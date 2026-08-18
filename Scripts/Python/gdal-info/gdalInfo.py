import os
import subprocess


class GdalInfoProcessor:
    """
    A class to process GDAL information from a file and optionally save the results as JSON.

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
        self.input_file_name, _ = os.path.splitext(os.path.basename(input_path))

    def build_command(self, save_as_json: bool = False) -> list:
        """
        Build the gdalinfo command with specified parameters.

        Args:
            save_as_json (bool): Whether to save the output as JSON.

        Returns:
            list: The command to be executed.
        """
        command = ["gdalinfo", self.input_path]
        if save_as_json:
            command.append("-json")
        return command

    def execute_command(self, save_as_json: bool = False) -> str:
        """
        Execute the gdalinfo command and capture the output.

        Args:
            save_as_json (bool): Whether to save the output as JSON.

        Returns:
            str: The output of the command.

        Raises:
            subprocess.CalledProcessError: If the command execution fails.
        """
        command = self.build_command(save_as_json)
        try:
            result = subprocess.run(
                command, check=True, stdout=subprocess.PIPE, text=True
            )
            return result.stdout
        except subprocess.CalledProcessError as e:
            raise RuntimeError(f"An error occurred while executing the command: {e}")

    def save_output(self, output: str):
        """
        Save the command output to a JSON file.

        Args:
            output (str): The output to be written to the JSON file.
        """
        output_path = f"{self.input_file_name}.json"
        with open(output_path, "w") as output_file:
            output_file.write(output)
        print(f"Saved to {output_path} successfully.")


def main():
    """
    Main function to execute the gdalinfo command on a specified file and optionally save the output as JSON.
    """
    input_path = input("Enter the path to the file: ")
    processor = GdalInfoProcessor(input_path)

    bool_crop = input("Do you want to save results as JSON? (y/n): ")
    save_as_json = bool_crop.lower() == "y"

    try:
        output = processor.execute_command(save_as_json)
        if save_as_json:
            processor.save_output(output)
        else:
            print(output)
    except RuntimeError as e:
        print(e)


if __name__ == "__main__":
    main()
