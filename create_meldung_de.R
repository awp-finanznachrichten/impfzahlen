setwd("C:/Automatisierungen/impfzahlen/")

#Wochentage
wochentag <- weekdays(Sys.Date())

wochentag <- gsub("Monday","Montag",wochentag)
wochentag <- gsub("Tuesday","Dienstag",wochentag)
wochentag <- gsub("Wednesday","Mittwoch",wochentag)
wochentag <- gsub("Thursday","Donnerstag",wochentag)
wochentag <- gsub("Friday","Freitag",wochentag)
wochentag <- gsub("Saturday","Samstag",wochentag)
wochentag <- gsub("Sunday","Sonntag",wochentag)

wochentag_publish <- weekdays(Sys.Date()-1)

wochentag_publish <- gsub("Monday","Montag",wochentag_publish)
wochentag_publish <- gsub("Tuesday","Dienstag",wochentag_publish)
wochentag_publish <- gsub("Wednesday","Mittwoch",wochentag_publish)
wochentag_publish <- gsub("Thursday","Donnerstag",wochentag_publish)
wochentag_publish <- gsub("Friday","Freitag",wochentag_publish)
wochentag_publish <- gsub("Saturday","Samstag",wochentag_publish)
wochentag_publish <- gsub("Sunday","Sonntag",wochentag_publish)

#Datum
number_date <- as.numeric(format(date_verabreicht-1,"%d"))
number_date_earlier <- as.numeric(format(date_verabreicht-8,"%d"))

#Monat
month <- months(date_verabreicht-1)
month <- gsub("January","Januar",month)
month <- gsub("February","Februar",month)
month <- gsub("March","März",month)
month <- gsub("April","April",month)
month <- gsub("May","Mai",month)
month <- gsub("June","Juni",month)
month <- gsub("July","Juli",month)
month <- gsub("August","August",month)
month <- gsub("September","September",month)
month <- gsub("October","Oktober",month)
month <- gsub("November","November",month)
month <- gsub("December","Dezember",month)

#Monat vor einer Woche
month_earlier <- months(date_verabreicht-8)
month_earlier <- gsub("January","Januar",month_earlier)
month_earlier <- gsub("February","Februar",month_earlier)
month_earlier <- gsub("March","März",month_earlier)
month_earlier <- gsub("April","April",month_earlier)
month_earlier <- gsub("May","Mai",month_earlier)
month_earlier <- gsub("June","Juni",month_earlier)
month_earlier <- gsub("July","Juli",month_earlier)
month_earlier <- gsub("August","August",month_earlier)
month_earlier <- gsub("September","September",month_earlier)
month_earlier <- gsub("October","Oktober",month_earlier)
month_earlier <- gsub("November","November",month_earlier)
month_earlier <- gsub("December","Dezember",month_earlier)


title <- paste0("BAG registriert ",format(impfungen_letzte_woche,big.mark = "'")," neue Impfungen in den letzten 7 Tagen")


#Impfanteil vollständing und teilweise geimpft
anteil_bevoelkerung <- round((as.numeric(impfdaten_meldung$Verimpft_pro_person[1])/impfdaten_meldung$Verimpft[1])*impfungen_complete,1)



text_einleitung <- paste0("<p>Bern (awp) - Vom ",number_date_earlier,". ",month_earlier," bis ",number_date,". ",month," sind in der Schweiz ",
                          format(impfungen_letzte_woche,big.mark = "'")," Impfdosen gegen Covid-19 verabreicht worden.",
                          " Damit sind neu ", gsub("[.]",",",anteil_bevoelkerung), " Prozent der Bevölkerung vollständig geimpft.",
                          " Dies geht aus den Angaben hervor, die das Bundesamt für Gesundheit (BAG) am ",wochentag,
                          " auf seiner Website veröffentlichte.\n</p>",
                          "<p>Insgesamt wurden ",format(impfdaten_meldung$Verimpft[1],big.mark="'"),
                          " Impfungen verabreicht. ",format(impfungen_complete,big.mark = "'"),
                          " Personen haben zwei Impfdosen erhalten, bei ",
                          format(impfdaten_meldung$Verimpft[1]-(impfungen_complete*2),big.mark = "'"),
                          " Personen wurde bislang nur die Erstimpfung durchgeführt.\n</p>",
                          "<p>Pro Tag wurden letzte Woche durchschnittlich ",format(round(impfungen_letzte_woche/7,0),big.mark = "'"),
                          " Impfungen durchgeführt. Im Vergleich zur Woche davor ",tendenz,"\n</p>")
             

#Create Tabelle
tabelle <- paste0("                                       Aktuell    Vor 7 Tagen\n\n",
"Vollständig geimpfte Personen           ",gsub("[.]",",",anteil_bevoelkerung),
"         ",gsub("[.]",",",anteil_bevoelkerung),"\n",
"Personen mit mindestens einer Impfung   ",gsub("[.]",",",anteil_bevoelkerung),
"         ",gsub("[.]",",",anteil_bevoelkerung),"\n\n"
)


#Sonderzeichen anpassen

tabelle <- str_replace_all(tabelle,"&", "&amp;")
tabelle <- str_replace_all(tabelle,"<", "&lt;")
tabelle <- str_replace_all(tabelle,">", "&gt;")

