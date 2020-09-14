###########################
#' 2020_09_10_my_first_file.R
#' 
#' This script is my first R file
#' and it doesn't do much, but it's mine.
#'
#' @author Mickayla Johnston
#'
#' @changelog

###########################

# Square roots
sqrt(4)

# Logs
log10(10)

log(5)

# Natural log
??"log10"

log2(50)

#### Variables in r
pi

exp(1) #e

foo <- sqrt(2)

# Why no = ?
# 1. History
#2. Un-ambiguity
  # <- tells us whats being assigned to what
#3. Understand when we are using functions
  # = is reserved for use in specifying function args
# "option" + "-" is the shortcut for <- !

foo


# Variable naming
  # 1. Be meaningful
squareroot2 <- sqrt(2)

  # be short but meaningful
  # don't start with a number
  # use either snake or camel case
square_root_of_two <- sqrt(2) # snake case
squareRootOfTwo <- sqrt(2) # camel case

  # BE CONSISTENT! 

#### Classes of objects ####
class(squareroot2)

# Create text string
text_string <- "this is text"
class(text_string)
  # This is class "character"

# BOOLEANS- Trues and Falses
class(TRUE)
  # class "logical"

TRUE + 0
  # =1

# Is the square root of 2 equal to 1?
squareroot2 == 1
  # FALSE

# Is it less than 1?
squareroot2 < 1

# Missing values
  # NAs
  # Related special variables
    # NaN ("Not a number"...not missing like NA!)
    # Inf & -Inf

class(NaN)
  # class numeric

class(Inf)
  # class numeric

#### Exercise ####

#1. Make a variable
variable <- 2

#2. Make a variable out of some math equation
variable_equation <- variable + 2
variable_equation

# Try adding variables of different classes
text_string + variable

#### Vectors ####
  # "c" stands for concatenate
my_vec <- c(1,1,2,3,5,8)
my_vec

class(my_vec)
  # numeric
class(c("a", "b", "c"))
  # character

# Useful charcter vector
letters
LETTERS

# What is the 12th letter of the alphabet
letters[12]

# Range of values
1:10

# First 10 letters of alphabet
letters[1:10]

# letters of the alphabet corresponding to my_vec
letters[my_vec]

#### Exercise ####
# Make two vectors and add them together
vec_1 <- c(1,4,5,6,7)
vec_2 <- c(3,4,1,4,6)
vec_1 + vec_2

# Then try vectors of different object types
vec_1 + letters[1:5]

#### Sequences ####
seq(from= 1, to = 10, by = .1)

seq(from= 1, to = 10, length.out = 100)

# random numbers
runif(n = 100, min = 13.5, max = 200)
myunif <- runif(n = 100, min = 13.5, max = 200)

# Many functions work on vectors
sum(myunif)
mean(myunif)

#### str & summary ####
# What's in the object?

str(myunif)
# Gives you these, all in 1:
class(myunif)
length(myunif)
head(myunif)

# Sometimes problems are not obvious
na_vec <- c(1:100, NA, 10:100)

str(na_vec)
  # Doesn't show the NA!

summary(na_vec)
  # Tells you the number of NAs

#### Exercise ####
# Create a vector of any class. 
new_vec <- "This is a vector"
# str() and summarize() it. 
str(new_vec)
summary(new_vec)

# Now, create two vectors of different object types. 
letters_vec <- letters[c(1:5)]
numbers_vec <- c[1:5]

# Combine them. What do these two useful functions tell you what happened?
#   Write your answer below.
letters_vec + numbers_vec

#### DIFFERENCE BETWEEN [] AND () ####

letters[c(1:5)]

# if you switch them
letters(c[1:5])
  # gives you error

  # () are reserved for functions... letters is not a function

c[1:5]
  # gives error
  
  # [] are for things are can subset

# subsetting letters!
letters[1:5]

  # whereas c[1:5] isn't subsetting anything