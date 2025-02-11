#!/bin/bash

# Define the input and output files
MIRRORLIST="/etc/pacman.d/mirrorlist"
OUTPUT="sorted_mirrors.txt"

# Ensure the script runs as root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

# Extract server URLs from the mirrorlist
SERVERS=$(grep -oP '^Server\s*=\s*\K.*' "$MIRRORLIST")

if [[ -z "$SERVERS" ]]; then
  echo "No servers found in $MIRRORLIST"
  exit 1
fi

# Test each server's speed and store the results in an array
SPEED_RESULTS=()
UNREACHABLE_SERVERS=()
echo "Testing server speeds..."
for SERVER in $SERVERS; do
  # Measure download speed using curl (time to fetch 1MB of /dev/null)
  SPEED=$(curl -o /dev/null --max-time 5 --silent --write-out '%{speed_download}\n' "$SERVER")
  if [[ $? -eq 0 ]]; then
    SPEED_RESULTS+=("$SPEED $SERVER")
  else
    echo "Failed to test $SERVER"
    UNREACHABLE_SERVERS+=("$SERVER")
  fi
done

# Check if any speeds were recorded
if [[ ${#SPEED_RESULTS[@]} -eq 0 ]]; then
  echo "No servers responded successfully."
  exit 1
fi

# Sort the results based on speed (numerical order, descending)
echo "Sorting servers by speed..."
SORTED_RESULTS=$(printf "%s\n" "${SPEED_RESULTS[@]}" | sort -nr)

# Save the sorted results to the output file
echo "$SORTED_RESULTS" > "$OUTPUT"

# Append unreachable servers at the end of the output file
if [[ ${#UNREACHABLE_SERVERS[@]} -ne 0 ]]; then
  echo "Unreachable Servers:" >> "$OUTPUT"
  printf "%s\n" "${UNREACHABLE_SERVERS[@]}" >> "$OUTPUT"
fi

echo "Sorted mirror list saved to $OUTPUT"

# Optionally, display the sorted results
echo "Sorted Mirror List:" 
cat "$OUTPUT"
