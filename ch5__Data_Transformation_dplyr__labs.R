#--------------------------------------
#
# R for Data Science - http://r4ds.had.co.nz/data-visualisation.html
# 
# Labs notes and exercises for Chapter 5 - Data transformation
#
# How to transform your data using the dplyr package
#
#--------------------------------------


# load the core tidyverse packages
library(tidyverse)
# or olny
# library(dplyr)


# use data from nycflights13 package
# install.packages("nycflights13")
library(nycflights13)


# ---------------------------------
# 5.1.1  nycflights13 Data Set
# ---------------------------------

# To explore the basic data manipulation verbs of dplyr, we’ll use
# nycflights13::flights. This data frame contains all 336,776 flights that
# departed from New York City in 2013. The data comes from the US Bureau of
# Transportation Statistics, and is documented in ?flights.

?flights
## On-time data for all flights that departed NYC (i.e. JFK, LGA or EWR) in 2013.

glimpse(flights)
## Observations: 336,776
## Variables: 19

## Tibbles are data frames, but slightly tweaked to work better in the tidyverse. 

# ---------------------------------
# 5.1.2  Types of Variables
# ---------------------------------

# Types of variables that are used in tibbles:
#  int  stands for integers.
#  dbl  stands for doubles, or real numbers.
#  chr  stands for character vectors, or strings.
#  dttm stands for date-times (a date + a time).
#  lgl  stands for logical, vectors that contain only TRUE or FALSE.
#  fctr stands for factors, which R uses to represent categorical variables with fixed possible values.
#  date stands for dates.

# To see the whole dataset, you can run View(flights) which will open the dataset in the RStudio viewer

# ---------------------------------
# 5.1.3   Key dplyr Functions
# ---------------------------------

# There are the five key dplyr functions that allow you to solve the vast majority 
# of your data manipulation challenges:
#  - Pick observations by their values (filter()).
#  - Reorder the rows (arrange()).
#  - Pick variables by their names (select()).
#  - Create new variables with functions of existing variables (mutate()).
#  - Collapse many values down to a single summary (summarise()).


# ---------------------------------
# 5.2  Filter rows with filter()
# ---------------------------------

# filter() allows you to subset observations based on their values. The first
# argument is the name of the data frame. The second and subsequent arguments
# are the expressions that filter the data frame. For example, we can select all
# flights on January 1st with:

filter(flights, month == 1, day == 1)


# dplyr functions never modify their inputs, so if you want to save the result,
# you’ll need to use the assignment operator, <-:

jan1 <- filter(flights, month == 1, day == 1)

# R either prints out the results, or saves them to a variable. If you want to
# do both, you can wrap the assignment in parentheses:
  
(dec25 <- filter(flights, month == 12, day == 25))

# ---------------------------------
# 5.2.1 Comparisons
# ---------------------------------

# To use filtering effectively, you have to know how to select the observations
# that you want using the comparison operators. R provides the standard suite:
# >, >=, <, <=, != (not equal), and == (equal).

# When you’re starting out with R, the easiest mistake to make is to use =
# instead of == when testing for equality. When this happens you’ll get an
# informative error:

filter(flights, month = 1)
#> Error: filter() takes unnamed arguments. Do you need `==`?

# There’s another common problem you might encounter when using ==: floating
# point numbers. These results might surprise you!
  
sqrt(2) ^ 2 == 2
#> [1] FALSE
  
1/49 * 49 == 1
#> [1] FALSE

# Computers use finite precision arithmetic (they obviously can’t store an
# infinite number of digits!) so remember that every number you see is an
# approximation. Instead of relying on ==, use near():
  
near(sqrt(2) ^ 2,  2)
#> [1] TRUE
near(1 / 49 * 49, 1)
#> [1] TRUE

# finds all flights that departed in November or December:
filter(flights, month == 11 | month == 12)
  
