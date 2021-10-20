#' @param site_no chr, 8-digit USGS NWIS gage number. Include leading zero.
#' @param pathout chr, file path for output `csv` file. Path only; do not include file name.
#' 
download_nwis_data <- function(site_no, pathout = '1_fetch/out/'){
  download_file <- paste(pathout, "/nwis_", site_no, ".csv", sep = "")
  download_nwis_site_data(download_file, parameterCd = '00010')
  return(download_file)
}

nwis_site_info <- function(fileout, site_data){
  site_no <- unique(site_data$site_no)
  site_info <- dataRetrieval::readNWISsite(site_no)
  write_csv(site_info, fileout)
  return(fileout)
}

#' staging for future function 
# combine_nwis_data <- function(in_dir){}
# 
# 

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

