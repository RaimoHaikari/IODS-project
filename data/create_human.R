# Raimo Haikari
# Fri 23.11.2018

# Script that prepares Human development and Gender inequality dataset for further analysis.
# Descriptions of datasets:
# http://hdr.undp.org/en/content/human-development-index-hdi
# http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf

# Clear memory
rm(list=ls())

# Load packages
library(dplyr)

# read files
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# dplyr -packages glimpse -method gives general overvies of dataset
glimpse(hd)

glimpse(gii)

# Renaming variables:
#
# hd
# hdi_rank = HDI.Rank                              
# country = Country
# hdi = Human.Development.Index..HDI.
# span_of_life = Life.Expectancy.at.Birth
# education_child = Expected.Years.of.Education
# education_adults = Mean.Years.of.Education            
# gni = Gross.National.Income..GNI..per.Capita
# gni_rank = GNI.per.Capita.Rank.Minus.HDI.Rank 
colnames(hd) <- c("hdi_rank",
                  "country",
                  "hdi",
                  "span_of_life",
                  "education_child",
                  "education_adults",
                  "gni",
                  "gni_rank")

# gii
# gii_rank = GII.Rank
# country = Country
# gii_index = Gender.Inequality.Index..GII.
# maternal_mortality = Maternal.Mortality.Ratio
# youth_mother = Adolescent.Birth.Rate
# parliament_each = Percent.Representation.in.Parliament
# education_female = Population.with.Secondary.Education..Female.
# education_male = Population.with.Secondary.Education..Male.
# work_female = Labour.Force.Participation.Rate..Female.
# workmale = Labour.Force.Participation.Rate..Male.
colnames(gii) = c("gii_rank",
                  "country",
                  "gii_index", 
                  "maternal_mortality", 
                  "youth_mother", 
                  "parliament_each", 
                  "education_female", 
                  "education_male", 
                  "work_female", 
                  "work_male")

# Adding variables for:
# - ratio of Female and Male populations with secondary education
# - ratio of labour force participation of females and males
gii <- gii %>%
  mutate(education_ratio = education_female / education_male) %>%
  mutate(work_ratio = work_female / work_male)

human <- inner_join(hd, gii, by = ("country"), suffix = c(".hd", ".gii"))

# Save the new data.frame
fileName = "data/human.csv"
write.csv(file=fileName, x=human, row.names = FALSE)

# clear memory and check that human data.frame can be read
rm(list=ls())

fileName = "data/human.csv"
human <- read.csv(fileName)
dim(human) # seems to be ok
