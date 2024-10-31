#' Counts of organic operation sizes by state
#'
#' Inlcudes counts of 'all' farms (conventional),
#'
#' @format A tibble with 1050 rows and 9 variables:
#' \describe{
#'   \item{state}{a character denoting which of the 50 US states}
#'   \item{acreage_range}{a character denoting one of seven acreage categories}
#'   \item{total_farm_count}{a number denoting the count of all farms - conventional (and organic?)}
#'   \item{certified_ops_count}{a number denoting the count of certified operations (excludes exempt) }
#'   \item{org_under50perc_sales_count}{a number denoting the count of certified operations with organic sales under 50% of their sales}
#'   \item{org_over50perc_sales_count}{a number denoting the count of certified operations with organic sales over 50% of their sales}
#'   \item{exempt_from_cert_count}{a number denoting the count of operations exempt from organic certification}
#'   \item{organic_ops_count}{a number denoting the count of certified operations (includes exempt)}
#'   \item{year}{the year in which the census data were collected (2007, 2008, or 2009)}
#' }

#' @source {Gentoo penguins: Palmer Station Antarctica LTER and K. Gorman. 2020. Structural size measurements and isotopic signatures of foraging among adult male and female Gentoo penguin (Pygoscelis papua) nesting along the Palmer Archipelago near Palmer Station, 2007-2009 ver 5. Environmental Data Initiative.} \doi{10.6073/pasta/7fca67fb28d56ee2ffa3d9370ebda689}
#' @source {Chinstrap penguins: Palmer Station Antarctica LTER and K. Gorman. 2020. Structural size measurements and isotopic signatures of foraging among adult male and female Chinstrap penguin (Pygoscelis antarcticus) nesting along the Palmer Archipelago near Palmer Station, 2007-2009 ver 6. Environmental Data Initiative.} \doi{10.6073/pasta/c14dfcfada8ea13a17536e73eb6fbe9e}
#' @source {Originally published in: Gorman KB, Williams TD, Fraser WR (2014) Ecological Sexual Dimorphism and Environmental Variability within a Community of Antarctic Penguins (Genus Pygoscelis). PLoS ONE 9(3): e90081. doi:10.1371/journal.pone.0090081}
"organic_census"
