# Raimo Haikari
# wed 14.10.2018

# Script that prepares Student Performance Data Set for further analysis.
# Link to dataset: https://archive.ics.uci.edu/ml/datasets/Student+Performance

rm(list=ls())

# Load the reequired packages
library(dplyr)

# Read the datafiles
math.Filename = "data/student-mat.csv"
math <- read.csv(math.Filename, stringsAsFactors = T, sep=";")

por.Filename = "data/student-por.csv"
por <- read.csv(por.Filename, stringsAsFactors = T, sep=";")

# Peek at the content of data:
# - math
dim(math) # 33 variables 395 observations
glimpse(math)

# - por
dim(por)  # 33 variables 649 observations
glimpse(por)

# define columns that are used in id's when combining datasets
join_by <- c("school","sex","age","address","famsize","Pstatus", "Medu", "Fedu", "Mjob", "Fjob","reason", "nursery","internet")

# combined set should consist student's that are in both disticnt dataset so we use dlpyr:inner_join
alc <- inner_join(math, por, by = join_by,suffix = c(".math",".por"))

# Peek at the content of combined dataset:
dim(alc) # 53 variables 382 observations

glimpse(alc)

# combine the "duplicated answers"
dublicates <- colnames(math)[!(colnames(math) %in% join_by)]

for(d in dublicates){
  d_cols <- select(alc, starts_with(d))
  first_column <- select(d_cols, 1)[[1]]
  
  if(is.numeric(first_column)){
    alc[d] <- round(rowMeans(d_cols)) # take a rounded average of each row of the two columns
  } else {
    alc[d] <- first_column            # add the first column vector to the alc data frame
  }
  
  alc[,colnames(d_cols)] <- NULL      # We can remove dublicate columns
}

# Peek at the content of combined dataset. New columns can be seen at the end of listing...
glimpse(alc)

# Add two new columns:
# - alc_use for average use
# - high_use TRUE/FALSE if person uses more than 2 times a week
alc <- alc %>%
  mutate(alc_use = (Dalc + Walc) / 2) %>%
  mutate(high_use = ifelse(alc_use > 2, TRUE, FALSE)) 

# Save the modified data
fileName = "data/alc.csv"

write.table(alc, file = fileName, sep = ";", col.names = NA)
