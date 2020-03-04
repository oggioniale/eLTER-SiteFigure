##
# Libraries
##
library(maptools)
library(dplyr)

##
# Variables
##
wfs_LTERitaly <- "http://getit.lteritalia.it/geoserver/wfs"


#-------- connection to web services --------#
wfs <- ows4R::WFSClient$new(
  url = wfs_LTERitaly, 
  serviceVersion = "2.0.0",
  logger = "INFO"#,
  # user = "",
  # pwd = ""
)
caps <- wfs$getCapabilities()
centroids <- caps$findFeatureTypeByName("geonode:Centroid_LTER_Italy", exact = TRUE)
centroidsFeature <- centroids$getFeatures()
centroidsFeatureSP <- as(centroidsFeature, "Spatial")
names(centroidsFeatureSP)[4] <- "Type"

# Nepal centroids
centroidsFeatureSPNepal <-
  centroidsFeatureSP[which(centroidsFeatureSP$ParSite == "IT11 - Himalayan Lakes - Nepal"),]
# Antartica centroids
centroidsFeatureSPAntarctica <-
  centroidsFeatureSP[which(centroidsFeatureSP$ParSite == "IT17 - Antarctica Research Station - Antarctica"),]
centroidsFeatureSPAntarctica <- centroidsFeatureSPAntarctica
centroidsFeatureSPAntarctica$SiteName <- substring(text = centroidsFeatureSPAntarctica$SiteName, first = 0, last = 9)
# Italy centroids
centroidsFeatureSPItaly <-
  centroidsFeatureSP[which(centroidsFeatureSP$ParSite != "IT17 - Antarctica Research Station - Antarctica" & centroidsFeatureSP$ParSite != "IT11 - Himalayan Lakes - Nepal"),]
# sp::plot(centroidsFeatureSP)

tmap::tmap_mode(mode = "plot")

