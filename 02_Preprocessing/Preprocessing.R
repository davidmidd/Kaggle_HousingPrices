library(dplyr)
library(Metrics)
library(stringr)
library(readr)

#ich weiß nicht ob es besser ist SAF = TRUE zu setzen, hab ich jetzt im Internet schon häufiger gesehen...
data = read.csv("01_Data/train.csv", stringsAsFactors = FALSE)
data$Id <- NULL

#Unterteile Daten in Numerische und Kategorielle Variablen
data_chr <- data[,sapply(data, is.character)]
data_int <- data[,sapply(data, is.integer)]

colSums(is.na(data_chr))
colSums(is.na(data_int))

#Ersetze LotFrontage NA durch 0, später ändern durch mean
data[is.na(data$LotFrontage),]$LotFrontage <- 0
#Ersetze Alley NA durch "NoAlley"
data[is.na(data$Alley),]$Alley <- "NoAlley"
#Ersetze MiscFeature NA durch "NoMisc"
data[is.na(data$MiscFeature),]$MiscFeature <- "NoMisc"
#Fence
data[is.na(data$Fence),]$Fence <- "NoFence"
#Pool
data[is.na(data$PoolQC),]$PoolQC <- "NoPool"

#Ersetze Garagen Variablen, außer die numerische(was machen wir mit der?)
data[is.na(data$GarageType),]$GarageType <- "NoGarage"
data[is.na(data$GarageFinish),]$GarageFinish <- "NoGarage"
data[is.na(data$GarageQual),]$GarageQual <- "NoGarage"
data[is.na(data$GarageCond),]$GarageCond <- "NoGarage"
