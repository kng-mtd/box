#!/bin/bash
# chmod +x wide2long2.sh
# Usage:
#   ./wide2long2.sh wide.csv long.csv 1 2
#     => keeps columns 1 and 2, converts the rest to long format

inputFile="${1:-wide.csv}"
outputFile="${2:-long.csv}"
shift 2

# Check file
if [ ! -f "$inputFile" ]; then
  echo "Input file not found: $inputFile"
  exit 1
fi

# Check for at least one column to keep
if [ $# -eq 0 ]; then
  echo "Please specify at least one column number to keep."
  exit 1
fi

# Store keep (non-transform) columns
keepCols=("$@")

awk -v keep="$(IFS=,; echo "${keepCols[*]}")" '
BEGIN {
  FS = OFS = ",";
  split(keep, kcols, ",");
  for (i in kcols) {
    keepCol[kcols[i]] = 1;
  }
}
NR == 1 {
  for (i = 1; i <= NF; i++) {
    headers[i] = $i;
    if (i in keepCol) {
      keepIdx[++nk] = i;
    } else {
      convertIdx[++nc] = i;
    }
  }
  # print header
  for (i = 1; i <= nk; i++) {
    printf "%s%s", headers[keepIdx[i]], (i < nk ? OFS : "");
  }
  printf "%sx%sval\n", (nk > 0 ? OFS : ""), OFS;
  next;
}
{
  # prepare fixed part
  for (i = 1; i <= nk; i++) {
    fixed[i] = $keepIdx[i];
  }

  # for each convert column, emit a row
  for (j = 1; j <= nc; j++) {
    col = convertIdx[j];
    for (i = 1; i <= nk; i++) {
      printf "%s%s", fixed[i], (i < nk ? OFS : "");
    }
    printf "%s%s%s\n", (nk > 0 ? OFS : ""), headers[col], OFS $col;
  }
}
' "$inputFile" > "$outputFile"

echo "Transformation completed. Output file: $outputFile"
