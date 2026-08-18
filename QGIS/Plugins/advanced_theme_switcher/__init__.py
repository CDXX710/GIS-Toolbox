# -*- coding: utf-8 -*-
"""Advanced Theme Switcher - QGIS plugin entry point."""


def classFactory(iface):
    from .advanced_theme_switcher import AdvancedThemeSwitcherPlugin
    return AdvancedThemeSwitcherPlugin(iface)
