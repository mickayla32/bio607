###############
# LAB 2020-10-02
#
# Wide and long data
#
###############

# Libraries
library(tidyr)
library(dplyr)
library(ggplot2)

# Data
mammals <- data.frame(site = c(1,1,2,3,3,3), 
                      taxon = c('Suncus etruscus', 'Sorex cinereus', 
                                'Myotis nigricans', 'Notiosorex crawfordi', 
                                'Suncus etruscus', 'Myotis nigricans'),
                      density = c(6.2, 5.2, 11.0, 1.2, 9.4, 9.6))

mammals
# this is long data

# What if we want wide data?
m_wide <- pivot_wider(mammals,
                      names_from = taxon, # these names become the columns
                      values_from = density) # these values become the values for each row

m_wide

# Fill in NAs with a value (0)

m_wide_0 <- mammals %>%
  pivot_wider(names_from = taxon,
              values_from = density,
              values_fill = list(density = 0))

m_wide_0
# now NAs are filled in with 0s

vis_dat(m_wide_0)

# What if had already pivoted and wanted to fill in values
  # fill in 0s without pivoting

mammals_0 <- mammals %>%
  complete(site, taxon, # any time there is a missing site-density pair, fill in 0
           fill = list(density = 0))

mammals_0

# Pivoting long
m_long_0 <- m_wide_0 %>%
  pivot_longer(cols = -site,  # everything but site is pivoted-- turned into a row
               names_to = "species_name", # species column name
               values_to = "density") # value column name

m_long_0

names(m_wide_0)

# plot
ggplot(m_wide_0,
       aes(x = `Suncus etruscus`,
           y = `Notiosorex crawfordi`)) +
  geom_jitter()

ggplot(m_long_0,
       mapping = aes(x = species_name,
                     y = density)) +
  geom_violin() +
  stat_summary(color = "red")

# Exercise
# Using palmer penguins, which is wide, make a long data frame
# so that we can see the average of all measurements
# split up by year, species, island, and sex (faceting, colors, etc)

library(palmerpenguins)
data("penguins")

# check data
penguins

#pivot longer

penguins_long <- pivot_longer(penguins,
                              cols = c(3:6),
                              names_to = "variable",
                              values_to = "measurement")
penguins_long

ggplot(data = penguins_long,
       mapping = aes(x = species,
                     y = measurement,
                     fill = sex)) +
  geom_boxplot() +
  facet_wrap(~variable, scales = "free_y")
