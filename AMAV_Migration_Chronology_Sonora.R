# Get the state boundary for Sonora, Mexico
region_boundary <- ne_states(iso_a2 = "MX", returnclass = "sf") |>
  filter(name == "Sonora")

# download data if they haven't already been downloaded
# only weekly 3km relative abundance, median and confidence limits
ebirdst_download_status("ameavo", 
                        pattern = "abundance_(median|upper|lower)_3km")

# load the median weekly relative abundance and lower/upper confidence limits
abd_median <- load_raster("ameavo", product = "abundance", metric = "median")
abd_lower <- load_raster("ameavo", product = "abundance", metric = "lower")
abd_upper <- load_raster("ameavo", product = "abundance", metric = "upper")

# project region boundary to match raster data
region_boundary_proj <- st_transform(region_boundary, st_crs(abd_median))

# extract values within region and calculate the mean
abd_median_region <- extract(abd_median, region_boundary_proj,
                             fun = "mean", na.rm = TRUE, ID = FALSE)
abd_lower_region <- extract(abd_lower, region_boundary_proj,
                            fun = "mean", na.rm = TRUE, ID = FALSE)
abd_upper_region <- extract(abd_upper, region_boundary_proj,
                            fun = "mean", na.rm = TRUE, ID = FALSE)

# transform to data frame format with rows corresponding to weeks
chronology_SO <- data.frame(week = as.Date(names(abd_median)),
                            median = as.numeric(abd_median_region),
                            lower = as.numeric(abd_lower_region),
                            upper = as.numeric(abd_upper_region))


#Make a graph 
AMAV_SO <- ggplot(chronology_SO) +
  aes(x = week, y = median) +
  geom_ribbon(aes(ymin = lower, ymax = upper), fill = "green", alpha = 0.4) +
  geom_line(color = "purple") +
  scale_x_date(date_labels = "%b", date_breaks = "1 month") +
  theme_classic() +
  labs(x = "Week",
       y = "Mean relative abundance in Sonora",
       title = "Migration chronology for American Avocet in Sonora")

AMAV_SO  

WA_SO_AV <- AMAV_WA + AMAV_SO 

ggsave("Avocet_chron_WA_SO.png", plot = WA_SO_AV, width = 10, height = 6, dpi = 300)