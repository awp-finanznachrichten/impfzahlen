setwd("C:/Automatisierungen/impfzahlen/")

#Get Data for Flashes
data_check <- html_text(html_nodes(webpage,"h3"))
impfungen_check <- grepl("Impfungen",data_check[7])

text_check <- grepl("Verabreichte Impfdosen",html_text(html_nodes(webpage,"th"))[25])
text_check_2 <- grepl("Erhaltene Impfdosen",html_text(html_nodes(webpage,"th"))[23])

if  ( (impfungen_check == TRUE) & (text_check == TRUE) & (text_check_2 == TRUE) ) {
  
#Get Data  
data <- html_text(html_nodes(webpage,"td"))  

impfungen_verabreicht <- as.numeric(gsub("[^0-9.]", "",data[24]))
impfungen_complete <- 3722255 #as.numeric(gsub("[^0-9.]", "",data[23]))
impfungen_erhalten <- as.numeric(gsub("[^0-9.]", "",data[22]))

impfungen_verabreicht_vorwoche <- impfdaten[impfdaten$datum == current_date-9 &   #9
                                              impfdaten$Typ == "Bislang total verimpft",
                                            4]

impfungen_verabreicht_zweiwochen <- impfdaten[impfdaten$datum == current_date-16 &  #16
                                              impfdaten$Typ == "Bislang total verimpft",
                                            4]

impfungen_letzte_woche <- impfungen_verabreicht - impfungen_verabreicht_vorwoche
impfungen_vorletzte_woche <- impfungen_verabreicht_vorwoche - impfungen_verabreicht_zweiwochen

impfungen_veraenderung <- round((impfungen_letzte_woche*100)/impfungen_vorletzte_woche-100,0)

if (impfungen_veraenderung > 0) {

impfungen_veraenderung <- paste0("+",impfungen_veraenderung,"%")   
  
} else if (impfungen_veraenderung == 0) {

impfungen_veraenderung <- "stabil"    
  
} else {

impfungen_veraenderung <- paste0(impfungen_veraenderung,"%")    
  
}  

###Create Flash DE
flash <- paste0("BAG: ",format(impfungen_letzte_woche,big.mark = "'")," Impfungen in den letzten 7 Tagen, ",
                impfungen_veraenderung," ggü. Vorwoche")

#ID erzeugen
ID <- read.delim("C:/Automatisierungen/ID_Meldungen/ID_Meldungen.txt", header=FALSE)
ID <- as.numeric(ID)
ID_new <- ID+1
cat(ID_new, file="C:/Automatisierungen/ID_Meldungen/ID_Meldungen.txt")


#Flash-Vorlage laden
vorlage <- read_file("./Vorlage_Flashes/Vorlage_Flashes.txt")

#Datum und Zeit
date_and_time <- format(Sys.time(), "%Y%m%dT%H%M%S%z")

#Daten einfügen
vorlage <- gsub("Insert_DateAndTime",date_and_time,vorlage)
vorlage <- gsub("Insert_ID",ID,vorlage)
vorlage <- gsub("Insert_Status","Withheld",vorlage)
vorlage <- gsub("Insert_Language","de",vorlage)
vorlage <- gsub("Insert_Countries","<Property FormalName='Country' Value='CH'>",vorlage)
vorlage <- gsub("Insert_Companies","<Property FormalName='ShortName' Value='BAG'/>", vorlage)
vorlage <- gsub("Insert_Channel","P", vorlage)
vorlage <- gsub("Insert_Relations","<Property FormalName='Subject' Value='HEA'/><Property FormalName='Subject' Value='POL'/>\n", vorlage)


#Flash einf?gen
vorlage <- gsub("Insert_Headline",flash,vorlage)

#Datei speichern
setwd("./Output")
cat(vorlage,file=paste0(date_and_time,"_flash_impfungen_de.xml"))

###FTP-Upload
ftpUpload(paste0(date_and_time,"_flash_impfungen_de.xml"), "ftp://ftp.awp.ch/flash_impfungen_de.xml",userpwd="awprobot:awp32Feed43")

setwd("..")

###Create Flash FR
flash <- paste0("OFSP: ",format(impfungen_letzte_woche,big.mark = "'")," vaccinations en 7 jours, ",
                impfungen_veraenderung," sur une semaine")

flash <- gsub("stabil","stable",flash)

#ID erzeugen
ID <- read.delim("C:/Automatisierungen/ID_Meldungen/ID_Meldungen.txt", header=FALSE)
ID <- as.numeric(ID)
ID_new <- ID+1
cat(ID_new, file="C:/Automatisierungen/ID_Meldungen/ID_Meldungen.txt")


#Flash-Vorlage laden
vorlage <- read_file("./Vorlage_Flashes/Vorlage_Flashes.txt")

#Datum und Zeit
date_and_time <- format(Sys.time(), "%Y%m%dT%H%M%S%z")

#Daten einfügen
vorlage <- gsub("Insert_DateAndTime",date_and_time,vorlage)
vorlage <- gsub("Insert_ID",ID,vorlage)
vorlage <- gsub("Insert_Status","Withheld",vorlage)
vorlage <- gsub("Insert_Language","fr",vorlage)
vorlage <- gsub("Insert_Countries","<Property FormalName='Country' Value='CH'>",vorlage)
vorlage <- gsub("Insert_Companies","<Property FormalName='ShortName' Value='BAG'/>", vorlage)
vorlage <- gsub("Insert_Channel","P", vorlage)
vorlage <- gsub("Insert_Relations","<Property FormalName='Subject' Value='HEA'/><Property FormalName='Subject' Value='POL'/>\n", vorlage)


#Flash einfügen
vorlage <- gsub("Insert_Headline",flash,vorlage)

#Datei speichern
setwd("./Output")
cat(vorlage,file=paste0(date_and_time,"_flash_impfungen_fr.xml"))

###FTP-Upload
ftpUpload(paste0(date_and_time,"_flash_impfungen_fr.xml"), "ftp://ftp.awp.ch/flash_impfungen_fr.xml",userpwd="awprobot:awp32Feed43")

setwd("..")

} else {
  
#Mail
library(blatr)
  
  blat(f = "robot-notification@awp.ch",
       to = "robot-notification@awp.ch",
       s = "Problem beim Einlesen der Impfzahlen",
       body= "Die Impfzahlen für den Flash konnten heute auf der BAG-Seite nicht korrekt erfasst werden.\n\n
         AWP-Robot",
       server = "smtp.juergruettimann.ch",
       u = "awp-robot@juergruettimann.ch",
       pw = "SimonWolanin123")
}  

