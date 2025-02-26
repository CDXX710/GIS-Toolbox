import os
import subprocess


def main():
    """
    Main function to execute the gdalinfo command on a specified file and optionally save the output as JSON.
    """
    # Prompt the user for the input file path
    input_path = input("Enter the path to the file: ")

    # Extract the file name and extension from the input path
    input_file_name, input_file_extension = os.path.splitext(
        os.path.basename(input_path)
    )

    # Initialize the gdalinfo command with the input file path
    command = ["gdalinfo", input_path]

    # Prompt the user for the option to save results as JSON
    bool_crop = input("Do you want to save results as JSON? (y/n): ")

    # If the user wants to save the result as JSON
    if bool_crop.lower() == "y":
        output_path = f"{input_file_name}.json"
        # Add the JSON flag to the gdalinfo command
        command.append("-json")
    else:
        output_path = None

    # Execute the gdalinfo command
    try:
        result = subprocess.run(command, check=True, stdout=subprocess.PIPE, text=True)

        # If an output path is specified, write the output to the file
        if output_path:
            with open(output_path, "w") as output_file:
                output_file.write(result.stdout)
            print(f"Saved to {output_path} successfully.")
        else:
            # Print the output to the console
            print(result.stdout)

    except subprocess.CalledProcessError as e:
        # Handle errors that occur during the subprocess execution
        print(f"An error occurred: {e}")


if __name__ == "__main__":
    main()
