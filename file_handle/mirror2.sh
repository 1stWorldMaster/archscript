#!/bin/bash

# Input and output file paths
input_file="sorted_mirrors.txt"  # Replace with your input file path
output_file="/etc/pacman.d/mirrorlist"  # Replace with your output file path

# Initialize a flag to track unreachable server section
unreachable_section=false

# Create/clear the output file before appending
> "$output_file"

# Process the input file
while IFS= read -r line; do
    # Check if the line contains "Unreachable Servers:"
    if [[ "$line" == "Unreachable Servers:" ]]; then
        unreachable_section=true
        echo "# $line" >> "$output_file"
    # If in unreachable section, comment out the line
    elif [[ "$unreachable_section" == true && -n "$line" ]]; then
        echo "# $line" >> "$output_file"
    # If an empty line, end the unreachable section
    elif [[ -z "$line" && "$unreachable_section" == true ]]; then
        unreachable_section=false
        echo "$line" >> "$output_file"
    # Process any reachable server lines (those starting with a number)
    elif [[ "$line" =~ ^[0-9]+[[:space:]] ]]; then
        server_url=$(echo "$line" | cut -d ' ' -f2-)
        echo "Server = $server_url" >> "$output_file"
    else
        # For other lines, just append them as is
        echo "$line" >> "$output_file"
    fi
done < "$input_file"

echo "Output written to $output_file"
