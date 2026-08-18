# 🗺️ GIS Toolbox 🛠️

***A collection of homemade, customized, and saved GIS tools and tutorials to streamline geospatial workflows.***

---

## 📌 About This Repository
This repository serves as a hub for all the QGIS and GIS-related tools I've developed, customized, or saved over time. Whether it's Python scripts, QGIS plugins, or handy automation tools, you'll find useful resources to enhance spatial data management, analysis, and visualization.

I created this collection to improve efficiency in GIS tasks, automate repetitive processes, and explore different ways to extend QGIS functionality. Feel free to explore, use, and contribute!

## 🚀 What's Inside?
This repo includes:
- ✅ QGIS Plugins – Custom PyQGIS plugins that extend QGIS's UI and behavior
- ✅ QGIS Styles – Color ramps and marker symbol sets
- ✅ Geoprocessing & Data Cleaning Tools – Scripts and models for fixing geometries, removing duplicates, and more
- ✅ Automation Scripts – Bash, Python, and SQL tools to streamline spatial workflows
- ✅ Other GIS Utilities – Various scripts and resources for GIS analysis

## 🗂️ Repository Layout

```
GIS-Toolbox/
├── QGIS/           QGIS-specific content — see QGIS/README.MD
│   ├── Plugins/           installable QGIS plugins (snake_case, required by QGIS)
│   ├── Processing-Models/ QGIS Model Builder workflows (reserved, currently empty)
│   ├── Splash-Screen/     splash screen customization guide
│   └── Styles/            color ramps and marker symbol sets
└── Scripts/        standalone scripts, grouped by language — see Scripts/README.MD
    ├── Bash/
    ├── Python/
    └── SQL/
```

Every tool lives in its own folder with a `README.MD` covering installation,
usage, and license. `QGIS/README.MD` and `Scripts/README.MD` each index their
subfolders — start there to browse what's available before digging into the
tables below.

**Naming convention:** script tool folders under `Scripts/` use `kebab-case`.
QGIS plugin folders under `QGIS/Plugins/` use `snake_case`, because QGIS
loads each plugin folder as a Python package and requires it.

## 🧰 Tool Index

### QGIS Plugins
| Tool | Description |
| --- | --- |
| [advanced_theme_switcher](QGIS/Plugins/advanced_theme_switcher) | Dockable Map Themes panel; exposes the active theme as `@current_theme` in expressions. |
| [single_group_visibility](QGIS/Plugins/single_group_visibility) | Keeps only one top-level layer tree group visible at a time. |

### QGIS Styles
| Tool | Description |
| --- | --- |
| [Color-Ramps/ArcGIS_Random_Colors](QGIS/Styles/Color-Ramps/ArcGIS_Random_Colors) | Randomized, visually distinct color ramp. |
| [Markers/QGIS_Markers_Bundle](QGIS/Styles/Markers/QGIS_Markers_Bundle) | Full Temaki + Mapbox Maki icon collections. |
| [Markers/WarGames_Neons_Markers](QGIS/Styles/Markers/WarGames_Neons_Markers) | Neon-glow 1980s-inspired marker symbols. |

### Bash Scripts
| Tool | Description |
| --- | --- |
| [cascade-folders-builder](Scripts/Bash/cascade-folders-builder) | Creates a predefined set of nested directories. |
| [data-fetcher](Scripts/Bash/data-fetcher) | Downloads geospatial data by INSEE code from data.gouv.fr. |

### Python Scripts
| Tool | Description |
| --- | --- |
| [data-cleaner](Scripts/Python/data-cleaner) | Fixes invalid geometries and removes duplicates (QGIS Processing script). |
| [diff-py](Scripts/Python/diff-py) | Compares two files and generates a difference report. |
| [pdf-cropper](Scripts/Python/pdf-cropper) | Deletes specified pages from a PDF file. |
| [gdal-info](Scripts/Python/gdal-info) | Runs `gdalinfo` and optionally saves the result as JSON. |
| [gdal-warp](Scripts/Python/gdal-warp) | Reprojects/transforms geospatial data via `gdalwarp`. |
| [ogr2ogr-reproject](Scripts/Python/ogr2ogr-reproject) | Reprojects and converts geospatial data via `ogr2ogr`. |
| [ogr-info](Scripts/Python/ogr-info) | Runs `ogrinfo` and optionally exports the result as JSON. |

### SQL Scripts
| Tool | Description |
| --- | --- |
| [data-checker](Scripts/SQL/data-checker) | Geometry validity, duplicate, and cross-table data integrity checks (PostGIS). |

## 🔧 Installation & Usage
```
Download or Clone the Repository/Files needed
```

### Bash
```bash
git clone https://github.com/CDXX710/GIS-Toolbox.git
```
### QGIS - Plugins
```
Plugins → Manage and Install Plugins → Install from ZIP (or copy the plugin
folder into your QGIS profile's python/plugins directory)
```
### QGIS - Processing Scripts
```
Open QGIS and go to Processing Toolbox

Click on Scripts → Create a New Script

Copy and paste the script, save, and run it
```
### Standalone Python
```
Ensure you have the script's dependencies installed (see each tool's
README.MD — some need QGIS's qgis.core, others just the GDAL/OGR CLI
tools on PATH, others are pure stdlib)
```

## 📜 License
This repository is open-source, so feel free to use, modify, and contribute. If you improve or extend any tools, I'd love to see your contributions!

## ✉️ Contact
Have suggestions or need help? Feel free to open an issue or reach out!

---
