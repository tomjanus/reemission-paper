#  10-06-2025 
library(pracma)
library(jsonlite)
library(dplyr)
library(readr)
library(purrr)
library(tidyr)
library(tidyverse)
library(stringr)
library(tibble)
library(rrapply)
library(ggrepel)
library(patchwork)
rmlist=(ls)

##############################################################################################################################################
######----calculation of reservoir ghg emissions via application of Gres submodels and Gres approach----###################################### 
## res-catchment data derived via geocaret 
## submodel specification as per Harrison et al. 2021; see supplementary materials,
## and Gres technical documentation v.3:
## https://agupubs.onlinelibrary.wiley.com/doi/10.1029/2020GB006888
## https://g-res.hydropower.org/guidance-documents/ 
## see also Prairie et al. 2021
##############################################################################################################################################

# working directory for input / output files

setwd("/home/lepton/Documents/git_projects/reemission-paper/code/R/cbarry/")
list.files("/home/lepton/Documents/git_projects/reemission-paper/code/R/cbarry/")

# read in input data;  here we use "validation_inputs.json", first converted to csv externally
# https://www.convertcsv.com/json-to-csv.htm
# 249 Myanmar and UK dams

dd <- read.csv("validation_inputs.csv" , header = TRUE)
dd
#dd[,1]		# reservoir names
#colnames(dd)
#str(dd)

#heet output csv input file specifications
#dd_param_descr <- read.csv("N:/PROJECTS/FutureDams/R calc checks Jul2023/99_output_specification.csv" , header = TRUE)
###############################################################################################################################################

###############################################################################################################################################
##########------------------- Script contents -----------------------####################################################

#### 1. CO2 emissions
# 1.1.1  Effective temperature for CO2
# 1.1.2  hydrological parameters (water residence time; annual discharge; Phosphorus retention coeffs)
# 1.1.3  Compute annual total phosphorus loading to reservoirs; and reservoir TP concentrations
# 1.1.3b Compute annual total phosphorus loading to reservoirs; and reservoir TP concentrations - McDowell TP
### 1.2 calculate emissions
# 1.2.1 Diffusive CO2 emissions, by year  - emissions profiles;  yr100 - taken as non-anthropogenic flux 
# 1.2.2 gross and net (gross -non.anthro yr100) integrated lifetime emissions(100 years)
#    - the mean annual flux for 100 years
# 1.2.3 Account for preimpoundment emissions 

#### 2. CH4 emissions
# 2.1 Diffusive emission
# 2.2 Ebullition
# 2.3 Degassing Emission (hpower)
# 2.4 compute preimpoundment CH4 emission

#### 3. N20 Emissions 
# 3.1 approach 1 (default Scenario 1; DS1)
# 3.2 approach 2 (defailt Scenario 2; DS2)
# 3.3 Estimation of Downstream TN flux & mean outflow concentration

#### 4. Compile output tables and plots
# 4.1 Tabularise some key input and derived parameters
# 4.2 Tabularise GHG emission outputs
# 4.3 Plot some emission profiles

###############################################################################################################################################
###############################################################################################################################################
### 1. CO2 diffusive emissions

## 1.1. compute CO2 sub-model input data
# 1.1.1 Effective temperature for CO2
 
# monthly temps
monthly_temp_cols <- grep("^monthly_temps\\.\\d+$", names(dd), value = TRUE)

# Calc. CO2 effective and mean annual temperature
dd <- dd %>%
  rowwise() %>%
  mutate(
    EFtempsCO2 = log10(mean(
      c_across(all_of(monthly_temp_cols)) %>%
        purrr::map_dbl(~ 10^(as.numeric(.x) * 0.05))
    )) / 0.05,   
    meanAnntemp = mean(
      c_across(all_of(monthly_temp_cols)) %>%
        as.numeric()
    )
  ) %>%
  ungroup()
dd
###############################################################################################################################################
#### 1.1.2  hydrological parameters (water residence time; annual discharge; Phosphorus retention coeffs)

### Most accurate runoff data appears to be for terraclim: heet code: c_mar_mm_alt2; 
###  (Fekete; "c_mar_mm" is Gres default)

### Gres TP retention - "RetentionCoeffs.gres"
# Larsen, DP and Mercier, HT. 1976. Phosphorus retention capacity of lakes. 
# Journal of the Fisheries Research Board of Canada 33:1742-1750
# Revised TP retention for Reservoirs - Maavara et al. (2015) https://doi.org/10.1073/pnas.1511797112

dd <- dd %>%
  mutate(
    checkVol.m3 = reservoir.area * reservoir.mean_depth * 1e6,
    annualdischarge.m3 = catchment.runoff * catchment.area * 1e3,
    WaterResid.yrs = reservoir.volume / annualdischarge.m3,
# Phosphorus retention coefficients
    RetentionCoeffs = 1 - (1 / (1 + (0.801 * WaterResid.yrs))),
    RetentionCoeffs.gres = 1 / (1 + (1 / sqrt(WaterResid.yrs))),
# Mean annual discharge in m³/s
    meanannualdischarge.m3s = annualdischarge.m3 / (365.25 * 24 * 60 * 60)
)

# checkVol.m3'reservoir.volume' greater than computed, as 'reservoir.mean_depth' only reported to 1dp

par(mfrow=c(3,2))
plot(log10(dd$meanannualdischarge.m3s))
plot(dd$RetentionCoeffs.gres ~ dd$RetentionCoeffs)
plot(dd$WaterResid.yrs ~log10(dd$meanannualdischarge.m3s))
plot(dd$RetentionCoeffs ~ dd$WaterResid.yrs)
points(dd$RetentionCoeffs.gres ~ dd$WaterResid.yrs, col = "red")
hist(dd$WaterResid.yrs)
hist(dd$RetentionCoeffs)

# reemission internals - same non-Gres retention coeffs, so Tw matches....
# which means res volume and annual discharge match, which means runoff matches

###############################################################################################################################################
######## 1.1.3  Compute annual total phosphorus loading to reservoirs; and reservoir TP concentrations
# Gres -  export coefficient approach + per capita excreta P loading 
# Prairie and Kalff (1986) Effect of catchment size on phosphorus export. Water Resources Bulletin. vol 22:3

# set up land cover coefficients; units are kg P ha-1 yr-1
# If national or regional or local export coefficients have been derived, these would be considered more accurate and should be used to compute the annual P loading
# two coeffs are given for grassland/pasture land cover - one pertains to 'low land use intensity' the other to 'high land use intensity'
#	land use intensity can be set as a configurable option ('high' 'low') - intensively managed pastures are considered 'high' 
#	in this example all grasslands are considered 'low' intensity which may be approximately appropriate for tropical regions where grass production for livestock is less intensive
#	the 'high' pasture coefficient is particularly high and may not be approporiate in many settings.
# 	for crop and forest, land use export coefficents calculated following Prairie & Kalff 1986, water resources bulletin, jawra, 22:3, p465
# 	I have added  columns for Land use intensty and degree of water treatment, but these are not used herein

# LANDSCAPE P EXPORT


levels(as.factor(dd$catchment.biogenic_factors.landuse_intensity))
# "high intensity" "low intensity"

# Vector of fraction column names and corresponding export coefficients
lc_fractions <- paste0("catchment.area_fractions.", 0:8)

export_coeffs <- c(
  Barearea 		= 0.31,
  PermSnowIce 	= 0.15,
  UrbanSettle 	= 2.75,
  Waterbodies 	= 0.0,
  Wetlands 		= 0.1,
  Crop 		= NA,      # calculated later
  Grassland 	= NA,	     # calc later
  Forest 		= NA,    # calculated later
  Nodata 		= 0.0
)

# land class fraction to areas,  km2
catch_areas <- map_dfc(0:8, ~{
  colname <- paste0("catchment.area_fractions.", .x)
  newcol <- paste0("catch.area_", .x, "_km2")
  dd[[newcol]] <- dd[[colname]] * dd$catchment.area
  dd[[newcol]]
}) %>% setNames(paste0("catch.area_", 0:8, "_km2"))

# Add catchment areas to dd
dd <- bind_cols(dd, catch_areas)

# Checksum (check area total)
dd <- dd %>%
  mutate(
    sum_c_LC = rowSums(select(., starts_with("catch.area_"))),
    sum_diff_pct = ((sum_c_LC - catchment.area) / catchment.area) * 100
)
print(dd$sum_c_LC)
plot(dd$sum_diff_pct)

# Extract crop, forest, grass land class areas
crop_area   <- dd$`catch.area_5_km2`
forest_area <- dd$`catch.area_7_km2`
grass_area <- dd$`catch.area_6_km2`

#aa <- data.frame(cbind(cropP ,  dd$catchment.biogenic_factors.landuse_intensity, grass_area, dd$catch.area_6_km2 ))


# Compute grass, crop and forest export coefficients (kg P/ha/yr), with conditional'high' LUI coeffs

cropP <- case_when(
  dd$catchment.biogenic_factors.landuse_intensity == "high intensity" ~ 2.24,
  crop_area > 0 ~ 10^(1.818 - 0.227 * log10(crop_area))/100 ,
  TRUE ~ 0
)

forestP <- case_when(
  dd$catchment.biogenic_factors.landuse_intensity == "high intensity" ~ 0.41,
  forest_area > 0 ~ 10^(0.914 - 0.014 * log10(forest_area)) / 100,
  TRUE ~ 0
)

grassP <- case_when(
  dd$catchment.biogenic_factors.landuse_intensity == "high intensity" ~ 42.86,
  grass_area > 0 ~ 0.26,
  TRUE ~ 0
)


# Landscape P export (kg/yr)
dd <- dd %>%
  mutate(
    landscapeP_kgyr = 
      `catch.area_0_km2` *100* export_coeffs["Barearea"] +		#*100 fro km2 >ha 
      `catch.area_1_km2` *100* export_coeffs["PermSnowIce"] +
      `catch.area_2_km2` *100* export_coeffs["UrbanSettle"] +
      `catch.area_3_km2` *100* export_coeffs["Waterbodies"] +
      `catch.area_4_km2` *100* export_coeffs["Wetlands"] +
      crop_area *100* cropP +
      grass_area  *100* grassP +
      forest_area *100* forestP +
      `catch.area_8_km2` *100* export_coeffs["Nodata"]
)

# WASTE WATER P EXPORT  - Human P loading 
# Human P loading; kg yr-1; uses "catchment.population" ; 2g P/person/day
# wastewater treatment level configurable - "catchment.biogenic_factors.treatment_factor"
#	1.0	= no removal; 0.9 = primary-mechanical; 0.3 = secondary-biological treatment; 0.1 = tertiary (e.g. P stripping). 
#     0.9-1.0 can be assumed for areas of developing countries without obvious sewerage.

print(levels(as.factor(dd$catchment.biogenic_factors.treatment_factor)))

