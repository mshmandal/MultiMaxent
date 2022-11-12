#' Download data from worldclim_v_2.1
#'
#' @param name name of the data; valid arguments are "tmin", "tmax","tavg",
#' "precipitation", "srad","wspeed","wvapor", "bio","elevation". Check
#' worldclim website for more information.
#' @param wd current working directory path; do not forget trailing slash
#' @param ext xmin,xmax,ymin,ymax
#'
#' @return A SpatRaster object cropped by ext
#' @export
#'
#' @examples
#'
#' # Note:
#' # Currently on WorldClim v2.1 data are supported
#' # The raster package has a useful function getData() which performs much
#' # more than current functionality here. So, do check that one.
#'
#' get_worldclim(name="elevation",wd="./",ext=c(88,90,20,25))
#'
get_worldclim <-function(name,wd,ext){
  # increase timeout time and method for download
  options(download.file.method="libcurl")
  options(timeout=600) # 10 minutes

  # worldlcim database url
  worldclim <- "https://biogeo.ucdavis.edu/data/worldclim/v2.1/base/"

  # use swtich to get the product url
  download_url <- switch (
    name,
    "tmin" = paste0(worldclim,"wc2.1_30s_tmin.zip"),
    "tmax" = paste0(worldclim,"wc2.1_30s_tmax.zip"),
    "tavg" = paste0(worldclim,"wc2.1_30s_tavg.zip"),
    "precipitation" = paste0(worldclim,"wc2.1_30s_prec.zip"),
    "srad" = paste0(worldclim,"wc2.1_30s_srad.zip"),
    "wspeed" =paste0(worldclim,"wc2.1_30s_wind.zip"),
    "wvapor" = paste0(worldclim,"wc2.1_30s_vapr.zip"),
    "bio" =  paste0(worldclim,"wc2.1_30s_bio.zip"),
    "elevation" = paste0(worldclim,"wc2.1_30s_elev.zip")

  )

  # directory management
  wd<- wd
  data_dir<- name
  # if not exit, create new directory
  dir.create(paste0(wd,"/",name))
  file_name <- paste0(wd,"/",data_dir,"/",name,".zip")

  # download the data
  download.file(download_url, destfile=file_name)
  file <- unzip(file_name,exdir = paste0(wd,"/",data_dir))
  # read the file using terra package and crop
  file<- terra::rast(file)
  file <-terra::crop(file,ext)

  return(file)
}
