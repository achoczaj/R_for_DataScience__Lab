#--------------------------------------
#
# R for Data Science - http://r4ds.had.co.nz/data-visualisation.html
# 
# Labs notes and exercises for Chapter 3 - Data visualisation
#
# How to visualise your data using ggplot2
#
#--------------------------------------

#load the core tidyverse packages
library(tidyverse)


# explore mpg data frame found in ggplot2 (aka ggplot2::mpg).
mpg
## Tibbles are a modern take on data frames. They keep the features that have stood the test of time, and drop the features that used to be convenient but are now frustrating (i.e. converting character vectors to factors).
## tibble() is a nice way to create data frames.

# open mpg's help page
?mpg


# ---------------------------------
# 3.2  Creating a ggplot
# ---------------------------------

# plot mpg, run this code to put displ on the x-axis and hwy on the y-axis:
  
ggplot(data = mpg) + ##dataset to use in the graph
  ## adding one or more layers to ggplot()
  ## the '+' has to come at the end of the line, not the start
  
  ## geom_point() adds a layer of points to your plot, which creates a scatterplot
  geom_point(mapping = aes(x = displ, y = hwy)) 
  ## define how variables in your dataset are mapped to visual properties
  ## i.e. specify which variables to map to the x and y axes


# 3.2.4 Exercises

# 2. How many rows are in mpg? How many columns?
dim(mpg)
## [1] 234  11

# 3. What does the drv variable describe? Read the help for ?mpg to find out.
?mpg
## f = front-wheel drive, r = rear wheel drive, 4 = 4wd

# 4. Make a scatterplot of hwy vs cyl.
ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = cyl))

# 5. What happens if you make a scatterplot of class vs drv? Why is the plot not useful?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = drv))


# ---------------------------------
# 3.3  Aesthetic mappings
# ---------------------------------

# You can add a third variable, like class, to a two dimensional scatterplot by mapping it to an aesthetic. 
# An aesthetic is a visual property of the objects in your plot. Aesthetics include things like the size, the shape, or the color of your points.


# the colour aesthetic, which controls the colour of the points


# map the colors of your points to the class variable to reveal the class of each car
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
## To map an aesthetic to a variable, associate the name of the aesthetic to the name of the variable inside aes().



# the size aesthetic, which controls the size of the points

# map class to the size aesthetic in the same way
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))
## We get a warning here, because mapping an unordered variable (class) to an ordered aesthetic (size) is not a good idea.


# the alpha aesthetic, which controls the transparency of the points

# Left
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))


# the shape aesthetic, which controls the shape of the points

# Right
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
## ggplot2 will only use six shapes at a time. By default, additional groups will go unplotted when you use the shape aesthetic.


# set the aesthetic properties of your geom manually
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
## arguments of your geom function goes outside of aes(). 

## You’ll need to pick a value that makes sense for that aesthetic:
## - The name of a color as a character string.
## - The size of a point in mm.
## - The shape of a point as a number (1:25).


# 3.3.1 Exercises

# 1. What’s gone wrong with this code? Why are the points not blue?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
## the argument of geom function did not go outside of aes(). 
## Because the color argument was set within aes(), not geom_point().
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# 2. Which variables in mpg are categorical? 
#    Which variables are continuous? 
#    (Hint: type ?mpg to read the documentation for the dataset). How can you see this information when you run mpg?
str(mpg)

# Categorical - manufacturer, model, trans, drv, fl, class
# Continuous - displ, cyl, cty, hwy
#  Categorical variables are type chr, 
#  whereas continuous variables are type dbl or int


# 3. Map a continuous variable to color, size, and shape. 
#    How do these aesthetics behave differently 
#    for categorical vs. continuous variables?


# continuous variable to color
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = cty))

# continuous variable to size
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = cty))

# continuous variable to shape
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = cty))
## Error: A continuous variable can not be mapped to shape


## For these aesthetics, continuous variables are visualized on a spectrum 
## (see the color plot with the continuous color palette), 
##  whereas categorical variables are binned into discrete categories, 
## like this:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))


