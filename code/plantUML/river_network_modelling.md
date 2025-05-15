@startuml
skinparam packageStyle frame
skinparam shadowing false
skinparam handwritten false
skinparam monochrome false

skinparam class {
    BackgroundColor<<future>> White
    BorderColor<<future>> Gray
    BorderStyle<<future>> Dashed
}

package "remission" { 

package "river network" {
class River <<future>> {
 + flow : float
 + tn : float
 + tp : float
 + toc : float
 + cod : float
 + bod5 : float
 + tss : float
 + vss : float
}

class Reservoir {
  +coordinates: Tuple[float, float]
  +temperature : MonthlyTemperature
  +volume: float
  +max_depth: float
  +mean_depth: float
  +inflow_rate: float
  +area: float
  +soil_carbon: float
  +area_fractions: List[float]
  +mean_radiance: float
  +mean_radiance_may_sept: float
  +mean_radiance_nov_mar: float
  +mean_monthly_windspeed: float
  +water_intake_depth: float
  +name: str
  -- --
  +residence_time() : float
  +q_bath_shape() : float
  +littoral_area_frac() : float
  +thermocline_depth(wind_speed: Optional[float], wind_height: float) : float
  +retention_coeff(method: str) : float
  +reservoir_conc(inflow_conc: float, method: Optional[str]) : float
  +trophic_status(tp_inflow_conc: float, as_value: bool) : Enum|str]
  -- (other methods not shown) --
}

class Catchment {
  +area: float: float
  +riv_length: float
  +runoff: float
  +population: int
  +slope: float
  +precip: float
  +etransp: float
  +soil_wetness: float
  +mean_olsen: float
  +area_fractions: List[float]
  +biogenic_factors: BiogenicFactors
  +name: str
  -- --
  +population_density() : float
  +landuse_area(landuse_fraction: float) : float
  +discharge() : float
  +river_area_before_impoundment(river_width: Optional[float]) : float
  +inflow_p_conc(method: str) : float
  +inflow_n_conc() : float
  +nitrogen_load() : float
  +phosphorus_load(method: str) : float
  -- (other methods not shown) --
}

}

class BiogenicFactors <<external>> {
  +biome : Biome
  +climate : Climate
  +soil_type : SoilType
  +treatment_factor : TreatmentFactor
  +landuse_intensity : LanduseIntensity
}

class MonthlyTemperature << external >> {
  temp_profile: List[float]
  + eff_temp(gas: str): float
  + coldest(): float
  + mean_warmest(number_of_months: int): float
}

package "remission.constants" {
    enum Climate {
        BOREAL
        SUBTROPICAL
        TEMPERATE
        TROPICAL
        UNKNOWN
    }

    enum TrophicStatus {
      OLIGOTROPHIC
      MESOTROPHIC
      EUTROPHIC
      HYPER_EUTROPHIC
    }

    enum Biome {
        DESERTS
        MEDFORESTS
        MONTANEGRASSLANDS
        TEMPERATEBROADLEAFANDMIXED
        TEMPERATECONIFER
        TEMPERATEGRASSLANDS
        TROPICALDRYBROADFLEAF
        TROPICALGRASSLANDS
        TROPICALMOISTBROADLEAF
        TUNDRA
    }

    enum Landuse {
      BARE
      SNOW_ICE
      URBAN
      WATER
      WETLANDS
      CROPS
      SHRUBS
      FOREST
      NODATA
    }

    enum LanduseIntensity {
        LOW
        HIGH
    }

    enum SoilType {
        MINERAL
        ORGANIC
        NODATA
    }

    enum TreatmentFactor {
        NONE
        PRIMARY
        SECONDARY
        TERTIARY
    }

}

Reservoir --> MonthlyTemperature : has
Reservoir ..> Landuse : uses
Reservoir ..> TrophicStatus : returns
Catchment --> BiogenicFactors : has
Catchment ..> Landuse : uses
BiogenicFactors --> Biome : has
BiogenicFactors --> Climate : has
BiogenicFactors --> SoilType : has
BiogenicFactors --> TreatmentFactor : has
BiogenicFactors --> LanduseIntensity : has
River --> MonthlyTemperature : has
}

}
@enduml
