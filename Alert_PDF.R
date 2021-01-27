library(rvest)

url <- "https://www.bag.admin.ch/bag/de/home/krankheiten/ausbrueche-epidemien-pandemien/aktuelle-ausbrueche-epidemien/novel-cov/situation-schweiz-und-international.html"

webpage <- read_html(url)

daten <- as.data.frame(html_text(html_nodes(webpage,"a")))

daten$check <- grepl("Zahlen zur Covid-19-Impfung: Stand",daten$`html_text(html_nodes(webpage, "a"))`)

datum <- daten[daten$check == TRUE,1]
datum <- gsub(".*,","",datum)
datum
datum <- trimws(gsub(")","",datum))
datum <- as.Date(datum,format="%d.%m.%Y")