# 4. What happens if you map the same variable to multiple aesthetics?

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = cty, size = cty))

## Both aesthetics are implemented, and multiple legends are generated.

# 5. What does the stroke aesthetic do? What shapes does it work with? 
#    (Hint: use ?geom_point)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), stroke = 3, shape = 21)

## stroke adjusts the thickness of the border for shapes that can take on different colors both inside and outside. 
## It only works for shapes 21-24.


# 6. What happens if you map an aesthetic to something other than a variable name, like  aes(colour = displ < 5)?

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))

## R executes the code and creates a temporary variable containing the results of the operation. 
## Here, the new variable takes on a value of TRUE if the engine displacement is less than 5 
## or FALSE if the engine displacement is more than or equal to 5.



# ---------------------------------
# 3.4  Common problems
# ---------------------------------

# One common problem when creating ggplot2 graphics 
# is to put the + in the wrong place: 
# it has to come at the end of the line, not the start. 
# In other words, make sure you haven’t accidentally written code like this:

ggplot(data = mpg) 
+ geom_point(mapping = aes(x = displ, y = hwy))

## Error in +geom_point(mapping = aes(x = displ, y = hwy)) : 
##  invalid argument to unary operator


# ---------------------------------
# 3.5  Facets
# ---------------------------------

# One way to add additional variables is with aesthetics. 
# Another way, particularly useful for categorical variables, 
# is to split your plot into facets, subplots 
# that each display one subset of the data.

# use facet_wrap() to facet your plot by a single variable

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 3)
  ## The first argument of facet_wrap() should be a formula, 
  ##   which you create with ~ followed by a variable name.
  ## The variable that you pass to facet_wrap() should be discrete.


# use facet_grid() to facet your plot on the combination of two variables

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)
  ## The first argument of facet_grid() is a formula. 
  ## The formula should contain two variable names separated by a ~.[y ~ x]


# If you prefer to not facet in the rows or columns dimension, 
# use a . instead of a variable name, e.g. + facet_grid(. ~ cyl).

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ cyl)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(cyl ~ .)


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ drv, nrow = 2)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ drv)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ class)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(class ~ .)


# 3.5.1 Exercises

# 1. What happens if you facet on a continuous variable?

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl)) +
  facet_wrap(~ displ)

## Your graph will not make much sense. R will try to draw 
##  a separate facet for each unique value of the continuous variable. 
## If you have too many unique values, you may crash R.


# 2. What do the empty cells in plot with facet_grid(drv ~ cyl) mean? 
#    How do they relate to this plot?

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl))

## Empty cells mean there are no observations in the data 
## that have that unique combination of values. 

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl)) +
  facet_grid(drv ~ cyl)

## For instance, in this plot we can determine that there are 
## no vehicles with 5 cylinders that are also 
## 4 wheel [4] or rear wheel [r] drive vehicles. 

## The plot is similar to the original one, just that each facet only appears 
## to have a single data point.


# 3. What plots does the following code make? What does . do?

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

## '.' acts a placeholder for no variable. 
## In facet_grid(), this results in a plot faceted 
## on a single dimension (1-by-n or n-by-1) 
## rather than an n-by-n grid.


# 4. Take the first faceted plot in this section:
  
  ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

  
# 4.1 What are the advantages to using faceting instead of the colour aesthetic? 
#     What are the disadvantages? 
#     How might the balance change if you had a larger dataset?

  ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy, color = class))
  
## Faceting splits the data into separate grids and better visualizes trends 
##  within each individual facet. 
## The disadvantage is that by doing so, it is harder to visualize 
##  the overall relationship across facets. 

## The color aesthetic is fine when your dataset is small, 
##  but with larger datasets points may begin to overlap with one another. 
## In this situation with a colored plot, jittering may not be sufficient 
##  because of the additional color aesthetic.

# 4.2 Read ?facet_wrap. What does nrow do? What does ncol do? 
#      What other options control the layout of the individual panels? 
#      Why doesn’t facet_grid() have nrow and ncol argument?

