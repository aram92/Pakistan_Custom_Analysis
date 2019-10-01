
import1 <- read.csv('C:/Users/wb554990/OneDrive - WBG/Pakistan Custom Data Analysis/Imports/Import_wb_2017_18 Part-1_KC.csv')

import2 <- read.csv('C:/Users/wb554990/OneDrive - WBG/Pakistan Custom Data Analysis/Imports/Import_wb_2017_18 Part-2_KC.csv')

import3 <- read.csv('C:/Users/wb554990/OneDrive - WBG/Pakistan Custom Data Analysis/Imports/Import_wb_2017_18 Part-3_KC.csv')

imp1 <- colnames(import1)
imp2 <- colnames(import2)
imp3 <- colnames(import3)

setdiff(imp1, imp2)
setdiff(imp2, imp1)
colnames(import2)[colnames(import2)=="NTN.ID"] <- "ntnid"
colnames(import2)[colnames(import2)=="Cd.Rate"] <- "CD.Rate"
colnames(import2)[colnames(import2)=="Shipping_Line_Name"] <- "Shipping.line.name"

setdiff(imp1, imp3)
setdiff(imp3, imp1)
colnames(import3)[colnames(import3)=="GD_no_id"] <- "GD_NO_ID"
colnames(import3)[colnames(import3)=="ntn_id"] <- "ntnid"
colnames(import3)[colnames(import3)=="Agent_id"] <- "Agent.id"
colnames(import3)[colnames(import3)=="Cd.Rate"] <- "CD.Rate"
colnames(import3)[colnames(import3)=="Shipping_Line_Name"] <- "Shipping.line.name"

all_import <- rbind(import1, import2, import3)
rm(import1, import2, import3)

sum(is.na(all_import$HS_Code))
sum(is.na(all_import$Quantity_Unit_Code))

all_import$hs6 <- as.integer(all_import$HS_Code*100)

keep_vars <- c("GD_NO_ID", "GD_Date", "ntnid", "Shed_Name", "hs6")
all_import1 = all_import[keep_vars]

write.csv(all_import1, file = "C:/Users/wb554990/OneDrive - WBG/Pakistan Custom Data Analysis/Imports/hs6_check.csv")

#library(foreign)
#write.dta(all_import, "C:/Users/wb554990/OneDrive - WBG/Pakistan Custom Data Analysis/Imports/merged_import.dta")
