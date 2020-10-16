###########################
#
# Lab week 3-- ggplot2
#
# 2020-09-25
#
###########################

# Libraries
library(ggplot2)
library(dplyr)
library(palmerpenguins)

# Look at penguins
head(penguins)

# Look at distribution of bill lengths

bill_dense <- ggplot(data = penguins,
                     mapping = aes(x= bill_length_mm))

bill_dense +
  geom_histogram()

bill_dense +
  geom_freqpoly()

# What happens if you add geom_density() ?

bill_dense +
  geom_density()

# Look at distribution of bill lengths by species
bill_dense_group <- ggplot(data = penguins,
                            mapping = aes(x = bill_length_mm,
                                          group = species))

bill_dense_group +
  geom_density()

# Add fill colors
bill_dense_group +
  geom_density(mapping = aes(fill = species))

# Make plot transparent
  # Specify something about an aesthetic, but not have it mapped to the data
bill_dense_group +
  geom_density(mapping = aes(fill = species), # maps to data
               alpha = 0.3) # does not map to data- it's fixed

# Use position = "stack"
bill_dense_group +
  geom_density(mapping = aes(fill = species), 
               postition = "stack")

#### EXERCISE
# Now try geom_histogram
  # Add different colors, alphas, fills, position

bill_dense_group + 
  geom_histogram(mapping = aes(fill = species),
                 position = position_dodge(width = 0.3),
                 alpha = 0.5) 

# color = changes the outlines

# do a little x and y as your 2 dimensions
pen_plot_base <- ggplot(data = penguins,
                        mapping = aes(x = body_mass_g,
                                      y = species,
                                      color = species))

pen_plot_base +
  geom_point(size = 3,
             alpha = 0.3)

# geom_jitter
pen_plot_base +
  geom_jitter(size = 2, alpha = 0.6)

pen_plot_base +
  geom_jitter(size = 2,
              alpha = 0.6,
              position = position_jitter(width = 0,
                                         height = 0.4))

#### Exercise
# 1. Try out the following geoms : geom_boxplot(), geom_violin(), stat_summary()
pen_plot_base + geom_boxplot(alpha = 0.3)

pen_plot_base + geom_violin(alpha = 0.3)

pen_plot_base + stat_summary(aes(fun = "median", geom = "bar"))
pen_plot_base + stat_summary_bin(fun = "mean", geom = "point", orientation = 'y',
                                 fill = "white", alpha = 0.7)

# 2. Try adding multiple geoms together
  # Does order matter?
pen_plot_base + stat_summary() + geom_boxplot()

# 3. Try ggridges-- geom_density_ridges()

# Continuous values on both axis
pen_mass_depth <- ggplot(data = penguins,
                         mapping = aes(x = body_mass_g,
                             y = bill_depth_mm,
                             color = species))

pen_mass_depth + 
  geom_point()


# Facetting

  # facet_wrap-- let R specify rows, cols, etc
pen_mass_depth + geom_point() +
  facet_wrap(~species + island)

# Exercise

  # Facet grid by other variables
pen_mass_depth + 
  geom_point() +
  facet_grid(~species + island)

pen_mass_depth + 
  geom_point() +
  facet_grid(~species + sex)

pen_mass_depth + 
  geom_point() +
  facet_grid(~species + year)

  # Try coloring by a different variable
pen_mass_depth2 <- ggplot(data = penguins,
                         mapping = aes(x = body_mass_g,
                                       y = bill_depth_mm,
                                       color = island))

pen_mass_depth2 + geom_point() +
  facet_grid(~sex)

pen_mass_depth2 + geom_point() +
  facet_grid(~species)

####

pen_scatter <- pen_mass_depth +
  geom_point()

# Labels
library(ggthemes)
pen_scatter <- pen_scatter +
  labs(title = "Penguin Bill Depth vs. Body Mass",
       subtitle = "Data from Palmer LTER",
       x = "Body Mass (g)",
       y = "Bill Depth (mm)",
       color = "Species of \nPenguin")

pen_scatter +
  theme_bw(base_size = 14,
           base_family = "Times")

pen_scatter +
  theme_fivethirtyeight()

theme_set(theme_classic(base_size = 12, base_family = "Times"))

# Colors
pen_scatter +
  scale_color_manual(values = c("orange", "purple", "darkblue"))

pen_scatter +
  scale_color_brewer(palette = "Dark2")

pen_scatter +
  scale_color_viridis_d()

pen_scatter +
  scale_color_viridis_d(option = "A")

pen_scatter +
  scale_color_manual(values = rainbow(3))

library(wesanderson)

pen_scatter +
  scale_color_manual(values = wes_palette("BottleRocket2"))

# Continuous color scales
pen_mass_col <- ggplot(data = penguins,
                       mapping = aes(x = bill_depth_mm,
                                     y = bill_length_mm,
                                     color = body_mass_g)) +
  geom_point() +
  facet_wrap(~species)


pen_mass_col

# Viridis
pen_mass_col +
  scale_color_viridis_c()

pen_mass_col +
  scale_color_gradient(low = "blue", high = "red")


#### Exercise ####

# How does flipper length relate to bill length and depth
  # Combine aspects- sex, year, etc.
  # Add a great color scale with matching theme



pen_flip_bill <- ggplot(data = penguins,
                       mapping = aes(x = bill_depth_mm,
                                     y = bill_length_mm,
                                     color = flipper_length_mm)) +
  geom_point() +
  facet_wrap(~species + island)

pen_flip_bill +
  theme_par(base_size = 12, base_family = "Times") +
  scale_color_continuous_tableau(palette = "Red-Gold") +
  labs(x = "Bill Depth (mm)",
       y = "Bill Length (mm)",
       color = "Flipper Length (mm)")

                        