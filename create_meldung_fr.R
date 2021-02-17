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

wochentag_publish <- weekdays(Sys.Date()-2)

wochentag_publish <- gsub("Monday","lundi",wochentag_publish)
wochentag_publish <- gsub("Tuesday","mardi",wochentag_publish)
wochentag_publish <- gsub("Wednesday","mercredi",wochentag_publish)
wochentag_publish <- gsub("Thursday","jeudi",wochentag_publish)
wochentag_publish <- gsub("Friday","vendredi",wochentag_publish)
wochentag_publish <- gsub("Saturday","samedi",wochentag_publish)
wochentag_publish <- gsub("Sunday","dimanche",wochentag_publish)

tendenz_fr <- gsub("stieg die Impfkadenz um","le rythme des vaccinations s'est accéléré de",tendenz)
tendenz_fr <- gsub("sank die Impfkadenz um","le rythme des vaccinations a ralenti de",tendenz_fr)
tendenz_fr <- gsub(" Prozent","%",tendenz_fr)
tendenz_fr <- gsub("hat sich die Impfkadenz nicht verändert","le rythme des vaccinations reste inchangé",tendenz_fr)

title <- paste0("Suisse: ",format(impfungen_letzte_woche,big.mark = "'")," nouvelles vaccinations en 7 jours (OFSP)")

text_einleitung <- paste0("<p>Berne (awp) - Sur une semaine et jusqu'à ",wochentag_publish,", ",
                          format(impfungen_letzte_woche,big.mark = "'"),
                          " doses de vaccin contre la Covid-19 ont été administrées en Suisse",
                          ", selon les données publiées ",
                          wochentag," sur le site de l'Office fédéral de la santé publique (OFSP).\n</p>",
                          "<p>En moyenne, ",format(round(impfungen_letzte_woche/7,0),big.mark = "'"),
                          " vaccinations ont été effectuées par jour. Comparé à la semaine précédente, ",tendenz_fr,"\n</p>",
                          "<p>Au total, ",format(impfdaten_meldung$Verimpft[1],big.mark="'"), 
                          " vaccinations ont été réalisées jusqu'à ",wochentag_publish,".",
                          " Cela représente ",gsub("[.]",",",impfdaten_meldung$Verimpft_pro_person[1]),
                          " doses de vaccin administrées sur 100 habitants en Suisse et au Liechtenstein.",
                          " Une personne doit recevoir deux doses de vaccin afin d'être protégée au mieux contre le coronavirus.\n</p>",
                          "<p>Quelque ",format(impfdaten_meldung$Impfdosen[1]-impfdaten_meldung$Verimpft[1],big.mark = "'"),
                          " doses de vaccin ont été livrées aux cantons, mais n'ont pas encore été employées.",
                          " Par ailleurs, ",format(impfungen_erhalten - impfdaten_meldung$Impfdosen[1],big.mark = "'"),
                          " doses de vaccin sont stockées par la Confédération.\n</p>")