dd <- dd %>%
  mutate(
    WWtreat = case_when(
      catchment.biogenic_factors.treatment_factor == "no treatment" ~ 1.0,
      catchment.biogenic_factors.treatment_factor == "primary (mechanical)" ~ 0.9,
      catchment.biogenic_factors.treatment_factor == "secondary biological treatment" ~ 0.3,
      catchment.biogenic_factors.treatment_factor == "tertiary" ~ 0.1,
      TRUE ~ 0
    ),
    
    landuse_warning = case_when(
      is.na(catchment.biogenic_factors.landuse_intensity) | is.nan(catchment.biogenic_factors.landuse_intensity) ~ 
        "no wastewater treatment factor supplied",
      TRUE ~ NA_character_
    ),
    
    humanP_kgyr = catchment.population * 0.002 * 365.25 * WWtreat,
    totalPload.kg = landscapeP_kgyr + humanP_kgyr,
    humP_fract = humanP_kgyr / totalPload.kg,
    totalPexp.kghayr = totalPload.kg / (catchment.area * 100),
    inflowP.ugL = (totalPload.kg * 1e9) / (annualdischarge.m3 * 1e3),
    inflowPlandscape.ugL = (landscapeP_kgyr * 1e9) / (annualdischarge.m3 * 1e3),
    ReservoirTP.ugL = inflowP.ugL * (1 - RetentionCoeffs)
  )


# check pop density 
popdens.km2 <- dd$catchment.population/dd$catchment.area ; hist(popdens.km2)

dd$totalPload.kg
dd$humP_fract
plot(dd$inflowP.ugL) 
plot(dd$inflowP.ugL ~dd$ReservoirTP.ugL)
dd$WWtreat
dd$landscapeP_kgyr
colnames(dd)

aa <- data.frame(cbind( dd$inflowP.ugL))

##############################################################################################################################################
######## 1.1.3b  Compute annual total phosphorus loading to reservoirs; and reservoir TP concentrations

# McDowell global model - APRROACH B - McDowell et al. 2020. https://doi.org/10.1038/s41598-020-60279-w
# set up  model coeffs
# **** median concentrations were derived using data for all months for tropical regions...
# "We focused our data to periods of likely peak growth by fltering data for temperate and polar regions (i.e., 
# regions outside the tropics of Cancer and Capricorn) to values measured from May to October in the Northern 
# Hemisphere and for November to April in the Southern Hemisphere. All data were used to generate medians for 
# tropical regions"
# ------- for non tropical regions the predictors are for 'summer time' ~base-flow concentrations
# no specific per capita excreta P loading specification - impact buried within derived model

# model coeffs
coeffs <- list(
  MDPInt = -4.2396,
  MDOlsenP = 0.01,
  MDMeanMprecip = -0.0062,
  MDMeanslope_pc = -0.0768,
  MDCropland_pc = 0.0075,
  MDpTevapotmeanM = 0.0134,
  MDBiascorrF = 0.855
)

# model Biome coeffs Mapping
levels(as.factor(dd$catchment.biogenic_factors.biome))

biome_coeffs <- c(
  "tropical moist broadleaf"       = 1.0789,
  "temperate coniferous"      = 0.8749,
  "xeric shrub"                    = 1.4481,
  "mediterranean forests"        	 = 1.8352,
  "montane grasslands"			 = 0.5575,
  "temperate broadleaf and mixed" = 0.5216,
  "temperate grasslands"          = 1.0591,
  "tropical grasslands"           = 0.9004,
  "tropical dry broadleaf"        = 0.2002,
  "tundra"                        = 1.9464,
  "deserts"				= 0
)


#dd$catchment.area_fractions.5

# Calculations
dd <- dd %>%
  mutate(
    biome_coeff = biome_coeffs[catchment.biogenic_factors.biome] %>% replace_na(0)%>% unname(),
    
    McD_medianinflowP.ugl = exp(
      coeffs$MDPInt +
        (catchment.mean_olsen * coeffs$MDOlsenP) +
        ((catchment.precip / 12) * coeffs$MDMeanMprecip) +
        (catchment.slope * coeffs$MDMeanslope_pc) +
        ((catchment.area_fractions.5*100) * coeffs$MDCropland_pc) +
        ((catchment.etransp / 12) * coeffs$MDpTevapotmeanM) +
        biome_coeff) * coeffs$MDBiascorrF * 1e3,
# add MDres TP
 		MDReservoirTP.ugL = McD_medianinflowP.ugl * (1 - RetentionCoeffs),
# add preinundation river water area
		preinundRivWaterArea_km2 = (catchment.riv_length * 1000) * 5.9 * catchment.area^0.32 * 1e-6)

print(dd$McD_medianinflowP.ugl)
print(dd$MDReservoirTP.ugL)
print(dd$preinundRivWaterArea_km2)
print(dd$reservoir.area)
plot(dd$inflowP.ugL ~ dd$McD_medianinflowP.ugl) 
dd$biome_coeff


aa <- data.frame(cbind( dd$inflowP.ugL, dd$McD_medianinflowP.ugl))


# Plot inflowP.ugL and label 10 highest and lowest values, plot comparison of P estimates

dd_long <- dd %>%
  select(X_key, inflowP.ugL, McD_medianinflowP.ugl) %>%
  pivot_longer(cols = c(inflowP.ugL, McD_medianinflowP.ugl), names_to = "Variable", values_to = "Value")

# Step 2: Get top/bottom 10 per variable for labeling
dd_labels <- dd_long %>%
  group_by(Variable) %>%
  arrange(Value) %>%
  slice_head(n = 10) %>%
  bind_rows(
    dd_long %>%
      group_by(Variable) %>%
      arrange(desc(Value)) %>%
      slice_head(n = 10)
  )

# Step 3: Plot
ggplot(dd_long, aes(x = Variable, y = Value)) +
  geom_violin(fill = "lightblue", width = 0.6, color = "grey40") +
  geom_jitter(width = 0.2, alpha = 0.6, size = 2, color = "darkblue") +
  geom_text_repel(
    data = dd_labels,
    aes(label = X_key),
    nudge_x = 0.2,
    direction = "y",
    size = 3,
    max.overlaps = 20
  ) +
  labs(
    x = "Variable",
    y = "Phosphorus Concentration (µg/L)",
    title = "Violin Plot of Inflow P Values with Site Labels"
  ) +
  theme_minimal()

#### proceed with use of Gres TP export - approach A; output data for McDowell model for comparison

# pre-inundation river waterbody area "preinundRivWaterArea_km2"
# ~ a correction to the 'new' reservoir area - it is estimated from length of the preinundation river and catchment area
# preinundation waterbody length 'catchment.riv_length';  units are km
# where 'catchment.riv_length' is NA in input file, set to 0

###############################################################################################################################################
##### 1.2 Compute CO2 diffusive fluxes

# 1.2.1 CO2 diffusive fluxes by year - emission profiles

# units    mg CO2-C m-2 d-1 ; 
# here for years = x = 1, 5, 10, 20, 30, 40, 50, 65, 80, 100 
# year 100 flux = non-anthropogenic flux

#### compute emissions by year
## output using McDowell TP included; 
## this exercise could be repeated using the original Gres P retention coefficient formulation also

# Constants
constantCO2 <- list(
  intercept = 1.8569682,
  age       = -0.329955,
  temp      = 0.0332459,
  resArea   = 0.0799146,
  soilC     = 0.015512,
  ResTP     = 0.2263344
)

# Year vector
year_vector <- c(yr1 = 1, yr5 = 5, yr10 = 10, yr20 = 20, yr30 = 30,
  			yr40 = 40, yr50 = 50, yr65 = 65, yr80 = 80, yr100 = 100)

# Pre-compute base and correction terms (for preinundated river area)
dd <- dd %>%
  mutate(
    CO2_base = (EFtempsCO2 * constantCO2$temp) +
               (log10(reservoir.area) * constantCO2$resArea) +
               (reservoir.soil_carbon * constantCO2$soilC) +
               (log10(ReservoirTP.ugL) * constantCO2$ResTP),

    CO2_corr = (1 - (preinundRivWaterArea_km2 / reservoir.area))
)

# Add CO2 fluxes for each year
dd <- bind_cols(dd, purrr::map_dfc(year_vector, function(year) {
  flux <- 10^(
    constantCO2$intercept +
    (log10(year) * constantCO2$age) +
    dd$CO2_base
) * dd$CO2_corr

  tibble(!!paste0("CO2yrdiff_mgCO2Cm2d_yr", year) := flux)
}))

# Compute base term using McDowell TP
dd <- dd %>%
  mutate(
    CO2_base_MD = (EFtempsCO2 * constantCO2$temp) +
                  (log10(reservoir.area) * constantCO2$resArea) +
                  (reservoir.soil_carbon * constantCO2$soilC) +
                  (log10(MDReservoirTP.ugL) * constantCO2$ResTP)
)

# Add McDowell TP-based year-specific CO2 fluxes
dd <- bind_cols(dd, purrr::map_dfc(year_vector, function(year) {
  flux_MD <- 10^(
    constantCO2$intercept +
    (log10(year) * constantCO2$age) +
    dd$CO2_base_MD
  ) * dd$CO2_corr

  tibble(!!paste0("CO2yrdiff_mgCO2Cm2d_yr", year, ".MD") := flux_MD)
}))


#########################################################################################################################
##### 1.2.2 Gross & net integrated emissions for lifetime (100 years) -  the mean annual flux for 100 years
##### Gross - total; net - after subtraction of yr100 emissions

# Conversion factor
factor1 <- 1.33925
calcint <-	-0.329956 

# Compute GROSS and NET integrated emissions, and CO2eq conversions

dd <- dd %>%
  mutate(
# Gross integrated emissions over 100 years (mean annual flux)
    CO2yrdiff_mgCO2Cm2d_GROSSINTEG = 10^(
      constantCO2$intercept +
      (EFtempsCO2 * constantCO2$temp) +
      (log10(reservoir.area) * constantCO2$resArea) +
      (reservoir.soil_carbon * constantCO2$soilC) +
      (log10(ReservoirTP.ugL) * constantCO2$ResTP)
    ) * (1 - (preinundRivWaterArea_km2 / reservoir.area)) *
      ((100^(calcint + 1) - 0.5^(calcint + 1)) / ((calcint + 1) * (100 - 0.5))),

# Net integrated emissions (subtract year-100 value as "non-anthropogenic")
    CO2yrdiff_mgCO2Cm2d_NETINTEG = CO2yrdiff_mgCO2Cm2d_GROSSINTEG - CO2yrdiff_mgCO2Cm2d_yr100,

# CO₂-eq conversions (g CO2eq m⁻² yr⁻¹)
    CO2yrdiff_gCO2eqm2yr_yr1   = CO2yrdiff_mgCO2Cm2d_yr1   * factor1,
    CO2yrdiff_gCO2eqm2yr_yr5   = CO2yrdiff_mgCO2Cm2d_yr5   * factor1,
    CO2yrdiff_gCO2eqm2yr_yr10  = CO2yrdiff_mgCO2Cm2d_yr10  * factor1,
    CO2yrdiff_gCO2eqm2yr_yr20  = CO2yrdiff_mgCO2Cm2d_yr20  * factor1,
    CO2yrdiff_gCO2eqm2yr_yr30  = CO2yrdiff_mgCO2Cm2d_yr30  * factor1,
    CO2yrdiff_gCO2eqm2yr_yr40  = CO2yrdiff_mgCO2Cm2d_yr40  * factor1,
    CO2yrdiff_gCO2eqm2yr_yr50  = CO2yrdiff_mgCO2Cm2d_yr50  * factor1,
    CO2yrdiff_gCO2eqm2yr_yr65  = CO2yrdiff_mgCO2Cm2d_yr65  * factor1,
    CO2yrdiff_gCO2eqm2yr_yr80  = CO2yrdiff_mgCO2Cm2d_yr80  * factor1,
    CO2yrdiff_gCO2eqm2yr_yr100 = CO2yrdiff_mgCO2Cm2d_yr100 * factor1,
# Integrated values in CO2-eq
    CO2yrdiff_gCO2eqm2yr_GROSSINTEG = CO2yrdiff_mgCO2Cm2d_GROSSINTEG * factor1,
    CO2yrdiff_gCO2eqm2yr_NETINTEG   = CO2yrdiff_gCO2eqm2yr_GROSSINTEG - CO2yrdiff_gCO2eqm2yr_yr100
  )

