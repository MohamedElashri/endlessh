#!/bin/bash

input_log="/$HOME/endlessh/data/logs/endlessh/current"
output_log="/$HOME/endlessh/parsed_output.log"

awk '{
    timestamp = substr($1, 1, 19)
    if (match($0, /::ffff:[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/)) {
        ip = substr($0, RSTART+7, RLENGTH-7)
    }
    if (match($0, /port=[0-9]+/)) {
        port = substr($0, RSTART+5, RLENGTH-5)
        print timestamp, ip, port
    }
}' "$input_log" > "$output_log"