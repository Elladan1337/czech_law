library(tidyverse)
library(tmap)
library(sf)

import <- read.csv("~/Desktop/res_data.csv")

legal <- filter(import, NACE == "69100", FORMA == 105)
#Selecting natural persons providing legal services

attorneys <- legal %>%
  filter(grepl("advokát", FIRMA) == TRUE)

#Selecting only those who use attorney as part of their legal name
#This includes "advokát", "advokátka" and "advokátní kancelář".

okres <- st_read("~/Desktop/SPH_OKRES.shx")
#https://geoportal.cuzk.cz/

attorney_okres <- attorneys %>%
  group_by(OKRESLAU) %>%
  summarize(n())

colnames(attorney_okres) <- c("KOD_LAU1", "Advokáti")


okres_attorneys <- left_join(okres, attorney_okres, by = "KOD_LAU1")

obce_attorneys$Advokáti <- replace_na(data = obce_attorneys$Advokáti, 0)

#Adding the number of attorneys into the map, replacing NA data.

korekce_x <- vector()
korekce_x[1:77] <- 0
korekce_x[28] <- 1 #Cheb

korekce_y <- vector()
korekce_y[1:77] <- 0
korekce_y[10] <- -0.9 #Praha-východ
korekce_y[11] <- -0.75 #Praha-západ
korekce_y[28] <- -1 #Cheb
korekce_y[58] <- -1 #Brno-venkov

tm_shape(okres_attorneys) +
  tm_borders() +
  tm_fill(col = "Advokáti", style = "jenks", palette = "Blues", n = 7, legend.format = list(text.separator = "-"), legend.text.size = 10) +
  tm_text(text = "Advokáti", size = 1, xmod=korekce_x, ymod=korekce_y) +
  tm_layout(main.title = "Počet advokátů podle okresu v ČR", main.title.position = "center", fontface = "bold", fontfamily = "sans", frame = FALSE)

# Final Visualisation