# You can’t write filter(flights, month == 11 | 12), which you might literally
# translate into “finds all flights that departed in November or December”.
# Instead it finds all months that equal 11 | 12, an expression that evaluates
# to TRUE. In a numeric context (like here), TRUE becomes one, so this finds all
# flights in January, not November or December. This is quite confusing!

# A useful short-hand for this problem is x %in% y. This will select every row
# where x is one of the values in y. We could use it to rewrite the code above:
  
(nov_dec <- filter(flights, month %in% c(11, 12)))


# Sometimes you can simplify complicated subsetting by remembering De Morgan’s
# law: !(x & y) is the same as !x | !y, and !(x | y) is the same as !x & !y. For
# example, if you wanted to find flights that weren’t delayed (on arrival or
# departure) by more than two hours, you could use either of the following two
# filters:

filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

# As well as & and |, R also has && and ||. Don’t use them here! You’ll learn
# when you should use them in conditional execution.

# Whenever you start using complicated, multipart expressions in filter(),
# consider making them explicit variables instead. That makes it much easier to
# check your work.

# ---------------------------------
# 5.2.3  Missing values
# ---------------------------------

# One important feature of R that can make comparison tricky are missing values,
# or NAs (“not availables”). NA represents an unknown value so missing values
# are “contagious”: almost any operation involving an unknown value will also be
# unknown.

NA > 5
#> [1] NA
10 == NA
#> [1] NA
NA + 10
#> [1] NA
NA / 2
#> [1] NA

# The most confusing result is this one:
  NA == NA
#> [1] NA


# If you want to determine if a value is missing, use is.na():
x <- NA
is.na(x)
#> [1] TRUE


# filter() only includes rows where the condition is TRUE; it excludes both
# FALSE and NA values. If you want to preserve missing values, ask for them
# explicitly:
    
df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)
#> # A tibble: 1 × 1
#>       x
#>   <dbl>
#> 1     3

filter(df, is.na(x) | x > 1)
#> # A tibble: 2 × 1
#>       x
#>   <dbl>
#> 1    NA
#> 2     3


# ---------------------------------
# 5.2.4  Exercises filter()
# ---------------------------------

# 1. Find all flights that:

# Had an arrival delay of two or more hours
filter(flights, arr_delay >= 120)
#> A tibble: 10,200 x 19

# Flew to Houston (IAH or HOU)
filter(flights, dest == "IAH"| dest == "HOU")
#> A tibble: 9,313 x 19

# Were operated by United, American, or Delta
filter(flights, carrier %in% c("UA", "AA", "DL" ))
#> A tibble: 139,504 x 19

# Departed in summer (July, August, and September)
filter(flights, month  %in% c(7,8,9))
#> A tibble: 86,326 x 19

# Arrived more than two hours late, but didn’t leave late
filter(flights, arr_delay > 120, dep_delay <= 0)
#> A tibble: 29 x 19
filter(flights, arr_delay > 120 & dep_delay <= 0)
#> A tibble: 29 x 19

# Were delayed by at least an hour, but made up over 30 minutes in flight
filter(flights, dep_delay >= 60, dep_delay - arr_delay > 30)
# A tibble: 1,844 x 19
filter(flights, dep_delay >= 60 & (dep_delay - arr_delay > 30))
# A tibble: 1,844 x 19
filter(flights, dep_delay >= 60 & dep_delay - arr_delay > 30)
# A tibble: 1,844 x 19

# Departed between midnight and 6am (inclusive)
filter(flights, dep_time >=0, dep_time <= 600)
#> A tibble: 9,344 x 19


# 2. Another useful dplyr filtering helper is between(). What does it do? Can
# you use it to simplify the code needed to answer the previous challenges?

## It is a shortcut for finding observations between two values. 

# Departed in summer (July, August, and September)
filter(flights, month  %in% c(7,8,9))
#> A tibble: 86,326 x 19
filter(flights, between(month, 7, 9))
#> A tibble: 86,326 x 19

