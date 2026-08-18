# QGIS

Plugins, processing models, styles, and interface customization for QGIS.

## Plugins

Folder names are `snake_case` because QGIS loads each plugin folder as a
Python package — this naming is required, not a style choice.

| Plugin | Description |
| --- | --- |
| [`advanced_theme_switcher`](Plugins/advanced_theme_switcher) | Dockable panel to apply Map Themes and expose the active theme as the `@current_theme` expression variable everywhere in the project. |
| [`single_group_visibility`](Plugins/single_group_visibility) | Keeps only one top-level layer tree group visible at a time (radio-button style). |

## Processing Models

[`Processing-Models/`](Processing-Models) — reserved for QGIS Model Builder
(`.model3`) workflows. Empty for now.

## Styles

| Style | Type | Description |
| --- | --- | --- |
| [`Color-Ramps/ArcGIS_Random_Colors`](Styles/Color-Ramps/ArcGIS_Random_Colors) | Color ramp | Randomized, visually distinct colors for quick thematic mapping. |
| [`Markers/QGIS_Markers_Bundle`](Styles/Markers/QGIS_Markers_Bundle) | Marker set | Full Temaki + Mapbox Maki icon collections packaged as a QGIS symbol library. |
| [`Markers/WarGames_Neons_Markers`](Styles/Markers/WarGames_Neons_Markers) | Marker set | Neon-glow, 1980s-inspired marker symbols for dark map backgrounds. |

## Splash Screen

[`Splash-Screen/`](Splash-Screen) — guide to customizing the QGIS splash
screen via `QGISCUSTOMIZATION3.ini`.
