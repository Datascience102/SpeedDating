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
## Error in `[.data.frame`(ProjectData, , independent_variables): undefined columns selected
```

```
## 
## *****
##  BE CAREFUL, THE DEPENDENT VARIABLE TAKES MORE THAN 2 VALUES...
## Splitting it around its median...
## *****
## 
```

```
## Error in median.default(ProjectData[, dependent_variable]): need numeric data
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


Let's get the data and see it for a few customers. This is how the first 10 out of the total of 5656 rows look:


|  01|  02|  03|  04|  05|  06|  07|  08|  09|  10|
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 511| 510| 507| 512| 514| 513| 508| 509| 515| 516|

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



We typically call the three data samples as **estimation_data** (e.g. 80% of the data in our case),  **validation_data**  (e.g. the 10% of the data) and **test_data** (e.g. the remaining 10% of the data).

In our case we use for example  observations in the estimation data, 
 in the validation data, and  in the test data. 

## Step 2: Choose dependent variable

First, make sure the dependent variable is set up as a categorical 0-1 variable. In this illustrative example, the "intent to recommend" and "intent to purchase" are 0-1 variables: we will use the later as our dependent variable but a similar analysis could be done for the former. 

The data however may not be always readily available with a categorical dependent variable. Suppose a retail store wants to understand what discriminates consumers who are  loyal versus those who are not. If they have data on the amount that customers spend in their store or the frequency of their purchases, they can create a categorical variable ("loyal vs not-loyal") by using a definition such as: "A loyal customer is one who spends more than X amount at the store and makes at least Y purchases a year". They can then code these loyal customers as "1" and the others as "0". They can choose the thresholds X and Y as they wish: a definition/decision that may have a big impact in the overall analysis. This decision can be the most crucial one of the whole data analysis: a wrong choice at this step may lead both to poor performance later as well as to no valuable insights. One should revisit the choice made at this step several times, iterating steps 2-3 and 2-5.

> Carefully deciding what the dependent 0/1 variable is can be the most critical choice of a classification analysis. This decision typically depends on contextual knowledge and needs to be revisited multiple times throughout a data analytics project. 

In our data the number of 0/1's in our estimation sample is as follows:


```
## Error in estimation_data[, dependent_variable]: incorrect number of dimensions
```

```
## Error in colnames(class_percentages) <- c("Class 1", "Class 0"): object 'class_percentages' not found
```

```
## Error in rownames(class_percentages) <- "# of Observations": object 'class_percentages' not found
```

```
## Error in inherits(x, "list"): object 'class_percentages' not found
```

while in the validation sample they are:


```
## Error in validation_data[, dependent_variable]: incorrect number of dimensions
```

```
## Error in colnames(class_percentages) <- c("Class 1", "Class 0"): object 'class_percentages' not found
```

```
## Error in rownames(class_percentages) <- "# of Observations": object 'class_percentages' not found
```

```
## Error in inherits(x, "list"): object 'class_percentages' not found
```

## Step 3: Simple Analysis

Good data analytics starts with good contextual knowledge as well as a simple statistical and visualization exploration of the data. In the case of classification, one can explore "simple classifications" by assessing how the  classes differ along any of the independent variables. For example, these are the statistics of our independent variables across the two classes, class 1, "purchase"


```
## Error in estimation_data[, dependent_variable]: incorrect number of dimensions
```

and class 0, "no purchase":


```
## Error in estimation_data[, dependent_variable]: incorrect number of dimensions
```

The purpose of such an analysis by class is to get an initial idea about whether the classes are indeed separable as well as to understant which of the independent variables have most discriminatory power. Can you see any differences across the two classes in the tables above? 

Notice however that

> Even though each independent variable may not differ across classes, classification may still be feasible: a (linear or nonlinear) combination of independent variables may still be discriminatory. 

A simple visualization tool to assess the discriminatory power of the independent variables are the **box plots**. These visually indicate simple summary statistics of an independent variable (e.g. mean, median, top and bottom quantiles, min, max, etc). For example consider the box plots for our data, for class 0


```
## Error in estimation_data[, dependent_variable]: incorrect number of dimensions
```

```
## Error in estimation_data[, dependent_variable]: incorrect number of dimensions
```

```
## Error in estimation_data[, dependent_variable]: incorrect number of dimensions
```

```
## Error in ncol(x0): object 'x0' not found
```

```
## Error in ncol(x1): object 'x1' not found
```

```
## Error in ncol(x0): object 'x0' not found
```

```
## Error in nrow(x0): object 'x0' not found
```

and class 1:


```
## Error in ncol(x1): object 'x1' not found
```

