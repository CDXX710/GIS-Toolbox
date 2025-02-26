from PyPDF2 import PdfReader, PdfWriter
import os

def parse_pages(pages_input):
    pages_to_delete = set()
    for part in pages_input.split(","):
        if "-" in part:
            start, end = map(int, part.split("-"))
            pages_to_delete.update(range(start, end + 1))
        else:
            pages_to_delete.add(int(part))
    return sorted(pages_to_delete)

def delete_pages_from_pdf():
    # Prompt the user for the input file path
    input_path = input("Enter the path of the input PDF file: ")

    # Prompt the user for the output file path, with a default option
    output_path = input(f"Enter the path to save the output PDF file (press Enter to use '{os.path.splitext(input_path)[0]}-crop.pdf'): ")

    # Use the default output path if none is provided
    if not output_path:
        output_path = f"{os.path.splitext(input_path)[0]}-crop.pdf"

    # Prompt the user for the pages to delete
    pages_input = input("Enter the page numbers to delete (e.g., 1,3,5-10): ")
    pages_to_delete = [page - 1 for page in parse_pages(pages_input)]

    # Read the input PDF
    reader = PdfReader(input_path)
    writer = PdfWriter()

    # Copy pages to the writer, excluding the pages to delete
    for i, page in enumerate(reader.pages):
        if i not in pages_to_delete:
            writer.add_page(page)

    # Write the output PDF
    with open(output_path, "wb") as f_out:
        writer.write(f_out)

    print(f"Pages {pages_input} have been deleted. The new PDF is saved at {output_path}.")

# Run the function
delete_pages_from_pdf()
