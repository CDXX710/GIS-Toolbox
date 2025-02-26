import os
import subprocess


def reproject_file(s_epsg, t_epsg, input_path, output_path):
    """
    Reproject a file from the source EPSG code to the target EPSG code using ogr2ogr.

    :param s_epsg: Source EPSG code
    :param t_epsg: Target EPSG code
    :param input_path: Path to the input file
    :param output_path: Path to save the output file
    """
    # Construct the ogr2ogr command
    command = [
        "ogr2ogr",
        "-s_srs",
        f"EPSG:{s_epsg}",
        "-t_srs",
        f"EPSG:{t_epsg}",
        output_path,
        input_path,
    ]

    # Execute the ogr2ogr command
    try:
        subprocess.run(command, check=True)
        print(f"Reprojection successful. Output saved to {output_path}")
    except subprocess.CalledProcessError as e:
        print(f"An error occurred: {e}")


def main():
    # Prompt the user for the source EPSG code
    s_epsg = input("Enter the source EPSG code (e.g., 4326): ")

    # Prompt the user for the target EPSG code, with an option to use the source EPSG as default
    t_epsg = input(
        f"Enter the target EPSG code (e.g., 2154) or press Enter to use '{s_epsg}': "
    )

    # If no target EPSG code is provided, use the source EPSG code as the default
    if not t_epsg:
        t_epsg = s_epsg

    # Prompt the user for the input file path
    input_path = input("Enter the path to the input file: ")

    # Extract the file name and extension from the input path
    input_file_name, input_file_extension = os.path.splitext(
        os.path.basename(input_path)
    )

    # Prompt the user for the output file path, with a default option
    output_path = input(
        f"Enter output file name and format or press Enter to use '{t_epsg}_{input_file_name}{input_file_extension}': "
    )

    # If no output path is provided, use the default output path
    if not output_path:
        output_path = f"{t_epsg}_{input_file_name}{input_file_extension}"

    # Reproject the file
    reproject_file(s_epsg, t_epsg, input_path, output_path)


if __name__ == "__main__":
    main()
