---
title: "Classification Methods"
author: "T. Evgeniou"
output:
  html_document:
    css: styles/default.css
    theme: paper
    toc: yes
    toc_float:
      collapsed: no
      smooth_scroll: yes
  pdf_document:
    includes:
      in_header: styles/default.sty
---


```
## 
## *****
##  BE CAREFUL, THE DEPENDENT VARIABLE TAKES MORE THAN 2 VALUES...
## Splitting it around its median...
## *****
## 
```


# What is this for?

A bank is interested in knowing which customers are likely to default on loan payments. The bank is also interested in knowing what characteristics of customers may explain their loan payment behavior. An advertiser is interested in choosing the set of customers or prospects who are most likely to respond to a direct mail campaign. The advertiser is also interested in knowing what characteristics of consumers are most likely to explain responsiveness to the campaign. A procurement manager is interested in knowing which orders will most likely be delayed, based on recent behavior of the suppliers. An investor is interested in knowing which assets are most likely to increase in value. 

Classification (or categorization) techniques are useful to help answer such questions. They help predict the group membership (or class - hence called **classification techniques**) of individuals (data), for **predefined group memberships** (e.g. "success" vs "failure" for **binary** classification, the focus of this note), and also to describe which characteristics of individuals can predict their group membership. Examples of group memberships/classes could be: (1) loyal customers versus customers who will churn; (2) high price sensitive versus low price sensitive customers; (3) satisfied versus dissatisfied customers; (4) purchasers versus non-purchasers; (5) assets that increase in value versus not; (6) products that may be good recommendations to a customer versus not, etc. Characteristics that are useful in classifying individuals/data into predefined groups/classes could include for example (1) demographics; (2) psychographics; (3) past behavior; (4) attitudes towards specific products, (5) social network data,  etc. 

There are many techniques for solving classification problems: classification trees, logistic regression, discriminant analysis, neural networks, boosted trees, random forests, deep learning methods, nearest neighbors, support vector machines, etc, (e.g. see the R package "e1071" for more example methods). 
There are also many <a href="https://cran.r-project.org/web/views/MachineLearning.html">  R packages </a> for everything developed in the past - including the "fashionable" methods on <a href="http://deeplearning.netl">  deep learning </a>  - see various news <a href="http://www.bloomberg.com/news/articles/2015-12-08/why-2015-was-a-breakthrough-year-in-artificial-intelligence">   here </a> or <a href="http://www.bloomberg.com/news/articles/2015-12-08/why-2015-was-a-breakthrough-year-in-artificial-intelligence">   here </a>  or <a href="http://www.forbes.com/sites/anthonykosner/2014/12/29/tech-2015-deep-learning-and-machine-intelligence-will-eat-the-world/#3e2e74bf282c">   here </a> for example. Microsoft also has a large collection of methods they <a href="https://azure.microsoft.com/en-us/documentation/articles/machine-learning-algorithm-choice/">  they develop. </a> In this report, for simplicity  we focus on the first two, although one can always use some of the other methods instead of the ones discussed here. The focus of this note is not do explain any specific ("black box, math") classification method, but to describe a process for classification independent of the method used (e.g. independent of the method selected in one of the steps in the process outlined below).

An important question when using classification methods is to assess the relative performance of all available methods/models i.e. in order to use the best one according to our criteria. To this purpose there are standard performance **classification assessment metrics**, which we discuss below - this is a key focus of this note.  

# Classification using an Example

## The "Business Decision"

A boating company had become a victim of the crisis in the boating industry. The business problem of the "Boat" case study, although hypothetical, depicts very well the sort of business problems faced by many real companies in an increasingly data-intensive business environment. The management team was now exploring various growth options. Expanding further in some markets, in particular North America, was no longer something to consider for the distant future. It was becoming an immediate necessity. 

The team believed that in order to develop a strategy for North America, they needed a better understanding of their current and potential customers in that market. They believed that they had to build more targeted boats for their most important segments there. To that purpose, the boating company had commissioned a project for that market. Being a data-friendly company, the decision was made to develop an understanding of their customers in a data-driven way. 

