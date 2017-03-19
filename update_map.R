#===========================================
# @Project: open map Starbucks Rome
# @Name: update_map
# @url: http://slow-data.com/wifibar
# @author: jprimav
# @date: 2017/03
#===========================================


## --- Libraries
library(leaflet.extras)
library(leaflet)
library(htmlwidgets)


## --- load data
load(file = "C:/Users/pc/Documents/slowdata/post/starbucks_style_cafes_rome/git/data/cafes.RData")


## --- Prepare popups
line1 <- rep("<b>Not available</b>", nrow(Points))
for(i in 1:nrow(Points)) {
  if(!is.na(Points$name[i])) line1[i] <- ifelse(!is.na(Points$website[i]), 
                                                               paste0("<b><a href='", Points$website[i], "' target='_blank'  >", Points$name[i], "</a></b>"),
                                                               paste0("<b>", Points$name[i], "</b>"))
}

line2 <- rep("",nrow(Points))
for(i in 1:nrow(Points)) {
  if(!is.na(Points$description[i])) line2[i] <- paste0("<br/>",Points$description[i])
}

line3 <- rep("",nrow(Points))
for(i in 1:nrow(Points)) {
  if(!is.na(Points$address[i])) line3[i] <- paste0("<br/>",Points$address[i])
}

line4 <- rep("",nrow(Points))
for(i in 1:nrow(Points)) {
  if(!is.na(Points$opening_hours[i])) line4[i] <- paste0("<br/>",Points$opening_hours[i])
}

popups <- rep(NA, nrow(Points))
for(i in 1:nrow(Points)) {
  popups[i] <- paste0(line1[i], line2[i], line3[i], line4[i])
}

Points$popups <- popups



## --- Open Map
openmap <- leaflet(data = Points) %>%
  addTiles() %>%
  addProviderTiles(provider = "Esri.WorldStreetMap") %>%
  setView(lng = 12.4964, lat = 41.9028, zoom = 12) %>%
  addCircleMarkers(
    lng = ~ lon,
    lat = ~ lat,
#   col = "#FF0000", 
    fillOpacity = 1,
    radius = 7,
    weight = 2,
#   stroke = TRUE,
    group = 'cafes',
    label = ~name,
#   clusterOptions = markerClusterOptions(
#      maxClusterRadius=35, 
#      disableClusteringAtZoom=14),
    popup = ~popups) %>%
  addFullscreenControl() %>%
  addSearchMarker(
    targetGroup = 'cafes',
    options = searchMarkersOptions(zoom=16, openPopup = TRUE)) 
 #%>%
 # addControl("<P>Search a cafe<br/>by name<br/><ul><li>Yeah</li><li>Circus</li><li>Baylon</li><li>...</li></P>",
 #                                                                         position='topright') 

openmap

# saveWidget(frameableWidget(openmap), "C:/Users/pc/Documents/slowdata/post/starbucks_style_cafes_rome/git/web/openmapFrame.html")
# saveWidget(openmap, "C:/Users/pc/Documents/slowdata/post/starbucks_style_cafes_rome/git/web/openmap.html", selfcontained = FALSE)
