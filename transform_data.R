setwd("C:/Automatisierungen/impfzahlen")

#Impfdaten abrufen
mydb <- dbConnect(MySQL(), user='awp', password='rs71MR3!', dbname='covid', host='32863.hostserv.eu')
rs <- dbSendQuery(mydb, "SELECT * FROM impfungen")
impfdaten <- DBI::fetch(rs,n=-1)

dbDisconnectAll()

impfungen_ch <- format(impfdaten[nrow(impfdaten)-1,4],big.mark = "'")
impfungen_anteil_ch <- round(impfdaten[nrow(impfdaten),4],1)
impfdaten <- impfdaten[,-c(1,4,31)]


#Kantonsnamen abrufen
kantone <- read_csv("Daten/MASTERFILE_GDE_NEW.csv")
kantone <- unique(kantone[,c(2,9:11)])


#Transform Data
long <- impfdaten %>%
  gather(area,value,-c(datum,Typ))

long$datum <- as.Date(long$datum)
last_date <- long$datum[nrow(long)]
last_date_string <- format(last_date,"%d.%m.%Y")

long_verimpft_aktuell <- long[long$Typ == "Bislang total verimpft" & long$datum == last_date,]
long_verimpft_last_week <- long[long$Typ == "Bislang total verimpft" & long$datum == last_date-7,] #7
long_verimpft_second_last_week <- long[long$Typ == "Bislang total verimpft" & long$datum == last_date-7,] #14
long_verimpft_second_last_week$value <- long_verimpft_second_last_week$value - 1000
long_impfdosen <- long[long$Typ == "Gelieferte Impfdosen" & long$datum == last_date,]
long_verimpft_pro_person <- long[long$Typ == "Geimpfte Dosen pro 100 Einwohner" & long$datum == last_date,]

#Create Data Frame
impfdaten_dw <- data.frame("Kanton_short","Datum",999,999,
                  999,999,999,999,999)

colnames(impfdaten_dw) <- c("Kanton_Short","Datum","Verimpft","Verimpft_pro_Person",
                            "Verimpft_pro_Tag","Verimpft_pro_Tag_Vorwoche","Veraenderung","Geliefert","Verimpft_Anteil")


for (i in 1:26) {

kanton_short <- long_verimpft_aktuell$area[i]
verimpft <- long_verimpft_aktuell$value[i]
verimpft_pro_person <- long_verimpft_pro_person$value[i]
verimpft_pro_tag <- (long_verimpft_aktuell$value[i]-long_verimpft_last_week$value[i])/7
verimpft_pro_tag_vorwoche <- (long_verimpft_last_week$value[i]-long_verimpft_second_last_week$value[i])/7
veraenderung <- (verimpft_pro_tag*100)/verimpft_pro_tag_vorwoche-100  
geliefert <- long_impfdosen$value[i]
verimpft_anteil <- (long_verimpft_aktuell$value[i]/long_impfdosen$value[i])*100

new_data <- data.frame(kanton_short,last_date_string,verimpft,verimpft_pro_person,
                       verimpft_pro_tag,verimpft_pro_tag_vorwoche,veraenderung,
                       geliefert,verimpft_anteil)

colnames(new_data) <- c("Kanton_Short","Datum","Verimpft","Verimpft_pro_Person",
                            "Verimpft_pro_Tag","Verimpft_pro_Tag_Vorwoche","Veraenderung","Geliefert","Verimpft_Anteil")

impfdaten_dw <- rbind(impfdaten_dw,new_data)
  
}

#Adapt dw Data
impfdaten_dw <- impfdaten_dw[-1,]
impfdaten_dw$Verimpft_pro_Person <- round(impfdaten_dw$Verimpft_pro_Person,1)
impfdaten_dw$Verimpft <- format(impfdaten_dw$Verimpft,big.mark = "'")
impfdaten_dw$Verimpft_pro_Tag <- format(round(impfdaten_dw$Verimpft_pro_Tag,0),big.mark = "'")
impfdaten_dw$Verimpft_pro_Tag_Vorwoche <- format(round(impfdaten_dw$Verimpft_pro_Tag_Vorwoche,0),big.mark = "'")
impfdaten_dw$Veraenderung <- round(impfdaten_dw$Veraenderung,0)
impfdaten_dw$Geliefert <- format(impfdaten_dw$Geliefert,big.mark = "'")
impfdaten_dw$Verimpft_Anteil <- round(impfdaten_dw$Verimpft_Anteil,0)

#Merge mit Kantonsnamen
impfdaten_dw <- merge(impfdaten_dw,kantone)

