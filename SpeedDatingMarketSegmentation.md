---
title: "SpeedDating market segmentation"
author: "T. Evgeniou"
output:
  html_document:
    css: ../../AnalyticsStyles/default.css
    theme: paper
    toc: yes
    toc_float:
      collapsed: no
      smooth_scroll: yes
  pdf_document:
    includes:
      in_header: ../../AnalyticsStyles/default.sty
always_allow_html: yes
---

> **IMPORTANT**: Please make sure you create a copy of this file with a customized name, so that your work (e.g. answers to the questions) is not over-written when you pull the latest content from the course github. 
This is a **template process for market segmentation based on survey data**, using the  [Boats cases A](http://inseaddataanalytics.github.io/INSEADAnalytics/Boats-A-prerelease.pdf) and  [B](http://inseaddataanalytics.github.io/INSEADAnalytics/Boats-B-prerelease.pdf).

All material and code is available at the [INSEAD Data Analytics for Business](http://inseaddataanalytics.github.io/INSEADAnalytics/) website and github. Before starting, make sure you have pulled the [course files](https://github.com/InseadDataAnalytics/INSEADAnalytics) on your github repository.  As always, you can use the `help` command in Rstudio to find out about any R function (e.g. type `help(list.files)` to learn what the R function `list.files` does).


<hr>\clearpage

# The Business Questions

This process can be used as a (starting) template for projects like the one described in the [Boats cases A](http://inseaddataanalytics.github.io/INSEADAnalytics/Boats-A-prerelease.pdf) and  [B](http://inseaddataanalytics.github.io/INSEADAnalytics/Boats-B-prerelease.pdf). For example (but not only), in this case some of the business questions were: 

- What are the main purchase drivers of the customers (and prospects) of this company? 

- Are there different market segments? Which ones? Do the purchase drivers differ across segments? 

- What (possibly market segment specific) product development or brand positioning strategy should the company follow in order to increase its sales? 

See for example some of the analysis of this case in  these slides: <a href="http://inseaddataanalytics.github.io/INSEADAnalytics/Sessions2_3 Handouts.pdf"  target="_blank"> part 1</a> and <a href="http://inseaddataanalytics.github.io/INSEADAnalytics/Sessions4_5 Handouts.pdf"  target="_blank"> part 2</a>.

<hr>\clearpage

# The Process

The "high level" process template is split in 3 parts, corresponding to the course sessions 3-4, 5-6, and an optional last part: 

1. *Part 1*: We use some of the survey questions (e.g. in this case the first 29 "attitude" questions) to find **key customer descriptors** ("factors") using *dimensionality reduction* techniques described in the [Dimensionality Reduction](http://inseaddataanalytics.github.io/INSEADAnalytics/CourseSessions/Sessions23/FactorAnalysisReading.html) reading of Sessions 3-4.

2. *Part 2*: We use the selected customer descriptors to **segment the market** using *cluster analysis* techniques described in the [Cluster Analysis ](http://inseaddataanalytics.github.io/INSEADAnalytics/CourseSessions/Sessions45/ClusterAnalysisReading.html) reading of Sessions 5-6.

3. *Part 3*: For the market segments we create, we will use *classification analysis* to classify people based on whether or not they have purchased a product and find what are the **key purchase drivers per segment**. For this part we will use [classification analysis ](http://inseaddataanalytics.github.io/INSEADAnalytics/CourseSessions/Sessions67/ClassificationAnalysisReading.html) techniques.

Finally, we will use the results of this analysis to make business decisions e.g. about brand positioning, product development, etc depending on our market segments and key purchase drivers we find at the end of this process.




<hr>\clearpage

# The Data

First we load the data to use (see the raw .Rmd file to change the data file as needed):


```r
# Please ENTER the name of the file with the data used. The file should be a
# .csv with one row per observation (e.g. person) and one column per
# attribute. Do not add .csv at the end, make sure the data are numeric.
datafile_name = "data/SpeedDatingData_clean.csv"

# Please enter the minimum number below which you would like not to print -
# this makes the readability of the tables easier. Default values are either
# 10e6 (to print everything) or 0.5. Try both to see the difference.
MIN_VALUE = 0.5

# Please enter the maximum number of observations to show in the report and
# slides.  DEFAULT is 10. If the number is large the report may be slow.
max_data_report = 10
```


```
## Error in eval(expr, envir, enclos): could not find function "read_csv"
```

```
## Error in is.data.frame(frame): object 'ProjectData' not found
```

```
## Error in eval(expr, envir, enclos): object 'ProjectData' not found
```

<hr>\clearpage

# Part 1: Key Customer Characteristics

The code used here is along the lines of the code in the session 3-4 reading  [FactorAnalysisReading.Rmd](https://github.com/InseadDataAnalytics/INSEADAnalytics/blob/master/CourseSessions/Sessions23/FactorAnalysisReading.Rmd). We follow the process described in the [Dimensionality Reduction ](http://inseaddataanalytics.github.io/INSEADAnalytics/CourseSessions/Sessions23/FactorAnalysisReading.html) reading. 

In this part we also become familiar with:

1. Some visualization tools;
2. Principal Component Analysis and Factor Analysis;
3. Introduction to machine learning methods;

(All user inputs for this part should be selected in the code chunk in the raw .Rmd file) 


```r
# Please ENTER then original raw attributes to use.  Please use numbers, not
# column names, e.g. c(1:5, 7, 8) uses columns 1,2,3,4,5,7,8
factor_attributes_used = c("goal", "attr1_1", "sinc1_1", "intel1_1", "fun1_1", 
    "amb1_1", "shar1_1", "attr1_1", "sinc2_1", "intel2_1", "fun2_1", "amb2_1", 
    "shar2_1", "sinc3_1", "intel3_1", "fun3_1", "amb3_1", "shar3_1", "sinc5_1", 
    "intel5_1", "fun5_1", "amb5_1", "shar5_1")

# Please ENTER the selection criterions for the factors to use.  Choices:
# 'eigenvalue', 'variance', 'manual'
factor_selectionciterion = "manual"

# Please ENTER the desired minumum variance explained (Only used in case
# 'variance' is the factor selection criterion used).
minimum_variance_explained = 65  # between 1 and 100

# Please ENTER the number of factors to use (Only used in case 'manual' is
# the factor selection criterion used).
manual_numb_factors_used = 15

# Please ENTER the rotation eventually used (e.g. 'none', 'varimax',
# 'quatimax', 'promax', 'oblimin', 'simplimax', and 'cluster' - see
# help(principal)). Default is 'varimax'
rotation_used = "varimax"
```


```
## Error in ncol(ProjectData): object 'ProjectData' not found
```

```
## Error in eval(expr, envir, enclos): object 'ProjectData' not found
```

```
## Error in is.data.frame(frame): object 'ProjectDataFactor' not found
```

## Steps 1-2: Check the Data 

Start by some basic visual exploration of, say, a few data:


```
## Error in nrow(ProjectDataFactor): object 'ProjectDataFactor' not found
```

```
## Error in head(round(ProjectDataFactor, 2), max_data_report): object 'ProjectDataFactor' not found
```

The data we use here have the following descriptive statistics: 


```
## Error in apply(thedata, 2, function(r) c(min(r), quantile(r, 0.25), quantile(r, : object 'ProjectDataFactor' not found
```





















































































