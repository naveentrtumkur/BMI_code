####################################################################
## Data for in-class practice
## BMI 5759
## Summer 2018
####################################################################

## The 'cardio_labs.csv' file contains some laboratory values on
## general internal medicine patients who are considered to be at
## high risk for cardiovascular disease

## Read in the data using the 'read.csv' function.  You can call it
##  something simple like 'data' or 'cardio.data'
data <- read.csv("cardio_labs.csv", header = TRUE)

## Use 'head' to look at the first few observations of the data
head(data)

## Use 'names' to see just the variable (column) names
names(data)

## Use 'dim' to see the dimension (number of columns (variables) and rows (subjects))
##  of the data
dim(data)


## I don't like dealing with CAPS or '_' in variable names, so use the following to change
##  the variable names to lowercase and replace the '_' with a '.' (where 'data' is the name for
##  whatever you called the data set in R)
names(data) <- tolower(names(data))
names(data) <- gsub("_", ".", names(data))
names(data)

## Use 'str' to look at the structure of the data.  What class (numeric, character, factor)
##  was used for the cholesterol and BMI variables?  Is that surprising to you?
str(data)


## We don't want to have a non-numeric class for cholesterol data, so try forcing the 'cholesterol'
##  variable to be numeric using 'as.numeric'.  Call this something different like 'data$cholesterol2'
##  to avoid overwriting the original 'cholesterol' value (we'll use both in the exercise). Use 'str'
##  and 'head' to check your result
data$cholesterol2 <- as.numeric(data$cholesterol)
str(data)
head(data)

## If you just used 'as.numeric(data$cholesterol)' you get a strange result that doesn't match the
## original cholesterol values.  This is because 'cholesterol' was stored as a factor, and what
## you are converting to numeric are the integer levels used to represent the factor levels.
## Instead, try using 'as.numeric(as.character(data$cholesterol))' to see if that works
data$cholesterol2 <- as.numeric(as.character(data$cholesterol))
str(data)
head(data)

## Use 'sum' and 'is.na' together to check how many missing values there are in 'cholesterol2'
sum(is.na(data$cholesterol2))

## There are quite a few missing values now in cholesterol.  Let's see what values these correspond
##  to in the original 'cholesterol' variable.  First, use 'is.na' and 'which' (which is optional) to
##  create an index of which subjects have missing cholesterol values
idx <- which(is.na(data$cholesterol2))

## Then, use 'unique' to look at the unique values of the original 'cholesterol' variable corresponding
##  to this index. What are these values?  Does it seem reasonable to set these to missing?
unique(data$cholesterol[idx])


## Now, let's repeat this exercise with the 'bmi' variable
data$bmi2 <- as.numeric(as.character(data$bmi))
str(data)
head(data)
sum(is.na(data$bmi2))
idx <- which(is.na(data$bmi2))
unique(data$bmi[idx])
## hmm, also not bad ...

## Any others that are bad?

## The above exercise seems to suggest that "--" and "Sent to main lab" can be regarded as
##   missing values when reading in the data.  Try re-reading in the data but this time use
##   the 'na.strings' argument set to the above two values.  Use 'str' to look at the data
##   again and see if it looks more reasonable.
na.strings <- c("--", "Sent to main lab")
data <- read.csv("cardio_labs.csv", header = TRUE, na.strings = na.strings)
names(data) <- tolower(names(data))
names(data) <- gsub("_", ".", names(data))
names(data)
str(data)

## The 'ldl.chol.calc' variable is still being read in as a factor.  Let's repeat the
##  steps we used for 'bmi' and 'cholesterol' previously to convert this to a numeric
##  variable and see what values are converted to missing
data$ldl.chol.calc2 <- as.numeric(as.character(data$ldl.chol.calc))
sum(is.na(data$ldl.chol.calc2))
idx <- which(is.na(data$ldl.chol.calc2))
unique(data$ldl.chol.calc[idx])


## The additional values are 'NEG 12', 'NEG 19', and 'NEG 3'.  We can add these to the vector of
##  values for 'na.strings' if we want and re-read in the data, which should then read 'ldl.chol.cal'
##  as numeric (you can skip this step)


## Use the 'summary' command on the numeric 'ldl.chol.calc2' variable you just created to see
##  summary characteristics of its distribution in this sample
summary(data$ldl.chol.calc2)  ## some seem a little suspicious

## Use the 'cut' command to create a factor for LDL cholesterol based on the cut-points defined
##  by the National Heart, Lung, and Blood Institute (NHLBI):

## LDL Cholesterol Level   LDL-Cholesterol Category
## Less than 100 mg/dL 	   Optimal
## 100-129 mg/dL           Near optimal/above optimal
## 130-159 mg/dL           Borderline high
## 160-189 mg/dL           High
## 190 mg/dL and above 	   Very high

## Be sure to put '0' as the intial value for the cutpoint and a value above 406 (the max value in
##  the data set) as the last (highest) value.  Check to make sure you have the same number of NAs
##  as in the numeric version using the 'sum' and 'is.na' command (you can also just use 'summary'
##  instead)
data$ldl.chol.calc.fac <- cut(data$ldl.chol.calc2, breaks = c(0, 100, 130, 160, 190, 410),
                              right = FALSE)
sum(is.na(data$ldl.chol.calc.fac))
summary(data$ldl.chol.calc.fac)

## Check your result using the 'table' command and also the 'prop.table' command.  What
##  proportion of subjects are in each of the categories defined by the NHLBI?
(tab <- table(data$ldl.chol.calc.fac))
round(prop.table(tab), 2)


## These aren't bad (I think), only 5% in the 'high' and above category ...