# Departed between midnight and 6am (inclusive)
filter(flights, dep_time >=0, dep_time <= 600)
#> A tibble: 9,344 x 19
filter(flights, between(dep_time, 0, 600))
#> A tibble: 9,344 x 19


# 3. How many flights have a missing dep_time? What other variables are missing? What might these rows represent?

filter(flights, is.na(dep_time))
#> A tibble: 8,255 x 19

# What other variables are missing?
sort(sapply(flights, function(x) any(is.na(x)) ), decreasing = TRUE)
#> 
# Browse[1]> sapply(flights, function(x) any(is.na(x)) )
# dep_time      dep_delay       arr_time      arr_delay        tailnum       air_time           year          month 
# TRUE           TRUE           TRUE           TRUE           TRUE           TRUE          FALSE          FALSE 
# day sched_dep_time sched_arr_time        carrier         flight         origin           dest       distance 
# FALSE          FALSE          FALSE          FALSE          FALSE          FALSE          FALSE          FALSE 
# hour         minute      time_hour 
# FALSE          FALSE          FALSE 

names(flights)[sapply(flights, function(x) any(is.na(x)) )]
#> "dep_time"  "dep_delay" "arr_time"  "arr_delay" "tailnum"   "air_time" 

colSums(is.na(flights))
# year          month            day       dep_time sched_dep_time      dep_delay       arr_time sched_arr_time 
# 0              0              0           8255              0           8255           8713              0 
# arr_delay        carrier         flight        tailnum         origin           dest       air_time       distance 
# 9430              0              0           2512              0              0           9430              0 
# hour         minute      time_hour 
# 0              0              0 
names(flights)[colSums(is.na(flights)) > 0]
#> "dep_time"  "dep_delay" "arr_time"  "arr_delay" "tailnum"   "air_time" 

## Missing values are in the following variables: dep_time, dep_delay, arr_time, arr_delay, tailnum, air_time


NA_dep_time <- filter(flights, is.na(dep_time))
#> A tibble: 8,255 x 19
View(NA_dep_time)

NA_tailnum <- filter(flights, is.na(tailnum))
#> A tibble: 2,512 x 19
View(NA_tailnum)


NA_arr_delay <- filter(flights, is.na(arr_delay)) 
#> A tibble: 9,430 x 19
View(arr_delay)

temp <- filter(flights, !is.na(dep_time))
NA_arr_delay_subset <- filter(temp, is.na(arr_delay)) 
#> A tibble: 1,175 x 19
View(NA_arr_delay_subset)

## Most likely these (NA_dep_time) are scheduled flights (8,255) that never flew.



# 4. Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing? Can you figure out the general rule? (NA * 0 is a tricky counterexample!)

## NA ^ 0      - anything to the 0-th power is 1 (by definition).
## NA | TRUE   - condition is TRUE, so the result is TRUE. 
## FALSE & NA  - NA indicates the absence of a value, so the conditional expression ignores it.

## In general any operation on a missing value becomes a missing value. 
## Hence NA * 0 is NA. In conditional expressions, NA values are simply ignored.



# ---------------------------------
# 5.3  Arrange rows with arrange()
# ---------------------------------

# arrange() works similarly to filter() except that instead of selecting rows,
# it changes their order. It takes a data frame and a set of column names (or
# more complicated expressions) to order by. If you provide more than one column
# name, each additional column will be used to break ties in the values of
# preceding columns:
arrange(flights, year, month, day)
#> A tibble: 336,776 × 19

# Use desc() to re-order by a column in descending order:
arrange(flights, desc(arr_delay))

# Missing values are always sorted at the end:
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))

# ---------------------------------
# 5.3.1 Exercises with arrange()
# ---------------------------------

# 1. How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).

arrange(flights, !is.na(dep_time))

arrange(flights, -is.na(dep_time))

arrange(flights, desc(is.na(dep_time)))


# 2. Sort flights to find the most delayed flights. Find the flights that left earliest.

# most delayed (based on arrival)
arrange(flights, desc(arr_delay))

# left earliest than scheduled
arrange(flights, dep_delay)

