# creates a map view centered at the BFH-HAFL in Switzerland
# adding pixelmaps from geo.admin.ch

library(sp)
library(mapview)
library(leaflet)

wms_ch <- "https://wms.geo.admin.ch"

hafl<-data.frame(name="home",x=46.99183,y=7.46771)
hafl<-SpatialPointsDataFrame(coords=hafl[,c("y","x")],data=data.frame(hafl[,"name"]),proj4string = CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs "))

m <- mapview(hafl,label="name")
m@map = m@map %>% addWMSTiles(
  wms_ch,
  layers= "ch.swisstopo.pixelkarte-farbe-pk25.noscale",
  options = WMSTileOptions(format = "image/png", transparent = TRUE)
)

m

