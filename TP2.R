rm(list = ls())

library(sf)
library(dplyr)

# Question 1 
fond_carte <- st_read("fonds/commune_francemetro_2021.gpkg")
# On nous donne la géométrie type, la dimension 

# Question 2
summary(fond_carte)

# Question 3 
View(fond_carte)

# Question 4 
st_crs(fond_carte)

# Question 5 
communes_Bretagne <- fond_carte %>% 
  filter(reg == "53") %>% 
  select(code, libelle, epc, dep, surf)

# Question 6 
str(communes_Bretagne) # On a bien un fichier sf

# Question 7
plot(communes_Bretagne)

# Question 8 
plot(st_geometry(communes_Bretagne))

# Question 9 
communes_Bretagne <- communes_Bretagne %>% 
  mutate(surf2 = st_area(geom))
str(communes_Bretagne$surf2)
# Unité en m^2

# Question 10
communes_Bretagne <- communes_Bretagne %>% 
  mutate(surf2 = units::set_units(surf2, km^2))
str(communes_Bretagne$surf2)

# Question 11 