```
## Error in nrow(x1): object 'x1' not found
```

Can you see which variables appear to be the most discrimatory ones?

## Step 4: Classification and Interpretation

Once we decide which  dependent and independent variables to use (which can be revisited in later iterations), one can use a number of classification methods to develop a model that discriminates the different classes. 

> Some of the widely used classification methods are:  classification and regression trees, boosted trees, support vector machines, neural networks, nearest neighbors, logistic regression, lasso, random forests, deep learning methods, etc.

In this note we will consider for simplicity only two classification methods: **logistic regression** and **classification and regression trees (CART)**. However, replacing them with other methods is relatively simple (although some knowledge of how these methods work is often necessary - see the R help command for the methods if needed). Understanding how these methods work is beyond the scope of this note - there are many references available online for all these classification methods. 

CART is a widely used classification method largely because the estimated classification models are easy to interpret. This classification tool iteratively "splits" the data using the most discriminatory independent variable at each step, building a "tree" - as shown below - on the way. The CART methods **limit the size of the tree** using various statistical techniques in order to avoid **overfitting the data**. For example, using the rpart and rpart.control functions in R, we can limit the size of the tree by selecting the functions' **complexity control** paramater **cp** (what this does is beyond the scope of this note. For the rpart and rpart.control functions in R, smaller values, e.g. cp=0.001, lead to larger trees, as we will see next).

> One of the biggest risks when developing classification models is overfitting: while it is always trivial to develop a model (e.g. a tree) that classifies any (estimation) dataset with no misclassification error at all, there is no guarantee that the quality of a classifier in out-of-sample data (e.g. in the validation data) will be close to that in the estimation data. Striking the right balance between "over-fitting" and "under-fitting" is one of the most important aspects in data analytics. While there are a number of statistical techniques to help us find this balance - including the use of validation data - it is largely a combination of good statistical analysis with qualitative criteria (e.g. regarding the interpretability or simplicity of the estimated models) that leads to classification models which can work well in practice. 

Running a basic CART model with complexity control cp=0.01,  leads to the following tree (**NOTE**: for better readability of the tree figures below,  we will rename the independent variables as IV1 to IV1 when using CART):


```
## Error in estimation_data[, dependent_variable]: incorrect number of dimensions
```

```
## Error in colnames(estimation_data_nolabel) <- c(colnames(estimation_data)[dependent_variable], : object 'estimation_data_nolabel' not found
```

```
## Error in validation_data[, dependent_variable]: incorrect number of dimensions
```

```
## Error in colnames(validation_data_nolabel) <- c(dependent_variable, independent_variables_nolabel): object 'validation_data_nolabel' not found
```

```
## Error in test_data[, dependent_variable]: incorrect number of dimensions
```

```
## Error in colnames(test_data_nolabel) <- c(dependent_variable, independent_variables_nolabel): object 'test_data_nolabel' not found
```

```
## Error in data.frame(estimation_data_nolabel): object 'estimation_data_nolabel' not found
```

```
## Error in data.frame(validation_data_nolabel): object 'validation_data_nolabel' not found
```

```
## Error in data.frame(test_data_nolabel): object 'test_data_nolabel' not found
```

```
## Error in is.data.frame(data): object 'estimation_data_nolabel' not found
```

```
## Error in inherits(x, "rpart"): object 'CART_tree' not found
```

The leaves of the tree indicate the number of estimation data observations that belong to each class which "reach that leaf" as well as the pecentage of all data points that reach the leaf. A perfect classification would only have data from one class in each of the tree leaves. However, such a perfect classification of the estimation data would most likely not be able to classify well out-of-sample data due to over-fitting of the estimation data.

One can estimate larger trees through changing the tree's **complexity control** parameter (in this case the rpart.control argument cp). For example, this is how the tree would look like if we set `cp = 0.005`:


```
## Error in is.data.frame(data): object 'estimation_data_nolabel' not found
```

```
## Error in inherits(x, "rpart"): object 'CART_tree_large' not found
```

One can also use the percentage of data in each leaf of the tree to have an estimated probability that an observation (e.g. person) belongs to a given class.  The **purity of the leaf** can indicate the probability an observation which "reaches that leaf" belongs to a class. In our case, the probability our validation data belong to class 1 (e.g. the customer is likely to purchase a boat) for the first few validation data observations, using the first CART above, is:


```
## Error in predict(CART_tree, estimation_data_nolabel): object 'CART_tree' not found
```

```
## Error in predict(CART_tree_large, estimation_data_nolabel): object 'CART_tree_large' not found
```

```
## Error in predict(CART_tree, validation_data_nolabel): object 'CART_tree' not found
```

