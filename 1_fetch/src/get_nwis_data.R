#' Download NWIS site data
#' 
#' Download site metadata from NWIS
#' 
#' @param file_out chr, valid 8-digit USGS NWIS gage number. Include leading zero.
#' @param site_data upstream `targets` object
#' 
nwis_site_info <- function(fileout, site_data){
  site_no <- unique(site_data$site_no)
  site_info <- dataRetrieval::readNWISsite(site_no)
  write_csv(site_info, fileout)
  return(fileout)
}

#' Combine NWIS data files 
#' 
#' Combine NWIS data files into one `data.table`
#' 
#' @param filepath chr, file path where downloaded NWIS data files are stored
#' 
combine_nwis_data <- function(filepath){
  # data_files <- list.files(in_dir, pattern = 'nwis') %>% file.path(in_dir, .)
  data <- lapply(filepath, readr::read_csv)
  
  data_out <- dplyr::bind_rows(data)
}

#' Download NWIS Data
#' 
#' Download instantaneous data from NWIS. THis function is called internally by `download_nwis_data`
#' 
#' @param filepath chr, complete file path for file of interest
#' @param parameterCd chr, parameter code corresponding to a valid USGS parameter code. Complete list of parameters here: https://help.waterdata.usgs.gov/codes-and-parameters/parameters
#' @param startDate chr, start date for period of record. "YYYY-MM-DD" format.
#' @param endDate chr, end date for period of record. "YYYY-MM-DD" format.
#' 
download_nwis_site_data <- function(filepath, parameterCd = '00010', startDate="2014-05-01", endDate="2015-05-01"){

  # filepaths look something like directory/nwis_01432160_data.csv,
  # remove the directory with basename() and extract the 01432160 with the regular expression match
  site_num <- basename(filepath) %>%
    stringr::str_extract(pattern = "(?:[0-9]+)")

  # readNWISdata is from the dataRetrieval package
  data_out <- readNWISdata(sites=site_num, service="iv",
                           parameterCd = parameterCd, startDate = startDate, endDate = endDate)

  # -- simulating a failure-prone web-sevice here, do not edit --
  set.seed(Sys.time())
  if (sample(c(T,F,F,F), 1)){
    stop(site_num, ' has failed due to connection timeout. Try tar_make() again')
  }
  # -- end of do-not-edit block

  write_csv(data_out, file = filepath)
  return(filepath)
}

