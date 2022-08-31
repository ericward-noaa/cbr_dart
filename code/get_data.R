library(dplyr)
library(tidyr)
library(lubridate)

update_historic <- FALSE
if(update_historic == TRUE) {
  start_year <- 1938
  end_year <- lubridate::year(Sys.Date()) - 1
  for(y in start_year:end_year) {
    url <- paste0("https://www.cbr.washington.edu/dart/cs/php/rpt/mg.php?sc=1&mgconfig=adult&outputFormat=csvSingle&year%5B%5D=",y,"&loc%5B%5D=BON&ftype%5B%5D=fc&ftype%5B%5D=fcj&ftype%5B%5D=fk&ftype%5B%5D=fkj&ftype%5B%5D=fb&ftype%5B%5D=fs&ftype%5B%5D=fsw&data%5B%5D=&data%5B%5D=&startdate=1%2F1&enddate=12%2F31")
    data <- read.csv(url)
    if(y==start_year) {
      dat <- data
    } else {
      dat <- rbind(data, dat)
    }
  }
  saveRDS(dat, "data/bonneville_counts.rds")
}

dat <- readRDS("data/bonneville_counts.rds")

# add update data from current year
this_year <- lubridate::year(Sys.Date())
url <- paste0("https://www.cbr.washington.edu/dart/cs/php/rpt/mg.php?sc=1&mgconfig=adult&outputFormat=csvSingle&year%5B%5D=",this_year,"&loc%5B%5D=BON&ftype%5B%5D=fc&ftype%5B%5D=fcj&ftype%5B%5D=fk&ftype%5B%5D=fkj&ftype%5B%5D=fb&ftype%5B%5D=fs&ftype%5B%5D=fsw&data%5B%5D=&data%5B%5D=&startdate=1%2F1&enddate=12%2F31")
update <- read.csv(url)
update$latitude <- 45.644336 
update$longitude <- -121.940851

dat <- rbind(dat, update)
# remove duplicates
dat <- dat[which(duplicated(dat)==FALSE), ]

# add lat / lon
dat$latitude <- 45.644336 
dat$longitude <- -121.940851

saveRDS(dat, "data/bonneville_counts.rds")
  