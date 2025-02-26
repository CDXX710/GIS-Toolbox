# 🛠️ GdalInfo: GDAL Information Extractor

GdalInfo is a Python script designed to extract and process GDAL information from a specified file. It allows users to execute the `gdalinfo` command and optionally save the results as a JSON file.

## 📌 Features

✔️ Executes the `gdalinfo` command on a specified file
✔️ Optionally saves the output as a JSON file
✔️ Provides a command-line interface for user interaction
✔️ Supports user-specified file paths

## 🚀 Installation & Usage

### 1️⃣ Save the Script

1. Save the `gdalInfo.py` script to your local machine.

### 2️⃣ Run the Script

1. Open a terminal or command prompt.
2. Navigate to the directory where `gdalInfo.py` is saved.
3. Run the script using Python:

```
python gdalInfo.py
```

4. Follow the prompts to enter the path of the file to process and specify whether to save the results as JSON.

The script will:

- Execute the `gdalinfo` command on the specified file.
- Optionally save the output to a JSON file if specified.
- Print the output to the console if not saving as JSON.

## 📂 Output File Naming

The script saves the output to a JSON file named after the input file (without extension) if the user chooses to save the results as JSON.

## 📜 License

Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International

> CC BY-NC-SA 4.0

## ✉️ Contact & Contributions

- Open an issue for bug reports or feature requests.
- Feel free to submit a pull request with improvements!
