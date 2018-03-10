library(dplyr)
library(Metrics)
library(stringr)
library(readr)


traindata = read.csv("01_Data/train.csv", stringsAsFactors = FALSE)
traindata$Id <- NULL

hist(traindata$SalePrice)

hist(traindata$YearBuilt)

#Untersuche Correlations von SalePrice zu Variablen die auf den ersten Blick wichtig aussehen
#Benutze einfaches Lineares Modell
traindata_2 <- traindata[,c(13,14,17,18,19,27,28,30,31,38,39,40,41,42,46,49:54,61,62,71,78,79,80)]
linear_mod <- lm(formula = SalePrice ~., data=traindata_2)
linear_mod_test <- lm(formula =SalePrice~SaleCondition, data=traindata)
print(linear_mod)
summary(linear_mod)

#aus der Summary ist zu entnehmen, dass die Variablen GarageCars, KitchenAbvGr, KitchenQual, GrLivArea
# BsmtQual, ExterQual, YearBuilt, OverallQual, OverallCond, TotalBsmtSf Signifikant sind
#Ich nehme die Variable SaleCondition noch mit, weil ich glaube, dass sie wichtig ist
traindata_3 <- traindata_2[,c(3,4,5,6,8,10,15,19,20,22,26,27)]
linear_mod_new <- lm(formula = SalePrice~., data=traindata_3)
summary(linear_mod_new)

#Erstelle train und test samples, um linear_mod_new zu testen
shuffle <- sample(1460)   #das hier ist mehr oder weniger Problematisch, da das samplen Einfluss auf die Signifkanz der Variablen hat

train_sample <- traindata_3[shuffle[1:730],]
test_sample <- traindata_3[shuffle[731:1460],]

linear_mod_pred <- lm(formula = SalePrice~., data=train_sample)
print(linear_mod_pred)
summary(linear_mod_pred)

test_sample$SalePrice_Prediction <- predict(linear_mod_pred, test_sample)
#Wenn kein Basement vorhanden ist, wird NA predicted, diese werden für die Berechnung des mse erstmal rausgenommen
#Man kann/sollte alternativ die NA's in BsmtQual ersetzen
test_sample <- na.omit(test_sample)
mse(test_sample$SalePrice, test_sample$SalePrice_Prediction) #Die Fehler sind immer noch riesig, aber die geringsten die ich bis jetzt hatte :D


#Untersuchung der Variable SaleCondition, bzw. SaleCondition = Partial, hier ist der Fehler größer...
partial <- filter(test_sample, SaleCondition == "Partial")
mse(partial$SalePrice, partial$SalePrice_Prediction)

partial_all <- filter(traindata, SaleCondition == "Partial")
npartial_all <- filter(traindata, SaleCondition != "Partial")
mean(partial_all$SalePrice)
mean(npartial_all$SalePrice) #-> Häuser mit der SaleCondition Partial sind im Schnitt 100,000 Dollar teurer

abnorml_all <- filter(traindata, SaleCondition == "Abnorml")
nabnorml_all <- filter(traindata, SaleCondition != "Abnorml")
mean(abnorml_all$SalePrice)
mean(nabnorml_all$SalePrice) #-> Abnorml hat nicht so viel Einfluss wie Partial, nur 40,000 Dollar
