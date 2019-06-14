#data download
#https://www.census.gov/geo/maps-data/data/tiger-cart-boundary.html
#https://cran.r-project.org/doc/contrib/intro-spatial-rl.pdf

x <- c("ggmap", "rgdal", "rgeos", "maptools", "dplyr", "tidyr", "tmap")
# install.packages(x) # warning: uncommenting this may take a number of minutes
lapply(x, library, character.only = TRUE) # load the required packages

og_data <- readOGR(dsn = "gz_2010_44_140_00_500k", layer = "gz_2010_44_140_00_500k")

head(og_data@data, n = 2)
mean(og_data$CENSUSAREA)
sapply(og_data@data, class)

#geo_id from our dataset, with classifications
og_8090 <- read.csv("nbhd_change_socialexp.csv", stringsAsFactors = TRUE)

#plot just providence county
prov_cty <- og_data[og_data$GEO_ID %in% og_8090$geo_id,]
plot(prov_cty)

og_data@data <- left_join(og_data@data, og_8090, by = c('GEO_ID' = 'geo_id'))
og_data <- og_data[!is.na(og_data@data$X8090),]

tmap_mode("view")

#trajectory map, same for all

tm_shape(og_data) +
  tm_fill("traj", title = "Cluster", style = "cat",
          breaks = c(1, 2, 3),
          palette = c("blue", "red")) +
  tm_borders() +
  tm_layout("LTA Classifications For All Decades",
            legend.title.size = 1,
            legend.text.size = .8,
            legend.position = c("left","bottom"),
            legend.bg.color = "white",
            legend.bg.alpha = 1) +
  tm_tiles("CartoDB.PositronOnlyLabels")

#8090 map
tm_shape(og_data) +
  tm_fill("X8090", title = "Cluster", style = "cat",
          breaks = c(1, 2, 3),
          palette = c("darkblue", "steelblue", "lightblue")) +
  tm_borders() +
  tm_layout("Classifications for 1980-1990",
            legend.title.size = 1,
            legend.text.size = .8,
            legend.position = c("left","bottom"),
            legend.bg.color = "white",
            legend.bg.alpha = 1)  +
  tm_tiles("CartoDB.PositronOnlyLabels")

#90-00 map, no time
tm_shape(og_data) +
  tm_fill("X9000", title = "Cluster", style = "cat",
          breaks = c(1, 2, 3),
          palette = c("lightblue", "steelblue")) +
  tm_borders() +
  tm_layout("Classifications for 1990-2000",
            legend.title.size = 1,
            legend.text.size = .8,
            legend.position = c("left","bottom"),
            legend.bg.color = "white",
            legend.bg.alpha = 1) +
  tm_tiles("CartoDB.PositronOnlyLabels")


#2000-2010 map, no time
tm_shape(og_data) +
  tm_fill("X10", title = "Cluster", style = "cat",
          breaks = c(1, 2, 3),
          palette = c("steelblue", "lightblue")) +
  tm_borders() +
  tm_layout("Classifications for 2000-2010",
            legend.title.size = 1,
            legend.text.size = .8,
            legend.position = c("left","bottom"),
            legend.bg.color = "white",
            legend.bg.alpha = 1)+
  tm_tiles("CartoDB.PositronOnlyLabels")
