import os
import subprocess


def get_epsg_code(prompt, default=None):
    """
    Prompt the user for an EPSG code and return it.
    """
    code = input(prompt)
    return code if code else default


def get_file_path(prompt, default=None):
    """
    Prompt the user for a file path and return it.
    """
    path = input(prompt)
    return path if path else default


def build_gdalwarp_command(
    input_path, output_path, s_epsg, t_epsg, crop=False, sql_query=None
):
    """
    Build the gdalwarp command with the given parameters.
    """
    command = [
        "gdalwarp",
        "-s_srs",
        f"EPSG:{s_epsg}",
        "-t_srs",
        f"EPSG:{t_epsg}",
        "-dstalpha",
        input_path,
        output_path,
    ]

    if crop:
        cutline_path = input("Enter the path to the cutline file: ")
        command.extend(["-cutline", cutline_path, "-crop_to_cutline"])

    if sql_query:
        command.extend(["-csql", sql_query])

    return command


def execute_command(command):
    """Execute the given command and handle errors."""
    try:
        subprocess.run(command, check=True)
        print(f"Reprojection successful. Output saved to {command[-1]}")
    except subprocess.CalledProcessError as e:
        print(f"An error occurred: {e}")


def main():
    # Get EPSG codes
    s_epsg = get_epsg_code("Enter the source EPSG code (e.g. 4326): ")
    t_epsg = get_epsg_code(
        f"Enter the target EPSG code if needed (e.g. 2154) or press Enter to use '{s_epsg}': ",
        s_epsg,
    )

    # Get file paths
    input_path = get_file_path("Enter the path of the input file: ")
    input_file_name, input_file_extension = os.path.splitext(
        os.path.basename(input_path)
    )
    default_output_path = f"{t_epsg}_{input_file_name}{input_file_extension}"
    output_path = get_file_path(
        f"Enter output file name and format or press Enter to use '{default_output_path}': ",
        default_output_path,
    )

    # Get additional options
    bool_crop = input("Do you want to crop the image? (y/n): ").lower() == "y"
    bool_sql = input("Do you want to use a SQL query? (y/n): ").lower() == "y"
    sql_query = input("Enter the SQL query: ") if bool_sql else None

    # Build and execute the command
    command = build_gdalwarp_command(
        input_path, output_path, s_epsg, t_epsg, bool_crop, sql_query
    )
    execute_command(command)


if __name__ == "__main__":
    main()
