#' Get species occurrence data
#'
#' @param species character name of the species
#' @param ext a vector  xmin,xmax,ymin,ymax
#' @param limit number of points to return
#'
#' @return returns a dataframe
#' @export
#'
#' @examples
#' get_species("Chromolaena odorata",ext=c(87,94,20,27),limit=10)
#'
get_species <- function(species,ext,limit=500){
  # Get occurrence points using spocc package
  points_df = spocc::occ(
    species,
    limit=limit,
    has_coords = T,
    geometry=c(ext[1],ext[3],ext[2],ext[4])
    )
  # convert it to dataframe
  points_df = spocc::occ2df(points_df)

  return(points_df)
}


#' Combine multiple species occ data
#'
#' @param species A list of species name
#' @param ... Arguments from get_species function
#'
#' @return A list of data frames
#' @export
#'
#' @examples
#' # vector of species name
#' names <- c("Chromolaena odorata","Parthenium hysterophorus")
#' # extent bounds
#' ext=c(87,94,20,27)
#' multi_species(species=names,ext,limit=10)
#'
multi_species<- function(species, ...){
  # create an empty list
  species_list <- vector("list",length = length(species))

  # loop over all the species list names
  for (i in 1:length(species)) {
    # download one by one
    sp_df <- get_species(species = species[i],...)
    # append to the empty list
    species_list[[i]] <- sp_df
  }
  # rename the list items
  names(species_list) <- species

  return(species_list)

}



