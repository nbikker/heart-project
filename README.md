# Heart Failure Project

### About the dataset
This project's goal is to predict what causes death by heart failure. Heart failure is the number 1 cause of death world wide, accounting for 31% of global deaths. Heart failure can occur when the heart can't pump enough blood to the rest of the body. This data set consists of 299 patients and 13 different variables that can be used to predict mortality by heart failure. These variables include age, sex, anaemia, creatinine phosphokinase, diabetes, ejection fraction, high blood pressure, platelets, serum creatinine, serum sodium, time, whether they smoke or not, and if they died. This data set includes binary variables (0 and 1). For anaemia, diabetes, high blood pressure, and smoking, 0 means false and 1 means true. For sex, 0 means female and 1 means male. For death event, 0 means they survived and 1 means they died.

### Methods used 
First, important libraries I used for this data set were `ggplot2` for visualizations, `survival` and `survminer` for the cox plot, and `caret` for logistic regression. To analyze this data set, I first wanted to create visualizations to better understand the data. From there, I wanted to use regression models to determine which variables would be most significant in predicting death by heart failure. To start off, I used the `ggplot2` library in R to create boxplots and observe any outliers and analyze the means based on death event. <br />
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
This is a basic cox plot and shows the survival probability as time increases. As expected, survival decreases as time increases.
