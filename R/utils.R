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
naics <- c("Oilseed and grain farming (1111)",
           "Vegetable and melon farming (1112)",
           "Fruit and tree nut farming (1113)",
           "Greenhouse, nursery, and floriculture production (1114)",
           "Tobacco farming (11191)",
           "Cotton farming (11192)",
           "Sugarcane farming, hay farming, and all other crop farming (11193,11194,11199)",
           "Beef cattle ranching and farming (112111)",
           "Cattle feedlots (112112)",
           "Dairy cattle and milk production (11212)",
           "Hog and pig farming (1122)",
           "Poultry and egg production (1123)",
           "Sheep and goat farming (1124)",
           "Animal aquaculture and other animal production (1125, 1129)")

usda_pdf_to_df <- function(pdf_path, year, var = 'size', cropcat_n){
  # Read in PDF
  txt <- pdftools::pdf_text(pdf_path)

  # Chose which variable to work with"
  if(var == "size"){
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

      acre_counts <- c(n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12)
    }

    df <- data.frame("location" = states,
                     "size" = rep(acres_cat, each = length(states)),
                     'counts' = trimws(counts))

  } else if(var == "naics"){
    # Move on to: NAICS. Extract text and pull out acres based on crop category
    pgs <- txt[str_which(txt, 'FARMS BY NORTH AMERICAN INDUSTRY')]
    start <- str_locate(pgs, 'FARMS BY NORTH AMERICAN INDUSTRY')[,2]
    end <- str_locate(pgs, 'OTHER FARM CHARACTERISTICS')[,1]
    info <- str_sub(pgs, start+1, (end-1))
    info <- str_squish(str_remove_all(info, "\\."))
    c1 <- str_remove_all(str_extract(info,
                                     "(?<=\\(1111\\))[0-9, \\-]+(?=Vegetable and melon)"), ",")
    c2 <- str_remove_all(str_extract(info,
                                     "(?<=\\(1112\\))[0-9, \\-]+(?=Fruit and tree)"), ",")
    c3 <- str_remove_all(str_extract(info,
                                     "(?<=\\(1113\\))[0-9, \\-]+(?=Greenhouse)"), ",")
    c4 <- str_remove_all(str_extract(info,
                                     "(?<=\\(1114\\))[0-9, \\-]+(?=Other crop)"), ",")
    c5 <- str_remove_all(str_extract(info,
                                     "(?<=\\(11191\\))[0-9, \\-]+(?=Cotton)"), ",")
    c6 <- str_remove_all(str_extract(info,
                                     "(?<=\\(11192\\))[0-9, \\-]+(?=Sugarcane)"), ",")
    c7 <- str_remove_all(str_extract(info,
                                     "(?<=\\(11193,11194,11199\\))[0-9, \\-]+(?=Beef)"), ",")
    c8 <- str_remove_all(str_extract(info,
                                     "(?<=\\(112111\\))[0-9, \\-]+(?=Cattle feedlots)"), ",")
    c9 <- str_remove_all(str_extract(info,
                                     "(?<=\\(112112\\))[0-9, \\-]+(?=Dairy)"), ",")
    c10 <- str_remove_all(str_extract(info,
                                     "(?<=\\(11212\\))[0-9, \\-]+(?=Hog)"), ",")
    c11 <- str_remove_all(str_extract(info,
                                      "(?<=\\(1122\\))[0-9, \\-]+(?=Poultry)"), ",")
    c12 <- str_remove_all(str_extract(info,
                                      "(?<=\\(1123\\))[0-9, \\-]+(?=Sheep)"), ",")
    c13 <- str_remove_all(str_extract(info,
                                      "(?<=\\(1124\\))[0-9, \\-]+(?=Animal aquaculture)"), ",")
    c14 <- str_remove_all(str_extract(info,
                                      "(?<=\\(1125, 1129\\))[0-9, \\-]+"), ",")
    counts <- c(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14)

    df <- data.frame("location" = states,
                     "naics" = rep(naics, each = length(states)),
                     'counts' = trimws(counts))
  }

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
    mutate(all_organic_ops_total = ifelse(is.na(all_organic_ops_total),
                                          cert_organic_ops_total, all_organic_ops_total)) %>%
    select(location, size, all, cert_organic_ops_total, org_under50perc_sales,
           org_over50perc_sales, exempt_from_cert, all_organic_ops_total) %>%
    arrange(location) %>%
    mutate(year = year)


  if(var == "size" & cropcat_n == 12){
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

usda_excel_to_df <- function(excel_path, year = 2022, var = 'size', cropcat_n = 12){
  df <- xlsx::read.xlsx(excel_path, sheetIndex = 1)
  colnames(df)[c(2:4,5:8)] <- c('location', 'group', 'var', 'all',
                                'org_under50perc_sales',
                                'org_over50perc_sales', 'exempt_from_cert')

  if(var == 'size'){
    df <- df %>%
      filter(location %in% states,
             group == "Farms by size") %>%
      mutate(size = trimws(str_remove_all(var, 'Farms by size\\:| acres')),
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
    } else if(var == 'naics'){
      df <- df %>%
        filter(location %in% states,
               group == "Farms by North American Industry Classification System (NAICS)") %>%
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
        select(location, var, all, cert_organic_ops_total, org_under50perc_sales,
               org_over50perc_sales, exempt_from_cert, all_organic_ops_total) %>%
        arrange(location) %>%
        mutate(year = year)
    }
  }
  return(df)
}

nop_scrape <- function(excel_path, collection_year, collection_quarter)

