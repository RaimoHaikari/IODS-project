# Raimo HAikari
# 08.11.2018
# R script to execute Data wrangling part of week 2 assignment

rm(list=ls())

# Read the needed packages
library(dplyr)
#library(ggplot2)
#library(GGally)

# PART 2
# - Read the data
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# - Get overaook of the data
dim(lrn14)
str(lrn14)

# There are:
# - 60 variables
# Variables consists of:
# - first 56 variables have a range of 1 ... 5
# - three discrete numeric variables: Age, Attitude and Points
# - gender variable


# PART 3
# - extract final dataset

# - combine questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

surf_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surf_columns)

stra_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(stra_columns)

# - define attributes to keep
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

# - select data
lrn14 <- lrn14 %>%
  filter(Points > 0) %>%
  select(keep_columns)

# PART 4
# - save data

# i don't wan't to mess with working directory, so i choose to use full filename
fileName = "data/learning2014.csv"

write.table(lrn14, file = fileName, sep = ",", col.names = NA)
# wooohooo!!!!