##  facet_wrap(facets, nrow = NULL, ncol = NULL, scales = "fixed",
##   shrink = TRUE, labeller = "label_value", as.table = TRUE,
##   switch = NULL, drop = TRUE, dir = "h", strip.position = "top")
##  
##  nrow sets how many rows the faceted plot will have
##  ncol sets how many columns the faceted plot will have
##  as.table determines the starting facet to begin filling the plot
##  dir determines the starting direction for filling in the plot (horizontal or vertical)
  
  
# 6. When using facet_grid() you should usually put the variable 
#     with more unique levels in the columns. Why?

## This will extend the plot vertically, where you typically have more viewing space. 
##  If you extend it horizontally, the plot will be compressed and harder to view.

# extend the plot vertically
  ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy)) +
    facet_grid(trans ~ drv)
  
# extend the plot horizontally
  ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy)) +
    facet_grid(drv ~ trans)

    
  
# ---------------------------------
# 3.6  Geometric objects
# ---------------------------------

# Plot can use a different visual object (geom) to represent the data.

# left
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# right
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

# Every geom function in ggplot2 takes a mapping argument. However, not every aesthetic works with every geom. You could set the shape of a point, but you couldn’t set the “shape” of a line. On the other hand, you could set the linetype of a line. geom_smooth() will draw a different line, with a different linetype, for each unique value of the variable that you map to linetype.
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
## Here geom_smooth() separates the cars into three lines based on their drv value, which describes a car’s drivetrain. 


# Using the group aesthetic to a categorical variable to draw multiple objects

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy)
    )

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, group = drv) ## draw a separate object for each unique value of the grouping variable
    )

## In practice, ggplot2 will automatically group the data for these geoms whenever you map an aesthetic to a discrete variable (as in the linetype example). It is convenient to rely on this feature because the group aesthetic by itself does not add a legend or distinguishing features to the geoms.
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )


# Displaing multiple geoms in the same plot,

# To display multiple geoms in the same plot, add multiple geom functions to ggplot():
  
  ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
  
  
# Using global mappings for plots
  
# This, however, introduces some duplication in our code. 
# Imagine if you wanted to change the y-axis to display cty instead of hwy. 
# You’d need to change the variable in two places, and you might forget 
# to update one. 

# You can avoid this type of repetition by passing a set of mappings to ggplot(). 
# ggplot2 will treat these mappings as global mappings 
# that apply to each geom in the graph. 
# In other words, this code will produce the same plot as the previous code:

  ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point() + 
    geom_smooth()
  
# If you place mappings in a geom function, ggplot2 will treat them 
# as local mappings for the layer. 
# It will use these mappings to extend or overwrite the global mappings 
# for that layer only. 
# This makes it possible to display different aesthetics in different layers.
  
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point(mapping = aes(color = class)) + 
    geom_smooth()

# You can use the same idea to specify different data for each layer. 

  ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point(mapping = aes(color = class)) + 
    geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)
## Here, our smooth line displays just a subset of the mpg dataset, the subcompact cars. The local data argument in geom_smooth() overrides the global data argument in ggplot() for that layer only.  

  
# 3.6.1 Exercises
  
# 1. What geom would you use to draw a line chart? A boxplot? A histogram? An area chart?
##  Line chart - geom_line()
##  Boxplot - geom_boxplot()
##  Histogram - geom_histogram()
##  Area chart - geom_area()
  
# 2. Run this code in your head and predict what the output will look like. Then, run the code in R and check your predictions.  

  ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
    geom_point() + 
    geom_smooth(se = FALSE)

  
# 3. What does show.legend = FALSE do? What happens if you remove it?
#    Why do you think I used it earlier in the chapter? 

    ggplot(data = mpg) +
    geom_smooth(
      mapping = aes(x = displ, y = hwy, color = drv),
      show.legend = TRUE
    )
  
  ggplot(data = mpg) +
     geom_smooth(
       mapping = aes(x = displ, y = hwy, color = drv),
       show.legend = FALSE
     )

##  It removes the legend. The aesthetics are still mapped and plotted, 
##  but the key is removed from the graph.
  
