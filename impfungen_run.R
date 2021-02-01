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

setwd("C:/Users/simon/OneDrive/R/impfzahlen/")

source("functions.R")
source("load_data.R")

current_date <- Sys.Date()
url <- "https://www.covid19.admin.ch/de/overview"

webpage <- retry(read_html(url),maxErrors = 5,sleep = 10)

#Datum Check ausgeliefert und verabreicht
date_ausgeliefert <- html_text(html_nodes(webpage,".bag-key-value-list__entry-key-description"))[3]
date_ausgeliefert <- gsub(",.*","",date_ausgeliefert)
date_ausgeliefert <- gsub(".*: ","",date_ausgeliefert)
date_ausgeliefert <- as.Date(date_ausgeliefert,format="%d.%m.%Y")

date_verabreicht <- html_text(html_nodes(webpage,".bag-key-value-list__entry-key-description"))[3]
date_verabreicht <- gsub(",.*","",date_verabreicht)
date_verabreicht <- gsub(".*: ","",date_verabreicht)
date_verabreicht <- as.Date(date_verabreicht,format="%d.%m.%Y")

if ( (date_ausgeliefert == current_date-2) & (date_verabreicht == current_date-2) ) {

#Get Flash-Data and create Flash DE/FR
source("create_flashes.R")
    
#Get Data from CSV and read in Database
source("read_data_website.R")
  
#Create Meldungen DE/FR
  
#Send Mail  
  
  
} else {

print("Keine aktuellen Impfdaten gefunden")    
  
}  
