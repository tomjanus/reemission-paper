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
#highlight "monthly_temps" / "unit_latex"
#highlight "catchment_inputs" / "var_dict"
monthly_temps:
  include: true
  name: "Monthly Temperatures"
  long_description: ""
  unit: "deg C"
  unit_latex: "$^o$C"
catchment_inputs:
  include: true
  name: "Inputs for catchment-level process calculations"
  long_description: ""
  var_dict:
    runoff:
      name: "Annual runoff"
      unit: "mm/year"
      unit_latex: "mm/year"
    area:
      name: "Catchment area"
      unit: "km2"
      unit_latex: "km$^2$"
    other_variables: "..."
print_long_descriptions: false
other_variables: "..."
@endyaml
