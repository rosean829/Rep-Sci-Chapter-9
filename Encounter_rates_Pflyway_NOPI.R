library(tidyverse)
library(ggplot2)
library(sf)
library(raster)
library(terra)
library(patchwork)
library(tigris)
library(rnaturalearth)
library(ebirdst)
library(tanagR)


#Allows to access data in ebirst package
set_ebirdst_access_key("aj6vlciqa1gd", overwrite = TRUE)

#Create an object with shape file 
states <- tigris::states(cb = TRUE, class = "sf")

# Filter for pacific flyway
pacific_flyway <- states %>%
  filter(NAME %in% c("Arizona", "California", "Nevada", "Idaho", "Oregon", "Utah", "Washington"))



NOPI_data <- data.frame(
  NAME = c("Arizona", "California", "Idaho", "Nevada", "Oregon", "Utah", "Washington"),
  value = c(22.26903091, 27.59856963, 23.51193247, 35.93710033, 37.88742535, 29.01291321, 40.52533229)  # took values from spreadsheet, too scared to figure out filtering
)

head(NOPI_data)

# Join to spatial data
NOPI_map <- pacific_flyway %>%
  left_join(NOPI_data, by = "NAME")

#make a map using ggplot
ggplot(NOPI_map) +
  geom_sf(aes(fill = value)) +
  scale_fill_viridis_c(option = "viridis") +  
  theme_minimal() +
  labs(title = "Northern Pintail Encounter Rate, Pacific Flyway",
       fill = "Value")

#make it a little cleanr by getting rid of background grid
NOPI<-ggplot(NOPI_map) +
  geom_sf(aes(fill = value)) +
  scale_fill_viridis_c(option = "viridis") +
  labs(
    title = "Northern Pintail Encounter Rate, Pacific Flyway",
    fill = "Value"
  ) +
  theme_minimal() +
  theme(
    panel.grid.major = element_blank(),  # remove gridlines
    axis.text = element_blank(),         # remove axis text (lat/long labels)
    axis.ticks = element_blank(),        # remove axis ticks
    axis.title = element_blank()         # remove axis titles
  )
#Graph to be called later
NOPI
