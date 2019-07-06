# identifying_gentrification
A Data Science Approach to Identifying Gentrification in Providence, RI

File descriptions:

For analysis and data preparation:

Panel_Mar27.csv  |  This csv is a panel dataset constructed from downloaded data from the Neighborhood Change Database, contains data for 1980, 1990, 2000, 2010 adjused for 2010 geographic boundaries.

panel_prepMar21.R  |  This R file takes in the Panel_Mar27.csv to create 3 datasets which sumarize the change in metrics over each decade.

vscc_Mar22.R  |  This R file takes in the output from panel_prepMar21.R to feed it into the vscc R package. This runs the LTA analysis on each decade to determine the clustering for each census tract.


For mapping:

gz_2010_44_140_00_500k  |  This folder contains the Cartographic Boundary Files from the Census Bureau's TIGER database. It is needed for GIS mapping of 2010 census tract boundaries.

nbhd_change_socialexp.csv  |  This csv contains the number of every census tract in the sample, latitude and longitude points, and the cluster it was placed in for each decade.

gis_lta.R  |  This script uses gz_2010_44_140_00_500k and nbhd_change_socialexp.csv to map the cluster assignment of each census tract. This script was modified based on code by Robin Lovelace, which can be found here: https://github.com/Robinlovelace/Creating-maps-in-R/blob/master/R/intro-spatial.R
