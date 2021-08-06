# Load the libraries we'll need
library(tidyverse)

# Load our data
data <- read_csv("walkin_clinic.csv") 

# Let's have a peak at the data
# To view, click on the little spreadsheet on the RHS of data in the environment tab
view(data)
head(data)
str(data)
glimpse(data) # data is a tibble - an R equivalent of a spreadsheet

## What types of data do we encounter in R?

# Most common - numeric
class(data$Temp)
# used for discrete and continuous data

# Integer - used for discrete integer data
data <- data %>% 
  mutate(Temp = as.integer(Temp))
class(data$Temp)

# Character data (or strings) - contain text
class(data$Name)
data$Name

# Factor is a special case of a character variable
# It contains text, but there is a limited number of unique strings
# Often used for categorical data

data$Gender
data <- data %>% 
  mutate(Gender = factor(Gender))
class(data$Gender)
str(data$Gender)
data$Gender

# When dealing with ordinal categorical data, we can use ordered factors

data$Age
data <- data %>% 
  mutate(Age = factor(Age, levels = c("less than 21", "21-65", "greater than 65"), ordered = TRUE))

# We also can have logical data - only assuming the values "True" or "False"
data$Drove
data <- data %>% 
  mutate(Drove = as.logical(Drove))

# Let's save this version of our data
write_csv(data, "walkin_clinic_clean.csv")
