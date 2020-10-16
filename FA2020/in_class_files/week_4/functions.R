###############
# FUNCTIONS
#
# 2020-09-29
#
###############


#### General setup of a function ####
my_cool_function <- function(arguments) {
  
  something_to_give_back <- do_things(arguments)
  
  return(something_to_give_back)
  
}

# Example
add_one <- function(x){
  
  ret_value <- x + 1

  return(ret_value)  
}

# Try it
add_one(3)

# Another example:
square_root <- function(x) {
  
  # create something
  ret_value <- sqrt(x)
  
  # return it
  return(ret_value)
  
}

# Try it
square_root(16)

# Example:
max_minus_min <- function(vec) {
  
  ret_value <- max(vec) - min(vec)
  
  return(ret_value)
  
}

# Try it:
max_minus_min(c(4,7,1,6,8))

# Functions can take many arguments
# Functions can have default values

add_values <- function(x, y = 0) {
  return(x+y)
  
}

# "..." to pass many other arguments

make_mean <- function(a_vector, ...) {
  
  sum_vector <- sum(a_vector, ...)
  
  n <- length(a_vector)
  
  return(sum_vector/n)
}

make_mean(c(4,5,6), na.rm = TRUE)


#### EXERCISE ####

#1. Takes a vector and sums it up after it squares it
  # use c(4,5,6)... to test (=77)

sum_sq <- function(vec) {
  
  squared_vec <- (vec)^2
  
  sum_vec <- sum(squared_vec)
  
  return(sum_vec)
}

sum_sq(c(4,5,6))

#2. Takes a number and combines it into a string with the word "elephants", using paste()

elephants_string <- function(x) {
  
  number_elephants <- paste(x, "elephants", sep = " ")
  
  return(number_elephants)
}

elephants_string(1)
elephants_string(10)

#3. Takes a number, a string, and a separator and combines them

num_string_sep_fun <- function(x, y, z) {
  
  paste(x,y, sep = z)
  
}

num_string_sep_fun(3, "hello", "-")


# EC. Write a function that takes a sample size, mean, SD, 
  # and number of sims, and returns a data frame with a mean and SE of said mean. 
  # Have it default to 100 sims.

mean_and_se_sim <- function(n, m, s, sims = 100){
  
  # Generate simulated samples from a population
  samps <- replicate(sims, rnorm(n = n, mean = m ,s =s))
  
  
  # Take the means of those samples
  
  means <- colMeans(samps)
  
  # Calculate the mean of the means, and the sd of the means
  
  out <- data.frame(mean = mean(means), 
                    se_mean = sd(means))
  
  # Return that 
  
  return(out)
}

mean_and_se_sim(n = 50, m = 25, s = 2)

################
sim_fun <- function(ss, mean, sd, sims) {
  
  samp <- rnorm(40, mean = mean, sd = sd)
  
  df <- data.frame(samp_sizes = ss) %>%
    # For each sample size,
    rowwise(samp_sizes) %>%
    # replicate 
    summarize(df = replicate(100,
                                    sample(samp,
                                           size = samp_sizes,
                                           replace = TRUE) %>%
                                      # & get the mean
                                      mean() %>%
                             sd())) 
  
  return(df)
  
}

sim_fun(ss= 100, mean = 3, sd = 2)


##############################
# 2020-10-01
#
# More about functions
#
##############################

# Look at this function again:
mean_and_se_sim <- function(n, m, s, sims = 100){
  
  # Generate simulated samples from a population
  samps <- replicate(sims, rnorm(n = n, mean = m ,s =s))
  
  
  # Take the means of those samples
  
  means <- colMeans(samps)
  
  # Calculate the mean of the means, and the sd of the means
  
  out <- data.frame(mean = mean(means), 
                    se_mean = sd(means))
  
  # Return that 
  
  return(out)
}

# Modular programming:

# Get_samp_rep gives a sample mean everytime you run it
get_samp_rep <- function(n,m,s){
  # Sample from a normal population
  samp <- rnorm(n,m,s)
  
  # Return the mean from that sample
  mean(samp)
}

# Ex

# Old function, updated
means_and_se_sim <- function(n,m,s, sims = 100){
  
  means <- replicate(sims, get_samp_rep(n,m,s))
  
  out <- data.frame(mean = mean(means),
                    se_mean = sd(means))
  
  return(out)
  
}

# Or... more modular
  # Wrapper function to get mean and SE of the estimate of the mean, 
  # based on repeated draws from a normal population
means_and_se_sim <- function(n,m,s, sims = 100){
  # Draw sim number of means from a sampled poplation
  means <- get_sim_means(n,m,s, sims = sims)
  
  # Make a DF from those simulations, with the mean and SE
  out <- make_mean_se_data_frame(means)
  
  # Return it
  return(out)
  
}

#### Write get_sim_means function-- gets simulated means
get_sim_means <- function(n,m,s, sims = 100){
  #repeat some number of times
  out <- replicate (sims,
                    # drawing means from simulations
                    get_mean_from_one_sim)
  
  return(out)
}

#### get_mean_from_one_sim -- gets mean of ONE simulation

get_mean_from_one_sim <- function(n,m,s) {
  # get one sample draw
  samp <- rnorm(n,m,s)
  
  # calculate a mean and return it
  out <- mean(samp)
  
  # Return
  return(out)
}

#### Write make_mean_se_data_frame function
make_mean_se_data_frame <- function(sim_means){
  # calculate the mean of my sims
  m <- mean(sim_means)
  
  # caluclate the SE of my simulations
  se_mean <-sd(sim_means)
  
  # return the mean and SE in a single DF
  return(data.frame(mean = m,
                    se_mean = se_mean))
}


#######################
# FINAL EXERCISES
# 1. Write a function that will get the mean, sd, median, and IQR of a sample of a population.

get_samp_rep <- function(n, mean, sd){
  samp <- rnorm(n, mean, sd)
  mean(samp)
  sd(samp)
  IQR(samp)
  median(samp)
}

stats_sim <- function(n, mean, sd, sims = 1000){
  
  stats <- replicate(sims, get_samp_rep(n, mean, sd))
  
  out <- data.frame(mean = mean(stats),
                    median = median(stats),
                    sd = sd(stats),
                    iqr = IQR(stats),
                    se = sd(stats)/sqrt(n))
  
  return(out)
}

# 2. Write a function that uses this to get 1K resampled values to get the statistic and its SE.
data.frame(sims = 1:10) %>%  
  rowwise() %>%  
  summarize(stats_sim(3,5,10)) %>%



# 3. Wrap it all in dplyr magick to get these statistics for sample sizes 3:5, means 2:5, and sd 1:3. 
  # Use tidyr::crossing to make the initial data frame.

  # Out
  map_df(1:10, ~stats_sim(3:5,2:5,1:3))



# EC. Use ggplot2 to look at how the SE of these different statistics changes based on population mean, sample size, and SD