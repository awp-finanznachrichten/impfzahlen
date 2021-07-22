setwd("C:/Automatisierungen/impfzahlen/")

#Wochentage
wochentag <- weekdays(Sys.Date())

wochentag <- gsub("Monday","lundi",wochentag)
wochentag <- gsub("Tuesday","mardi",wochentag)
wochentag <- gsub("Wednesday","mercredi",wochentag)
wochentag <- gsub("Thursday","jeudi",wochentag)
wochentag <- gsub("Friday","vendredi",wochentag)
wochentag <- gsub("Saturday","samedi",wochentag)
wochentag <- gsub("Sunday","dimanche",wochentag)

wochentag_publish <- weekdays(Sys.Date()-1)

wochentag_publish <- gsub("Monday","lundi",wochentag_publish)
wochentag_publish <- gsub("Tuesday","mardi",wochentag_publish)
wochentag_publish <- gsub("Wednesday","mercredi",wochentag_publish)
wochentag_publish <- gsub("Thursday","jeudi",wochentag_publish)
wochentag_publish <- gsub("Friday","vendredi",wochentag_publish)
wochentag_publish <- gsub("Saturday","samedi",wochentag_publish)
wochentag_publish <- gsub("Sunday","dimanche",wochentag_publish)

wochentag_publish_last <- weekdays(Sys.Date()-8)
wochentag_publish_last <- gsub("Monday","lundi",wochentag_publish_last)
wochentag_publish_last <- gsub("Tuesday","mardi",wochentag_publish_last)
wochentag_publish_last <- gsub("Wednesday","mercredi",wochentag_publish_last)
wochentag_publish_last <- gsub("Thursday","jeudi",wochentag_publish_last)
wochentag_publish_last <- gsub("Friday","vendredi",wochentag_publish_last)
wochentag_publish_last <- gsub("Saturday","samedi",wochentag_publish_last)
wochentag_publish_last <- gsub("Sunday","dimanche",wochentag_publish_last)

#Monat
month <- months(date_verabreicht-1)
month <- gsub("January","janvier",month)
month <- gsub("February","février",month)
month <- gsub("March","mars",month)
month <- gsub("April","avril",month)
month <- gsub("May","mai",month)
month <- gsub("June","juin",month)
month <- gsub("July","juillet",month)
month <- gsub("August","août",month)
month <- gsub("September","septembre",month)
month <- gsub("October","octobre",month)
month <- gsub("November","novembre",month)
month <- gsub("December","décembre",month)

#Monat vor einer Woche
month_earlier <- months(date_verabreicht-7)
month_earlier <- gsub("January","janvier",month_earlier)
month_earlier <- gsub("February","février",month_earlier)
month_earlier <- gsub("March","mars",month_earlier)
month_earlier <- gsub("April","avril",month_earlier)
month_earlier <- gsub("May","mai",month_earlier)
month_earlier <- gsub("June","juin",month_earlier)
month_earlier <- gsub("July","juillet",month_earlier)
month_earlier <- gsub("August","août",month_earlier)
month_earlier <- gsub("September","septembre",month_earlier)
month_earlier <- gsub("October","octobre",month_earlier)
month_earlier <- gsub("November","novembre",month_earlier)
month_earlier <- gsub("December","décembre",month_earlier)



tendenz_fr <- gsub("stieg die Impfkadenz um","le rythme des injections s'est accéléré de",tendenz)
tendenz_fr <- gsub("sank die Impfkadenz um","le rythme des injections a ralenti de",tendenz_fr)
tendenz_fr <- gsub(" Prozent","%",tendenz_fr)
tendenz_fr <- gsub("hat sich die Impfkadenz nicht verändert","le rythme des injections reste inchangé",tendenz_fr)

title <- paste0("Suisse: ",gsub("[.]",",",anteil_bevoelkerung),"% de la population entièrement vaccinée (OFSP)")

text_einleitung <- paste0("<p>Berne (awp) - Du ",number_date_earlier," ",month_earlier," au ",number_date," ",month,", ",
                          format(impfungen_letzte_woche,big.mark = "'"),
                          " doses de vaccin contre la Covid-19 ont été administrées en Suisse.",
                          " Au total, ",gsub("[.]",",",anteil_bevoelkerung),
                          "% de la population est donc entièrement vaccinée, ",
                          " selon les données publiées ",
                          wochentag," sur le site de l'Office fédéral de la santé publique (OFSP).\n</p>",
                          "<p>Depuis le début de la campagne de vaccination, ",format(impfdaten_meldung$Verimpft[1],big.mark="'"), 
                          " de doses de vaccin ont été administrées. ",
                          format(impfungen_complete,big.mark = "'"),
                          " de personnes ont reçu deux doses de sérum et ", 
                          format(impfdaten_meldung$Verimpft[1]-(impfungen_complete*2),big.mark = "'"),
                          " jusqu'à présent une seule piqûre.\n</p>",
                          "<p>En moyenne, ",format(round(impfungen_letzte_woche/7,0),big.mark = "'"),
                          " vaccinations ont été effectuées par jour. Comparé à la semaine précédente, ",tendenz_fr,"\n</p>")

