# Single Group Visibility

A QGIS plugin that keeps only one top-level layer tree group visible at a time — radio-button style. Turning a group's visibility checkbox ON automatically turns all other top-level groups OFF.

Useful when you have several mutually-exclusive groups (e.g. different scenarios, time periods, or basemaps) and want to make sure only one is ever shown on the canvas.

## Features

- Enforces single-group visibility across **top-level groups** in the layer tree
- Toggle button in the toolbar / plugin menu to enable or disable the enforcement without uninstalling
- No effect on nested groups or individual layers — only top-level groups are managed
- Lightweight, no external dependencies

## Installation

### From ZIP
1. Download the latest `single_group_visibility.zip` from [Releases](https://github.com/CDXX710/GIS-Toolbox/releases) or this repo.
2. In QGIS: **Plugins → Manage and Install Plugins → Install from ZIP**.
3. Select the downloaded ZIP file and click **Install Plugin**.
4. Enable **Single Group Visibility** in the plugin list if it isn't already active.

### Manual install
1. Clone or download this repo.
2. Copy the `single_group_visibility` folder into your QGIS plugins directory:
   - **Windows:** `C:\Users\<user>\AppData\Roaming\QGIS\QGIS3\profiles\default\python\plugins\`
   - **macOS:** `~/Library/Application Support/QGIS/QGIS3/profiles/default/python/plugins/`
   - **Linux:** `~/.local/share/QGIS/QGIS3/profiles/default/python/plugins/`
3. Restart QGIS and enable the plugin via **Plugins → Manage and Install Plugins → Installed**.

## Usage

Once enabled, the plugin works automatically in the background. Check a top-level group's visibility box and any other visible top-level groups will be unchecked.

A toolbar/menu button labeled **Single Group Visibility: Enabled** lets you pause the behavior (e.g. if you temporarily need multiple groups visible) without disabling the whole plugin.

## How it works

The plugin connects to the layer tree root's `visibilityChanged` signal. When a top-level group is checked, it iterates over sibling top-level groups and unchecks any that are currently visible. A re-entrancy guard prevents the resulting signal emissions from causing recursive loops.

Only groups are affected — visibility changes are checked via `nodeType() == 0` (group) vs `1` (layer), and `itemVisibilityChecked()` is used rather than `isVisible()` to avoid ambiguity from QGIS's tri-state (checked / unchecked / partially checked) visibility model.

## Requirements

- QGIS 3.0+

## License

BY-NC-SA 4.0

## Contributing

Issues and pull requests welcome.
