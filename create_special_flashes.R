###Check total verimpfte Personen
anteil_bevoelkerung <- (as.numeric(impfdaten_meldung$Verimpft_pro_person[1])/impfdaten_meldung$Verimpft[1])*impfungen_complete

if (anteil_bevoelkerung > 50 ) {
  
  ###Create Flash DE
  flash <- "BAG: Über die Hälfte der Schweizer Bevölkerung vollständig geimpft"
  
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
  vorlage <- gsub("Insert_Status","Usable",vorlage)
  vorlage <- gsub("Insert_Language","de",vorlage)
  vorlage <- gsub("Insert_Countries","<Property FormalName='Country' Value='CH'>",vorlage)
  vorlage <- gsub("Insert_Companies","<Property FormalName='ShortName' Value='BAG'/>", vorlage)
  vorlage <- gsub("Insert_Channel","P", vorlage)
  vorlage <- gsub("Insert_Relations","<Property FormalName='Subject' Value='HEA'/><Property FormalName='Subject' Value='POL'/>\n", vorlage)

  #Flash einf?gen
  vorlage <- gsub("Insert_Headline",flash,vorlage)
  
  #Datei speichern
  setwd("./Output")
  cat(vorlage,file=paste0(date_and_time,"_flash_special_amount_de.xml"))
  
  ###FTP-Upload
  ftpUpload(paste0(date_and_time,"_flash_special_amount_de.xml"), "ftp://ftp.awp.ch/flash_special_amount_de.xml",userpwd="awprobot:awp32Feed43")
  
  setwd("..")
  
  ###Create Flash FR
  flash <- "OFSP: 50% de la population suisse complètement vaccinée"
  
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
  vorlage <- gsub("Insert_Status","Usable",vorlage)
  vorlage <- gsub("Insert_Language","fr",vorlage)
  vorlage <- gsub("Insert_Countries","<Property FormalName='Country' Value='CH'>",vorlage)
  vorlage <- gsub("Insert_Companies","<Property FormalName='ShortName' Value='BAG'/>", vorlage)
  vorlage <- gsub("Insert_Channel","P", vorlage)
  vorlage <- gsub("Insert_Relations","<Property FormalName='Subject' Value='HEA'/><Property FormalName='Subject' Value='POL'/>\n", vorlage)
  
  
  #Flash einfügen
  vorlage <- gsub("Insert_Headline",flash,vorlage)
  
  #Datei speichern
  setwd("./Output")
  cat(vorlage,file=paste0(date_and_time,"_flash_special_amount_fr.xml"))
  
  ###FTP-Upload
  ftpUpload(paste0(date_and_time,"_flash_special_amount_fr.xml"), "ftp://ftp.awp.ch/flash_special_amount_fr.xml",userpwd="awprobot:awp32Feed43")
  
  setwd("..")

  #Mail SDA
  library(blatr)
  
  blat(f = "robot-notification@awp.ch",
       to = "robot-notification@awp.ch, inland@keystone-sda.ch, suisse@keystone-ats.ch, redazione@keystone-ats.ch, federico.bragagnini@keystone-ats.ch, thomas.oswald@keystone-sda.ch, nicola.wenger@keystone-ats.ch",
       s = "Über die Hälfte der Bevölkerung vollständig geimpft",
       body= paste0("Liebes SDA-Team,\n\n",
                    "Ein nächster Meilenstein ist erreicht: Über 50 Prozent der Schweizer Bevölkerung haben bereits zwei Impfdosen erhalten und sind damit vollständig geimpft.\n\n",
                    "Liebe Grüsse\n\n",
                    "AWP-Robot"),
       server = "smtp.juergruettimann.ch",
       u = "awp-robot@juergruettimann.ch",
       pw = "SimonWolanin123")
  
}  


###Check total verimpfte Personen absolut

if (impfungen_complete > 4000000 ) {
  
  ###Create Flash DE
  flash <- "BAG: Über vier Million Personen in der Schweiz vollständig geimpft"
  
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
  vorlage <- gsub("Insert_Status","Usable",vorlage)
  vorlage <- gsub("Insert_Language","de",vorlage)
  vorlage <- gsub("Insert_Countries","<Property FormalName='Country' Value='CH'>",vorlage)
  vorlage <- gsub("Insert_Companies","<Property FormalName='ShortName' Value='BAG'/>", vorlage)
  vorlage <- gsub("Insert_Channel","P", vorlage)
  vorlage <- gsub("Insert_Relations","<Property FormalName='Subject' Value='HEA'/><Property FormalName='Subject' Value='POL'/>\n", vorlage)
  
  #Flash einf?gen
  vorlage <- gsub("Insert_Headline",flash,vorlage)
  
  #Datei speichern
  setwd("./Output")
  cat(vorlage,file=paste0(date_and_time,"_flash_special_amount_de.xml"))
  
  ###FTP-Upload
  ftpUpload(paste0(date_and_time,"_flash_special_amount_de.xml"), "ftp://ftp.awp.ch/flash_special_amount_de.xml",userpwd="awprobot:awp32Feed43")
  
  setwd("..")
  
  ###Create Flash FR
  flash <- "OFSP: Plus de quatre million de personnes complètement vaccinée en Suisse"
  
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
  vorlage <- gsub("Insert_Status","Usable",vorlage)
  vorlage <- gsub("Insert_Language","fr",vorlage)
  vorlage <- gsub("Insert_Countries","<Property FormalName='Country' Value='CH'>",vorlage)
  vorlage <- gsub("Insert_Companies","<Property FormalName='ShortName' Value='BAG'/>", vorlage)
  vorlage <- gsub("Insert_Channel","P", vorlage)
  vorlage <- gsub("Insert_Relations","<Property FormalName='Subject' Value='HEA'/><Property FormalName='Subject' Value='POL'/>\n", vorlage)
  
  
  #Flash einfügen
  vorlage <- gsub("Insert_Headline",flash,vorlage)
  
  #Datei speichern
  setwd("./Output")
  cat(vorlage,file=paste0(date_and_time,"_flash_special_amount_fr.xml"))
  
  ###FTP-Upload
  ftpUpload(paste0(date_and_time,"_flash_special_amount_fr.xml"), "ftp://ftp.awp.ch/flash_special_amount_fr.xml",userpwd="awprobot:awp32Feed43")
  
  setwd("..")
  
  #Mail SDA
  library(blatr)
  
  blat(f = "robot-notification@awp.ch",
       to = "robot-notification@awp.ch, inland@keystone-sda.ch, suisse@keystone-ats.ch, redazione@keystone-ats.ch, federico.bragagnini@keystone-ats.ch, thomas.oswald@keystone-sda.ch, nicola.wenger@keystone-ats.ch",
       s = "Über vier Million Personen in der Schweiz vollständig geimpft",
       body= paste0("Liebes SDA-Team,\n\n",
                    "Ein nächster Meilenstein ist erreicht: Über vier Million Personen in der Schweiz haben bereits zwei Impfdosen erhalten und sind damit vollständig geimpft.\n\n",
                    "Liebe Grüsse\n\n",
                    "AWP-Robot"),
       server = "smtp.juergruettimann.ch",
       u = "awp-robot@juergruettimann.ch",
       pw = "SimonWolanin123")
  
}  




