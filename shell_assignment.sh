#!/usr/bin/env bash
set -euo pipefail

# Validate input
if [[ $# -ne 1 || ! "$1" =~ ^https?:// ]]; then
    echo "Usage: $0 <csv_url>" >&2
    exit 1
fi

# Download the CSV
tmp_file=$(mktemp)
trap 'rm -f "$tmp_file"' EXIT

curl -fsSL --retry 2 --max-time 60 "$1" -o "$tmp_file"

# Extract company, location, and founding year
printf 'Company\tLocation\tFounding Year\n'

gawk --csv '
    NR == 1 {
        if ($2 != "Security" ||
            $5 != "Headquarters Location" ||
            $8 != "Founded") {
            print "Error: Unexpected CSV columns" > "/dev/stderr"
            exit 1
        }
        next
    }

    {
        year = ($8 ~ /^[0-9]{4}/) ? substr($8, 1, 4) : "Unknown"
        sort_year = (year == "Unknown") ? 9999 : year

        printf "%d\t%s\t%s\t%s\n",
            sort_year, $2, $5, year
    }
' "$tmp_file" |
sort -t $'\t' -k1,1n -k2,2 |
cut -f2-