# checksum
plot((dd$CO2yrdiff_gCO2eqm2yr_NETINTEG-dd$CO2yrdiff_mgCO2Cm2d_NETINTEG * factor1))
dd$CO2yrdiff_gCO2eqm2yr_NETINTEG
print(data.frame(c(dd$CO2yrdiff_gCO2eqm2yr_NETINTEG)))

### 1.2.3 account for preimpoundment emissions ; for CO2eq and mg CO2 m-2 d-1

# these are based on default global landcover emission factors, and are partitioned by climate zone - 
# for mineral soils there are no emissions; only sinks (negative values) for forest landcover
# Mineral soils are classed as those with soil organic carbon content of <12% (0-30cm depth).
# output gives breakdown of land cover classes among mineral, organic and 'no data' for the inundated reservoir area
# these emission factor coefficients are applied to each of these  
# - no data returns have 0 coefficeint values associated with them 
									
# approach is based on FAO(2001) climate domains, using reservoir mean monthly temps:
# Gres doesn't formally compute a climate zone - it is user selected from 4 options.
# The climate zone (in conjunction with land cover type among mineral and organic soils) is used to dictate 
# the land cover emission factors for computation of the pre-impoundment emissions from the reservoir area. 
# The climate zones (~ domains) represented in this schema are:
# Boreal, Temperate, sub-Tropical, and Tropical [do not fit within the Koppen system].

# As we are interested in the pre-impoundment reservoir area, this is the location used for determining 
# the climate zone (domain), on basis of temp.
# as per FAO (2001), as used in IPCC (2006):

#	Tropical 		= all months with mean temps >18degC			
#	Sub-Tropical 	= 8 or more months with mean temps >10degC
#	Temperate 		= 4-7 months with mean temps >10 degC
#	Boreal 		= 3 or less months with mean temps >10 degC
#	[Polar - NA 	= all months with mean temps <10 deg C]

# These domains are precomputed within 'GeoCaret' and output to 'catchment.biogenic_factors.climate'
print(levels(as.factor(dd$catchment.biogenic_factors.climate)))

#print(levels(as.factor(dd$catchment.biogenic_factors.soil_type)))

### soil landcover emission coefficients 
# tonnes CO2-C /km2/yr == grams CO2-C /m2/yr

# BOR - boreal; TEM = temp ; STR = subtropical; TRO = tropical
# ORG - organic ; MIN = mineral

# Define coefficients:  nested list structure: climate → soil_type → land_cover
# CO2 coefficients list using UPPERCASE climate keys

CO2_coeffs <- list(
  BOR = list(
    ORG = c(crop = 790,    bare = 300,  wetland = -50,  forest = 60,   grass = 570,    urban = 640),
    MIN = c(crop = 0,      bare = 0,    wetland = 0,    forest = -45,  grass = 0,    urban = 0)
  ),
  TEM = list(
    ORG = c(crop = 790,    bare = 300,  wetland = -50,  forest = 0,    grass = 500,  urban = 640),
    MIN = c(crop = 0,      bare = 0,    wetland = 0,    forest = -91,  grass = 0,    urban = 0)
  ),
  STR = list(
    ORG = c(crop = 1170,   bare = 200,  wetland = 10,   forest = 260,  grass = 960,  urban = 640),
    MIN = c(crop = 0,      bare = 0,    wetland = 0,    forest = -140, grass = 0,    urban = 0)
  ),
  TRO = list(
    ORG = c(crop = 1170,   bare = 200,  wetland = 0,    forest = 1530, grass = 960,  urban = 640),
    MIN = c(crop = 0,      bare = 0,    wetland = 0,    forest = -140, grass = 0,    urban = 0)
  )
)

# Climate code converter
climate_code <- function(climate_string) {
  dplyr::case_when(
    tolower(climate_string) == "boreal"      ~ "BOR",
    tolower(climate_string) == "temperate"   ~ "TEM",
    tolower(climate_string) == "subtropical" ~ "STR",
    tolower(climate_string) == "tropical"    ~ "TRO",
    TRUE ~ NA_character_
  )
}

#### Function to compute emissions

compute_preimp_emissions <- function(climate, area, org_fracs, min_fracs) {
  climate_key <- climate_code(climate)
  coeffs <- CO2_coeffs[[climate_key]]

  if (is.null(coeffs)) {
    warning("Unrecognized climate type: ", climate)
    return(NA_real_)
  }

  # Ensure NAs are treated as 0s
org_fracs <- purrr::map_dbl(org_fracs, ~ ifelse(is.na(.x), 0, .x))
min_fracs <- purrr::map_dbl(min_fracs, ~ ifelse(is.na(.x), 0, .x))

  # Compute total emissions = Area × Σ(fraction × coefficient)
  total_emissions <- sum(
    area * (
      org_fracs[["crop"]]    * coeffs$ORG["crop"] +
      org_fracs[["forest"]]  * coeffs$ORG["forest"] +
      org_fracs[["grass"]]   * coeffs$ORG["grass"] +
      org_fracs[["wetland"]] * coeffs$ORG["wetland"] +
      org_fracs[["urban"]]   * coeffs$ORG["urban"] +
      org_fracs[["bare"]]    * coeffs$ORG["bare"] +

      min_fracs[["forest"]]  * coeffs$MIN["forest"] 
    )
)

  # Return emission intensity in g C / m² / yr
  total_emissions / area
}

dd <- dd %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    preimpEMCO2.gCm2yr = compute_preimp_emissions(
      climate = catchment.biogenic_factors.climate,
      area = reservoir.area,
      org_fracs = list(
        crop    = reservoir.area_fractions.14,
        forest  = reservoir.area_fractions.16,
        grass   = reservoir.area_fractions.15,
        wetland = reservoir.area_fractions.13,
        urban   = reservoir.area_fractions.11,
        bare    = reservoir.area_fractions.9
      ),
      min_fracs = list(
        crop    = reservoir.area_fractions.5,
        forest  = reservoir.area_fractions.7,
        grass   = reservoir.area_fractions.6,
        wetland = reservoir.area_fractions.4,
        urban   = reservoir.area_fractions.2,
        bare    = reservoir.area_fractions.0
      )
    )
  ) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(
    preimpEM.mgCm2d      = (preimpEMCO2.gCm2yr / 365.25) * 1000,
    preimpEM.gCO2eqm2yr  = preimpEMCO2.gCm2yr * (44 / 12)
  )

aa<- data.frame(dd$preimpEM.gCO2eqm2yr)
aa<- data.frame(dd$X_key, dd$reservoir.area_fractions.7)

###---
colnames(dd)

# NOTE of caution
# check the 'preimpoundment' water body proportion of the reservoir area
# large values (>5-30%) are unlikely; 
# but can reflect damming of steep valleys where the pre-indation river area is significant



#############################################################################################################
# CO2 diffusion - correction for reservoir area pre-impoundment emissions

# Vector of all column suffixes to correct
mgCm2d_suffixes <- c(
  "yr1", "yr5", "yr10", "yr20", "yr30", "yr40", "yr50", "yr65", "yr80", "yr100",
  "GROSSINTEG", "NETINTEG"
)

gCO2eqm2yr_suffixes <- mgCm2d_suffixes

# Apply corrections for mgC/m²/day
for (suffix in mgCm2d_suffixes) {
  colname <- paste0("CO2yrdiff_mgCO2Cm2d_", suffix)
  new_colname <- paste0(colname, ".preimpCor")
  dd[[new_colname]] <- dd[[colname]] - dd$preimpEM.mgCm2d
}

# Apply corrections for gCO2eq/m²/yr
for (suffix in gCO2eqm2yr_suffixes) {
  colname <- paste0("CO2yrdiff_gCO2eqm2yr_", suffix)
  new_colname <- paste0(colname, ".preimpCor")
  dd[[new_colname]] <- dd[[colname]] - dd$preimpEM.gCO2eqm2yr
}

dd$CO2yrdiff_mgCO2Cm2d_GROSSINTEG.preimpCor
print(data.frame(dd$CO2yrdiff_mgCO2Cm2d_NETINTEG.preimpCor))

dd$CO2yrdiff_gCO2eqm2yr_GROSSINTEG.preimpCor
dd$CO2yrdiff_gCO2eqm2yr_NETINTEG.preimpCor  
colnames(dd)
#######################################################################################################################################
#######################################################################################################################################
# 2.	CH4 fluxes
# 2.1 CH4 diffusion

# construct sub-model input data

### percent littoral area

dd <- dd %>%
  mutate(
    pc_littoral = if_else(
      reservoir.max_depth < 3,
      100,
      (1 - (1 - (3 / reservoir.max_depth))^((reservoir.max_depth / reservoir.mean_depth) - 1)) * 100
    )
)

print(data.frame(dd$pc_littoral))
### Effective CH4 temperature

monthly_temp_cols <- grep("^monthly_temps\\.\\d+$", names(dd), value = TRUE)
dd <- dd %>% mutate(
    EFtempsCH4 = log10(rowMeans(10^(select(., all_of(monthly_temp_cols)) * 0.052), na.rm = TRUE)) / 0.052)

print(dd$EFtempsCH4)	
								
### compute CH4 diffusion

# set up coeffs
coef_diff <- list(
  int = 0.8031702,
  age = -0.014187,
  littoral = 0.4594447,
  temp = 0.0481904
)

# Years to calculate
years <- c(1, 5, 10, 20, 30, 40, 50, 65, 80, 100)

# Compute CH4 diffusion mg CH4-C m⁻² d⁻¹ and convert to CO₂eq g m⁻² yr⁻¹
for (yr in years) {
  dd[[paste0("CH4yrdiff_mgCH4Cm2d_yr", yr)]] <- 10^(
    coef_diff$int +
    coef_diff$age * yr +
    coef_diff$littoral * log10(dd$pc_littoral / 100) +
    coef_diff$temp * dd$EFtempsCH4
  )
  
  dd[[paste0("CH4yrdiff_gCO2eqm2yr_yr", yr)]] <- dd[[paste0("CH4yrdiff_mgCH4Cm2d_yr", yr)]] * 16.55
}

# INTEG Emissions (mean over 100 years); exp decay
dd <- dd %>%
  mutate(
    CH4yrdiff_mgCH4Cm2d_.INTEG = (
      10^(
        coef_diff$int +
        coef_diff$littoral * log10(pc_littoral / 100) +
        coef_diff$temp * EFtempsCH4
      ) * (1 - 10^(100 * coef_diff$age))
    ) / (100 * -coef_diff$age * log(10)),
    CH4yrdiff_gCO2eqm2yr_.INTEG = CH4yrdiff_mgCH4Cm2d_.INTEG * 16.55
  )


print(data.frame(dd$CH4yrdiff_gCO2eqm2yr_.INTEG))
########################################################################################################################
# 2.2 CH4 ebullition

coef_ebull <- list(
  int = -1.310432,
  litt = 0.8515131,
  irrad = 0.051977
)

