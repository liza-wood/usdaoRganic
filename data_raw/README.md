

01: Scrape NOP data

When? Twice a year, ideally June and December 1, Q2 and Q4

1. Each scrape should have two source files to work with: the NOP database for 4 different status filters: First should have Certified, the second should have Surrendered, Suspended, or Revoked. Input each of these files and run the scraping function
2. For each, save into the scraped folder

02: Create NOP data

When? Twice a year, after scraping
1. 


03: create organic census data:

1. Only re-run if new census data have been added. If new data, continue
2. Save organic census data to data_raw/source
3. Review data first to determine if its organization fits within the current farm size categories (7 or 12 categories)
4. Add new dataframe to script to add to data
5. re-run, new data will be overwritten
