setwd("C:/Automatisierungen/impfzahlen")

#Impfdaten abrufen
mydb <- dbConnect(MySQL(), user='awp', password='rs71MR3!', dbname='covid', host='32863.hostserv.eu')
rs <- dbSendQuery(mydb, "SELECT * FROM impfungen")
impfdaten <- DBI::fetch(rs,n=-1)

dbDisconnectAll()

###Prepare Data for Meldung

impfdaten_meldung <- impfdaten[,-1]

#Transform Data
long <- impfdaten_meldung %>%
  gather(area,value,-c(datum,Typ))

long$datum <- as.Date(long$datum)
last_date <- long$datum[nrow(long)]
last_date_string <- format(last_date,"%d.%m.%Y")

long_verimpft_aktuell <- long[long$Typ == "Bislang total verimpft" & long$datum == last_date,]
long_verimpft_last_week <- long[long$Typ == "Bislang total verimpft" & long$datum == last_date-7,]
long_verimpft_second_last_week <- long[long$Typ == "Bislang total verimpft" & long$datum == last_date-14,] #14
long_impfdosen <- long[long$Typ == "Gelieferte Impfdosen" & long$datum == last_date,]
long_verimpft_pro_person <- long[long$Typ == "Geimpfte Dosen pro 100 Einwohner" & long$datum == last_date,]
long_verimpft_pro_person_last_week <- long[long$Typ == "Geimpfte Dosen pro 100 Einwohner" & long$datum == last_date-7,]
long_verimpft_pro_person_second_last_week <- long[long$Typ == "Geimpfte Dosen pro 100 Einwohner" & long$datum == last_date-14,] #14

#Create Data Frame
impfdaten_meldung <- data.frame("Kanton_short","Datum",999,999,
                                999,999,999,999,999)

colnames(impfdaten_meldung) <- c("Kanton_Short","Datum","Verimpft","Verimpft_last_week","Verimpft_second_last_week",
                                 "Impfdosen","Verimpft_pro_person","Verimpft_pro_Person_last_week","Verimpft_pro_person_second_last_week")


for (i in 1:nrow(long_verimpft_aktuell)) {
  
  kanton_short <- long_verimpft_aktuell$area[i]
  verimpft <- long_verimpft_aktuell$value[i]
  verimpft_last_week <- long_verimpft_last_week$value[i]
  verimpft_second_last_week <- long_verimpft_second_last_week$value[i]
  geliefert <- long_impfdosen$value[i]
  verimpft_pro_person <- long_verimpft_pro_person$value[i]
  verimpft_pro_person_last_week <- long_verimpft_pro_person_last_week$value[i]
  verimpft_pro_person_second_last_week <- long_verimpft_pro_person_second_last_week$value[i]
  
  
  new_data <- data.frame(kanton_short,last_date_string,verimpft,verimpft_last_week,verimpft_second_last_week,
                         geliefert,
                         verimpft_pro_person,verimpft_pro_person_last_week,verimpft_pro_person_second_last_week)
  
  colnames(new_data) <- c("Kanton_Short","Datum","Verimpft","Verimpft_last_week","Verimpft_second_last_week",
                          "Impfdosen","Verimpft_pro_person","Verimpft_pro_Person_last_week","Verimpft_pro_person_second_last_week")
  
  
  impfdaten_meldung <- rbind(impfdaten_meldung,new_data)
  
}

impfdaten_meldung <- na.omit(impfdaten_meldung[-1,])

#Calculate needed variables
impfdaten_meldung$impfungen_last_week <- impfdaten_meldung$Verimpft-impfdaten_meldung$Verimpft_last_week
impfdaten_meldung$impfungen_second_last_week <- impfdaten_meldung$Verimpft_last_week-impfdaten_meldung$Verimpft_second_last_week
impfdaten_meldung$impfungen_change <- round((impfdaten_meldung$impfungen_last_week*100)/impfdaten_meldung$impfungen_second_last_week-100,0)

impfdaten_meldung$personen_last_week <- round(impfdaten_meldung$Verimpft_pro_person-impfdaten_meldung$Verimpft_pro_Person_last_week,1)
impfdaten_meldung$personen_second_last_week <- round(impfdaten_meldung$Verimpft_pro_Person_last_week-impfdaten_meldung$Verimpft_pro_person_second_last_week,1)
impfdaten_meldung$Verimpft_pro_person <- round(impfdaten_meldung$Verimpft_pro_person,1)

