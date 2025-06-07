@startuml
' Extremely vertical architectural view of RE-Emission
skinparam shadowing true
' skinparam linetype polyline
' skinparam ArrowColor #666666
skinparam packageStyle folder
skinparam DefaultTextAlignment center
' skinparam linetype ortho
' skinparam Nodesep 10
' skinparam Ranksep 20

skinparam rectangle {
  BorderColor #f7ab05
  BackgroundColor #F9EED6
  BorderThickness 1
}

' Vertical top-down direction with aggressive vertical compression
top to bottom direction

' Architectural packages
frame "Re-Emission System Architecture" {
    package "Helper Functions" as helpers {
      package "reemission.utils" as utils
      package "reemission.auxiliary" as aux
'      package "reemisison.mixins" as mixins
'      package "reemission.constants" as constants
    }
    package "ReEmission Engine and I/O" as reemission {
      rectangle "Core Engine" as core {
        package "reemission.model" as model
        package "reemission.emissions" as emissions
        package "reemission.profile" as profile
      }

      package "reemission.input" as input
      package "reemission.registry" as registry
      package "reemission.presenter" as presentation
      
    }
}

' Dependencies with vertical emphasis
' config -[hidden]down-> input
input -[hidden]down-> emissions
emissions -[hidden]down-> profile
' profile -[hidden]down-> presentation

input --> model : provides data
model --> emissions : computes
model --> profile : computes
model --> presentation : provides data
helpers ..> reemission : supports
presentation ..> profile : uses
registry --> core: provides data
registry --> presentation : provides data

' Annotation
note bottom of model
  Central coordination of the
  emissions estimation workflow
end note

@enduml
