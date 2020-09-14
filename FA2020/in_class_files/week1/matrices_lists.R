#### -------------------------- ####
#
# @title Matrices, lists, and more!
# 
# @author Mickayla Johnston
# @date 2020-09-11
#### -------------------------- ####

my_vec <- 1:50

my_matrix <- matrix(my_vec, ncol = 10)
my_matrix

# default
matrix(my_vec, ncol = 10, byrow = FALSE)

# as opposed to (??)
matrix(my_vec, ncol = 10, byrow = TRUE)

#### ROWS = [1,] ####
  # Comma second
#### COLUMNS = [,1] ####
  # Comma first

# Use [] since we're subsetting
my_matrix[2,2]

# Indices

  # 2nd row
my_matrix[2,]

  # 2nd column
my_matrix[,2]

  #### matrix[row,column] ####

#### Explore the matrix ####
str(my_matrix)
  # class integer
  # 5 rows, 10 columns

summary(my_matrix)
  # independent summary for each column

length(my_matrix)
  # length of vector

#### Matrix-specific functions ####
dim(my_matrix)
  # 5x10 matrix

nrow(my_matrix)
  # number of rows

ncol(my_matrix)
  # number of columns

#### Exercise ####
# Create 10x10 matrix of random uniform numbers between 5 and 50
  # Need to use runif with the matrix function, to put the random numbers in a matrix
exercise_matrix <- matrix(runif(n = 100, min = 5, max = 50))

# get the row and column means (rowMeans() and colMeans()). 
rowMeans(exercise_matrix)
colMeans(exercise_matrix)

# What’s the output of str()? 
str(exercise_matrix)


#### LISTS ####

my_list <- list(first = 1:10,
                second = letters[10:25])
my_list

# What's in the list?
str(my_list)

names(my_list)

my_list$first
my_list[first] # doesn't work
my_list["first"] # does work!

# To get a VECTOR back:
my_list[["first"]]
class(my_list[["first"]])

# If you don't know names:

  # gives a list:
my_list[1]
  # gives a vector:
my_list[[1]]

#### EXERCISE ####
# Create a list consisting of a vector of numbers, an NA, and a list which contains two vectors. 
third_list <- list(10:20, 30:40)
exercise_list <- list(numbers = 1:10,
                      na = NA,
                      twovecs = third_list)

# Take a look at their second elements. What is there? 
exercise_list$numbers
exercise_list$na
exercise_list$twovecs

# Give 2 vectors (because of double [])
exercise_list[["twovecs"]]

# Also, check out our old friends str and summary
str(exercise_list$numbers)
str(exercise_list$na)
str(exercise_list$twovecs)

summary(exercise_list$numbers)
summary(exercise_list$na)
summary(exercise_list$twovecs)

# nested and mixed lists
big_list <- list(first = 1:10,
                 second = NA,
                 third = list(a = letters[1:5],
                              b = LETTERS[1:5]))

#### Dataframes ####

View(my_matrix)
View(big_list)

data("mtcars")
str(mtcars)

mtcars[1,5] # [row,column]

mtcars[1, "drat"]
names(mtcars)

# rows 3:10 of columns mpg & wt
mtcars[3:10, c("mpg", "wt")]

# Mean of every column
colMeans(mtcars)