# only flights which left earliest than scheduled
arrange(filter(flights, dep_delay < 0), dep_delay)
#>A tibble: 183,575 x 19

 
# 3. Sort flights to find the fastest flights.

## fastest flights
arrange(flights, desc(distance / air_time))


# 4. Which flights travelled the longest? Which travelled the shortest?

## longest flights by distance
arrange(flights, desc(distance))

## shortest flights by distance
arrange(flights, distance)



# ---------------------------------
# 5.4  Select columns with select()
# ---------------------------------

# It’s not uncommon to get datasets with hundreds or even thousands of
# variables. In this case, the first challenge is often narrowing in on the
# variables you’re actually interested in. select() allows you to rapidly zoom
# in on a useful subset using operations based on the names of the variables.

# select() is not terribly useful with the flights data because we only have 19
# variables, but you can still get the general idea:

# Select columns by name
temp <- select(flights,  carrier, flight, origin, dest, air_time, distance, hour, minute, time_hour)
## show fastest flights
arrange(temp, desc(distance / air_time))

# Select columns by name
select(flights,  year, month, day)

# Select all columns between year and day (inclusive)
select(flights,  year:day)

# Select all columns except those from year to day (inclusive)
select(flights,  -(year:day))


# Select columns using column indx
select(data, 1, 2, 3)
select(data, 1:3)

select(data, -1, -2, -3)
select(data, -(1:3))


#-----------------------------------------------
# 5.4.2  Utility functions of select()
#-----------------------------------------------

## Utility functions existing in select(), summarise_each() and mutate_each() in
## dplyr as well as some functions in the tidyr package.

# There are a number of helper functions you can use within select():
#  starts_with("abc"): matches names that begin with “abc”.
#  ends_with("xyz"): matches names that end with “xyz”.
#  contains("ijk"): matches names that contain “ijk”.
#  matches("(.)\\1"): selects variables that match a regular expression. 
#    This one matches any variables that contain repeated characters. 
#    You’ll learn more about regular expressions in strings.
#  num_range("x", 1:3): matches x1, x2 and x3.
#  one_of(..., vars = current_vars()): matches variables in character vector
#  everything(..., vars = current_vars()): matches all variables
# 
#   See ?select for more details.
#   starts_with(match, ignore.case = TRUE, vars = current_vars())

#------------------------------------
# 5.4.3  Rename variables in data frame
#------------------------------------

# select() can be used to rename variables, but it’s rarely useful 
# because it drops all of the variables not explicitly mentioned. 
# 
# Instead, use rename(), which is a variant of select() 
# that keeps all the variables that aren’t explicitly mentioned:

rename(flights,  tail_num = tailnum)


#------------------------------------
# 5.4.3  Reorder variables in data frame
#------------------------------------

# Another option is to use select() in conjunction with the everything() helper.
# This is useful if you have a handful of variables you’d like to move to the
# start of the data frame.

select(flights,  time_hour, air_time, everything())


# --------------------------------------------------
# 5.4.4  Standard evaluation with dplyr::select_()
# --------------------------------------------------

# Thus far, we explained the normal select() function; however, the normal
# select() function cannot handle character strings as arguments. This might
# become a problem when column names are given as a string vector for example. 

# "year", "month", "day"

# To solve this problem, the select_() function was equipped in dplyr. 
# (Caution: An underscore was added in the function name.) 


# The use of the select_() function is the same as the select() except
# specifying columns by string; however, attention is needed when specifying a
# column name by a vector.

select_(flights, "year", "month", "day")
#> A tibble: 336,776 x 3


# When specifying column names by a vector, the vector should be given the .dot
# argument.

col_vector <- c("year", "month", "day")
select_(flights, .dots = col_vector)
#> A tibble: 336,776 x 3


#------------------------------------
# utility functions with select_()
#------------------------------------

select_(flights, 'starts_with("arr")', '-ends_with("time")')

# Furthermore, using utility functions, the argument vector 
# should be given the .dot argument in the select_() function.


