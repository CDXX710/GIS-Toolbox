# Advanced Theme Switcher (QGIS Plugin)

A QGIS plugin with two responsibilities only: a dockable panel for applying Map Themes, and a project expression variable, `@current_theme`, that always reflects whichever theme is currently active.

Useful when your styling, labeling, or rendering rules need to know which Map Theme is active — something QGIS has no built-in expression variable for.

## Features

- Dockable **Theme Switcher** panel listing the project's Map Themes. Clicking a theme applies it exactly the way QGIS's own built-in Map Themes panel would (visibility, layer order, opacity, expanded/collapsed legend groups — unchanged)
- Sets a project expression variable, `current_theme`, to the applied theme's name via `QgsExpressionContextUtils.setProjectVariable()`. From then on, `@current_theme` is readable in **any** expression anywhere in the project — symbology, labels, the field calculator, rule-based rendering, "Control feature rendering," etc.
- Also catches theme switches made through QGIS's own native "Manage Map Themes" toolbar button, not just this panel (see [below](#catching-the-native-manage-map-themes-button-too))
- Repaints every layer belonging to the newly applied theme, so styling driven by `@current_theme` never looks stale after a switch (see [below](#refreshing-theme-dependent-styling))
- Lightweight: no toolbar button, no per-layer style binding, no style matching. Style logic based on `@current_theme` is written by you directly in QGIS's own expression fields

## Installation

### From ZIP
1. Download the latest `advanced_theme_switcher.zip` from [Releases](https://github.com/CDXX710/GIS-Toolbox/releases) or this repo.
2. In QGIS: **Plugins → Manage and Install Plugins → Install from ZIP**.
3. Select the downloaded ZIP file and click **Install Plugin**.
4. Enable **Advanced Theme Switcher** in the plugin list if it isn't already active.

### Manual install
1. Clone or download this repo.
2. Copy the `advanced_theme_switcher` folder into your QGIS plugins directory:
   - **Windows:** `C:\Users\<user>\AppData\Roaming\QGIS\QGIS3\profiles\default\python\plugins\`
   - **macOS:** `~/Library/Application Support/QGIS/QGIS3/profiles/default/python/plugins/`
   - **Linux:** `~/.local/share/QGIS/QGIS3/profiles/default/python/plugins/`
3. Restart QGIS and enable the plugin via **Plugins → Manage and Install Plugins → Installed**.

## Usage

Once enabled, the **Theme Switcher** panel opens automatically. Like any QGIS dock, it can also be shown or hidden from **View → Panels**.

Click a theme in the panel to apply it. Only clicking a theme _in this panel or in QGIS's native theme menu_ updates `@current_theme` — toggling layer checkboxes by hand won't.

The variable is stored in the project (via the QGIS expression context), so save the project (**File → Save Project**) if you want the last-applied theme name to persist across a reload; otherwise it's simply re-set the next time you click a theme.

## Refreshing theme-dependent styling

`applyTheme()` only tells a layer to redraw when its checked/visible state changes between the old and new theme. A layer that stays visible in _every_ theme (e.g. a layer styled entirely via `@current_theme` rather than by being toggled on/off per theme) never gets that signal on its own, so its style can look stale after a switch.

To handle this without flagging anything or touching every layer in the project, the plugin repaints every layer that belongs to the theme just applied (`QgsMapThemeCollection.mapThemeVisibleLayers()`), which naturally includes that layer every time. This is bounded by the theme's own layer list, not your whole project, so it stays cheap. A status-bar message after each switch shows how many layers were repainted, as a quick sanity check.

## Catching the native "Manage Map Themes" button too

There's no public QGIS API for "a theme was applied via the native toolbar button" — not even `QgsMapCanvas.themeChanged`, which is known to not fire reliably for native theme-menu switches. So this plugin uses a different, more durable heuristic: it watches (globally, via a Qt event filter) for any menu popping up whose entries include one of your current theme names — which is exactly what QGIS's own theme-selector menu looks like — and hooks whichever theme you pick from it. QGIS's own handler applies the theme first as usual; this plugin's hook then runs right after to publish `@current_theme` and repaint.

This keys off your theme names (project data), not any internal QGIS widget/action name, so it should keep working across QGIS versions more reliably than hard-coding a private object path — but it's still a heuristic, not a documented API, so if a future QGIS version changes how that menu is built, this may need revisiting.

## Example: style layer C based on layers A and B's presence

If layer C should render differently depending on whether features exist in layers A and B for the currently active theme, you can combine `@current_theme` with `aggregate()` (or a join) in layer C's own styling expression, e.g. as a rule-based renderer rule or a data-defined override:

```sql
if(@current_theme = 'Historical',
   count(
     overlay_intersects('layer_a', $geometry)
   ) > 0
   or
   count(
     overlay_intersects('layer_b', $geometry)
   ) > 0,
   true)
```

(Adjust to your actual relationship between C and A/B — spatial overlay, attribute join, etc. — the point is `@current_theme` is now available to gate that logic on the active theme.)

## Requirements

- QGIS 3.16+

## License

BY-NC-SA 4.0

## Contributing

Issues and pull requests welcome.
