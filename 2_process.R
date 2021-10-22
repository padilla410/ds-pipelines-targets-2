source("2_process/src/process_and_style.R")

p2_targets_list <- list(
  tar_target(
    p2_site_data_clean_csv,
    process_data(nwis_data = p1_site_data_csv, nwis_site_data = p1_site_info_csv),
    format = "file"
  )
)