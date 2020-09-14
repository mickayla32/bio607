#### HOMEWORK WEEK 1- INTRO TO R ####
#### 2020-09-11 ####
#### Mickayla Johnston ####

# Load quakes with data(quakes). Show what’s there with str() and summary().
data("quakes")
str(quakes)
summary(quakes)

# Show the entirity of the column "long".
quakes[["long"]]
 
# Hey, another useful function - unique()! Apply it to a vector, and you can see what are all of the unique values. It’s great for really digging into a problematic vector.
unique(quakes[["stations"]])

# What unique stations are there? Use length() with unique() to determine how many stations there are.
length(unique(quakes[["stations"]]))
# There are 102

# Using range(), what is the range of depths where quakes occur?
range(quakes[["depth"]])
# 40 to 680

#   E.C. Where was the earthquake of largest magnitude found? You’ll need to use some comparisons and the max() function for this in your indices instead of a number!
max(quakes[["mag"]])

match(6.4, quakes[["mag"]])

quakes[152, "stations"]
