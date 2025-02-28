# 🛠️ Ogr2Ogr: Geospatial Data Reprojection Tool

Ogr2Ogr is a Python script designed to facilitate the reprojection and conversion of geospatial data using the `ogr2ogr` utility. It allows users to specify source and target EPSG codes, input and output file paths, and executes the reprojection process seamlessly.

## 📌 Features

- ✔️ Reprojects geospatial data from one coordinate system to another
- ✔️ Supports user-specified EPSG codes and file paths
- ✔️ Provides an interactive command-line interface for user interaction
- ✔️ Generates a default output file name based on the target EPSG code and input file name
- ✔️ Easy to integrate into existing workflows
- ✔️ Supports multiple geospatial data formats
- ✔️ Auto-detects EPSG codes and geometry types
- ✔️ Handles multiple layers in GPKG files
- ✔️ Applies performance optimizations and error handling options
- ✔️ Allows filtering and selection of specific fields and features using SQL queries

## 🚀 Installation & Usage

### 1️⃣ Save the Script

1. Save the `ogr2ogr.py` script to your local machine.

### 2️⃣ Run the Script

1. Open a terminal or command prompt.
2. Navigate to the directory where `ogr2ogr.py` is saved.
3. Run the script using Python:

```bash
python ogr2ogr.py
```

4. Follow the prompts to enter the necessary information:
    - Source and target EPSG codes
    - Input and output file paths
    - Optional: Convert to another format, apply field selection, feature filtering, and performance options

The script will:

- Construct the `ogr2ogr` command with the specified parameters.
- Execute the command to reproject and convert the geospatial data.
- Save the output to the specified file path.

## 📂 Output File Naming

The script automatically generates a default output file name if none is provided by the user. The default name is based on the target EPSG code and the input file name.

## 📜 License

This project is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.

> CC BY-NC-SA 4.0

## ✉️ Contact & Contributions

- Open an issue for bug reports or feature requests.
- Feel free to submit a pull request with improvements!
