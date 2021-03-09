# Heart Failure Project

### About the dataset
This project's goal is to predict what causes death by heart failure. Heart failure is the number 1 cause of death world wide, accounting for 31% of global deaths. Heart failure can occur when the heart can't pump enough blood to the rest of the body. This data set consists of 299 patients and 13 different variables that can be used to predict mortality by heart failure. These variables include age, sex, anaemia, creatinine phosphokinase, diabetes, ejection fraction, high blood pressure, platelets, serum creatinine, serum sodium, time, whether they smoke or not, and if they died. This data set includes binary variables (0 and 1). For anaemia, diabetes, high blood pressure, and smoking, 0 means false and 1 means true. For sex, 0 means female and 1 means male. For death event, 0 means they survived and 1 means they died.

### Methods used 
First, important libraries I used for this data set were `ggplot2` for visualizations, `survival` and `survminer` for the cox plot, and `caret` for logistic regression. To analyze this data set, I first wanted to create visualizations to better understand the data. From there, I wanted to use statistical methods such as regression models to determine which variables would be most significant in predicting death by heart failure. To start off, I used the `ggplot2` library in R to create boxplots and observe any outliers and analyze the means based on death event. <br />
###### *code for box plot*
```
graph_age <- ggplot(df, aes(x=DEATH_EVENT, y=age, group=DEATH_EVENT)) +
  geom_boxplot(aes(fill=DEATH_EVENT),outlier.colour = 'red')
graph_age + ggtitle("Age by Death Event") + theme_classic() 
```
![age_box](https://user-images.githubusercontent.com/47092306/110375136-8ba32b00-801f-11eb-9df9-255bf18626ec.png) <br />
As you can see, this box plot shows only one outlier. Also, I noticed that the average age of a patient if they died was only slightly higher than if they survived. I created box plots for all of the variables, and many of them had a lot of outliers. Here is an example of the box plot "Platelets by death event" which included numerous outliers.
```
graph_platelets <- ggplot(df, aes(x=DEATH_EVENT, y=platelets, group=DEATH_EVENT)) +
  geom_boxplot(aes(fill=DEATH_EVENT), outlier.colour = 'red')
graph_platelets + ggtitle("Platelets by Death Event") + theme_classic()
```
![platelets_box](https://user-images.githubusercontent.com/47092306/110376294-06b91100-8021-11eb-9054-06afc72d0a37.png) <br />
This box plot clearly has more outliers than the age plot. After creating all the different box plots, the plots with the least amount of outliers were time and age. This could indicate that time and age are significant factors when it comes to predicting death. Also, in some of the plots, the means are dramatically different. The time plot you can see the mean for if the patient died is extremely lower than if they did not die, which makes sense. <br />
Next, I wanted to start with my regression models. I decided to use cox regression and logistic regression to find significant variables and I wanted to see how the different regression models gave different results. I decided to use cox regression first because we are analyzing the outcome of death from heart failure. It can be used to investigate the survival time of patients in this data set and one or more of the variables. I created a formula for cox given the specific variables, and looked at the summary to find significant variables. 
```
cox<-coxph(Surv(time,DEATH_EVENT)~age+sex+anaemia+serum_sodium+
                   creatinine_phosphokinase+ejection_fraction+diabetes+
                   high_blood_pressure+smoking+serum_creatinine,data=df)
summary(cox)
```
Here are the results from the summary
```
                             coef  exp(coef)   se(coef)      z Pr(>|z|)    
age                       0.0458869  1.0469560  0.0092074  4.984 6.24e-07 ***
sex                      -0.2177957  0.8042897  0.2464650 -0.884   0.3769    
anaemia                   0.4580205  1.5809414  0.2167654  2.113   0.0346 *  
serum_sodium             -0.0448337  0.9561565  0.0231985 -1.933   0.0533 .  
creatinine_phosphokinase  0.0002198  1.0002198  0.0000989  2.222   0.0263 *  
ejection_fraction        -0.0488823  0.9522932  0.0104769 -4.666 3.08e-06 ***
diabetes                  0.1330636  1.1423226  0.2226422  0.598   0.5501    
high_blood_pressure       0.4697306  1.5995632  0.2156587  2.178   0.0294 *  
smoking                   0.1141273  1.1208948  0.2480591  0.460   0.6455    
serum_creatinine          0.3231991  1.3815404  0.0698266  4.629 3.68e-06 ***
```
In cox regression, the exp(coef) is the hazard ratio. Any exp(coef) that is greater than 1 indicates that there is an increase in the hazard as the covariate rises. As you can see from the summary, high_blood_pressure and anaemia had the highest exp(coef), indicating that they could play a large role in predicting death by heart failure. Next, I wanted to visualize the cox regression in a plot. <br />
###### *code for cox plot*
```
plot1=ggsurvplot(survfit(heart.cox,data=df),palette = 'darkred',
                 ggtheme=theme_classic())
plot1
``` 
![cox](https://user-images.githubusercontent.com/47092306/110376707-83e48600-8021-11eb-857b-aa22f809f95a.png) <br />
This is a basic cox plot and shows the survival probability as time increases. As expected, survival decreases as time increases. Next, I made a cox regression plot observing how high blood pressure over time affects the survival probability.
```
high_blood_pressure=with(df,data.frame(high_blood_pressure=c(0,1), anaemia=c(0,0), age=rep(mean(age),2), sex=c(0,0),
                         serum_sodium=rep(mean(serum_sodium),2), ejection_fraction=rep(mean(ejection_fraction),2),
                         creatinine_phosphokinase=rep(mean(creatinine_phosphokinase),2),
                         diabetes=c(0,0),smoking=c(0,0),
                         serum_creatinine=rep(mean(serum_creatinine),2)))

fit1=survfit(heart.cox,newdata=high_blood_pressure)  
hypertension_plot=ggsurvplot(fit1, high_blood_pressure, legend.labs=c("HighBloodpressure1","HighBloodpressure2"),ggtheme = theme_classic())
hypertension_plot
```
![cox_bloodpressure](https://user-images.githubusercontent.com/47092306/110376726-88a93a00-8021-11eb-993f-d2c302f7f6b8.png) <br />
As you can see from the plot, males have a lower chance of survival when they have high blood pressure (hypertension). <br />
Next, I created a logistic regression model using the glm function in R. 
```
logistic_regression <- glm(formula = DEATH_EVENT ~ ., data = df[train, ], family = "binomial")
summary(logistic_regression)
```
```

Coefficients:
                           Estimate Std. Error z value Pr(>|z|)    
(Intercept)               1.083e+01  5.986e+00   1.810 0.070359 .  
age                       4.560e-02  1.748e-02   2.608 0.009097 ** 
anaemia                   2.685e-01  4.081e-01   0.658 0.510539    
creatinine_phosphokinase  3.031e-04  1.905e-04   1.591 0.111642    
diabetes                  1.165e-01  3.909e-01   0.298 0.765620    
ejection_fraction        -7.742e-02  1.856e-02  -4.171 3.04e-05 ***
high_blood_pressure      -2.096e-01  4.254e-01  -0.493 0.622308    
platelets                -1.680e-06  2.077e-06  -0.809 0.418551    
serum_creatinine          7.129e-01  2.057e-01   3.466 0.000528 ***
serum_sodium             -7.302e-02  4.256e-02  -1.716 0.086205 .  
sex                      -5.067e-01  4.614e-01  -1.098 0.272135    
smoking                  -2.647e-01  4.524e-01  -0.585 0.558429    
time                     -1.812e-02  3.190e-03  -5.679 1.35e-08 ***
```
When looking at a regression model, you can spot significant variables by observing the p-value. If the p-value is less than 0.05, it indicates that the variable is significant. From the summary statistics, we can see that age, ejection fraction, serum creatinine, and time are significant predictors. <br />
### Results
These results from the regression models show that serum creatinine, ejection fraction, high blood pressure, anaemia, age and time as being the best predictors for death by heart failure. Based on the significant values, I believe serum creatine, ejection fraction and high blood pressure are the most significant. These results can help by being a tool used to help doctors understand if a patient will survive or not by focusing on these key variables. <br />
### Citation of data set
Davide Chicco, Giuseppe Jurman: Machine learning can predict survival of patients with heart failure from serum creatinine and ejection fraction alone. BMC Medical Informatics and Decision Making 20, 16 (2020).
