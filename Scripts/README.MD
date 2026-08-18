# Scripts

Standalone automation scripts, grouped by language. Tool folders use
`kebab-case`; QGIS plugin folders (a different part of this repo) use
`snake_case` because QGIS requires it — that's the one naming split in
this repo, and it stops there.

## Bash

| Script | Requires | Description |
| --- | --- | --- |
| [`cascade-folders-builder`](Bash/cascade-folders-builder) | Bash | Creates a predefined set of nested directories from an array of names. |
| [`data-fetcher`](Bash/data-fetcher) | Bash, `wget` | Builds a directory structure from INSEE codes/city names and downloads matching geospatial data from data.gouv.fr. |

## Python

| Script | Requires | Description |
| --- | --- | --- |
| [`data-cleaner`](Python/data-cleaner) | QGIS (`qgis.core`, run as a Processing script) | Fixes invalid geometries and removes duplicate geometries from a vector layer, preserving the input format. |
| [`diff-py`](Python/diff-py) | Python stdlib (`difflib`) | Compares two files line by line and writes a difference report. |
| [`pdf-cropper`](Python/pdf-cropper) | Python, `PyPDF2` | Deletes specified pages from a PDF file. |
| [`gdal-info`](Python/gdal-info) | `gdalinfo` CLI on PATH | Runs `gdalinfo` on a file and optionally saves the result as JSON. |
| [`gdal-warp`](Python/gdal-warp) | `gdalwarp` CLI on PATH | Reprojects/transforms geospatial data, with optional cropping and SQL filtering. |
| [`ogr2ogr-reproject`](Python/ogr2ogr-reproject) | `ogr2ogr` CLI on PATH | Reprojects and converts geospatial data between EPSG codes and formats. |
| [`ogr-info`](Python/ogr-info) | `ogrinfo` CLI on PATH | Runs `ogrinfo` on a file and optionally exports the result as JSON. |

## SQL

| Script | Requires | Description |
| --- | --- | --- |
| [`data-checker`](SQL/data-checker) | PostgreSQL + PostGIS | Checks geometry validity, finds duplicate/empty geometries, and compares data between tables (with a completeness index). |
