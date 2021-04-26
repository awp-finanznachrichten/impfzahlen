library(lubridate)

setwd("C:/Automatisierungen/impfzahlen/")

#impfdaten_entwicklung abrufen
mydb <- dbConnect(MySQL(), user='awp', password='rs71MR3!', dbname='covid', host='32863.hostserv.eu')
rs <- dbSendQuery(mydb, "SELECT * FROM impfungen")
impfdaten_entwicklung <- DBI::fetch(rs,n=-1)

dbDisconnectAll()

#Filter
impfdaten_entwicklung <- impfdaten_entwicklung[impfdaten_entwicklung$Typ == "Bislang total verimpft",]
impfdaten_entwicklung$datum <- as.Date(impfdaten_entwicklung$datum)
impfdaten_entwicklung$weekday <- weekdays(impfdaten_entwicklung$datum)
impfdaten_entwicklung <- impfdaten_entwicklung[impfdaten_entwicklung$weekday == "Sunday",]
impfdaten_entwicklung <- impfdaten_entwicklung[,-c(1,3,ncol(impfdaten_entwicklung))]

for (c in 2:ncol(impfdaten_entwicklung)) {

  for (r in nrow(impfdaten_entwicklung):3 ) {
  
  impfdaten_entwicklung[r,c] <- impfdaten_entwicklung[r,c] - impfdaten_entwicklung[r-1,c]   #/7
  
  }  
  
}  

impfdaten_entwicklung <- impfdaten_entwicklung[-c(1:2),]

impfdaten_entwicklung$week <- paste0("KW ",isoweek(impfdaten_entwicklung$datum),"\n (",format(impfdaten_entwicklung$datum-6,"%d.%m"),"-",format(impfdaten_entwicklung$datum,"%d.%m"),")")
impfdaten_entwicklung$week_fr <- paste0(format(impfdaten_entwicklung$datum-6,"%d.%m"),"-",format(impfdaten_entwicklung$datum,"%d.%m"))

write.csv(impfdaten_entwicklung,"Output/chart_entwicklung_impfungen.csv",row.names = FALSE)

