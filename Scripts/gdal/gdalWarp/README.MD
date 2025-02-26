# 🛠️ GDALWarp: GDAL Reprojection and Transformation Tool

GDALWarp is a Python script designed to handle the reprojection and transformation of geospatial data using GDAL. It allows users to specify input and output file paths, EPSG codes, and additional options such as cropping and SQL queries.

## 📌 Features

✔️ Reprojects geospatial data from one coordinate system to another
✔️ Supports cropping of the output image
✔️ Allows the application of SQL queries during the transformation process
✔️ Provides a command-line interface for user interaction
✔️ Supports user-specified file paths and EPSG codes

## 🚀 Installation & Usage

### 1️⃣ Save the Script

1. Save the `gdalWarp.py` script to your local machine.

### 2️⃣ Run the Script

1. Open a terminal or command prompt.
2. Navigate to the directory where `gdalWarp.py` is saved.
3. Run the script using Python:

```
python gdalWarp.py
```

4. Follow the prompts to enter the necessary information:
   - Source and target EPSG codes
   - Input and output file paths
   - Whether to crop the image
   - Whether to apply a SQL query

The script will:

- Build the `gdalwarp` command with the specified parameters.
- Execute the command to reproject and transform the geospatial data.
- Save the output to the specified file path.

## 📂 Output File Naming

The script uses the target EPSG code and input file name to generate a default output file name if none is provided by the user.

## 📜 License

Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
> [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode)

## ✉️ Contact & Contributions

- Open an issue for bug reports or feature requests.
- Feel free to submit a pull request with improvements!
