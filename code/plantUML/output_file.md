@startjson
<style>
  .h1 {
    BackGroundColor #F7C6C7
    FontColor #333333
    FontStyle bold
  }
  .h2 {
    BackGroundColor #AEC6CF
    FontColor #333333
    FontStyle bold
  }
  .h3 {
    BackGroundColor #C3E5AE
    FontColor #333333
    FontStyle bold
  }
  .h4 {
    BackGroundColor #FFD8B1  // pastel peach
    FontColor #333333
    FontStyle bold
  }
</style>
#highlight "Shweli 1" / "inputs" <<h2>>
#highlight "Shweli 1" / "outputs" <<h3>>
#highlight "Shweli 1" / "intern_vars" <<h1>>
{
    "Shweli 1": {
        "inputs": {
            "id": {
                "name": "Reservoir ID",
                "unit": "",
                "value": 1
            },
            "monthly_temps": {
                "name": "Monthly Temperatures",
                "unit": "deg C",
                "value": [13.9, 16.0, "... <color:#1F3A93>(12 values)"]
            },
            "<color:#5f99cf>other inputs": "...",
            "biogenic_factors": {
                "name": "Biogenic factors",
                "biome": {
                    "name": "Biome",
                    "unit": "",
                    "value": "tropical moist broadleaf"
                },
                "<color:#5f99cf>other biogenic factors": "..."
            },
            "catchment_inputs": {
                "name": "Inputs for [...]",
                "runoff": {
                    "name": "Annual runoff",
                    "unit": "mm/year",
                    "value": 1115.0
                },
                "<color:#5f99cf>other catchment inputs": "..."
            },
            "reservoir_inputs": {
                "name": "Inputs for [...]",
                "volume": {
                    "name": "Reservoir volume",
                    "unit": "m3",
                    "value": 7238166.0
                },
                "<color:#5f99cf>other reservoir inputs": "..."
            }
        },
        "outputs": {
            "co2_diffusion": {
                "name": "CO2 diffusion flux",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "Total CO2 emissions from a [...]",
                "value": 572.8396
            },
            "<color:#5f99cf>other outputs": "..."
        },
        "intern_vars": {
            "inflow_p_conc": {
                "name": "Influent total P concentration",
                "unit": "micrograms / L",
                "long_description": "Median influent total [...]",
                "value": 88.8024
            },
            "<color:#5f99cf>other internal variables": "..."
        }
    },
    "<color:#5f99cf>other reservoirs": "..."
}
@endjson
