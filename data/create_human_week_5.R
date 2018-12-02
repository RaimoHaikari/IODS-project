# Raimo Haikari
# Sun 2.12.2018

# Script that prepares Human development and Gender inequality dataset for further analysis.
# Descriptions of datasets:
# http://hdr.undp.org/en/content/human-development-index-hdi
# http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf

# Clear memory
rm(list = ls())


# Load packages
library(dplyr)
library(stringr)


# read file
linkToData <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt"
human <- read.csv(linkToData, stringsAsFactors = F)

# Various ratio variables, where proportion of participation between females and males are summarised.
# e.g Edu2.FM percentage of girls get educated is divided by percentage of boys get educated.

# Dataset has 195 observations of 19 variables
dim(human)
str(human)

# transform the Gross National Income (GNI) variable to numeric (Using string manipulation
human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric()

# exclude unneeded variables
toKeep = c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")

human <- human %>%
  select(toKeep)

# Remove all rows with missing values (1 point)
human <- human[complete.cases(human),]

# Remove the observations which relate to regions instead of countries. 
# - seem to be the last 7 observations
regions <- c("Arab States",
             "East Asia and the Pacific",
             "Europe and Central Asia",
             "Latin America and the Caribbean",
             "South Asia",
             "Sub-Saharan Africa",
             "World")

human <- human %>%
  filter(!(Country %in% regions))

# convert content of country-variable to rownames and remove column
row.names(human) <- human$Country
human$Country <- NULL

# Save 
write.csv(file="data/human.csv", x=human, row.names = TRUE)

# Read and confirm that content is what it is supposed to be...
rm(list=ls())
human <- read.csv("data/human.csv",row.names = 1) # 1st column contains rownames...
dim(human) # seems to be ouklidoukli
