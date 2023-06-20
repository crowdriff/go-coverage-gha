#!/usr/bin/env bash

# set -euo pipefail

# This is a simple script to generate an HTML coverage report,
# and SVG badge for your Go project.
#
# Place it some where in your code tree and execute it.
# If your tests pass, next to the script you'll find
# the coverage.html report and coverage.svg badge.
#
# You can add the badge to your README.md as such:
#  [![Go Coverage](PATH_TO/coverage.svg)](https://raw.githack.com/URL/coverage.html)
#
# Visit https://raw.githack.com/ to find the correct URL.

# Get the script's directory after resolving a possible symlink.
# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

SCRIPT_DIR=$DIR

echo "SCRIPT_DIR: $SCRIPT_DIR"

# Get coverage for all packages in the current directory; store next to script.
go test `go list ./...` -coverprofile=$SCRIPT_DIR/coverage.out ./...

# Create an HTML report; store next to script.
go tool cover -html="$SCRIPT_DIR/coverage.out" -o "$SCRIPT_DIR/coverage.html"

# Extract total coverage: the decimal number from the last line of the function report.
COVERAGE=$(go tool cover -func="$SCRIPT_DIR/coverage.out" | tail -1 | grep -Eo '[0-9]+\.[0-9]')

echo "coverage: $COVERAGE% of statements"

date "+%s,$COVERAGE" >> "$SCRIPT_DIR/coverage.log"

# Pick a color for the badge.
if awk "BEGIN {exit !($COVERAGE >= 90)}"; then
	COLOR=brightgreen
elif awk "BEGIN {exit !($COVERAGE >= 80)}"; then
	COLOR=green
elif awk "BEGIN {exit !($COVERAGE >= 70)}"; then
	COLOR=yellowgreen
elif awk "BEGIN {exit !($COVERAGE >= 60)}"; then
	COLOR=yellow
elif awk "BEGIN {exit !($COVERAGE >= 50)}"; then
	COLOR=orange
else
	COLOR=red
fi

# Download the badge; store next to script.
curl -s "https://img.shields.io/badge/coverage-$COVERAGE%25-$COLOR" > "$SCRIPT_DIR/coverage.svg"