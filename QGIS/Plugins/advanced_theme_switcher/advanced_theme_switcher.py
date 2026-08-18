# -*- coding: utf-8 -*-
"""
Advanced Theme Switcher
======================

Minimal plugin with exactly two responsibilities:

1. A dockable "Theme Switcher" panel listing the project's Map Themes.
   Clicking a theme applies it the normal way, via QGIS's own
   QgsMapThemeCollection.applyTheme() - so standard theme behaviour
   (layer visibility, order, opacity, expanded/collapsed legend groups)
   is untouched.

2. Every time a theme is applied through this panel, the plugin sets a
   project-level expression variable, `current_theme`, to that theme's
   name via QgsExpressionContextUtils.setProjectVariable(). That makes
   the active theme's name readable as `@current_theme` in ANY expression
   anywhere in the project (symbology, labels, field calculator, rule-based
   rendering, "Control feature rendering", etc.) - QGIS has no built-in
   variable for this, so the plugin provides one.

Refreshing only what needs it
------------------------------
QGIS caches each layer's rendered image and only redraws a layer when
something explicitly invalidates that layer's cache. applyTheme() only
does that for layers whose checked/visible state actually changes between
the old and new theme - a layer that stays visible in both (e.g. one whose
styling depends on @current_theme rather than on its own visibility, and
so is deliberately left checked-on in every theme) is never told anything
happened, and keeps showing a stale cached image.

Rather than force-redrawing every layer in the whole project (expensive on
large projects), or relying on manual per-layer flags, this plugin simply
repaints every layer that belongs to the theme just applied - a small,
bounded set defined by QGIS itself (QgsMapThemeCollection.
mapThemeVisibleLayers()), not the full project layer list. That
automatically covers a layer like this on every theme switch, with no
per-layer setup required.

Nothing else: no toolbar button, no style matching/binding logic. The
dock is shown when the plugin loads and, like any QGIS dock widget, can
also be toggled from View > Panels.

Also catching the native "Manage Map Themes" button
-----------------------------------------------------
QGIS has no public signal for "a theme was applied via the native Manage
Map Themes toolbar button" - and QgsMapCanvas.theme()/themeChanged aren't
reliably updated by it either (a long-standing QGIS bug: native theme
switches go through the layer tree directly, bypassing that). So instead
of chasing a private, version-fragile widget name, this plugin installs a
global event filter that watches for any QMenu being shown whose actions
include one of the project's current theme names - which is exactly what
QGIS's native theme-selector menu looks like when opened. When the user
clicks a theme name in that menu, QGIS's own handler applies it first (as
normal), and immediately afterwards this plugin's handler runs and
publishes @current_theme + repaints, the same as if it had been clicked in
this plugin's own panel. This is still a heuristic (it doesn't hook a
documented API), but it doesn't depend on internal object names/paths that
change between QGIS versions - only on theme names matching, which is
project data, not QGIS internals.
"""

import os

from qgis.PyQt.QtCore import Qt, QEvent, QObject
from qgis.PyQt.QtGui import QIcon
from qgis.PyQt.QtWidgets import (
    QApplication,
    QDockWidget,
    QMenu,
    QWidget,
    QVBoxLayout,
    QHBoxLayout,
    QListWidget,
    QListWidgetItem,
    QPushButton,
    QLabel,
)
from qgis.core import Qgis, QgsProject, QgsExpressionContextUtils

PLUGIN_NAME = "Advanced Theme Switcher"
VARIABLE_NAME = "current_theme"


