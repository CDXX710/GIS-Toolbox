# 🛠️ DCleaner: QGIS Data Cleaning Process

**DCleaner** is a QGIS Processing script designed to **fix geometries** and **remove duplicate geometries** from vector layers. It supports multiple file formats and automatically saves outputs in the same format as the input. If the input is from a **GeoPackage (.gpkg)**, the cleaned layers will be saved inside the same GeoPackage.

---

## 📌 Features

✔️ **Fixes invalid geometries** using QGIS's `native:fixgeometries` tool  
✔️ **Removes duplicate geometries** with `native:deleteduplicategeometries`  
✔️ **Preserves the original format** (e.g., Shapefile, GeoJSON, GeoPackage, etc.)  
✔️ **Supports direct saving to GeoPackage layers** when the input is from a `.gpkg`  

---

## 🚀 Installation & Usage

### 1️⃣ Add the Script to QGIS
1. Open **QGIS**.
2. Go to **Processing Toolbox → Scripts → Create a New Script**.
3. Copy and paste the `DCleaner_Data_Cleaning_Process.py` script.
4. Save and close.

### 2️⃣ Run the Tool
1. Open the **Processing Toolbox** in QGIS.
2. Locate **"DCleaner: Data Cleaning Process"**.
3. Select an **input vector layer**.
4. Click **Run**.

The script will:
- Fix invalid geometries.
- Remove duplicate geometries.
- Save the cleaned layers **in the same location and format as the input**.

---

## 📂 Output File Naming
The script automatically assigns output names based on the input file:

| **Input Format** | **Fixed Output** | **Fixed + Clean Output** |
|-----------------|-----------------|---------------------------|
| `shapefile.shp` | `shapefile_fixed.shp` | `shapefile_fixed_cleaned.shp` |
| `data.geojson` | `data_fixed.geojson` | `data_fixed_cleaned.geojson` |
| `mydata.gpkg (layer: roads)` | `mydata.gpkg (layer: roads_fixed)` | `mydata.gpkg (layer: roads_fixed_cleaned)` |

---

## 📜 License
This script is **open-source**—feel free to **use, modify, and contribute**! If you find it useful, consider sharing your feedback or improvements. 🚀

---

## ✉️ Contact & Contributions
- Open an **issue** for bug reports or feature requests.
- Feel free to submit a **pull request** with improvements!

---
