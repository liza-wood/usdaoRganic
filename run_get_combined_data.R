# get_combined_data is in utils
# Run if ever need to refresh
df <- get_combined_data()
saveRDS(df, 'data/organic_census.RDS')
