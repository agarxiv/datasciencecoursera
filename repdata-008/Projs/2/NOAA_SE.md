---
title: "Investigating Deadliness and Costliness in Weather Events in the U.S.A"
author: "agarxiv"
date: "November, 2014"
output: 
  html_document:
    toc: true
    theme: united
    highlight: tango
  pdf_document:
    toc: true
    highlight: zenburn
---

"Investigating Deadliness and Costliness in Weather Events in the U.S.A"
=========================================================================

# Synopsis

This report presents brief analyses of data for weather-related events in the U.S. Storms and other severe weather events can cause both public health and economic problems for communities and municipalities. Many severe events can result in fatalities, injuries, and property damage, and preventing such outcomes to the extent possible is a key concern.

This project involves exploring the U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database. This database tracks characteristics of major storms and weather events in the United States, including when and where they occur, as well as estimates of any fatalities, injuries, and property damage.

The events in the database start in the year 1950 and end in November 2011. In the earlier years of the database there are generally fewer events recorded, most likely due to a lack of good records. More recent years should be considered more complete.

The following investigations aim to answer two questions:

1. Across the United States, which types of events (as indicated in the `EVTYPE` variable) are most harmful with respect to population health?
2. Across the United States, which types of events have the greatest economic consequences?

Briefly, our results included both total costs, as well as novel measures which we call **deadliness** and **costliness**, the former measuring the injuries and fatalities per event, the latter measuring property and crop damage combined per event. Further, in order to more clearly reveal what these measures indicate about the impacts of events on the population and economy, we have grouped events into more general types (e.g. all storm-related such as "rain",  "wind", "thunder", etc, are put in one group). As can be seen below, result for total costs differ from those for deadliness and costliness, with most deadly events being marine-related (essentially accidents), while the most costly events in terms of damage to property and crops were typhoons.


# Data Processing

## Variables

The NOAA data is quite comprehensive, consisting of 37 variables covering a range of information relevant for determining the impact of weather-related events, from the states in which the events occur, their beginning and ending times/dates, exact location, as well as some measures of possible effects on populations and property. We are only focusing on these latter:

1. Populations effects having to do with numbers of fatalities and injuries, which we combine to derive a measure of the cost to the population.
2. Economic effects having to do with damage to crops and property, which we combine to derive a measure of the cost to the economy.

The actual variables from the NOAA database we will be using are the following:

    Variable | Description
         --- | ---
    `EVTYPE` | a factor with 985 levels (e.g. HEAT, STORM, TORNADO, RAIN, etc)
`FATALITIES` | a numeric vector
  `INJURIES` | a numeric vector
   `PROPDMG` | a numeric vector
`PROPDMGEXP` | a factor with 19 levels, including `H`, `K`, `M` (representing hundreds, thousands, millions)
   `CROPDMG` | a numeric vector
`CROPDMGEXP` | a factor with 9 levels, including `H`, `K`, `M` (representing hundreds, thousands, millions)
   `REMARKS` | a factor with 436781 levels (essentially strings, describing events)

## Pre-processing Steps

We began by loading a range of required libraries, and then downloaded the data file to a temporary directory. Finally, we loaded the data, ready for use.


```r
suppressMessages(library(dplyr))
library(ggplot2)
library(stringr)
library(gridExtra)
```

```
## Loading required package: grid
```

```r
data_url = "http://d396qusza40orc.cloudfront.net/repdata/data/StormData.csv.bz2"
td = tempdir()
tf = tempfile(tmpdir=td, fileext=".bz2")
download.file(data_url, tf)

storm_data <- read.csv(tf, header=TRUE, comment.char="", fileEncoding = "ISO-8859-15")
```

Several issues were found with the data which require some clean-up operations on it:

