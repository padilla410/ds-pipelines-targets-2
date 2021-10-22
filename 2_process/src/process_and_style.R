#' Process NWIS data for plotting
#'
#' @param nwis_data upstream `targets` object, raw NWIS data
#' @param nwis_site_data chr, full file path for NWIS site data
#' @param fileout chr, complete path and file name for clean data
#' 
process_data <- function(nwis_data, nwis_site_data, fileout = "2_process/out/nwis_data_clean.csv"){
  # rename default NWIS parameterCd names into human-readable format
  # and remove parameter code columns
  site_data <- read_csv(nwis_data, show_col_types = F)
  nwis_data_clean <- rename(site_data, water_temperature = X_00010_00000) %>% 
    select(-agency_cd, -X_00010_00000_cd, -tz_cd)
  
  # combine data with site metadata, select columns of interest, 
  # add human-readable names, and convert type for plotting
  site_info <- read_csv(nwis_site_data, show_col_types = F)
  annotated_data <- left_join(nwis_data_clean, site_info, by = "site_no") %>% 
    select(station_name = station_nm, site_no, dateTime, water_temperature, 
           latitude = dec_lat_va, longitude = dec_long_va) %>% 
    mutate(station_name = as.factor(station_name))
  
  readr::write_csv(annotated_data, file = fileout)
  
  return(fileout)
}
