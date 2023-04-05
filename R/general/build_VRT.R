# Takes a folder with tifs and creates a virtual raster
# author: Hannes Horneber, 2022-05
library(stars)

DIR_INPUT = "D:/Data/DTM/swissALTI3D"
DIR_OUTPUT = DIR_INPUT
NAME_OUTPUT = paste0("swissALTI3D_2019", ".vrt")

# read all .tifs from input folder
# recursive option can be added, see doc on list.files
list_raster_tiles = list.files(path=PATH_DATA, pattern='.tif', full.names = TRUE)

# create vrt
vrt = stars::st_mosaic(list_raster_tiles, 
						 dst=file.path(PATH_DATA, "swissALTI3D_2019.vrt"), 
						 file_ext=".vrt")
