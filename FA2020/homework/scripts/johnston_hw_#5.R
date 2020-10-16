###################
# Homework Week 5: Correlation & Regression
#
# 2020-10-11
#
####################

# Libraries
library(dplyr)
library(ggplot2)


# Load data
getwd()
language <- read.csv("homework/data/week_5/chap16q15LanguageGreyMatter.csv")
liver <- read.csv("homework/data/week_5/chap16q19LiverPreparation.csv")
nutrients <- read.csv("homework/data/week_5/chap17q19GrasslandNutrientsPlantSpecies.csv")
beetles <- read.csv("homework/data/week_5/chap17q25BeetleWingsAndHorns.csv")
nuclear <- read.csv("homework/data/week_5/chap17q30NuclearTeeth.csv")

# See what's there
str(language)
skimr::skim(language)
summary(language)

# 1. Correlation: W&S ch.16

#1a. Display the association between the 2 variables in a scatterplot
language_plot <- ggplot(data = language,
                    mapping = aes(x = proficiency, y = greymatter)) +
  geom_point()

# view it
language_plot

#1b. Calculate the correlation between language proficiency and gray matter density
cor(language, method = "pearson")

# The correlation is 0.8183134

# 1c. Test the null hypothesis of zero correlation
# The null hypothesis is that there is no correlation between language proficiency and gray matter density
# The alternative hypothesis is that there is a correlation between language proficinecy and gray matter density


# Fit model
language_mod <- lm(greymatter ~ proficiency,
                   data = language)
  

# View model
summary(language_mod)

# anova
anova(language_mod)

# The t-value is -5.861, and the p-value of 3.264e-06 is less than 0.05, so we can reject the null hypothesis of zero correlation

# 1d. What are your assumptions?
# Assumptions of Pearson correlation:
# 1. The observations are from a random sample
# 2. Each observation is independent
# 3. x & y are from a normal distribution

# 1e. Does your scatter plot support these assumptions?
######## ******** #######

# 1f. Do the results indicate that language proficiency effects graymatter area in the brain? Why or why not?
  # Yes, the results support the hypothesis that language proficiency effects the amount of graymatter in the brain because
    # 1. from the scatter plot, we can see a pretty strong positive relationship between the two variables.
      # The plot shows that as proficiency increases, greymatter also increases.
      # And 2. The r value (Pearson's correlation coefficient), which ranges from -1 to 1 and indicates the strength of the association between two variables, is 0.818,
      # which means there is a pretty strong positive relationship. *********

# 2. Rat Liver Data:
str(liver)

# 2a. Calculate the correlation between the two variables
cor(liver, method = "pearson")
# The r value is -0.8563765

# 2b. Plot the relationship
liver_plot <- ggplot(data = liver,
mapping = aes(x = concentration, y = unboundFraction)) +
  geom_point()

# view it
liver_plot

# 2c. The relationship appears to be maximlly strong, yet the correlation coefficient is not near 
  # the maximum possible value. Why not?
# The plot appears to show a curve in the data-- so, the relationship is non-linear.

# 2d. What steps would you take to ensure the assumptions of the correlation analysis were met?
# Make sure that the sampling procedure involves true random sampling: every individual in the population has an equal chance of being sampled, 
  # and the sampling of each individual is independent from one another.
  # In the case of this experiment, one should ensure rats are chosen at random (ensuring the criteria listed above are met)
    # Each rat can be numbered, and then using a random number generator, rats can be selected for the experiment
  # Also, we can log-transform the data to make the shape of the relationship linear


# 3. Correlation SE
happy_cats <- data.frame(cats = c(-0.30	, 0.42, 0.85, -0.45	, 0.22, -0.12	, 1.46, -0.79, 0.40, -0.07),
                         happiness_score = c(-0.57, -0.10, -0.04, -0.29, 0.42, -0.92, 0.99, -0.62, 1.14, 0.33))

happy_cats

# 3a. Are these two variables correlated? What is the output of cor() here. What does a test show you?
cor(happy_cats)
#                 cats          happiness_score
# cats            1.0000000       0.6758738
# happiness_score 0.6758738       1.0000000

# The r value is 0.6758738, which doesn't indicate a very strong correlation

# 3b. What is the SE of the correlation based on the info from cor.test()
cor.test(happy_cats$cats, happy_cats$happiness_score)
# Jarrett's : (0.91578829 - 0.6758738 ) / 2

# Equation = squareroot of (1-r^2)/ (n-2)

# r^2
0.6758738^2
  # 0.4568054

# 1 - 0.4568054 = 0.5431946

# n-2 
length(happy_cats)
  # 10-2 = 8

sqrt((0.5431946) / 8)
  # 0.260575

#### ****** ####

