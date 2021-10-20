library(targets)
source("1_fetch/src/get_nwis_data.R")
source("2_process/src/process_and_style.R")
source("3_visualize/src/plot_timeseries.R")

options(tidyverse.quiet = TRUE)
tar_option_set(packages = c("tidyverse", "dataRetrieval")) # Loading tidyverse because we need dplyr, ggplot2, readr, stringr, and purrr

# define NWIS stations of interest and file out paths
nwis_stn <- c("01427207", "01432160", "01436690", "01466500") # removing "01435000" because it returns an unexpected column name
fileout_stn <- paste0("1_fetch/out/nwis_", nwis_stn, ".csv")
nwis_target <- paste0("nwis_", nwis_stn)

p1_targets_list <- list(
  # download data
  tar_target(
    nwis_target[1],
    download_nwis_data(site_no = nwis_stn[1], pathout = "1_fetch/out/"),
    format = "file"
  ),
  
  tar_target(
    nwis_target[2],
    download_nwis_data(site_no = nwis_stn[2], pathout = "1_fetch/out/"),
    format = "file"
  ),
  
  tar_target(
    nwis_target[3],
    download_nwis_data(site_no = nwis_stn[3], pathout = "1_fetch/out/"),
    format = "file"
  ),
  
  tar_target(
    nwis_target[4],
    download_nwis_data(site_no = nwis_stn[4], pathout = "1_fetch/out/"),
    format = "file"
  ),

  # combine into one data set
  tar_target(
    site_data,
    combine_nwis_data("1_fetch/out")
  ),
  
  # grab site info for each site of interest
  tar_target(
    site_info_csv,
    nwis_site_info(fileout = "1_fetch/out/site_info.csv", site_data),
    format = "file"
  )

  # make an `in_dir` style target to check the directory https://github.com/padilla410/ds-pipelines-targets-2/issues/3
  
  # tar_target(
  #   site_data,
  #   download_nwis_data(),
  # ),
  # tar_target(
  #   site_info_csv,
  #   nwis_site_info(fileout = "1_fetch/out/site_info.csv", site_data),
  #   format = "file"
  # )
)

# p2_targets_list <- list(
#   tar_target(
#     site_data_clean, 
#     process_data(site_data)
#   ),
#   tar_target(
#     site_data_annotated,
#     annotate_data(site_data_clean, site_filename = site_info_csv)
#   ),
#   tar_target(
#     site_data_styled,
#     style_data(site_data_annotated)
#   )
# )
# 
# p3_targets_list <- list(
#   tar_target(
#     figure_1_png,
#     plot_nwis_timeseries(fileout = "3_visualize/out/figure_1.png", site_data_styled),
#     format = "file"
#   )
# )

# Return the complete list of targets
# c(p1_targets_list, p2_targets_list, p3_targets_list)
c(p1_targets_list)