dd <- dd %>%
  rowwise() %>%
  mutate(
    months_above_zero = sum(c_across(starts_with("monthly_temps.")) > 0, na.rm = TRUE),

    adjusted_radiance = if (coordinates.0 >= -40 & coordinates.0 <= 40) {
      (reservoir.mean_radiance * 30.4 * months_above_zero) / 30.4
    } else {
      (reservoir.mean_radiance_may_sept * 30.4 * months_above_zero) / 30.4
    },

    CH4ebull_mgCH4Cm2d = 10^(
      coef_ebull$int +
      coef_ebull$litt * log10(pc_littoral / 100) +
      coef_ebull$irrad * adjusted_radiance
    ),

    CH4ebull_gCO2eqm2yr = CH4ebull_mgCH4Cm2d * 16.55
  ) %>%
  ungroup()

########################################################################################################################
# 	2.3  CH4 Degassing - (uses CH4 diff)

# this approach is applied to all hydropower and multipurpose reservoirs that 
# 1)  operate  deep water (hypolimnetic) withdrawal that are below thermocline ~;  stratified systems. 
# If water withdrawal depth is known, this can be an input & compared with the thermocline depth to establish 
# if water is taken from below the thermocline

##### estimate thermocline depth

# Read et al. 2011, https://doi.org/10.1016/j.envsoft.2011.05.006
# CD for wind <5ms-1 modifed following Crusiuis and Wanninkhof 2003; cd = 0.0013 
# air density; kg/m3 ; 	<- 101325/(287.05*(mean temp of warmest 4 months +273.15)
# Compute the mean of the 4 greatest mean mothly temps

# Windspeed to 10m height?
# The terraclimate wind speed source data supplies data for windspeed at 10m height;  no correction is required
# https://developers.google.com/earth-engine/datasets/catalog/IDAHO_EPSCOR_TERRACLIMATE#bands
# https://www.nature.com/articles/sdata2017191

# note incorrect in use of log10 in Gres documentation description of windspeed-height correction
# - should be nat log
# Correct formulation;   following Read et al. 2011, https://doi.org/10.1016/j.envsoft.2011.05.006
# wind.10m	<- reservoir.mean_monthly_windspeed*(1-(dd$CD^0.5/0.4)*log(10/50))^-1; print(wind.10m)
# note that "reservoir.mean_monthly_windspeed" is the mean annual windspeed based, as mean of monthly means
#### bottom water density
# if mean temp of coldest month >1.4,  bottom water temp is .656*mean temp of coldest month +10.7
#### surface water density
# surface temp - mean of warmest 4 months 
#### thermocline depth, metres, Gorham and Boyce, 1989
# alternative - Hanna, 1990;  given in Gres documentation
#  - may be better, however requires fetch, as Maximum Effective length (MEL)
# Here MEL is estimated as sqrt(res. area) 
# Maximum effective length is defined by the straightline connecting the two most distant points on the shoreline 
# overwhich wind & waves may act withbut interruptions from land or islands

###---

monthly_temps <- grep("^monthly_temps\\.\\d+$", names(dd), value = TRUE)
dd <- dd %>%
  mutate(
    CD = if_else(reservoir.mean_monthly_windspeed < 5, 0.0013, 0.000015),
    mean_top4_monthly_temps = apply(select(., all_of(monthly_temps)), 1, function(x) mean(sort(x, decreasing = TRUE)[1:4], na.rm = TRUE)),
    airdens = 101325 / (287.05 * (mean_top4_monthly_temps + 273.15)),
    wind_10m = reservoir.mean_monthly_windspeed,  # no correction needed
    mintemp = apply(select(., all_of(monthly_temps)), 1, min, na.rm = TRUE),
    bottomtemp.C = if_else(mintemp > 1.4, 0.656 * mintemp + 10.7, 0.2345 * mintemp + 10.11),
    bottomwaterdens.kgm3 = (1 - (((bottomtemp.C + 288.9414) / (508929.2 * (bottomtemp.C + 68.12923))) * (bottomtemp.C - 3.9863)^2)) * 1000,
    surfacetemp.C = mean_top4_monthly_temps,
    surfacewaterdens.kgm3 = (1 - (((surfacetemp.C + 288.9414) / (508929.2 * (surfacetemp.C + 68.12923))) * (surfacetemp.C - 3.9863)^2)) * 1000
  )

print(data.frame(dd$bottomwaterdens.kgm3))
print(data.frame(cbind(dd$CD, dd$wind_10m, dd$wind.10mb)))
plot(dd$CD, dd$wind_10m)

dd$wind.10mb	<- dd$reservoir.mean_monthly_windspeed*(1-(dd$CD^0.5/0.4)*log(10/50))^-1; print(wind.10mb)
plot(dd$wind.10mb ~ dd$wind_10m)

# Thermocline depth (Gorham and Boyce 1989)
dd <- dd %>%
  mutate(
    thermoclinedepth.m = case_when(
      bottomwaterdens.kgm3 > surfacewaterdens.kgm3 ~ 
        2.0 * sqrt((CD * airdens * wind_10m) / 
                   (9.80665 * (bottomwaterdens.kgm3 - surfacewaterdens.kgm3))) *
        sqrt(sqrt(reservoir.area * 1e6)),
      TRUE ~ NaN
    ),
    thermoclinedepth.m.ALT1 =  6.95 * reservoir.area^0.185
  )

print(data.frame(dd$thermoclinedepth.m))
print(data.frame(dd$thermoclinedepth.m.ALT2))

dd$thermoclinedepth.m.ALT1 	<- 10^((0.185*log10(dd$reservoir.area))+0.842)
dd$check <- 6.95 * dd$reservoir.area^0.185
plot(dd$check ~dd$thermoclinedepth.m.ALT1 )

print(data.frame(dd$thermoclinedepth.m.ALT1))

##################################################################################################

##### compute degassing if reservoir is hydropower or multipurpose only
##### and if offtake depth > thermocline depth
##### use offtake depth if reported, otherwise 0.8*max depth
	
# set up coeefs
contantCH4degas.Int	<-	-6.910614
constantCH4degas.Tw	<- 	0.6016803			# Tw = hydraulic residence time
constantCH4degs.diff	<-	2.9499679

levels(as.factor(dd$type))

dd <- dd %>%
  mutate(
# 1. hydropower or multipurpose? if unknown assume not hydropower - no degassing flux computed
    is_target_type = type %in% c("hydroelectric", "multipurpose"),
    
# 2. Compute offtake depth (use intake depth if present, else 80% of max depth)
    offtakedepth.m = ifelse(is.na(reservoir.water_intake_depth),
                            0.8 * reservoir.max_depth,
                            reservoir.water_intake_depth),
    
# 3. Compute CH4 degassing if conditions are met
    CH4degas_gCH4Cm2yr_INT100yr = ifelse(
      is_target_type & (offtakedepth.m > thermoclinedepth.m),
      ((10^(contantCH4degas.Int +
             constantCH4degas.Tw * log10(WaterResid.yrs) +
             constantCH4degs.diff * log10(CH4yrdiff_gCO2eqm2yr_.INTEG)) *
         annualdischarge.m3 * 1000 * 0.9) * 1e-9) / reservoir.area, 0),
# 4. to CO2eq
	CH4degas_gCO2eqm2yr_INT100yr = CH4degas_gCH4Cm2yr_INT100yr*(16/12)*34		
)

# 0.9 in equation above is 'loose' estimation to account for runoff not passing through turbines 
# (leakages, other outflows, evap)

print(data.frame(dd$CH4degas_gCO2eqm2yr_INT100yr))


########################################################################################################################
#### 2.4 compute preimpoundment CH4 emissions
# same general approach as for preimpoundment CO2 emissions

#### Set up organic soil land cover CH4 emission coefficients
# Units: tonnes CH4-C/km²/yr (equivalent to g CH4-C/m²/yr)
# No CH4 emissions or sinks for mineral soils
# BOR = Boreal, TEM = Temperate, STR = Subtropical, TRO = Tropical
# ORG = Organic

# Boreal
BOR.ORG.cropch4    <- 0
BOR.ORG.barech4    <- 0.4575
BOR.ORG.wetlandch4 <- 6.675
BOR.ORG.forestch4  <- 0.3375
BOR.ORG.grassch4   <- 0.105
BOR.ORG.urbanch4   <- 1.47

# Temperate
TEM.ORG.cropch4    <- 0
TEM.ORG.barech4    <- 0.4575
TEM.ORG.wetlandch4 <- 0
TEM.ORG.forestch4  <- 0
TEM.ORG.grassch4   <- 1.4175
TEM.ORG.urbanch4   <- 1.47

# Subtropical
STR.ORG.cropch4    <- 0
STR.ORG.barech4    <- 0.525
STR.ORG.wetlandch4 <- 8.7225
STR.ORG.forestch4  <- 0.1875
STR.ORG.grassch4   <- 0.525
STR.ORG.urbanch4   <- 1.47

# Tropical
TRO.ORG.cropch4    <- 5.625
TRO.ORG.barech4    <- 0.525
TRO.ORG.wetlandch4 <- 3.075
TRO.ORG.forestch4  <- 0.135
TRO.ORG.grassch4   <- 0.525
TRO.ORG.urbanch4   <- 1.47

# compute pre-impoundment emissions; (sum(reservoir area proportions*res area(km2)*coeffs))/res area															ACTION
# note tonnes/km2 = g/m2; # Units: g CH4-C/m²/yr
levels(as.factor(dd$catchment.biogenic_factors.climate))


dd$preimpEM.CH4.gCm2yr <- as.numeric(with(dd, ifelse(catchment.biogenic_factors.climate == "tropical",
  ((reservoir.area_fractions.14 * reservoir.area * TRO.ORG.cropch4) + 
   (reservoir.area_fractions.16 * reservoir.area * TRO.ORG.forestch4) +
   (reservoir.area_fractions.15 * reservoir.area * TRO.ORG.grassch4) +
   (reservoir.area_fractions.13 * reservoir.area * TRO.ORG.wetlandch4) +
   (reservoir.area_fractions.11 * reservoir.area * TRO.ORG.urbanch4) +
   (reservoir.area_fractions.9  * reservoir.area * TRO.ORG.barech4)) / reservoir.area,
ifelse(catchment.biogenic_factors.climate == "subtropical",
  ((reservoir.area_fractions.14 * reservoir.area * STR.ORG.cropch4) + 
   (reservoir.area_fractions.16 * reservoir.area * STR.ORG.forestch4) +
   (reservoir.area_fractions.15 * reservoir.area * STR.ORG.grassch4) +
   (reservoir.area_fractions.13 * reservoir.area * STR.ORG.wetlandch4) +
   (reservoir.area_fractions.11 * reservoir.area * STR.ORG.urbanch4) +
   (reservoir.area_fractions.9  * reservoir.area * STR.ORG.barech4)) / reservoir.area,
ifelse(catchment.biogenic_factors.climate == "temperate",
  ((reservoir.area_fractions.14 * reservoir.area * TEM.ORG.cropch4) + 
   (reservoir.area_fractions.16 * reservoir.area * TEM.ORG.forestch4) +
   (reservoir.area_fractions.15 * reservoir.area * TEM.ORG.grassch4) +
   (reservoir.area_fractions.13 * reservoir.area * TEM.ORG.wetlandch4) +
   (reservoir.area_fractions.11 * reservoir.area * TEM.ORG.urbanch4) +
   (reservoir.area_fractions.9  * reservoir.area * TEM.ORG.barech4)) / reservoir.area,
  ifelse(catchment.biogenic_factors.climate == "boreal",
   ((reservoir.area_fractions.14 * reservoir.area * BOR.ORG.cropch4) + 
   (reservoir.area_fractions.16 * reservoir.area * BOR.ORG.forestch4) +
   (reservoir.area_fractions.15 * reservoir.area * BOR.ORG.grassch4) +
   (reservoir.area_fractions.13 * reservoir.area * BOR.ORG.wetlandch4) +
   (reservoir.area_fractions.11 * reservoir.area * BOR.ORG.urbanch4) +
   (reservoir.area_fractions.9  * reservoir.area * BOR.ORG.barech4)) / reservoir.area, "no climate factor"))))
))
print(dd$preimpEM.CH4.gCm2yr)
# Convert to mg CH4-C/m²/day; for match up with first set of output calcs in these units
dd$preimpEM.CH4.mgCm2d <- dd$preimpEM.CH4.gCm2yr * 1000 / 365.25

