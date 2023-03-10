#### Configuraciones Iniciales ####

# Limpiar memoria
rm(list = ls())
library(tidyverse)
library(sf)
library(ggrepel)
library(RColorBrewer)

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


#### Carguemos la informacion social ####

# Educacion y Pobreza

# Tasa de Pobreza 2016
povrate2k16 <- read.csv(paste0(wd$datasets, "povrate2016.csv"))

# Años de eduacion promedio 2016
educ2k16 <- read.csv(paste0(wd$datasets, "educ2016.csv"))

# Juntemos nuestra bd
peru_datos <- peru_sf %>%
  left_join(povrate2k16) %>%
  left_join(educ2k16)

#### Grafico 1: Tasa de pobreza dpto 2016 ####
ggplot(data=peru_datos) + 
  geom_sf(aes(fill = poor)) + theme_void() +
  scale_fill_distiller(palette = "Spectral") +  
  labs(title = "Poblacion pobre por dpto 2016",
       caption = "Fuente de datos: ENAHO 2016",
       x = "Longitud",
       y = "Latitud",
       fill = "Tasa de Pobreza") + 
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBDEP), size = 2)
ggsave(filename = paste0(wd$outputs, "MapaPobrezaDpto2016.png"),
       width = 8.5, height = 11)

#### Grafico 2: Año de estudio promedio dpto 2016 ####
ggplot(data=peru_datos) + 
  geom_sf(aes(fill = educ)) + theme_void() +
  scale_fill_distiller(palette = "Spectral") + 
  labs(title = "Años de educacion promedio \npor dpto 2016",
       caption = "Fuente de datos: ENAHO 2016",
       x = "Longitud",
       y = "Latitud",
       fill = "Años de Educacion") + 
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBDEP), size = 2,
                  max.overlaps = 100)
ggsave(filename = paste0(wd$outputs, "MapaEducDpto2016.png"),
       width = 8.5, height = 11)


#### Grafico 3: Relacion Pobreza - Educacion ####

ggplot(data = peru_datos) +
  geom_sf(mapping = aes (fill = poor)) +
  geom_point(aes(x = coords_x, y = coords_y, size = educ), color = "darkseagreen") +
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBDEP), size = 2,
                  max.overlaps = 100) +
  labs(title = "Pobreza y Educacion por dpto 2016",
       caption = "Fuente de datos: ENAHO 2016",
       x = "Longitud",
       y = "Latitud",
       fill = "Tasa de pobreza",
       size = "Años de Educacion")
ggsave(filename = paste0(wd$outputs, "PobrezaEducacion2k16.png"),
       width = 8.5, height = 11)


#### Grafico 3.1: Relacion Pobreza - Educacion ####
#Departamentos con indice de pobreza mayor a 0.3
ggplot(data = peru_datos) +
  geom_sf(mapping = aes (fill = poor)) +
  geom_point(aes(x = coords_x, y = coords_y, size = educ), color = "darkseagreen") +
  geom_text_repel(data = peru_datos %>% filter(poor > 0.3),
                  mapping = aes(coords_x, coords_y, label = NOMBDEP), size = 2,
                  max.overlaps = 100) +
  labs(title = "Pobreza y Educacion por dpto 2016",
       caption = "Fuente de datos: ENAHO 2016",
       x = "Longitud",
       y = "Latitud",
       fill = "Tasa de pobreza",
       size = "Años de Educacion")
ggsave(filename = paste0(wd$outputs, "PobrezaEducacion2k16_v2.png"),
       width = 8.5, height = 11)

