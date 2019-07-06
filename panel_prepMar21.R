library(tidyverse)
library(gridExtra)
library(ggplot2)
library(zoo)
library(pastecs)

og_data <- read.csv("latent_cluster_analysis_model/Panel_Mar27.csv")
df_og <- as.data.frame(og_data)
df_og <- df_og %>% arrange(-desc(AREAKEY), -desc(YEAR))
#lowercase, remove names
colnames(df_og) <- tolower(colnames(df_og))

#creating required metrics
df_mut <- df_og %>%
  mutate(shrapi = shrapi8n/shr8d, shroth8 = shroth8n/shr8d, shrami = shrami8n/shr8d) %>% 
  mutate(famhse = favinc8d/numhhs8) %>%
  mutate(racialdiv = (1-(shrwht8^2+shrblk8^2+shrapi^2+shrhsp8^2+shroth8^2+shrami^2))/(5/6)) %>%
  mutate(yadult = (fem198a+fem248+fem298+fem348+men198a+men248+men298+men348)/trctpop8) %>%
  mutate(senior = (fem748 + men748 + fem758 + men758)/trctpop8) %>%
  mutate(vacancyrate = vachu8/tothsun8) %>%
  mutate(condo = ttunit58/tothsun8) %>%
  mutate(colgrad= educ168/educpp8) %>%
  mutate(avgvalhs = aggval8/ownocc8) %>%
  mutate(percapinc = avhhin8n/trctpop8) %>%
  mutate(highmohse = (m35pi108+m35pi208+m35pix8)/ownocc8) %>%
  mutate(highrent = (r35pi108+r35pi208+r35pix8)/rntocc8) %>%
  mutate(rntocc = ownocc8 / rntocc8)

#removing variables used to create above metrics that aren't used individually
df_mut <- subset(df_mut, select=-c(shroth8, shrami, shr8d, shrapi8n, shroth8n, shrami8n, favinc8d,numhhs8, avhhin8n))
df_mut<- subset(df_mut, select=-c(educ168, educpp8,m35pi108,m35pi208,m35pix8,r35pi108,r35pi208,r35pix8))
df_mut <- subset(df_mut, select = -c(fem198a,fem248,fem298,fem348,men198a,men248,men298,men348,fem748 , men748 , fem758 , men758))
df_mut <- subset(df_mut, select = -c(vachu8, ownocc8, rntocc8, ttunit58, aggval8))

#adjusting to 2010 USD using CPI
df_cpi <- df_mut %>% mutate(avgvalhs = case_when(year == 1980 ~ avgvalhs*218.056/82.4, 
                                               year == 1990 ~ avgvalhs*218.056/130.7,
                                               year == 2000 ~ avgvalhs*218.056/172.2,
                                               year == 2010 ~ avgvalhs)) %>%
                    mutate(avhhin8 = case_when(year == 1980 ~ avhhin8*218.056/82.4, 
                                               year == 1990 ~ avhhin8*218.056/130.7,
                                               year == 2000 ~ avhhin8*218.056/172.2,
                                               year == 2010 ~ avhhin8)) %>%
                    mutate(mdgrent8 = case_when(year == 1980 ~ as.double(mdgrent8)*218.056/82.4, 
                                               year == 1990 ~ as.double(mdgrent8)*218.056/130.7,
                                               year == 2000 ~ as.double(mdgrent8)*218.056/172.2,
                                               year == 2010 ~ as.double(mdgrent8))) %>%
                    mutate(percapinc = case_when(year == 1980 ~ percapinc*218.056/82.4, 
                                               year == 1990 ~ percapinc*218.056/130.7,
                                               year == 2000 ~ percapinc*218.056/172.2,
                                               year == 2010 ~ percapinc))

#preparing for new summary dataframe, roundin to 2 decimal places
d80 <- df_cpi %>% filter(year==1980)
res80 <- d80 %>% stat.desc(d80, basic = TRUE, desc = TRUE) %>% round(2)
d90 <- df_cpi %>% filter(year==1990)
res90 <- d90 %>% stat.desc(d90, basic = TRUE, desc = TRUE) %>% round(2)
d00 <- df_cpi %>% filter(year==2000)
res00 <- d00 %>% stat.desc(d00, basic = TRUE, desc = TRUE) %>% round(2)
d10 <- df_cpi %>% filter(year==2010)
res10 <- d10 %>% stat.desc(d10, basic = TRUE, desc = TRUE) %>% round(2)
summary_vals <- bind_rows(res80, res90, res00, res10)

#saving summary dataset
write_csv(summary_vals, path = "latent_cluster_analysis_model/summary_vals.csv")


#preparing for by decade difference database
df_diff <- df_cpi %>% mutate_all(funs(c(NA, diff(as.numeric(.))))) 
#rownames(df_diff) <- 1:nrow(df_diff)

change8090 <- df_diff[seq(2, nrow(df_diff), 4) ,]
change8090$year <- 1
change8090$geo <- unique(df_og$areakey)
#change8090 <- subset(change8090, select=-c(areakey))


change9000 <- df_diff[seq(3, nrow(df_diff), 4) ,]
change9000$year <- 2
change9000$geo <- unique(df_og$areakey)

change0010 <- df_diff[seq(4, nrow(df_diff), 4) ,]
change0010$year <- 3
change0010$geo <- unique(df_og$areakey)

df_change <- bind_rows(change8090, change9000, change0010)
write_csv(df_change, path = "latent_cluster_analysis_model/modified_panel.csv")

#preparing a summary of change by decade database
summary_change <- df_change %>% group_by(year) %>% summarise_all(funs(mean))
summary_change <- t(summary_change)

write_csv(summary_change, path = "latent_cluster_analysis_model/summary_change.csv")

