get_combined_nop_data <- function(){
  fls <- list.files('data_raw/source/scraped/')
  df <- readRDS(fls)
  return(df)
}

# get_combined_data is in utils
# Run if ever need to refresh
nop_certificates <- get_combined_nop_data()
usethis::use_data(nop_certificates, overwrite = T)
