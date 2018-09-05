# Function to validate hobo data derived from preparaHobo.R function 
# @ajperez (ajperez@go.ugr.es)
# v.0.1 
# august 2018 

# arguments
# x: a tibble with data from preparaHobo.R 
# vnameTemp: name of the variable Temperature
# vnameDate: name of the variable Date 

# a) Create flags for bad Battery events. -1 = bad events, 1 = good events
# b) Validate values using sensor specifications
#       Validate temperature range (-20 to 70 C degree) in air. 
#       See http://www.onsetcomp.com/products/data-loggers/utbi-001
# c) Remove first and last day 


validaHobo <- function(df, vnameTemp) { 
  
  require(dplyr)
  
  # aux <- df %>% mutate(
  #   bB = as.numeric(if_else(is.na(BadBattery), 0, -1)),
  #   gB = as.numeric(if_else(is.na(GoodBattery), 0, 1)),
  #   aux_flag = bB + gB,
  #   # https://stackoverflow.com/questions/20416046/filling-data-frame-with-previous-row-value 
  #   flag = ave(aux_flag, cumsum(aux_flag), FUN = function(x) x[x !=0])) %>% 
  #   dplyr::select(-c(bB,gB,aux_flag))
  # 
  
  # Validate temperature range (-20 to 70 C degree) in air. 
  # See http://www.onsetcomp.com/products/data-loggers/utbi-001
  validdf <- df %>% 
    mutate(valid = if_else(
      .[[vnameTemp]] < -20, 0, if_else(.[[vnameTemp]] >= 70, 0, 1)
    )) 
  
  return(validdf)
  
}   
