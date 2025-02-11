# 📂 Cascade Folder Building Script 🚀

_This is a simple Bash script that creates a predefined set of nested directories in the current working directory. It iterates over an array of values and generates folder structures accordingly._

---

## ⚙️ Usage

### 📌 Prerequisites

- ✅ Ensure you have Bash installed (default on most Linux and macOS systems).
- ✅ Ensure you have the necessary permissions to create directories in the target location.

### ▶️ Running the Script

1. Copy the script into a file, e.g., `create_folders.sh`.
2. Make the script executable:
   ```bash
   chmod +x create_folders.sh
   ```
3. Run the script:
   ```bash
   ./create_folders.sh
   ```

## 🔍 Script Functionality

- Defines an array (`array`) containing values: `Value1`, `Value2`, and `Value3`.
- Iterates through each value and creates the following directory structure:
  ```
  ValueX/
  ├── Subfolder1/
  │   └── SubSubfolder/
  ├── Subfolder2/
      └── SubSubfolder/
  ```
  where `ValueX` corresponds to each value in the array (`Value1`, `Value2`, etc.).

## 📂 Example Output

After running the script, the following directories will be created:

```
./Value1/Subfolder1/SubSubfolder
./Value1/Subfolder2/SubSubfolder
./Value2/Subfolder1/SubSubfolder
./Value2/Subfolder2/SubSubfolder
./Value3/Subfolder1/SubSubfolder
./Value3/Subfolder2/SubSubfolder
```

## ✏️ Customization

- 🎯 Modify the `array` variable in the script to include or remove values as needed.
- 🎯 Adjust the folder structure by modifying the `mkdir -p` command inside the loop.

## 🛠️ Notes

- 🏗️ The `-p` option in `mkdir` ensures that parent directories are created as needed and prevents errors if they already exist.
- 🔄 Running the script multiple times will not overwrite existing folders but will ensure they exist.

## 📜 License

Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
> [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode)

## ✉️ Contact & Contributions

- Open an **issue** for bug reports or feature requests.
- Feel free to submit a **pull request** with improvements!

---
