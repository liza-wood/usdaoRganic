# NASS Census Tabs
library(stringr)
library(dplyr)

states <- c("Total","Alabama","Alaska","Arizona","Arkansas","California",
            "Colorado","Connecticut","Delaware","Florida","Georgia","Hawaii",
            "Idaho","Illinois","Indiana","Iowa","Kansas","Kentucky","Louisiana",
            "Maine","Maryland","Massachusetts","Michigan","Minnesota",
            "Mississippi","Missouri","Montana","Nebraska","Nevada",
            "New Hampshire","New Jersey","New Mexico","New York","North Carolina",
            "North Dakota","Ohio","Oklahoma","Oregon","Pennsylvania",
            "Rhode Island","South Carolina","South Dakota","Tennessee","Texas",
            "Utah","Vermont","Virginia","Washington","West Virginia",
            "Wisconsin","Wyoming")
acres_cat7 <- c("1 to 9", "10 to 49", "50 to 179", "180 to 499",
                "500 to 999", "1,000 to 1,999", "2,000 +")
acres_cat12 <- c("1 to 9", "10 to 49", "50 to 69", "70 to 99", "100 to 139",
                 "140 to 179", "180 to 219", "220 to 259", "260 to 499",
                 "500 to 999", "1,000 to 1,999", "2,000 +")

usda_pdf_to_df <- function(pdf_path, year, cropcat_n){
  if(cropcat_n == 7){
    acres_cat <- acres_cat7
  } else if(cropcat_n == 12){
    acres_cat <- acres_cat12
  } else{
    acres_cat <- "Error"
  }

  if("Error" %in% acres_cat){
    print("You've entered a crop category arguement that is not compatible. Try 7 or 12.")
    stop()
  }
  # Read in PDF
  txt <- pdftools::pdf_text(pdf_path)
  # Start with size. Extract text and pull out acres based on crop category
  pgs <- txt[str_which(txt, 'FARMS BY SIZE')]
  start <- str_locate(pgs, 'FARMS BY SIZE')[,2]
  end <- str_locate(pgs, 'FARMS BY NORTH AMERICAN INDUSTRY')[,1]
  info <- str_sub(pgs, start+1, (end-1))
  info <- str_squish(str_remove_all(info, "\\."))
  if(cropcat_n == 7){
    n1 <- str_remove_all(str_extract(info,
                                     "(?<=1 to 9 acres )[0-9, \\-]+(?=10 to)"), ",")
    n2 <- str_remove_all(str_extract(info,
                                     "(?<=10 to 49 acres )[0-9, \\-]+(?=50 to)"), ",")
    n3 <- str_remove_all(str_extract(info,
                                     "(?<=50 to 179 acres )[0-9, \\-]+(?=180 to)"), ",")
    n4 <- str_remove_all(str_extract(info,
                                     "(?<=180 to 499 acres )[0-9, \\-]+(?=500 to)"), ",")
    n5 <- str_remove_all(str_extract(info,
                                     "(?<=500 to 999 acres )[0-9, \\-]+(?=1,000 to)"), ",")
    n6 <- str_remove_all(str_extract(info,
                                     "(?<=1,000 to 1,999 acres )[0-9, \\-]+(?=2,000)"), ",")
    n7 <- str_remove_all(str_extract(info,
                                     "(?<=2,000 acres or more )[0-9, \\-]+"), ",")
    counts <- c(n1, n2, n3, n4, n5, n6, n7)
  } else if(cropcat_n == 12){
    n1 <- str_remove_all(str_extract(info,
                                     "(?<=1 to 9 acres )[0-9, \\-]+(?=10 to)"), ",")
    n2 <- str_remove_all(str_extract(info,
                                     "(?<=10 to 49 acres )[0-9, \\-]+(?=50 to)"), ",")
    n3 <- str_remove_all(str_extract(info,
                                     "(?<=50 to 69 acres )[0-9, \\-]+(?=70 to)"), ",")
    n4 <- str_remove_all(str_extract(info,
                                     "(?<=70 to 99 acres )[0-9, \\-]+(?=100 to)"), ",")
    n5 <- str_remove_all(str_extract(info,
                                     "(?<=100 to 139 acres )[0-9, \\-]+(?=140 to)"), ",")
    n6 <- str_remove_all(str_extract(info,
                                     "(?<=140 to 179 acres )[0-9, \\-]+(?=180 to)"), ",")
    n7 <- str_remove_all(str_extract(info,
                                     "(?<=180 to 219 acres )[0-9, \\-]+(?=220 to)"), ",")
    n8 <- str_remove_all(str_extract(info,
                                     "(?<=220 to 259 acres )[0-9, \\-]+(?=260 to)"), ",")
    n9 <- str_remove_all(str_extract(info,
                                     "(?<=260 to 499 acres )[0-9, \\-]+(?=500 to)"), ",")
    n10 <- str_remove_all(str_extract(info,
                                      "(?<=500 to 999 acres )[0-9, \\-]+(?=1,000 to)"), ",")
    n11 <- str_remove_all(str_extract(info,
                                      "(?<=1,000 to 1,999 acres )[0-9, \\-]+(?=2,000)"), ",")
    n12 <- str_remove_all(str_extract(info,
                                      "(?<=2,000 acres or more )[0-9, \\-]+"), ",")

    counts <- c(n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12)
  }

  df <- data.frame("location" = states,
                   "size" = rep(acres_cat, each = length(states)),
                   'counts' = trimws(counts))

  df$counts <- str_replace_all(df$counts, '-', "0")

  if(year == 2012){
    sep_cols <- c("all", "org_under50perc_sales",
                  "org_over50perc_sales")
  } else if(year == 2017){
    sep_cols <- c("all", "org_under50perc_sales",
                  "org_over50perc_sales", "exempt_from_cert")
  }
  df <- tidyr::separate(df, counts, into = sep_cols,
                        sep = " ")
  df[,3:ncol(df)] <- sapply(df[,3:ncol(df)], as.numeric)

  if(year == 2012){
    df$exempt_from_cert <- NA
  }

  df <- df %>%
    filter(location != "Total") %>%
    mutate(cert_organic_ops_total = org_under50perc_sales + org_over50perc_sales,
           all_organic_ops_total = cert_organic_ops_total + exempt_from_cert) %>%
    select(location, size, all, cert_organic_ops_total, org_under50perc_sales,
           org_over50perc_sales, exempt_from_cert, all_organic_ops_total) %>%
    arrange(location) %>%
    mutate(year = year)


  if(cropcat_n == 12){
    df <- df %>%
      mutate(size = case_when(
        size %in% acres_cat12[3:6] ~ acres_cat7[3],
        size %in% acres_cat12[7:9] ~ acres_cat7[4],
        T ~ size
      )) %>%
      group_by(location, size) %>%
      summarize(all = sum(all, na.rm = T),
                cert_organic_ops_total = sum(cert_organic_ops_total, na.rm = T),
                org_under50perc_sales = sum(org_under50perc_sales, na.rm = T),
                org_over50perc_sales = sum(org_over50perc_sales, na.rm = T),
                exempt_from_cert = sum(exempt_from_cert, na.rm = T),
                all_organic_ops_total = sum(all_organic_ops_total, na.rm = T)) %>%
      ungroup() %>%
      mutate(year = year)
  }
  return(df)
}