##
# Functions
##
fProduceMapOfSite <- function(deimsid) {
  lterCode <- centroidsFeatureSP$SiteCode[centroidsFeatureSP$DEIMS_ID == deimsid]
  suffix <- listOfSites$suffix[listOfSites$name == lterCode]
  lterItalySites <- caps$findFeatureTypeByName(paste0("geonode:", paste0(lterCode, suffix)), exact = TRUE)
  lterItalySitesFeature <- lterItalySites$getFeatures() %>% sf::st_cast(., "GEOMETRYCOLLECTION") %>%
    sf::st_collection_extract("POLYGON")
  # Selection of site centroid
  centroidsFeatureSPNepalSelected <- centroidsFeatureSPNepal[which(centroidsFeatureSPNepal$SiteCode == lterCode),]
  centroidsFeatureSPItalySelected <- centroidsFeatureSPItaly[which(centroidsFeatureSPItaly$SiteCode == lterCode),]
  color <- listOfSites$color[listOfSites$name == lterCode] #"#03a3b8" #freshwater #"#43903f" #transitional #"#055ca8" #marine #"#b07c03" #terrestrial
  colorBorder <- listOfSites$colorBorder[listOfSites$name == lterCode] #"#04d0eb" #freshwater "#5ecc58" #transitional #"#057ae1" #marine #"#e8a303" #terrestrial
  country <- raster::getData(country = listOfSites$country[listOfSites$name == lterCode], level = 0)
  mapOfItalyCentroids <- tmap::tm_shape(country) +
    tmap::tm_borders("grey75", lwd = 1) +
    tmap::tm_shape(centroidsFeatureSPItaly) +
    tmap::tm_dots(col = NA, size = 0.01, shape = 16, title = NA, legend.show = FALSE) +
    tmap::tm_shape(centroidsFeatureSPItalySelected) +
    tmap::tm_dots(col = "Type", size = 0.1, shape = 16, palette = color, title = NA, legend.show = FALSE)
  # mapOfItalyCentroids
  lterItalySitesFeature <- sf::as_Spatial(lterItalySitesFeature, )
  bboxXMin <- listOfSites$bboxXMin[listOfSites$name == lterCode]
  bboxXMax <- listOfSites$bboxXMax[listOfSites$name == lterCode]
  bboxYMin <- listOfSites$bboxYMin[listOfSites$name == lterCode]
  bboxYMax <- listOfSites$bboxYMax[listOfSites$name == lterCode]
  bboxlterItalySitesFeature <- sp::bbox(lterItalySitesFeature)
  bboxlterItalySitesFeature[1] <- sp::bbox(lterItalySitesFeature)[1] + bboxXMin
  bboxlterItalySitesFeature[3] <- sp::bbox(lterItalySitesFeature)[3] + bboxXMax
  bboxlterItalySitesFeature[2] <- sp::bbox(lterItalySitesFeature)[2] + bboxYMin
  bboxlterItalySitesFeature[4] <- sp::bbox(lterItalySitesFeature)[4] + bboxYMax
  baseMap <- rosm::osm.raster(bboxlterItalySitesFeature)
  # plot(baseMap)
  newBaseMap <- raster::reclassify(baseMap, cbind(NA, 255))
  # plot(newBaseMap)
  mapOfSite <-
    tmap::tm_shape(newBaseMap, ) + tmap::tm_rgb() +
    tmap::tm_shape(lterItalySitesFeature) +
    tmap::tm_borders(col = colorBorder) +
    tmap::tm_fill(col = color) +
    # tmap::tm_text(text = "long_name", col = "black", fontfamily = "sans", size = 1.5) +
    tmap::tm_compass(type = "8star", position = c("right", "bottom")) +
    tmap::tm_scale_bar(position = c("right", "bottom")) +
    tmap::tm_layout(main.title = paste0("Sito: ", lterItalySitesFeature$long_name),
                    main.title.position = "center",
                    main.title.color = "black",
                    main.title.fontfamily = "sans",
                    main.title.size = 1.5,
                    legend.bg.color = "white",
                    legend.position = c(0.75, 0.9),
                    legend.width = -0.24
    ) +
    # tmap::tm_credits(paste0("DEIMS ID: ", centroidsFeatureSPItalySelected$DEIMS_ID),
    #                  size = 0.7,
    #                  fontfamily = "sans",
    #                  position = c("left", "top")) +
    tmap::tm_credits("© OpenStreetMap contributors - \nhttps://www.openstreetmap.org/",
                     size = 0.6,
                     fontfamily = "sans",
                     position = c("left", "bottom")) +
    tmap::tm_basemap(leaflet::providers$Stamen.Watercolor)
  # mapOfSite
  gridNx <- listOfSites$gridNx[listOfSites$name == lterCode]
  gridNy <- listOfSites$gridNy[listOfSites$name == lterCode]
  # print(mapOfItalyCentroids, vp = grid::viewport(gridNx, gridNy, width = 0.25, height = 0.25))
  tmap::tmap_save(
    tm = mapOfSite,
    filename = paste0("images/", paste0(lterCode, suffix), ".png"),
    dpi = 400,
    insets_tm = mapOfItalyCentroids,
    insets_vp = grid::viewport(gridNx, gridNy, width = 0.25, height = 0.25)
  )
}

