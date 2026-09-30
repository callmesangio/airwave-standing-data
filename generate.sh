#!/bin/bash

set -e

generate() {
    local src="$1"
    local dst="$2"
    {
        head -n 1 "$(find "$src" -type f -name '*.csv' -print -quit)"
        find "$src" -type f -name '*.csv' -exec awk 'FNR > 1' {} +
    } > "$dst"
}

repo=$(mktemp -d)
here=$(dirname "$0")
git clone --depth=1 https://github.com/vradarserver/standing-data "$repo"
generate "$repo/routes" "$here/csv/routes.csv"
generate "$repo/airports" "$here/csv/airports.csv"
generate "$repo/aircraft" "$here/csv/aircraft.csv"
cp "$repo/airlines/schema-01/airlines.csv" "$here/csv/airlines.csv"
