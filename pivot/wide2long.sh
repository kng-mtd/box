#!/bin/bash
#chmod +x wide2long.sh
#./wide2long.sh (wide.csv as default)
# or
#./wide2long.sh wide.csv long.csv

# Process command-line arguments
inputFile="${1:-wide.csv}"  # Default input file: wide.csv
outputFile="${2:-long.csv}" # Default output file: long.csv

# Check if the input file exists
if [ ! -f "$inputFile" ]; then
  echo "The specified input file was not found: $inputFile"
  exit 1
fi

# Transform CSV from wide format to long format
awk '
BEGIN {
  FS = ","; OFS = ",";  # Set field separator and output field separator
}
NR == 1 {
  # Read the header row (store column names)
  for (i = 2; i <= NF; i++) {
    headers[i] = $i;
  }
  print "id,x,val";  # Print the new header for the long format
  next;
}
{
  # Process data rows
  id = $1;
  for (i = 2; i <= NF; i++) {
    print id, headers[i], $i;
  }
}
' "$inputFile" > "$outputFile"

# Notify the user about the result
echo "Transformation completed. Output file: $outputFile"
