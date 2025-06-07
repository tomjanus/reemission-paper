#!/bin/bash

# Exit immediately on error
set -e

# Define file paths
INPUT1="../data/myanmar_inputs.json"
INPUT2="../data/uk_inputs.json"
OUTPUT="../data/validation_inputs.json"
N="all"  # Change to "all" to modify all reservoirs

# Run the Python script
python3 create_test_input.py --input1 "$INPUT1" --input2 "$INPUT2" --output "$OUTPUT" --n "$N"