1. The levels of `EVTYPE` need grouping, as there were initially far too many labels, these labels being ambiguous (e.g. apparently several labels for what are effectively the same event) and frequently in error (e.g. spelling mistakes). 
2. The `CROPDMGEXP` and `PROPDMGEXP` variables have a range of problems that need fixing, where there are levels with distinct symbols for a very small number of entries (some being less than 10), or indeed values missing labels completely which covered a much larger number of entries (in the order of `1e4`).
3. There is also an apparent data entry mistake for one of the event observations, where the cost of this has been over-estimated in the order of `1e11`. 

First, to fix the levels of the `EVTYPE` factor, we will group patterns that relate to the same event type. For this we use regular expression matches for `EVTYPE` levels. For example, for storm events, the regular expressions we use include: `.*[Ss][Tt][Oo][Rr].*|.*[Ww][Ii].*[Nn][DdTt].*|.*[Tt][Hh][Uu][Nn][Dd].*`. The complete list of groupings is as follows:

1. **Storm** event, including rain, hail, snow and ice events (nb. as all patterns involving summaries describe storm events, these are also included here)
2. **Freezing** events
3. **Heat** events
4. **Cold** events
5. **Fire** events
6. **Flood** events
7. **Tornado**-type events
8. **Volcanic** events
9. **Slide** and **Slump** events (e.g. landslide, mudslide, landslumps, etc)
10. **Rain** events
11. **Seas** events
12. **Marine** events (i.e. mishaps or accidents)

A complete list of all regular expressions is shown below:


```r
storm = ".*[Ss][Tt][Oo][Rr].*|.*[Ww][Ii].*[Nn][DdTt].*|.*[Tt][Hh][Uu][Nn][Dd].*|.*[Ss][Nn][Oo][Ww].*|.*[Ss][Ll][Ee]+[Tt].*|.*[Bb][Ll][Ii][Zz]+[Aa][Rr][Dd].*|.*[Tt][Rr][Oo][Pp][Ii][Cc][Aa][Ll].*|.*[Tt][Ss][Uu][Nn][Aa][Mm][Ii].*|.*[Ww][Ee][Tt].*|.*[Hh][Aa][Ii][Ll].*|.*[[Ll][Ii][Gg][Hh][Tt][Nn].*[Ii].*|.*[Hh][Uu][Rr]+[Ii][Cc][Aa][Nn][Ee].*|.*[Ss][Uu][Mm]+[Aa][Rr][Yy].*"
freeze = ".*[Ii][Cc][EeYy].*|.*[Ff][Rr][EeOo]+[ZzSs].*"
heat = ".*[Hh][Ee][Aa][Tt].*|.*[Dd][Rr][Oo][Uu][Gg][Hh][Tt].*|.*[Dd][Rr][IiYy].*|.*[Hh][Ii][Gg][Hh].*[Tt][Ee][Mm][Pp].*|.*[Ww][Aa][Rr][Mm].*|.*[Rr][Ee][Cc][Oo][Rr][Dd].*[Tt][Ee][Mm][Pp][Ee][Rr][Aa][Tt].*|.*[Rr][Ee][Cc][Oo][[Rr][Dd].*[Hh][Ii][Gg][Hh].*|.*[Hh][Oo][Tt].*"
cold = ".*[Cc][Oo][Ll][Dd].*|.*[Cc][Oo]+[Ll].*|.*[Ll][Oo][Ww].*[Tt][Ee][Mm][Pp][Ee][Rr][Aa][Tt].*|[Cc][Oo][Ll][Dd]|.*.*[Rr][Ee][Cc][Oo][Rr][Dd].*[Ll][Oo][Ww].*"
fire = ".*[Ff][Ii][Rr][Ee].*"
flood = ".*[Ff][Ll][Oo]+[Dd].*|.*[Uu][Rr][Bb][Aa][Nn].*[Ss][Mm][Aa][Ll]+.*"
tornado = ".*[Tt][Oo][Rr][Nn].*[Dd].*[Oo].*|.*[Ss][Pp][Oo][Uu][Tt].*"
volcano = ".*[Vv][Oo][Ll][Cc][Aa][Nn].*"
slide = ".*[Ss][Ll][Ii][Dd][EeIi].*|.*[Ss][Ll][Uu][Mm][Pp].*"
rain = ".*[Rr][Aa][Ii][Nn].*|.*[Pp][Rr][Ee][Cc][Ii][Pp].*|.*[Ss][Hh][Oo][Ww][Ee][Rr].*"
seas = ".*[Hh][Ii][Gg][Hh].*[SsTtWw].*|.*[Ww][Aa][Vv][Ee].*|.*[Ss][Ee][Aa][Ss].*|.*[Cc][Uu][Rr].*[Ee][Nn][Tt].*|.*[Ss][Uu][Rr][Ff].*"
marine = ".*[Mm][Aa][Rr][Ii][Nn][Ee].*"
```