select_(flights, .dots = c('starts_with("arr")', '-ends_with("time")'))


# ---------------------------------
# 5.4  Exercises with select()
# ---------------------------------

# 1. Brainstorm as many ways as possible to select dep_time, dep_delay, arr_time, and arr_delay from flights.

select(flights,  dep_time, dep_delay, arr_time, arr_delay)

select(flights,  4,6,7,9)
select(flights,  4:9, -5, -8)
select(flights,  dep_time:arr_delay, -starts_with("sched"))

select(flights,  starts_with("dep"), starts_with("arr"))
select(flights,  ends_with("delay"), ends_with("time"), -starts_with("sched"), -starts_with("air"))

select(flights,  contains("dep_"), contains("arr_"), -contains("sched"))
select(flights,  contains("delay"), contains("time"), -contains("sched"), -contains("air"), -contains("hour"))

select(flights,  matches("_delay"), matches("_time"), -matches("sched"), -matches("air"))
select(flights,  matches("dep_"), matches("arr_"),  -matches("sched"))
select(flights,  matches("^(dep|arr)_")) ##use of RegEx: starts with... 


# 2. What happens if you include the name of a variable multiple times in a select() call?

select(flights, dep_time, dep_time, dep_delay, dep_time)

## R includes this variable only a single time in the new data frame


# 3. What does the one_of() function do? 
#    Why might it be helpful in conjunction with this vector?

vars <- c("year", "month", "day", "dep_delay", "arr_delay")
## vars	
## A character vector of variable names. When called from inside select() these are automatically set to the names of the table.

## When a column is named as a vector or character string
select(flights,  one_of(vars)) ## the standard way
select(flights,  vars)
## works the same - correctred in R???



# 4. Does the result of running the following code surprise you? How do the select helpers deal with case by default? How can you change that default?
select(flights, contains("TIME"))

## By default the select utilty functions ignore case. 
## To adhere to case, set ignore.case = FALSE in the helper function. For example:

select(flights, contains("TIME", ignore.case = FALSE))
#> A tibble: 336,776 × 0



# ----------------------------------------
# 5.5  Adding new variables with mutate()
# ----------------------------------------

# Besides selecting sets of existing columns, it’s often useful to add new
# columns that are functions of existing columns. That’s the job of mutate().

# mutate() always adds new columns at the end of your dataset so we’ll start by
# creating a narrower dataset so we can see the new variables. Remember that
# when you’re in RStudio, the easiest way to see all the columns is View().

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
                      )

mutate(flights_sml,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60
      )

# Note that you can refer to columns that you’ve just created:

mutate(flights_sml,
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
      )

# If you only want to keep the new variables, use transmute():

transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
          ) 

#---------------------------------
# 5.5.1 Useful creation functions
#---------------------------------

# There are many functions for creating new variables that you can use with
# mutate(). The key property is that the function must be vectorised: it must
# take a vector of values as input, return a vector with the same number of
# values as output.

# 1. Arithmetic operators: +, -, *, /, ^. 

# These are all vectorised, using the so called “recycling rules”. If one
# parameter is shorter than the other, it will be automatically extended to be
# the same length. This is most useful when one of the arguments is a single
# number: air_time / 60, hours * 60 + minute, etc.

transmute(flights,
          gain = arr_delay - dep_delay,
          speed = distance / air_time * 60
          )

# Arithmetic operators are also useful in conjunction with the aggregate
# functions you’ll learn about later. For example, x / sum(x) calculates the
# proportion of a total, and y - mean(y) computes the difference from the mean.

transmute(flights,
          gain = arr_delay - dep_delay,
          speed = distance / air_time * 60,
          mean_speed = mean(speed, na.rm = TRUE),
          residual_speed =  speed - mean(speed, na.rm = TRUE)
          )


# 2. Modular arithmetic: %/% (integer division) and %% (remainder)

