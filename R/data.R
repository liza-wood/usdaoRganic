#' Organic census
#'
#' Inlcudes counts of 'all' farms (conventional),
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


"organic_census"
