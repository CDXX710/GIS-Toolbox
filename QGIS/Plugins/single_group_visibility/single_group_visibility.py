import os

from qgis.core import QgsProject
from qgis.PyQt.QtWidgets import QAction
from qgis.PyQt.QtCore import QObject
from qgis.PyQt.QtGui import QIcon

PLUGIN_DIR = os.path.dirname(__file__)
ICON_ON = QIcon(os.path.join(PLUGIN_DIR, "icons", "icon_on.svg"))
ICON_OFF = QIcon(os.path.join(PLUGIN_DIR, "icons", "icon_off.svg"))

class SingleGroupVisibilityPlugin(QObject):
    """
    Keeps at most one top-level layer tree group visible at a time.
    Turning a group's checkbox ON automatically turns all other
    top-level groups OFF.
    """

    def __init__(self, iface):
        super().__init__()
        self.iface = iface
        self.root = QgsProject.instance().layerTreeRoot()
        self._updating = False
        self._enabled = True
        self.action = None

    def initGui(self):
        self.action = QAction(ICON_ON, "Single Group Visibility: Enabled", self.iface.mainWindow())
        self.action.setCheckable(True)
        self.action.setChecked(True)
        self.action.toggled.connect(self._on_toggle_enabled)
        self.iface.addPluginToMenu("Single Group Visibility", self.action)
        self.iface.addToolBarIcon(self.action)

        self.root.visibilityChanged.connect(self.enforce_single_group_visibility)

    def unload(self):
        try:
            self.root.visibilityChanged.disconnect(self.enforce_single_group_visibility)
        except (TypeError, RuntimeError):
            pass
        if self.action is not None:
            self.iface.removePluginMenu("Single Group Visibility", self.action)
            self.iface.removeToolBarIcon(self.action)

    def _on_toggle_enabled(self, checked):
        self._enabled = checked
        self.action.setIcon(ICON_ON if checked else ICON_OFF)
        label = "Enabled" if checked else "Disabled"
        self.action.setText(f"Single Group Visibility: {label}")

    def enforce_single_group_visibility(self, node):
        if not self._enabled or self._updating:
            return

        # Top-level groups only (nodeType() == 0 means group, 1 means layer)
        groups = [child for child in self.root.children() if child.nodeType() == 0]

        # Only react when a top-level group was just turned ON
        if node not in groups or not node.itemVisibilityChecked():
            return

        self._updating = True
        try:
            for g in groups:
                if g is not node and g.itemVisibilityChecked():
                    g.setItemVisibilityChecked(False)
        finally:
            self._updating = False