Next, we carry out the collection by employing an R list as a dictionary-like data-structure, which has labels for events as **keys**, and the regular expressions for matching `EVTYPE` levels as **values**.


```r
evtype_dictionary <- list(storm, freeze, heat, cold, fire, flood, tornado, volcano, slide, rain, seas, marine)
names(evtype_dictionary) <- c("STORM", "FREEZE", "HEAT", "COLD", "FIRE", "FLOOD", "TORNADO", "VOLCANO", "SLIDE", "RAIN", "SEAS", "MARINE")
```

Then, we loop through the collection of `EVTYPE` levels, reducing the overall set of types by relabelling levels which we have decided to group with the same, more general label (e.g. both wind and storm events are labelled as "STORM").


```r
for(i in 1:length(evtype_dictionary)){
  idx <- na.omit(str_match_all(levels(storm_data$EVTYPE), evtype_dictionary[[i]]))
	levels(storm_data$EVTYPE)[levels(storm_data$EVTYPE) %in% idx] <- names(evtype_dictionary)[[i]]
}
```

```
## Error in na.omit(str_match_all(levels(storm_data$EVTYPE), evtype_dictionary[[i]])): could not find function "str_match_all"
```

There are several other fixes required for two other factors: `CROPDMGEXP` and `PROPDMGEXP`. In particular, factor levels which are unclear and represent a very small amount of data, need to be removed:

1. Remove *?*, *1* and *2* levels for `CROPDMGEXP` factor
2. Remove *?*, *-*, *+*, *1*, *2*, *3*, *4*, *5*, *6*, *7* and *8* levels for `PROPDMGEXP` factor as it is uncertain what information these contain, and they represent a very small amount of data.

Finally, we drop unused levels from the data frame.


```r
idx_CROPDMGEXP_cleanup <- storm_data$CROPDMGEXP %in% c("?", "0", "2")
storm_data <- storm_data[!idx_CROPDMGEXP_cleanup,]
idx_PROPDMGEXP_cleanup <- storm_data$PROPDMGEXP %in% c("?", "-", "+", "0", "1", "2", "3", "4", "5", "6", "7", "8")
storm_data <- storm_data[!idx_PROPDMGEXP_cleanup,]
storm_data <- droplevels(storm_data)
```

The `CROPDMGEXP` and `PROPDMGEXP` factors also contain levels which have no label and which, through inspection of the `CROPDMG` and `PROPDMG` factors, we see cover a very large amount of data. Further inspection of the CROPDMG and PROPDMG factors also reveal that the associated `CROPDMG` and `PROPDMG` data need no exponents (e.g. amounts less than 100), explaining the lack of `CROPDMGEXP` and `PROPDMGEXP` data for them. We can therefore fix the empty entries `CROPDMGEXP` and `PROPDMGEXP` by filling these in with the value of `1`. 


```r
levels(storm_data$CROPDMGEXP)[levels(storm_data$CROPDMGEXP)==""] <- 1
levels(storm_data$PROPDMGEXP)[levels(storm_data$PROPDMGEXP)==""] <- 1
```

Now, in order to use the `CROPDMG` and `PROPDMG` factors directly, we expand these by first recoded `CROPDMGEXP` and `PROPDMGEXP` factors to replace their exponent symbols with numerical values. We do this by creating a dictionary mapping these symbols to their numerical values.


