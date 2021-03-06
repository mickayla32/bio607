##############
# Homework Week 3- Sims and Viz
#
# 2020-09-28
#
##############

# Libraries
library(dplyr)
library(ggplot2)
library(readr)
library(forcats)
library(TSP)

# 1. Sample Properties
# Consider the following vasopressin levels in voles.
# 

vole_vaso <- c(98,96,94,88,86,82,77,74,70,60,
                59,52,50,47,40,35,29,13,6,5)

# 1a. Say “Vole vasopressin” 10 times as fast as you can. How many times did you trip up?
# None!! :-)   
#   1b. What is the mean, median, sd, and interquartile range of the sample?
mean(vole_vaso)
# The mean is 58.05
median(vole_vaso)
# The median is 59.5
sd(vole_vaso)
# The SD is 29.75244
IQR(vole_vaso)
# The IQR is 44.25

#   1c. What is the standard error of the mean (do this with a formula!)?
  # SE of the mean = sd of your sample / the square root of your sample size

vole_se_mean <- sd(vole_vaso) / sqrt(length(vole_vaso))
vole_se_mean
# SE of the mean = 6.652849

#   1d. What does the standard error of the mean tell you about our estimate of the mean values of the population of vole vassopressin?
# The SE tells us how precise our samples are. 
# *****

# 2. Sample Size for upper quartiles.
# We can get the upper quartile value of vole vassopressin with
# 
quantile(vole_vaso, probs = 0.75)
# 75% = 83

# Let’s assume the sample is representative of the popultion.
# 2a. Use sample() to get just one resample with a sample size of 10. What is its upper quartile?

# Create sample size object
samp_size <- 10

# Set seed for reproducibility
set.seed(123)

# Run 1 resample using sample size object to get the upper quantile
sample(vole_vaso,
       size = samp_size,
       replace = TRUE) %>%
  quantile(prob = 0.75)
# The upper quartile of this resample is 59.75

# 2b. Build an initial data frame for simulations with the sample sizes 5 through 20.

# Set seed for reproducibility
set.seed(123)

vole_upperq_sims <- data.frame(samp_sizes = 5:20) %>%


# 2c. Use this data frame to get simulated upper quartiles for each sample size using 1,000 simulations

  rowwise(samp_sizes) %>%
  # replicate 
  summarize(boot_upperq = replicate(1000,
                                  # bootstrap draws
                                  sample(vole_vaso,
                                         size = samp_sizes,
                                         replace = TRUE) %>%
                                    # & get an IQR
                                    quantile(prob = 0.75)))


# View the output
vole_upperq_sims

# 2d. With a ggplot, make a guesstimate as to the best sample size for estimating the upper quartile of the population. Use whatever geom you feel makes things most easy to see. 
# E.C. Add a red dashed line using geom_vline() or geom_hline() to show where that should be, perhaps.

iqr_samp_size_plot <- ggplot(data = vole_upperq_sims,
       mapping = aes(x = samp_sizes,
                     y = boot_upperq)) +
  geom_point() +
  scale_x_continuous(breaks = round(seq(min(vole_upperq_sims$samp_sizes), max(vole_upperq_sims$samp_sizes), by = 1),1))

iqr_samp_size_plot

# The best sample size looks to be around 11, since the upper quantile doesn't seem to vary much from sample size of 11 and up
iqr_samp_size_plot + geom_vline(xintercept = 11, color = "red",
                                linetype = "dashed")


# 2e. Plot the SE of the estimate of the upper quantile by sample size. 
  # Again, what it the best way to see this? Does it level off? Is there a level you feel acceptable? 
  # Justify your answer. Does this match with what you put in 2d?

# Get SE of the upper quantiles
boot_se_upperq <- vole_upperq_sims %>%
  group_by(samp_sizes) %>%
  summarize(se_upperq = sd(boot_upperq))

# Create the plot
se_upperq_plot <- ggplot(data = boot_se_upperq,
                         mapping = aes(x = samp_sizes,
                                       y = se_upperq)) +
  geom_line() +
  scale_x_continuous(breaks = round(seq(min(boot_se_upperq$samp_sizes), max(boot_se_upperq$samp_sizes), by = 1),1))


# View it
se_upperq_plot

# This plot doesn't seem to level off as much as the previous one. Even at sample size = 11, the SE still seems to continue to decrease
  # From this plot, a sample size of around 18 seems better, as the SE sort of levels out here.