text_einleitung <- gsub("De jeudi","Du jeudi",text_einleitung)

#Create Tabelle
tabelle <- paste0("                                       actuellement   il y a 7 jours\n\n",
                  "Personnes entièrement vaccinées (%)    ",gsub("[.]",",",anteil_bevoelkerung),
                  "           ",gsub("[.]",",",anteil_bevoelkerung_last_week),"\n\n",
                  "Doses de vaccin administrées           ",format(impfdaten_meldung$Verimpft[1],big.mark="'"),
                  "      ",format(impfdaten_meldung$Verimpft_last_week[1],big.mark="'"),"\n\n"
)

cat(tabelle)


#Sonderzeichen anpassen
tabelle <- str_replace_all(tabelle,"&", "&amp;")
tabelle <- str_replace_all(tabelle,"<", "&lt;")
tabelle <- str_replace_all(tabelle,">", "&gt;")

tabelle <- str_replace_all(tabelle,"[.]",",")
tabelle <- str_replace_all(tabelle,"habit,","habit.")
tabelle <- str_replace_all(tabelle,"préc,","préc.")

text <- paste0(text_einleitung,"<pre>\n[[\n",tabelle,"\n]]</pre><p/>\n\n",
               "<p>Carte le point sur la vaccine en Suisse: https://datawrapper.dwcdn.net/TeJmy </p>",
               "<p>Sources: Office fédéral de la santé publique (OFSP)",
               " sur www.covid.admin.ch\n</p>",
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

###Daten einfügen
vorlage <- gsub("Insert_DateAndTime",date_and_time,vorlage)
vorlage <- gsub("Insert_ID",ID,vorlage)
vorlage <- gsub("Insert_Status","Withheld",vorlage)
vorlage <- gsub("Insert_Storytype","T",vorlage)
vorlage <- gsub("Insert_Language","fr",vorlage)
vorlage <- gsub("Insert_Country","CH",vorlage)
vorlage <- gsub("Insert_Companies","<Property FormalName='ShortName' Value='BAG'/>", vorlage)
vorlage <- gsub("Insert_Channel","P", vorlage)
vorlage <- gsub("Insert_Relations","<Property FormalName='Subject' Value='HEA'/><Property FormalName='Subject' Value='POL'/>\n", vorlage)

#Titel und Text einfügen
vorlage <- str_replace_all(vorlage,"Insert_Headline",title)
vorlage <- str_replace_all(vorlage,"Insert_Text",text)

#Datei speichern
setwd("./Output")
cat(vorlage,file=paste0(date_and_time,"_impfungen_fr_a.xml"))

###FTP-Upload
ftpUpload(paste0(date_and_time,"_impfungen_fr_a.xml"), "ftp://ftp.awp.ch/impfungen_fr_a.xml",userpwd="awprobot:awp32Feed43")

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

###Daten einfügen
vorlage <- gsub("Insert_DateAndTime",date_and_time,vorlage)
vorlage <- gsub("Insert_ID",ID,vorlage)
vorlage <- gsub("Insert_Status","Withheld",vorlage)
vorlage <- gsub("Insert_Storytype","T",vorlage)
vorlage <- gsub("Insert_Language","fr",vorlage)
vorlage <- gsub("Insert_Country","CH",vorlage)
vorlage <- gsub("Insert_Companies","<Property FormalName='ShortName' Value='BAG'/>", vorlage)
vorlage <- gsub("Insert_Channel","B", vorlage)
vorlage <- gsub("Insert_Relations","<Property FormalName='Subject' Value='HEA'/><Property FormalName='Subject' Value='POL'/>\n", vorlage)

#Text für B
text_b <- paste0(text_einleitung,"<p/>\n\n",
                 "<p>awp-robot/sw/</p>")

#Titel und Text einfügen
vorlage <- str_replace_all(vorlage,"Insert_Headline",title)
vorlage <- str_replace_all(vorlage,"Insert_Text",text_b)

#Datei speichern
setwd("./Output")
cat(vorlage,file=paste0(date_and_time,"_impfungen_fr_b.xml"))

###FTP-Upload
ftpUpload(paste0(date_and_time,"_impfungen_fr_b.xml"), "ftp://ftp.awp.ch/impfungen_fr_b.xml",userpwd="awprobot:awp32Feed43")

setwd("..")

#Output für SDA

title_sda <- paste0("Coronavirus: ",gsub("[.]",",",anteil_bevoelkerung),"% de la population entièrement vaccinée (OFSP)")

text_sda_fr <- gsub("<p>","\n",text_einleitung)
text_sda_fr <- gsub("</p>","",text_sda_fr)
text_sda_fr <- paste0(title_sda,"\n",
                      text_sda_fr,"\n",
                      "https://datawrapper.dwcdn.net/ILXgH ","\n\n",
                      "Note: La dépêche a été générée automatiquement sur la base des données de l’Office fédéral de la santé publique (OFSP). Elle a été relue avant diffusion."
                      )

text_sda_fr <- gsub("la Covid","le Covid",text_sda_fr)
text_sda_fr <- gsub("awp","awp/ats",text_sda_fr)

###Text SDA italienisch
title_sda_it <-  paste0("UFSP: ",gsub("[.]",",",anteil_bevoelkerung),"percento della popolazione completamente vaccinata")

#Monat
month <- months(date_verabreicht-1)
month <- gsub("January","gennaio",month)
month <- gsub("February","febbraio",month)
month <- gsub("March","marzo",month)
month <- gsub("April","aprile",month)
month <- gsub("May","maggio",month)
month <- gsub("June","giugno",month)
month <- gsub("July","luglio",month)
month <- gsub("August","agosto",month)
month <- gsub("September","settembre",month)
month <- gsub("October","ottobre",month)
month <- gsub("November","novembre",month)
month <- gsub("December","dicembre",month)

#Monat vor einer Woche
month_earlier <- months(date_verabreicht-7)
month_earlier <- gsub("January","gennaio",month_earlier)
month_earlier <- gsub("February","febbraio",month_earlier)
month_earlier <- gsub("March","marzo",month_earlier)
month_earlier <- gsub("April","aprile",month_earlier)
month_earlier <- gsub("May","maggio",month_earlier)
month_earlier <- gsub("June","giugno",month_earlier)
month_earlier <- gsub("July","luglio",month_earlier)
month_earlier <- gsub("August","agosto",month_earlier)
month_earlier <- gsub("September","settembre",month_earlier)
month_earlier <- gsub("October","ottobre",month_earlier)
month_earlier <- gsub("November","novembre",month_earlier)
month_earlier <- gsub("December","dicembre",month_earlier)

#Tendenz italienisch
tendenz_it <- gsub("le rythme des injections s'est accéléré de","è aumentato del",tendenz_fr)
tendenz_it <- gsub("le rythme des injections a ralenti de","è diminuito del",tendenz_it)
tendenz_it <- gsub("le rythme des injections reste inchangé","non è cambiato",tendenz_it)


text_einleitung_it <- paste0("Berna (awp/ats) - Fra il ",
                          number_date_earlier," ",month_earlier," e il ",number_date," ",month,
                          " in Svizzera sono state somministrate ",format(impfungen_letzte_woche,big.mark = "'"),
                          " dosi di vaccino anti-Covid 19.",
                          " Ora il ",gsub("[.]",",",anteil_bevoelkerung),
                          "%  della popolazione è completamente vaccinata, secondo i dati pubblicati dall’Ufficio federale della sanità pubblica (UFSP).\n\n",
                          "In totale sono stati somministrati ",
                          format(impfdaten_meldung$Verimpft[1],big.mark="'"),
                          " vaccini. ",format(impfungen_complete,big.mark = "'"),
                          " di persone hanno ricevuto due iniezioni e altre ",
                          format(impfdaten_meldung$Verimpft[1]-(impfungen_complete*2),big.mark = "'"),
                          " hanno fino ad ora ricevuto solo la prima dose.\n\n",
                          "In media, nella Confederazione vengono effettuate ",format(round(impfungen_letzte_woche/7,0),big.mark = "'"),
                          " vaccinazioni al giorno. Rispetto alla settimana precedente, il ritmo delle inoculazioni ",tendenz_it,"\n\n",
                          "https://datawrapper.dwcdn.net/mfQwr","\n\n",
                          "Note: La notizia è stata generata automaticamente sulla base dei dati dell'Ufficio federale della sanità pubblica (UFSP)"
                          )

text_sda_it <- paste0(title_sda_it,"\n\n",text_einleitung_it)

text_sda <- paste0(text_sda,"\n\n\n",text_sda_fr,"\n\n\n",text_sda_it)

cat(text_sda,file="Output/text_sda.txt", fileEncoding = "UTF-8")