```
## Error in predict(CART_tree_large, validation_data_nolabel): object 'CART_tree_large' not found
```

```
## Error in predict(CART_tree, test_data_nolabel): object 'CART_tree' not found
```

```
## Error in predict(CART_tree_large, test_data_nolabel): object 'CART_tree_large' not found
```

```
## Error in as.vector(estimation_Probability_class1_tree > Probability_Threshold): object 'estimation_Probability_class1_tree' not found
```

```
## Error in as.vector(estimation_Probability_class1_tree_large > Probability_Threshold): object 'estimation_Probability_class1_tree_large' not found
```

```
## Error in as.vector(validation_Probability_class1_tree > Probability_Threshold): object 'validation_Probability_class1_tree' not found
```

```
## Error in as.vector(validation_Probability_class1_tree_large > Probability_Threshold): object 'validation_Probability_class1_tree_large' not found
```

```
## Error in as.vector(test_Probability_class1_tree > Probability_Threshold): object 'test_Probability_class1_tree' not found
```

```
## Error in as.vector(test_Probability_class1_tree_large > Probability_Threshold): object 'test_Probability_class1_tree_large' not found
```

```
## Error in rbind(validation_data[, dependent_variable], validation_Probability_class1_tree): object 'validation_Probability_class1_tree' not found
```

```
## Error in rownames(Classification_Table) <- c("Actual Class", "Probability of Class 1"): object 'Classification_Table' not found
```

```
## Error in ncol(Classification_Table): object 'Classification_Table' not found
```

```
## Error in rbind(validation_data[, dependent_variable], validation_Probability_class1_tree): object 'validation_Probability_class1_tree' not found
```

```
## Error in rownames(Classification_Table_large) <- c("Actual Class", "Probability of Class 1"): object 'Classification_Table_large' not found
```

```
## Error in ncol(Classification_Table_large): object 'Classification_Table_large' not found
```

```
## Error in t(round(Classification_Table, 2)): object 'Classification_Table' not found
```

In practice we need to select the **probability threshold** above which we consider an observation as "class 1": this is an important choice that we will discuss below. First we discuss another method widely used, namely logistic regression.

**Logistic Regression** is a method similar to linear regression except that the dependent variable can be discrete (e.g. 0 or 1). **Linear** logistic regression estimates the coefficients of a linear model using the selected independent variables while optimizing a classification criterion. For example, this is the logistic regression parameters for our data:


```
## Warning in model.matrix.default(mt, mf, contrasts): the response appeared
## on the right-hand side and was dropped
```

```
## Warning in model.matrix.default(mt, mf, contrasts): problem with term 1 in
## model.matrix: no columns are assigned
```

```
## Error in eval(expr, envir, enclos): y values must be 0 <= y <= 1
```

```
## Error in summary(logreg_solution): object 'logreg_solution' not found
```

```
## Error in inherits(x, "list"): object 'log_coefficients' not found
```

Given a set of independent variables, the output of the estimated logistic regression (the sum of the products of the independent variables with the corresponding regression coefficients) can be used to assess the probability an observation belongs to one of the classes. Specifically, the regression output can be transformed into a probability of belonging to, say, class 1 for each observation. In our case, the probability our validation data belong to class 1 (e.g. the customer is likely to purchase a boat) for the first few validation data observations, using the logistic regression above, is:


```
## Error in predict(logreg_solution, type = "response", newdata = estimation_data[, : object 'logreg_solution' not found
```

```
## Error in predict(logreg_solution, type = "response", newdata = validation_data[, : object 'logreg_solution' not found
```

```
## Error in predict(logreg_solution, type = "response", newdata = test_data[, : object 'logreg_solution' not found
```

```
## Error in as.vector(estimation_Probability_class1_log > Probability_Threshold): object 'estimation_Probability_class1_log' not found
```

```
## Error in as.vector(validation_Probability_class1_log > Probability_Threshold): object 'validation_Probability_class1_log' not found
```

```
## Error in as.vector(test_Probability_class1_log > Probability_Threshold): object 'test_Probability_class1_log' not found
```

```
## Error in rbind(validation_data[, dependent_variable], validation_Probability_class1_log): object 'validation_Probability_class1_log' not found
```

```
## Error in rownames(Classification_Table) <- c("Actual Class", "Probability of Class 1"): object 'Classification_Table' not found
```

```
## Error in ncol(Classification_Table): object 'Classification_Table' not found
```

```
## Error in t(round(Classification_Table, 2)): object 'Classification_Table' not found
```

The default decision is to classify each observation in the group with the highest probability - but one can change this choice, as we discuss below. 

