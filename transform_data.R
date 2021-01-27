library(git2r)
library(dplyr)
library(readxl)
library(DBI)
library(RMySQL)
library(tidyr)
library(readr)

#Funktionen
dbDisconnectAll <- function(){
  ile <- length(dbListConnections(MySQL())  )
  lapply( dbListConnections(MySQL()), function(x) dbDisconnect(x) )
  cat(sprintf("%s connection(s) closed.\n", ile))
}

gitcommit <- function(msg = "commit from Rstudio", dir = getwd()){
  cmd = sprintf("git commit -m\"%s\"",msg)
  system(cmd)
}

gitstatus <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git status"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}

gitadd <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git add --all"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}

gitpush <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git push"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}

setwd("C:/Users/simon/OneDrive/R/impfzahlen")

#Impfdaten abrufen
mydb <- dbConnect(MySQL(), user='awp', password='rs71MR3!', dbname='covid', host='32863.hostserv.eu')
rs <- dbSendQuery(mydb, "SELECT * FROM impfungen")
impfdaten <- DBI::fetch(rs,n=-1)

dbDisconnectAll()

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
long_verimpft_last_week <- long[long$Typ == "Bislang total verimpft" & long$datum == last_date-3,] #7
long_verimpft_second_last_week <- long[long$Typ == "Bislang total verimpft" & long$datum == last_date-3,] #14
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
impfdaten_dw$Verimpft <- format(impfdaten_dw$Verimpft,big.mark = "'")
impfdaten_dw$Verimpft_pro_Tag <- format(round(impfdaten_dw$Verimpft_pro_Tag,0),big.mark = "'")
impfdaten_dw$Verimpft_pro_Tag_Vorwoche <- format(round(impfdaten_dw$Verimpft_pro_Tag_Vorwoche,0),big.mark = "'")
impfdaten_dw$Veraenderung <- round(impfdaten_dw$Veraenderung,0)
impfdaten_dw$Geliefert <- format(impfdaten_dw$Geliefert,big.mark = "'")
impfdaten_dw$Verimpft_Anteil <- round(impfdaten_dw$Verimpft_Anteil,0)

#Merge mit Kantonsnamen
impfdaten_dw <- merge(impfdaten_dw,kantone)

#Create_Text
impfdaten_dw$Text_d <- paste0("Im Kanton ",impfdaten_dw$Kanton_d," wurden bislang por 100 Einwohner <b>",
                              impfdaten_dw$Verimpft_pro_Person,"</b> Impfungen durchgeführt.",
                              " Das entspricht <b>",impfdaten_dw$Verimpft,"</b> Impfungen.<br><br>",
                              "In der vergangenen Woche wurden pro Tag durchschnittlich <b>",impfdaten_dw$Verimpft_pro_Tag,
                              "</b> Personen geimpft. Im Vergleich zur Vorwoche eintspricht dies einer Veränderung von <b>",
                              impfdaten_dw$Veraenderung,"%</b>.<br><br>",
                              "Insgesamt wurden in den Kanton ",impfdaten_dw$Kanton_d," bislang <b>",impfdaten_dw$Geliefert,
                              "</b> Impfdosen geliefert. Davon wurden bereits <b>",impfdaten_dw$Verimpft_Anteil,"%</b> verimpft.<br><br>",
                              "<i>Stand: ",impfdaten_dw$Datum,"</i>")


#Write File
write.csv(impfdaten_dw,"Output/impfdaten.csv", row.names=FALSE)
                           
#Make Commit
git2r::config(user.name = "awp-finanznachrichten",user.email = "sw@awp.ch")
gitadd()
gitcommit()
gitpush()
