library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

p1_targets_list <- list(
  # download data
  tar_target(
    nwis_01427207,
    download_nwis_data(site_no = "01427207", pathout = "1_fetch/out/"),
    format = "file"
  ),
  
  tar_target(
    nwis_01432160,
    download_nwis_data(site_no = "01432160", pathout = "1_fetch/out/"),
    format = "file"
  ),
  
  tar_target(
    nwis_01436690,
    download_nwis_data(site_no = "01436690", pathout = "1_fetch/out/"),
    format = "file"
  ),
  
  tar_target(
    nwis_01466500,
    download_nwis_data(site_no = "01466500", pathout = "1_fetch/out/"),
    format = "file"
  ),

  # combine data targets
  tar_target(in_files,
             c(nwis_01427207,
               nwis_01432160,
               nwis_01436690,
               nwis_01466500),
             format = "file"),
  
  # combine into one data set
  tar_target(
    site_data,
    combine_nwis_data(in_files)
  ),
  
  # grab site info for each site of interest
  tar_target(
    site_info_csv,
    nwis_site_info(fileout = "1_fetch/out/site_info.csv", site_data),
    format = "file"
  )
)

p2_targets_list <- list(
  tar_target(
    site_data_clean_csv,
    process_data(nwis_data = site_data, nwis_site_data = site_info_csv),
    format = "file"
  )
)

p3_targets_list <- list(
  tar_target(
    figure_1_png,
    plot_nwis_timeseries(filein = site_data_clean_csv, fileout = "3_visualize/out/figure_1.png"),
    format = "file"
  )
)

# Return the complete list of targets
c(p1_targets_list, p2_targets_list, p3_targets_list)

