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
#highlight "global"
#highlight "global" / "plot_profiles"
#highlight "global" / "plot_landcover_piecharts"
global:
  print_long_descriptions: False
  plot_profiles: True
  plot_emission_bars: True
  plot_landcover_piecharts: True
outputs:
  co2_diffusion:
    include: True
    name: "CO2 diffusion flux"
    gas_name: "CO2"
    name_latex: "CO$_2$ diffusion flux"
    unit: "gCO2eq m-2 yr-1"
    unit_latex: "gCO$_{2,eq}$ m$^{-2}$ yr$^{-1}$"
    long_description: "Total CO2 emissions from a reservoir integrated over lifetime"
    hint: ""
  ch4_degassing:
    include: True
    name: "CH4 emission via degassing"
    gas_name: "CH4"
    name_latex: "CH$_4$ emission via degassing"
    unit: "g CO2eq m-2 yr-1"
    unit_latex: "gCO$_{2,eq}$ m$^{-2}$ yr$^{-1}$"
    long_description: "CH4 emission via degassing integrated for a number of years"
    hint: "The default time horizon is 100 years"
  other_variables: "..."
other_variables: "..."
@endyaml