#Create Tabelle
tabelle <- paste0("                                    7 derniers jours   semaine préc.   total\n\n",
"Doses administrées                  ",format(impfdaten_meldung$impfungen_last_week[1],big.mark = "'"),
strrep(" ",19-nchar(format(impfdaten_meldung$impfungen_last_week[1],big.mark = "'"))),
format(impfdaten_meldung$impfungen_second_last_week[1],big.mark = "'"),
strrep(" ",16-nchar(format(impfdaten_meldung$impfungen_second_last_week[1],big.mark = "'")))
,format(impfdaten_meldung$Verimpft[1],big.mark = "'"),"\n",
"Nombre vaccinations/100 habitants   ",impfdaten_meldung$personen_last_week[1],
"                ",impfdaten_meldung$personen_second_last_week[1],
"            ",impfdaten_meldung$Verimpft_pro_person[1],"\n\n",
"(2 doses de vaccin nécessaires par personne)\n\n",
"Données par cantons:\n\n",
"         vaccinations/100 habit.  variation       total vaccinations/\n",
"         7 derniers jours         semaine préc.   100 habit.\n\n",
"ZH       ",impfdaten_meldung$personen_last_week[13],
"                      ",impfdaten_meldung$impfungen_change[13],"%",
strrep(" ",15-impfdaten_meldung$char_count_change[13]),impfdaten_meldung$Verimpft_pro_person[13],"\n",
"BE       ",impfdaten_meldung$personen_last_week[8],
"                      ",impfdaten_meldung$impfungen_change[8],"%",
strrep(" ",15-impfdaten_meldung$char_count_change[8]),impfdaten_meldung$Verimpft_pro_person[8],"\n",
"BS       ",impfdaten_meldung$personen_last_week[10],
"                      ",impfdaten_meldung$impfungen_change[10],"%",
strrep(" ",15-impfdaten_meldung$char_count_change[10]),impfdaten_meldung$Verimpft_pro_person[10],"\n",
"SG       ",impfdaten_meldung$personen_last_week[18],
"                      ",impfdaten_meldung$impfungen_change[18],"%",
strrep(" ",15-impfdaten_meldung$char_count_change[18]),impfdaten_meldung$Verimpft_pro_person[18],"\n",
"AG       ",impfdaten_meldung$personen_last_week[12],
"                      ",impfdaten_meldung$impfungen_change[12],"%",
strrep(" ",15-impfdaten_meldung$char_count_change[12]),impfdaten_meldung$Verimpft_pro_person[12],"\n",
"LU       ",impfdaten_meldung$personen_last_week[22],
"                      ",impfdaten_meldung$impfungen_change[22],"%",
strrep(" ",15-impfdaten_meldung$char_count_change[22]),impfdaten_meldung$Verimpft_pro_person[22],"\n",
"GE       ",impfdaten_meldung$personen_last_week[2],
"                      ",impfdaten_meldung$impfungen_change[2],"%",
strrep(" ",15-impfdaten_meldung$char_count_change[2]),impfdaten_meldung$Verimpft_pro_person[2],"\n",
"VD       ",impfdaten_meldung$personen_last_week[3],
"                      ",impfdaten_meldung$impfungen_change[3],"%",
strrep(" ",15-impfdaten_meldung$char_count_change[3]),impfdaten_meldung$Verimpft_pro_person[3],"\n"
)

#Sonderzeichen anpassen
tabelle <- str_replace_all(tabelle,"&", "&amp;")
tabelle <- str_replace_all(tabelle,"<", "&lt;")
tabelle <- str_replace_all(tabelle,">", "&gt;")

tabelle <- str_replace_all(tabelle,"[.]",",")
tabelle <- str_replace_all(tabelle,"habit,","habit.")
tabelle <- str_replace_all(tabelle,"préc,","préc.")

text <- paste0(text_einleitung,"<pre>\n[[\n",tabelle,"\n]]</pre><p/>\n\n",
               "<p>Carte: https://datawrapper.dwcdn.net/TeJmy \n</p>",
               "<p>Sources: Office fédéral de la santé publique (OFSP) et Base logistique de l'Armée (BLA)",
               " sur www.covid.admin.ch\n</p>",
               "<p>awp-robot/sw/</p>")

#Meldung erzeugen
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
vorlage <- gsub("Insert_Status","Usable",vorlage)
vorlage <- gsub("Insert_Storytype","T",vorlage)
vorlage <- gsub("Insert_Language","fr",vorlage)
vorlage <- gsub("Insert_Country","CH",vorlage)
vorlage <- gsub("Insert_Companies","<Property FormalName='Relation.Name' Value='Bundesamt für Gesundheit (BAG)'/>", vorlage)
vorlage <- gsub("Insert_Channel","P", vorlage)
vorlage <- gsub("Insert_Relations","<Property FormalName='Subject' Value='HEA'/><Property FormalName='Subject' Value='POL'/>\n", vorlage)

