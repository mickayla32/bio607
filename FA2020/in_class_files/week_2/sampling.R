################################
#
# SAMPLING NOTES-- week 2
#
# 2020-09-15
#
################################

# Stratified sampling
  # Sample over a gradient
  # aka cluster sampling
  # Potential problems:
    ##1. Total dist. of population may not be even- bias from where the cluster is placed
    ##2. How many samples per strata?
      ## Only if we are interested in variation WITHIN a strata
        ## Think about a more NESTED sampling design
      ## Strata are not just spatial
    ##3. Many types of gradients
    ##4. Many types of gradients AT ONCE
      ## Gradients are not linear and smooth?

    ## TWO MAIN ISSUES:
      # 1. There are many strata- both known and unknown
        # Make sure we are evenly sampling across the pop, even if there are gradients we don't know about
      # 2. Possible variation within a strata might be large

#### Statified or Random?
  # How is your pop defined?
    # Large or small
  # What is your scale of inference?
  # What might influence the inclusio of a replicate?
  # How important are external factors? Things that create graients

#### Stratified Random Sampling
  ## Create strata, and randomly sample within each strata

#### EXERCISE ####
# 1. What is a population you sample?
# 2. How do you ensure validity, reliability, and representatieness of a sample?

##### Describing a sample ####

# 1. Visualize our sample as counts or frequencies-- histogram
  # FREQUENCY = percent of sample with that value
    # Probability of drawing that value from a sample
    # Also called probability density- sums to 1
# 2. Median, what are large and small values like, is our sample clustered? spread out?

# The empirical cumulative dist. plot
  # x- size of different samples
  # each dot represents 1 sample
  # y = cumulative frequency

# Boxplot (box and whisker plot)

  ## Both emp. cum. & boxplot show
    # Median
    # 1st and 3rd quartiles = 25th and 75th percentiles
    # Whiskers- 

# Assuming our sample is representative of the population
# Mean-- the expected value (x bar) (of our SAMPLE)
  # Estimator of "mew" (u)-- the average value of the POPULATION

# How variable is a population?
  # Standard Deviaton-- based on the "variance"
  # sigma squared if describing POPULATION
  # s2 if describing SAMPLE (variance) --> square root of s2 is s.d
  # Why n-1? --> we've used 1 degree of freedom when we calculate our mean
              # --> we use some information when we calculate a quantity
              # --> n-1 "unbiases" our estimate

################################
#
# 2020-09-17
#
# Sampling continued
#
################################

## Our sample should be reliable, valid, and representative of our pop.
  # Want to estimate population parameters
  # We assume there is a distrubution of values in a population-- some set of deterministic & stochastic factors

#### PROBAILITY DISTRIBUTIONS ####
  ## S.D is one way of describing the variability

  ## Some probabilty of getting a given value ***

  ## All prob. dist. are goverened by certain PARAMETERS
      ## We want to estimate those parameters (by taking a sample of the population)
        ## Then relate the parameters back to the BIOLOGY OF OUR SYSTEM
  
# continuous = prob density
# discrete = prob. mass

#### The Normal (Gaussian) Distribution ####

# Arises from some deterministic value & very small additive deviations
# Very common

# As you accumulate many small random distributions, you produce a normal dist.

# The "Random Walk"
# Most values will be near 0

## NORMAL DISTRIBUTIONS:
# Defined by 2 parameters- mean and standard deviation
# 2/3 of data is within 1 SD of the mean
# Values are peaked without skew (skewness = 0)
# Tails are neither too thin, nor too fat (kurtosis = 0)

# variance = sum(x - xbar)^2/(n-1) 
# skew = sum(x - xbar)^3/(n-1) ??

### What does it mean if the data doesn't follow normal distribution?
  ### Other data or error generating processes you aren't considering - THAT'S BIOLOGY!

# Why are most values at 0? Can it be another value other than 0 in nature?
  # Standard Normal is N(0,1): mean = 0, SD = 1

#### WHAT SHOULD MY SAMPLE SIZE BE ####

# What if we could pretend to sample?
  # Assume the dist. of pop
  # Draw simulated sample...


# low sample size --> low precision in estimate  
# increase in precision at higher and higher sample sizes

# How do we calculate the precision level/ a good sample size in nature? Like how do we know the mean and s.d of a natural population?

# Standard error: SD of an estimated parameter if we were able to sample it repeatedly
  # We often want a SE that is less than 2*(the mean)
#### Central Limit Theorem: the dist of means of a sufficiently large sample size will be approx. normal ####
  # Even if the population dist. is not normal, when estimating it using a sample of the pop.,
    # it will be a normal dist.
    ## i.e. the means will be normal

#### simulated mean = one simulated mean is the mean of one simulated sample draw


#### BOOTSTRAPPING ####
# We can resample our sample some # of times with replacement
    # This is called bootstrapping
    # One replicate simjulation is one *bootstrap*
  # Repeat this resampling of our sample 1000s of times to get a "bootstrap sample"

# ex) sample(firefly$flash.ms, size = nrow(firefly), replace= TRUE)

# We can calc the SD of a sample stat using replicate bootstrap samples
  # This is called the bootstrapped SE of the estimate

# SE of the mean = sd of your sample / the square root of your sample size