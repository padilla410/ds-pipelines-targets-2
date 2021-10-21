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
    download_nwis_site_data(site_num = "01427207")
  ),
  
  tar_target(
    nwis_01432160,
    download_nwis_site_data(site_num = "01432160")
  ),
  
  tar_target(
    nwis_01436690,
    download_nwis_site_data(site_num = "01436690")
  ),
  
  tar_target(
    nwis_01466500,
    download_nwis_site_data(site_num = "01466500")
  ),

  # combine each location into one target
  tar_target(
    site_data_csv,
    combine_nwis_data(list(nwis_01427207, nwis_01432160,
                        nwis_01436690, nwis_01466500)),
    format = "file"
  ),
  
  # grab site info for each site of interest
  tar_target(
    site_info_csv,
    nwis_site_info(fileout = "1_fetch/out/site_info.csv", site_data_csv),
    format = "file"
  )
)

p2_targets_list <- list(
  tar_target(
    site_data_clean_csv,
    process_data(nwis_data = site_data_csv, nwis_site_data = site_info_csv),
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

