#!/bin/bash
#chmod +x long2wide.sh
# Usage:
#   ./long2wide.sh long.csv wide.csv 1 2 3
# Specify fixed columns as the 3rd and following arguments (1-based column numbers)

#!/bin/bash

inputFile="${1:-long.csv}"
outputFile="${2:-wide.csv}"

shift 2
fixedCols=("$@")

if [ ! -f "$inputFile" ]; then
  echo "Input file not found: $inputFile"
  exit 1
fi

# Extract unique x values in the file, sorted
xvals_sorted=$(awk -F',' '
NR>1 && $1 != "" { print $0 }
' "$inputFile" | awk -F',' '
NR==1 {
  # find column index of "x"
  for (i=1; i<=NF; i++) {
    if ($i == "x") xcol = i
    else if ($i == "val") valcol = i
  }
  next
}
{
  print $xcol
}' "$inputFile" | sort -u | tr '\n' ',' | sed 's/,$//')

awk -F',' -v OFS=',' -v fixedCols="$(IFS=','; echo "${fixedCols[*]}")" -v xvals="$xvals_sorted" '
BEGIN {
  split(fixedCols, fcols, ",")
  split(xvals, sorted_xvals, ",")
  fixedCount = length(fcols)
}
NR==1 {
  header_fixed = ""
  for (i=1; i<=fixedCount; i++) {
    c = fcols[i]
    if (header_fixed != "") header_fixed = header_fixed "," $c
    else header_fixed = $c
  }
  # find columns "x" and "val"
  for (i=1; i<=NF; i++) {
    if ($i == "x") xcol = i
    else if ($i == "val") valcol = i
  }
  # Print header explicitly with one line, no extra newline
  printf "%s", header_fixed
  for (i=1; i<=length(sorted_xvals); i++) {
    printf ",%s", sorted_xvals[i]
  }
  printf "\n"
  next
}
{
  key = ""
  for (i=1; i<=fixedCount; i++) {
    c = fcols[i]
    if (key != "") key = key "," $c
    else key = $c
  }
  xval = $xcol
  val = $valcol
  data[key,xval] = val
  keys[key] = 1
}
END {
  for (k in keys) {
    printf "%s", k
    for (i=1; i<=length(sorted_xvals); i++) {
      v = data[k,sorted_xvals[i]]
      if (v == "") v = ""
      printf ",%s", v
    }
    printf "\n"
  }
}
' "$inputFile" > "$outputFile"

echo "Conversion done: $outputFile"
