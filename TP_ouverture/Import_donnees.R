library(purrr)

fichiers = data.frame(
  fichier=c(
  "abstentions.csv",
  "dep_francemetro_2021.gpkg"
),
  type=rep("TP_ouverture",2),
  remote = c("Data","Fonds"))

walk(
  unique(fichiers$type),
  \(t) if(!dir.exists(t)) dir.create(paste0(t, "/"), recursive = TRUE)
)

upload_fichier <- function(fichier, type, remote){
  
  base_url <- "https://minio.lab.sspcloud.fr/daudenaert"
  
  tryCatch(
    {
      download.file(url = paste0(base_url, "/", remote, "/", fichier),
                    destfile = paste0(type, "/", fichier))
    },
    error = function(e){print(paste0("pb de téléchargement pour le fichier ", fichier))}
  )
}

pwalk(fichiers, upload_fichier)