##  The group aesthetic by itself does not add a legend or distinguishing features 
##  to the geoms. So to generate similar plot w/o legent whenever you map an aesthetic to a discrete variable.   
  
  
# 4. What does the se argument to geom_smooth() do?

  ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
    geom_point() + 
    geom_smooth(se = FALSE)
  
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
    geom_point() + 
    geom_smooth(se = TRUE)
  
## It determines whether or not to draw a confidence interval around the smoothing line.  
  
# 5. Will these two graphs look different? Why/why not?  
  
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
     geom_point() + 
     geom_smooth()
   
  ggplot() + 
     geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + 
     geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))
   
## No because they use the same data and mapping settings. 
## By storing data and mapping settings in the ggplot() function, 
##  it is automatically reused for each layer, if not changed localy.

# 6. Recreate the R code necessary to generate the following graphs.

   ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
     geom_point() + 
     geom_smooth(se=FALSE)      

   ggplot(data = mpg, mapping = aes(x = displ, y = hwy) ) + 
     geom_point() + 
     geom_smooth(mapping = aes(group = drv), se=FALSE)      
   
   ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv) ) + 
     geom_point() + 
     geom_smooth(se=FALSE)

   ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
     geom_point(mapping = aes(color = drv)) +
     geom_smooth(se = FALSE)     
   
   ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
     geom_point(mapping = aes(color = drv)) +
     geom_smooth(mapping = aes(linetype = drv), se = FALSE)
   
   ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
     geom_point(stroke = 5, color = "white") +
     geom_point(size = 4, aes(color = drv))
   

#------------------------------------    
# 3.7  Statistical transformations
#------------------------------------    

# Let’s take a look at a bar chart. Bar charts seem simple, but they are
# interesting because they reveal something subtle about plots. Consider a basic
# bar chart, as drawn with geom_bar(). The following chart displays the total
# number of diamonds in the diamonds dataset, grouped by cut. The diamonds
# dataset comes in ggplot2 and contains information about ~54,000 diamonds,
# including the price, carat, color, clarity, and cut of each diamond. The chart
# shows that more diamonds are available with high quality cuts than with low
# quality cuts.
   
   ggplot(data = diamonds) + 
     geom_bar(mapping = aes(x = cut))

# On the x-axis, the chart displays cut, a variable from diamonds. On the
# y-axis, it displays count, but count is not a variable in diamonds! Where does
# count come from? Many graphs, like scatterplots, plot the raw values of your
# dataset. Other graphs, like bar charts, calculate new values to plot:
   
# - bar charts, histograms, and frequency polygons: bin your data and then plot bin counts, 
#     the number of points that fall in each bin.
   
# - smoothers: fit a model to your data and then plot predictions from the model.
   
# - boxplots: compute a robust summary of the distribution and then display a specially formatted box.
   
# The algorithm used to calculate new values for a graph is called a stat, short
# for statistical transformation. You can learn which stat a geom uses by
# inspecting the default value for the stat argument. For example, ?geom_bar
# shows that the default value for stat is “count”, which means that geom_bar()
# uses stat_count(). 

# stat_count() is documented on the same page as geom_bar(), and if you scroll
# down you can find a section called “Computed variables”. That describes how it
# computes two new variables: count and prop.
   
# You can generally use geoms and stats interchangeably. For example, you can
# recreate the previous plot using stat_count() instead of geom_bar():

   ggplot(data = diamonds) + 
     stat_count(mapping = aes(x = cut))

# This works because every geom has a default stat; and every stat has a default
# geom. This means that you can typically use geoms without worrying about the
# underlying statistical transformation. 
   
   
# There are three reasons you might need to use a stat explicitly:

# Reason 1: override the default stat
# You might want to override the default stat. In the code below, I change the 
# stat of geom_bar() from count (the default) to identity. This lets me map the 
# height of the bars to the raw values of a y  variable. 
   
# Unfortunately when people talk about bar charts casually, they might be
# referring to this type of bar chart, where the height of the bar is already
# present in the data, or the previous bar chart where the height of the bar is
# generated by counting rows.
   
   demo <- tribble(
     ~cut,         ~freq,
     "Fair",       1610,
     "Good",       4906,
     "Very Good",  12082,
     "Premium",    13791,
     "Ideal",      21551
   )
   
   ggplot(data = demo) +
     geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")   

