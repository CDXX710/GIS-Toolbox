import os
import subprocess


class GDALWarper:
    """
    A class to handle the reprojection and transformation of geospatial data using GDAL.
    """

    def __init__(self):
        """Initialize the GDALWarper class."""
        pass

    def get_epsg_code(self, prompt, default=None):
        """
        Prompt the user for an EPSG code and return it.

        Args:
            prompt (str): The input prompt message.
            default (str, optional): The default value to return if no input is provided.

        Returns:
            str: The EPSG code entered by the user or the default value.
        """
        code = input(prompt)
        return code if code else default

    def get_file_path(self, prompt, default=None):
        """
        Prompt the user for a file path and return it.

        Args:
            prompt (str): The input prompt message.
            default (str, optional): The default value to return if no input is provided.

        Returns:
            str: The file path entered by the user or the default value.
        """
        path = input(prompt)
        return path if path else default

    def build_gdalwarp_command(
        self, input_path, output_path, s_epsg, t_epsg, crop=False, sql_query=None
    ):
        """
        Build the gdalwarp command with the given parameters.

        Args:
            input_path (str): The path to the input file.
            output_path (str): The path to the output file.
            s_epsg (str): The source EPSG code.
            t_epsg (str): The target EPSG code.
            crop (bool, optional): Whether to crop the image.
            sql_query (str, optional): The SQL query to apply.

        Returns:
            list: The constructed gdalwarp command.
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

    def execute_command(self, command):
        """
        Execute the given command and handle errors.

        Args:
            command (list): The command to execute.
        """
        try:
            subprocess.run(command, check=True)
            print(f"Reprojection successful. Output saved to {command[-1]}")
        except subprocess.CalledProcessError as e:
            print(f"An error occurred: {e}")

    def main(self):
        """
        Main function to execute the GDAL warp process.
        """
        # Get EPSG codes
        s_epsg = self.get_epsg_code("Enter the source EPSG code (e.g. 4326): ")
        t_epsg = self.get_epsg_code(
            f"Enter the target EPSG code if needed (e.g. 2154) or press Enter to use '{s_epsg}': ",
            s_epsg,
        )

        # Get file paths
        input_path = self.get_file_path("Enter the path of the input file: ")
        input_file_name, input_file_extension = os.path.splitext(
            os.path.basename(input_path)
        )
        default_output_path = f"{t_epsg}_{input_file_name}{input_file_extension}"
        output_path = self.get_file_path(
            f"Enter output file name and format or press Enter to use '{default_output_path}': ",
            default_output_path,
        )

        # Get additional options
        bool_crop = input("Do you want to crop the image? (y/n): ") == "y"
        bool_sql = input("Do you want to use a SQL query? (y/n): ") == "y"
        sql_query = input("Enter the SQL query: ") if bool_sql else None

        # Build and execute the command
        command = self.build_gdalwarp_command(
            input_path, output_path, s_epsg, t_epsg, bool_crop, sql_query
        )
        self.execute_command(command)


if __name__ == "__main__":
    warper = GDALWarper()
    warper.main()
