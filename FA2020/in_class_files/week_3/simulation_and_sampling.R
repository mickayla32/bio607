################################
#
# Simulation and Sampling
# HOW BIG SHOULD MY SAMPLE SIZE BE?
#
# 2020-09-22
#
################################

# Libraries
library(dplyr)
library(purrr)


# Random number generation
  # different ones for each prob dist.

#### Normal Population ####
# rnorm = random normal numbers
rnorm(n=5, mean = 3, sd = 2)
hist(rnorm(n=1000, mean = 3, sd = 2))

# these are actually "pseudo-random"
  # let's show this:
  # the number that starts with is the "seed"

# If you keep running this, it will produce the same numbers
set.seed(607)
rnorm(5, mean = 3, sd = 2)

  # set.seed allows reproducibility of randomness

#### Binomial Dist-- flipping a coin ####
# How many heads to we get if we flip an unbiased coin 10 times
# repeat 10 flips 1 time
rbinom(n= 1, prob= 0.5, size = 10 )

# repeat 10 flips 100 times
rbinom(n=100, prob = 0.5, size = 10)

#### equal probability of any number in a range ####
runif(n = 50, min = -5, max = 5)

# random whole numbers
runif(10, min = 0, max = 10) %>%
  round()


#### If we make assumptions about a population, then let's sample ####
# make choices based on something that is biologically plausible
  # plausible ranges/ averages to use during a simulation

#### Start by making some assumptions

# Mean of pop
mean_pop <- 45
sd_pop <- 15

# Let's set up our simulation
# We want to test what sample size we need!!!! ***

samp_sim <- data.frame(samp_size = 3:50)

# NOW we need to do some simulations

  # If we just wanted ranom draws:
rnorm(3:50, mean_pop, sd_pop)

  # If we wanted to do random draws with the data
samp_sim_one_replicate <- samp_sim %>%
  rowwise(samp_size) %>% # groups by row number -- good for iterating over multiple params
  summarize(samp = rnorm(samp_size, mean = mean_pop, sd = sd_pop))

# Simulated data at different sample sizes: ****
head(samp_sim_one_replicate)

plot(samp ~ samp_size, data = samp_sim_one_replicate)

# What if we want to estimate the mean** at each sample size, a huge number of times
samp_sim_means <- samp_sim %>%
  rowwise(samp_size) %>% # groups by row number (which is sample size?)-- good for iterating over multiple params
  summarize(samp_mean =  replicate(1000,
              rnorm(samp_size, 
                    mean = mean_pop, 
                    sd = sd_pop) %>%
              mean()))

# Convergence of sample mean as sample size increases!!! ***
plot(samp_mean ~ samp_size, data = samp_sim_means)

# The comment-first approach to simulation:

# Assume some population parameters
# Create a data frame with a variety of plausible sample sizes/ properties
# For each sample size (set of params)...
# Replicate calculating estimated paramets from a random draw, some number of times

#### Let's get simulated mean and SDs to examine sample size

# Assume some population parameters
mean_pop <- 45
sd_pop <- 15

# Create a data frame with a variety of plausible sample sizes/ properties
sim_results <- data.frame(samp_size = 3:30) %>%
  # For each sample size (set of params)...
  rowwise(samp_size) %>%
  
  # Replicate calculating estimated parameters
  # from a random draw, 
  # some number of times
  summarize(samp_mean = replicate(100, 
                                  mean(rnorm(n= samp_size, mean = mean_pop, sd = sd_pop))),
            samp_sd = replicate(100,
            sd(rnorm(n = samp_size, mean = mean_pop, sd = sd_pop))))


# I replicated 100 simuations twice...
# What if I only did it once, and made a DF for each simulation
# Create a df with a variety of plausible sample sizes/properties
sim_results <- data.frame(samp_size = 3:30) %>%
  # For each sample size (set of params)...
  rowwise(samp_size) %>%
  
  # Replicate calculating estimated parameters
  # from a random draw
  # some # of times (100 times)
  summarize(map_df(1:100,
                   ~data.frame(sim = .x,
                               samp_mean = mean(rnorm(samp_size, mean_pop, sd_pop)),
                               samp_sd = sd(rnorm(samp_size, mean_pop, sd_pop)))))


#### FADED EXAMPLES ###

#Some preperatory material
set.seed(42)
mean_pop <- 10
sd_pop <- 3
nsim <- 100
sampSim <- data.frame(samp_size = 3:50)

# Mean simulations
sampSim %>%
  rowwise(samp_size) %>% 
  summarize(samp_mean =
              replicate(nsim,
                        rnorm(samp_size, mean_pop, sd_pop) %>%
                          mean()))

# Median simulations

median_sims <- samp_sim %>%
  rowwise(samp_size) %>% 
  summarize(samp_median =
              replicate(nsim,
                        rnorm(samp_size, mean_pop, sd_pop) %>%
                          median()))

plot(samp_median ~ samp_size, data = median_sims)

# IQR sim
iqr_sims <- samp_sim %>%
  rowwise(samp_size) %>%
  summarize(samp_iqr =
              replicate(nsim,
                        rnorm(samp_size, mean_pop, sd_pop) %>%
                          IQR()))

plot(samp_iqr ~ samp_size, data = iqr_sims)


# Sample and sift
sim_results_common_sim <- samp_sim %>%
  rowwise(samp_sim) %>%
  summarize(map_df(1:50,
                   ~data.frame(sim = .x,
                               sample_values = rnorm(samp_size,
                                                     mean_pop,
                                                     sd_pop)))) %>%
  group_by(samp_size, sim) %>%
  summarize(mean_samp = mean(sample_values),
            sd_samp = sd(sample_values),
            median_samp = median(sample_values))

str(samp_size)
