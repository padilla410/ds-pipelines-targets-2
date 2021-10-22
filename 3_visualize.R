source("3_visualize/src/plot_timeseries.R")

p3_targets_list <- list(
  tar_target(
    p3_figure_1_png,
    plot_nwis_timeseries(filein = p2_site_data_clean_csv, fileout = "3_visualize/out/figure_1.png"),
    format = "file"
  )
)