# Reason 2: override the default mapping from transformed variables to aesthetics
# You might want to override the default mapping from transformed variables to aesthetics. 
#  For example, you might want to display a bar chart of proportion, rather than count:
   
   ggplot(data = diamonds) + 
     geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

# Reason 3: draw greater attention to the statistical transformation in your code
# You might want to draw greater attention to the statistical transformation in your code. 
#  For example, you might use stat_summary(), which summarises the y values 
#  for each unique x value, to draw attention to the summary that you’re computing:
   
   ggplot(data = diamonds) + 
     stat_summary(
       mapping = aes(x = cut, y = depth),
       fun.ymin = min,
       fun.ymax = max,
       fun.y = median
     )
# ggplot2 provides over 20 stats for you to use. Each stat is a function, so you
# can get help in the usual way, e.g. ?stat_bin. To see a complete list of
# stats, try the ggplot2 cheatsheet.


# 3.7.1 Exercises
   
# 1. What is the default geom associated with stat_summary()? 
#    How could you rewrite the previous plot to use that geom function instead of the stat function?

## The default geom is geom_pointrange()
   ggplot(data = diamonds) +
     geom_pointrange(mapping = aes(x = cut, y = depth),
                     stat = "summary",
                     fun.ymin = min,
                     fun.ymax = max,
                     fun.y = median)
      
# 2. What does geom_col() do? How is it different to geom_bar()?

## geom_bar() uses the stat_count() statistical transformation to draw the bar graph. 
## geom_col() assumes the values have already been transformed to the appropriate values. 
## geom_bar(stat = "identity") and  geom_col() are equivalent.   
   
# 3. Most geoms and stats come in pairs that are almost always used in concert. Read through the documentation and make a list of all the pairs. What do they have in common?

      
# 4. What variables does stat_smooth() compute? What parameters control its behaviour?
   
## stat_smooth() calculates four variables:
##  y - predicted value
##  ymin - lower pointwise confidence interval around the mean
##  ymax - upper pointwise confidence interval around the mean
##  se - standard error

## See ?stat_smooth for more details on the specific parameters. Most
## importantly, method controls the smoothing method to be employed, se
## determines whether confidence interval should be plotted, and  level
## determines the level of confidence interval to use.
   
# 5. In our proportion bar chart, we need to set group = 1. Why? 
#    In other words what is the problem with these two graphs?
   
   ggplot(data = diamonds) + 
     geom_bar(mapping = aes(x = cut, y = ..prop..))
   
   ggplot(data = diamonds) + 
     geom_bar(mapping = aes(x = cut, y = ..prop.., fill = color))      

## If we fail to set group = 1 or group = color, the proportions for each cut 
## are calculated using the complete dataset, rather than each subset of cut. 
## Instead, we want the graphs to look like this:
   
   ggplot(data = diamonds) + 
     geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1)) 
## or   
   ggplot(data = diamonds) + 
     geom_bar(mapping = aes(x = cut, y = ..prop.., group = color))  
   
   
   ggplot(data = diamonds) + 
     geom_bar(mapping = aes(x = cut, y = ..prop.., group = color, fill = color))
## or   
   ggplot(data = diamonds) + 
     geom_bar(mapping = aes(x = cut, y = ..prop.., group = color, color = color))


   
#------------------------------------     
# 3.8  Position adjustments   
#------------------------------------

# You can colour a bar chart using either the colour aesthetic, or, more usefully, fill:
     
  ggplot(data = diamonds) + 
     geom_bar(mapping = aes(x = cut, colour = cut))
  
  ggplot(data = diamonds) + 
     geom_bar(mapping = aes(x = cut, fill = cut))


# If you map the fill aesthetic to another variable, like clarity: the bars are automatically stacked. Each colored rectangle represents a combination of cut and clarity.
  
  ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, fill = clarity))    

