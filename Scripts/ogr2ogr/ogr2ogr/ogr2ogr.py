import os
import subprocess
import sys


class Reprojector:
    """
    A class to handle the reprojection of geospatial data using ogr2ogr.
    """

    def __init__(self):
        """Initialize the Reprojector class."""
        pass

    def get_layer_name(self, input_path):
        """
        Get the layer name from the input file using ogrinfo.

        Args:
            input_path (str): Path to the input file.

        Returns:
            str: The layer name.
        """
        command = ["ogrinfo", "-ro", input_path]

        try:
            result = subprocess.run(command, capture_output=True, text=True, check=True)
            print("ogrinfo output:", result.stdout)  # Print the output for debugging
            # Parse the output to find the layer name
            lines = result.stdout.splitlines()
            for line in lines:
                if line.strip().startswith("1:"):
                    layer_name = line.split("(")[0].split(":")[-1].strip()
                    return layer_name
            print("No layer name found in the output.")
            return None
        except subprocess.CalledProcessError as e:
            print(f"An error occurred while running ogrinfo: {e}")
            print(f"Error output: {e.stderr}")
            return None
        except Exception as e:
            print(f"An unexpected error occurred: {e}")
            return None

    def reproject_file(self, s_epsg, t_epsg, input_path, output_path, sql_query=None):
        """
        Reproject a file from the source EPSG code to the target EPSG code using ogr2ogr.

        Args:
            s_epsg (str): Source EPSG code.
            t_epsg (str): Target EPSG code.
            input_path (str): Path to the input file.
            output_path (str): Path to save the output file.
            sql_query (str, optional): SQL query for attribute filtering.
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

        # Add the SQL query if provided
        if sql_query:
            command.extend(["-sql", sql_query])

        # Execute the ogr2ogr command
        try:
            subprocess.run(command, check=True)
            print(f"Reprojection successful. Output saved to {output_path}")
        except subprocess.CalledProcessError as e:
            print(f"An error occurred: {e}")

    def main(self):
        """
        Main function to execute the reprojection process.
        """
        # Prompt the user for the source EPSG code
        s_epsg = (
            input("Enter the source EPSG code (e.g., 4326): ")
            .encode("utf-8")
            .decode(sys.stdin.encoding)
        )

        # Prompt the user for the target EPSG code, with an option to use the source EPSG as default
        t_epsg = (
            input(
                f"Enter the target EPSG code (e.g., 2154) or press Enter to use '{s_epsg}': "
            )
            .encode("utf-8")
            .decode(sys.stdin.encoding)
        )

        # If no target EPSG code is provided, use the source EPSG code as the default
        if not t_epsg:
            t_epsg = s_epsg

        # Prompt the user for the input file path
        input_path = (
            input("Enter the path to the input file: ")
            .encode("utf-8")
            .decode(sys.stdin.encoding)
        )

        # Get the layer name from the input file
        layer_name = self.get_layer_name(input_path)
        if not layer_name:
            print("Could not retrieve the layer name. Exiting.")
            return

        # Extract the file name and extension from the input path
        input_file_name, input_file_extension = os.path.splitext(
            os.path.basename(input_path)
        )

        # Prompt the user for the output file path, with a default option
        output_path = (
            input(
                f"Enter output file name and format or press Enter to use '{t_epsg}_{input_file_name}{input_file_extension}': "
            )
            .encode("utf-8")
            .decode(sys.stdin.encoding)
        )

        # If no output path is provided, use the default
        if not output_path:
            output_path = f"{t_epsg}_{input_file_name}{input_file_extension}"

        # Prompt for attribute filtering
        do_attribute_filtering = (
            input("Do you want to apply an SQL query for attribute filtering? (y/n): ")
            .lower()
            .encode("utf-8")
            .decode(sys.stdin.encoding)
            == "y"
        )
        sql_query = None
        if do_attribute_filtering:
            where_clause = (
                input("Enter the SQL WHERE clause (e.g., 'WHERE dep = 42'): ")
                .encode("utf-8")
                .decode(sys.stdin.encoding)
            )
            sql_query = f"SELECT * FROM {layer_name} {where_clause}"

        # Reproject the file
        self.reproject_file(s_epsg, t_epsg, input_path, output_path, sql_query)


if __name__ == "__main__":
    reprojector = Reprojector()
    reprojector.main()
