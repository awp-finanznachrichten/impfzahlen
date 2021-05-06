#Bild speichern
library(magick)

#Als JPEG
map <- dw_export_chart("pyMze", scale=4,plain=FALSE, border_width=10, width=400, height=910)
image_write(map,path="./SDA_Grafik/preview.jpeg",format="jpeg")

#Als EPS
map <- dw_export_chart("pyMze", scale=4,plain=FALSE, border_width=60, width=400, height=910)
image_write(map,path="./SDA_Grafik/Impfungen.eps",format="eps")

#Metadata
metadata <- paste0("i5_object_name=GRAFIK COVID-19-Impfungen in der Schweiz\n",
                   "i55_date_created=",format(Sys.Date(),"%Y%m%d"),"\n",
                   "i120_caption= Geimpfte Dosen pro 100 Einwohner, bislang total verimpfte Dosen (920 X 1940 Pixel hoch) vom ",format(Sys.Date(),"%d.%m.%Y"),"\n",
                   "i103_original_transmission_reference=\n",
                   "i90_city=\n",
                   "i100_country_code= CHE\n",
                   "i15_category= N\n",
                   "i105_headline= Corona, Covid-19, Impfungen, Impfen, Medizin, Gesundheit\n",
                   "i40_special_instructions=\n",
                   "i110_credit=KEYSTONE\n",
                   "i115_source=KEYSTONE\n",
                   "i80_byline= AWP Finanznachrichten\n",
                   "i122_writer= AWP\n")

cat(metadata,file="./SDA_Grafik/metadata.properties")

#Zip-File
library(zip)
zip::zip(zipfile = 'SDA_Grafik/Impfungen_DEU.zip', c("SDA_Grafik/Impfungen.eps","SDA_Grafik/preview.jpeg","SDA_Grafik/metadata.properties"), mode="cherry-pick")

#Make Commit
git2r::config(user.name = "awp-finanznachrichten",user.email = "sw@awp.ch")
gitadd()
gitcommit()
gitpush()