# 3. Ggplot
# 3a. Some setup. Run the code below. For extra credit, look up the packages and functions used and explain what is going on here. But, that’s EC.

# (Libraries loaded above)

# Set theme
theme_set(theme_bw(base_size=12))

# Read in data
ice <- read_csv("http://biol607.github.io/homework/data/NH_seaice_extent_monthly_1978_2016.csv") %>%
  mutate(Month_Name = factor(Month_Name),
         Month_Name = fct_reorder(Month_Name, Month))

# 3b. Make a boxplot showing the variability in sea ice extent every month.

ggplot(data = ice, 
       mapping = aes(x = Month_Name,
                     y = Extent)) +
  geom_boxplot()

# 3c. Use dplyr to get the annual minimum sea ice extent. 
  # Plot minimum ice by year. What do you observe?

# Calculate annual min ice extent
ice <- ice %>%
  group_by(Year) %>%
  mutate(annual_min_ext = min(Extent)) %>%
  ungroup()

# Check ice for new column
head(ice)

# Plot it by year
ggplot(data = ice,
       mapping = aes(x = Year,
                     y = annual_min_ext)) +
  geom_line()

# Right before 1980 (perhaps 1979), the annual minimum extent drops dramatically. It fluctuates each year after that, hovering around 7, and then drops again around 2002

# 3d. One thing that’s really cool about faceting is that you can use cut_*() functions on continuos variables to make facets by groups of continuous variables. 
  # To see what I mean, try cut_interval(1:10, n = 5) See how it makes five bins of even width? We use cut_interval() or other cut functions with faceting like so 
  # facet_wrap(~cut_interval(some_variable)).
  # With the original data, plot sea ice by year, with different lines (oh! What geom will you need for that?) for different months. 
  # Then, use facet_wrap and cut_interval(Month, n=4) to split the plot into seasons.

# Try out cut_interval
cut_interval(1:10, n = 5)

# Plot of sea ice extent by year, colored by month
ext_by_year_plot <- ggplot(data = ice, 
       mapping = aes(x = Year,
                     y = Extent,
                     color = Month_Name)) +
  geom_line()

# View it
ext_by_year_plot

# Add facets by season cut_interval(Month, n = 4) ** Must be "Month", not "Month_Name", otherwise get error: 'x' must be numeric
ext_by_year_plot +
  facet_wrap(~cut_interval(Month, n = 4))

# 3e. Last, make a line plot of sea ice by month with different lines as different years. 
  # Gussy it up with colors by year, a different theme, critical values, and whatever other annotations, changes to axes, etc., you think best show the story of this data. 
  # For ideas, see the lab, and look at various palettes around. 
  # Extra credit for using colorfindr to make a palette.

ext_by_month_plot <- ggplot(data = ice, 
                            mapping = aes(x = Month_Name,
                                          y = Extent,
                                          color = Year)) +
  geom_line(mapping = 
              aes(group = Year))

# View it
ext_by_month_plot

# Install and load colorfindr
#install.packages("colorfindr")
library(colorfindr)

# Plot (5000 randomly selected pixels) of aurora borealis
get_colors("https://upload.wikimedia.org/wikipedia/commons/a/aa/Polarlicht_2.jpg") %>% 
  plot_colors_3d(sample_size = 5000, marker_size = 2.5, color_space = "RGB")

# Set seed
set.seed(123)

# Get colors and create a palette with n = 5 
my_palette <- get_colors("https://upload.wikimedia.org/wikipedia/commons/a/aa/Polarlicht_2.jpg") %>% 
  make_palette(n = 50)

# Sort colors
rgb <- col2rgb(my_palette)
tsp <- as.TSP(dist(t(rgb)))
sol <- solve_TSP(tsp, control = list(repetitions = 1e3))
ordered_cols <- my_palette[sol]

lab <- convertColor(t(rgb), 'sRGB', 'Lab')
ordered_cols2 <- my_palette[order(lab[, 'L'])]

# Plot ordered colors
my_palette_ordered <- ggplot2::qplot(x = 1:50, y = 1, fill = I(ordered_cols2), geom = 'col', width = 1) + ggplot2::theme_void()

# Add different color palette, theme, etc.
ext_by_month_plot <- ext_by_month_plot + scale_color_gradientn(colors = ordered_cols2)

# Change theme, add title, change axis

ext_by_month_plot + theme_light() +
  labs(title = "Monthly Change in Sea Ice Extent, by Year", x = "Month", y = "Extent")
