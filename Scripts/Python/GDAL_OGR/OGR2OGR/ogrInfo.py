import os
import subprocess


def get_file_info(input_path):
    """
    Executes the ogrinfo command to retrieve information about a file.

    Parameters:
    - input_path (str): The path to the file for which information is to be retrieved.

    Returns:
    - None
    """
    # Construct the ogrinfo command with options:
    # -al: List all layers
    # -so: Summary only (omit full feature dump)
    command = ["ogrinfo", input_path, "-al", "-so"]

    try:
        # Execute the command and check for errors
        result = subprocess.run(command, check=True, capture_output=True, text=True)
        # Print the result output
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        # Handle errors that occur during the command execution
        print(f"An error occurred: {e}")
    except FileNotFoundError:
        # Handle the case where the ogrinfo command is not found
        print(
            "The ogrinfo command is not available. Please ensure GDAL is installed and accessible."
        )


if __name__ == "__main__":
    # Prompt the user for the input file path
    input_path = input("Enter the path to the file: ")

    # Call the function to get file information
    get_file_info(input_path)
