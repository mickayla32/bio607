###############
#
# Linear regression lab 
#
# 2020-10-09
#
################

# FUNDAMENTAL STEPS OF EXECUTING LINEAR REGRESSION

#1. Load the data

#2. Visualize the data- just to detect problems and perform cursory test of assumptions

#3. Fit the model

#4. Use the fit model to test assumptions

#5. Evaluate the model

#6. Visualize the fit model 


#### Seal Model ####

# Libraries 
library(dplyr)
library(ggplot2)
library(tidyr)

#1. Load data
getwd()
seals <- read.csv("labs/data/17e8ShrinkingSeals Trites 1996.csv")

# What's here?
str(seals)
summary(seals)
skimr::skim(seals)


#2. Plot the data-- length and age
seal_plot <- ggplot(data = seals,
       mapping = aes(x = age.days, y = length.cm)) +
  geom_point(alpha = 0.5)

seal_plot

# 3. Fit the model

# y ~ x format
seal_lm <- lm(length.cm ~ age.days, 
              data = seals)

seal_lm

#4. Use the fit model to test assumptions

# Does the distribution of our predictions match our data?
# produce simulated values with some residual for every predicted value
  # simulate()

seal_sims <- simulate(seal_lm, nsim = 20) %>%
  pivot_longer(cols = everything(),
               names_to = "sim",
               values_to = "length.cm")

# Look at it
head(seal_sims)

# step 3 in notes on "evaluating fit linear models"-- does the model capture the features in the data?
  # i.e. does the model fit the data? Are there deviations?
  # Simulating implications from the model to see if we match the features in the data
  
  # Light lines are the simulations (from the model), blue line is the ACTUAL data
ggplot() +
  geom_density(data = seal_sims,
                    mapping = aes(x = length.cm, group = sim),
                    size = 0.2) +
         geom_density(data = seals,
                      mapping = aes(x = length.cm),
                      size = 2, color = "blue")

# Is there a relationship between fitted and residual values?
plot(seal_lm, which = 1) # RESIDUALS VS. FITTED
  # Random blob! (which is good... want no pattern (see step 6- equal variance of errors, in "fitting linear models" notes))

# Did we satisfy normality and homoskedacticity (variance is constant across entire model) using qq plot and levene test?
residuals(seal_lm) %>% # GIVES YOU ALL RESIDUAL VALUES
  
# then, get a histogram of it
hist()

# Or...
plot(seal_lm, which = 2) # Q-Q PLOT

# Also, 
residuals(seal_lm) %>% shapiro.test() # doesn't work with this cause the sample size is too big

# Look for outliers
plot(seal_lm, which = 4) # COOKS DISTANCE-- how far something is outside of the cloud of points (how much of an outlier a point it)
  # No values close to 1, so not a problem

# Also,
plot(seal_lm, which = 5) # RESIDUALS VS LEVERAGE (only if you're reallyyy worried)
  # Leverage-- outliers will get a lot of leverage (large influence), if they're way far out on the x-axis
    # this can effect the line that's fit

#### Side Note: Shapiro test tells you if its from a normal distribution (?)
  # Using a p-value

#5. Evaluate the model

# F-test
  # Two fundamental questions we want to ask of our models:
    # Did we explain any variation in the data other than noise?
    # Null hypothesis = our model should have just as much explanatory power
      # as the noise we observe -- var(model) / var(error) = f ratio

    # if we get a small probability value, we accept the null ^ ??????

# To do this, we run an ANOVA (analysis of variance)

anova(seal_lm)
  # f-value: ratio of variablilty explained by our model, divided by the variability explained by the error
  # small p-value means we can reject the null! ????? 

library(broom)

anova(seal_lm) %>%
  tidy()


# T-test of parameters
  # If we divide a parameter by its SE (precision), we get a t-value
  # We can use that to see if we can reject the hypothesis that our parameter = 0

summary(seal_lm)
# Coefficients:
#           Estimate    Std. Error t value Pr(>|t|)    
# (Intercept) 1.158e+02  1.764e-01  656.37   <2e-16 ***
#   age.days  *2.371e-03* 4.467e-05   53.06   <2e-16 ***
              # (SLOPE) ^
  # 1 unit change in days, resuts in 2.371e-03 increase in size (cm)

# Multiple R-squared:  0.2256
  # 0.2256 of variablilty in age is associated with variability in length (R2 value)

tidy(seal_lm)
  # estimate of age.days is the slope!

glance(seal_lm)
  # statistic is the f-statistic

# just the r2
summary(seal_lm)$r.squared

# coef table
summary(seal_lm)$coef

#6. Visualize the fit model 

# our data:
seal_plot

# add to this plot:
seal_plot + 
  stat_smooth(method = lm) # fit the linear model
  # Does show CI, just very narrow here!
    # Error around our fit (fit interval)

# Another way to see fit interval
predict.lm(seal_lm)
  # predictions based on model ^

fit_seals <- predict.lm(seal_lm, #se.fit = TRUE,
                        interval = "confidence")
names(fit_seals)
  # Gives us a fit and a SE of the fit

head(fit_seals)
  # lower and upper CI

# Used predict to get the fit CI
fit_seals <- predict.lm(seal_lm,
                        interval = "confidence") %>%
  # turned it into a df or tibble
as_tibble() %>%
  # renamed columns for clarity
  rename(lwr_ci = lwr,
         upr_ci = upr)

# combine them
seals <- cbind(seals, fit_seals)

head(seals)