#Titel und Text einfügen
vorlage <- str_replace_all(vorlage,"Insert_Headline",title)
vorlage <- str_replace_all(vorlage,"Insert_Text",text)

#Datei speichern
setwd("./Output")
cat(vorlage,file=paste0(date_and_time,"_impfungen_fr_p.xml"))

###FTP-Upload
ftpUpload(paste0(date_and_time,"_impfungen_fr_p.xml"), "ftp://ftp.awp.ch/impfungen_fr_p.xml",userpwd="awprobot:awp32Feed43")

setwd("..")

#Output für SDA

title_sda <- paste0("Coronavirus: ",format(impfungen_letzte_woche,big.mark = "'")," nouvelles vaccinations en 7 jours en Suisse (OFSP)")

text_sda_fr <- gsub("<p>","\n",text_einleitung)
text_sda_fr <- gsub("</p>","",text_sda_fr)
text_sda_fr <- paste0(title_sda,"\n",text_sda_fr)

text_sda_fr <- gsub("la Covid","le Covid",text_sda_fr)
text_sda_fr <- gsub("awp","awp/ats",text_sda_fr)

###Text SDA italienisch
title_sda_it <- paste0("Coronavirus: UFSP, ",format(impfungen_letzte_woche,big.mark = "'")," nuove vaccinazioni in 7 giorni")

#Zeitspanne
number_date <- as.numeric(format(date_verabreicht,"%d"))
number_date_earlier <- as.numeric(format(date_verabreicht-6,"%d"))
month <- months(date_verabreicht)
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



#Tendenz italienisch
tendenz_it <- gsub("le rythme des vaccinations s'est accéléré de","è aumentato del",tendenz_fr)
tendenz_it <- gsub("le rythme des vaccinations a ralenti de","è diminuito del",tendenz_it)
tendenz_it <- gsub("le rythme des vaccinations reste inchangé","non è cambiato",tendenz_it)


text_einleitung_it <- paste0("Berna (awp/ats) - Le dosi di vaccino contro il Covid-19 somministrate in Svizzera nella settimana dal ",
                             number_date_earlier," al ",number_date," ",month,
                          " sono state ",format(impfungen_letzte_woche,big.mark = "'"),
                          ". È quanto emerge dai dati pubblicati oggi sul sito dell'Ufficio federale della sanità pubblica (UFSP).\n\n",
                          "In media, nella Confederazione vengono effettuate ",format(round(impfungen_letzte_woche/7,0),big.mark = "'"),
                          " vaccinazioni al giorno. Rispetto alla settimana precedente, il ritmo delle inoculazioni ",tendenz_it,"\n\n",
                          "In totale, indica l'UFSP aggiornando i dati fino a due giorni fa, sono state già somministrate ",
                          format(impfdaten_meldung$Verimpft[1],big.mark="'"),
                          " dosi di vaccino, per una media di ",gsub("[.]",",",impfdaten_meldung$Verimpft_pro_person[1]),
                          " dosi ogni 100 abitanti.",
                          " Per essere protetta al meglio contro il coronavirus, una persona è tenuta a ricevere due dosi.\n\n",
                          "Attualmente ",format(impfdaten_meldung$Impfdosen[1]-impfdaten_meldung$Verimpft[1],big.mark = "'"),
                          " dosi sono state consegnate ai cantoni, ma non ancora somministrate.",
                          " Inoltre, ",format(impfungen_erhalten - impfdaten_meldung$Impfdosen[1],big.mark = "'"),
                          " dosi sono immagazzinate dalla Confederazione.\n\n",
                          "Note: La notizia è stata generata automaticamente sulla base dei dati dell'Ufficio federale della sanità pubblica (UFSP) e della Base logistica dell'Esercito (BLEs)"
                          )

text_sda_it <- paste0(title_sda_it,"\n\n",text_einleitung_it)

text_sda <- paste0(text_sda,"\n\n\n",text_sda_fr,"\n\n\n",text_sda_it)

cat(text_sda,file="Output/text_sda.txt", fileEncoding = "UTF-8")

