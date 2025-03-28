

fichiers = c(
    "TP_note/resultats-par-circonscriptions-france-entiere.xlsx",
    "TP_note/circonscriptions_2022.gpkg",
    "TP_note/commune_francemetro_2021.gpkg"
  )
remote = "TP_note"
if(!dir.exists(remote)) dir.create(paste0(remote, "/"))


upload_fichier <- function(fichier, remote){
  
  base_url <- "https://minio.lab.sspcloud.fr/daudenaert"
  
  tryCatch(
    {
      download.file(url = paste0(base_url, "/", fichier),
                    destfile = paste0(fichier))
    },
    error = function(e){print(paste0("pb de téléchargement pour le fichier ", fichier))}
  )
}

sapply(fichiers, upload_fichier)



              