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
</style>
#highlight "Shweli 1" / "catchment" <<h2>>
#highlight "Shweli 1" / "catchment" / "biogenic_factors" <<h3>>
#highlight "Shweli 1" / "reservoir" <<h1>>
{
    "Shweli 1": {
        "id": 1,
        "type": "hydroelectric",
        "coordinates": [0,0],
        "monthly_temps": [13.9, 16.0, "... <color:#1F3A93>(12 values)"],
        "year_vector": [1, 5, 10, "..."],
        "gasses": ["co2", "ch4", "n2o"],
        "catchment": {
            "runoff": 1115.0,
            "area": 12582.6,
            "riv_length": 0.0,
            "population": 1587524,
            "area_fractions": [0.0, 0.0, 0.003, "... <color:#1F3A93>(9 values)"],
            "slope": 23.0,
            "precip": 1498.0,
            "etransp": 1123.0,
            "soil_wetness": 144.0,
            "mean_olsen": 5.85,
            "biogenic_factors": {
                "biome": "tropical moist broadleaf",
                "climate": "temperate",
                "soil_type": "mineral",
                "treatment_factor": "primary (mechanical)",
                "landuse_intensity": "low intensity"
            }
        },
        "reservoir": {
            "volume": 7238166,
            "area": 1.604,
            "max_depth": 22.0,
            "mean_depth": 4.5,
            "area_fractions": [0.0, 0.0, "... <color:#1F3A93>(27 values)"],
            "soil_carbon": 6.28,
            "mean_radiance": 4.66,
            "mean_radiance_may_sept": 4.328,
            "mean_radiance_nov_mar": 4.852,
            "mean_monthly_windspeed": 1.08,
            "water_intake_depth": null
        }
    },
    "<color:#5f99cf>other reservoirs": "..."
}
@endjson