# The stacking is performed automatically by the position adjustment specified
# by the position argument. 
  
  
# If you don’t want a stacked bar chart, you can use one of 
#  three other options: "identity", "dodge" or "fill".
  
# position = "identity" will place each object exactly where it falls in the context of the graph. This is not very useful for bars, because it overlaps them. To see that overlapping we either need to make the bars slightly transparent by setting alpha to a small value, or completely transparent by setting fill = NA.
  
  ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
    geom_bar(alpha = 1/5, position = "identity")
  
  ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
    geom_bar(fill = NA, position = "identity")  

## The identity position adjustment is more useful for 2d geoms, like points, where it is the default.
  
# position = "fill" works like stacking, but makes each set of stacked bars the same height. 
#  This makes it easier to compare proportions across groups.
  
  ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")
  
  
# position = "dodge" places overlapping objects directly beside one another. 
#  This makes it easier to compare individual values.
  
  ggplot(data = diamonds) + 
    geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge") 
  

# position = "jitter"
# Other type of adjustment that’s not useful for bar charts, but it can be very useful 
# for scatterplots when many points overlap each other.
# his problem is known as overplotting. This arrangement makes it hard 
# to see where the mass of the data is.

# You can avoid this gridding by setting the position adjustment to “jitter”.
# position = "jitter" adds a small amount of random noise to each point. This
# spreads the points out because no two points are likely to receive the same
# amount of random noise.

  ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy))
  
  ggplot(data = mpg) + 
    geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")
  
  # Adding randomness seems like a strange way to improve your plot, 
  # but while it makes your graph less accurate at small scales, 
  # it makes your graph more revealing at large scales. 
  # Because this is such a useful operation, ggplot2 comes with a shorthand 
  # for geom_point(position = "jitter"): geom_jitter().
  
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point() +
    geom_jitter()
  
  ggplot(mpg, aes(class, hwy)) +
    geom_boxplot(colour = "grey50") +
    geom_jitter()
  
  # If the default jittering is too much, as in this plot:
  ggplot(mtcars, aes(am, vs)) +
    geom_jitter()
  
  # You can adjust it in two ways
  ggplot(mtcars, aes(am, vs)) +
    geom_jitter(width = 0.1, height = 0.1)
  
  ggplot(mtcars, aes(am, vs)) +
    geom_jitter(position = position_jitter(width = 0.1, height = 0.1))
  
# To learn more about a position adjustment, look up the help page associated 
# with each adjustment: ?position_dodge, ?position_fill, ?position_identity, 
# ?position_jitter, and ?position_stack.  

  
# 3.8.1 Exercises  

# 1. What is the problem with this plot? How could you improve it?

  ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
    geom_point()

## Many of the data points overlap. We can jitter the points by adding some
## slight random noise, which will improve the overall visualization.
  
  ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
    geom_point() +
    geom_jitter()
  
# 2. What parameters to geom_jitter() control the amount of jittering?
  
## width and height
  
# 3. Compare and contrast geom_jitter() with geom_count().
  
  ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
    geom_jitter()
  
  ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
    geom_count()

## Rather than adding random noise, geom_count() counts the number of
## observations at each location, then maps the count to point area. It makes
## larger points the more observations are located at that area, so the number
## of visible points is equal to geom_point().

# 4. What’s the default position adjustment for geom_boxplot()? 
#   Create a visualisation of the mpg dataset that demonstrates it.

## The default position adjustment is position_dodge().

  ggplot(data = mpg, mapping = aes(x = class, y = hwy, color = drv)) + 
    geom_boxplot()
  
  ggplot(data = mpg, mapping = aes(x = class, y = hwy, color = drv)) + 
    geom_boxplot(position = "dodge")

  
  
#--------------------------------
# 3.9  Coordinate systems      
#--------------------------------  

# The default coordinate system is the Cartesian coordinate system where the x
# and y positions act independently to determine the location of each point.

# There are a number of other coordinate systems that are occasionally helpful.
  
# coord_flip() switches the x and y axes. 
# This is useful (for example), if you want horizontal boxplots. It’s also 
# useful for long labels: it’s hard to get them to fit without overlapping on 
# the x-axis.
  
  ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
    geom_boxplot()

  ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
    geom_boxplot() +
    coord_flip()    