Selecting the best subset of independent variables for logistic regression, a special case of the general problem of **feature selection**, is an iterative process where both the significance of the regression coefficients as well as the performance of the estimated logistic regression model on the first validation data are used as guidance. A number of variations are tested in practice, each leading to different performances, which we discuss next. 

In our case, we can see the relative importance of the independent variables using the `variable.importance` of the CART trees (see `help(rpart.object)` in R) or the z-scores from the output of logistic regression. For easier visualization, we scale all values between -1 and 1 (the scaling is done for each method separately - note that CART does not provide the sign of the "coefficients"). From this table we can see the **key drivers** of the classification according to each of the methods we used here. 


```
Error in tail(log_coefficients[, "z value", drop = F], -1): object 'log_coefficients' not found
```

```
Error in eval(expr, envir, enclos): object 'log_importance' not found
```

```
Error in eval(expr, envir, enclos): object 'CART_tree' not found
```

```
Error in gsub("\\IV", " ", names(CART_tree$variable.importance)): object 'CART_tree' not found
```

```
Error in eval(expr, envir, enclos): object 'tree_importance' not found
```

```
Error in eval(expr, envir, enclos): object 'log_importance' not found
```

```
Error in eval(expr, envir, enclos): object 'CART_tree_large' not found
```

```
Error in gsub("\\IV", " ", names(CART_tree_large$variable.importance)): object 'CART_tree_large' not found
```

```
Error in eval(expr, envir, enclos): object 'large_tree_importance' not found
```

```
Error in eval(expr, envir, enclos): object 'log_importance' not found
```

```
Error in cbind(tree_importance_final, large_tree_importance_final, log_importance): object 'log_importance' not found
```

```
Error in colnames(Importance_table) <- c("CART 1", "CART 2", "Logistic Regr."): object 'Importance_table' not found
```

```
Error in rownames(log_importance): object 'log_importance' not found
```

```
Error in inherits(x, "list"): object 'Importance_table' not found
```

In general it is not necessary for all methods to agree on the most important drivers: when there is "major" disagreement, particularly among models that have satisfactory performance as discussed next, we may need to reconsider the overall analysis, including the objective of the analysis as well as the data used, as the results may not be robust. **As always, interpreting and using the results of data analytics requires a balance between quantitative and qualitative analysis.** 


## Step 5: Validation accuracy 

Using the predicted class probabilities  of the validation data, as outlined above, we can  generate four basic measures of classification performance. Before discussing them, note that given the probability an observation belongs to a class, **a reasonable class prediction choice is to predict the class that has the highest probability**. However, this does not need to be the only choice in practice.

> Selecting the probability threshold based on which we predict the class of an observation is a decision the user needs to make. While in some cases a reasonable probability threshold is 50%, in other cases it may be 99.9% or 0.01%. Can you think of such cases?

For different choices of the probability threshold, one can measure a number of classification performance metrics, which are outlined next. 

### 1.  Hit ratio
This is simply the percentage of the observations that have been correctly classified (the predicted is the same as the actual class). We can just count the number of the (first) validation data correctly classified and divide this number with the total number of the (fist) validation data, using the two CART and the logistic regression above. These are as follows for the probability threshold  50% for the validation data:


```
## Error in rbind(validation_prediction_class_tree, validation_prediction_class_tree_large, : object 'validation_prediction_class_tree' not found
```

```
## Error in rbind(100 * sum(validation_prediction_class_tree == validation_actual)/length(validation_actual), : object 'validation_prediction_class_tree' not found
```

```
## Error in colnames(validation_hit_rates) <- "Hit Ratio": object 'validation_hit_rates' not found
```

```
## Error in rownames(validation_hit_rates) <- c("First CART", "Second CART", : object 'validation_hit_rates' not found
```

```
## Error in inherits(x, "list"): object 'validation_hit_rates' not found
```

while for the estimation data the hit rates are:

```
## Error in rbind(estimation_prediction_class_tree, estimation_prediction_class_tree_large, : object 'estimation_prediction_class_tree' not found
```

```
## Error in rbind(100 * sum(estimation_prediction_class_tree == estimation_actual)/length(estimation_actual), : object 'estimation_prediction_class_tree' not found
```

```
## Error in colnames(estimation_hit_rates) <- "Hit Ratio": object 'estimation_hit_rates' not found
```

```
## Error in rownames(estimation_hit_rates) <- c("First CART", "Second CART", : object 'estimation_hit_rates' not found
```

```
## Error in inherits(x, "list"): object 'estimation_hit_rates' not found
```

