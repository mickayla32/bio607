#### PRE-LAB: NOTES ON CONFIDENCE INTERVALS
# 2020-09-18

#### Standard error as a measure of confidence
  #### Did I precisely measure an estimate?

  # We have drawn our SE from a sample- not the population
  # Our estimate of +/- 1 SE tells us 2.3 of the estimates we could get by soley resampling this sample
    # BASED ON OUR SAMPLE - NOT ON THE POPULATION
    # This is not 2/3 of the possible TRUE PARAMETER VALUES-- 2/3 of the possible values we could of gotten from OUR SAMPLE
    # Rather, if we were to sample the population many many times, 2/3 of the time, this interval will contain the true value

# Confidence intervals -- precision of your ESTIMATE
  # 1 SE = 66% confidence interval
  # ~2 SE = 95% C.I

# Everytime you caclulate a C.I, some percentage of the time, your sample will contain the true value
  # If you run your experiment 1000s of times, 90% of the time your true value will be contained within the confidence interval
    # We are assuming a "true value" exists

  # Frequentist Philosophy
    # The ideal of drawing conclusions from data based on properties derived from THEORETICAL RESAMPLING
      # Assumes we can derive the truth by observing a result with some frequency in the long run
        

#### SD is a population parameter in and of itself
    ### should not change based on sample size

#### SE & CI are estimates of precision
  ### thus as you increase your sample size, they will shrink (because precision will increase)
    ### measures of your sample

#####################################################

##### SIMULATION, DPLYR, ETC.  ######

#####################################################

#### Pipes ####

vec <- 1:10

# Load magrittr library
library(magrittr)

1:10 %>% sum()

# Start with vec 1:10
1:10 %>%
  
# take its length
  length() %>%
  
# take the sqrt of the length 
  sqrt() %>%
  
# take the log
  log()

#### EXERCISE ####

#1. Use pipes to sum the log of 100:200
100:200 %>%
  log() %>%
  sum()

#2. Use pipes to take sqrt of the mean of 100 random unifom numbers
runif(100) %>%
  mean() %>%
  sqrt()

#3. Using mtcars df, get its summary, then str the summary
data("mtcars")

mtcars %>%
  summary() %>%
  str()

#### Base plot ####

vals <- runif(n = 1000, min = -10, max = 10)

#histogram
hist(vals, xlim = c(-20,20))

# scatter plot
my_df <- data.frame(x = 1:10, y = 1:10)

plot(y ~ x, data = my_df)

#### dplyr ####
library(dplyr)

# mutate
mtcars2 <- mutate(mtcars, log_mpg = log(mpg))

head(mtcars2)

# or...
mtcars2 <- mtcars %>%
  mutate(log_mpg = log(mpg),
         sqrt_cyl = sqrt(cyl))

# group_by
# I want to add a column that has the avg mpg for each # of gears

mtcars_group <- mtcars %>%
  group_by(gear) %>%
  mutate(avg_mpg = mean(mpg)) %>%
  ungroup()

View(mtcars_group)

# if we didn't group_by, then the avg_mpg column would be the same number over and over again.... it would calculate the avg mpg of the entire dataframe

# summarize
# we want to create a derived dataset
# want avg and sd of mpg by gear and ONLY THAT

mtcars_summary <- mtcars %>%
  group_by(gear) %>%
  summarize(avg_mpg = mean(mpg),
            sd_mpg = sd(mpg))

# filter
# remove all data where the # of cyl = 3
mtcars_filter <- mtcars %>%
  filter(cyl != 3)

# select
mtcars %>%
  select(mpg) %>%
  head()

# just a few columns
mtcars %>%
  select(gear, carb, disp) %>%
  head()

# all columns with an m in them
mtcars %>%
  select(contains("m")) %>%
  head()

#### Exercises ####

#1. Add some columns to mtcars to plot the log of mpg by the square root of hp
mtcars_ex <- mtcars %>%
  mutate(log_mpg = log(mpg), sqrt_hp = sqrt(hp)) 

head(mtcars_ex)

#plot(y ~ x, data = my_df)
plot(log_mpg ~ sqrt_hp, data = mtcars_ex)

#2. Get the avg hp per gear and plot them against each other
mtcars_ex <- mtcars %>%
  group_by(gear) %>%
  mutate(avg_hp_gear = mean(hp)) %>%
  ungroup()
  
plot(avg_hp_gear ~ gear, data=mtcars_ex)

#3. Make a df for only 6 cyl engines, with only the disp and carb columns
  # create a boxplot of how carb influences disp.

mtcars_ex_2 <- mtcars %>%
  filter(cyl == 6) %>%
  select(disp, carb)

head(mtcars_ex_2)

boxplot(disp ~ carb, data = mtcars_ex_2)

#### Simulation ####

# base::replicate()

# replicate summing the #s 1:10, 10 times
replicate(n = 10, sum(1:10))

# purr:map_dbl
library(purrr)

# map takes a list/vector as an input, then applies the function to every element of it

map_dbl(1:10, ~sum(1:100))

map_dbl(1:10, ~sum(1:.x))
#.x is a stand-in for 1:10
  # first .x is 1... sum 1:1
  # next, .x is 2... sum 1:2
# so .x is referring to that first arg

# x column is #s 1:10 (x = .x)
# y column is the sum of 1: 1:10 (?)
map_df(1:10, ~data.frame(x = .x,
                         y = sum(1:.x)))

#### Exercises ####
# 1. Use replicate() to repeatedly average the numbers 1:10 seven times.
# replicate(n = 10, sum(1:10))
replicate(n=7, mean(1:10))

#2. Do the same thing with map_dbl() - also what happens if you use other map functions?

# 1:7 specifies 7 times... mean(1:10) takes the mean of #s 1:10
# not using .x here... so the first argument is not a "list or vector"... 
  # it's just specifying that we're going to apply mean(1:10) 7 TIMES***
map_dbl(1:7, ~mean(1:10))  

# 3. Start with a vector:
  my_vec <- c(11, 10, 10, 9, 10, 11, 10, 9, 10, 
              12, 9, 11, 8, 11, 11, 10, 11, 10, 
              11, 9)

# Use map_df() to make a data frame that, for the numbers 3 through 15, returns two columns. 
  # One is the the average of the element of the vector 1 through the chosen number, the second is the standard deviation.
# e.g. 10.2 for a mean - but the 10 will be .x for you!

  # This takes the 3rd : 15th number is the vector my_vec, and uses those  
map_df(my_vec[3:15], ~data.frame(x = mean(1:.x),
                                   y = sd(1:.x)))

# whereas here, we're using .x, which is referencing the 3:15!! 
map_df(3:15, ~data.frame(m = mean(my_vec[1:.x]),
                         s = sd(my_vec[1:.x])))
