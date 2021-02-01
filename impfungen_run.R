library(dplyr)
library(DBI)
library(RMySQL)
library(rvest)
library(git2r)
library(tidyr)
library(readr)
library(stringr)
#library(DatawRappr)
library(RCurl)

setwd("C:/Automatisierungen/impfzahlen/")

source("functions.R")
source("load_data.R")

current_date <- Sys.Date()
url <- "https://www.covid19.admin.ch/de/overview"


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
date_ausgeliefert <- html_text(html_nodes(webpage,".bag-key-value-list__entry-key-description"))[2]
date_ausgeliefert <- gsub(",.*","",date_ausgeliefert)
date_ausgeliefert <- gsub(".*: ","",date_ausgeliefert)
date_ausgeliefert <- as.Date(date_ausgeliefert,format="%d.%m.%Y")

date_verabreicht <- html_text(html_nodes(webpage,".bag-key-value-list__entry-key-description"))[3]
date_verabreicht <- gsub(",.*","",date_verabreicht)
date_verabreicht <- gsub(".*: ","",date_verabreicht)
date_verabreicht <- as.Date(date_verabreicht,format="%d.%m.%Y")

if ( (date_ausgeliefert == current_date-2) & (date_verabreicht == current_date-2) ) {

#Get Flash-Data and create Flash DE/FR
source("create_flashes.R", encoding= "UTF-8")
    
#Get Data from CSV and read in Database
source("read_data_website.R", encoding= "UTF-8")
  
#Create Meldungen DE/FR
  
#Update Datawrapper Maps  
  
#Send Mail  
  
break  
  
} else {

print("Keine aktuellen Impfdaten gefunden")    
  
}  

}