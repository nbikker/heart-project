# heart failure is the #1 cause of death world wide. it accounts for 31% of global deaths
# This .r analyzes a dataset that has 12 features that can be used to predict heart failure
# it intoduces a cox regression model as well as a logistic regression model
# i wanted to see how the different regression models produced diff. results


# working hyppthesis
# from this data i hypothesize that anaemia, high blood pressure, serum creatinine,
# serum sodium, and obviously time as being the best predictors of heart failure by death


# difficulties with the project 
# the biggest difficulties i am having with this project is trying to implement 
# different things like knn and maybe naive bayes
# also, looking for a different dataset is very difficult 

# import data I am using
df <- read.csv('~/cds 490/heart_failure_project.csv')

# load libraries
library(tidyverse)
library(ggplot2)
library(dplyr)
# survival and survminer will be used for cox plot
library(survival)
library(survminer)
library(caret)

# view data
summary(df)

# Now we will use ggplot2 to create boxplots to observe outliers

# Age by death event 
graph_age <- ggplot(df, aes(x=DEATH_EVENT, y=age, group=DEATH_EVENT)) +
  geom_boxplot(aes(fill=DEATH_EVENT),outlier.colour = 'red')
graph_age + ggtitle("Age by Death Event") + theme_classic() 

# creatinine phosphokinase by death event
graph_cph <- ggplot(df, aes(x=DEATH_EVENT, y=creatinine_phosphokinase, group=DEATH_EVENT)) +
  geom_boxplot(aes(fill=DEATH_EVENT), outlier.colour = 'red')
graph_cph + ggtitle("Creatinine Phosphokinase by Death Event") + theme_classic()
# as you can see, this plot has a large amount of outliers 

# ejection fraction by death event
graph_ef <- ggplot(df, aes(x=DEATH_EVENT, y=ejection_fraction, group=DEATH_EVENT)) +
  geom_boxplot(aes(fill=DEATH_EVENT), outlier.colour = 'red')
graph_ef + ggtitle("Ejeection Fraction by Death Event") + theme_classic()

# Platelets by death event
graph_platelets <- ggplot(df, aes(x=DEATH_EVENT, y=platelets, group=DEATH_EVENT)) +
  geom_boxplot(aes(fill=DEATH_EVENT), outlier.colour = 'red')
graph_platelets + ggtitle("Platelets by Death Event") + theme_classic()

# serum creatinine by death event
graph_sc <- ggplot(df, aes(x=DEATH_EVENT, y=serum_creatinine, group=DEATH_EVENT)) +
  geom_boxplot(aes(fill=DEATH_EVENT), outlier.colour = 'red')
graph_sc + ggtitle("Serum Creatinine by Death Event") + theme_classic()

# serum sodium by death event
graph_ss <- ggplot(df, aes(x=DEATH_EVENT, y=serum_sodium, group=DEATH_EVENT)) +
  geom_boxplot(aes(fill=DEATH_EVENT), outlier.colour = 'red')
graph_ss + ggtitle("Serum Sodium by Death Event") + theme_classic()

# time by death event
graph_time <- ggplot(df, aes(x=DEATH_EVENT, y=time, group=DEATH_EVENT)) +
  geom_boxplot(aes(fill=DEATH_EVENT), outlier.colour = 'red')
graph_time + ggtitle("Time by Death Event") + theme_classic()

# based off of these plots, the plots with the least outliers seem to be time and age
# this can indicate that these are the biggest factors when it comes to predicting death
# also, some of the plots the mean seems to differ. In the time plot, the means are at different levels.

# histogram of age
with(df, hist(age))
# gives basic understanding of age with this data set


# more visualizations

sc_plt <- ggplot(data=df, aes(x=serum_creatinine, y=age,fill = DEATH_EVENT)) + geom_point()+geom_smooth()
sc_plt

time_plt <- ggplot(data=df,aes(x = time, colour = DEATH_EVENT)) + 
  geom_density() + 
  ggtitle("Distribution of time to death") + 
  theme_classic()
time_plt

# cox formula
# this formula is a regression of time and death based off the factors specified
cox<-coxph(Surv(time,DEATH_EVENT)~age+sex+anaemia+serum_sodium+
                   creatinine_phosphokinase+ejection_fraction+diabetes+
                   high_blood_pressure+smoking+serum_creatinine,data=df)
summary(cox)
# the hazard ratio is the exp(coef) in this summary.
# any exp(coef) that is greater than 1 indicates an increase in the hazard as the covariate rises
# anaemia and high blood pressure were two of the highest exp(coef)
# this could indicate that they play a large role in predicting death from heart failure

#cox plot
plot1=ggsurvplot(survfit(heart.cox,data=df),palette = 'darkred',
                 ggtheme=theme_classic())
plot1
# This is a basic plot showing the survival probability as time increases
# as expected, the chance of surviving from heart failure decreases with time


# high blood pressure cox
high_blood_pressure=with(df,data.frame(high_blood_pressure=c(0,1), anaemia=c(0,0), age=rep(mean(age),2), sex=c(0,0),
                                                   serum_sodium=rep(mean(serum_sodium),2), ejection_fraction=rep(mean(ejection_fraction),2),
                                                   creatinine_phosphokinase=rep(mean(creatinine_phosphokinase),2),
                                                   diabetes=c(0,0),smoking=c(0,0),
                                                   serum_creatinine=rep(mean(serum_creatinine),2)))

fit1=survfit(heart.cox,newdata=high_blood_pressure)  
hypertension_plot=ggsurvplot(fit1, high_blood_pressure, legend.labs=c("HighBloodpressure1","HighBloodpressure2"),ggtheme = theme_tufte())
hypertension_plot
# This cox plot shows how high blood pressure over time affects the survival probability
# The plot shows that males have a lower chance of survival with high blood pressure


# Now i am going to create a logistic regression model
set.seed(1234)

# first i split the data into a training and test set
# i used an 80:20 split 
train <- sample(1:nrow(df), round(0.8 * nrow(df), digits = 0))
test <- setdiff(1:nrow(df), train)

# logistic regression model using glm function
logistic_regression <- glm(formula = DEATH_EVENT ~ ., data = df[train, ], family = "binomial")
summary(logistic_regression)
# from the summary statistics, age, ejection fraction, serum creatinine, 
# serum sodium, and time are significant predictors
# these are significant because p-value is less than 0.05

# I plan to validate my results using cross-validataion
# like i have done, I will split the data into training and test set
# My goal is to predict the accuracy of the model. I am hoping to have 
# an accuracy of at least 85% to show that it is a reliable model.
# another way I could validate my results is through comparing them to another
# data set. However, I am having a hard time searching for another data set
# that compares well to the one I have now.


