library(tidyverse)
library(mclust)
library(ggplot2)
library(rrcov)
library(vscc)

#og_data <- read.csv("latent_cluster_analysis_model/modified_panel.csv")
#og_data <- read.csv("latent_cluster_analysis_model/LTA_Apr17.csv")
og_data <- read.csv("latent_cluster_analysis_model/nbhd_change_socialexp.csv")

df_og <- as.data.frame(og_data)
df_mclust <- df_og
#df_mclust <- subset(df_og, select=-c(geo, geo1980))
df_8090 <- df_mclust %>% filter(year==1) %>% select(-geo, -areakey, -year)
df_9000 <- df_mclust %>% filter(year==2) %>% select(-geo, -areakey, -year)
df_0010 <- df_mclust %>% filter(year==3) %>% select(-geo, -areakey, -year)
df_llca <- df_mclust %>% select(-geo, -year1, -year2, -year3)

modllca <- vscc(df_llca, G=2:30, automate = "mclust", initial = NULL, train = NULL, forcereduction = TRUE)
mod8090$bestmodel$parameters #forcereduction true = 3 clusters, shrhsp and unemprt, if false 2 clusters and all vars
mod8090$bestmodel$bic
mod8090$bestmodel$classification
plot(mod8090$bestmodel)

mod8090 <- vscc(df_8090, G=2:15, automate = "mclust", initial = NULL, train = NULL, forcereduction = TRUE)
mod8090$bestmodel$parameters #forcereduction true = 3 clusters, shrhsp and unemprt, if false 2 clusters and all vars
mod8090$bestmodel$bic
mod8090$bestmodel$classification
plot(mod8090$bestmodel)

mod9000 <- vscc(df_9000, G=2:15, automate = "mclust", initial = NULL, train = NULL, forcereduction = TRUE)
mod9000$bestmodel$parameters
mod9000$bestmodel$bic
mod9000$bestmodel$classification
plot(mod9000$bestmodel)

mod0010 <- vscc(df_0010, G=2:15, automate = "mclust", initial = NULL, train = NULL, forcereduction = TRUE)
mod0010$bestmodel$parameters
mod0010$bestmodel$bic
mod0010$bestmodel$classification
plot(mod0010$bestmodel)

modallwyear <- vscc(df_allwyear, G=2:15, automate = "mclust", initial = NULL, train = NULL, forcereduction = FALSE)
modallwyear$bestmodel$parameters
modallwyear$bestmodel$bic
modallwyear$bestmodel$classification
plot(modallwyear$bestmodel)

modallnoyear <- vscc(df_allnoyear, G=2:15, automate = "mclust", initial = NULL, train = NULL, forcereduction = TRUE)
modallnoyear$bestmodel$parameters
modallnoyear$bestmodel$bic
modallnoyear$bestmodel$classification
plot(modallnoyear$bestmodel)

#####



modvscc <- vscc(df_mclust, G=2:15, automate = "mclust", forcereduction = TRUE)
modvscc$bestmodel$parameters
modvscc <- vscc(df_mclust, G=2:15, automate = "mclust", initial = NULL, train = NULL, forcereduction = TRUE)

plot(modvscc, what = "classification")

selecsub <- subset(df_mclust, select=c(propownocc, propcondo, shrblk8, propfam, ratioownrnt,yadult,povrat8,avgvalhs, mdgrent8, percapinc))
#the select sub is all the variables chosen by modvscc, but i reintroduced the three gentrification variables
playing <- Mclust(selecsub, G=2:15, forcereduction = TRUE)
#playing <- Mclust(selecsub)

plot(modvscc$bestmodel) #pick classification
#VVV, 3
modvscc$initialrun #Clustering results on full data set 
modvscc$bestmodel$parameters #Clustering results on reduced data set


#look at mclustVariance, type ? into help -- $sigma vs $shape ???



#standardize after 8090, 1990-2000
#df_og <- as.data.frame(scale(df_og))

#each df_ will have its own vars + gent variables
df_dem <- subset(df_og, select=c(trctpop8,shrwht8,shrblk8,shrapi, shrhsp8, shroth8, shrami, propfam, racialdiv, propchild, propold, propyprof))
df_dem1 <- subset(df_og, select=c(trctpop8,shrwht8,shrblk8,shrapi, shrhsp8, shroth8, shrami, propfam, racialdiv, propchild, propold, propyprof, avgvalhs, mdgrent8, percapinc))

#df_mark<- subset(df_og, select=c())
#df_vul <- subset(df_og, select=c())

df_dem <- na.omit(df_dem)
df_dem1 <- na.omit(df_dem1)

modvscc <- vscc(df_dem, G=2:9, automate = "mclust", forcereduction = TRUE)
modvscc1 <- vscc(df_dem1, G=2:9, automate = "mclust", forcereduction = TRUE)

modvscc$bestmodel$parameters
modvscc1$bestmodel$parameters
modvscc$bestmodel$bic
modvscc1$bestmodel$bic
plot(modvscc$bestmodel) #pick classification
#VVV, 3
modvscc$initialrun$classification #Clustering results on full data set 
modvscc$bestmodel$classification #Clustering results on reduced data set
head(modvscc$topselected)



require("mclust")
data(banknote) #Load data
head(banknote[,-1]) #Show preview of full data set
bankrun <- vscc(banknote[,-1])
head(bankrun$topselected) #Show preview of selected variables
table(banknote[,1], bankrun$initialrun$classification) #Clustering results on full data set 
table(banknote[,1], bankrun$bestmodel$classification) #Clustering results on reduced data set