usda_excel_to_df <- function(excel_path, year, cropcat_n){
  df <- xlsx::read.xlsx(excel_path, sheetIndex = 1)
  colnames(df)[c(2,4,5:8)] <- c('location', 'size', 'all', 'org_under50perc_sales',
                                'org_over50perc_sales', 'exempt_from_cert')

  df <- df %>%
    filter(location %in% states,
           (str_detect(size, 'Farms by size\\:'))) %>%
    mutate(size = trimws(str_remove_all(size, 'Farms by size\\:| acres')),
           size = str_replace(size, 'or more', '+')) %>%
    mutate(all = case_when(all == '.' ~ 0,
                           T ~ as.numeric(all)),
           org_under50perc_sales = case_when(org_under50perc_sales == '.' ~ 0,
                                             T ~ as.numeric(org_under50perc_sales)),
           org_over50perc_sales = case_when(org_over50perc_sales == '.' ~ 0,
                                            T ~ as.numeric(org_over50perc_sales)),
           exempt_from_cert = case_when(exempt_from_cert == '.' ~ 0,
                                        T ~ as.numeric(exempt_from_cert))) %>%
    mutate(cert_organic_ops_total = as.numeric(org_under50perc_sales) +
             as.numeric(org_over50perc_sales),
           all_organic_ops_total = as.numeric(cert_organic_ops_total) +
             as.numeric(exempt_from_cert)) %>%
    select(location, size, all, cert_organic_ops_total, org_under50perc_sales,
           org_over50perc_sales, exempt_from_cert, all_organic_ops_total) %>%
    arrange(location) %>%
    mutate(year = year)

  if(cropcat_n == 12){
    df <- df %>%
      mutate(size = case_when(
        size %in% acres_cat12[3:6] ~ acres_cat7[3],
        size %in% acres_cat12[7:9] ~ acres_cat7[4],
        T ~ size
      )) %>%
      group_by(location, size) %>%
      summarize(all = sum(all, na.rm = T),
                cert_organic_ops_total = sum(cert_organic_ops_total, na.rm = T),
                org_under50perc_sales = sum(org_under50perc_sales, na.rm = T),
                org_over50perc_sales = sum(org_over50perc_sales, na.rm = T),
                exempt_from_cert = sum(exempt_from_cert, na.rm = T),
                all_organic_ops_total = sum(all_organic_ops_total, na.rm = T)) %>%
      ungroup()  %>%
      mutate(year = year)
  }

  return(df)
}

# 2012 report: "https://agcensus.library.cornell.edu/wp-content/uploads/2012-organictab-1.pdf"
#df12 <- usda_pdf_to_df('data/source/organictab_2012.pdf', 2017, 12)
# 2017 report: "https://www.nass.usda.gov/Publications/AgCensus/2017/Online_Resources/Organics_Tabulation/organictab.pdf"
#df17 <- usda_pdf_to_df('data/source/organictab_2017.pdf', 2017, 12)
# 2022 report: https://www.nass.usda.gov/Publications/AgCensus/2022/index.php
#df22 <- usda_excel_to_df('data/source/organictab_2022.xlsx', 2022, 12)

