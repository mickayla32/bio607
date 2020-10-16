#######################
#
# LAB 2020-10-02
#
# Loading Data
#
#######################

#### Navigating out filesystem with R ####

# where does r think it is looking for files?
getwd()

# what files?
list.files()

# what is in "data"
list.files("data")

#### Read in file ####
sheet1<- read.csv("data/test_data_sheet_3.csv")

#what is here
names(sheet1)

str(sheet1)

summary(sheet1)

# Make an NA
sheet1[2,2] <- NA

# Looking at our data at scale
library(visdat)
vis_dat(sheet1)

# skimming your data
library(skimr)
skim(sheet1)

# Loading data the new school way
library(readr)

sheet2 <- read_csv("data/test_data_sheet_2.csv")

# To clean names
install.packages("janitor")
library(janitor)

sheet2 <- sheet2 %>% 
  clean_names()

names(sheet2)

# Reading from excel or other things
library(readxl)

sheet1_xl <- read_excel("data/test_data.xlsx",
                        sheet = "Sheet1") %>%
  janitor::clean_names()

sheet1_xl