**Why are the performances on the estimation and validation data different? How different can they possibly be? What does this diffference depend on?** Is the Validation Data Hit Rate satisfactory? Which classifier should we use? What should be the benchmark against which to compare the hit rate? 

A simple benchmark to compare the performance of a classification model against is the **Maximum Chance Criterion**. This measures the proportion of the class with the largest size. For our validation data the largest group is people who do not intent do purchase a boat: 0 out of 566 people). Clearly without doing any discriminant analysis, if we classified all individuals into the largest group,  we could get a hit-rate of 0% - without doing any work. One should have a hit rate of at least as much as the the Maximum Chance Criterion rate, although as we discuss next there are more performance criteria to consider. 

### 2. Confusion matrix

The confusion matrix shows for each class the number (or percentage) of the  data that are correctly classified for that class. For example for the method above with the highest hit rate in the validation data (among logistic regression and the 2 CART models), the confusion matrix for the validation data is:


```
## Error in eval(expr, envir, enclos): object 'validation_predictions' not found
```

```
## Error in eval(expr, envir, enclos): object 'validation_prediction_best' not found
```

```
## Error in eval(expr, envir, enclos): object 'validation_prediction_best' not found
```

```
## Error in eval(expr, envir, enclos): object 'validation_prediction_best' not found
```

```
## Error in eval(expr, envir, enclos): object 'validation_prediction_best' not found
```



|         | Predicted 1| Predicted 0|
|:--------|-----------:|-----------:|
|Actual 1 |           0|           0|
|Actual 0 |           0|           0|

Note that the percentages add up to 100% for each row: can you see why? Moreover, a "good" confusion matrix should have large diagonal values and small off-diagonal oens: you see why?

### 3. ROC curve

Remember that each observation is classified by our model according to the probabilities Pr(0) and Pr(1) and a chosen probability threshold. Typically we set the probability threshold to 0.5 - so that observations for which Pr(1) > 0.5 are classified as 1's. However, we can vary this threshold, for example if we are interested in correctly predicting all 1's but do not mind missing some 0's (and vice-versa) - can you think of such a scenario? 

When we change the probability threshold we get different values of hit rate, false positive and false negative rates, or any other performance metric. We can plot for example how the false positive versus true posititive rates change as we alter the probability threshold,  and generate the so called ROC curve. 

The ROC curves for the validation data for both the CARTs above as well as the logistic regression are as follows:


```
## Error in is.data.frame(predictions): object 'validation_Probability_class1_tree' not found
```

```
## Error in is.data.frame(predictions): object 'validation_Probability_class1_tree_large' not found
```

```
## Error in is.data.frame(predictions): object 'validation_Probability_class1_log' not found
```

```
## Error in performance(pred_tree, "tpr", "fpr"): object 'pred_tree' not found
```

```
## Error in as.data.frame(test1@x.values): object 'test1' not found
```

```
## Error in colnames(df1) <- c("False Positive rate CART 1", "True Positive CART 1"): object 'df1' not found
```

```
## Error in ggplot(df1, aes(x = `False Positive rate CART 1`, y = `True Positive CART 1`)): object 'df1' not found
```

```
## Error in performance(pred_log, "tpr", "fpr"): object 'pred_log' not found
```

```
## Error in as.data.frame(test2@x.values): object 'test2' not found
```

```
## Error in colnames(df2) <- c("False Positive rate log reg", "True Positive log reg"): object 'df2' not found
```

```
## Error in ggplot(df2, aes(x = `False Positive rate log reg`, y = `True Positive log reg`)): object 'df2' not found
```

```
## Error in performance(pred_tree_large, "tpr", "fpr"): object 'pred_tree_large' not found
```

```
## Error in as.data.frame(test3@x.values): object 'test3' not found
```

```
## Error in colnames(df3) <- c("False Positive rate CART 2", "True Positive CART 2"): object 'df3' not found
```

```
## Error in ggplot(df3, aes(x = `False Positive rate CART 2`, y = `True Positive CART 2`)): object 'df3' not found
```

```
## Error in lapply(list(df1, df2, df3), function(df) {: object 'df1' not found
```

```
## Error in ggplot(df.all, aes(x = `False Positive rate`, y = value, colour = variable)): object 'df.all' not found
```

How should a good ROC curve look like? A rule of thumb in assessing ROC curves is that the "higher" the curve, hence the larger the area under the curve, the better. You may also select one point on the ROC curve (the "best one" for our purpose) and use that false positive/false negative performances (and corresponding threshold for P(0)) to assess your model. **Which point on the ROC should we select?**

### 4. Lift curve