# coord_quickmap() sets the aspect ratio correctly for maps. This is very
# important if you’re plotting spatial data with ggplot2 (which unfortunately we
# don’t have the space to cover in this book).
  
# install.packages("maps")  
library("maps")

  nz <- map_data("nz")
  
  ggplot(nz, aes(long, lat, group = group)) +
    geom_polygon(fill = "white", colour = "black")
  
  ggplot(nz, aes(long, lat, group = group)) +
    geom_polygon(fill = "white", colour = "black") +
    coord_quickmap()    

  world <- map_data("world")
  
  ggplot(world, aes(long, lat, group = group)) +
    geom_polygon(fill = "white", colour = "black")
  
  ggplot(world, aes(long, lat, group = group)) +
    geom_polygon(fill = "white", colour = "black") +
    coord_quickmap()     

# coord_polar() uses polar coordinates. 

# Polar coordinates reveal an interesting connection between a bar chart and a
# Coxcomb chart.

  bar <- ggplot(data = diamonds) + 
    geom_bar(
      mapping = aes(x = cut, fill = cut), 
      show.legend = FALSE,
      width = 1
    ) + 
    theme(aspect.ratio = 1) +
    labs(x = NULL, y = NULL)
  
  bar + coord_flip()
  bar + coord_polar()  


# 3.9.1 Exercises

# 1. Turn a stacked bar chart into a pie chart using coord_polar().
  
  ggplot(mpg) + 
    geom_bar(aes(x = class, fill = class))
  
  ggplot(mpg, aes(x = factor(1), fill = class)) +
    geom_bar(width = 1)   +
    coord_polar(theta = "y")  

# 2. What does labs() do? Read the documentation.

  graph <- ggplot(mtcars, aes(mpg, wt, colour = cyl)) + geom_point()
  graph + labs(title = "New plot title", subtitle = "A subtitle")
  graph + labs(x = "Miles/(US) gallon")
  graph + labs(y = "Weight (1000 lbs)")
  graph + labs(colour = "Cylinders")
  
## labs() adds labels to the graph. You can add a title, subtitle, and a label
## for the x and y axes, as well as a caption.

# 3. What’s the difference between coord_quickmap() and coord_map()?

  world <- map_data("world")
  
  ggplot(world, aes(long, lat, group = group)) +
    geom_polygon(fill = "white", colour = "black") +
    coord_quickmap() 

#install.packages("mapproj")
library("mapproj")  
  ggplot(world, aes(long, lat, group = group)) +
    geom_polygon(fill = "white", colour = "black") +
    coord_map() 
    
    
##  coord_map() projects a portion of the earth (a three-dimensional object)
##  onto a flat (two-dimensional) plane. 
##  coord_map() does not preserve straight lines and therefore is computationally
##  intensive;  

##  coord_quickmap() preserves straight lines and is therefore faster to draw
##  (though less accurate).

    nz <- map_data("nz")
    # Prepare a map of NZ
    nzmap <- ggplot(nz, aes(x = long, y = lat, group = group)) +
      geom_polygon(fill = "white", colour = "black")
    
    # Plot it in cartesian coordinates
    nzmap
    # With correct mercator projection
    nzmap + coord_map()
    # With the aspect ratio approximation
    nzmap + coord_quickmap()  
  
# 4. What does the plot below tell you about the relationship between city and highway mpg? 
#    Why is coord_fixed() important? What does geom_abline() do?
  
  ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_point() + 
    geom_abline() +
    coord_fixed()

##  The relationships is approximately linear, though overall cars have slightly
##  better highway mileage than city mileage. 
  
##  But using coord_fixed(), the plot draws equal intervals on the x and y
##  axes so they are directly comparable. 

##  geom_abline() draws a line that, by default, has an intercept of 0 and slope
##  of 1. This aids us in our discovery that automobile gas efficiency is on
##  average slightly higher for highways than city driving, though the slope of
##  the relationship is still roughly 1-to-1.


      
#-----------------------  
## end of lesson
#-----------------------  
  