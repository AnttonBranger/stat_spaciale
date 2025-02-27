rm(list = ls())

library(sf)
library(dplyr)

## Question 1 
fond_carte <- st_read("fonds/commune_francemetro_2021.gpkg")
# On nous donne la géométrie type, la dimension 

## Question 2
summary(fond_carte)

## Question 3 
View(fond_carte)

## Question 4 
st_crs(fond_carte)

## Question 5 
communes_Bretagne <- fond_carte %>% 
  filter(reg == "53") %>% 
  select(code, libelle, epc, dep, surf)

## Question 6 
str(communes_Bretagne) # On a bien un fichier sf

## Question 7
plot(communes_Bretagne)

## Question 8 
plot(st_geometry(communes_Bretagne))

## Question 9 
communes_Bretagne <- communes_Bretagne %>% 
  mutate(surf2 = st_area(geom))
str(communes_Bretagne$surf2)
# Unité en m^2

## Question 10
communes_Bretagne <- communes_Bretagne %>% 
  mutate(surf2 = units::set_units(surf2, km^2))
str(communes_Bretagne$surf2)

## Question 11 
mean(abs(communes_Bretagne$surf-as.numeric(communes_Bretagne$surf2))^2)
# Les variables surf et surf2 ne sont pas égales 
# Cela peut venir du système de projection qui sont différents 

## Question 12
dept_bretagne <- communes_Bretagne %>% 
  group_by(dep) %>% 
  summarise(surf = min(surf)) %>% 
  select(dep, surf) %>% 
  ungroup()
str(dept_bretagne)

plot(st_geometry(dept_bretagne))

## Question 13
dept_bretagne2 <- communes_Bretagne %>% 
  group_by(dep) %>% 
  summarise(geom = st_union(geom))
plot(st_geometry(dept_bretagne2))

## Question 14

centroide_dept_bretagne <- st_centroid(dept_bretagne)
class(centroide_dept_bretagne$geom)

plot(st_geometry(dept_bretagne))
plot(st_geometry(centroide_dept_bretagne), add = T)

dept_lib <- tibble(
  dep = c("22", "29", "35", "56"),
  dep_lib = c("Côtes d'Armor", "Finistère", "Ille-et-Vilaine", "Morbian"))
centroide_dept_bretagne <- centroide_dept_bretagne %>% 
  left_join(
    dept_lib, 
    by = "dep")

centroid_coords <- st_coordinates(centroide_dept_bretagne)
centroid_coords %>% str()
centroid_coords <- centroid_coords %>% 
  bind_cols(
    centroide_dept_bretagne %>% 
      select(dep, dep_lib) %>% 
      st_drop_geometry() # permet de supprimer la variable du fond de geometry
  ) 
centroid_coords %>% str()

plot(st_geometry(dept_bretagne))
plot(st_geometry(centroide_dept_bretagne), pch = 16, col = "orangered", add = T)
text(
  x = centroid_coords$X,
  y = centroid_coords$Y,
  labels = centroid_coords$dep_lib, 
  pos = 3, 
  cex = 0.8,
  col = "orangered"
)

## Question 15
commune_centroide_bretagne <- st_intersects(communes_Bretagne, centroide_dept_bretagne)
typeof(commune_centroide_bretagne)
which(lengths(commune_centroide_bretagne)>0)


## Question 16
st_intersection(communes_Bretagne, centroide_dept_bretagne) # le plus interessant 
Q16_with_in <- st_within(communes_Bretagne, centroide_dept_bretagne)

# Question 17
Q17 <- st_distance(centroide_dept_bretagne,
                   communes_Bretagne %>% 
                     filter(libelle %in% c("Saint-Brieuc", "Quimper", "Rennes", "Vannes")))
Q17 <- data.frame(Q17)
rownames(Q17) <- centroide_dept_bretagne
colnames(Q17) <- c("Saint-Brieuc", "Quimper", "Rennes", "Vannes")

## Question 18

buffer <- st_buffer()