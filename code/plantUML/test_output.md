@startjson
<style>
jsonDiagram {
    highlight {
      BackGroundColor #d8e2f2
      FontColor #40454d
      FontStyle italic
    }
}
</style>
{
    "Shweli 1": {
        "inputs": {
            "coordinates": {
                "name": "Reservoir coordinates (lat/lon)",
                "unit": "deg",
                "value": [
                    0.0,
                    0.0
                ]
            },
            "id": {
                "name": "Reservoir ID",
                "unit": "",
                "value": 1
            },
            "type": {
                "name": "Reservoir type",
                "unit": "",
                "value": "hydroelectric"
            },
            "monthly_temps": {
                "name": "Monthly Temperatures",
                "unit": "deg C",
                "value": [
                    13.9,
                    16.0,
                    19.3,
                    22.8,
                    24.2,
                    24.5,
                    24.2,
                    24.3,
                    23.9,
                    22.1,
                    18.5,
                    14.8
                ]
            },
            "year_profile": {
                "name": "Year vector for emission profiles",
                "unit": "yr",
                "value": [
                    1,
                    5,
                    10,
                    20,
                    30,
                    40,
                    50,
                    65,
                    80,
                    100
                ]
            },
            "gasses": {
                "name": "Calculated gas emissions",
                "unit": "-",
                "value": [
                    "co2",
                    "ch4",
                    "n2o"
                ]
            },
            "biogenic_factors": {
                "name": "Biogenic factors",
                "biome": {
                    "name": "Biome",
                    "unit": "",
                    "value": "tropical moist broadleaf"
                },
                "climate": {
                    "name": "Climate",
                    "unit": "",
                    "value": "temperate"
                },
                "soil_type": {
                    "name": "Soil Type",
                    "unit": "",
                    "value": "mineral"
                },
                "treatment_factor": {
                    "name": "Treatment Factor",
                    "unit": "",
                    "value": "primary (mechanical)"
                }
            },
            "catchment_inputs": {
                "name": "Inputs for catchment-level process calculations",
                "runoff": {
                    "name": "Annual runoff",
                    "unit": "mm/year",
                    "value": 1115.0
                },
                "area": {
                    "name": "Catchment area",
                    "unit": "km2",
                    "value": 12582.613
                },
                "riv_length": {
                    "name": "Length of inundated river",
                    "unit": "km",
                    "value": 0.0
                },
                "population": {
                    "name": "Population",
                    "unit": "capita",
                    "value": 1587524.0
                },
                "area_fractions": {
                    "name": "Area fractions",
                    "unit": "-",
                    "value": "0.0, 0.0, 0.003, 0.002, 0.001, 0.146, 0.391, 0.457, 0.0"
                },
                "slope": {
                    "name": "Mean catchment slope",
                    "unit": "%",
                    "value": 23.0
                },
                "precip": {
                    "name": "Mean annual precipitation",
                    "unit": "mm/year",
                    "value": 1498.0
                },
                "etransp": {
                    "name": "Mean annual evapotranspiration",
                    "unit": "mm/year",
                    "value": 1123.0
                },
                "soil_wetness": {
                    "name": "Soil wetness",
                    "unit": "mm over profile",
                    "value": 144.0
                },
                "mean_olsen": {
                    "name": "Soil Olsen P content",
                    "unit": "kgP/ha",
                    "value": 5.85
                }
            },
            "reservoir_inputs": {
                "name": "Inputs for reservoir-level process calculations",
                "volume": {
                    "name": "Reservoir volume",
                    "unit": "m3",
                    "value": 7238166.0
                },
                "area": {
                    "name": "Reservoir area",
                    "unit": "km2",
                    "value": 1.604
                },
                "max_depth": {
                    "name": "Maximum reservoir depth",
                    "unit": "m",
                    "value": 22.0
                },
                "mean_depth": {
                    "name": "Mean reservoir depth",
                    "unit": "m",
                    "value": 4.5
                },
                "area_fractions": {
                    "name": "Inundated area fractions",
                    "unit": "-",
                    "value": "0.0, 0.0, 0.0, 0.0, 0.0, 0.45, 0.15, 0.4, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0"
                },
                "soil_carbon": {
                    "name": "Soil carbon in inundated area",
                    "unit": "kgC/m2",
                    "value": 6.281
                },
                "mean_radiance": {
                    "name": "Mean monthly horizontal radiance",
                    "unit": "kWh/m2/d",
                    "value": 4.66
                },
                "mean_radiance_may_sept": {
                    "name": "Mean monthly horizontal radiance: May - Sept",
                    "unit": "kWh/m2/d",
                    "value": 4.328
                },
                "mean_radiance_nov_mar": {
                    "name": "Mean monthly horizontal radiance: Nov - Mar",
                    "unit": "kWh/m2/d",
                    "value": 4.852
                },
                "mean_monthly_windspeed": {
                    "name": "Mean monthly wind speed",
                    "unit": "m/s",
                    "value": 1.08
                },
                "water_intake_depth": {
                    "name": "Water intake depth below surface",
                    "unit": "m",
                    "value": null
                }
            }
        },
        "outputs": {
            "co2_diffusion": {
                "name": "CO2 diffusion flux",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "Total CO2 emissions from a reservoir integrated over lifetime",
                "value": 572.8396
            },
            "co2_diffusion_nonanthro": {
                "name": "Nonanthropogenic CO2 diffusion flux",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "CO2 diffusion flux taken at (after) 100 years",
                "value": 393.1274
            },
            "co2_preimp": {
                "name": "Preimpoundment CO2 emissions",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "CO2 emission in the area covered by the reservoir prior to impoundment",
                "value": -132.0
            },
            "co2_minus_nonanthro": {
                "name": "CO2 emission minus non-anthropogenic",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "CO2 emissions minus non-anthropogenic over a number of years",
                "value": 179.7121
            },
            "co2_net": {
                "name": "Net CO2 emission",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "Overall integrated emissions for lifetime",
                "value": 311.7121
            },
            "co2_total_per_year": {
                "name": "Total CO2 emission per year",
                "gas_name": "CO2",
                "unit": "tCO2eq yr-1",
                "long_description": "Total CO2 emission per year integrated over lifetime",
                "value": 499.9863
            },
            "co2_total_lifetime": {
                "name": "Total CO2 emission per lifetime",
                "gas_name": "CO2",
                "unit": "tCO2eq",
                "long_description": "Total CO2 emission integrated over lifetime",
                "value": 49.9986
            },
            "co2_profile": {
                "name": "CO2 emission profile",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "CO2 emission per year for a defined list of years",
                "value": [
                    1535.8117,
                    795.3817,
                    579.3641,
                    407.5143,
                    323.7749,
                    270.8014,
                    233.039,
                    192.0538,
                    162.0414,
                    132.0
                ]
            },
            "ch4_diffusion": {
                "name": "CH4 emission via diffusion",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "CH4 emission via diffusion integrated over a number of years.",
                "value": 222.1296
            },
            "ch4_ebullition": {
                "name": "CH4 emission via ebullition",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "CH4 emission via ebullition",
                "value": 321.232
            },
            "ch4_degassing": {
                "name": "CH4 emission via degassing",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "CH4 emission via degassing integrated for a number of years",
                "value": 3857.2376
            },
            "ch4_preimp": {
                "name": "Pre-impounment CH4 emission",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "Pre-impounment CH4 emission",
                "value": 0.0
            },
            "ch4_net": {
                "name": "Net CH4 emission",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "Net per area CH4 emission",
                "value": 4400.5992
            },
            "ch4_total_per_year": {
                "name": "Total CH4 emission per year",
                "gas_name": "CH4",
                "unit": "tCO2eq yr-1",
                "long_description": "Total CH4 emission per year integrated over lifetime",
                "value": 7058.5611
            },
            "ch4_total_lifetime": {
                "name": "Total CH4 emission per lifetime",
                "gas_name": "CH4",
                "unit": "ktCO2eq",
                "long_description": "Total CH4 emission integrated over lifetime",
                "value": 705.8561
            },
            "ch4_profile": {
                "name": "CH4 emission profile",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "CH4 emission per year for a defined list of years",
                "value": [
                    13754.635,
                    12109.1572,
                    10332.7868,
                    7542.7723,
                    5530.2776,
                    4078.6237,
                    3031.5159,
                    1981.6111,
                    1338.4165,
                    850.4765
                ]
            },
            "n2o_methodA": {
                "name": "N2O emission, method A",
                "gas_name": "N2O",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "N2O emission, method A",
                "value": 0.0433
            },
            "n2o_methodB": {
                "name": "N2O emission, method B",
                "gas_name": "N2O",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "N2O emission, method B",
                "value": 0.0481
            },
            "n2o_mean": {
                "name": "N2O emission, mean value",
                "gas_name": "N2O",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "N2O emission factor, average of two methods",
                "value": 0.0457
            },
            "n2o_total_per_year": {
                "name": "Total N2O emission per year",
                "gas_name": "N2O",
                "unit": "tCO2eq yr-1",
                "long_description": "Total N2O emission per year integrated over lifetime",
                "value": 0.0694
            },
            "n2o_total_lifetime": {
                "name": "Total N2O emission per lifetime",
                "gas_name": "N2O",
                "unit": "ktCO2eq",
                "long_description": "Total N2O emission integrated over lifetime",
                "value": 0.0069
            },
            "n2o_profile": {
                "name": "N2O emission profile",
                "gas_name": "N2O",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "N2O emission per year for a defined list of years",
                "value": [
                    0.0433,
                    0.0433,
                    0.0433,
                    0.0433,
                    0.0433,
                    0.0433,
                    0.0433,
                    0.0433,
                    0.0433,
                    0.0433
                ]
            }
        },
        "intern_vars": {
            "inflow_p_conc": {
                "name": "Influent total P concentration",
                "unit": "micrograms / L",
                "long_description": "Median influent total phosphorus concentration in micrograms/L entering the reservoir with runoff",
                "value": 88.8024
            },
            "retention_coeff": {
                "name": "Retention coefficient",
                "unit": "-",
                "long_description": "",
                "value": 0.0004
            },
            "trophic_status": {
                "name": "Trophic status of the reservoir",
                "unit": "-",
                "long_description": "",
                "value": "eutrophic"
            },
            "inflow_n_conc": {
                "name": "Influent total N concentration",
                "unit": "micrograms / L",
                "long_description": "Median influent total nitrogen concentration in micrograms/L entering the reservoir with runoff",
                "value": 5.4369
            },
            "reservoir_tn": {
                "name": "Reservoir TN concentration",
                "unit": "micrograms / L",
                "long_description": "",
                "value": 5.4344
            },
            "reservoir_tp": {
                "name": "Reservoir TP concentration",
                "unit": "micrograms / L",
                "long_description": "",
                "value": 88.7758
            },
            "littoral_area_frac": {
                "name": "Percentage of reservoir's surface area that is littoral",
                "unit": "%",
                "long_description": "",
                "value": 43.4545
            },
            "mean_radiance_lat": {
                "name": "Mean radiance at the reservoir",
                "unit": "kWh m-2 d-1",
                "long_description": "",
                "value": 4.66
            },
            "global_radiance": {
                "name": "Cumulative global horizontal radiance at the reservoir",
                "unit": "kWh m-2 d-1",
                "long_description": "",
                "value": 55.92
            },
            "bottom_temperature": {
                "name": "Bottom (hypolimnion) temperature in the reservoir",
                "unit": "deg C",
                "long_description": "",
                "value": 19.8254
            },
            "bottom_density": {
                "name": "Water density at the bottom of the reservoir",
                "unit": "kg/m3",
                "long_description": "",
                "value": 998.2695
            },
            "surface_temperature": {
                "name": "Surface (epilimnion) temperature in the reservoir",
                "unit": "deg C",
                "long_description": "",
                "value": 24.3
            },
            "surface_density": {
                "name": "Water density at the surface of the reservoir",
                "unit": "kg/m3",
                "long_description": "",
                "value": 997.2522
            },
            "thermocline_depth": {
                "name": "Thermocline depth",
                "unit": "m",
                "long_description": "",
                "value": 0.8992
            },
            "nitrogen_load": {
                "name": "Influent total N load",
                "unit": "kgN / yr-1",
                "long_description": "",
                "value": 76277.2771
            },
            "phosphorus_load": {
                "name": "Influent total P load",
                "unit": "kgP / yr-1",
                "long_description": "",
                "value": 1245863.4777
            },
            "nitrogen_downstream_conc": {
                "name": "Downstream TN concentration",
                "unit": "mg / L",
                "long_description": "",
                "value": 0.0054
            }
        }
    },
    "Paung Laung (lower)": {
        "inputs": {
            "coordinates": {
                "name": "Reservoir coordinates (lat/lon)",
                "unit": "deg",
                "value": [
                    19.785,
                    96.335
                ]
            },
            "id": {
                "name": "Reservoir ID",
                "unit": "",
                "value": 2
            },
            "type": {
                "name": "Reservoir type",
                "unit": "",
                "value": "unknown"
            },
            "monthly_temps": {
                "name": "Monthly Temperatures",
                "unit": "deg C",
                "value": [
                    21.2,
                    23.5,
                    27.3,
                    30.2,
                    29.2,
                    27.1,
                    26.6,
                    26.5,
                    27.0,
                    26.7,
                    24.7,
                    21.4
                ]
            },
            "year_profile": {
                "name": "Year vector for emission profiles",
                "unit": "yr",
                "value": [
                    1,
                    5,
                    10,
                    20,
                    30,
                    40,
                    50,
                    65,
                    80,
                    100
                ]
            },
            "gasses": {
                "name": "Calculated gas emissions",
                "unit": "-",
                "value": [
                    "co2",
                    "ch4",
                    "n2o"
                ]
            },
            "biogenic_factors": {
                "name": "Biogenic factors",
                "biome": {
                    "name": "Biome",
                    "unit": "",
                    "value": "tropical moist broadleaf"
                },
                "climate": {
                    "name": "Climate",
                    "unit": "",
                    "value": "tropical"
                },
                "soil_type": {
                    "name": "Soil Type",
                    "unit": "",
                    "value": "mineral"
                },
                "treatment_factor": {
                    "name": "Treatment Factor",
                    "unit": "",
                    "value": "primary (mechanical)"
                },
                "landuse_intensity": {
                    "name": "Landuse Intensity",
                    "unit": "",
                    "value": "low intensity"
                }
            },
            "catchment_inputs": {
                "name": "Inputs for catchment-level process calculations",
                "runoff": {
                    "name": "Annual runoff",
                    "unit": "mm/year",
                    "value": 923.0
                },
                "area": {
                    "name": "Catchment area",
                    "unit": "km2",
                    "value": 4577.466
                },
                "riv_length": {
                    "name": "Length of inundated river",
                    "unit": "km",
                    "value": 19.648
                },
                "population": {
                    "name": "Population",
                    "unit": "capita",
                    "value": 290571.0
                },
                "area_fractions": {
                    "name": "Area fractions",
                    "unit": "-",
                    "value": "0.0, 0.0, 0.0, 0.0, 0.007, 0.018, 0.409, 0.566, 0.0"
                },
                "slope": {
                    "name": "Mean catchment slope",
                    "unit": "%",
                    "value": 27.0
                },
                "precip": {
                    "name": "Mean annual precipitation",
                    "unit": "mm/year",
                    "value": 1265.0
                },
                "etransp": {
                    "name": "Mean annual evapotranspiration",
                    "unit": "mm/year",
                    "value": 1307.0
                },
                "soil_wetness": {
                    "name": "Soil wetness",
                    "unit": "mm over profile",
                    "value": 194.0
                },
                "mean_olsen": {
                    "name": "Soil Olsen P content",
                    "unit": "kgP/ha",
                    "value": 8.362
                }
            },
            "reservoir_inputs": {
                "name": "Inputs for reservoir-level process calculations",
                "volume": {
                    "name": "Reservoir volume",
                    "unit": "m3",
                    "value": 718240688.0
                },
                "area": {
                    "name": "Reservoir area",
                    "unit": "km2",
                    "value": 17.378
                },
                "max_depth": {
                    "name": "Maximum reservoir depth",
                    "unit": "m",
                    "value": 103.0
                },
                "mean_depth": {
                    "name": "Mean reservoir depth",
                    "unit": "m",
                    "value": 41.3
                },
                "area_fractions": {
                    "name": "Inundated area fractions",
                    "unit": "-",
                    "value": "0.0, 0.0, 0.0, 0.0, 0.169, 0.272, 0.308, 0.251, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0"
                },
                "soil_carbon": {
                    "name": "Soil carbon in inundated area",
                    "unit": "kgC/m2",
                    "value": 5.801
                },
                "mean_radiance": {
                    "name": "Mean monthly horizontal radiance",
                    "unit": "kWh/m2/d",
                    "value": 5.15
                },
                "mean_radiance_may_sept": {
                    "name": "Mean monthly horizontal radiance: May - Sept",
                    "unit": "kWh/m2/d",
                    "value": 4.672
                },
                "mean_radiance_nov_mar": {
                    "name": "Mean monthly horizontal radiance: Nov - Mar",
                    "unit": "kWh/m2/d",
                    "value": 5.426
                },
                "mean_monthly_windspeed": {
                    "name": "Mean monthly wind speed",
                    "unit": "m/s",
                    "value": 1.12
                },
                "water_intake_depth": {
                    "name": "Water intake depth below surface",
                    "unit": "m",
                    "value": null
                }
            }
        },
        "outputs": {
            "co2_diffusion": {
                "name": "CO2 diffusion flux",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "Total CO2 emissions from a reservoir integrated over lifetime",
                "value": 797.0697
            },
            "co2_diffusion_nonanthro": {
                "name": "Nonanthropogenic CO2 diffusion flux",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "CO2 diffusion flux taken at (after) 100 years",
                "value": 547.0118
            },
            "co2_preimp": {
                "name": "Preimpoundment CO2 emissions",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "CO2 emission in the area covered by the reservoir prior to impoundment",
                "value": -128.8467
            },
            "co2_minus_nonanthro": {
                "name": "CO2 emission minus non-anthropogenic",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "CO2 emissions minus non-anthropogenic over a number of years",
                "value": 250.058
            },
            "co2_net": {
                "name": "Net CO2 emission",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "Overall integrated emissions for lifetime",
                "value": 378.9046
            },
            "co2_total_per_year": {
                "name": "Total CO2 emission per year",
                "gas_name": "CO2",
                "unit": "tCO2eq yr-1",
                "long_description": "Total CO2 emission per year integrated over lifetime",
                "value": 6584.6046
            },
            "co2_total_lifetime": {
                "name": "Total CO2 emission per lifetime",
                "gas_name": "CO2",
                "unit": "tCO2eq",
                "long_description": "Total CO2 emission integrated over lifetime",
                "value": 658.4605
            },
            "co2_profile": {
                "name": "CO2 emission profile",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "CO2 emission per year for a defined list of years",
                "value": [
                    2082.161,
                    1051.9,
                    751.3253,
                    512.2072,
                    395.6892,
                    321.98,
                    269.436,
                    212.4077,
                    170.6473,
                    128.8467
                ]
            },
            "ch4_diffusion": {
                "name": "CH4 emission via diffusion",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "CH4 emission via diffusion integrated over a number of years.",
                "value": 131.7338
            },
            "ch4_ebullition": {
                "name": "CH4 emission via ebullition",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "CH4 emission via ebullition",
                "value": 90.9443
            },
            "ch4_degassing": {
                "name": "CH4 emission via degassing",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "CH4 emission via degassing integrated for a number of years",
                "value": 751.422
            },
            "ch4_preimp": {
                "name": "Pre-impounment CH4 emission",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "Pre-impounment CH4 emission",
                "value": 0.0
            },
            "ch4_net": {
                "name": "Net CH4 emission",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "Net per area CH4 emission",
                "value": 974.1002
            },
            "ch4_total_per_year": {
                "name": "Total CH4 emission per year",
                "gas_name": "CH4",
                "unit": "tCO2eq yr-1",
                "long_description": "Total CH4 emission per year integrated over lifetime",
                "value": 16927.9136
            },
            "ch4_total_lifetime": {
                "name": "Total CH4 emission per lifetime",
                "gas_name": "CH4",
                "unit": "ktCO2eq",
                "long_description": "Total CH4 emission integrated over lifetime",
                "value": 1692.7914
            },
            "ch4_profile": {
                "name": "CH4 emission profile",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "CH4 emission per year for a defined list of years",
                "value": [
                    3008.3688,
                    2651.0022,
                    2265.2094,
                    1659.2759,
                    1222.2065,
                    906.9416,
                    679.536,
                    451.5248,
                    311.8416,
                    205.8764
                ]
            },
            "n2o_methodA": {
                "name": "N2O emission, method A",
                "gas_name": "N2O",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "N2O emission, method A",
                "value": 0.3555
            },
            "n2o_methodB": {
                "name": "N2O emission, method B",
                "gas_name": "N2O",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "N2O emission, method B",
                "value": 0.2814
            },
            "n2o_mean": {
                "name": "N2O emission, mean value",
                "gas_name": "N2O",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "N2O emission factor, average of two methods",
                "value": 0.3185
            },
            "n2o_total_per_year": {
                "name": "Total N2O emission per year",
                "gas_name": "N2O",
                "unit": "tCO2eq yr-1",
                "long_description": "Total N2O emission per year integrated over lifetime",
                "value": 6.1785
            },
            "n2o_total_lifetime": {
                "name": "Total N2O emission per lifetime",
                "gas_name": "N2O",
                "unit": "ktCO2eq",
                "long_description": "Total N2O emission integrated over lifetime",
                "value": 0.6178
            },
            "n2o_profile": {
                "name": "N2O emission profile",
                "gas_name": "N2O",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "N2O emission per year for a defined list of years",
                "value": [
                    0.3555,
                    0.3555,
                    0.3555,
                    0.3555,
                    0.3555,
                    0.3555,
                    0.3555,
                    0.3555,
                    0.3555,
                    0.3555
                ]
            }
        },
        "intern_vars": {
            "inflow_p_conc": {
                "name": "Influent total P concentration",
                "unit": "micrograms / L",
                "long_description": "Median influent total phosphorus concentration in micrograms/L entering the reservoir with runoff",
                "value": 61.7901
            },
            "retention_coeff": {
                "name": "Retention coefficient",
                "unit": "-",
                "long_description": "",
                "value": 0.1198
            },
            "trophic_status": {
                "name": "Trophic status of the reservoir",
                "unit": "-",
                "long_description": "",
                "value": "eutrophic"
            },
            "inflow_n_conc": {
                "name": "Influent total N concentration",
                "unit": "micrograms / L",
                "long_description": "Median influent total nitrogen concentration in micrograms/L entering the reservoir with runoff",
                "value": 3.5613
            },
            "reservoir_tn": {
                "name": "Reservoir TN concentration",
                "unit": "micrograms / L",
                "long_description": "",
                "value": 3.1313
            },
            "reservoir_tp": {
                "name": "Reservoir TP concentration",
                "unit": "micrograms / L",
                "long_description": "",
                "value": 54.5314
            },
            "littoral_area_frac": {
                "name": "Percentage of reservoir's surface area that is littoral",
                "unit": "%",
                "long_description": "",
                "value": 4.3198
            },
            "mean_radiance_lat": {
                "name": "Mean radiance at the reservoir",
                "unit": "kWh m-2 d-1",
                "long_description": "",
                "value": 5.15
            },
            "global_radiance": {
                "name": "Cumulative global horizontal radiance at the reservoir",
                "unit": "kWh m-2 d-1",
                "long_description": "",
                "value": 61.8
            },
            "bottom_temperature": {
                "name": "Bottom (hypolimnion) temperature in the reservoir",
                "unit": "deg C",
                "long_description": "",
                "value": 24.6178
            },
            "bottom_density": {
                "name": "Water density at the bottom of the reservoir",
                "unit": "kg/m3",
                "long_description": "",
                "value": 997.1724
            },
            "surface_temperature": {
                "name": "Surface (epilimnion) temperature in the reservoir",
                "unit": "deg C",
                "long_description": "",
                "value": 28.45
            },
            "surface_density": {
                "name": "Water density at the surface of the reservoir",
                "unit": "kg/m3",
                "long_description": "",
                "value": 996.1355
            },
            "thermocline_depth": {
                "name": "Thermocline depth",
                "unit": "m",
                "long_description": "",
                "value": 1.6643
            },
            "nitrogen_load": {
                "name": "Influent total N load",
                "unit": "kgN / yr-1",
                "long_description": "",
                "value": 15046.6082
            },
            "phosphorus_load": {
                "name": "Influent total P load",
                "unit": "kgP / yr-1",
                "long_description": "",
                "value": 261063.1275
            },
            "nitrogen_downstream_conc": {
                "name": "Downstream TN concentration",
                "unit": "mg / L",
                "long_description": "",
                "value": 0.0045
            }
        }
    },
    "Kabaung": {
        "inputs": {
            "coordinates": {
                "name": "Reservoir coordinates (lat/lon)",
                "unit": "deg",
                "value": [
                    18.8967,
                    96.2208
                ]
            },
            "id": {
                "name": "Reservoir ID",
                "unit": "",
                "value": 3
            },
            "type": {
                "name": "Reservoir type",
                "unit": "",
                "value": "unknown"
            },
            "monthly_temps": {
                "name": "Monthly Temperatures",
                "unit": "deg C",
                "value": [
                    21.6,
                    23.7,
                    27.2,
                    30.1,
                    29.3,
                    26.9,
                    26.5,
                    26.5,
                    27.0,
                    27.3,
                    25.4,
                    22.3
                ]
            },
            "year_profile": {
                "name": "Year vector for emission profiles",
                "unit": "yr",
                "value": [
                    1,
                    5,
                    10,
                    20,
                    30,
                    40,
                    50,
                    65,
                    80,
                    100
                ]
            },
            "gasses": {
                "name": "Calculated gas emissions",
                "unit": "-",
                "value": [
                    "co2",
                    "ch4",
                    "n2o"
                ]
            },
            "biogenic_factors": {
                "name": "Biogenic factors",
                "biome": {
                    "name": "Biome",
                    "unit": "",
                    "value": "tropical moist broadleaf"
                },
                "climate": {
                    "name": "Climate",
                    "unit": "",
                    "value": "tropical"
                },
                "soil_type": {
                    "name": "Soil Type",
                    "unit": "",
                    "value": "mineral"
                },
                "treatment_factor": {
                    "name": "Treatment Factor",
                    "unit": "",
                    "value": "primary (mechanical)"
                },
                "landuse_intensity": {
                    "name": "Landuse Intensity",
                    "unit": "",
                    "value": "low intensity"
                }
            },
            "catchment_inputs": {
                "name": "Inputs for catchment-level process calculations",
                "runoff": {
                    "name": "Annual runoff",
                    "unit": "mm/year",
                    "value": 828.0
                },
                "area": {
                    "name": "Catchment area",
                    "unit": "km2",
                    "value": 1181.378
                },
                "riv_length": {
                    "name": "Length of inundated river",
                    "unit": "km",
                    "value": 21.602
                },
                "population": {
                    "name": "Population",
                    "unit": "capita",
                    "value": 142154.0
                },
                "area_fractions": {
                    "name": "Area fractions",
                    "unit": "-",
                    "value": "0.0, 0.0, 0.0, 0.0, 0.003, 0.002, 0.646, 0.349, 0.0"
                },
                "slope": {
                    "name": "Mean catchment slope",
                    "unit": "%",
                    "value": 11.0
                },
                "precip": {
                    "name": "Mean annual precipitation",
                    "unit": "mm/year",
                    "value": 1492.0
                },
                "etransp": {
                    "name": "Mean annual evapotranspiration",
                    "unit": "mm/year",
                    "value": 1346.0
                },
                "soil_wetness": {
                    "name": "Soil wetness",
                    "unit": "mm over profile",
                    "value": 323.0
                },
                "mean_olsen": {
                    "name": "Soil Olsen P content",
                    "unit": "kgP/ha",
                    "value": 5.231
                }
            },
            "reservoir_inputs": {
                "name": "Inputs for reservoir-level process calculations",
                "volume": {
                    "name": "Reservoir volume",
                    "unit": "m3",
                    "value": 591966860.0
                },
                "area": {
                    "name": "Reservoir area",
                    "unit": "km2",
                    "value": 44.194
                },
                "max_depth": {
                    "name": "Maximum reservoir depth",
                    "unit": "m",
                    "value": 39.0
                },
                "mean_depth": {
                    "name": "Mean reservoir depth",
                    "unit": "m",
                    "value": 13.4
                },
                "area_fractions": {
                    "name": "Inundated area fractions",
                    "unit": "-",
                    "value": "0.0, 0.0, 0.0, 0.0, 0.075, 0.031, 0.139, 0.755, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0"
                },
                "soil_carbon": {
                    "name": "Soil carbon in inundated area",
                    "unit": "kgC/m2",
                    "value": 5.021
                },
                "mean_radiance": {
                    "name": "Mean monthly horizontal radiance",
                    "unit": "kWh/m2/d",
                    "value": 5.03
                },
                "mean_radiance_may_sept": {
                    "name": "Mean monthly horizontal radiance: May - Sept",
                    "unit": "kWh/m2/d",
                    "value": 4.34
                },
                "mean_radiance_nov_mar": {
                    "name": "Mean monthly horizontal radiance: Nov - Mar",
                    "unit": "kWh/m2/d",
                    "value": 5.458
                },
                "mean_monthly_windspeed": {
                    "name": "Mean monthly wind speed",
                    "unit": "m/s",
                    "value": 1.0
                },
                "water_intake_depth": {
                    "name": "Water intake depth below surface",
                    "unit": "m",
                    "value": null
                }
            }
        },
        "outputs": {
            "co2_diffusion": {
                "name": "CO2 diffusion flux",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "Total CO2 emissions from a reservoir integrated over lifetime",
                "value": 1002.0002
            },
            "co2_diffusion_nonanthro": {
                "name": "Nonanthropogenic CO2 diffusion flux",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "CO2 diffusion flux taken at (after) 100 years",
                "value": 687.6511
            },
            "co2_preimp": {
                "name": "Preimpoundment CO2 emissions",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "CO2 emission in the area covered by the reservoir prior to impoundment",
                "value": -387.5667
            },
            "co2_minus_nonanthro": {
                "name": "CO2 emission minus non-anthropogenic",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "CO2 emissions minus non-anthropogenic over a number of years",
                "value": 314.3491
            },
            "co2_net": {
                "name": "Net CO2 emission",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "Overall integrated emissions for lifetime",
                "value": 701.9157
            },
            "co2_total_per_year": {
                "name": "Total CO2 emission per year",
                "gas_name": "CO2",
                "unit": "tCO2eq yr-1",
                "long_description": "Total CO2 emission per year integrated over lifetime",
                "value": 31020.4636
            },
            "co2_total_lifetime": {
                "name": "Total CO2 emission per lifetime",
                "gas_name": "CO2",
                "unit": "tCO2eq",
                "long_description": "Total CO2 emission integrated over lifetime",
                "value": 3102.0464
            },
            "co2_profile": {
                "name": "CO2 emission profile",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "CO2 emission per year for a defined list of years",
                "value": [
                    2843.0876,
                    1547.9414,
                    1170.0876,
                    869.491,
                    723.0157,
                    630.3555,
                    564.3022,
                    492.6117,
                    440.1145,
                    387.5667
                ]
            },
            "ch4_diffusion": {
                "name": "CH4 emission via diffusion",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "CH4 emission via diffusion integrated over a number of years.",
                "value": 230.9829
            },
            "ch4_ebullition": {
                "name": "CH4 emission via ebullition",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "CH4 emission via ebullition",
                "value": 210.6076
            },
            "ch4_degassing": {
                "name": "CH4 emission via degassing",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "CH4 emission via degassing integrated for a number of years",
                "value": 769.7628
            },
            "ch4_preimp": {
                "name": "Pre-impounment CH4 emission",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "Pre-impounment CH4 emission",
                "value": 0.0
            },
            "ch4_net": {
                "name": "Net CH4 emission",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "Net per area CH4 emission",
                "value": 1211.3534
            },
            "ch4_total_per_year": {
                "name": "Total CH4 emission per year",
                "gas_name": "CH4",
                "unit": "tCO2eq yr-1",
                "long_description": "Total CH4 emission per year integrated over lifetime",
                "value": 53534.5514
            },
            "ch4_total_lifetime": {
                "name": "Total CH4 emission per lifetime",
                "gas_name": "CH4",
                "unit": "ktCO2eq",
                "long_description": "Total CH4 emission integrated over lifetime",
                "value": 5353.4551
            },
            "ch4_profile": {
                "name": "CH4 emission profile",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "CH4 emission per year for a defined list of years",
                "value": [
                    3525.4491,
                    3119.3947,
                    2681.0423,
                    1992.5607,
                    1495.951,
                    1137.7407,
                    879.3594,
                    620.2919,
                    461.5845,
                    341.1885
                ]
            },
            "n2o_methodA": {
                "name": "N2O emission, method A",
                "gas_name": "N2O",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "N2O emission, method A",
                "value": 3.6101
            },
            "n2o_methodB": {
                "name": "N2O emission, method B",
                "gas_name": "N2O",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "N2O emission, method B",
                "value": 2.2495
            },
            "n2o_mean": {
                "name": "N2O emission, mean value",
                "gas_name": "N2O",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "N2O emission factor, average of two methods",
                "value": 2.9298
            },
            "n2o_total_per_year": {
                "name": "Total N2O emission per year",
                "gas_name": "N2O",
                "unit": "tCO2eq yr-1",
                "long_description": "Total N2O emission per year integrated over lifetime",
                "value": 159.5443
            },
            "n2o_total_lifetime": {
                "name": "Total N2O emission per lifetime",
                "gas_name": "N2O",
                "unit": "ktCO2eq",
                "long_description": "Total N2O emission integrated over lifetime",
                "value": 15.9544
            },
            "n2o_profile": {
                "name": "N2O emission profile",
                "gas_name": "N2O",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "N2O emission per year for a defined list of years",
                "value": [
                    3.6101,
                    3.6101,
                    3.6101,
                    3.6101,
                    3.6101,
                    3.6101,
                    3.6101,
                    3.6101,
                    3.6101,
                    3.6101
                ]
            }
        },
        "intern_vars": {
            "inflow_p_conc": {
                "name": "Influent total P concentration",
                "unit": "micrograms / L",
                "long_description": "Median influent total phosphorus concentration in micrograms/L entering the reservoir with runoff",
                "value": 119.174
            },
            "retention_coeff": {
                "name": "Retention coefficient",
                "unit": "-",
                "long_description": "",
                "value": 0.3265
            },
            "trophic_status": {
                "name": "Trophic status of the reservoir",
                "unit": "-",
                "long_description": "",
                "value": "eutrophic"
            },
            "inflow_n_conc": {
                "name": "Influent total N concentration",
                "unit": "micrograms / L",
                "long_description": "Median influent total nitrogen concentration in micrograms/L entering the reservoir with runoff",
                "value": 113.8765
            },
            "reservoir_tn": {
                "name": "Reservoir TN concentration",
                "unit": "micrograms / L",
                "long_description": "",
                "value": 76.6063
            },
            "reservoir_tp": {
                "name": "Reservoir TP concentration",
                "unit": "micrograms / L",
                "long_description": "",
                "value": 83.025
            },
            "littoral_area_frac": {
                "name": "Percentage of reservoir's surface area that is littoral",
                "unit": "%",
                "long_description": "",
                "value": 14.1799
            },
            "mean_radiance_lat": {
                "name": "Mean radiance at the reservoir",
                "unit": "kWh m-2 d-1",
                "long_description": "",
                "value": 5.03
            },
            "global_radiance": {
                "name": "Cumulative global horizontal radiance at the reservoir",
                "unit": "kWh m-2 d-1",
                "long_description": "",
                "value": 60.36
            },
            "bottom_temperature": {
                "name": "Bottom (hypolimnion) temperature in the reservoir",
                "unit": "deg C",
                "long_description": "",
                "value": 24.8804
            },
            "bottom_density": {
                "name": "Water density at the bottom of the reservoir",
                "unit": "kg/m3",
                "long_description": "",
                "value": 997.1057
            },
            "surface_temperature": {
                "name": "Surface (epilimnion) temperature in the reservoir",
                "unit": "deg C",
                "long_description": "",
                "value": 28.475
            },
            "surface_density": {
                "name": "Water density at the surface of the reservoir",
                "unit": "kg/m3",
                "long_description": "",
                "value": 996.1283
            },
            "thermocline_depth": {
                "name": "Thermocline depth",
                "unit": "m",
                "long_description": "",
                "value": 1.9326
            },
            "nitrogen_load": {
                "name": "Influent total N load",
                "unit": "kgN / yr-1",
                "long_description": "",
                "value": 111391.8503
            },
            "phosphorus_load": {
                "name": "Influent total P load",
                "unit": "kgP / yr-1",
                "long_description": "",
                "value": 116573.7104
            },
            "nitrogen_downstream_conc": {
                "name": "Downstream TN concentration",
                "unit": "mg / L",
                "long_description": "",
                "value": 0.1123
            }
        }
    },
    "Myitsone": {
        "inputs": {
            "coordinates": {
                "name": "Reservoir coordinates (lat/lon)",
                "unit": "deg",
                "value": [
                    25.715,
                    97.535
                ]
            },
            "id": {
                "name": "Reservoir ID",
                "unit": "",
                "value": 4
            },
            "type": {
                "name": "Reservoir type",
                "unit": "",
                "value": "unknown"
            },
            "monthly_temps": {
                "name": "Monthly Temperatures",
                "unit": "deg C",
                "value": [
                    15.9,
                    17.7,
                    21.5,
                    24.2,
                    26.2,
                    26.8,
                    26.6,
                    27.0,
                    26.7,
                    24.7,
                    20.6,
                    16.9
                ]
            },
            "year_profile": {
                "name": "Year vector for emission profiles",
                "unit": "yr",
                "value": [
                    1,
                    5,
                    10,
                    20,
                    30,
                    40,
                    50,
                    65,
                    80,
                    100
                ]
            },
            "gasses": {
                "name": "Calculated gas emissions",
                "unit": "-",
                "value": [
                    "co2",
                    "ch4",
                    "n2o"
                ]
            },
            "biogenic_factors": {
                "name": "Biogenic factors",
                "biome": {
                    "name": "Biome",
                    "unit": "",
                    "value": "tropical moist broadleaf"
                },
                "climate": {
                    "name": "Climate",
                    "unit": "",
                    "value": "temperate"
                },
                "soil_type": {
                    "name": "Soil Type",
                    "unit": "",
                    "value": "mineral"
                },
                "treatment_factor": {
                    "name": "Treatment Factor",
                    "unit": "",
                    "value": "primary (mechanical)"
                },
                "landuse_intensity": {
                    "name": "Landuse Intensity",
                    "unit": "",
                    "value": "low intensity"
                }
            },
            "catchment_inputs": {
                "name": "Inputs for catchment-level process calculations",
                "runoff": {
                    "name": "Annual runoff",
                    "unit": "mm/year",
                    "value": 2930.0
                },
                "area": {
                    "name": "Catchment area",
                    "unit": "km2",
                    "value": 24259.371
                },
                "riv_length": {
                    "name": "Length of inundated river",
                    "unit": "km",
                    "value": 107.451
                },
                "population": {
                    "name": "Population",
                    "unit": "capita",
                    "value": 99161.0
                },
                "area_fractions": {
                    "name": "Area fractions",
                    "unit": "-",
                    "value": "0.0, 0.002, 0.0, 0.0, 0.003, 0.007, 0.731, 0.256, 0.0"
                },
                "slope": {
                    "name": "Mean catchment slope",
                    "unit": "%",
                    "value": 49.0
                },
                "precip": {
                    "name": "Mean annual precipitation",
                    "unit": "mm/year",
                    "value": 1430.0
                },
                "etransp": {
                    "name": "Mean annual evapotranspiration",
                    "unit": "mm/year",
                    "value": 817.0
                },
                "soil_wetness": {
                    "name": "Soil wetness",
                    "unit": "mm over profile",
                    "value": 155.0
                },
                "mean_olsen": {
                    "name": "Soil Olsen P content",
                    "unit": "kgP/ha",
                    "value": 8.036
                }
            },
            "reservoir_inputs": {
                "name": "Inputs for reservoir-level process calculations",
                "volume": {
                    "name": "Reservoir volume",
                    "unit": "m3",
                    "value": 9815314935.0
                },
                "area": {
                    "name": "Reservoir area",
                    "unit": "km2",
                    "value": 264.225
                },
                "max_depth": {
                    "name": "Maximum reservoir depth",
                    "unit": "m",
                    "value": 122.0
                },
                "mean_depth": {
                    "name": "Mean reservoir depth",
                    "unit": "m",
                    "value": 37.1
                },
                "area_fractions": {
                    "name": "Inundated area fractions",
                    "unit": "-",
                    "value": "0.0, 0.0, 0.0, 0.018, 0.008, 0.098, 0.35, 0.523, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.003, 0.0, 0.0, 0.0, 0.0, 0.0"
                },
                "soil_carbon": {
                    "name": "Soil carbon in inundated area",
                    "unit": "kgC/m2",
                    "value": 6.77
                },
                "mean_radiance": {
                    "name": "Mean monthly horizontal radiance",
                    "unit": "kWh/m2/d",
                    "value": 4.353
                },
                "mean_radiance_may_sept": {
                    "name": "Mean monthly horizontal radiance: May - Sept",
                    "unit": "kWh/m2/d",
                    "value": 4.103
                },
                "mean_radiance_nov_mar": {
                    "name": "Mean monthly horizontal radiance: Nov - Mar",
                    "unit": "kWh/m2/d",
                    "value": 4.476
                },
                "mean_monthly_windspeed": {
                    "name": "Mean monthly wind speed",
                    "unit": "m/s",
                    "value": 0.99
                },
                "water_intake_depth": {
                    "name": "Water intake depth below surface",
                    "unit": "m",
                    "value": null
                }
            }
        },
        "outputs": {
            "co2_diffusion": {
                "name": "CO2 diffusion flux",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "Total CO2 emissions from a reservoir integrated over lifetime",
                "value": 556.6722
            },
            "co2_diffusion_nonanthro": {
                "name": "Nonanthropogenic CO2 diffusion flux",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "CO2 diffusion flux taken at (after) 100 years",
                "value": 382.0322
            },
            "co2_preimp": {
                "name": "Preimpoundment CO2 emissions",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "CO2 emission in the area covered by the reservoir prior to impoundment",
                "value": -172.59
            },
            "co2_minus_nonanthro": {
                "name": "CO2 emission minus non-anthropogenic",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "CO2 emissions minus non-anthropogenic over a number of years",
                "value": 174.6401
            },
            "co2_net": {
                "name": "Net CO2 emission",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "Overall integrated emissions for lifetime",
                "value": 347.2301
            },
            "co2_total_per_year": {
                "name": "Total CO2 emission per year",
                "gas_name": "CO2",
                "unit": "tCO2eq yr-1",
                "long_description": "Total CO2 emission per year integrated over lifetime",
                "value": 91746.8696
            },
            "co2_total_lifetime": {
                "name": "Total CO2 emission per lifetime",
                "gas_name": "CO2",
                "unit": "tCO2eq",
                "long_description": "Total CO2 emission integrated over lifetime",
                "value": 9174.687
            },
            "co2_profile": {
                "name": "CO2 emission profile",
                "gas_name": "CO2",
                "unit": "gCO2eq m-2 yr-1",
                "long_description": "CO2 emission per year for a defined list of years",
                "value": [
                    1536.7817,
                    817.249,
                    607.3281,
                    440.3284,
                    358.9524,
                    307.474,
                    270.7774,
                    230.9489,
                    201.7835,
                    172.59
                ]
            },
            "ch4_diffusion": {
                "name": "CH4 emission via diffusion",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "CH4 emission via diffusion integrated over a number of years.",
                "value": 110.8754
            },
            "ch4_ebullition": {
                "name": "CH4 emission via ebullition",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "CH4 emission via ebullition",
                "value": 35.7704
            },
            "ch4_degassing": {
                "name": "CH4 emission via degassing",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "CH4 emission via degassing integrated for a number of years",
                "value": 441.2296
            },
            "ch4_preimp": {
                "name": "Pre-impounment CH4 emission",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "Pre-impounment CH4 emission",
                "value": 0.0
            },
            "ch4_net": {
                "name": "Net CH4 emission",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "Net per area CH4 emission",
                "value": 587.8754
            },
            "ch4_total_per_year": {
                "name": "Total CH4 emission per year",
                "gas_name": "CH4",
                "unit": "tCO2eq yr-1",
                "long_description": "Total CH4 emission per year integrated over lifetime",
                "value": 155331.3867
            },
            "ch4_total_lifetime": {
                "name": "Total CH4 emission per lifetime",
                "gas_name": "CH4",
                "unit": "ktCO2eq",
                "long_description": "Total CH4 emission integrated over lifetime",
                "value": 15533.1387
            },
            "ch4_profile": {
                "name": "CH4 emission profile",
                "gas_name": "CH4",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "CH4 emission per year for a defined list of years",
                "value": [
                    1862.7299,
                    1638.9362,
                    1397.3415,
                    1017.8895,
                    744.1857,
                    546.7597,
                    404.3536,
                    261.569,
                    174.0974,
                    107.7409
                ]
            },
            "n2o_methodA": {
                "name": "N2O emission, method A",
                "gas_name": "N2O",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "N2O emission, method A",
                "value": 0.004
            },
            "n2o_methodB": {
                "name": "N2O emission, method B",
                "gas_name": "N2O",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "N2O emission, method B",
                "value": 0.0032
            },
            "n2o_mean": {
                "name": "N2O emission, mean value",
                "gas_name": "N2O",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "N2O emission factor, average of two methods",
                "value": 0.0036
            },
            "n2o_total_per_year": {
                "name": "Total N2O emission per year",
                "gas_name": "N2O",
                "unit": "tCO2eq yr-1",
                "long_description": "Total N2O emission per year integrated over lifetime",
                "value": 1.0454
            },
            "n2o_total_lifetime": {
                "name": "Total N2O emission per lifetime",
                "gas_name": "N2O",
                "unit": "ktCO2eq",
                "long_description": "Total N2O emission integrated over lifetime",
                "value": 0.1045
            },
            "n2o_profile": {
                "name": "N2O emission profile",
                "gas_name": "N2O",
                "unit": "g CO2eq m-2 yr-1",
                "long_description": "N2O emission per year for a defined list of years",
                "value": [
                    0.004,
                    0.004,
                    0.004,
                    0.004,
                    0.004,
                    0.004,
                    0.004,
                    0.004,
                    0.004,
                    0.004
                ]
            }
        },
        "intern_vars": {
            "inflow_p_conc": {
                "name": "Influent total P concentration",
                "unit": "micrograms / L",
                "long_description": "Median influent total phosphorus concentration in micrograms/L entering the reservoir with runoff",
                "value": 8.1076
            },
            "retention_coeff": {
                "name": "Retention coefficient",
                "unit": "-",
                "long_description": "",
                "value": 0.0996
            },
            "trophic_status": {
                "name": "Trophic status of the reservoir",
                "unit": "-",
                "long_description": "",
                "value": "eutrophic"
            },
            "inflow_n_conc": {
                "name": "Influent total N concentration",
                "unit": "micrograms / L",
                "long_description": "Median influent total nitrogen concentration in micrograms/L entering the reservoir with runoff",
                "value": 0.0441
            },
            "reservoir_tn": {
                "name": "Reservoir TN concentration",
                "unit": "micrograms / L",
                "long_description": "",
                "value": 0.0396
            },
            "reservoir_tp": {
                "name": "Reservoir TP concentration",
                "unit": "micrograms / L",
                "long_description": "",
                "value": 7.3314
            },
            "littoral_area_frac": {
                "name": "Percentage of reservoir's surface area that is littoral",
                "unit": "%",
                "long_description": "",
                "value": 5.5383
            },
            "mean_radiance_lat": {
                "name": "Mean radiance at the reservoir",
                "unit": "kWh m-2 d-1",
                "long_description": "",
                "value": 4.353
            },
            "global_radiance": {
                "name": "Cumulative global horizontal radiance at the reservoir",
                "unit": "kWh m-2 d-1",
                "long_description": "",
                "value": 52.236
            },
            "bottom_temperature": {
                "name": "Bottom (hypolimnion) temperature in the reservoir",
                "unit": "deg C",
                "long_description": "",
                "value": 21.1383
            },
            "bottom_density": {
                "name": "Water density at the bottom of the reservoir",
                "unit": "kg/m3",
                "long_description": "",
                "value": 997.9921
            },
            "surface_temperature": {
                "name": "Surface (epilimnion) temperature in the reservoir",
                "unit": "deg C",
                "long_description": "",
                "value": 26.775
            },
            "surface_density": {
                "name": "Water density at the surface of the reservoir",
                "unit": "kg/m3",
                "long_description": "",
                "value": 996.6054
            },
            "thermocline_depth": {
                "name": "Thermocline depth",
                "unit": "m",
                "long_description": "",
                "value": 2.519
            },
            "nitrogen_load": {
                "name": "Influent total N load",
                "unit": "kgN / yr-1",
                "long_description": "",
                "value": 3132.4125
            },
            "phosphorus_load": {
                "name": "Influent total P load",
                "unit": "kgP / yr-1",
                "long_description": "",
                "value": 576287.4307
            },
            "nitrogen_downstream_conc": {
                "name": "Downstream TN concentration",
                "unit": "mg / L",
                "long_description": "",
                "value": 0.0001
            }
        }
    }
}
@endjson
