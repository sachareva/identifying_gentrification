# identifying_gentrification
A Data Science Approach to Identifying Gentrification in Providence, RI

File descriptions:

For analysis and data preparation:



For mapping:

gz_2010_44_140_00_500k  |  This folder contains the Cartographic Boundary Files from the Census Bureau's TIGER database. It is needed for GIS mapping of 2010 census tract boundaries.

nbhd_change_socialexp.csv  |  This csv contains the number of every census tract in the sample, latitude and longitude points, and the cluster it was placed in for each decade.

gis_lta.R  |  This script uses gz_2010_44_140_00_500k and nbhd_change_socialexp.csv to map the cluster assignment of each census tract. This script was modified based on code by Robin Lovelace, which can be found here: https://github.com/Robinlovelace/Creating-maps-in-R/blob/master/R/intro-spatial.R
