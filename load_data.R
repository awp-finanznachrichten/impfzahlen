#Impfdaten abrufen
mydb <- dbConnect(MySQL(), user='awp', password='rs71MR3!', dbname='covid', host='32863.hostserv.eu')
rs <- dbSendQuery(mydb, "SELECT * FROM impfungen")
impfdaten <- DBI::fetch(rs,n=-1)

dbDisconnectAll()