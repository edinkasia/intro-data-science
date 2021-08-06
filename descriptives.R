library(tidyverse)
library(janitor)
library(NHSRdatasets)

# Let's read in our walk in clinic data and explore it a bit
clinic_data <- read_csv("walkin_clinic_clean.csv") %>% 
  mutate(Gender = factor(Gender),
         Age = factor(Age, levels = c("less than 21", "21-65", "greater than 65"), ordered = TRUE))

# For simple statistics, you can use base R functions
mean(clinic_data$Temp)

# We can use tidyverse functions to see statistics by group
# The resulting object is a tibble
summary_table <- clinic_data %>% 
  group_by(Gender) %>% 
  summarise(mean_temp = mean(Temp), sd_temp = sd(Temp), n = n())

summary_table

# We can use the table function to look at cross-tabulations
table(clinic_data$Age, clinic_data$Gender)

# Function tabyl from janitor makes nice cross-tabulations, especially for Markdown reports
clinic_data %>% 
  tabyl(Age, Gender) %>% 
  knitr::kable()



# Let's have a look at the uptake of cervical screening in Scotland
# https://www.opendata.nhs.scot/dataset/scottish-cervical-screening-programme-statistics/resource/7191190e-2ebd-47e4-bbca-a1eb3182408a
# We'll need to load in data from the internet
cervical_data <- read_csv(file = "https://www.opendata.nhs.scot/dataset/874b6f70-8640-458a-81cb-83afde9ffd71/resource/7191190e-2ebd-47e4-bbca-a1eb3182408a/download/open-data-cervical-screening-uptake-201617-201819.csv")
glimpse(cervical_data)

# The healthboard codes are not easy to decipher, but luckily there is another dataset that explains them
HB_codes <- read_csv(file = "https://www.opendata.nhs.scot/dataset/9f942fdb-e59e-44f5-b534-d6e17229cc7b/resource/652ff726-e676-4a20-abda-435b98dd7bdc/download/hb14_hb19.csv") %>% 
  select(HB, HBName) %>% # selecting only the code and the name
  rename(HBR = HB) # renaming the code variable, so it matches the variable name in cervical_data

# We can use the join function to add the names of healthboards into our dataset
cervical_data_withHB <- HB_codes %>% 
  full_join(cervical_data, by = "HBR") 

# Columns AgeGroupQF and HBRQF indicate which rows contain aggregated data (with "d")- 
# Let's remove those rows (keeping only the rows with missing values)

cervical_data_withHB <- cervical_data_withHB %>% 
  filter(is.na(AgeGroupQF) & is.na(HBRQF)) %>% 
  mutate(HBName = factor(HBName))

table1 <- cervical_data_withHB %>% 
  group_by(HBName, FinancialYear) %>% 
  summarise(AverageUptake = mean(PercentageUptake))

# We get some unexpected NAs in this table - checking the original data shows empty rows
# We can remove them using the drop_na function

table1 <- cervical_data_withHB %>% 
  group_by(HBName, FinancialYear) %>% 
  summarise(AverageUptake = mean(PercentageUptake)) %>% 
  drop_na()
