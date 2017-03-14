

## --- Libraries
library(dplyr)
# devtools::install_github("jennybc/googlesheets")
library(googlesheets)


## --- Retrieve data from shared Google Sheet
my_sheets <- gs_ls() # (expect a prompt to authenticate with Google interactively HERE)
my_sheets %>% glimpse()
gs_ls("rome_wifi_places") # search for a sheet by title
wifibar <- gs_title("rome_wifi_places") # 'register' (copy in my workspace) a sheet by title
wifibar <- wifibar %>% gs_gs() # re-register it if worried that sheet went out of date

gs_ws_ls(wifibar)
Points <- wifibar %>%
  gs_read(ws = "List", range = "A12:L28", col_names = TRUE) # check the range!
str(Points)

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


# Removing some special characters
levels(Points$name)[1] <- 'Baylon Cafe'
levels(Points$name)[3] <- 'Caffe Letterario'
levels(Points$name)[8] <- 'Gastro'
levels(Points$name)[14] <- 'Violetta'

# save data
# save.image(file = "C:/Users/pc/Documents/slowdata/post/starbucks_style_cafes_rome/git/data/cafes.RData")
