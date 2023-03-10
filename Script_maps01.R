#### Configuraciones Iniciales ####

# Limpiar memoria
rm(list = ls())
library(tidyverse)
library(sf)
library(ggrepel)

#### Datos ####

# Definamos una estructura de directorios, tanto para inputs como para outputs

wd <- list()

wd$root <- "D:/Clase4_pdeBigData/Clase4_pdeBigDataRepo1/"
wd$inputs <- paste0(wd$root, "01_inputs/")
wd$shapef <- paste0(wd$inputs, "shapefiles/")
wd$datasets <- paste0(wd$inputs, "datasets/")
wd$outputs <- paste0(wd$root, "02_outputs/")

# Carguemos la informacion espacial

peru_sf <- st_read(paste0(wd$shapef, "INEI_LIMITE_DEPARTAMENTAL.shp"))

#### Primer mapa ####

ggplot(data=peru_sf) + 
  geom_sf()

# Guardar en el directorio de outputs de este grafico
ggsave(filename = paste0(wd$outputs, "MapaBasePeru.png"),
       width = 8.5, height = 11)

# Lista de departamentos

unique(peru_sf$NOMBDEP)


#### Mapa de Junin ####

ggplot(data=peru_sf %>% filter(NOMBDEP == "JUNIN")) +
  geom_sf()
ggsave(filename = paste0(wd$outputs, "MapaJunin.png"), #guardar la imagen generada en la ruta de outputs
       width = 8, height = 8)


#### Calculo de centroides ####

peru_sf <- peru_sf %>% mutate(centroid = map(geometry, st_centroid),
                              coords = map(centroid, st_coordinates),
                              coords_x = map_dbl(coords, 1),
                              coords_y = map_dbl(coords, 2))

#### Coloquemos las etiquetas a cada dpto ####

ggplot(data=peru_sf) + 
  geom_sf(fill = "skyblue", color = "black", alpha = 0.7) + 
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBDEP), size = 2)
ggsave(filename = paste0(wd$outputs, "MapaPeruCentroide.png"),
       width = 8.5, height = 11)

