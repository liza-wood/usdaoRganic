#' Read ad combine USDA Organic Census tables
#'
#' Reads in PDF/Excel files from USDA generates a data frame. This function does not require any parameters
#'
#'
#' @return A data frame of USDA organic census data, to be saved as organic_census
#'
#' @export


get_combined_data <- function(){
  # 2012 report: "https://agcensus.library.cornell.edu/wp-content/uploads/2012-organictab-1.pdf"
  df12 <- suppressMessages(usda_pdf_to_df('data/source/organictab_2012.pdf', 2012, 7))
  # 2017 report: "https://www.nass.usda.gov/Publications/AgCensus/2017/Online_Resources/Organics_Tabulation/organictab.pdf"
  df17 <- suppressMessages(usda_pdf_to_df('data/source/organictab_2017.pdf', 2017, 12))
  # 2022 report: https://www.nass.usda.gov/Publications/AgCensus/2022/index.php
  df22 <- suppressMessages(usda_excel_to_df('data/source/organictab_2022.xlsx', 2022, 12))
  df <- rbind(df12, df17, df22)
  colnames(df) <- c("state", "acreage_range", "total_farm_count",
                    "certified_ops_count", "org_under50perc_sales_count",
                    "org_over50perc_sales_count", "exempt_from_cert_count",
                    "organic_ops_count", "year")
  df$year[df$year == 2012] <- 2010
  df$year[df$year == 2017] <- 2015
  df$year[df$year == 2022] <- 2020
  return(df)
}
