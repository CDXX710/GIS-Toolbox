import os
import subprocess
import sys
import re


def main():
    # Prompt the user for input layer
    input_path = input("Enter the input layer path: ")

    # Extract the name and extension from the input path
    input_file_name, input_file_extension = os.path.splitext(
        os.path.basename(input_path)
    )

    # Prompt the user for the source EPSG code if known or extract it from the input layer
    s_epsg = input(
        "Enter the source EPSG code (e.g., 4326) or press Enter to auto-detect: "
    )
    if not s_epsg:
        try:
            result = subprocess.run(
                ["ogrinfo", "-al", "-so", input_path],
                capture_output=True,
                text=True,
                check=True,
            )

            # Split the output into lines and reverse the list to search from the bottom
            lines = result.stdout.splitlines()[::-1]

            # Use regular expression to find the first EPSG code from the bottom
            epsg_pattern = r'ID\["EPSG",(\d+)\]\]'
            for line in lines:
                match = re.search(epsg_pattern, line)
                if match:
                    s_epsg = match.group(1)
                    break
            else:
                raise ValueError("No EPSG code found in the output.")

        except (subprocess.CalledProcessError, ValueError) as e:
            print(f"Error: {e}")
            sys.exit(1)

    print(f"Detected EPSG Code: {s_epsg}")

    # Prompt the user if they want to reproject to a different EPSG code
    t_epsg = input(
        f"Enter the target EPSG code (e.g., 2154) or press Enter to use '{s_epsg}': "
    )

    # If no target EPSG code is provided, use the source EPSG code as the default
    if not t_epsg:
        t_epsg = s_epsg

    # Prompt the user if they want to convert the input format to another format
    if (
        input(
            "Do you want to convert the input to another format? (y/n) or press Enter to skip: "
        ).lower()
        == "y"
    ):
        valid_formats = {
            ".shp": "ESRI Shapefile",
            ".gpkg": "GPKG",
            ".geojson": "GeoJSON",
            ".csv": "CSV",
            ".pgsql": "PostgreSQL/PostGIS",
            ".sqlite": "SQLite/SpatiaLite",
            ".tab": "MapInfo File",
            ".pdf": "PDF",
            ".kml": "KML",
            ".gml": "GML",
            ".gpx": "GPX",
            ".dgn": "DGN",
            ".pix": "PCIDSK",
            ".nc": "netCDF",
            ".bna": "BNA",
            ".000": "S57",
            ".mem": "Memory",
            ".ili": "Interlis 1 and 2",
            ".gmt": "OGR_GMT",
            ".odbc": "ODBC",
            ".map": "WAsP",
        }
        print("Available formats:")
        for ext, format_name in valid_formats.items():
            print(f"{ext}: {format_name}")

        output_extension = input(
            "Enter the extension corresponding to the output format (e.g., .shp): "
        )
        output_format = valid_formats.get(output_extension)
        if not output_format:
            print("Invalid format selected.")
            sys.exit(1)
        else:
            print(f"Selected format: {output_format}")
    else:
        output_format = None
        output_extension = input_file_extension

    output_path = input(
        f"Enter the output path or press Enter to use './{t_epsg}_{input_file_name}{output_extension}': "
    )
    if not output_path:
        output_path = f"{t_epsg}_{input_file_name}{output_extension}"

    # Check if the output file exists
    if os.path.exists(output_path):
        # Prompt the user if they want to overwrite, append or update the output file if it exists
        file_exists = input(
            "It seems the file already exists, do you want to update it or append to it? (u/a) or press Enter to overwrite): "
        ).lower()

        # Default to overwrite if no input is provided
        if file_exists == "u":
            overwrite = False
            append = False
            update = True
        elif file_exists == "a":
            overwrite = False
            append = True
            update = False
        else:
            # Default case: overwrite
            overwrite = True
            append = False
            update = False

    # Prompt the user for layer name when outputting to a format that supports them
    if output_format in ["MapInfo File", "GPKG", "PostgreSQL"]:
        layer_name = input(
            f"Enter the name of the output layer (-nln) or press Enter to use {input_file_name}: "
        )
        if not layer_name:
            layer_name = input_file_name
    # Initialize variables with default values
    where_clause = None
    sql_statement = None
    layer_name = None
    skip_failures = False
    geometry_threshold = None
    select_fields = None
    new_fields = None
    overwrite = False
    append = False
    update = False

    # Prompt the user for field modifications
    field_modifications = (
        input("Do you want to modify fields? (y/n) or press Enter to skip: ").lower()
        == "y"
    )
    if field_modifications:
        # Prompt the user for specific fields to select from the input layer
        select_fields = input(
            "Enter fields to select from the input layer (field1, field2..) or press Enter to continue: "
        )
        # Prompt the user for the fields to add
        new_fields = input(
            "Enter new fields to add (field1:type, field2:type..) or press Enter to continue: "
        )

    # Prompt the user for data selection options
    selection_options = (
        input(
            "Do you want to apply features filtering ? (y/n) or press Enter to skip: "
        )
        == "y"
    )

    if selection_options:
        # Prompt the user for a SQL WHERE clause to filter features
        where_clause = input(
            "Enter a SQL WHERE clause to filter features (e.g. code_insee='300120') or press Enter to continue: "
        )
        # Prompt the user for an SQL statement to filter features
        sql_statement = input(
            "Enter an SQL statement to execute (e.g. SELECT * FROM ...) or press Enter to continue: "
        )

    # Prompt the user if they want to set performance options
    performance_options = (
        input(
            "Do you want to set performance options? (y/n) or press Enter to skip: "
        ).lower()
        == "y"
    )
    if performance_options:
        # If User answers 'y' to the question, the following options will be prompted
        skip_failures = (
            input(
                "Continue processing even if a feature fails to convert? (y/n) or press Enter to continue: "
            ).lower()
            == "y"
        )
        geometry_threshold = input(
            "Enter the maximum threshold for the number of points in a geometry (e.g. 24) or press Enter to continue: "
        )

    # Construct the ogr2ogr command
    command = [
        "ogr2ogr",
        "-s_srs",
        f"EPSG:{s_epsg}",
        "-t_srs",
        f"EPSG:{t_epsg}",
        f"{output_path}",
        f"{input_path}",
        "-progress",
    ]

    if output_format:
        command.extend(["-f", output_format])
    if where_clause:
        command.append(f"-where {where_clause}")
    if sql_statement:
        command.append(f"-sql {sql_statement}")
    if layer_name:
        command.append(f"-nln {layer_name}")
    if skip_failures:
        command.append("-skipfailures")
    if geometry_threshold:
        command.append(f"-gt {geometry_threshold}")
    if select_fields:
        command.append(f"-select")
        command.extend(select_fields.split())
    if new_fields:
        command.append(f"-addfields {new_fields}")
    if overwrite == True:
        command.append("-overwrite")
    if append == True:
        command.append("-append")
    if update == True:
        command.append("-update")

    # Execute the command
    subprocess.run(command)


if __name__ == "__main__":
    main()
