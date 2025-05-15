@startyaml
<style>
yamlDiagram {
    highlight {
      BackGroundColor #d8e2f2
      FontColor #40454d
      FontStyle italic
    }
}
</style>
#highlight "CARBON_DIOXIDE"
#highlight "CALCULATIONS"
#highlight "CARBON_DIOXIDE" / "weight_CO2"
#highlight "CALCULATIONS" / "eps_catchment_area_fractions"
#highlight "CALCULATIONS" / "p_export_cal"
CARBON_DIOXIDE:
  k1_diff: 1.860
  weight_CO2: 44
  conv_coeff: 3.667
  other_parameters: "..."

METHANE:
  k1_diff: 0.8032
  k1_ebull: -1.3104
  conv_coeff: 16.55
  other_parameters: "..."

NITROUS_OXIDE:
  conv_coeff: 0.170924
  nitrous_gwp100: 298.0
  other_parameters: "..."

CALCULATIONS:
  eps_catchment_area_fractions: 0.01
  ret_coeff_method: "empirical"
  p_export_cal: "g-res"
  other_parameters: "..."
@endyaml