# Modulo %/% (integer division) and %% (remainder), where x == y * (x %/% y) +
# (x %% y). Modular arithmetic is a handy tool because it allows you to break
# integers up into pieces. For example, in the flights dataset, you can compute
# hour and minute from dep_time with:

transmute(flights,
            dep_time,
            hour = dep_time %/% 100,
            minute = dep_time %% 100
            )


# 3. Logs: log(), log2(), log10(). 

# Logarithms are an incredibly useful transformation for dealing with data that
# ranges across multiple orders of magnitude. They also convert multiplicative
# relationships to additive, a feature we’ll come back to in modelling.

# All else being equal, I recommend using log2() because it’s easy to interpret:
# a difference of 1 on the log scale corresponds to doubling on the original
# scale and a difference of -1 corresponds to halving on the original scale.


# 4. Offsets: lead() and lag()

# Offsets: lead() and lag() allow you to refer to leading or lagging values.
# This allows you to compute running differences (e.g. x - lag(x)) 
# or find when values change (x != lag(x)). 
# They are most useful in conjunction with
# group_by(), which you’ll learn about shortly.

(x <- 1:10)
#>  [1]  1  2  3  4  5  6  7  8  9 10

## find "next/ahead" value in a vector
lead(x)
#>  [1]  2  3  4  5  6  7  8  9 10 NA

## find "previous/behind" value in a vector
lag(x)
#>  [1] NA  1  2  3  4  5  6  7  8  9

## Find the "next" or "previous" values in a vector. 
## Useful for comparing values ahead of or behind the current values.

# compute running differences
x - lag(x)


# 5. Cumulative and rolling aggregates

# R provides functions for running sums, products, mins and maxes: cumsum(),
# cumprod(), cummin(), cummax(); and dplyr provides cummean() for cumulative
# means. If you need rolling aggregates (i.e. a sum computed over a rolling
# window), try the RcppRoll package.

x
#>  [1]  1  2  3  4  5  6  7  8  9 10
cumsum(x)
#>  [1]  1  3  6 10 15 21 28 36 45 55
cummean(x)
#>  [1] 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5


# 6. Logical comparisons

# Logical comparisons, <, <=, >, >=, !=, which you learned about earlier. If
# you’re doing a complex sequence of logical operations it’s often a good idea
# to store the interim values in new variables so you can check that each step
# is working as expected.



# 7. Ranking 

# There are a number of ranking functions, but you should start with min_rank().
# It does the most usual type of ranking (e.g. 1st, 2nd, 2nd, 4th). The default
# gives smallest values the small ranks; use desc(x) to give the largest values
# the smallest ranks.

y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
#> [1]  1  2  2 NA  4  5
min_rank(desc(y))
#> [1]  5  3  3 NA  2  1

# If min_rank() doesn’t do what you need, look at the variants row_number(),
# dense_rank(), percent_rank(), cume_dist(), ntile(). See their help pages for
# more details.

row_number(y)
#> [1]  1  2  3 NA  4  5
dense_rank(y)
#> [1]  1  2  2 NA  3  4
percent_rank(y)
#> [1] 0.00 0.25 0.25   NA 0.75 1.00
cume_dist(y)
#> [1] 0.2 0.6 0.6  NA 0.8 1.0


# ------------------------------------
# 5.  Exercises with mutate()
# ------------------------------------

# 1. Currently dep_time and sched_dep_time are convenient to look at, but hard to compute with because they’re not really continuous numbers. Convert them to a more convenient representation of number of minutes since midnight.

# 2. Compare air_time with arr_time - dep_time. What do you expect to see? What do you see? What do you need to do to fix it?

# 3. Compare dep_time, sched_dep_time, and dep_delay. How would you expect those three numbers to be related?

# 4. Find the 10 most delayed flights using a ranking function. How do you want to handle ties? Carefully read the documentation for min_rank().

# 5. What does 1:3 + 1:10 return? Why?

# 6. What trigonometric functions does R provide?



# ------------------------------------
# 5.5  Add new variables with mutate()
# ------------------------------------