By changing the probability threshold, we can also generate the so called lift curve, which is useful for certain applications e.g. in marketing or credit risk. For example, consider the case of capturing fraud by examining only a few transactions instead of every single one of them. In this case we may want to examine as few transactions as possible and capture the maximum number of frauds possible. We can measure the percentage of all frauds we capture if we only examine, say, x% of cases (the top x% in terms of Probability(fraud)). If we plot these points [percentage of class 1 captured vs percentage of all data examined] while we change the threshold, we get a curve that is called the **lift curve**. 

The Lift curves for the validation data for our three classifiers are the following:


```
## Error in eval(expr, envir, enclos): object 'validation_Probability_class1_tree' not found
```

```
## Error in unique(c(0, 1, probs)): object 'probs' not found
```

```
## Error in lapply(xaxis, function(prob) {: object 'xaxis' not found
```

```
## Error in data.frame(`CART 1 % of validation data` = res[1, ], `CART 1 % of class 1` = res[2, : object 'res' not found
```

```
## Error in ggplot(frame1, aes(x = `CART 1 % of validation data`, y = `CART 1 % of class 1`)): object 'frame1' not found
```

```
## Error in eval(expr, envir, enclos): object 'validation_Probability_class1_tree_large' not found
```

```
## Error in unique(c(0, 1, probs)): object 'probs' not found
```

```
## Error in lapply(xaxis, function(prob) {: object 'xaxis' not found
```

```
## Error in data.frame(`CART 2 % of validation data` = res[1, ], `CART 2 % of class 1` = res[2, : object 'res' not found
```

```
## Error in ggplot(frame2, aes(x = `CART 2 % of validation data`, y = `CART 2 % of class 1`)): object 'frame2' not found
```

```
## Error in eval(expr, envir, enclos): object 'validation_Probability_class1_log' not found
```

```
## Error in unique(c(0, 1, probs)): object 'probs' not found
```

```
## Error in lapply(xaxis, function(prob) {: object 'xaxis' not found
```

```
## Error in data.frame(`log reg % of validation data` = res[1, ], `log reg % of class 1` = res[2, : object 'res' not found
```

```
## Error in ggplot(frame3, aes(x = `log reg % of validation data`, y = `log reg % of class 1`)): object 'frame3' not found
```

```
## Error in lapply(list(frame1, frame2, frame3), function(df) {: object 'frame1' not found
```

```
## Error in ggplot(df.all, aes(x = `Percent of validation data`, y = value, : object 'df.all' not found
```

How should a good Lift Curve look like? Notice that if we were to randomly examine transactions, **the "random prediction" lift curve would be a 45 degrees straight diagonal line** (why?)! So the further **above** this 45 degrees line our Lift curve is, the better the "lift". Moreover, much like for the ROC curve, one can select the probability threshold appropriately so that any point of the lift curve is selected. **Which point on the lift curve should we select in practice?** 

### 5. Profit Curve 

Finally, we can generate the so called profit curve, which we often use to make our final decisions.  The intuition is as follows. Consider a direct marketing campaign, and suppose it costs $ 1 to send an advertisement, and the expected profit from a person who responds positively is $45. Suppose you have a database of 1 million people to whom you could potentially send the ads. What fraction of the 1 million people should you send ads (typical response rates are 0.05%)? To answer this type of questions we need to create the profit curve, which is generated by changing again the probability threshold for classifying observations: for each threshold value we can simply measure the total **Expected Profit** (or loss) we would generate. This is simply equal to:

> Total Expected Profit = (% of 1's correctly predicted)x(value of capturing a 1) + (% of 0's correctly predicted)x(value of capturing a 0) + (% of 1's incorrectly predicted as 0)x(cost of missing a 1) + (% of 0's incorrectly predicted as 1)x(cost of missing a 0)
> 
> Calculating the expected profit requires we have an estimate of the 4 costs/values: value of capturing a 1 or a 0, and cost of misclassifying a 1 into a 0 or vice versa. 

Given the values and costs of correct classifications and misclassifications, we can plot the total expected profit (or loss) as we change the probabibility threshold, much like how we generated the ROC and the Lift Curves. Here is the profit curve for our example if we consider the following business profit and loss for the correctly classified as well as the misclassified customers: 


|         | Predict 1| Predict 0|
|:--------|---------:|---------:|
|Actual 1 |       100|       -75|
|Actual 0 |       -50|         0|

Based on these profit and cost estimates, the profit curves for the validation data for the three classifiers are:


```
## Error in eval(expr, envir, enclos): object 'validation_Probability_class1_tree' not found
```

```
## Error in unique(c(0, 1, probs)): object 'probs' not found
```

```
## Error in lapply(xaxis, function(prob) {: object 'xaxis' not found
```

