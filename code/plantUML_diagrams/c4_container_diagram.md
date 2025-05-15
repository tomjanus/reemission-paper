@startuml
!theme plain
skinparam shadowing true
!define C4P https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master
!includeurl C4P/C4_Container.puml

Person(user, "Reservoir Emission Modeller", "Runs analyses via CLI or as a library")  

System_Boundary(reemission_sys, "Re-Emission") {
    Container(cli, "CLI Tool", "Click/Python", "Commands `reemission` & `reemission-geocaret`")  
    Container(config_loader, "Configuration Loader", "Python", "Reads model & output settings from YAML and .INI")
    Container(input_handler, "Input Handler", "Python", "Parses JSON/CSV input into `Inputs` objects")  
    Container(core_lib, "Core Library", "Python", "Executes `EmissionModel.calculate()`")  
    Container(output_generator, "Output Generator", "Python", "Formats & writes Excel, JSON, HTML PDF reports")
}

ContainerDb(filesystem, "File System", "JSON, YAML, XLSX, LaTeX, PDF, HTML", "Stores inputs, configs & outputs")

' Relationships (horizontal layout)
Rel(user, cli, "Invokes")
Rel(cli, config_loader, "Loads `config/*.yaml` and `config/*.ini`")
Rel(cli, input_handler, "Loads input via `Inputs.fromfile(...)`")
Rel(config_loader, core_lib, "Injects model parameters")
Rel(input_handler, core_lib, "Supplies `Inputs` instances")
Rel(core_lib, output_generator, "Delivers results dict")
Rel(output_generator, user, "Writes reports to disk")

Rel(config_loader, filesystem, "Reads YAML and .INI config files")
Rel(input_handler, filesystem, "Reads input files")
Rel(output_generator, filesystem, "Writes output files")
@enduml
