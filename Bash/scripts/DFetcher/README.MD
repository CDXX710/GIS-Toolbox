# 🌍 Data Fetching Script 📂

_This Bash script automates the creation of a directory structure based on INSEE codes and city names. It then downloads corresponding geospatial data files from the French government’s open data portal._

_It is totally possible to modify either the downloaded data set nor the data source as needed._

## ⚙️ Usage

### 📌 Prerequisites

- ✅ Ensure you have Bash installed (default on most Linux and macOS systems).
- ✅ Ensure you have an active internet connection for downloading files.
- ✅ Ensure `wget` is installed (available by default in most Linux/macOS distributions).

### ▶️ Running the Script

1. Copy the script into a file, e.g., `fetch_foncier_data.sh`.
2. Make the script executable:
   ```bash
   chmod +x fetch_foncier_data.sh
   ```
3. Run the script:
   ```bash
   ./fetch_foncier_data.sh
   ```

## 🔍 Script Functionality

- Defines two parallel arrays:
  - `code_insee`: Stores INSEE codes of various cities.
  - `city_name`: Stores corresponding city names.
- Creates a root folder named `foncier_communal`.
- Iterates through the arrays and for each city:
  1. Creates a subdirectory with the city name.
  2. Downloads the corresponding CSV data file from the `data.gouv.fr` portal.

## 📂 Example Output

After running the script, the following structure will be created:

```
foncier_communal/
├── Aussonne/
│   └── 31032.csv
├── Beauzelle/
│   └── 31056.csv
├── Blagnac/
│   └── 31069.csv
...
└── Tournefeuille/
    └── 31557.csv
```

## ✏️ Customization

- 🎯 Modify the `code_insee` and `city_name` arrays to add or remove locations.
- 🎯 Change the `wget` URL to point to a different dataset if needed.

## 🛠️ Notes

- 🌐 The script downloads data directly from the open-data portal, so ensure the URL is up-to-date.
- 🔄 Running the script multiple times will not overwrite existing folders but will ensure they exist.

## 📜 License

This script is provided under the MIT License. Feel free to modify and distribute as needed.

---
