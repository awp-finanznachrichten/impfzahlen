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

wochentag_publish <- weekdays(Sys.Date()-2)

wochentag_publish <- gsub("Monday","Montag",wochentag_publish)
wochentag_publish <- gsub("Tuesday","Dienstag",wochentag_publish)
wochentag_publish <- gsub("Wednesday","Mittwoch",wochentag_publish)
wochentag_publish <- gsub("Thursday","Donnerstag",wochentag_publish)
wochentag_publish <- gsub("Friday","Freitag",wochentag_publish)
wochentag_publish <- gsub("Saturday","Samstag",wochentag_publish)
wochentag_publish <- gsub("Sunday","Sonntag",wochentag_publish)


title <- paste0("BAG registriert ",format(impfungen_letzte_woche,big.mark = "'")," neue Impfungen in den letzten 7 Tagen")

text_einleitung <- paste0("<p>Bern (awp) - Bis und mit ",wochentag_publish," sind in der Schweiz innert Wochenfrist ",
                          format(impfungen_letzte_woche,big.mark = "'")," Impfdosen gegen Covid-19 verabreicht worden.",
                          " Dies geht aus den Angaben hervor, die das Bundesamt für Gesundheit (BAG) heute ",wochentag,
                          " auf seiner Website veröffentlicht hat.\n</p>",
                          "<p>Pro Tag wurden damit durchschnittlich ",format(round(impfungen_letzte_woche/7,0),big.mark = "'"),
                          " Impfungen durchgeführt. Im Vergleich zur Woche davor ",tendenz,"\n</p>",
                          "<p>Insgesamt wurden bis ",wochentag_publish," ",format(impfdaten_meldung$Verimpft[1],big.mark="'"),
                          " Impfungen durchgeführt. Aktuell sind damit pro 100 Einwohner in der Schweiz und in Liechtenstein ",
                          gsub("[.]",",",format(impfdaten_meldung$Verimpft_pro_person[1],big.mark="'")),
                          " Impfdosen verabreicht worden. Um gegen eine Erkrankung an Covid-19 optimal geschützt zu sein,",
                          " sind pro Person zwei Impfdosen notwendig.\n</p>",
                          "<p>Bereits an die Kantone ausgeliefert, aber noch nicht verimpft sind momentan ",
                          format(impfdaten_meldung$Impfdosen[1]-impfdaten_meldung$Verimpft[1],big.mark = "'"),
                          " Impfdosen.\n</p>")

#Create Tabelle
tabelle <- paste0("                              Letzte 7 Tage    Woche davor     Total\n\n",
"Verimpfte Dosen               ",format(impfdaten_meldung$impfungen_last_week[1],big.mark = "'"),
strrep(" ",17-nchar(format(impfdaten_meldung$impfungen_last_week[1],big.mark = "'"))),
format(impfdaten_meldung$impfungen_second_last_week[1],big.mark = "'"),
strrep(" ",16-nchar(format(impfdaten_meldung$impfungen_second_last_week[1],big.mark = "'")))
,format(impfdaten_meldung$Verimpft[1],big.mark = "'"),"\n",
"Impfungen pro 100 Einwohner   ",impfdaten_meldung$personen_last_week[1],
"              ",impfdaten_meldung$personen_second_last_week[1],
"             ",impfdaten_meldung$Verimpft_pro_person[1],"\n\n",
"(pro Person sind zwei Impfungen notwendig)\n\n",
"Daten aus ausgewählten Kantonen:\n\n",
"         Zahl Impf./100 Einw.   Veränderung     Total Impf./\n",
"         letzte 7 Tage          ggü. Vorwoche   100 Einw.\n\n",
"ZH       ",impfdaten_meldung$personen_last_week[13],
"                    ",impfdaten_meldung$impfungen_change[13],"%",
strrep(" ",15-impfdaten_meldung$char_count_change[13]),impfdaten_meldung$Verimpft_pro_person[13],"\n",
"BE       ",impfdaten_meldung$personen_last_week[8],
"                    ",impfdaten_meldung$impfungen_change[8],"%",
strrep(" ",15-impfdaten_meldung$char_count_change[8]),impfdaten_meldung$Verimpft_pro_person[8],"\n",
"BS       ",impfdaten_meldung$personen_last_week[10],
"                    ",impfdaten_meldung$impfungen_change[10],"%",
strrep(" ",15-impfdaten_meldung$char_count_change[10]),impfdaten_meldung$Verimpft_pro_person[10],"\n",
"SG       ",impfdaten_meldung$personen_last_week[18],
"                    ",impfdaten_meldung$impfungen_change[18],"%",
strrep(" ",15-impfdaten_meldung$char_count_change[18]),impfdaten_meldung$Verimpft_pro_person[18],"\n",
"AG       ",impfdaten_meldung$personen_last_week[12],
"                    ",impfdaten_meldung$impfungen_change[12],"%",
strrep(" ",15-impfdaten_meldung$char_count_change[12]),impfdaten_meldung$Verimpft_pro_person[12],"\n",
"LU       ",impfdaten_meldung$personen_last_week[22],
"                    ",impfdaten_meldung$impfungen_change[22],"%",
strrep(" ",15-impfdaten_meldung$char_count_change[22]),impfdaten_meldung$Verimpft_pro_person[22],"\n",
"GE       ",impfdaten_meldung$personen_last_week[2],
"                    ",impfdaten_meldung$impfungen_change[2],"%",
strrep(" ",15-impfdaten_meldung$char_count_change[2]),impfdaten_meldung$Verimpft_pro_person[2],"\n",
"VD       ",impfdaten_meldung$personen_last_week[3],
"                    ",impfdaten_meldung$impfungen_change[3],"%",
strrep(" ",15-impfdaten_meldung$char_count_change[3]),impfdaten_meldung$Verimpft_pro_person[3],"\n"
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
               "<p>Quelle: Daten des Bundesamts für Gesundheit (BAG) und der Logistikbasis der Armee (LBA)",
               " auf www.covid.admin.ch\n</p>",
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

###Daten einf?gen
vorlage <- gsub("Insert_DateAndTime",date_and_time,vorlage)
vorlage <- gsub("Insert_ID",ID,vorlage)
vorlage <- gsub("Insert_Status","Withheld",vorlage)
vorlage <- gsub("Insert_Storytype","T",vorlage)
vorlage <- gsub("Insert_Language","de",vorlage)
vorlage <- gsub("Insert_Country","CH",vorlage)
vorlage <- gsub("Insert_Companies","<Property FormalName='Relation.Name' Value='Bundesamt für Gesundheit (BAG)'/>", vorlage)
vorlage <- gsub("Insert_Channel","P", vorlage)
vorlage <- gsub("Insert_Relations","<Property FormalName='Subject' Value='HEA'/><Property FormalName='Subject' Value='POL'/>\n", vorlage)

#Titel und Text einfügen
vorlage <- str_replace_all(vorlage,"Insert_Headline",title)
vorlage <- str_replace_all(vorlage,"Insert_Text",text)

#Datei speichern
setwd("./Output")
cat(vorlage,file=paste0(date_and_time,"_impfungen_de_p.xml"))

###FTP-Upload
ftpUpload(paste0(date_and_time,"_impfungen_de_p.xml"), "ftp://ftp.awp.ch/impfungen_de_p.xml",userpwd="awprobot:awp32Feed43")

setwd("..")

#Output für SDA
text_sda <- gsub("<p>","\n",text_einleitung)
text_sda <- gsub("</p>","",text_sda)
text_sda <- paste0(title,"\n",text_sda)
                          