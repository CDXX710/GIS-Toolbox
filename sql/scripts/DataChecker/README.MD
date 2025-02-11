# 🛠️ Geometric and Data Integrity Checks in SQL

This SQL script performs various geometric and data integrity checks on a spatial dataset. It identifies and locates invalid geometries, detects duplicate geometries, finds empty surfaces, and compares data between tables to determine inconsistencies. Additionally, it calculates a completeness index for data validation.

---

## 📌 Features

### 1️⃣ Identify and Locate Invalid Geometries

- **View Creation:** `wrong_geom`
- Uses `ST_IsValid(geom)` to check validity.
- Uses `ST_IsValidReason(geom)` to provide a justification.
- Uses `LOCATION(st_isvaliddetail(geom))` to pinpoint the invalid geometry location.
- Example Query:
  ```sql
  SELECT * FROM wrong_geom;
  ```

### 2️⃣ Detect Duplicate Geometries

- Uses `ROW_NUMBER() OVER (PARTITION BY ST_asbinary(geom))` to identify duplicates.
- Keeps only unique geometries.
- Example Query:
  ```sql
  WITH unique_geom (id, geom) AS (
      SELECT ROW_NUMBER() OVER (PARTITION BY ST_asbinary(geom)) AS id, geom
      FROM [TABLE_NAME]
  )
  SELECT geom FROM unique_geom WHERE id <> 1;
  ```

### 3️⃣ Identify Empty Surfaces

- Uses `ST_Area(geom) = 0` to find geometries with no area.
- Example Query:
  ```sql
  SELECT * FROM [TABLE_NAME] WHERE ST_Area(geom) = 0;
  ```

### 4️⃣ Compare Differences Between Tables

- Uses `EXCEPT` to find values in `[TABLE_NAME]` not present in `[REF_TABLE_NAME]`.
- Example Query:
  ```sql
  SELECT typezone, 'not in [REF_TABLE_NAME]' AS note FROM [TABLE_NAME]
  EXCEPT
  SELECT typezone, 'not in [TABLE_NAME]' AS note FROM [REF_TABLE_NAME];
  ```

### 5️⃣ Bidirectional Table Comparison

- Uses `EXCEPT` and `UNION` to list differences in both directions.
- Example Query:
  ```sql
  SELECT libelle AS typezone, 'not in [REF_TABLE_NAME]' AS comparison FROM [TABLE_NAME]
  EXCEPT
  SELECT libelle AS typezone, 'not in [REF_TABLE_NAME]' AS comparison FROM [REF_TABLE_NAME]
  UNION
  SELECT libelle AS typezone, 'not in [TABLE_NAME]' AS comparison FROM [REF_TABLE_NAME]
  EXCEPT
  SELECT libelle AS typezone, 'not in [TABLE_NAME]' AS comparison FROM [TABLE_NAME];
  ```

### 6️⃣ Calculate Completeness Index

- Computes the completeness index using the formula:
  ```
  X = 1 - (nb_exceed + nb_omission) / nb_ref
  ```
- Uses a `FULL JOIN` to compare data.
- Example Query:
  ```sql
  WITH comparison AS (
      SELECT CASE
          WHEN REF IS NULL THEN 'EXCEEDING'
          WHEN DATA IS NULL THEN 'OMISSION'
          ELSE 'OK'
      END AS statut, *
      FROM [TABLE_NAME] DATA
      FULL JOIN [REF_TABLE_NAME] REF ON REF.libelle = DATA.libelle
  )
  SELECT nb_exceed.value AS "Exceeding", nb_omission.value AS "Omission",
         nb_ref.value AS "Reference Value",
         1 - (nb_exceed.value + nb_omission.value)::NUMERIC / nb_ref.value AS "Completeness Index"
  FROM (SELECT COUNT(*) AS value FROM [REF_TABLE_NAME]) nb_ref
  CROSS JOIN (SELECT COUNT(*) AS value FROM comparison WHERE statut = 'EXCEEDING') AS nb_exceed
  CROSS JOIN (SELECT COUNT(*) AS value FROM comparison WHERE statut = 'OMISSION') AS nb_omission;
  ```

---

## 🔑 Usage

1. Run the SQL file in a database that supports PostGIS.
2. Ensure that the tables `[TABLE_NAME]` and `[REF_TABLE_NAME]` exist before execution.
3. Modify table names and column names as necessary to align with your dataset.

---

## ✔️ Dependencies

- PostgreSQL with PostGIS extension enabled.

---

## 📜 License

This project is open-source. Feel free to use and modify it as needed.

