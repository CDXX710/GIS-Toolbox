def classFactory(iface):
    from .single_group_visibility import SingleGroupVisibilityPlugin
    return SingleGroupVisibilityPlugin(iface)
