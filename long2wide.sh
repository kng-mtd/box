#!/bin/bash
#chmod +x long2wide.sh
#./long2wide.sh (long.csv as default)
# or
#./long2wide.sh long.csv wide.csv.

# Process command line arguments
inputFile="${1:-long.csv}"
outputFile="${2:-wide.csv}"

# Check if input file exists
if [ ! -f "$inputFile" ]; then
  echo "The specified input file was not found: $inputFile"
  exit 1
fi

# Prepare headers and data
declare -A headers
declare -A dataMap
idList=()

# Read the input CSV file
while IFS=',' read -r id key value; do
  if [[ "$id" == "id" ]]; then
    continue # Skip header row
  fi

  # Collect headers (create a list of keys)
  headers["$key"]=1

  # Store data for each id
  dataMap["$id,$key"]="$value"

  # Add id to idList
  if [[ ! " ${idList[@]} " =~ " ${id} " ]]; then
    idList+=("$id")
  fi
done < "$inputFile"

# Create header row (maintaining the order of keys)
headerRow="id"
headerKeys=()
for key in "${!headers[@]}"; do
  headerRow+=",${key}"
  headerKeys+=("$key")
done

# Write the header row to the output file
echo "$headerRow" > "$outputFile"

# Create data rows for each id
for id in "${idList[@]}"; do
  row="$id"
  for key in "${headerKeys[@]}"; do
    row+=",${dataMap["$id,$key"]}"
  done
  echo "$row" >> "$outputFile"
done

echo "Conversion completed. Output file: $outputFile"