```r
exp_dictionary = c("1"=1, "h"=1e2, "H"=1e2, "k"=1e3, "K"=1e3, "m"=1e6, "M"=1e6, "B"=1e9)
```

Then, using this dictionary, we recode the `CROPDMGEXP` and `PROPDMGEXP` factors.


```r
crop_dmg_exps_recoded <- sapply(storm_data$CROPDMGEXP, function(x) exp_dictionary[as.character(x)])
prop_dmg_exps_recoded <- sapply(storm_data$PROPDMGEXP, function(x) exp_dictionary[as.character(x)])
```

Then, we recode and replace the `CROPDMG` and `PROPDMG` factors.


```r
storm_data$CROPDMG <- storm_data$CROPDMG*as.numeric(crop_dmg_exps_recoded)
storm_data$PROPDMG <- storm_data$PROPDMG*as.numeric(prop_dmg_exps_recoded)
```

A final clean-up is required, as an entry for a flood event is in error, for which PROPDMG has been mistakenly over-estimated in the order of `1e11`. We simply remove this entry.


```r
storm_data <- storm_data[-which.max(storm_data$PROPDMG),]
```


## Preparing data for analysis

We began by collecting data for population cost, coming up with results for both the single worst event type for population cost, as well as the top 10 worst types of events for population cost.


```r
summ_storm_evs_pop_cost <-   storm_data %>% 
  group_by(EVTYPE) %>%
	summarise(num.events=n(), counts=sum(FATALITIES+INJURIES), deadliness=counts/num.events)
```

```
## Error in eval(expr, envir, enclos): could not find function "%>%"
```

```r
worst_evs_by_pop_cost <- summ_storm_evs_pop_cost[which.max(summ_storm_evs_pop_cost$counts),]
```

```
## Error in eval(expr, envir, enclos): object 'summ_storm_evs_pop_cost' not found
```

```r
top_ten_worst_evs_by_pop_cost_byTotalCount <- arrange(summ_storm_evs_pop_cost, desc(counts))[1:10,]
```

```
## Error in eval(expr, envir, enclos): could not find function "arrange"
```

```r
top_ten_worst_evs_by_pop_cost_byDeadliness <- arrange(summ_storm_evs_pop_cost, desc(deadliness))[1:10,]
```

```
## Error in eval(expr, envir, enclos): could not find function "arrange"
```

In addition, we collected data for economic costs, coming up with results for both the single worst event type for economic cost, as well as the top 10 worst types of events for economic cost.


```r
summ_storm_evs_econ_cost <- storm_data %>% 
  group_by(EVTYPE) %>%
	summarise(num.events=n(), amounts=sum(CROPDMG +PROPDMG), costliness=amounts/num.events)
```

```
## Error in eval(expr, envir, enclos): could not find function "%>%"
```

```r
worst_evs_by_econ_cost <- summ_storm_evs_econ_cost[which.max(summ_storm_evs_econ_cost$amounts),]
```

```
## Error in eval(expr, envir, enclos): object 'summ_storm_evs_econ_cost' not found
```

```r
top_ten_worst_evs_by_econ_cost_byTotalAmount <- arrange(summ_storm_evs_econ_cost, desc(amounts))[1:10,]
```

```
## Error in eval(expr, envir, enclos): could not find function "arrange"
```

```r
top_ten_worst_evs_by_econ_cost_byCostliness <- arrange(summ_storm_evs_econ_cost, desc(costliness))[1:10,]
```

```
## Error in eval(expr, envir, enclos): could not find function "arrange"
```


# Results

Recall, that we have two questions to answer:

1. Across the United States, which types of events (as indicated in the `EVTYPE` variable) are most harmful with respect to population health?
2. Across the United States, which types of events have the greatest economic consequences?

Our results present answers to these questions, and are presented below as plots. 

First, we plot population cost, both by total counts, and by **deadliness**.