#Create_Text
impfdaten_dw$Text_d <- paste0("Im Kanton ",impfdaten_dw$Kanton_d," wurden bislang pro 100 Einwohner <b>",
                              impfdaten_dw$Verimpft_pro_Person,"</b> Impfungen durchgeführt.",
                              " Das entspricht <b>",impfdaten_dw$Verimpft,"</b> Impfungen.",
                              " In der vergangenen Woche wurden pro Tag durchschnittlich <b>",impfdaten_dw$Verimpft_pro_Tag,
                              "</b> Personen geimpft.",
                              #" Im Vergleich zur Vorwoche eintspricht dies einer Veränderung von <b>",impfdaten_dw$Veraenderung,"%</b>.",
                              " Insgesamt wurden in den Kanton ",impfdaten_dw$Kanton_d," bislang <b>",impfdaten_dw$Geliefert,
                              "</b> Impfdosen geliefert. Davon wurden bereits <b>",impfdaten_dw$Verimpft_Anteil,"%</b> verimpft.<br><br>")

#Create_Text
impfdaten_dw$Text_f <- paste0("Dans le canton de ",impfdaten_dw$Kanton_f,", <b>",
                              impfdaten_dw$Verimpft_pro_Person,"</b> injections pour 100 habitants ont été réalisées jusqu’ici.",
                              " Cela représente en tout <b>",impfdaten_dw$Verimpft,"</b> vaccinations.",
                              " La semaine dernière, <b>",impfdaten_dw$Verimpft_pro_Tag,
                              "</b> personnes ont été vaccinées chaque jour en moyenne.",
                              #" Cela représente une variation de <b>",impfdaten_dw$Veraenderung,"%</b> par rapport à la semaine précédente.",
                              " Au total, <b>",impfdaten_dw$Geliefert,"</b> doses de vaccin ont été livrées jusqu’ici dans le canton de ",
                              impfdaten_dw$Kanton_f,". Sur ce nombre, <b>",impfdaten_dw$Verimpft_Anteil,
                              "%</b> ont été utilisés.<br><br>")

impfdaten_dw$Text_i <- paste0("Nel canton ",impfdaten_dw$Kanton_i," fino a questo momento sono state effettuate <b>",
                              impfdaten_dw$Verimpft_pro_Person,"</b> iniezioni ogni 100 abitanti.",
                              " In cifre assolute, si tratta di <b>",impfdaten_dw$Verimpft,"</b> vaccinazioni.",
                              " La scorsa settimana, in media <b>",impfdaten_dw$Verimpft_pro_Tag,
                              "</b> persone sono state vaccinate giornalmente.",
                              #" (variazione rispetto alla settimana precedente: <b>",impfdaten_dw$Veraenderung,"%)</b>.",
                              " In totale, fino ad ora al canton ",impfdaten_dw$Kanton_i," sono state consegnate <b>",impfdaten_dw$Geliefert,
                              "</b> dosi di vaccino. Quota di utilizzo: <b>",impfdaten_dw$Verimpft_Anteil,"%</b>.<br><br>")

impfdaten_dw <- excuse_my_french(impfdaten_dw)




#Write File
write.csv(impfdaten_dw,"Output/impfdaten.csv", row.names=FALSE, fileEncoding = "UTF-8")
                           
#Make Commit
git2r::config(user.name = "awp-finanznachrichten",user.email = "sw@awp.ch")
gitadd()
gitcommit()
gitpush()


#Change Title of Datawrapper-Chart and publish Charts
dw_edit_chart("8nBMe",intro=paste0("In der Schweiz wurden bislang pro 100 Einwohner <b>",impfungen_anteil_ch,"</b> Impfdosen verabreicht. Das entspricht <b>",impfungen_ch,"</b> Impfungen. Für einen optimalen Schutz sind zwei Impfdosen pro Person nötig."), annotate=paste0("Stand: ",impfdaten_dw$Datum[1]))
dw_publish_chart("8nBMe")

dw_edit_chart("Ty61K",intro=paste0("En Suisse, <b>",impfungen_anteil_ch,"</b> injections pour 100 habitants ont été réalisées jusqu'ici. Cela représente en tout <b>",impfungen_ch,"</b> vaccinations. Pour garantir und protection optimale, deux doses de vaccin sont nécessaires."), annotate=paste0("Etat: ",impfdaten_dw$Datum[1]))
dw_publish_chart("Ty61K")

dw_edit_chart("OmzDG",intro=paste0("In Svizzera fino a questo momento sono state effettuate <b>",impfungen_anteil_ch,"</b> iniezioni ogni 100 abitanti. In cifre assolute, si tratta di <b>",impfungen_ch,"</b> vaccinazioni. Per und protezione vaccinale ottimale, due dosi sone necessaire."), annotate=paste0("Stato: ",impfdaten_dw$Datum[1]))
dw_publish_chart("OmzDG")
