#!/bin/bash

# Declare the array of values "array" containing different values
array="Value1 Value2 Value3"

# Execute the loop for each iteration of the array
for x in $array; do
    # Creates the folders Value1/Subfolder1/SubSubfolder, Value1/Subfolder2/SubSubfolder,
    # Value2/Subfolder1/SubSubfolder, Value2/Subfolder2/SubSubfolder in cascade at the current location
    mkdir -p ./$x/Subfolder1/SubSubfolder ./$x/Subfolder2/SubSubfolder
done
# End of loop