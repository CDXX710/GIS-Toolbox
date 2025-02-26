import os
import subprocess
import json


class GdalInfoProcessor:
    """
    A class to process GDAL information from a file and optionally export the results to a JSON file.

    Attributes:
        input_path (str): The path to the input file.
    """

    def __init__(self, input_path: str):
        """
        Initialize the GdalInfoProcessor with the input file path.

        Args:
            input_path (str): The path to the input file.
        """
        self.input_path = input_path
        self.input_file_name, self.input_file_extension = os.path.splitext(
            os.path.basename(input_path)
        )

    def build_command(self) -> list:
        """
        Build the gdalinfo command with specified parameters.

        Returns:
            list: The command to be executed.
        """
        return ["ogrinfo", self.input_path, "-al", "-so"]

    def execute_command(self) -> str:
        """
        Execute the gdalinfo command and capture the output.

        Returns:
            str: The output of the command.

        Raises:
            subprocess.CalledProcessError: If the command execution fails.
        """
        command = self.build_command()
        try:
            result = subprocess.run(command, check=True, text=True, capture_output=True)
            return result.stdout
        except subprocess.CalledProcessError as e:
            raise RuntimeError(f"An error occurred while executing the command: {e}")

    def export_to_json(self, output: str):
        """
        Export the command output to a JSON file.

        Args:
            output (str): The output to be written to the JSON file.
        """
        output_json_path = f"{self.input_file_name}.json"
        with open(output_json_path, "w") as json_file:
            json.dump({"output": output}, json_file, indent=4)
        print(f"Results have been saved to {output_json_path}")


def main():
    """
    Main function to process GDAL information and optionally export the results to a JSON file.
    """
    input_path = input("Enter the path to the file: ")
    processor = GdalInfoProcessor(input_path)

    try:
        output = processor.execute_command()
        export_to_json = input(
            "Do you want to export the results to a JSON file? (y/n): "
        )

        if export_to_json.lower() == "y":
            processor.export_to_json(output)
        else:
            print(output)

    except RuntimeError as e:
        print(e)


if __name__ == "__main__":
    main()
