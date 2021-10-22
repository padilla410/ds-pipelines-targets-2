source("1_fetch/src/get_nwis_data.R")

p1_targets_list <- list(
  # download data
  tar_target(
    p1_nwis_01427207,
    download_nwis_site_data(site_num = "01427207")
  ),
  
  tar_target(
    p1_nwis_01432160,
    download_nwis_site_data(site_num = "01432160")
  ),
  
  tar_target(
    p1_nwis_01436690,
    download_nwis_site_data(site_num = "01436690")
  ),
  
  tar_target(
    p1_nwis_01466500,
    download_nwis_site_data(site_num = "01466500")
  ),
  
  # combine each location into one target
  tar_target(
    p1_site_data_csv,
    combine_nwis_data(list(p1_nwis_01427207, p1_nwis_01432160,
                           p1_nwis_01436690, p1_nwis_01466500)),
    format = "file"
  ),
  
  # grab site info for each site of interest
  tar_target(
    p1_site_info_csv,
    nwis_site_info(fileout = "1_fetch/out/site_info.csv", p1_site_data_csv),
    format = "file"
  )
)