```
## Error in data.frame(`CART 1 % selected` = res[1, ], `CART 1 est. profit` = res[2, : object 'res' not found
```

```
## Error in ggplot(frame1, aes(x = `CART 1 % selected`, y = `CART 1 est. profit`)): object 'frame1' not found
```

```
## Error in eval(expr, envir, enclos): object 'validation_Probability_class1_tree_large' not found
```

```
## Error in unique(c(0, 1, probs)): object 'probs' not found
```

```
## Error in lapply(xaxis, function(prob) {: object 'xaxis' not found
```

```
## Error in data.frame(`CART 2 % selected` = res[1, ], `CART 2 est. profit` = res[2, : object 'res' not found
```

```
## Error in ggplot(frame2, aes(x = `CART 2 % selected`, y = `CART 2 est. profit`)): object 'frame2' not found
```

```
## Error in eval(expr, envir, enclos): object 'validation_Probability_class1_log' not found
```

```
## Error in unique(c(0, 1, probs)): object 'probs' not found
```

```
## Error in lapply(xaxis, function(prob) {: object 'xaxis' not found
```

```
## Error in data.frame(`log reg % selected` = res[1, ], `log reg est. profit` = res[2, : object 'res' not found
```

```
## Error in ggplot(frame3, aes(x = `log reg % selected`, y = `log reg est. profit`)): object 'frame3' not found
```

```
## Error in lapply(list(frame1, frame2, frame3), function(df) {: object 'frame1' not found
```

```
## Error in ggplot(df.all, aes(x = `Percent selected`, y = value, colour = variable)): object 'df.all' not found
```

We can then select the threshold that corresponds to the maximum expected profit (or minimum loss, if necessary). 

Notice that for us to maximize expected profit we need to have the cost/profit for each of the 4 cases! This can be difficult to assess, hence typically some sensitivity analysis to our assumptions about the cost/profit needs to be done: for example, we can generate different profit curves (i.e. worst case, best case, average case scenarios) and see how much the best profit we get varies, and most important **how our selection of the classification model and of the probability threshold vary** as these are what we need to eventually decide. 


## Step 6: Test Accuracy

Having iterated steps 2-5 until we are satisfyed with the performance of our selected model on the validation data, in this step the performance analysis outlined in step 5 needs to be done with the test sample. This is the performance that "best mimics" what one should expect in practice upon deployment of the classification solution, **assuming (as always) that the data used for this performance analysis are representative of the situation in which the solution will be deployed.** 

Let's see in our case how the **Confusion Matrix, ROC Curve, Lift Curve, and Profit Curve** look like for our test data. **Will the performance in the test data be similar to the performance in the  validation data above? More important: should we expect the performance of our classification model to be close to that in our test data when we deploy the model in practice? Why or why not? What should we do if they are different?**


```
## Error in rbind(test_prediction_class_tree, test_prediction_class_tree_large, : object 'test_prediction_class_tree' not found
```

```
## Error in rbind(100 * sum(test_prediction_class_tree == test_actual)/length(test_actual), : object 'test_prediction_class_tree' not found
```

```
## Error in colnames(test_hit_rates) <- "Hit Ratio": object 'test_hit_rates' not found
```

```
## Error in rownames(test_hit_rates) <- c("First CART", "Second CART", "Logistic Regression"): object 'test_hit_rates' not found
```

```
## Error in inherits(x, "list"): object 'test_hit_rates' not found
```

The Confusion Matrix for the model with the best validation data hit ratio above:


```
## Error in eval(expr, envir, enclos): object 'test_predictions' not found
```

```
## Error in eval(expr, envir, enclos): object 'test_prediction_best' not found
```

```
## Error in eval(expr, envir, enclos): object 'test_prediction_best' not found
```

```
## Error in eval(expr, envir, enclos): object 'test_prediction_best' not found
```

```
## Error in eval(expr, envir, enclos): object 'test_prediction_best' not found
```



|         | Predicted 1| Predicted 0|
|:--------|-----------:|-----------:|
|Actual 1 |           0|           0|
|Actual 0 |           0|           0|

ROC curves for the test data:


```
## Error in is.data.frame(predictions): object 'test_Probability_class1_tree' not found
```

```
## Error in is.data.frame(predictions): object 'test_Probability_class1_tree_large' not found
```

```
## Error in is.data.frame(predictions): object 'test_Probability_class1_log' not found
```

```
## Error in performance(pred_tree_test, "tpr", "fpr"): object 'pred_tree_test' not found
```

```
## Error in as.data.frame(test@x.values): trying to get slot "x.values" from an object of a basic class ("function") with no slots
```

