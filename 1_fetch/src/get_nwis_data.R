#' Download NWIS site data
#' 
#' Download site metadata from NWIS
#' 
#' @param file_out chr, valid 8-digit USGS NWIS gage number. Include leading zero.
#' @param site_data_csv upstream `targets` file
#' 
nwis_site_info <- function(fileout, site_data_csv){
  site_data <- readr::read_csv(site_data_csv, show_col_types = F)
  
  site_no <- unique(site_data$site_no)
  site_info <- dataRetrieval::readNWISsite(site_no)
  write_csv(site_info, fileout)
  return(fileout)
}

#' Combine NWIS data files 
#' 
#' Combine NWIS data files into one `data.table`
#' 
#' @param data chr, list of R objects generated from upstream targets
#' 
combine_nwis_data <- function(data, fileout = '1_fetch/out/site_data.csv'){
  data_out <- dplyr::bind_rows(data)
  readr::write_csv(data_out, file = fileout)
  
  return(fileout)
}

#' Download NWIS Data
#' 
#' Download instantaneous data from NWIS. THis function is called internally by `download_nwis_data`
#' 
#' @param site_no chr, 8-digit USGS gage code. Include leading zero.
#' @param parameterCd chr, parameter code corresponding to a valid USGS parameter code. Complete list of parameters here: https://help.waterdata.usgs.gov/codes-and-parameters/parameters
#' @param startDate chr, start date for period of record. "YYYY-MM-DD" format.
#' @param endDate chr, end date for period of record. "YYYY-MM-DD" format.
#' 
download_nwis_site_data <- function(site_num, parameterCd = '00010', startDate="2014-05-01", endDate="2015-05-01"){

  # filepaths look something like directory/nwis_01432160_data.csv,
  # remove the directory with basename() and extract the 01432160 with the regular expression match
  # site_num <- basename(filepath) %>%
  #   stringr::str_extract(pattern = "(?:[0-9]+)")

  # readNWISdata is from the dataRetrieval package
  data_out <- readNWISdata(sites=site_num, service="iv",
                           parameterCd = parameterCd, startDate = startDate, endDate = endDate)

  # -- simulating a failure-prone web-sevice here, do not edit --
  set.seed(Sys.time())
  if (sample(c(T,F,F,F), 1)){
    stop(site_num, ' has failed due to connection timeout. Try tar_make() again')
  }
  # -- end of do-not-edit block

  return(data_out)
}

