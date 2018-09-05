# Function to read hobo files from Data Logger 
# @ajperez (ajperez@go.ugr.es)
# v.0.1 
# august 2018 

# arguments
# f: a vector with the full filenames of the hobo files
# Example --> f <- list.files(here::here("sensores/hoboRaw"), pattern= p, full.names = TRUE)

# This function do two main actions:
# a) For each .hobo file:
#   a1) read the hobo file
#   a2) create two variable with serial number and sensor name of the hobo files
#   a3) create variables of Battery Events if they do not exit 
#   a4) Put the data into correct format (i.e. Date format)
# b) Combine all hobo files into a tibble 

# Function returns a tibble with all data from hobo files 

preparaHobo <- function(f){
  
  require(dplyr)
  
  out <- c() 
  
  for(i in 1:length(f)){
    
    # Read file 
    # Suppress the output see https://github.com/tidyverse/readr/pull/527
    taux <- read_csv(f[i], na='', col_types = cols())
    
    
    # Get the name of the sensor and Serial Number
    sensor_name <- str_remove(basename(f[i]), "\\.csv")
    
    name_sn <- names(dplyr::select(taux, starts_with("Temp")))
    serial <- str_extract(name_sn, "\\d+")
    
    # Rename variables
    taux <- taux %>% 
      rename_all(.funs = funs(str_remove_all(names(taux), "\\d+|[:space:]|[#]"))) %>% 
      rename_at(vars(starts_with("Temp")), funs(paste0("Temp")))
    
    # Create new variables if they do not exist 
    taux <- taux %>% mutate(
      GoodBattery = if ("GoodBattery" %in% names(.)) { 
        return(GoodBattery)
      } else {return(NA)},
      BadBattery = if ("BadBattery" %in% names(.)) { 
        return(BadBattery)
      } else {return(NA)})
    
    # Convert Date format
    taux <- taux %>% mutate(Date = as.Date(Date, format = "%d/%m/%y"))
    
    # Add sensor name and Serial Number as variables 
    taux <- taux %>% mutate(
      serialNumber = serial, 
      sensorName = sensor_name)
    

    ## Delete first and last day 
    taux_val <- taux %>% 
      filter(.data$Date != min(.data$Date)) %>% 
      filter(.data$Date != max(.data$Date)) 

    out <- bind_rows(out, taux_val)
    
    
    # assign(sensor_name, taux)
    
  }
  return(out)
}


