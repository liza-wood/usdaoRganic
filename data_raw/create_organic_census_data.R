get_combined_census_data <- function(){
  # 2012 report: "https://agcensus.library.cornell.edu/wp-content/uploads/2012-organictab-1.pdf"
  df12 <- suppressMessages(usda_pdf_to_df('data_raw/source/organictab_2012.pdf', 2012, 7))
  # 2017 report: "https://www.nass.usda.gov/Publications/AgCensus/2017/Online_Resources/Organics_Tabulation/organictab.pdf"
  df17 <- suppressMessages(usda_pdf_to_df('data_raw/source/organictab_2017.pdf', 2017, 12))
  # 2022 report: https://www.nass.usda.gov/Publications/AgCensus/2022/index.php
  df22 <- suppressMessages(usda_excel_to_df('data_raw/source/organictab_2022.xlsx', 2022, 12))
  df <- rbind(df12, df17, df22)
  colnames(df) <- c("state", "acreage_range", "total_farm_count",
                    "certified_ops_count", "org_under50perc_sales_count",
                    "org_over50perc_sales_count", "exempt_from_cert_count",
                    "organic_ops_count", "year")
  return(df)
}

# get_combined_data is in utils
# Run if ever need to refresh
organic_census <- get_combined_census_data()
usethis::use_data(organic_census, overwrite = T)
