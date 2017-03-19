

## --- Libraries
library(dplyr)
# devtools::install_github("jennybc/googlesheets")
library(googlesheets)
library(stringi)
library(geojsonio)
library(rgdal)

## --- Retrieve data from shared Google Sheet
my_sheets <- gs_ls() # (expect a prompt to authenticate with Google interactively HERE)
my_sheets %>% glimpse()
gs_ls("rome_wifi_places") # search for a sheet by title
wifibar <- gs_title("rome_wifi_places") # 'register' (copy in my workspace) a sheet by title
wifibar <- wifibar %>% gs_gs() # re-register it if worried that sheet went out of date

gs_ws_ls(wifibar)
Points <- wifibar %>%
  gs_read(ws = "List", range = "A12:L31", col_names = TRUE) # check the range!
str(Points)

# Normalizing text to Latin-ASCII
Points$name <- stri_trans_general(Points$name, "Latin-ASCII")
Points$address <- stri_trans_general(Points$address, "Latin-ASCII")
Points$description <- stri_trans_general(Points$description, "Latin-ASCII")

# converting from string to factor
Points$name <- as.factor(Points$name)
Points$address <- as.factor(Points$address)
Points$zu <- as.factor(Points$zu)
Points$description <- as.factor(Points$description)
Points$opening_hours <- as.factor(Points$opening_hours)
Points$website <- as.factor(Points$website)
Points$contributor <- as.factor(Points$contributor)
Points$contact <- as.factor(Points$contact)
str(Points)


# save data
save.image(file = "C:/Users/pc/Documents/slowdata/post/starbucks_style_cafes_rome/git/data/cafes.RData")
pts_json <- geojson_json(Points, lat = 'lat', lon = 'lon')
geojson_write(input = pts_json, file = "C:/Users/pc/Documents/slowdata/post/starbucks_style_cafes_rome/git/app/data/wificafes.geojson")

# Read SHAPEFILE with borders of 'zone urbanistiche' (neighborhoods)
zu <- readOGR(dsn = "C:/Users/pc/Documents/slowdata/post/starbucks_style_cafes_rome/git/shapes", layer = "ZU_COD")
crslonglat = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0")
zu <- spTransform(zu, CRS=crslonglat)
zu_json <- geojson_json(zu)
# geojson_write(input = zu_json, file = "C:/Users/pc/Documents/slowdata/post/starbucks_style_cafes_rome/my_bootleaf-master/data/zu.geojson")
