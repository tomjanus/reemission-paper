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
#highlight "reservoir_tp" / "include"
trophic_status:
  include: True
  name: "Trophic status of the reservoir"
  name_latex: "Trophic status of the reservoir"
  unit: "-"
  unit_latex: "-"
  long_description: ""
  hint: ""
reservoir_tp:
  include: True
  name: "Reservoir TP concentration"
  name_latex: "Reservoir TP concentration"
  unit: "micrograms / L"
  unit_latex: "$\\mu$g L$^{-1}$"
  long_description: ""
  hint: ""
nitrogen_downstream_conc:
  include: True
  name: "Downstream TN concentration"
  name_latex: "Downstream TN concentration"
  unit: "mg / L"
  unit_latex: "mg L$^{-1}$"
  long_description: ""
  hint: ""
other_variables: "..."
@endyaml