The company would like to understand who would be the most likely customers to purchase a boat in the future or to recommend their brand, as well as what would be the **key purchase drivers** that affect people's decision to purchase or recommend. 

## The Data

With the aid of a market research firm, the boating company gathered various data about the boating market in the US through interviews with almost 3,000 boat owners and intenders. The data consisted, among others, of 29 attitudes towards boating, which respondents indicated on a 5-point scale. They are listed below. Other types of information had been collected, such as demographics as well as information about the boats, such as the length of the boat they owned, how they used their boats, and the price of the boats. 

After analyzing the survey data (using for example factor and cluster analysis), the company managers decided to only focus on a few purchase drivers which they thought were the most important ones. They decided to perform the classification and purchase drivers analysis using only the responses to the following questions:

Name   | Description
:------|:--------------------------------------------------------------------


Let's get the data and see it for a few customers. This is how the first 0 out of the total of 0 rows look:


```
## Error in `colnames<-`(`*tmp*`, value = c("01", "00")): length of 'dimnames' [2] not equal to array extent
```

We will see some descriptive statistics of the data later, when we get into the statistical analysis.

## A Process for Classification

> It is important to remember that Data Analytics Projects require a delicate balance between experimentation, intuition, but also following (once a while) a process to avoid getting fooled by randomness in data and finding "results and patterns" that are mainly driven by our own biases and not by the facts/data themselves.

There is *not a single best* process for classification. However, we have to start somewhere, so we will use the following process:

# Classification in 6 steps

1. Create an estimation sample and two validation samples by splitting the data into three groups. Steps 2-5 below will then be performed only on the estimation and the first validation data. You should only do step 6 once on the second validation data, also called **test data**, and report/use the performance on that (second validation) data only to make final business decisions. 
2.  Set up the dependent variable (as a categorical 0-1 variable; multi-class classification is also feasible, and similar, but we do not explore it in this note). 
3. Make a preliminary assessment of the relative importance of the explanatory variables using visualization tools and simple descriptive statistics. 
4.  Estimate the classification model using the estimation data, and interpret the results.
5. Assess the accuracy of classification in the first validation sample, possibly repeating steps 2-5 a few times in different ways to increase performance.
6. Finally, assess the accuracy of classification in the second validation sample.  You should eventually use/report all relevant performance measures/plots on this second validation sample only.

Let's follow these steps.

## Step 1: Split the data 

It is very important that you finally measure and report (or expect to see from the data scientists working on the project) the performance of the models on **data that have not been used at all during the analysis, called "out-of-sample" or test data** (steps 2-5 above). The idea is that in practice we want our models to be used for predicting the class of observations/data we have not seen yet (e.g. "the future data"): although the performance of a classification method may be high in the data used to estimate the model parameters, it may be significantly poorer on data not used for parameter estimation, such as the **out-of-sample** (future) data in practice. The second validation data mimic such out-of-sample data, and the performance on this validation set is a better approximation of the performance one should expect in practice from the selected classification method.  This is why we split the data into an estimation sample and two validation samples  - using some kind of randomized splitting technique.  The estimation data and the first validation data are used during steps 2-5 (with a few iterations of these steps), while the second validation data is only used once at the very end before making final business decisions based on the analysis. The split can be, for example, 80% estimation, 10% validation, and 10% test data, depending on the number of observations - for example, when there is a lot of data, you may only keep a few hundreds of them for the validation and test sets, and use the rest for estimation. 

While setting up the estimation and validation samples, you should also check that the same proportion of data from each class, i.e. people who plan to purchase a boat versus not, are maintained in each sample, i.e., you should maintain the same balance of the dependent variable categories as in the overall dataset. 

For simplicy, in this note we will  not iterate steps 2-5.  Again, this should **not** be done in practice, as we should usually iterate steps 2-5 a number of times using the first validation sample each time, and make our final assessment of the classification model using the test sample only once (ideally). 


```
## Error in ProjectData[estimation_data_ids, ]: subscript out of bounds
```

```
## Error in ProjectData[validation_data_ids, ]: subscript out of bounds
```

















































