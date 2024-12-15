# usdaoRganic 

This package provides two datasets: USDA Organic Census Tabulations (2012, 2017, 2022) & NOP Organic Operations Data (collected twice-annually, in Q2 and Q4 of each year, beginning April 4 2024).

These data are also uploaded to:

```
install.packages('usdaoRganic')
library(usdaoRganic)
```

## `organic_census`
For data from the USDA organic Census tabulations, use the following:

```
organic_census(year = 2012, var = "size")
```

The possible arguments for `year` are 2012, 2017, or 2022. The current arguments for `var` are "size" or "naics". Future versions of the data will expand the possible variables.

Each row represents the variable for each state in that year. 

The output is a data frame with the following:


These data are from the following sources: [2012 PDF](https://agcensus.library.cornell.edu/wp-content/uploads/2012-organictab-1.pdf), [2017 PDF](https://www.nass.usda.gov/Publications/AgCensus/2017/Online_Resources/Organics_Tabulation/organictab.pdf), [2022 Excel]( https://www.nass.usda.gov/Publications/AgCensus/2022/index.php). 


## `nop_certificates` 

These data are taken from the NOP database. Acreage was only required to be reported beginning March 2024.

Each row represents a farm. The output is a data frame with the following:


## data creation functions 

Details on how the datasets were curated from the raw data are available in the utility functions (R > utils): `create_organic_census_data.R` and `create_nop_certificate_data.R`. 
