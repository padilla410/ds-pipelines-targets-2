library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

p1_targets_list <- list(
  # download data
  tar_target(
    nwis_01427207_csv,
    download_nwis_site_data(filepath = "1_fetch/out/nwis_01427207.csv"),
    format = "file"
  ),
  
  tar_target(
    nwis_01432160_csv,
    download_nwis_site_data(filepath = "1_fetch/out/nwis_01432160.csv"),
    format = "file"
  ),
  
  tar_target(
    nwis_01436690_csv,
    download_nwis_site_data(filepath = "1_fetch/out/nwis_01436690.csv"),
    format = "file"
  ),
  
  tar_target(
    nwis_01466500_csv,
    download_nwis_site_data(filepath = "1_fetch/out/nwis_01466500.csv"),
    format = "file"
  ),

  # combine each location into one target
  tar_target(
    site_data,
    combine_nwis_data(c(nwis_01427207_csv, nwis_01432160_csv,
                        nwis_01436690_csv, nwis_01466500_csv)
                      )
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