```r
pop_cost_byCount <- ggplot(data=top_ten_worst_evs_by_pop_cost_byTotalCount, aes(x=EVTYPE, y=counts))  +
  geom_bar(stat="identity", colour = "#E69F00", fill="#E69F00") +
	labs(y = "Total counts", x="Event types") + 
	labs(title = "Total counts of fatalities & injuries for each event\n(only top ten shown)") +
	theme(	plot.title = element_text(size = rel(1), face="bold"), 
			    axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
```

```
## Error in eval(expr, envir, enclos): could not find function "ggplot"
```

```r
pop_cost_byDeadliness <- ggplot(data=top_ten_worst_evs_by_pop_cost_byDeadliness, aes(x=EVTYPE, y=deadliness))  +
	geom_bar(stat="identity", colour = "#D55E00", fill="#D55E00") +
	labs(y = "Deadliness score (no. per event)", x="Event types") + 
	labs(title = "Deadliness scores for each event\n(only top ten shown)") +
	theme(	plot.title = element_text(size = rel(1), face="bold"), 
			    axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
```

```
## Error in eval(expr, envir, enclos): could not find function "ggplot"
```

```r
grid.arrange(pop_cost_byCount, pop_cost_byDeadliness, ncol=2)
```

```
## Error in eval(expr, envir, enclos): could not find function "grid.arrange"
```

From this, we can see that for total population costs, the three most costly events in terms of total counts of injuries and fatalities together were: first **Tornado**, second **Storm**, third heat and fourth **Flood**. In terms of the deadliness measure (i.e. counts of injuries and fatalities per event), we see the results are different, with first being **Marine** (mishaps or accidents), second **Glaze**  (i.e. the ground or exposed objects are covered by ice formed from the freezing of precipitation), third **Heat**, fourth **Tornado**. 

Next, we plot economic cost, both by total amounts, and by **costliness**.


```r
econ_cost_byAmount <- ggplot(data=top_ten_worst_evs_by_econ_cost_byTotalAmount, aes(x=EVTYPE, y=amounts))  +
	geom_bar(stat="identity", colour = "#56B4E9", fill="#56B4E9") +
	labs(y = "Total amounts (USD)", x="Event types") + 
	labs(title = "Total amounts of property & crop\ndamage for each event\n(only top ten shown)") +
	theme(	plot.title = element_text(size = rel(1), face="bold"), 
			    axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
```

```
## Error in eval(expr, envir, enclos): could not find function "ggplot"
```

```r
econ_cost_byCostliness <- ggplot(data=top_ten_worst_evs_by_econ_cost_byCostliness, aes(x=EVTYPE, y=costliness))  +
	geom_bar(stat="identity", colour = "#0072B2", fill="#0072B2") +
	labs(y = "Costliness score (USD per event)", x="Event types") + 
	labs(title = "Costliness scores for property & crop\ndamage for each event\n(only top ten shown)") +
	theme(	plot.title = element_text(size = rel(1), face="bold"), 
			    axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))
```

```
## Error in eval(expr, envir, enclos): could not find function "ggplot"
```

```r
grid.arrange(econ_cost_byAmount, econ_cost_byCostliness, ncol=2)
```

```
## Error in eval(expr, envir, enclos): could not find function "grid.arrange"
```


# Summary

From the plots above, we see that events having greatest total economic cost include: first **Storm**, second **Flood**, third **Tornado**, and fourth **Heat**. Events having greatest costliness measure (i.e. amounts of property and crop damage combined per event) again differed to total cost, with first being **Typhoon**, second **Heat**, third **Fire**, fourth **Cold**. This latter result also points to an important point to keep in mind about the novel measures we used: typhoons are relatively and yet highly destructive when they occur, which has led to the extreme costliness result for typhoons as reflected in the "Costliness scores" plot above.

Of course, these results relate directly to the groupings we applied to the `EVTYPE` variable in the data set. Varying the groupings would change the deadliness and costliness of the groups of events being reported. So one way of improving our results, would be to adjust these groupings, with the aim of obtaining a more clearer picture of the cost to the population and economy of such events.

