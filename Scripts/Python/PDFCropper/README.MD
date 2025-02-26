# 🛠️ PDFCropper: PDF Page Deleter

PDFCropper is a Python script designed to delete specified pages from a PDF file. It prompts the user for the input PDF file, the pages to delete, and the output file path. The script uses the `PyPDF2` library to manipulate the PDF files.

## 📌 Features

✔️ Deletes specified pages from a PDF file
✔️ Supports user-specified input and output file paths
✔️ Allows specifying pages to delete in a flexible format (e.g., `1,3,5-10`)
✔️ Automatically generates a default output file path if none is provided

## 🚀 Installation & Usage

### 1️⃣ Save the Script

1. Save the `PDFCropper.py` script to your local machine.

### 2️⃣ Run the Script

1. Open a terminal or command prompt.
2. Navigate to the directory where `PDFCropper.py` is saved.
3. Run the script using Python:

   ```sh
   python PDFCropper.py
   ```

4. Follow the prompts to enter the path of the input PDF file, the pages to delete, and the output file path.

The script will:

- Read the input PDF file.
- Delete the specified pages.
- Save the modified PDF to the specified output file path.

## 📂 Output File Naming

The script prompts the user for the output file path. If no path is provided, it defaults to the input file name with `-crop` appended before the file extension (e.g., `input.pdf` becomes `input-crop.pdf`).

## 📜 License

Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International

> CC BY-NC-SA 4.0

## ✉️ Contact & Contributions

- Open an issue for bug reports or feature requests.
- Feel free to submit a pull request with improvements!
