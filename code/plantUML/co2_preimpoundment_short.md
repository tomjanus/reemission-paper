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

#highlight "boreal" / "mineral"
#highlight "boreal" / "organic"

boreal:
  mineral:
    bare: 0.0
    crops: 0.0
    forest: -0.4
    shrubs: 0.0
    urban: 0.0
    wetlands: 0.0
  organic:
    bare: 2.8
    crops: 7.9
    forest: 0.6
    shrubs: 5.7
    urban: 6.4
    wetlands: -0.5
subtropical:
  mineral:
    bare: 0.0
    "other land covers": "..."
  organic:
    bare: 2.0
    "other land covers": "..."
temperate:
  mineral:
    bare: 0.0
    "other land covers": "..."
  organic:
    bare: 2.8
    "other land covers": "..."
tropical:
  mineral:
    bare: 0.0
    other_variables: "..."
  organic:
    bare: 2.0
    "other land covers": "..."
@endyaml@startyaml
