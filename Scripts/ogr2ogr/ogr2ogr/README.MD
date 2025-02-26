# 🛠️ Ogr2Ogr: Geospatial Data Reprojection Tool

Ogr2Ogr is a Python script designed to handle the reprojection of geospatial data using the `ogr2ogr` utility. It allows users to specify source and target EPSG codes, input and output file paths, and executes the reprojection process.

## 📌 Features

✔️ Reprojects geospatial data from one coordinate system to another
✔️ Supports user-specified EPSG codes and file paths
✔️ Provides a command-line interface for user interaction
✔️ Generates a default output file name based on the target EPSG code and input file name

## 🚀 Installation & Usage

### 1️⃣ Save the Script

1. Save the `ogr2ogr.py` script to your local machine.

### 2️⃣ Run the Script

1. Open a terminal or command prompt.
2. Navigate to the directory where `ogr2ogr.py` is saved.
3. Run the script using Python:

```
python ogr2ogr.py
```

4. Follow the prompts to enter the necessary information:
   - Source and target EPSG codes
   - Input and output file paths

The script will:

- Construct the `ogr2ogr` command with the specified parameters.
- Execute the command to reproject the geospatial data.
- Save the output to the specified file path.

## 📂 Output File Naming

The script uses the target EPSG code and input file name to generate a default output file name if none is provided by the user.

## 📜 License

Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
> [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode)

## ✉️ Contact & Contributions

- Open an issue for bug reports or feature requests.
- Feel free to submit a pull request with improvements!
