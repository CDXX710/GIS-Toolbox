# Geometric and Data Integrity Checks in SQL

---

## Overview

This SQL script performs various geometric and data integrity checks on a spatial dataset. It identifies and locates invalid geometries, detects duplicate geometries, finds empty surfaces, and compares data between tables to determine inconsistencies. Additionally, it calculates a completeness index for data validation.

---

## Features

---

### 1. Identify and Locate Invalid Geometries

- **View Creation:** `wrong_geom`
- Uses `ST_IsValid(geom)` to check validity.
- Uses `ST_IsValidReason(geom)` to provide a justification.
- Uses `LOCATION(st_isvaliddetail(geom))` to pinpoint the invalid geometry location.
- Example Query:
  ```sql
  SELECT * FROM wrong_geom;
  ```

### 2. Detect Duplicate Geometries

- Uses `ROW_NUMBER() OVER (PARTITION BY ST_asbinary(geom))` to identify duplicates.
- Keeps only unique geometries.
- Example Query:
  ```sql
  WITH unique_geom (id, geom) AS (
      SELECT ROW_NUMBER() OVER (PARTITION BY ST_asbinary(geom)) AS id, geom
      FROM pertuis_mauvais
  )
  SELECT geom FROM unique_geom WHERE id <> 1;
  ```

### 3. Identify Empty Surfaces

- Uses `ST_Area(geom) = 0` to find geometries with no area.
- Example Query:
  ```sql
  SELECT * FROM pertuis_mauvais WHERE ST_Area(geom) = 0;
  ```

### 4. Compare Differences Between Tables

- Uses `EXCEPT` to find values in `pertuis_mauvais` not present in `zone_urba`.
- Example Query:
  ```sql
  SELECT typezone, 'not in zone_urba_ref' AS note FROM pertuis_mauvais
  EXCEPT
  SELECT typezone, 'not in pertuis_mauvais' AS note FROM zone_urba;
  ```

### 5. Bidirectional Table Comparison

- Uses `EXCEPT` and `UNION` to list differences in both directions.
- Example Query:
  ```sql
  SELECT libelle AS typezone, 'not in zone_urba_ref' AS comparison FROM pertuis_mauvais
  EXCEPT
  SELECT libelle AS typezone, 'not in zone_urba_ref' AS comparison FROM zone_urba
  UNION
  SELECT libelle AS typezone, 'not in pertuis_mauvais' AS comparison FROM zone_urba
  EXCEPT
  SELECT libelle AS typezone, 'not in pertuis_mauvais' AS comparison FROM pertuis_mauvais;
  ```

### 6. Calculate Completeness Index

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
      FROM pertuis_mauvais DATA
      FULL JOIN zone_urba REF ON REF.libelle = DATA.libelle
  )
  SELECT nb_exceed.value AS "Exceeding", nb_omission.value AS "Omission",
         nb_ref.value AS "Reference Value",
         1 - (nb_exceed.value + nb_omission.value)::NUMERIC / nb_ref.value AS "Completeness Index"
  FROM (SELECT COUNT(*) AS value FROM zone_urba) nb_ref
  CROSS JOIN (SELECT COUNT(*) AS value FROM comparison WHERE statut = 'EXCEEDING') AS nb_exceed
  CROSS JOIN (SELECT COUNT(*) AS value FROM comparison WHERE statut = 'OMISSION') AS nb_omission;
  ```

---

## Usage

1. Run the SQL file in a database that supports PostGIS.
2. Ensure that the tables `pertuis_mauvais` and `zone_urba` exist before execution.
3. Modify table names and column names as necessary to align with your dataset.

---

## Dependencies

- PostgreSQL with PostGIS extension enabled.

---

## License

This project is open-source. Feel free to use and modify it as needed.

