""" """
from typing import Any
import json
import random
import argparse
from pathlib

# Define the available options for each field
BIOGENIC_OPTIONS = {
    "biome": [
        "deserts", "mediterreanan forests", "montane grasslands",
        "temperate broadleaf and mixed", "temperate coniferous",
        "temperate grasslands", "tropical dry broadleaf", "tropical grasslands",
        "tropical moist broadleaf", "tundra"
    ],
    "climate": ["boreal", "subtropical", "temperate", "tropical"],
    "soil_type": ["mineral", "organic"],
    "treatment_factor": [
        "no treatment", "primary (mechanical)",
        "secondary biological treatment", "tertiary"
    ],
    "landuse_intensity": ["low intensity", "high intensity"]
}

def load_json_file(filepath: pathlib.Path | str):
    with open(filepath, 'r') as f:
        return json.load(f)

def save_json_file(data: Any, filepath: pathlib.Path | str):
    with open(filepath, 'w') as f:
        json.dump(data, f, indent=2)

def randomize_biogenic_factors(reservoir_data):
    for field, options in BIOGENIC_OPTIONS.items():
        reservoir_data["catchment"]["biogenic_factors"][field] = random.choice(options)

def main(input1, input2, output, n):
    # Load and merge input files
    data1 = load_json_file(input1)
    data2 = load_json_file(input2)
    combined_data = {**data1, **data2}

    # Determine which reservoirs to select
    reservoir_names = list(combined_data.keys())
    if n == "all":
        selected_reservoirs = reservoir_names
    else:
        n = int(n)
        selected_reservoirs = random.sample(reservoir_names, min(n, len(reservoir_names)))

    # Modify the selected reservoirs
    for name in selected_reservoirs:
        randomize_biogenic_factors(combined_data[name])

    # Save to output file
    save_json_file(combined_data, output)
    print(f"Modified data saved to {output}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Modify reservoir input JSONs with randomized biogenic factors.")
    parser.add_argument("--input1", required=True, help="Path to first input JSON file")
    parser.add_argument("--input2", required=True, help="Path to second input JSON file")
    parser.add_argument("--output", required=True, help="Path to output JSON file")
    parser.add_argument("--n", default="all", help="Number of reservoirs to modify or 'all' (default: all)")

    args = parser.parse_args()
    main(args.input1, args.input2, args.output, args.n)