# Convert to g CO2-eq/m²/yr
dd$preimpEM.CH4.gCO2eqm2yr <- dd$preimpEM.CH4.gCm2yr * (16/12) * 34
print(data.frame(dd$preimpEM.CH4.gCO2eqm2yr))


##########################################################################################################
### compute CH4 emission for preimpoundment waterbodies - taken as lakes - Gres approach Rasilo 2015

# compute preimpoundment waterbody area km2 - sum of waterbodies for mineral, organic and bare areas in inundated area
# The approach is applicable to lakes

# We previously estimated the pre-inundation river area; dd$preinundRivWaterArea_km2 
# We can compare the preinundation water body LC sum area with this estimated river area
# estimated river areas should generally exceed LC water areas where only rivers are present 
# (rivers, esp smaller ones, are not well resolved in LC)
# Where water body LC > estimated river area, we can compute an emission for the residual area (waterbodiesLC - est.Riv area = 'lake' area)

dd$preimpWaterbodyArea.km2 <- with(dd,(reservoir.area_fractions.3 + reservoir.area_fractions.12 + reservoir.area_fractions.21)*reservoir.area)
print(dd$preinundRivWaterArea_km2)
print(dd$preimpWaterbodyArea.km2)
plot(dd$preimpWaterbodyArea.km2 ~ dd$preinundRivWaterArea_km2)
 dd$preinundRivWaterArea_km2 - dd$preimpWaterbodyArea.km2 

dd <- dd %>%
  mutate(
    lakearea = if_else(preimpWaterbodyArea.km2 > preinundRivWaterArea_km2,
                       preimpWaterbodyArea.km2 - preinundRivWaterArea_km2,
                       NA_real_),
# Compute gas transfer velocity k600
    k600a = if_else(!is.na(lakearea) & lakearea > 0,
                    0.24 * (2.51 + 1.48 * wind_10m + 0.39 * wind_10m * log10(lakearea)),
                    NA_real_),
    k600 = if_else(is.infinite(k600a) | k600a == -Inf, 0, k600a),
# Henry’s Law constant for CH4
    kH = exp(
      (-115.6477 - 6.1698 * (EFtempsCH4 + 273.15) / 100) +
      (155.5756 / ((EFtempsCH4 + 273.15) / 100)) +
      (65.2553 * log((EFtempsCH4 + 273.15) / 100))
    ) * (1000 / 18.0153),
# Partial pressure of CH4
    pCH4a = if_else(!is.na(lakearea) & lakearea > 0,
                    10^((1.46 + 0.03 * EFtempsCH4) - 0.29 * log10(lakearea)),
                    NA_real_),
    pCH4 = if_else(is.infinite(pCH4a), 0, pCH4a),
# CH4 concentration
    CH4conc = kH * pCH4,
# Final CH4 emission rate (kg CH4/ha/yr)
    CH4emiss = CH4conc * k600 * (16 / 12) * (365 / 100)
  )

# Convert lake CH4 emissions to:
dd$CH4preimpwaterbodyemiss.gCm2yr    <- ifelse(!is.na(dd$CH4emiss), dd$CH4emiss * 0.075, 0)
dd$CH4preimpwaterbodyemiss.mgCm2d    <- dd$CH4preimpwaterbodyemiss.gCm2yr * 1000 / 365.25
dd$CH4preimpwaterbodyemiss.gCO2eqm2yr <- dd$CH4preimpwaterbodyemiss.gCm2yr * (16/12) * 34

#### Combine total pre-impoundment CH4 emissions

dd$preimpEMTotalCH4.mgCm2d     <- dd$preimpEM.CH4.mgCm2d + dd$CH4preimpwaterbodyemiss.mgCm2d
dd$preimpEMTotalCH4.gCO2eqm2yr <- dd$preimpEM.CH4.gCO2eqm2yr + dd$CH4preimpwaterbodyemiss.gCO2eqm2yr


#### compute total emmission (per yr) cor for preimp

dd <- dd %>%
  mutate(
    total_CH4_yr_preimp.cor.gCO2eqm2yr = (CH4yrdiff_gCO2eqm2yr_.INTEG + CH4degas_gCO2eqm2yr_INT100yr + CH4ebull_gCO2eqm2yr) - preimpEMTotalCH4.gCO2eqm2yr)

print(dd$total_CH4_yr_preimp.cor.gCO2eqm2yr)

########################################################################################################################################################
########################################################################################################################################################
## compare with reemission outputs
str(dd)
colnames(dd)

## rr - reemisson combined outputs 27th June; then 30_6
#rr <- read.csv("N:/PROJECTS/FutureDams/R calc checks Jul2023/new R script MAY2025/validation_inputs_outputs/validation_package_27_06/reemission_27_6_comb_outputs.csv")
rr <- read.csv("/home/lepton/Documents/git_projects/reemission-paper/code/R/cbarry/validation_outputs_comb_30_6.csv")


## match R and reem outputs table
pp <- read.csv("/home/lepton/Documents/git_projects/reemission-paper/code/R/cbarry/validation_package_27_06/R Reem output match up.csv")
print(pp)



# Define group (UK or MY) based on row index
dd$group <- ifelse(seq_len(nrow(dd)) %in% 212:249, "UK", "MY")
rr$group <- dd$group  # Assumes dd and rr rows are aligned

# Function to generate comparison plots without titles
plot_variable_set <- function(pp, dd, rr, indices, group_col = "group") {
  selected_pp <- pp[indices, ] %>%
    filter(!is.na(R.Script) & !is.na(REEMISSION) & R.Script %in% names(dd) & REEMISSION %in% names(rr))
  
  plots <- pmap(selected_pp, function(R.Script, REEMISSION) {
    # Extract the values
    x_vals <- dd[[R.Script]]
    y_vals <- rr[[REEMISSION]]
    group_vals <- dd[[group_col]]

    # Build dataframe for plotting
    plot_df <- data.frame(
      x = x_vals,
      y = y_vals,
      group = group_vals
    )

    # Generate plot (no title)
    ggplot(plot_df, aes(x = x, y = y, color = group)) +
      geom_point(size = 2, alpha = 0.7) +
      geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "gray50") +
      labs(
        x = R.Script,
        y = REEMISSION,
        color = "Group"
      ) +
      theme_minimal() +
      coord_equal()
  })
  
  return(plots)
}

# Group indices from pp
print(pp)

group1_indices <- 2:5    # Skipping header row (1), gets items 1:5
group2_indices <- 6:10
group3_indices <- 11:16
group4_indices <- 17:21
group_mix_indices <- c(17,18,19,7,8)
group_mix_indices <- c(6,10,, 20,21)


# Generate plots
plots_group1 <- plot_variable_set(pp, dd, rr, group1_indices)
plots_group2 <- plot_variable_set(pp, dd, rr, group2_indices)
plots_group3 <- plot_variable_set(pp, dd, rr, group3_indices)
plots_group4 <- plot_variable_set(pp, dd, rr, group4_indices)
plots_group4 <- plot_variable_set(pp, dd, rr, group_mix_indices)


# Optional: Display first plot in each group
print(plots_group1[[1]])
print(plots_group2[[1]])
print(plots_group3[[1]])
print(plots_group4[[4]])

# To view all plots at once in a grid (e.g. using patchwork)

wrap_plots(plots_group1)  # or any other group
wrap_plots(plots_group2)
wrap_plots(plots_group3)
wrap_plots(plots_group4)



########################################################################################################################################################
########################################################################################################################################################
# 3. N2O emission calcs
# see notes at end of script

# Total Nitrogen loading to the reservoir
# set up McDowell et al. 2020 model coeffs
# note that median concentratiosn were derived using data for all months for tropical regions
# "We focused our data to periods of likely peak growth by filtering data for temperate and polar regions (i.e., 
# regions outside the tropics of Cancer and Capricorn) to values measured from May to October in the Northern 
# Hemisphere and for November to April in the Southern Hemisphere. All data were used to generate medians for 
# tropical regions"
# ------- for non tropical regions the predictors are for 'summer time' ~base-flow concentrations



###---

# model coeffs
coeffs <- list(
  MDPInt = -4.2396,
  MDOlsenP = 0.01,
  MDMeanMprecip = -0.0062,
  MDMeanslope_pc = -0.0768,
  MDCropland_pc = 0.0075,
  MDpTevapotmeanM = 0.0134,
  MDBiascorrF = 0.855
)

# model Biome coeffs Mapping
biome_coeffs <- c(
  "tropical moist broadleaf"       = 1.0789,
  "temperate coniferous"      = 0.8749,
  "xeric shrub"                    = 1.4481,
  "mediterranean forests"        	 = 1.8352,
  "montane grasslands"			 = 0.5575,
  "temperate broadleaf and mixed" = 0.5216,
  "temperate grasslands"          = 1.0591,
  "tropical grasslands"           = 0.9004,
  "tropical dry broadleaf"        = 0.2002,
  "tundra"                        = 1.9464
)

levels(as.factor(dd$catchment.biogenic_factors.biome))



###---


# Coefficients for median TN model

coeffsN <- list(
IntTN       = -1.5181,
Mprecip.mm  = -0.0089,
Mslope.pc   = -0.1838,	
Cropland.pc =  0.0106,
Soilwet.mm  =  0.0055,
BiascorrF = 0.595)

# Biome-specific coefficients
biome_coeffsN <- c(
  "tropical moist broadleaf"              = 1.2144,
  "temperate coniferous"        	     = 1.8488,
  "xeric shrub"                           = 1.9935,
  "mediterranean forests"                 = 3.2782,
  "montane grasslands"     			 = 1.5238,
  "temperate broadleaf and mixed"		 = 1.3245,
  "temperate grasslands"                 = 1.6756,
  "tropical dry broadleaf"               = 1.0801,
  "tropical grasslands"                  = 0.5203
)

# Calculations
dd <- dd %>%
  mutate(
    biome_coeffN = biome_coeffsN[catchment.biogenic_factors.biome] %>% replace_na(0)%>% unname(),

	medianTN.mgL =   exp(coeffsN$IntTN + 
    (coeffsN$Mprecip.mm * (catchment.precip / 12)) + 
    (coeffsN$Mslope.pc * catchment.slope) + 
    (coeffsN$Cropland.pc * (catchment.area_fractions.5 * 100)) + 
    (coeffsN$Soilwet.mm * catchment.soil_wetness) + 
    biome_coeffN) * coeffsN$BiascorrF
)


# TN load in kg/yr
dd$TNload.kgyr <- dd$medianTN.mgL * dd$annualdischarge.m3 * 1e-3

