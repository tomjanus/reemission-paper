@startuml
skinparam packageStyle frame
skinparam shadowing true
skinparam handwritten false
skinparam monochrome false
skinparam artifactBackgroundColor #E6F0FA
allowmixing

package "reemission" {

package "reemission.presenter" {
  class Presenter {
    +inputs: Inputs
    +outputs: Dict
    +internal_vars: Dict
    +writers: List[Writer]
    ...
    +output() : None
  }
  abstract Writer {
    +write() : None
  }

class ExcelWriter {
  +write() : None
}

class JSONWriter {
  +write() : None
}

class LatexWriter {
  +write() : None
}

class HTMLWriter {
  +write() : None
}

artifact "Presentation Config:\n- inputs.yaml\n- outputs.yaml\n- parameters.yaml\n- internal_vars.yaml" as PresentationConfig

}



package "reemission.input" {
  class Inputs {
    +inputs: Dict[str, Input]
    +add_input(input_dict: Dict[str, dict]) : None
    +get_catchments() : List[Catchment]
    +get_reservoirs() : List[Reservoir]
  }
  class Catchment {
    +name: str
    ...
  }
  class Reservoir {
    +name: str
    ...
  }
  class Input {
    +name: str
    +data: Dict
  }
}

package "reemission.model" {
  class EmissionModel {
    +inputs: Inputs
    +config: dict
    +presenter: Presenter
    ...
    +calculate() : None
    +get_outputs(): dict
    +get_inputs(): Inputs
    +get_internal_vars(): dict
  }
}

package "reemission.emissions" {
  abstract class Emission {
    +catchment: Catchment
    +reservoir: Reservoir
    +preinund_area: float or None
    +config
    +factor(num_years: int) : float
    +profile(years: List[int]): List[float]
    +total_emission_per_year(num_years: int) : float
    +total_lifetime_emission(num_years: int) : float
  }

  class MethaneEmission {
  }

  class CO2Emission {
  }

  class N2OEmission {
  }



artifact "Model Config:\n- config.ini" as ModelConfig


}

artifact "App Config:\n- app_config.yaml" as AppConfig

}

Presenter ..> PresentationConfig : config
Emission ..> ModelConfig : config

EmissionModel ..> Inputs : uses
Inputs --> Input : has
EmissionModel ..> Presenter : uses
EmissionModel "1" *-- "1..*" Emission : instantiates
Inputs "1" -- "0..*" Catchment : provides
Inputs "1" -- "0..*" Reservoir : provides
Emission ..> Catchment : uses
Emission ..> Reservoir : uses
Presenter "1" *-- "0..*" Writer : uses

Writer <|-- ExcelWriter : extends
Writer <|-- JSONWriter : extends  
Writer <|-- LatexWriter : extends
Writer <|-- HTMLWriter : extends

Emission <|-- MethaneEmission : extends
Emission <|-- CO2Emission : extends
Emission <|-- N2OEmission : extends  


@enduml
