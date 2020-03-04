eLTER Site Figure
======================

## Description 
eLTER sites managers often want to create figure of the site boundaries.

These R functions allow to create this based on the geographic boundaries entered in DEIMS-SDR as a polygon.

The figure is created with Open Street Map (OSM) base map, site boundaries, and title of the site, a resolution of 400px and an PNG extension suitable for both website and publication.

For LTER-Italy sites the function 
```R 
fProduceMapOfSite
``` 
is also accompanied by a evaluation of the country and the figure presents a inset map with relative position of the site in the country:

![Image of LTER_EU_IT_045 Lake Maggiore](https://zenodo.org/api/iiif/v2/0a9048b1-634b-42a4-b75e-9b16ad85d87f:e3ebd75f-080a-4a36-a2fc-9cf4784a7e31:LTER_EU_IT_045.png/full/750,/0/default.PNG)

For other eLTER sites the function 
```R
fProduceMapOfSiteFromDEIMS
``` 
is without country inset map:
...

## Usage
download the code and use in R

## Meta
* Please [provide a new manufacturer information by issues](https://github.com/oggioniale/eLTERSiteFigure/issues), or email oggionia.a(at)irea.cnr.it
* License: The collection is being developed by Alessandro Oggioni ([IREA-CNR](http://www.irea.cnr.it)) 
![alt text](https://orcid.org/sites/default/files/images/orcid_16x16(1).gif) [https://orcid.org/0000-0002-7997-219X](https://orcid.org/0000-0002-7997-219X)), and it is released under the [GNU General Public License version 3](https://www.gnu.org/licenses/gpl-3.0.html) (GPL‑3).
* Get citation information for eLTERSiteFigure
``` bibtex
```
