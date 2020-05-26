eLTER_siteFigure function
======================

eLTER sites managers often want to create figure of the site boundaries.

These R functions allow to create this based on the geographic boundaries entered in DEIMS-SDR as a polygon.

The figure is created with a base map Open Street Map (OSM) (© [OpenStreetMap](https://www.openstreetmap.org/copyright) contributors), site boundaries, and title of the site, a resolution of 400px and an PNG extension suitable for both website and publication.


## Prerequisites:
In this case some packages must by installed:

### jsonlite
```R
install.packages('jsonlite')
```

More information in [jsonlite wiebsite](https://jeroen.cran.dev/jsonlite/index.html)

Ooms J (2014). “The jsonlite Package: A Practical and Consistent Mapping Between JSON Data and R Objects.” arXiv:1403.2805 [stat.CO]. [arXiv:1403.2805](https://arxiv.org/abs/1403.2805)

### sf
```R
install.packages("sf")
```

More information in [sf wiebsite](https://r-spatial.github.io/sf/)

Pebesma, E., 2018. Simple Features for R: Standardized Support for Spatial Vector Data. The R Journal 10 (1), 439-446, [DOI:10.32614/RJ-2018-009](https://doi.org/10.32614/RJ-2018-009)

### rosm
```R
install.packages("rosm")
```

More information in [rosm wiebsite](https://github.com/paleolimbot/rosm)

### raster
```R
library(devtools)
install_github("rspatial/raster")
```

More information in [raster wiebsite](https://github.com/rspatial/raster)

### tmap
```R
install.packages("tmap")
```

More information in [sf wiebsite](https://r-spatial.github.io/sf/)

Tennekes, M., 2018, tmap: Thematic Maps in R, Journal of Statistical Software, 84(6), 1-39, [DOI:10.18637/jss.v084.i06](http://dx.doi.org/10.18637/jss.v084.i06)


## Using:
For all eLTER sites the function 
```R
sitesNetwork <- getNetworkSites(networkID = 'https://deims.org/api/sites?network=7fef6b73-e5cb-4cd2-b438-ed32eb1504b3')
sitesNetwork <- (sitesNetwork[!grepl('^IT', sitesNetwork$title),])
fProduceMapOfSiteFromDEIMS(
  deimsid = 'https://deims.org/1c9f9148-e8dc-4b67-ac13-ce387c5a6a2f',
  countryCode = 'ITA',
  listOfSites = sitesNetwork,
  gridNx = 0.7,
  gridNy = 0.35,
  width = 0.25,
  height = 0.25,
  siteName = 'Lago Maggiore',
  bboxXMax = 0,
  bboxXMin = 0,
  bboxYMin = 0,
  bboxYMax = 0
)
``` 

is accompanied by a evaluation of the country and the figure presents a inset map with relative position of the site in the country:

[Image of LTER_EU_IT_045 Lake Maggiore](https://zenodo.org/record/3696893/files/LTER_EU_IT_045.png)


## Meta
* Please [provide a new issues](https://github.com/oggioniale/eLTER-SiteFigure/issues), or email oggionia.a(at)irea.cnr.it
* License: The collection is being developed by Alessandro Oggioni ([IREA-CNR](http://www.irea.cnr.it)) 
![alt text](https://orcid.org/sites/default/files/images/orcid_16x16(1).gif) [https://orcid.org/0000-0002-7997-219X](https://orcid.org/0000-0002-7997-219X)), and it is released under the [GNU General Public License version 3](https://www.gnu.org/licenses/gpl-3.0.html) (GPL‑3).
* Get citation information for eLTER-SiteFigure
``` bibtex
```
