# Function to validate hobo data derived from preparaHobo.R function 
# @ajperez (ajperez@go.ugr.es)
# v.0.1 
# august 2018 

# arguments
# x: a tibble with data from preparaHobo.R 
# vnameDate: name of the variable Date 

# a) Create flags for bad Battery events. Bad = bad events, Good = good events
# b) Validate values using sensor specifications
#       Validate temperature range (-20 to 70 C degree) in air. 
#       See http://www.onsetcomp.com/products/data-loggers/utbi-001


validaHobo <- function(df, vnameTemp) { 
  
  require(dplyr)
  require(zoo)

  # Create flag column 
  # See https://markhneedham.com/blog/2015/06/28/r-dplyr-update-rows-with-earlierprevious-rows-values/ 
  aux <- df %>% mutate(
    auxFlag = ifelse(is.na(BadBattery) & is.na(GoodBattery), NA, 
                     ifelse(!is.na(BadBattery), 'Bad', 'Good')),
    flag0 = zoo::na.locf0(auxFlag)) %>% 
    mutate(flag = ifelse(is.na(flag0), 'Good',flag0)) %>% 
    dplyr::select(-c(auxFlag, flag0))
  

  # Validate temperature range (-20 to 70 C degree) in air. 
  # See http://www.onsetcomp.com/products/data-loggers/utbi-001
  validdf <- aux %>% 
    mutate(valid = if_else(
      .[[vnameTemp]] < -20, 0, if_else(.[[vnameTemp]] >= 70, 0, 1)
    )) 
  
  return(validdf)
  
}   
