# Load required packages
library(dplyr)
library(tidyr)

# clear memory
rm(list=ls())

# Read files:
bprsFile = "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt"
ratsFile = "https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt"

bprsRaw <- read.csv(bprsFile, sep  =" ", header = T, stringsAsFactors = F)
ratsRaw <- read.csv(ratsFile, sep  ="\t", header = T, stringsAsFactors = F)

# Overview of datasets
# BPRS
# - 40 Observations
# - 11 variables
# - treatment and subject identify patients and which group one belongs
#   Now integer, but should be converted to factor
# - 8 week colums, dedicated to weekly measurements
glimpse(bprsRaw)

# Rattus rattus
# - 16 Observations
# - 13 variables
# - ID and Group identify patients and which group one belongs
#   Now integer, but should be converted to factor
# - 11 columns dedicated to weight measurements
#   Number part of column name tells the day when measures were made
#   e.g WD1 weight in day 1, WD8 weight in day 8...
glimpse(ratsRaw)

# Rats are divided into 3 groups. 
# A thing to notice is that there are different amounts of rats in those groubs!
# i.e G1 has 8 rats, but G2 and G3 have 4 rats each
ratsRaw %>%
  group_by(Group) %>%
  summarise(n = n())

# Let's convert indentifying variables to factors
bprsRaw$treatment <- factor(bprsRaw$treatment)
bprsRaw$subject <- factor(bprsRaw$subject)

ratsRaw$ID <- factor(ratsRaw$ID)
ratsRaw$Group <- factor(ratsRaw$Group)

# By utilising mighty gather() -function we can convert wide dataform to long!
bprs <- bprsRaw %>% 
  gather(key = weeks, value = bprs, -treatment, -subject)

rats <- ratsRaw %>%
  gather(key = WD, value = Weight, -ID, -Group)

# extract week- and day numbers 
bprs$week <- sapply(bprs$weeks, function(x){as.integer(substring(x,5))})
rats$Time <- sapply(rats$WD, function(x){as.integer(substring(x,3))})

# Glimpse of the converted datasets
# - In the beginning we had variables for each measurement cycle, 
#   that is e.g in rats WD1, WD8 and so on
# - After modification
#   variables have been converted to observations
#   In rats that means that for each rat there are rows for Weight in day 1, Weight in day 8
glimpse(rats)
glimpse(bprs)

# save results
write.csv(file="data/rats.csv", x=rats, row.names = FALSE)
write.csv(file="data/bprs.csv", x=bprs, row.names = FALSE)

rm(list=ls())
rats <- read.csv("data/rats.csv") 
bprs <- read.csv("data/bprs.csv") # 1st column contains rownames...