#Get Tendenz
if (impfdaten_meldung$impfungen_change[1] > 0) {
  
  tendenz <- paste0("stieg die Impfkadenz um ",impfdaten_meldung$impfungen_change[1]," Prozent.") 
  
} else if (impfdaten_meldung$impfungen_change[1] == 0) {
  
  tendenz <- paste0("hat sich die Impfkadenz nicht verändert.")   
  
} else {
  
  tendenz <- paste0("sank die Impfkadenz um ",impfdaten_meldung$impfungen_change[1]," Prozent.")
  
}    

#Adapt
impfdaten_meldung$Verimpft_pro_person <- format(impfdaten_meldung$Verimpft_pro_person, nsmall=1)
impfdaten_meldung$personen_last_week <- format(impfdaten_meldung$personen_last_week, nsmall=1)
impfdaten_meldung$personen_second_last_week <- format(impfdaten_meldung$personen_second_last_week, nsmall=1)


impfdaten_meldung$check_change <- impfdaten_meldung$impfungen_change > 500
impfdaten_meldung$check_change_2 <- impfdaten_meldung$impfungen_change < -500

for (i in 1:nrow(impfdaten_meldung)) {
  
  if (impfdaten_meldung$impfungen_change[i] > 0) {
    
    impfdaten_meldung$impfungen_change[i] <- paste0("+",impfdaten_meldung$impfungen_change[i])
  }
  
}  

for (i in 1:nrow(impfdaten_meldung)) {
  
  if (impfdaten_meldung$check_change[i] == TRUE) {
    
    impfdaten_meldung$impfungen_change[i] <- ">+500"
  }
  
}  

for (i in 1:nrow(impfdaten_meldung)) {
  
  if (impfdaten_meldung$check_change_2[i] == TRUE) {
    
    impfdaten_meldung$impfungen_change[i] <- "<-500"
  }
  
}  

impfdaten_meldung$char_count_change <- nchar(impfdaten_meldung$impfungen_change)

###Prepare Data for Datawrapper
impfungen_ch <- format(impfdaten[nrow(impfdaten)-1,4],big.mark = "'")
impfungen_anteil_ch <- round(impfdaten[nrow(impfdaten),4],1)
impfdaten_datawrapper <- impfdaten[,-c(1,4,31)]


#Kantonsnamen abrufen
kantone <- read_csv("Daten/MASTERFILE_GDE_NEW.csv")
kantone <- unique(kantone[,c(2,9:11)])

#Transform Data
long <- impfdaten_datawrapper %>%
  gather(area,value,-c(datum,Typ))

long$datum <- as.Date(long$datum)
last_date <- long$datum[nrow(long)]
last_date_string <- format(last_date,"%d.%m.%Y")

long_verimpft_aktuell <- long[long$Typ == "Bislang total verimpft" & long$datum == last_date,]
long_verimpft_last_week <- long[long$Typ == "Bislang total verimpft" & long$datum == last_date-7,]
long_verimpft_second_last_week <- long[long$Typ == "Bislang total verimpft" & long$datum == last_date-14,] #14
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
  verimpft_pro_tag_vorwoche <- (long_verimpft_last_week$value[i]-long_verimpft_second_last_week$value[i])/7 #7
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

#Adapt Veränderung
for (y in 1:nrow(impfdaten_dw)) {
  
if (impfdaten_dw$Veraenderung[y] > 500) {
  
  impfdaten_dw$Veraenderung[y] <- 500
} 

}


for (y in 1:nrow(impfdaten_dw)) {
  
  if (impfdaten_dw$Veraenderung[y] < -500) {
    
    impfdaten_dw$Veraenderung[y] <- -500
  } 
  
}


for (y in 1:nrow(impfdaten_dw)) {
  
if (impfdaten_dw$Veraenderung[y] > 0 ) {
  
  impfdaten_dw$Veraenderung[y] <- paste0("+",impfdaten_dw$Veraenderung[y])
}

}

impfdaten_dw$Veraenderung <- gsub("[+]500","mehr als +500",impfdaten_dw$Veraenderung)
impfdaten_dw$Veraenderung <- gsub("[-]500","weniger als -500",impfdaten_dw$Veraenderung)