class AdvancedThemeSwitcherPlugin:
    """QGIS plugin object."""

    def __init__(self, iface):
        self.iface = iface
        self.dock = None
        self.native_watcher = None

    def initGui(self):
        self.dock = ThemeSwitcherDock(
            apply_theme_callback=self.apply_theme,
            parent=self.iface.mainWindow(),
        )
        icon_path = os.path.join(os.path.dirname(__file__), "icons", "icon.svg")
        self.dock.setWindowIcon(QIcon(icon_path))
        self.iface.addDockWidget(Qt.RightDockWidgetArea, self.dock)

        # Also catch theme switches made via QGIS's native theme menu (see
        # module docstring for how/why).
        self.native_watcher = NativeThemeMenuWatcher(
            on_theme_selected=self.publish_theme,
            parent=self.iface.mainWindow(),
        )
        QApplication.instance().installEventFilter(self.native_watcher)

    def unload(self):
        if self.native_watcher:
            QApplication.instance().removeEventFilter(self.native_watcher)
            self.native_watcher.deleteLater()
            self.native_watcher = None
        if self.dock:
            self.iface.removeDockWidget(self.dock)
            self.dock.deleteLater()
            self.dock = None

    def apply_theme(self, theme_name):
        """Apply a map theme the normal way (used by this plugin's own
        panel), then publish it via publish_theme()."""
        project = QgsProject.instance()
        collection = project.mapThemeCollection()

        if theme_name not in collection.mapThemes():
            return

        # Normal theme behaviour: visibility, order, opacity, expanded
        # legend state, etc. - exactly what QGIS's own panel does.
        collection.applyTheme(
            theme_name,
            project.layerTreeRoot(),
            self.iface.layerTreeView().layerTreeModel(),
        )

        self.publish_theme(theme_name)

    def publish_theme(self, theme_name):
        """Publish @current_theme and repaint that theme's layers. Used
        both after this plugin applies a theme itself, and after QGIS's
        native theme menu applies one on its own."""
        project = QgsProject.instance()
        collection = project.mapThemeCollection()

        if theme_name not in collection.mapThemes():
            return

        QgsExpressionContextUtils.setProjectVariable(project, VARIABLE_NAME, theme_name)

        # Repaint every layer that belongs to this theme. applyTheme()
        # only invalidates a layer's cached render when its checked state
        # actually changes between the old and new theme - a layer that
        # stays visible in both (e.g. because it's styled by
        # @current_theme rather than by its own visibility) is otherwise
        # never told to redraw. This stays cheap: it's bounded by the
        # theme's own layer list, not the whole project.
        theme_layers = collection.mapThemeVisibleLayers(theme_name)
        for layer in theme_layers:
            layer.triggerRepaint()

        self.iface.messageBar().pushMessage(
            PLUGIN_NAME,
            "Applied theme \"{}\". Repainted {} layer(s).".format(
                theme_name, len(theme_layers)
            ),
            level=Qgis.Info,
            duration=3,
        )


class NativeThemeMenuWatcher(QObject):
    """Global event filter that detects QGIS's own native theme-selector
    menu (identified by its actions matching current theme names, not by
    any internal widget name) and hooks the theme the user picks from it.
    """

    def __init__(self, on_theme_selected, parent=None):
        super().__init__(parent)
        self._on_theme_selected = on_theme_selected
        self._hooked_menus = set()

    def eventFilter(self, obj, event):
        if event.type() == QEvent.Show and isinstance(obj, QMenu):
            theme_names = set(QgsProject.instance().mapThemeCollection().mapThemes())
            if theme_names:
                action_texts = {a.text().replace("&", "") for a in obj.actions()}
                if theme_names & action_texts:
                    menu_key = id(obj)
                    if menu_key not in self._hooked_menus:
                        obj.triggered.connect(self._on_menu_action_triggered)
                        obj.destroyed.connect(
                            lambda: self._hooked_menus.discard(menu_key)
                        )
                        self._hooked_menus.add(menu_key)
        return False

    def _on_menu_action_triggered(self, action):
        theme_name = action.text().replace("&", "")
        if theme_name in QgsProject.instance().mapThemeCollection().mapThemes():
            # QGIS's own handler (connected first, when the action was
            # created) has already applied the theme by the time this
            # runs - we only need to publish/repaint.
            self._on_theme_selected(theme_name)


class ThemeSwitcherDock(QDockWidget):
    """Lists the project's Map Themes; clicking one applies it."""

    def __init__(self, apply_theme_callback, parent=None):
        super().__init__("Theme Switcher", parent)
        self._apply_theme_callback = apply_theme_callback

        container = QWidget()
        layout = QVBoxLayout(container)

        layout.addWidget(QLabel("Map Themes (click to apply):"))

        self.list_widget = QListWidget()
        self.list_widget.itemClicked.connect(self._on_theme_clicked)
        layout.addWidget(self.list_widget)

        btn_row = QHBoxLayout()
        self.refresh_btn = QPushButton("Refresh themes")
        self.refresh_btn.clicked.connect(self.refresh_theme_list)
        btn_row.addWidget(self.refresh_btn)
        layout.addLayout(btn_row)

        container.setLayout(layout)
        self.setWidget(container)

        QgsProject.instance().mapThemeCollection().mapThemesChanged.connect(
            self.refresh_theme_list
        )

        self.refresh_theme_list()

    def refresh_theme_list(self):
        self.list_widget.clear()
        themes = sorted(QgsProject.instance().mapThemeCollection().mapThemes())
        for theme_name in themes:
            self.list_widget.addItem(QListWidgetItem(theme_name))

    def _on_theme_clicked(self, item):
        self._apply_theme_callback(item.text())
