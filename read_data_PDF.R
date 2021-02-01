library(dplyr)
library(readxl)
library(DBI)
library(RMySQL)

setwd("C:/Users/simon/OneDrive/R/impfzahlen/")

source("functions.R")


impfdaten <- read_excel("Daten/20210127_Impfdaten_BAG.xlsx")
impfdaten$`Gelieferte Impfdosen` <- gsub("'","",impfdaten$`Gelieferte Impfdosen`)
impfdaten$`Gelieferte Impfdosen` <- gsub("'","",impfdaten$`Gelieferte Impfdosen`)
impfdaten$`Gelieferte Impfdosen` <- as.numeric(gsub("'","",impfdaten$`Gelieferte Impfdosen`))
impfdaten$`Bislang total verimpft` <- gsub("'","",impfdaten$`Bislang total verimpft`)
impfdaten$`Bislang total verimpft` <- gsub("'","",impfdaten$`Bislang total verimpft`)
impfdaten$`Bislang total verimpft` <- as.numeric(gsub("'","",impfdaten$`Bislang total verimpft`))

letter <- c("a","a","b","c")

for (i in 2:ncol(impfdaten)) {

ID <- paste0("20210127","_",letter[i])
datum <- "2021-01-27"
Typ <- colnames(impfdaten)[i]

#In Datenbank einlesen
mydb <- dbConnect(MySQL(), user='awp', password='rs71MR3!', dbname='covid', host='32863.hostserv.eu', encoding="utf8")

#Daten in Datenbank einlesen
sql_qry <- "INSERT IGNORE INTO impfungen(ID,datum,Typ,CH,GE,VD,VS,FR,NE,JU,BE,SO,BS,BL,AG,ZH,SH,TG,AR,AI,SG,GL,SZ,ZG,LU,NW,OW,UR,GR,TI,FL) VALUES"
sql_qry <- paste0(sql_qry, paste(sprintf("('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
                                         '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
                                         '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
                                         '%s')",
                                         ID,datum,Typ,
                                         impfdaten[1,i],impfdaten[2,i],impfdaten[3,i],impfdaten[4,i],impfdaten[5,i],
                                         impfdaten[6,i],impfdaten[7,i],impfdaten[8,i],impfdaten[9,i],impfdaten[10,i],
                                         impfdaten[11,i],impfdaten[12,i],impfdaten[13,i],impfdaten[14,i],impfdaten[15,i],
                                         impfdaten[16,i],impfdaten[17,i],impfdaten[18,i],impfdaten[19,i],impfdaten[20,i],
                                         impfdaten[21,i],impfdaten[22,i],impfdaten[23,i],impfdaten[24,i],impfdaten[25,i],
                                         impfdaten[26,i],impfdaten[27,i],impfdaten[28,i]
                                         ), collapse = ","))
dbGetQuery(mydb, "SET NAMES 'utf8'")
rs <- dbSendQuery(mydb, sql_qry)

#Datenbankverbindungen schliessen
dbDisconnectAll()

}
