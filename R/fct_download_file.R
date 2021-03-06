#' Downloads files from the internet
#'
#' This function will make k attempts of download and use different download options according to operating system.
#'
#' @param dl_link Link to file
#' @param dest_file Local file destination
#' @param max_dl_tries Maximum number of attempts
#' @param be_quiet Be quiet?
#'
#' @return Status (TRUE = OK)
#' @export
#' @examples
#'
#' my_url <- paste0('http://www.rad.cvm.gov.br/enetconsulta/',
#'                   'frmDownloadDocumento.aspx?CodigoInstituicao=2',
#'                   '&NumeroSequencialDocumento=46133')
#'
#' \dontrun{ # keep CHECK fast
#' dl_status <- my_download_file(my_url, 'tempfile.zip', 10)
#' }
my_download_file <- function(dl_link, dest_file, max_dl_tries = 10, be_quiet = TRUE) {

  Sys.sleep(0.5)

  if (file.exists(dest_file)) {
    message('\tFile already exists', appendLF = TRUE)
    return(TRUE)
  }

  for (i_try in seq(max_dl_tries)) {

    try({
      # old code. See issue 11: https://github.com/msperlin/GetDFPData/issues/11
      # utils::download.file(url = dl.link,
      #                      destfile = dest.file,
      #                      quiet = T,
      #                      mode = 'wb')

      # fix for issue 13: https://github.com/msperlin/GetDFPData/issues/13
      my.OS <- tolower(Sys.info()["sysname"])
      if (my.OS == 'windows') {
        utils::download.file(url = dl_link,
                             destfile = dest_file,
                             #method = 'wget',
                             #extra = '--no-check-certificate',
                             quiet = TRUE,
                             mode = 'wb')
      } else {
        # new code (only works in linux)
        dl_link <- stringr::str_replace(dl_link, stringr::fixed('https'), 'http' )
        utils::download.file(url = dl_link,
                             destfile = dest_file,
                             method = 'wget',
                             extra = '--no-check-certificate',
                             quiet = TRUE,
                             mode = 'wb')
      }



    })

    if (file.size(dest_file) < 10  ){
      message(paste0('\t\tError in downloading. Attempt ',i_try,'/', max_dl_tries),
              appendLF = FALSE)
      Sys.sleep(1)
    } else {
      message('\tSuccess', appendLF = TRUE)
      return(TRUE)
    }

  }

  return(FALSE)


}
