import difflib

def read_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        return file.readlines()

def write_diff_to_file(diff, output_file_path):
    with open(output_file_path, 'w', encoding='utf-8') as output_file:
        output_file.write("\n".join(diff))

# Prompt the user for the file paths
file1_path = input("Enter the path to the first file: ")
file2_path = input("Enter the path to the second file: ")

# Prompt the user for the output file path with a default value
output_file_path = input("Enter the path to the output file where differences will be written (press Enter for default 'diffpy_output.diff'): ")
if not output_file_path:
    output_file_path = 'diffpy_output.diff'

# Read the contents of the files
file1_contents = read_file(file1_path)
file2_contents = read_file(file2_path)

# Create a Differ object
d = difflib.Differ()

# Generate the diff
diff = d.compare(file1_contents, file2_contents)

# Write the diff to a file
write_diff_to_file(diff, output_file_path)

print(f"Differences have been written to {output_file_path}")