tabelle <- str_replace_all(tabelle,"[.]",",")
tabelle <- str_replace_all(tabelle,"Einw,","Einw.")
tabelle <- str_replace_all(tabelle,"Impf,","Impf.")
tabelle <- str_replace_all(tabelle,"ggü,","ggü.")

text <- paste0(text_einleitung,"<pre>\n[[\n",tabelle,"\n]]</pre><p/>\n\n",
               "<p>Übersichtskarte zur Situation in den einzelnen Kantonen: https://datawrapper.dwcdn.net/d7vmx </p>",
               "<p>Grafik zur Impfgeschwindigkeit in der Schweiz: https://datawrapper.dwcdn.net/bNIJk \n</p>",
               "<p>Quelle: Daten des Bundesamts für Gesundheit (BAG) und der Logistikbasis der Armee (LBA)",
               " auf www.covid.admin.ch\n</p>",
               "<p>awp-robot/sw/</p>")

#Meldung erzeugen P
date_and_time <- format(Sys.time(), "%Y%m%dT%H%M%S%z")


#ID erzeugen
ID <- read.delim("C:/Automatisierungen/ID_Meldungen/ID_Meldungen.txt", header=FALSE)
ID <- as.numeric(ID)
ID_new <- ID+1
cat(ID_new, file="C:/Automatisierungen/ID_Meldungen/ID_Meldungen.txt")

#Vorlage laden
vorlage <- read_file("C:/Automatisierungen/Vorlage_XML/Vorlage_XML.txt")

###Daten einf?gen
vorlage <- gsub("Insert_DateAndTime",date_and_time,vorlage)
vorlage <- gsub("Insert_ID",ID,vorlage)
vorlage <- gsub("Insert_Status","Withheld",vorlage)
vorlage <- gsub("Insert_Storytype","T",vorlage)
vorlage <- gsub("Insert_Language","de",vorlage)
vorlage <- gsub("Insert_Country","CH",vorlage)
vorlage <- gsub("Insert_Companies","<Property FormalName='ShortName' Value='BAG'/>", vorlage)
vorlage <- gsub("Insert_Channel","P", vorlage)
vorlage <- gsub("Insert_Relations","<Property FormalName='Subject' Value='HEA'/><Property FormalName='Subject' Value='POL'/>\n", vorlage)

#Titel und Text einfügen
vorlage <- str_replace_all(vorlage,"Insert_Headline",title)
vorlage <- str_replace_all(vorlage,"Insert_Text",text)

#Datei speichern
setwd("./Output")
cat(vorlage,file=paste0(date_and_time,"_impfungen_de_a.xml"))

###FTP-Upload
ftpUpload(paste0(date_and_time,"_impfungen_de_a.xml"), "ftp://ftp2.awp.ch/impfungen_de_a.xml",userpwd="awprobot:awp32Feed43")

setwd("..")

#Meldung erzeugen B
date_and_time <- format(Sys.time(), "%Y%m%dT%H%M%S%z")

#ID erzeugen
ID <- read.delim("C:/Automatisierungen/ID_Meldungen/ID_Meldungen.txt", header=FALSE)
ID <- as.numeric(ID)
ID_new <- ID+1
cat(ID_new, file="C:/Automatisierungen/ID_Meldungen/ID_Meldungen.txt")

#Vorlage laden
vorlage <- read_file("C:/Automatisierungen/Vorlage_XML/Vorlage_XML.txt")

###Daten einf?gen
vorlage <- gsub("Insert_DateAndTime",date_and_time,vorlage)
vorlage <- gsub("Insert_ID",ID,vorlage)
vorlage <- gsub("Insert_Status","Withheld",vorlage)
vorlage <- gsub("Insert_Storytype","T",vorlage)
vorlage <- gsub("Insert_Language","de",vorlage)
vorlage <- gsub("Insert_Country","CH",vorlage)
vorlage <- gsub("Insert_Companies","<Property FormalName='ShortName' Value='BAG'/>", vorlage)
vorlage <- gsub("Insert_Channel","B", vorlage)
vorlage <- gsub("Insert_Relations","<Property FormalName='Subject' Value='HEA'/><Property FormalName='Subject' Value='POL'/>\n", vorlage)

#Text B
text_b <- paste0(text_einleitung,"<p/>\n\n",
                 "<p>awp-robot/sw/</p>")


#Titel und Text einfügen
vorlage <- str_replace_all(vorlage,"Insert_Headline",title)
vorlage <- str_replace_all(vorlage,"Insert_Text",text_b)

#Datei speichern
setwd("./Output")
cat(vorlage,file=paste0(date_and_time,"_impfungen_de_b.xml"))

###FTP-Upload
ftpUpload(paste0(date_and_time,"_impfungen_de_b.xml"), "ftp://ftp2.awp.ch/impfungen_de_b.xml",userpwd="awprobot:awp32Feed43")

setwd("..")

#Output für SDA
text_sda <- gsub("<p>","\n",text_einleitung)
text_sda <- gsub("</p>","",text_sda)
text_sda <- paste0(title,"\n",text_sda,"\n",
                   "https://datawrapper.dwcdn.net/6thMk","\n\n",
                   "Die Meldung wurde automatisch auf Basis der Daten des Bundesamts für Gesundheit (BAG) und der Logistikbasis der Armee (LBA) erstellt. Sie wurde vor der Publikation überprüft."
                   )

text_sda <- gsub("awp","awp/sda",text_sda)
                          