# TN load in mol N/yr (14 g/mol N)
dd$TNloadmolyr <- (dd$TNload.kgyr * 1e3) / 14

# TN kg ha yr
dd$TNexport.kghayr <- dd$TNload.kgyr / (dd$catchment.area * 100)

# seems a little low, however see also, https://www.sciencedirect.com/science/article/pii/S0269749108001164?via%3Dihub
# largely <4kg/ha/yr
# McDowell dataset is largely larger rivers encompassing waste water N inputs
# It would be worth considering some assesement of waste water N loading
# e.g. https://essd.copernicus.org/articles/13/237/2021/  #gridded global dataset
# typical ~ 3.5 kg N yr; 9.6 g N /person/day
# ~ with waste water treatment ~"biological"~ could lower to c.6 g N/person/day

##################################################################################################################################################
# UK exp coeff model for TDN - flux at tidal limit based on harmonised monitoring scheme data
# https://doi.org/10.1016/j.scitotenv.2020.138864 Fan et al. 2020 #not a well described  model

# The model
# TDN.flux.tNyr <- 5.6*Urban + 4.3*Grass + 1.4*Arable + 4.9*mineral + 
#			6.4*organo-mineral + 5.9*organic - 0.8*Ksheep -5.4*Area

# we have no ready source for UK "sheep numbers" or "livestock" ; Ksheep = 1000s of sheep.  
# these are effectively livestocking rates where 3.1 sheep taken per cow. # not well documented

# suggest using a general elevation threshold for livestocking rates, between lowlands and uplands
# https://publications.naturalengland.org.uk/file/62085 

# lowlands <250masl
# 0.58 cattle per ha forage area
# 3.1*0.58 = 1.8 sheep per ha 'forage' land ---  take our LC 'Grass and Shrub' as = to forage land (~grass + rough grazing)
# # probable overestimate
# thus catchment grass area in ha *1.8 /1000 = Ksheep for lowland catchments

# difficult to obtain generalisations for uplands; pragmatically take 0.5*lowland value = 0.29
# 3.1*0.29 = 0.9 sheep per ha 'forage' land.

### WILL NEED ELEVATION ADDING TO JSON OUTPUT FROM GEOCARET to use this 
# - this could be taken as the full supply level "fsl_masl"
# areas in km2
# we cannot partition catchment soils to organo-mineral, min and org 
# - have not extracted breakdowns for the catchment
# however coeffs are not starkly different, and the org coeff lies between the min and org-min
# thus use overall mean (4.9+6.4+5.9)/3 = 5.73   # model seems a little strange with Area included; as sum(soils)=area

# TDN.flux.tNyr <- 5.6*Urban + 4.3*Grass + 1.4*Arable + 4.9*mineral + 6.4*organo-mineral + 5.9*organic - 0.8*Ksheep -5.4*Area
# modified
# TDN.flux.tNyr <- 5.6*Urban + 4.3*Grass + 1.4*Arable + 5.73*Area  - 0.8*Ksheep - 5.4*Area

# if elev <250, 
# dd$Ksheep <-catch.area_6_km2*100*1.8*10^-3
# if elev >250,
# dd$Ksheep <-catch.area_6_km2*100*0.9*10^-3

# TDN.flux.tNyr 	<-	 5.6*catch.area_2_km2 + 4.3*catch.area_6_km2 + 1.4*catch.area_5_km2 +
#			 	5.73*catchment.area  - 0.8*Ksheep - 5.4*catchment.area
# TDN.exp.kgNhayr <- 	TDN.flux.tNyr*10^3/(catchment.area*100)
# TDN.conc.mgNl 	<-	(TDN.flux.tNyr*10^6)/annualdischarge.m3	


### NOTE aNNUAL GLOBAL GRIDDED LOVESTOCK
# https://essd.copernicus.org/preprints/essd-2025-175/

##################################################################################################################################################
##################################################################################################################################################
####### compute TN fixation
## procede with McDowell N & Prairie P onc approaches            
## here for balance it might be best to us the McDOwell P and N predictions together
#  (remember McDowell P and N are summertime beyond the tropics)

# Convert TP load (kg) to mol: 1 mol P = 30.97 g
dd$TNTP.molaratio <- dd$TNloadmolyr / ((dd$totalPload.kg * 1e3) / 30.97)

# mu is a function of water residence time; erf is the error function
dd$mu <- ifelse(dd$WaterResid.yrs > 0.0274, 
                erf((dd$WaterResid.yrs - 0.028) / 0.04), 
                0)

# N-fixation percentage: constrained by stoichiometry and mu
dd$Nfix.pc <- ifelse(dd$TNTP.molaratio > 30, 
                     0, 
                     (37.2 / (1 + exp((0.5 * dd$TNTP.molaratio - 6.877)))) * dd$mu)

dd$Nfix.kgyr <- dd$Nfix.pc * 0.01 * dd$TNload.kgyr

# McDowell TP load (kg/yr) = [ug/L] * [m3/yr] = g/yr → kg/yr
dd$totalPload.kgMD <- dd$McD_medianinflowP.ugl * 1e-9 * dd$catchment.runoff * dd$catchment.area * 1e6

# Compute TN:TP ratio using McDowell TP 
dd$TNTP.molaratio.MD <- dd$TNloadmolyr/((dd$totalPload.kgMD*10^3)/30.97)

#  Compare original vs McDowell TN:TP ratios
plot(dd$TNTP.molaratio.MD ~ dd$TNTP.molaratio,
     main = "TN:TP Molar Ratio: McDowell vs Prairie TP",
     xlab = "Original TN:TP", 
     ylab = "McDowell-based TN:TP",
     pch = 19, col = "steelblue")

plot(dd$McD_medianinflowP.ugl, dd$inflowP.ugL,
     xlim = c(0, 100), ylim = c(0, 100),
     xlab = "McDowell inflow P (ug/L)", 
     ylab = "Prairie inflow P (ug/L)",
     main = "McDowell vs Prairie Inflow P",
     pch = 19, col = "purple")
abline(0, 1, lty = 2, col = "gray")  # 1:1 line

######################################################################################################################
###### 3. compute N2O emissions
# 3.1 DS1 Default scenario 1; ds1  ; default EF = 0.9%;  Beualieu et al. 2011

# Total N-based emissions from denitrification and nitrification
dd$N2Oemm.denitrif.kgNyr.ds1 <- 0.009 * (dd$TNload.kgyr + dd$Nfix.kgyr) * (0.3833 * erf(0.4723 * dd$WaterResid.yrs))
dd$N2Oemm.nitrif.kgNyr.ds1   <- 0.009 * (dd$TNload.kgyr + dd$Nfix.kgyr) * (0.5144 * erf(0.3692 * dd$WaterResid.yrs))

# Total N2O emissions from both pathways
dd$N2Oemm.total.kgNyr.ds1 <- dd$N2Oemm.nitrif.kgNyr.ds1 + dd$N2Oemm.denitrif.kgNyr.ds1

# Total mmol N m⁻² yr⁻¹
dd$N2Oemm.total.mmolNm2yr.ds1 <- ((dd$N2Oemm.total.kgNyr.ds1 * 1e6) / 14) / (dd$reservoir.area * 1e6)

# Convert to µmol N m⁻² d⁻¹
dd$N2Oemm.total.umolNm2d.ds1 <- (dd$N2Oemm.total.mmolNm2yr.ds1 * 1e3) / 365.25

# Alias for clarity — N2O as N
dd$N2Oemm.total.umolN2Om2d.ds1 <- dd$N2Oemm.total.umolNm2d.ds1

# Convert to µg N2O m⁻² d⁻¹ using molecular weight conversion: 14g N → 44g N2O, 2 N atoms
dd$N2Oemm.total.ugN20m2d.ds1 <- dd$N2Oemm.total.umolNm2d.ds1 * 14 * (44 / 28)

# Convert to mg N2O m⁻² yr⁻¹
dd$N2Oemm.total.mgN20m2yr.ds1 <- dd$N2Oemm.total.ugN20m2d.ds1 * 365.25 * 1e-3

# Convert to CO2-equivalents (GWP100 = 298)
dd$N2Oemm.total.gCO2eqm2yr.ds1 <- dd$N2Oemm.total.mgN20m2yr.ds1 * 1e-3 * 298

#####################################################################################################################
### 3.2 Default scenario 2 DS2 

# Total N2O emissions (from TN load only)

dd$N2Oemm.total.kgNyr.ds2 <- dd$TNload.kgyr*(0.002277*erf(1.63*dd$WaterResid.yrs))

# Partition into denitrification and nitrification
dd$N2Oemm.denitrif.kgNyr.ds2 <- (0.7789 * exp(-((dd$WaterResid.yrs - -1.366) / 2.751)^2)) * dd$N2Oemm.total.kgNyr.ds2
dd$N2Oemm.nitrif.kgNyr.ds2   <- dd$N2Oemm.total.kgNyr.ds2 - dd$N2Oemm.denitrif.kgNyr.ds2

# Convert to areal and mass units
# mmol N m⁻² yr⁻¹
dd$N2Oemm.total.mmolNm2yr.ds2 <- ((dd$N2Oemm.total.kgNyr.ds2 * 1e6) / 14) / (dd$reservoir.area * 1e6)

# µmol N m⁻² d⁻¹
dd$N2Oemm.total.umolNm2d.ds2 <- (dd$N2Oemm.total.mmolNm2yr.ds2 * 1e3) / 365.25

# µg N₂O m⁻² d⁻¹
dd$N2Oemm.total.ugN20m2d.ds2 <- dd$N2Oemm.total.umolNm2d.ds2 * 14 * (44 / 28)

# mg N₂O m⁻² yr⁻¹
dd$N2Oemm.total.mgN20m2yr.ds2 <- dd$N2Oemm.total.ugN20m2d.ds2 * 365.25 * 1e-3

# gCO2eqm2yr # N20 gwp100 = 298
dd$N2Oemm.total.gCO2eqm2yr.ds2 <- dd$N2Oemm.total.mgN20m2yr.ds2 * 1e-3 * 298

# mean of ds1 and ds2
dd$N2Oemm.total.gCO2eqm2yr.mean <- mean(dd$N2Oemm.total.gCO2eqm2yr.ds2 + dd$N2Oemm.total.gCO2eqm2yr.ds1)

#####################################################################################################################
### 3.3 Downstream Total N flux
# [Catchment input + Reservoir N2 fixation] - [In reservoir burial + In reservoir denitrification]

# Maavara et al. (2018) DOI: 10.1111/gcb.14504

# In reservoir burial [Maavara 2018; eq. 17] 
dd$TN.burial.kgyr <- (dd$Nfix.kgyr + dd$TNload.kgyr)*(0.51*erf(0.4723*dd$WaterResid.yrs)) 

# In reservoir denitrification [Maavara 2018; eq. 9] DS1 - 
dd$TN.denitrif.kgyr <- (dd$Nfix.kgyr + dd$TNload.kgyr)*(0.3833 * erf(0.4723 * dd$WaterResid.yrs))

# TN for downstream export
dd$TN.downstream.kgyr <- (dd$Nfix.kgyr + dd$TNload.kgyr) - dd$TN.burial.kgyr - dd$TN.denitrif.kgyr 

# expressed as res conc
TN.downstream.mgl <- dd$TN.downstream.kgyr /dd$reservoir.volume
TN.res.mgl <- dd$TNload.kgyr /dd$reservoir.volume