# plot this (same as stat_smooth, without all the points)
ggplot(seals, 
       aes(x = age.days, 
           ymin = lwr_ci, ymax = upr_ci,
           y = fit)) +
  geom_ribbon() +
  geom_line(color = "blue") # essentially makes the same as stat_smooth()


# Prediction Interval:
predict_seals <- predict(seal_lm,
                         interval = "prediction") %>%
  as_tibble() %>%
  # rename columns for clarity
  rename(lwr_pi = lwr, # upper and lower prediction intervals
         upr_pi = upr)

head(predict_seals)
  # CI for new predictions is much wider-- takes into account residual error

# cbind again
seals <- cbind(seals, predict_seals) 

# clean the names to get rid of 2 fit columns-- makes the col names have _ instead of .
seals <- janitor::clean_names(seals)

names(seals)

# look at it
head(seals)

# Look at prediction interval
ggplot(seals,
       mapping = aes(x = age_days,
                     y = fit,
                     ymin = lwr_pi,
                     ymax = upr_pi)) +
  geom_ribbon(alpha = 0.3) + # prediction interval
  geom_line(color = "blue", size = 2) + # model fit
  geom_point(mapping = aes(y = length_cm)) # actual data points
# WIDE BAND = PREDICTION INTERVAL

# Let's visually compare the fit interval and prediction interval
  # fit int-- implications of driver in model
  # predition int. -- all about predicting new values

ggplot(data = seals,
       mapping = aes(x = age_days,
                     y = length_cm)) +
  # prediction intervals-- predicting new values--  if we picked a new value 95% of the time, it should fall in this range
  geom_ribbon(mapping = aes(ymin = lwr_pi,
                            ymax = upr_pi),
              alpha = 0.5) +
  # fit interval -- just coefficient error (precision)
  geom_ribbon(mapping = aes(ymin = lwr_ci,
                            ymax = upr_ci),
              color = "red",
              alpha = 0.5)

# Prediction interval in grey, confidence interval in red
  # prediction is wider bc its taking into account *residual* error of the model
    # about predicting new values
    # take into account residual sources of error (fancy E in the equation at the end)
  # fit interval is just the coefficient error / error in deterministic processes

# What we MIGHT observe-- prediction interval
# Observations -- fit interval

  # Again:
# A fit interval shows you the interval around your predicted relationship due to coefficient error/precicion
# A prediction interval shows you the interval where a new predicted value of Y could occur given a new value of X.

  #### NOTE: As  you move further down x axis (further from the mean), the interal gets wider


##### FADED EXAMPLES #####

fat <- read.csv("labs/data/17q04BodyFatHeatLoss Sloan and Keatinge 1973 replica.csv")

# initial viz to determine if lm is appropriate
fat_plot <- ggplot(data = fat,
                   mapping = aes(x = leanness,
                                 y = lossrate)) +
  geom_point()

# view it
fat_plot

# make model
fat_mod <- lm(lossrate ~ leanness, data = fat)

# assumptions
simulate(fat_mod, nsim = 100) %>%
  pivot_longer(cols = everything(),
               names_to = "sim",
               values_to = "lossrate") %>%
  # pipe right to ggplot
  ggplot(mapping = aes(x = lossrate)) +
  geom_density(mapping = aes(group = sim), lwd = 0.2) +
  geom_density(data = fat, color = "blue", lwd = 2)

plot(fat_mod, which = 1) #RESIDUALS VS. FITTED
plot(fat_mod, which = 2) # Q-Q PLOT

# f-tests of model
anova(fat_mod)
  # fvalue = 68.729

#t-tests of parameters
summary(fat_mod)

# plot with line
fat_plot +
  stat_smooth(method = lm, formula = y~x)

# Another faded example:

# Load data
deet <- read.csv("labs/data/17q24DEETMosquiteBites.csv")

# Plot it:
deet_plot <- ggplot(data = deet,
                    aes(x = dose, y = bites)) +
  geom_point()

deet_plot

# model:
deet_mod <- lm(bites ~ dose, data = deet)

# assumptions
simulate(deet_mod, nsim = 100) %>%
  pivot_longer(cols = everything(),
               names_to = "sim",
               values_to = "bites") %>%
  ggplot(aes(x = bites)) +
  geom_density(mapping = aes(group = sim), lwd = 0.2) +
  geom_density(data = deet, color = "blue", lwd = 2) # original data

plot(deet_mod, which = 1)
plot(deet_mod, which = 2)

# f-tests of model
anova(deet_mod)

# t-tests of parameters
summary(deet_mod)

# plot with line
deet_plot +
  stat_smooth(method = lm, formula = y~x)

# Another faded example:

zoo <- read.csv("labs/data/17q02ZooMortality Clubb and Mason 2003 replica.csv")

zoo_plot <- ggplot(data=zoo, aes(x=mortality, y=homerange)) + 
  geom_point()

zoo_plot

zoo_mod <- lm(homerange ~ mortality, data = zoo)

#assumptions
simulate(zoo_mod, nsim = 100) %>%
  pivot_longer(cols = everything(), 
      names_to = "sim", values_to = "homerange") %>%
  ggplot(aes(x = homerange)) +
  geom_density(aes(group = sim), lwd = 0.2) +
  geom_density(data = zoo, color = "blue", lwd = 2)

plot(zoo_mod, which=1)
plot(zoo_mod, which=2)

#f-tests of model
anova(zoo_mod)

#t-tests of parameters
summary(zoo_mod)

#plot with line
zoo_plot + 
  stat_smooth(method=lm, formula=y~x)