```
## Error in colnames(df1) <- c("False Positive rate CART 1", "True Positive CART 1"): object 'df1' not found
```

```
## Error in performance(pred_tree_large_test, "tpr", "fpr"): object 'pred_tree_large_test' not found
```

```
## Error in as.data.frame(test2@x.values): object 'test2' not found
```

```
## Error in colnames(df2) <- c("False Positive rate CART 2", "True Positive CART 2"): object 'df2' not found
```

```
## Error in performance(pred_log_test, "tpr", "fpr"): object 'pred_log_test' not found
```

```
## Error in as.data.frame(test1@x.values): object 'test1' not found
```

```
## Error in colnames(df3) <- c("False Positive rate log reg", "True Positive log reg"): object 'df3' not found
```

```
## Error in lapply(list(df1, df2, df3), function(df) {: object 'df1' not found
```

```
## Error in ggplot(df.all, aes(x = `False Positive rate`, y = value, colour = variable)): object 'df.all' not found
```

Lift Curves for the test data:


```
## Error in eval(expr, envir, enclos): object 'test_Probability_class1_tree' not found
```

```
## Error in unique(c(0, 1, probs)): object 'probs' not found
```

```
## Error in lapply(xaxis, function(prob) {: object 'xaxis' not found
```

```
## Error in data.frame(`CART 1 % of validation data` = res[1, ], `CART 1 % of class 1` = res[2, : object 'res' not found
```

```
## Error in eval(expr, envir, enclos): object 'test_Probability_class1_tree_large' not found
```

```
## Error in unique(c(0, 1, probs)): object 'probs' not found
```

```
## Error in lapply(xaxis, function(prob) {: object 'xaxis' not found
```

```
## Error in data.frame(`CART 2 % of validation data` = res[1, ], `CART 2 % of class 1` = res[2, : object 'res' not found
```

```
## Error in eval(expr, envir, enclos): object 'test_Probability_class1_log' not found
```

```
## Error in unique(c(0, 1, probs)): object 'probs' not found
```

```
## Error in lapply(xaxis, function(prob) {: object 'xaxis' not found
```

```
## Error in data.frame(`log reg % of validation data` = res[1, ], `log reg % of class 1` = res[2, : object 'res' not found
```

```
## Error in lapply(list(frame1, frame2, frame3), function(df) {: object 'frame1' not found
```

```
## Error in ggplot(df.all, aes(x = `Percent of test data`, y = value, colour = variable)): object 'df.all' not found
```

Finally the profit curves for the test data, using the same profit/cost estimates as we did above:


```
## Error in eval(expr, envir, enclos): object 'test_Probability_class1_tree' not found
```

```
## Error in unique(c(0, 1, probs)): object 'probs' not found
```

```
## Error in lapply(xaxis, function(prob) {: object 'xaxis' not found
```

```
## Error in data.frame(`CART 1 % selected` = res[1, ], `CART 1 est. profit` = res[2, : object 'res' not found
```

```
## Error in eval(expr, envir, enclos): object 'test_Probability_class1_tree_large' not found
```

```
## Error in unique(c(0, 1, probs)): object 'probs' not found
```

```
## Error in lapply(xaxis, function(prob) {: object 'xaxis' not found
```

```
## Error in data.frame(`CART 2 % selected` = res[1, ], `CART 2 est. profit` = res[2, : object 'res' not found
```

```
## Error in eval(expr, envir, enclos): object 'test_Probability_class1_log' not found
```

```
## Error in unique(c(0, 1, probs)): object 'probs' not found
```

```
## Error in lapply(xaxis, function(prob) {: object 'xaxis' not found
```

```
## Error in data.frame(`log reg % selected` = res[1, ], `log reg est. profit` = res[2, : object 'res' not found
```

```
## Error in lapply(list(frame1, frame2, frame3), function(df) {: object 'frame1' not found
```

```
## Error in ggplot(df.all, aes(x = `Percent selected`, y = value, colour = variable)): object 'df.all' not found
```


# What if we consider a segment-specific analysis?

Often our data (e.g. people) belong to different segments. In such cases, if we perform the classification analysis using all segments together we may not be able to find good quality models or strong classification drivers. 

> When we believe our observations belong in different segments, we should perform the classification and drivers analysis for each segment separately. 

Indeed, in this case with some more effort one can improve the profit of the firm by more than 5% when using a segment specific analysis - which one can do based on all the readings of the class. 

Of course, as always, remember that 

> Data Analytics is an iterative process, therefore we may need to return to our original raw data at any point and select new raw attributes as well as a different classification tool and model.

