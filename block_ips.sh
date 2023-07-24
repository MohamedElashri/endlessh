#!/bin/bash

input_log="$HOME/endlessh/parsed_output.log"
blocked_ips="$HOME/endlessh/blocked_ips_file.log"

# Create the blocked_ips file if it does not exist
[ -e "$blocked_ips" ] || touch "$blocked_ips"

# Count the occurrences of each IP address and filter those with more than 10 occurrences
awk '{count[$2]++} END {for (ip in count) if (count[ip] > 10) print ip}' "$input_log" > tmp_ips_to_block.log

# Read the temporary file with IPs to block and check if they are already in the blocked_ips file
while read -r ip_to_block; do
    if ! grep -q "^${ip_to_block}$" "$blocked_ips"; then
        # Block the IP using UFW
        sudo ufw deny from "$ip_to_block"

        # Add the blocked IP to the blocked_ips file
        echo "$ip_to_block" >> "$blocked_ips"
    fi
done < tmp_ips_to_block.log

# Remove the temporary file
rm tmp_ips_to_block.log