# 3c. Now, what is the SE via simulation? To do this, you’ll need to use cor() 
  # and get the relevant parameter from the output (remember - you get a matrix back, so, what’s the right index!), 
  # replicate(), and sample() or dplyr::sample_n() with replace=TRUE to get, let’s say, 1000 correlations. 
  # How does this compare to your value above?
 ## [1] 0.1608964


# Test cor()[1,2]
cor(happy_cats)[1,2]

# cat_sim <- 
# # replicate
# replicate(1000,
#           # cor
#           cor(
#             # sample & correct index [1,2]
#             sample_n(happy_cats, nrow(happy_cats), replace=TRUE))[1,2])

cat_sim <- 
  # replicate
  replicate(1000,
            # cor
            cor(
              # sample & correct index [1,2]
              sample(happy_cats, 
                     size = length(happy_cats), 
                     replace=TRUE))[1,2])


# Get SE
sd(cat_sim)

#### ****** ##### How does this compare to answer from 3b

# 4. W&S Ch.17
str(nutrients)

#4a. Draw a scatter plot. What is the x variable and what is the y?
  # The x variable is nutrients, and the y is species

nutrients_plot <- ggplot(data = nutrients,
                         mapping = aes(x = nutrients, y = species)) +
  geom_point()


# view it
nutrients_plot

# 4b. What is the rate of change in the number of plant species supported per nutrient type added? 
  # Provide the SE for your estimate

# Fit model 
nutrients_mod <- lm(species ~ nutrients, data = nutrients)

# View it
summary(nutrients_mod)

# The slope is -3.339. This means that for every 1 nutrient added, ~3.3 species are lost.
# The SE is 1.098

# 4c. Add the least-squares regression line to your scatter plot. 
  # What fraction of the variation in the number of plant species is explained by the number of nutrients added?

nutrients_plot + stat_smooth(method = lm)

# 0.536 of the variation in the number of plant species is explained by the number of nutrients added (The R2 value)

# 4d. Test the null hypothesis of no treatment effect on the number of plant species
# t-value = -3.04 ****** Means??
# p-value = 0.0161, which means we can reject the null hypothesis that the addition of nutrients has no effect on the number os species 


# 5. W&S Chapter 17-25

#5a. Use these results to calculate the residuals

# Fit a model
beetle_mod <- lm(wingMass ~ hornSize, data = beetles)

# view model
beetle_mod

# Calculate resids
beetle_resids <- residuals(beetle_mod)

# View it
beetle_resids

# Make it a df
beetle_resids_df <- as.data.frame(beetle_resids)

# Combine it with beetles data
resid_plot_df <- cbind(beetles, beetle_resids_df)

# View it
resid_plot_df

#5b Use your results from part a to calculate a residuals plot 
ggplot(data = resid_plot_df, 
       mapping = aes(x = hornSize,
                     y = beetle_resids)) +
  geom_point()


# 5c. Use the graph provided and your residual plotto evaluate the main assumptions of linear regression.
# The results from the plot of residuals vs. horn size do not show any pattern.
# The scatter plot that was provided (wing mass vs. horn size) seems to fit a linear model well, but there are some deviations from the regrssion line, that may indicate that a non-linear model would be more appropriate.

# 5d. In light of your conclusions from part c, what steps should be taken?
# Other assumption tests can be explored (next question), and/or the data can be transformed and the model refit.
# A log transformation can get rid of the negative values in the data.

# 5e. Do any other diagnostics misbehave?
plot(beetle_mod, which = 1) # RESIDUALS VS. FITTED
# The residuals vs. fitted plot doesn't seem to be too bad, though the points do sort of fall along the horizontal line.
  # These points should be random- there should be no pattern, thus indicating the assumption of equal variance of errors is met

plot(beetle_mod, which = 2) # Q-Q PLOT
# The Q-Q plot seems ok as well- the points fall along the line for the most part, thus indicating the normality of errors assumption is met

plot(beetle_mod, which = 4)
# The Cook's distance plot has values close to 1, which can indicate a problem with outliers
# This is the minimal outlier influence assumption of linear models

plot(beetle_mod, which = 5) # RESIDUALS VS LEVERAGE
# The residuals vs. leverage plot shows that point 6 and 19 may be problem outliers, thus effecting the regression line that's fit to the model

# 6. W&S Ch. 17-30

# 6a. What is the approximate slope of the line?
# The slope looks to be close to -1

# 6b. Which pair of lines show the confidence bands? What do these confidence bands tell us?
# The narrower pair of dashed lines, closest to the solid regression line are the confidence bands
  # These show the precision and interval around the predicted relationship due to coefficient error/precision

# 6c Which pair of lines show the prediction interval? What do these tell us?
# The wider dashed lines, furthest from the solid regression line are the prediction interval bands.
  # These show us the interval where a new predicted value of Y could occur, given a new value of X.
  # i.e. what we MIGHT observe.
  # The prediction interval is wider bc its taking into account *residual* error of the model\