#######################################################################################################################
#######################################################################################################################

#######################################################################################################################
#######################################################################################################################
########----------------- 4. Data summaries --------------------------------###########################################

# to approx. match PDF output (MYA_GHG_outputs.pdf), gCO2eqm2yr; ~ allow comparison

### further derived outputs

# compile net CH4 emission
dd$CH4.NET.gCO2eqm2yr <- 	dd$CH4yrdiff_gCO2eqm2yr_.INTEG +
					dd$CH4ebull_gCO2eqm2yr +
					dd$CH4degas_gCO2eqm2yr_INT100yr - 
					(dd$preimpEM.CH4.gCO2eqm2yr + dd$CH4preimpwaterbodyemiss.gCO2eqm2yr)

# compile total net emission; CO2 and CH4 only
dd$NetEmission_C.gCO2eqm2yr <- with(dd,(
			CO2yrdiff_gCO2eqm2yr_NETINTEG.preimpCor +		# mean annual flux minus non-anthro, minus preimpound
			CH4yrdiff_gCO2eqm2yr_.INTEG +				# mean annual flux		
			CH4ebull_gCO2eqm2yr +						# mean annual flux
			CH4degas_gCO2eqm2yr_INT100yr -				# mean annual flux
			preimpEM.CH4.gCO2eqm2yr -					# mean annual flux
			CH4preimpwaterbodyemiss.gCO2eqm2yr)				# mean annual flux
)

# compile total net emission; CO2, CH4 and N2O
dd$NetEmission_CN.gCO2eqm2yr <-  dd$NetEmission_C.gCO2eqm2yr + dd$N2Oemm.total.gCO2eqm2yr.ds2 

#######################################################################################################################

#######################################################################################################################
#######################################################################################################################
### Create output tables	


# match reemission output  : "validation_outputs.xlsx" [ internals sheet ]

inflow_p_conc
retention_coeff
trophic_status
inflow_n_conc
reservoir_tn
reservoir_tp
littoral_area_frac
mean_radiance_lat
global_radiance
bottom_temperature
bottom_density
surface_temperature
surface_density
thermocline_depth
nitrogen_load
phosphorus_load
nitrogen_downstream_conc

write.csv(dd, "dd_results.csv", row.names = FALSE)

# named list of parameters to include
vars <- list(
   'Inflow P conc, Gres, ppb' = dd$inflowP.ugL,
   'Inflow P conc, McDowell, ppb' = dd$McD_medianinflowP.ugl,  
   'P retention coeff, Gres' = dd$RetentionCoeffs.gres,
   'P retention coeff, Maavara' = dd$RetentionCoeffs,
   'median TN conc, ppm' = dd$medianTN.mgL,
   'Reservoir P conc, Gres, ppb' = dd$ReservoirTP.ugL, 
   'Percent littoral area' = dd$pc_littoral,
   'reservoir.mean_radiance' = dd$reservoir.mean_radiance, 
   'bottomtemp.C' = dd$bottomtemp.C,                                 
   'bottomwaterdens.kgm3' = dd$bottomwaterdens.kgm3,                        
   'surfacetemp.C'= dd$surfacetemp.C,                               
   'surfacewaterdens.kgm3' = dd$surfacewaterdens.kgm3, 
   'thermocline depth, m' = dd$thermoclinedepth.m,
   'alt. thermocline depth, m' = dd$thermoclinedepth.m.ALT2,
   'Annual TN load, kg' = dd$TNload.kgyr,
   'totalPload.kg'= dd$totalPload.kg)

# to data.frame
intern_comp <- do.call(rbind, vars)
colnames(intern_comp) <- dd$X_key  # set reservoir names as column names
rownames(intern_comp) <- names(vars)
intern_comp <- as.data.frame(intern_comp)

# format - no scientific notation, round to 2 dp
intern_comp <- as.data.frame(
  apply(intern_comp, c(1,2), function(x) format(round(as.numeric(x), 2), nsmall = 2, scientific = FALSE)))

# View table1
View(intern_comp)
intern_comp <- t(intern_comp)

# Export table1 to CSV
write.csv(intern_comp, "Rinternals_comparison.csv", row.names = TRUE)


### 4.1 TABLE 1. Some key inputs and derived parameter values

# named list of parameters to include
vars <- list(
  'Annual runoff' = dd$catchment.runoff,
  'mean annual discharge m3/s' = dd$meanannualdischarge.m3s,
  'mean annual discharge m3' = dd$annualdischarge.m3,
  'water residence time, years' = dd$WaterResid.yrs,
  'P retention coeff, Maavara' = dd$RetentionCoeffs,
  'P retention coeff, Gres' = dd$RetentionCoeffs.gres,
  'waste water treatment factor' = dd$WWtreat,
  'P export kg/ha/yr' = dd$totalPexp.kghayr,
  'Inflow P conc, Gres, ppb' = dd$inflowP.ugL,
  'Reservoir P conc, Gres, ppb' = dd$ReservoirTP.ugL,
  'Inflow P conc, McDowell, ppb' = dd$McD_medianinflowP.ugl,
  'Reservoir P conc, McDowell, ppb' = dd$MDReservoirTP.ugL,
  'Percent littoral area' = dd$pc_littoral,
  'bottom Res. Temp, C' = dd$bottomtemp.C,
  'surface Res. Temp., C' = dd$surfacetemp.C,
  'thermocline depth, m' = dd$thermoclinedepth.m,
  'alt. thermocline depth, m' = dd$thermoclinedepth.m.ALT2,
  'median TN conc, ppm' = dd$medianTN.mgL,
  'Annual TN load, kg' = dd$TNload.kgyr,
  'Annual TN export, kg N/ha/yr' = dd$TNexport.kghayr,
  'Inflow TN:TP molar ratio' = dd$TNTP.molaratio,
  'Inflow TN:TP molar ratio, McDowell TP' = dd$TNTP.molaratio.MD)

# to data.frame
table1_df <- do.call(rbind, vars)
colnames(table1_df) <- dd$X_key  # set reservoir names as column names
rownames(table1_df) <- names(vars)
table1_df <- as.data.frame(table1_df)

# format - no scientific notation, round to 2 dp
table1_df <- as.data.frame(
  apply(table1_df, c(1,2), function(x) format(round(as.numeric(x), 2), nsmall = 2, scientific = FALSE)))

# View table1
View(table1_df)
table1_df2 <- t(table1_df)

# Export table1 to CSV
write.csv(table1_df2, "Reservoir_Summary_Table2.csv", row.names = TRUE)

### 4.2  TABLE 2. GHG Results

# named list of GHG parameters
ghg_vars <- list(
# CO2
  'CO2 diffusion (g CO2eq m2/yr)' = dd$CO2yrdiff_gCO2eqm2yr_GROSSINTEG,
  'Nonanthro. CO2 diffusion (g CO2eq m2/yr)' = dd$CO2yrdiff_gCO2eqm2yr_yr100,
  'Preimp. CO2 emissions (g CO2eq m2/yr)' = dd$preimpEM.gCO2eqm2yr,
  'CO2 emission minus non-anthro. (g CO2eq m2/yr)' = dd$CO2yrdiff_gCO2eqm2yr_NETINTEG,
  'Net CO2 emission (g CO2eq m2/yr)' = dd$CO2yrdiff_gCO2eqm2yr_NETINTEG.preimpCor,
# CH4
  'CH4 diffusion (g CO2eq m2/yr)' = dd$CH4yrdiff_gCO2eqm2yr_.INTEG,
  'CH4 ebullition (g CO2eq m2/yr)' = dd$CH4ebull_gCO2eqm2yr,
  'CH4 degassing (g CO2eq m2/yr)' = dd$CH4degas_gCO2eqm2yr_INT100yr,
  'Preimp. CH4 emissions (g CO2eq m2/yr)' = dd$preimpEM.CH4.gCO2eqm2yr + dd$CH4preimpwaterbodyemiss.gCO2eqm2yr,
  'Net CH4 emission (g CO2eq m2/yr)' = dd$CH4.NET.gCO2eqm2yr,
# N2O
  'Net N2O, ds1 (method A) (g CO2eq m2/yr)' = dd$N2Oemm.total.gCO2eqm2yr.ds1,
  'Net N2O, ds2 (method B) (g CO2eq m2/yr)' = dd$N2Oemm.total.gCO2eqm2yr.ds2,
  'Net N2O, mean (g CO2eq m2/yr)' = dd$N2Oemm.total.gCO2eqm2yr.mean,
# ALL GHG
  'Total net Em CO2+CH4 (g CO2eq m2/yr)' = dd$NetEmission_C.gCO2eqm2yr,
  'Total net Em CO2+CH4+N2O (g CO2eq m2/yr)' = dd$NetEmission_CN.gCO2eqm2yr)

# to data frame
ghg_table <- do.call(rbind, ghg_vars)
colnames(ghg_table) <- dd$X_key  # Reservoir names as columns
rownames(ghg_table) <- names(ghg_vars)
ghg_table <- as.data.frame(ghg_table)

# format - no scientific notation, round to 2 dp
ghg_table <- as.data.frame(
  apply(ghg_table, c(1, 2), function(x) format(round(as.numeric(x), 2), nsmall = 2, scientific = FALSE)))

# View ghg_table
View(ghg_table)

ghg_table2 <- t(ghg_table)
# Export to CSV
write.csv(ghg_table2, "Reservoir_GHG_Summary_Table2.csv", row.names = TRUE)

#############################################################################################################################
#######################################################################################################################

#######################################################################################################################
#############################################################################################################################
### 4.3 PLOTS

### ========================== SETUP ==========================

# Define year vectors
years <- c(1, 5, 10, 20, 30, 40, 50, 65, 80, 100)

# Column names
co2_cols <- paste0("CO2yrdiff_gCO2eqm2yr_yr", years, ".preimpCor")
ch4_cols <- paste0("CH4yrdiff_gCO2eqm2yr_yr", years)


### =================== Plot 1: Net CO2 Emissions ===================
# "MYA_GHG_outputs.pdf" - shows em profiles in gCO2eqm2yr, appear to be final net diffusive emissions profiles, 
# ~ after subtracting 100yr flux, and preimpoundment emissions (where sinks = -ve, sources = +ve)
colnames(dd)

# avoid double use of "CO2yrdiff_gCO2eqm2yr_yr100.preimpCor" in 'co2_cols' and in 'dd' in following reshape
dd$nonanthroCO2 <- dd$CO2yrdiff_gCO2eqm2yr_yr100.preimpCor 

# to long format with adjusted emissions
dd_long_CO2 <- dd %>%
  select(
    X_key,
    all_of(co2_cols),
    nonanthroCO2,
    preimpEM.gCO2eqm2yr,
    CO2yrdiff_gCO2eqm2yr_NETINTEG.preimpCor
  ) %>%
  rename(
    non_anthropogenic = nonanthroCO2,
    preimp = preimpEM.gCO2eqm2yr,
    net_mean = CO2yrdiff_gCO2eqm2yr_NETINTEG.preimpCor
  ) %>%
  pivot_longer(
    cols = all_of(co2_cols),
    names_to = "year_label",
    values_to = "CO2_emission"
  ) %>%
  mutate(
    year = as.numeric(gsub("CO2yrdiff_gCO2eqm2yr_yr([0-9]+).*", "\\1", year_label)),
    adjusted_emission = CO2_emission - non_anthropogenic
  )

