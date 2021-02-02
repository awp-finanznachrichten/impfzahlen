#Get CSV link
link <- webpage %>%
  html_nodes(xpath = "//li/a") %>%
  html_attr("href")

link <- paste0("https://www.covid19.admin.ch",link[21])

#Download Data from CSV
temp <- tempfile()
download.file(link,temp)
data_geliefert <- read.csv(unz(temp,"data/COVID19VaccDosesDelivered.csv"))
data_verimpft <- read.csv(unz(temp,"data/COVID19VaccDosesAdministered.csv"))

unlink(temp)

data_geliefert$date <- as.Date(data_geliefert$date)
data_verimpft$date <- as.Date(data_verimpft$date)

data_geliefert <- data_geliefert[data_geliefert$date == date_geliefert,]
data_verimpft <- data_verimpft[data_verimpft$date == date_verabreicht,]

data_geliefert <- data_geliefert[c(1,4:29,3),]
data_verimpft <- data_verimpft[c(1,4:29,3),]

#Datenbank-Zugriff
mydb <- dbConnect(MySQL(), user='awp', password='rs71MR3!', dbname='covid', host='32863.hostserv.eu', encoding="utf8")

#Daten in Datenbank einlesen - Gelieferte Impfdosen

ID <- paste0(format(date_verabreicht,"%Y%m%d"),"_a")
datum <- date_verabreicht
Typ <- "Gelieferte Impfdosen"

sql_qry <- "INSERT IGNORE INTO impfungen(ID,datum,Typ,CH,GE,VD,VS,FR,NE,JU,BE,SO,BS,BL,AG,ZH,SH,TG,AR,AI,SG,GL,SZ,ZG,LU,NW,OW,UR,GR,TI,FL) VALUES"
sql_qry <- paste0(sql_qry, paste(sprintf("('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
                                         '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
                                         '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
                                         '%s')",
                                         ID,datum,Typ,
                                         data_geliefert$sumTotal[1],data_geliefert$sumTotal[2],data_geliefert$sumTotal[3],data_geliefert$sumTotal[4],data_geliefert$sumTotal[5],
                                         data_geliefert$sumTotal[6],data_geliefert$sumTotal[7],data_geliefert$sumTotal[8],data_geliefert$sumTotal[9],data_geliefert$sumTotal[10],
                                         data_geliefert$sumTotal[11],data_geliefert$sumTotal[12],data_geliefert$sumTotal[13],data_geliefert$sumTotal[14],data_geliefert$sumTotal[15],
                                         data_geliefert$sumTotal[16],data_geliefert$sumTotal[17],data_geliefert$sumTotal[18],data_geliefert$sumTotal[19],data_geliefert$sumTotal[20],
                                         data_geliefert$sumTotal[21],data_geliefert$sumTotal[22],data_geliefert$sumTotal[23],data_geliefert$sumTotal[24],data_geliefert$sumTotal[25],
                                         data_geliefert$sumTotal[26],data_geliefert$sumTotal[27],data_geliefert$sumTotal[28]
                                     
                                         ), collapse = ","))
dbGetQuery(mydb, "SET NAMES 'utf8'")
rs <- dbSendQuery(mydb, sql_qry)

#Daten in Datenbank einlesen - Verimpfte Impfdosen

ID <- paste0(format(date_verabreicht,"%Y%m%d"),"_b")
datum <- date_verabreicht
Typ <- "Bislang total verimpft"

sql_qry <- "INSERT IGNORE INTO impfungen(ID,datum,Typ,CH,GE,VD,VS,FR,NE,JU,BE,SO,BS,BL,AG,ZH,SH,TG,AR,AI,SG,GL,SZ,ZG,LU,NW,OW,UR,GR,TI,FL) VALUES"
sql_qry <- paste0(sql_qry, paste(sprintf("('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
                                         '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
                                         '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
                                         '%s')",
                                         ID,datum,Typ,
                                         data_verimpft$sumTotal[1],data_verimpft$sumTotal[2],data_verimpft$sumTotal[3],data_verimpft$sumTotal[4],data_verimpft$sumTotal[5],
                                         data_verimpft$sumTotal[6],data_verimpft$sumTotal[7],data_verimpft$sumTotal[8],data_verimpft$sumTotal[9],data_verimpft$sumTotal[10],
                                         data_verimpft$sumTotal[11],data_verimpft$sumTotal[12],data_verimpft$sumTotal[13],data_verimpft$sumTotal[14],data_verimpft$sumTotal[15],
                                         data_verimpft$sumTotal[16],data_verimpft$sumTotal[17],data_verimpft$sumTotal[18],data_verimpft$sumTotal[19],data_verimpft$sumTotal[20],
                                         data_verimpft$sumTotal[21],data_verimpft$sumTotal[22],data_verimpft$sumTotal[23],data_verimpft$sumTotal[24],data_verimpft$sumTotal[25],
                                         data_verimpft$sumTotal[26],data_verimpft$sumTotal[27],data_verimpft$sumTotal[28]
                                         
), collapse = ","))
dbGetQuery(mydb, "SET NAMES 'utf8'")
rs <- dbSendQuery(mydb, sql_qry)

#Daten in Datenbank einlesen - Anteil pro 100 Einwohner

ID <- paste0(format(date_verabreicht,"%Y%m%d"),"_c")
datum <- date_verabreicht
Typ <- "Geimpfte Dosen pro 100 Einwohner"

sql_qry <- "INSERT IGNORE INTO impfungen(ID,datum,Typ,CH,GE,VD,VS,FR,NE,JU,BE,SO,BS,BL,AG,ZH,SH,TG,AR,AI,SG,GL,SZ,ZG,LU,NW,OW,UR,GR,TI,FL) VALUES"
sql_qry <- paste0(sql_qry, paste(sprintf("('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
                                         '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
                                         '%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',
                                         '%s')",
                                         ID,datum,Typ,
                                         data_verimpft$per100PersonsTotal[1],data_verimpft$per100PersonsTotal[2],data_verimpft$per100PersonsTotal[3],data_verimpft$per100PersonsTotal[4],data_verimpft$per100PersonsTotal[5],
                                         data_verimpft$per100PersonsTotal[6],data_verimpft$per100PersonsTotal[7],data_verimpft$per100PersonsTotal[8],data_verimpft$per100PersonsTotal[9],data_verimpft$per100PersonsTotal[10],
                                         data_verimpft$per100PersonsTotal[11],data_verimpft$per100PersonsTotal[12],data_verimpft$per100PersonsTotal[13],data_verimpft$per100PersonsTotal[14],data_verimpft$per100PersonsTotal[15],
                                         data_verimpft$per100PersonsTotal[16],data_verimpft$per100PersonsTotal[17],data_verimpft$per100PersonsTotal[18],data_verimpft$per100PersonsTotal[19],data_verimpft$per100PersonsTotal[20],
                                         data_verimpft$per100PersonsTotal[21],data_verimpft$per100PersonsTotal[22],data_verimpft$per100PersonsTotal[23],data_verimpft$per100PersonsTotal[24],data_verimpft$per100PersonsTotal[25],
                                         data_verimpft$per100PersonsTotal[26],data_verimpft$per100PersonsTotal[27],data_verimpft$per100PersonsTotal[28]
                                         
), collapse = ","))
dbGetQuery(mydb, "SET NAMES 'utf8'")
rs <- dbSendQuery(mydb, sql_qry)

dbDisconnectAll()