# 6d. Using `predict()` and `geom_ribbon()` in ggplot2, 
  # reproduce the above plot showing data, fit, fit interval, and prediction interval.

# Fit this model
nuclear_mod <- lm(dateOfBirth ~ deltaC14, data = nuclear)

# Regular fit plot

nuclear_plot <- ggplot(data = nuclear,
                       mapping = aes(x = deltaC14,
                                     y = dateOfBirth)) +
  geom_point()

# View it
nuclear_plot

# Add regression line
nuclear_plot + stat_smooth(method = lm)

# CI values
fit_nuclear <- predict.lm(nuclear_mod,
                        interval = "confidence") %>%
  # turned it into a df or tibble
  as_tibble() %>%
  # renamed columns for clarity
  rename(lwr_ci = lwr,
         upr_ci = upr)

# combine them
nuclear <- cbind(nuclear, fit_nuclear)

# Predicted values
predict_nuclear <- predict(nuclear_mod,
                         interval = "prediction") %>%
  as_tibble() %>%
  # rename columns for clarity
  rename(lwr_pi = lwr, # upper and lower prediction intervals
         upr_pi = upr)

# cbind again
nuclear <- cbind(nuclear, predict_nuclear) 

# view it
head(nuclear)

# clean the names to get rid of 2 fit columns-- makes the col names have _ instead of .
nuclear <- janitor::clean_names(nuclear)

names(nuclear)

# look at it
head(nuclear)

# Plot with data, fit, fit interval, and prediction interval
ggplot(data = nuclear,
       mapping = aes(x = delta_c14,
                     y = date_of_birth)) +
  # prediction intervals-- predicting new values--  if we picked a new value 95% of the time, it should fall in this range
  geom_ribbon(mapping = aes(ymin = lwr_pi,
                            ymax = upr_pi),
              alpha = 0.2) +
  # model fit
  geom_point(color = "black", size = 2) + 
  stat_smooth(method = lm) +
  # fit interval -- just coefficient error (precision)
  geom_ribbon(mapping = aes(ymin = lwr_ci,
                            ymax = upr_ci),
              color = "red",
              alpha = 0.3)

# The data points are in black, the regression line is in blue, the red lines are the fit interval, and the lighter gray is the prediction interval

# EC. Intervals and simulation
# Fit the deet and bites model from lab

# Load data
deet <- read.csv("labs/data/17q24DEETMosquiteBites.csv")

# Plot it:
deet_plot <- ggplot(data = deet,
                    aes(x = dose, y = bites)) +
  geom_point()

#View it
deet_plot

# model:
deet_mod <- lm(bites ~ dose, data = deet)

# Add fit line to plot
deet_plot + stat_smooth(method = "lm")

# Now, look at vcov applied to your fit
vcov(deet_mod)

# What you have here is the variance-covariance matrix of the parameters of the model. 
# In essence, every time you increase slopes in this case will have smaller intercepts, 
  # and vice-verse. This maintains the best fit possible, despite deviations in the slope and intercept. 
  # BUT - what’s cool about this is that it also allows us to produce simulations (posterior simulations for anyone interested) of the fit. 
  # We can use a package like mnormt that let’s us draw from a multivariate normal distribution when provided with a vcov matrix. For example…

#library(mnormt)
 
#rmnorm(4, mean = coef(deet_mod), varcov = vcov(deet_mod))
# ##      (Intercept)       dose
# ## [1,]    3.541639 -0.3524774
# ## [2,]    4.061716 -0.5296708
# ## [3,]    4.010105 -0.4772817
# ## [4,]    4.112800 -0.4790570
# produces a number of draws of the variance and the covariance!
# 
# A. Fit simulations!
# Using geom_abline() make a plot that has the following layers and shows that these 
  # simulated lines match up well with the fit CI. 
  # Layers: 1) the data, 2) the lm fit with a CI, and 3) simulated lines.

# Run the sims
deet_sims <- simulate(deet_mod, nsim = 20) %>%
  pivot_longer(cols = everything(),
               names_to = "sim",
               values_to = "bites")

# Create the plot-- sims and data
sim_plot <- ggplot() +
  geom_density(data = deet_sims, # Simulated lines
               mapping = aes(x = bites, group = sim),
               size = 0.2) +
  geom_density(data = deet, # Actual data
               mapping = aes(x = bites),
               size = 1, color = "blue")

# Add the fit
sim_plot + 
  #geom_point(color = "black", size = 2) + 
  stat_smooth(method = lm)


#### Jarrett's :
coef_sims <- rmnorm(500, mean = coef(deet_mod), varcov = vcov(deet_mod)) %>%
  as.data.frame

ggplot(deet, aes(dose, bites)) +
  geom_point() +
  geom_abline(data = deet_sims, aes(slope = dose, intercept = `(Intercept)`), alpha = 0.5) +
  stat_smooth(data = deet, method=lm, fill = "red")
