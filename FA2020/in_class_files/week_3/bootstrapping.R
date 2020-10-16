#### Bootstrapping ####
  # Based on repeated draws from a SAMPLE, not from the population
  # As opposed to assuming we know the population params, then simulate sampling, run an analysis (calculate mean, sd), then from that, decide what sample size we should use (what we did last class)

# Libraries
library(dplyr)
library(purrr)

# Create the sample we are going to work with
set.seed(2020)
# Normally we would use a sample we got from the field, or a paper, etc.
samp <- rnorm(40, mean = 10, sd = 3)

# One bootstrap sample is a resampled set of values with the same n, sampled with replacement
one_boot <- sample(samp,
                   size = length(samp),
                   replace = TRUE) # sampling with replacement

# All values in our bootstrap are in the sample
one_boot %in% samp

##### bootstrapped medians ####

# 1000 times, sample from samp, and calculate a median
boot_med <- replicate(1000,
                      sample(samp, 
                             size = length(samp),
                             replace = TRUE)
                      %>% median())

length(boot_med)

# let's look at the distribution of medians
hist(boot_med)

# The SE of the median is the SD of these bootstraps
sd(boot_med)
# SE of the median : 0.4935869

# 2/3rds confidence interval is
mean(boot_med) + sd(boot_med) #11.18657
mean(boot_med) - sd(boot_med) #10.19939

# compare median of samp and boot_med
median(samp)
mean(boot_med)

#### SE of the mean
boot_mean <- replicate(1000,
                      sample(samp, 
                             size = length(samp),
                             replace = TRUE)
                      %>% mean())

# Compare SEs
sd(boot_mean)
sd(samp)/sqrt(length(samp))


# Paired programming
# First, make sure you feel comfortable calculating the bootstrapped SE of the IQR from samp. Repeat what we did above with IQR instead of median.
boot_iqr <- replicate(1000,
                      sample(samp, 
                             size = length(samp),
                             replace = TRUE)
                      %>% IQR())

# SE of iqr
sd(boot_iqr)/sqrt(length(boot_iqr))

# Now, write out in comments what you will do to end up with a data frame that has a column of sample sizes and a column of IQRs calculated from sampling our samp vector.
# Code it!

# Creating a dataframe of sample sizes
samp_iter <- data.frame(samp_size = 3:length(samp))

# Start with samp_iter, our sample sizes
boot_dif_sizes <- samp_iter %>%
  # Group by sample sizes
  rowwise(samp_size) %>%
  # making different columns-- 
  summarize(samp_iqr =
              replicate(1000,
                        sample(samp,
                               size = samp_size,
                               replace = TRUE) %>% IQR())) %>%
  group_by(samp_size) %>%
  mutate(mean_samp_iqr = mean(samp_iqr), se_samp_iqr = sd(samp_iqr)) %>%
  select(samp_size, mean_samp_iqr, se_samp_iqr) %>% 
  distinct()

## the way jarrett did it:
boot_iqr <- replicate(1000,
                      sample(samp,
                             size = length(samp),
                             replace = TRUE) %>% IQR)

sd(boot_iqr) # bootstrapped SE of the IQR
mean(boot_iqr)
IQR(samp)


# Start with a dataframe with a sample size column
boot_iqrs <- data.frame(samp_sizes = 10:20) %>%
# For each sample size,
rowwise(samp_sizes) %>%
# replicate 
summarize(boot_iqrs = replicate(1000,
                                # bootstrap draws
                                sample(samp,
                                       size = samp_sizes,
                                       replace = TRUE) %>%
                                # & get an IQR
                                IQR()))
# Now I have sample sizes and lots of IQRs
boot_se_iqr <- boot_iqrs %>%
  group_by(samp_sizes) %>%
  summarize(se_iqr = sd(boot_iqrs))


plot(se_iqr ~ samp_sizes, data = boot_se_iqr,
     type = "l")

#Now, write out in comments how you would go from that data frame to one that has the SE for the IQR at each sample size.

