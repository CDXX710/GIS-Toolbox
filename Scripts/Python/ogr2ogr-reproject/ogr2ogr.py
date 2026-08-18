import os
import subprocess
import sys
import re
import platform
import time

# Declare valid_formats as a constant outside of the main function
VALID_FORMATS = {
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

# ANSI escape codes for colors
GREY = "\033[90m"
CYAN = "\033[96m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
RED = "\033[91m"
BLUE = "\033[94m"
RESET = "\033[0m"


def get_layer_names(input_path):
    try:
        result = subprocess.run(
            ["ogrinfo", "-noextent", "-nogeomtype", input_path],
            capture_output=True,
            text=True,
            check=True,
        )
        lines = result.stdout.splitlines()
        layer_pattern = r"^\d+: (\w+)"
        layer_names = []
        for line in lines:
            match = re.search(layer_pattern, line)
            if match:
                layer_names.append(match.group(1))

        if not layer_names:
            raise ValueError(f"{RED}/!\\ Error: No layers found. /!\\ {RESET}")
        return layer_names
    except (subprocess.CalledProcessError, ValueError) as e:
        print(f"{RED}/!\\ Error: {e} /!\\ {RESET}")
        sys.exit(1)


def get_epsg_code(input_path, layer_name):
    try:
        result = subprocess.run(
            ["ogrinfo", "-al", "-so", input_path, layer_name],
            capture_output=True,
            text=True,
            check=True,
        )
        lines = result.stdout.splitlines()[::-1]
        epsg_pattern = r'ID\["EPSG",(\d+)\]\]'
        for line in lines:
            match = re.search(epsg_pattern, line)
            if match:
                return match.group(1)
        raise ValueError(f"{RED}/!\\ Error: No EPSG code found. /!\\ {RESET}")
    except (subprocess.CalledProcessError, ValueError) as e:
        print(f"{RED}/!\\ Error: {e} /!\\ {RESET}")
        sys.exit(1)


def get_geometry_type(input_path, layer_name):
    try:
        result = subprocess.run(
            ["ogrinfo", "-al", "-so", input_path, layer_name],
            capture_output=True,
            text=True,
            check=True,
        )
        geom_pattern = r"Geometry: (\w+)"
        match = re.search(geom_pattern, result.stdout)
        if match:
            geometry_type = match.group(1)
            if geometry_type.lower() == "unknown":
                raise ValueError(
                    f"{RED}/!\\ Error: Unknown geometry type. /!\\ {RESET}"
                )
            return geometry_type
        raise ValueError(f"/!\\ Error: No geometry type found. /!\\ {RESET}")
    except (subprocess.CalledProcessError, ValueError) as e:
        print(f"{RED}/!\\ Error: {e} /!\\ {RESET}")
        sys.exit(1)


def clear_console():
    # For Windows
    if platform.system() == "Windows":
        os.system("cls")
    # For Unix-like systems
    else:
        os.system("clear")


def print_loading_bar(iteration, total, length=50):
    percent = ("{0:.1f}").format(100 * (iteration / float(total)))
    filled_length = int(length * iteration // total)
    bar = "█" * filled_length + "-" * (length - filled_length)
    # Move the cursor up to center the loading bar
    if iteration == 0:
        print("\n" * 14)
    print(f"\r|{bar}| {percent}% Complete", end="\r")
    if iteration == total:
        print()
        clear_console()


def main():
    # Clear the terminal
    clear_console()

    # Print loading bar
    total_steps = 100
    for i in range(total_steps + 1):
        print_loading_bar(i, total_steps)
        time.sleep(0.005)

    # Center the welcome message vertically
    print("\n" * 10)
    # Center the welcome message horizontally
    print(f"{BLUE}{' ' * 15}---------------------------------------------{RESET}")
    print(f"{BLUE}{' ' * 15}| Welcome to the OGR2OGR Conversion Script! |{RESET}")
    print(f"{BLUE}{' ' * 15}|-------------------------------------------|{RESET}")
    print(f"{BLUE}{' ' * 15}|    Purpose:                               |{RESET}")
    print(f"{BLUE}{' ' * 15}|    - Convert geospatial data formats      |{RESET}")
    print(f"{BLUE}{' ' * 15}|    - Reproject geospatial data            |{RESET}")
    print(f"{BLUE}{' ' * 15}|    - Filter and select specific fields    |{RESET}")
    print(f"{BLUE}{' ' * 15}|    - Apply SQL queries to data            |{RESET}")
    print(f"{BLUE}{' ' * 15}|    - Manage large datasets efficiently    |{RESET}")
    print(f"{BLUE}{' ' * 15}|-------------------------------------------|{RESET}")
    print(f"{BLUE}{' ' * 15}|    Capabilities:                          |{RESET}")
    print(f"{BLUE}{' ' * 15}|    - Supports multiple formats            |{RESET}")
    print(f"{BLUE}{' ' * 15}|    - Auto-detect EPSG codes               |{RESET}")
    print(f"{BLUE}{' ' * 15}|    - Handle multiple layers in GPKG       |{RESET}")
    print(f"{BLUE}{' ' * 15}|    - Apply performance optimizations      |{RESET}")
    print(f"{BLUE}{' ' * 15}---------------------------------------------{RESET}")
    print("\n" * 4)
    if input(f"{' ' * 24}Press Enter to start..") == "":
        clear_console()
        print(f"{GREY}-------------------------------------------{RESET}")
        print(f"{GREY}| Windows path e.g.:     .\\data\\file.gpkg |{RESET}")
        print(f"{GREY}| Linux path e.g.:     ./data/file.gpkg   |{RESET}")
        print(f"{GREY}-------------------------------------------{RESET}")
        input_path = input("->  Enter input file path:    ")
        input_file_name, input_file_extension = os.path.splitext(
            os.path.basename(input_path)
        )
        if not os.path.exists(input_path):
            raise ValueError(
                f"{RED}/!\\ Error: The file '{input_path}' does not exist. /!\\{RESET}"
            )

        layer_name = None
        if input_file_extension == ".gpkg":
            layer_names = get_layer_names(input_path)
            if len(layer_names) == 1:
                layer_name = layer_names[0]
                log_info = f"| Defaulting to unique layer found: '{layer_name}' |"
                log_dash = "-" * len(log_info)
                print(f"{GREEN}{log_dash}{RESET}")
                print(f"{GREEN}{log_info}{RESET}")
                print(f"{GREEN}{log_dash}{RESET}")
            else:
                warning_info = f"| /!\\ Warning: Multiple layers detected: /!\\ |"
                warning_dash = "-" * len(warning_info)
                print(f"{YELLOW}{warning_dash}{RESET}")
                print(f"{YELLOW}{warning_info}{RESET}")
                print(f"{YELLOW}{warning_dash}{RESET}")
                layer_names_str = ", ".join(layer_names)
                padding = (len(warning_dash) - len(layer_names_str) - 2) // 2
                print(
                    f"{YELLOW}|{RESET}{' ' * padding}{layer_names_str}{' ' * padding}{YELLOW}|{RESET}"
                )
                print(f"{YELLOW}{warning_dash}{RESET}")
                print(f"->  Enter target layer name ")
                layer_name = input(
                    f"{CYAN}  ->  Press Enter to use '{layer_names[0]}':    {RESET}"
                )
                if not layer_name:
                    layer_name = layer_names[0]
                log_info = f"| Selected layer: '{layer_name}' |"
                log_dash = "-" * len(log_info)
                print(f"{GREEN}{log_dash}{RESET}")
                print(f"{GREEN}{log_info}{RESET}")
                print(f"{GREEN}{log_dash}{RESET}")
        print(f"{GREY}-----------------------------{RESET}")
        print(f"{GREY}| EPSG code e.g.:      2154 |{RESET}")
        print(f"{GREY}-----------------------------{RESET}")
        print("->   Enter source EPSG code")
        s_epsg = input(f"{CYAN}  ->  (Press Enter to auto-detect):    {RESET}")
        if not s_epsg:
            s_epsg = get_epsg_code(input_path, layer_name)
            log_info = f"| Detected EPSG Code: {s_epsg} |"
            log_dash = "-" * len(log_info)
            print(f"{GREEN}{log_dash}{RESET}")
            print(f"{GREEN}{log_info}{RESET}")
            print(f"{GREEN}{log_dash}{RESET}")
        log_info = f"| Selected EPSG Code: {s_epsg} |"
        log_dash = "-" * len(log_info)
        print(f"{GREEN}{log_dash}{RESET}")
        print(f"{GREEN}{log_info}{RESET}")
        print(f"{GREEN}{log_dash}{RESET}")

        print("->   Enter output EPSG code")
        t_epsg = input(f"{CYAN}  ->   (Press Enter to use '{s_epsg}'):    {RESET}")
        if not t_epsg:
            t_epsg = s_epsg
        log_info = f"| Output EPSG: '{t_epsg}' |"
        log_dash = "-" * len(log_info)
        print(f"{GREEN}{log_dash}{RESET}")
        print(f"{GREEN}{log_info}{RESET}")
        print(f"{GREEN}{log_dash}{RESET}")

        output_format = VALID_FORMATS.get(input_file_extension)
        output_extension = input_file_extension
        print("->  Convert to another format? (y/n)")
        if input(f"{CYAN}  ->  (Press Enter to skip):    {RESET}").lower() == "y":
            print(f"{GREY}-----------------------------------{RESET}")
            print(f"{GREY}| {'Extension':<10}    {'Format Name':<17} |{RESET}")
            print(f"{GREY}{'-' * 35}{RESET}")
            for ext, format_name in VALID_FORMATS.items():
                print(f"{GREY}| {ext:<10} {format_name:<20} |{RESET}")
            print(f"{GREY}-----------------------------------{RESET}")
            output_extension = input("->  Enter the output extension: ")
            output_format = VALID_FORMATS.get(output_extension)
            if not output_format:
                raise ValueError(
                    f"{RED}/!\\ Error: Invalid format selected. /!\\ {RESET}"
                )
            log_info = f"| Selected format: {output_format} |"
            log_dash = "-" * len(log_info)
            print(f"{GREEN}{log_dash}{RESET}")
            print(f"{GREEN}{log_info}{RESET}")
            print(f"{GREEN}{log_dash}{RESET}")

        else:
            log_info = f"| Selected format: {output_format} |"
            log_dash = "-" * len(log_info)
            print(f"{GREEN}{log_dash}{RESET}")
            print(f"{GREEN}{log_info}{RESET}")
            print(f"{GREEN}{log_dash}{RESET}")

        print("->  Enter the output path")
        output_path = input(
            f"{CYAN}  ->  (Press Enter to use './{input_file_name}{output_extension}':)    {RESET}"
        )
        if not output_path:
            output_path = f"{input_file_name}{output_extension}"

        overwrite, append, update = True, False, False
        if os.path.exists(output_path):
            warning_info = f"| /!\\ Warning: File already exists: /!\\ |"
            warning_dash = "-" * len(warning_info)
            print(f"{YELLOW}{warning_dash}{RESET}")
            print(f"{YELLOW}{warning_info}{RESET}")
            print(f"{YELLOW}{warning_dash}{RESET}")
            print("->  Update (u), Append (a) or Overwrite (o)?")
            file_exists = input(
                f"{CYAN}  ->  Press Enter to Overwrite:    {RESET}"
            ).lower()
            if file_exists == "u":
                update = True
                overwrite = False
            elif file_exists == "a":
                append = True
                overwrite = False

        out_layer_name = None
        geometry_type = None
        if output_extension == ".gpkg":
            warning_info = f"| /!\\ Warning: Formats requires output layer name. /!\\ |"
            warning_dash = "-" * len(warning_info)
            print(f"{YELLOW}{warning_dash}{RESET}")
            print(f"{YELLOW}{warning_info}{RESET}")
            print(f"{YELLOW}{warning_dash}{RESET}")
            print("->  Enter output layer name")
            out_layer_name = input(
                f"{CYAN}  ->  (Press Enter to use '{input_file_name}_{t_epsg}'):    {RESET}"
            )
            if not out_layer_name:
                out_layer_name = f"{input_file_name}_{t_epsg}"
            geometry_type = get_geometry_type(input_path, layer_name)
            log_info = f"| Detected Geometry type: '{geometry_type}' |"
            log_dash = "-" * len(log_info)
            print(f"{GREEN}{log_dash}{RESET}")
            print(f"{GREEN}{log_info}{RESET}")
            print(f"{GREEN}{log_dash}{RESET}")

        select_fields = None
        new_fields = None
        print("Apply specific field(s) selection ? (y/n)")
        if input(f"{CYAN}  ->  (Press Enter to select all):    {RESET}").lower() == "y":
            print(f"{GREY}-------------------------------------------{RESET}")
            print(f"{GREY}| Single select e.g.:    name             |{RESET}")
            print(f"{GREY}| Multiselect e.g.:      id,name,phone    |{RESET}")
            print(f"{GREY}-------------------------------------------{RESET}")
            print("->  Enter fields to select from the input layer")
            select_fields = input(f"{CYAN}  ->  (Press Enter to skip):    {RESET}")
            print(f"{GREY}-----------------------------------------------{RESET}")
            print(f"{GREY}| Single field addition e.g.:  name           |{RESET}")
            print(f"{GREY}| Multi field addition e.g.:   id,name,phone  |{RESET}")
            print(f"{GREY}-----------------------------------------------{RESET}")
            print("->  Enter new field(s) to add")
            new_fields = input(f"{CYAN}  ->  (Press Enter to skip):    {RESET}")

        where_clause = None
        sql_statement = None
        print("->  Apply feature(s) filtering ? (y/n)")
        if input(f"{CYAN}  ->  Press Enter to skip:    {RESET}").lower() == "y":
            print(f"{GREY}--------------------------------------------{RESET}")
            print(f"{GREY}| SQL WHERE clause e.g.:  name LIKE '%42'  |{RESET}")
            print(f"{GREY}--------------------------------------------{RESET}")
            print("->  Enter a SQL WHERE clause to filter features")
            where_clause = input(f"{CYAN}  ->  Press Enter to continue:    {RESET}")
            print(f"{GREY}-------------------------------------------{RESET}")
            print(f"{GREY}| SQL statement e.g.:  SELECT * FROM ...  |{RESET}")
            print(f"{GREY}-------------------------------------------{RESET}")
            print("->  Enter SQL statement")
            sql_statement = input(f"{CYAN}  ->  (Press Enter to continue):    {RESET}")

        skip_failures = False
        geometry_threshold = None
        print("->  Access performance options ? (y/n)")
        if input(f"{CYAN}  ->  (Press Enter to skip):    {RESET}").lower() == "y":
            print("->  Continue processing if feature(s) fails ? (y/n)")
            skip_failures = (
                input(f"{CYAN}  ->  (Press Enter to continue):    {RESET}").lower()
                == "y"
            )
            print(f"{GREY}-------------------------------{RESET}")
            print(f"{GREY}| Geometry treshold e.g.:  34 |{RESET}")
            print(f"{GREY}-------------------------------{RESET}")
            print("->  Maximum amount of points in a geometry")
            geometry_threshold = input(
                f"{CYAN}  ->  (Press Enter to continue):    {RESET}"
            )

        command = [
            "ogr2ogr",
            "-s_srs",
            f"EPSG:{s_epsg}",
            "-t_srs",
            f"EPSG:{t_epsg}",
            output_path,
            input_path,
            "-progress",
        ]

        if output_format:
            command.extend(["-f", output_format])
        if where_clause:
            command.extend(["-where", where_clause])
        if sql_statement:
            command.extend(["-sql", sql_statement])
        if out_layer_name:
            command.extend(["-nln", out_layer_name])
        if skip_failures:
            command.append("-skipfailures")
        if geometry_threshold:
            command.extend(["-gt", geometry_threshold])
        if select_fields:
            command.extend(["-select", select_fields])
        if new_fields:
            command.extend(["-addfields", new_fields])
        if geometry_type:
            command.extend(["-nlt", geometry_type])
        if overwrite:
            command.append("-overwrite")
        if append:
            command.append("-append")
        if update:
            command.append("-update")

        subprocess.run(command)


if __name__ == "__main__":
    main()