# annotation positions
label_positions_CO2 <- dd_long_CO2 %>%
  group_by(X_key) %>%
  summarise(
    y_pos = max(adjusted_emission, na.rm = TRUE) * 0.9,
    x_pos = max(year),
    non_anthropogenic = first(non_anthropogenic),
    preimp = first(preimp),
    net_mean = first(net_mean),
    .groups = "drop"
  )

# plot
plot1_NETCO2.EM_profiles <- ggplot(dd_long_CO2, aes(x = year, y = adjusted_emission)) +
  geom_line(aes(color = X_key, group = X_key)) +
  geom_point(aes(color = X_key, group = X_key), size = 2) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey") +
  geom_hline(data = label_positions_CO2, aes(yintercept = net_mean), linetype = "dashed", color = "red") +
  geom_text(
    data = label_positions_CO2,
    aes(x = x_pos, y = y_pos, label = paste0(
      "Non-anthropog. Em: ", round(non_anthropogenic, 1), "\n",
      "Pre-imp. Em: ", round(preimp, 1), "\n",
      "Mean Annual Net Em: ", round(net_mean, 1)
    )),
    hjust = 1, vjust = 1, size = 3
  ) +
  facet_wrap(~X_key, scales = "free_y") +
  labs(
    x = "Year",
    y = "CO2 Emission (g CO2eq m²/yr)",
    title = "Net CO2 Emission Profiles",
    subtitle = "~diffusive emission timeseries corrected for pre-impound. and non-anthro. emissions"
  ) +
  theme_bw() +
  theme(legend.position = "none")

### =================== Plot 2: Net CH4 Emissions ===================
# This is the timeseries of diffusive em vs time, to which the static annual values of ebullition,
# and degassing are added, and the preimpoundment em substracted. 

# to long
dd_long_CH4 <- dd %>%
  select(
    X_key, all_of(ch4_cols),
    CH4ebull_gCO2eqm2yr, CH4degas_gCO2eqm2yr_INT100yr,
    preimpEMTotalCH4.gCO2eqm2yr, CH4.NET.gCO2eqm2yr
  ) %>%
  pivot_longer(
    cols = all_of(ch4_cols),
    names_to = "year_label",
    values_to = "CH4_emission"
  ) %>%
  mutate(
    year = as.numeric(gsub("CH4yrdiff_gCO2eqm2yr_yr", "", year_label)),
    adjusted_emission = CH4_emission + CH4ebull_gCO2eqm2yr + CH4degas_gCO2eqm2yr_INT100yr - preimpEMTotalCH4.gCO2eqm2yr
  )

write.csv(dd_long_CO2, "dd_long_CO2.csv", row.names = FALSE)
write.csv(dd_long_CH4, "dd_long_CH4.csv", row.names = FALSE)

labels_CH4 <- dd_long_CH4 %>%
  group_by(X_key) %>%
  summarise(
    y_top = max(adjusted_emission, na.rm = TRUE),
    x_pos = max(year),
    ebull = first(CH4ebull_gCO2eqm2yr),
    degass = first(CH4degas_gCO2eqm2yr_INT100yr),
    preimp = first(preimpEMTotalCH4.gCO2eqm2yr),
    net_mean = first(CH4.NET.gCO2eqm2yr),
    .groups = "drop"
  ) %>%
  mutate(
    y1 = y_top * 0.95,
    y2 = y_top * 0.88,
    y3 = y_top * 0.81,
    y4 = y_top * 0.74
  )

plot_CH4 <- ggplot(dd_long_CH4, aes(x = year, y = adjusted_emission)) +
  geom_line(aes(color = X_key, group = X_key)) +
  geom_point(aes(color = X_key, group = X_key), size = 2) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey") +
  geom_hline(data = labels_CH4, aes(yintercept = net_mean), linetype = "dashed", color = "red") +
  geom_text(data = labels_CH4, aes(x = x_pos, y = y1, label = paste0("ebullition = ", round(ebull, 0))), hjust = 1, size = 2.5) +
  geom_text(data = labels_CH4, aes(x = x_pos, y = y2, label = paste0("degassing = ", round(degass, 0))), hjust = 1, size = 2.5) +
  geom_text(data = labels_CH4, aes(x = x_pos, y = y3, label = paste0("Mean Annual Net Em = ", round(net_mean, 0))), hjust = 1, size = 2.5, color = "red") +
  geom_text(data = labels_CH4, aes(x = x_pos, y = y4, label = paste0("pre-impound. Em = ", round(preimp, 0))), hjust = 1, size = 2.5) +
  facet_wrap(~X_key, scales = "free_y") +
  labs(
    x = "Year",
    y = "CH4 Emission (g CO2eq m²/yr)",
    title = "Net CH4 Emission Profiles",
    subtitle = "- diffusive emission timeseries + ebull., degass. & pre-impound. emissions"
  ) +
  theme_bw() +
  theme(legend.position = "none")

### ================ Plot 3: CH4 Diffusion Only ===================
# plot to replicate CH4 emission timeseries in MYA_GHG_outputs.pdf ~?
# Not entirely clear what the values in these plots correspond to? - the values look too high relative to 
# tabular values of CH4 emissions?


dd_long_CH4_diff <- dd %>%
  select(X_key, all_of(ch4_cols), CH4yrdiff_gCO2eqm2yr_.INTEG) %>%
  pivot_longer(
    cols = all_of(ch4_cols),
    names_to = "year_label",
    values_to = "CH4_emission"
  ) %>%
  mutate(
    year = as.numeric(gsub("CH4yrdiff_gCO2eqm2yr_yr", "", year_label))
  )

labels_CH4_diff <- dd_long_CH4_diff %>%
  group_by(X_key) %>%
  summarise(
    y_label = max(CH4_emission, na.rm = TRUE) * 0.9,
    x_label = max(year),
    mean_diff = first(CH4yrdiff_gCO2eqm2yr_.INTEG),
    .groups = "drop"
  )

plot_CH4_diffusion_only <- ggplot(dd_long_CH4_diff, aes(x = year, y = CH4_emission)) +
  geom_line(aes(color = X_key, group = X_key)) +
  geom_point(aes(color = X_key, group = X_key), size = 2) +
  geom_hline(data = labels_CH4_diff, aes(yintercept = mean_diff), linetype = "dashed", color = "red") +
  geom_text(data = labels_CH4_diff,
            aes(x = x_label, y = y_label, label = paste0("Mean Annual diffusion = ", round(mean_diff, 0))),
            hjust = 1, size = 2.5) +
  facet_wrap(~X_key, scales = "free_y") +
  labs(
    x = "Year",
    y = "CH4 Diffusion (g CO2eq m²/yr)",
    title = "CH4 Diffusive Emission Profiles",
    subtitle = " -diffusive emissions only"
  ) +
  theme_bw() +
  theme(legend.position = "none")

plot_CH4_diffusion_only

########################################################################################################################
# Compile Plots
#
# OUTPUTS - plot names
#plot_CH4_diffusion_only
#plot_CH4
#plot1_NETCO2.EM_profiles

all3plots <- multiplot(plot1_NETCO2.EM_profiles, plot_CH4, plot_CH4_diffusion_only,cols =3)

# options to export plots
#ggsave(
#  filename = "NetCO2_Emission_Profiles.tiff",   # Output filename
#  plot = plot1_NETCO2.EM_profiles,              # Your ggplot object
#  device = "tiff",                              # File format
#  dpi = 100,                                    # Resolution (DPI)
#  width = 10,                                   # Width in inches
#  height = 8,                                   # Height in inches
#  units = "in"                                  # Units for width/height
#)

# ggsave("CH4_Net_Emission_Profiles.tiff", plot = plot_CH4, width = 10, height = 6, dpi = 100)
# ggsave("CH4_Diffusion_Only_Profiles.tiff", plot = plot_CH4_diffusion_only, width = 10, height = 6, dpi = 300)
#######################################################################################################################

#######################################################################################################################
#######################################################################################################################
#END
#######################################################################################################################

### NOTES ON N2O calcs

# General info on approaches	
# There is no time dependence of emissions - they reflect total nitrogen loading to the system, water residence time, 
# and Nitrogen:phosphorus stoichiometry with regard to N fixation	
	
#The N20 Emissions are computed by two approaches, termed default scenario 1 (DS1) and default scenario 2 (DS2) 
#as per notation used in source (Maarvara et al. 2018). 
#These are both employed towards providing upper and lower bound emission estimates	
	
#DS1	
#Annual N denitrification	- estimated as a function of the riverine input of total nitrogen (TN)	
#Annual N fixation 		- estimated as a function of the riverine input of total nitrogen and total phosphorus 	
#The N2O produced by these processes is estimated by applying a default EF of 0.9% to each, as derived by Beaulieu et al (2011)	
#This total quantity is taken as the annual N2O emission from the system	
	
#DS2	
# Maarvara et al. 2018 derived a single relationship for estimating total N2O emissions as functions of riverine TN loading and water residence time	
# see also, Akbarzadeh  et al (2019)10.1029/2019GB006222	
# Annual N  fixation estimated as a function of the riverine input of total nitrogen and total phosphorus   * EF = 0.9%, as for DS1	
# An EF for denitrification derived to account for internal consumpton of N2O at longer residence times (equation.10 -  Maarvara et al 2018);
# ie. not the 0.9% value used above for DS1, but the same means for estimating denitrification	
# A further adjustment of emissions to account for N2O evasion only occurrring where water N2O is above atmospheric.

#On the basis of the differences between these approaches (DS1; DS2), DS2 should provide lower evasion estimates, 
#with the difference between them increasing with water residence time.	
#However, at very short residence times there will be little difference between the approaches; and DS1 may even provide somewhat lower values than DS2.		
	
#Beaulieu, J. J., Tank, J. L., Hamilton, S. K., Wollheim, W. M., Hall, R. O.,	
#Mulholland, P. J., � Dahm, C. N. (2011). Nitrous oxide emission from	
#denitrification in stream and river networks. Proceedings of the	
#National Academy of Sciences of the United States of America, 108(1),	
#214�219. https://doi.org/10.1073/pnas.1011464108	
		
#The Key input variables required to compute N2O emission are:	
	
# Annual total nitrogen loading 	
# This load estimate employes a regression model for predicting the median annual TN concentration of runoff to the reservoir (McDowell)
# This model is derived uing empirical data for all annual months in tropical regions, 
# ***** but is limited to summer months beyond the tropics *******
# For application to temperate regions, a different TN export model is required.....
# A modified TN export coefficient model for large UK rivers is included herein, but is not coded formally	
	
# Annual total phosphorus loading	
# This load estimate is the same as that computed for use in the estimation of CO2 emissions.	
# Two options are available: 
# 1. the model employed in Gres (but with modifiable coefficients)
#  - Prairie and Kalff (1986) Effect of catchment size on phosphorus export. Water Resources Bulletin. vol 22:3
# 2. The 'McDowell' model: McDowell et al. 2020. https://doi.org/10.1038/s41598-020-60279-w
# 
# For cohesion, it may be best to use the McDowell (MD) TP and TN export models to predict these reservoir loads
# rather than Gres TP and MD TN.
# ; The lower TP predictions via MD  alter N:P stoichiometry, with impacts on estimated N dynamics and N2O
	
#Downstream TN export 
#This quantity is not  required in the case of estimating N2O emissions . 	
#in the case cascading reservoirs, the estimated downstream flux can be used in estimation of the influx to lower reservoirs

########################################################################################################################################################
########################################################################################################################################################