# Advanced Theme Switcher (QGIS plugin)

Minimal plugin, two responsibilities only:

1. A dockable **Theme Switcher** panel listing the project's Map Themes. Clicking a theme applies it exactly the way QGIS's own built-in Map Themes panel would (visibility, layer order, opacity, expanded/collapsed legend groups - unchanged).
2. Every time a theme is applied from this panel, the plugin sets a project expression variable named `current_theme` to that theme's name, via `QgsExpressionContextUtils.setProjectVariable()`. QGIS has no built-in variable for "the currently active theme," so this plugin adds one. From then on, `@current_theme` is readable in **any** expression anywhere in the project - symbology, labels, the field calculator, rule-based rendering, "Control feature rendering," etc.

Nothing else is included: no toolbar button, no per-layer style binding, no style matching. Style logic based on `@current_theme` is written by you directly in QGIS's own expression fields.

## Refreshing theme-dependent styling

`applyTheme()` only tells a layer to redraw when its checked/visible state changes between the old and new theme. A layer that stays visible in _every_ theme (e.g. layer C, styled entirely via `@current_theme` rather than by being toggled on/off per theme) never gets that signal on its own, so its style can look stale after a switch.

To handle this without flagging anything or touching every layer in the project, the plugin repaints every layer that belongs to the theme just applied (`QgsMapThemeCollection.mapThemeVisibleLayers()`), which naturally includes layer C every time. This is bounded by the theme's own layer list, not your whole project, so it stays cheap. A status-bar message after each switch shows how many layers were repainted, as a quick sanity check.

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

(Adjust to your actual relationship between C and A/B - spatial overlay, attribute join, etc. - the point is `@current_theme` is now available to gate that logic on the active theme.)

## Installation

1. Zip the `theme_switcher_panel` folder (already done if you received `theme_switcher_panel.zip`).
2. QGIS -> Plugins -> Manage and Install Plugins -> Install from ZIP, and point it at the zip file.
    - Or copy the `theme_switcher_panel` folder into your QGIS profile's `python/plugins` directory, then enable it from the Plugin Manager.
3. The **Theme Switcher** panel opens automatically when the plugin loads. Like any QGIS dock, it can also be shown/hidden from **View > Panels**.

## Catching the native "Manage Map Themes" button too

There's no public QGIS API for "a theme was applied via the native toolbar button" - not even `QgsMapCanvas.themeChanged`, which is known to not fire reliably for native theme-menu switches. So this plugin uses a different, more durable heuristic: it watches (globally, via a Qt event filter) for any menu popping up whose entries include one of your current theme names - which is exactly what QGIS's own theme-selector menu looks like - and hooks whichever theme you pick from it. QGIS's own handler applies the theme first as usual; this plugin's hook then runs right after to publish `@current_theme` and repaint.

This keys off your theme names (project data), not any internal QGIS widget/action name, so it should keep working across QGIS versions more reliably than hard-coding a private object path - but it's still a heuristic, not a documented API, so if a future QGIS version changes how that menu is built, this may need revisiting.

## Notes

-   Only clicking a theme _in this panel or in QGIS's native theme menu_ updates `@current_theme` (see above). Toggling layer checkboxes by hand won't.
-   The variable is stored in the project (via the QGIS expression context), so save the project (File -> Save Project) if you want the last-applied theme name to persist across a reload; otherwise it's simply re-set the next time you click a theme in the panel.
