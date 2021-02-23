library(dplyr)
library(DBI)
library(RMySQL)
library(rvest)
library(git2r)
library(tidyr)
library(readr)
library(stringr)
library(DatawRappr)
library(RCurl)

setwd("C:/Automatisierungen/impfzahlen/")

source("functions.R")
source("load_data.R")

current_date <- Sys.Date()
url <- "https://www.covid19.admin.ch/de/overview"
readin_check <- FALSE

repeat{
  
Sys.sleep(2)

hour <- format(Sys.time(),"%H")
hour <- as.numeric(hour)

if (hour > 22) {
  
  library(blatr)
  
  blat(f = "robot-notification@awp.ch",
       to = "robot-notification@awp.ch, redakt@awp.ch",
       s = "Keine Impf-Zahlen gefunden",
       body= "Es wurden heute keine Zahlen auf der BAG-Seite gefunden.\n\n
         AWP-Robot",
       server = "smtp.juergruettimann.ch",
       u = "awp-robot@juergruettimann.ch",
       pw = "SimonWolanin123")
  
  break  
}  

webpage <- retry(read_html(url),maxErrors = 5,sleep = 10)

#Datum Check ausgeliefert und verabreicht
datum_extract <- html_text(html_nodes(webpage,".bag-key-value-list__entry-key-description"))
correct_datum_1 <- which(grepl("Quelle: BAG",datum_extract))[1]
correct_datum_2 <- correct_datum_1-1
correct_datum_3 <- correct_datum_1+1

date_geliefert <- datum_extract[correct_datum_2]
date_geliefert <- gsub(",.*","",date_geliefert)
date_geliefert <- gsub(".*: ","",date_geliefert)
date_geliefert <- as.Date(date_geliefert,format="%d.%m.%Y")

date_verabreicht <- datum_extract[correct_datum_1]
date_verabreicht <- gsub(",.*","",date_verabreicht)
date_verabreicht <- gsub(".*: ","",date_verabreicht)
date_verabreicht <- as.Date(date_verabreicht,format="%d.%m.%Y")

date_vollstaendig <- datum_extract[correct_datum_3]
date_vollstaendig <- gsub(",.*","",date_vollstaendig)
date_vollstaendig <- gsub(".*: ","",date_vollstaendig)
date_vollstaendig <- as.Date(date_vollstaendig,format="%d.%m.%Y")


if ( date_verabreicht == current_date-2 ) {

#Get Flash-Data and create Flash DE/FR
source("create_flashes.R", encoding= "UTF-8")
    
#Get Data from CSV and read in Database
source("read_data_website.R", encoding= "UTF-8")
  
if (readin_check == TRUE) {  

#Prepare Data  
source("prepare_data.R", encoding = "UTF-8")

#Create Meldungen DE/FR
source("create_meldung_de.R", encoding = "UTF-8")
source("create_meldung_fr.R", encoding = "UTF-8")
  
#Update Datawrapper Maps
source("update_datawrapper.R", encoding = "UTF-8")
  
#Send Mail

  library(blatr)
  
  blat(f = "robot-notification@awp.ch",
       to = "robot-notification@awp.ch",
       s = "Neue Impf-Zahlen gefunden",
       body= "Die neuen Zahlen auf der BAG-Seite wurden erfolgreich erfasst. Die Meldungen wurden publiziert und die Datawrapper-Karte aktualisiert.\n\n
         AWP-Robot",
       server = "smtp.juergruettimann.ch",
       u = "awp-robot@juergruettimann.ch",
       pw = "SimonWolanin123")
  
  blat(f = "robot-notification@awp.ch",
       to = "robot-notification@awp.ch, inland@keystone-sda.ch, suisse@keystone-ats.ch, redazione@keystone-ats.ch, federico.bragagnini@keystone-ats.ch, thomas.oswald@keystone-sda.ch, nicola.wenger@keystone-ats.ch",
       s = "Neue Impf-Zahlen gefunden - automatisierte Meldung steht bereit",
       body= paste0("Liebes SDA-Team,\n\n",
                    "Die neuen Zahlen auf der BAG-Seite wurden erfolgreich erfasst und die Datawrapper-Karten aktualisiert.\n\n",
                    "Ihr findet die aktuelle Meldung auf Deutsch, Französisch und Italienisch hier:\n https://github.com/awp-finanznachrichten/impfzahlen/blob/master/Output/text_sda.txt\n\n",
                    "Eine Uebersicht über den Stand aller Kantone gibt es hier: https://datawrapper.dwcdn.net/6thMk\n\n",
                    "Liebe Grüsse\n\n",
                    "AWP-Robot"),
       server = "smtp.juergruettimann.ch",
       u = "awp-robot@juergruettimann.ch",
       pw = "SimonWolanin123")
  
}  
  
 
  
break  
  
} else {

print("Keine aktuellen Impfdaten gefunden")    
  
}  

}

