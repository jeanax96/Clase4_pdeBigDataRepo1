#### Configuraciones Iniciales ####

# Limpiar memoria
rm(list = ls())
library(tidyverse)
library(sf)


#### Datos ####

# Definamos una estructura de directorios, tanto para inputs como para outputs

wd <- list()

wd$root <- "D:/Clase4_pdeBigData/Clase4_pdeBigDataRepo1/"
wd$inputs <- paste0(wd$root, "01_inputs/")
wd$shapef <- paste0(wd$inputs, "shapefiles/")
wd$datasets <- paste0(wd$inputs, "datasets/")
wd$outputs <- paste0(wd$root, "02_outputs/")