fProduceMapOfSiteFromDEIMS <- function(deimsid) {
  geoBonBiome <- jsonlite::fromJSON(paste0("https://deims.org/", "api/site/", substring(deimsid, 19)))$attributes$environmentalCharacteristics$geoBonBiome
  color <- biomeColor$fill[biomeColor$geoBonBiome == geoBonBiome]
  colorBorder <- biomeColor$border[biomeColor$geoBonBiome == geoBonBiome]
  geoBoundaries <- jsonlite::fromJSON(paste0("https://deims.org/", "api/site/", substring(deimsid, 19)))$attributes$geographic$boundaries
  
  if (is.null(geoBoundaries)) {
    lterCoords <- jsonlite::fromJSON(paste0("https://deims.org/", "api/site/", substring(deimsid, 19)))$attributes$geographic$coordinates
    lterSitesFeaturePointDEIMS <- sf::as_Spatial(sf::st_as_sfc(lterCoords),)
    baseMap <- rosm::osm.raster(lterSitesFeaturePointDEIMS, zoomin = -5)
    # plot(baseMap)
    newBaseMap <- raster::reclassify(baseMap, cbind(NA, 255))
    # plot(newBaseMap)
    mapOfSite <-
      tmap::tm_shape(newBaseMap, ) + tmap::tm_rgb() +
      tmap::tm_shape(lterSitesFeaturePointDEIMS) +
      tmap::tm_dots(size = 1, shape = 16, palette = color, title = NA, legend.show = TRUE) +
      # tmap::tm_text(text = "long_name", col = "black", fontfamily = "sans", size = 1.5) +
      tmap::tm_compass(type = "8star", position = c("right", "bottom")) +
      tmap::tm_scale_bar(position = c("right", "bottom")) +
      tmap::tm_layout(main.title = paste0(jsonlite::fromJSON(paste0("https://deims.org/", "api/site/", substring(deimsid, 19)))$title),
                      main.title.position = "center",
                      main.title.color = "black",
                      main.title.fontfamily = "sans",
                      main.title.size = 1,
                      legend.bg.color = "white",
                      legend.position = c(0.75, 0.9),
                      legend.width = -0.24
      ) +
      # tmap::tm_credits(paste0("DEIMS ID: ", centroidsFeatureSPItalySelected$DEIMS_ID),
      #                  size = 0.7,
      #                  fontfamily = "sans",
      #                  position = c("left", "top")) +
      tmap::tm_credits("© OpenStreetMap contributors - \nhttps://www.openstreetmap.org/",
                       size = 0.6,
                       fontfamily = "sans",
                       position = c("left", "bottom")) +
      tmap::tm_basemap(leaflet::providers$Stamen.Watercolor)
  } else {
    lterSitesFeatureDEIMS <- sf::as_Spatial(sf::st_as_sfc(geoBoundaries),)
    baseMap <- rosm::osm.raster(lterSitesFeatureDEIMS)
    # plot(baseMap)
    newBaseMap <- raster::reclassify(baseMap, cbind(NA, 255))
    # plot(newBaseMap)
    mapOfSite <-
      tmap::tm_shape(newBaseMap, ) + tmap::tm_rgb() +
      tmap::tm_shape(lterSitesFeatureDEIMS) +
      tmap::tm_borders(col = colorBorder) +
      tmap::tm_fill(col = color) +
      # tmap::tm_text(text = "long_name", col = "black", fontfamily = "sans", size = 1.5) +
      tmap::tm_compass(type = "8star", position = c("right", "bottom")) +
      tmap::tm_scale_bar(position = c("right", "bottom")) +
      tmap::tm_layout(main.title = paste0(jsonlite::fromJSON(paste0("https://deims.org/", "api/site/", substring(deimsid, 19)))$title),
                      main.title.position = "center",
                      main.title.color = "black",
                      main.title.fontfamily = "sans",
                      main.title.size = 1,
                      legend.bg.color = "white",
                      legend.position = c(0.75, 0.9),
                      legend.width = -0.24
      ) +
      # tmap::tm_credits(paste0("DEIMS ID: ", centroidsFeatureSPItalySelected$DEIMS_ID),
      #                  size = 0.7,
      #                  fontfamily = "sans",
      #                  position = c("left", "top")) +
      tmap::tm_credits("© OpenStreetMap contributors - \nhttps://www.openstreetmap.org/",
                       size = 0.6,
                       fontfamily = "sans",
                       position = c("left", "bottom")) +
      tmap::tm_basemap(leaflet::providers$Stamen.Watercolor)
  }
  
  # mapOfSite
  tmap::tmap_save(
    tm = mapOfSite,
    filename = paste0("images/", substring(deimsid, 19), ".png"),
    dpi = 400
  )
}

###
# Execute this command line in order to produce the image of your site
# Insert below the DEIMS-ID e.g. https://deims.org/8bd7d2f8-421a-48bd-b212-04bc1e9f31d5
###
fProduceMapOfSite("https://deims.org/769556a6-0ee6-46a9-acbb-a1f2d51c07e8")

###
# For other sites within DEIMS-SDR
# could be possible to create images.
# Please execute the command below
###
fProduceMapOfSiteFromDEIMS("https://deims.org/1c9f9148-e8dc-4b67-ac13-ce387c5a6a2f")
