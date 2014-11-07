#' Download GEO metadata
#'
#' Function for downloading the metadata of a GEO dataset and prepare it for
#' analysis.
#' The function uses \code{getGEOSuppFiles} which downloads the data. The
#' function then unzips the data files in the GEO series.
#'
#' @param geo_nbr The GEO ascession number.
#' @param destdir The destination dir of the downloaded files.
#' @param clean Should the strictly unnessesary files be deleted?
#' @param verbose Signal the process.
#' @return A \code{data.frame} giving the clinical and metadata information
#'   for the GEO dataset.
#' @note The function will overwrite existing files in the \code{destdir}.
#' @author
#'   Anders Ellern Bilgrau,
#'   Steffen Falgreen Larsen
#' @examples
#' \dontrun{
#' downloadAndPrepareCELFiles(geo_nbr = "GSE18376",
#'                            destdir = tempdir())
#' }
#' @importFrom GEOquery getGEO
#' @importFrom Biobase pData
#' @keywords internal
#' @export
downloadAndPrepareMetadata <- function(geo_nbr,
                                       destdir = getwd(),
                                       clean = FALSE,
                                       verbose = TRUE) {
  if (verbose) cat("Preparing", geo_nbr, "metadata\n")

  # Download data if not already downloaded
  if (verbose) cat("Downloading files...\n")
  dl_dir <- file.path(destdir, geo_nbr)
  dir.create(dl_dir, showWarnings = FALSE)
  dl <- getGEO(GEO = geo_nbr, destdir = dl_dir,
               GSEMatrix = TRUE, getGPL = FALSE)

  # Extract pheno data
  pd <- pData(dl[[1]])
  class(pd) <- c(geo_nbr, class(pd))

  # Clean-up if wanted
  if (clean) {
    if (verbose) cat("Removing unnessary files...\n")
    file.remove(file.path(destdir, geo_nbr, names(dl)))
  }

  if (verbose) cat("Done.")
  return(invisible(pd))
}
