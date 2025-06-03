#!/bin/bash
#chmod +x long2wide.sh
#./long2wide.sh (long.csv as default)
# or
#./long2wide.sh long.csv wide.csv.

# Process command line arguments
inputFile="${1:-long.csv}"
outputFile="${2:-wide.csv}"

if [ ! -f "$inputFile" ]; then
  echo "Input file not found: $inputFile"
  exit 1
fi

# Use associative arrays to store values
declare -A dataMap
declare -A idSeen
declare -A keySeen

idList=()
keyList=()

# Read file
while IFS=',' read -r id key val; do
  if [[ "$id" == "id" && "$key" == "x" && "$val" == "val" ]]; then
    continue
  fi

  # Keep track of unique ids in order
  if [[ -z "${idSeen[$id]}" ]]; then
    idSeen[$id]=1
    idList+=("$id")
  fi

  # Keep track of unique keys in order
  if [[ -z "${keySeen[$key]}" ]]; then
    keySeen[$key]=1
    keyList+=("$key")
  fi

  dataMap["$id,$key"]="$val"
done < "$inputFile"

# Write header
{
  printf "id"
  for key in "${keyList[@]}"; do
    printf ",%s" "$key"
  done
  printf "\n"
} > "$outputFile"

# Write each row
for id in "${idList[@]}"; do
  printf "%s" "$id" >> "$outputFile"
  for key in "${keyList[@]}"; do
    val="${dataMap["$id,$key"]}"
    printf ",%s" "$val" >> "$outputFile"
  done
  printf "\n" >> "$outputFile"
done

echo "Conversion completed. Output file: $outputFile"
