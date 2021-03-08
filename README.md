# Heart Failure Project

### About the dataset
This project's goal is to predict what causes death by heart failure. Heart failure is the number 1 cause of death world wide, accounting for 31% of global deaths. Heart failure can occur when the heart can't pump enough blood to the rest of the body. This data set consists of 299 patients and 13 different variables that can be used to predict mortality by heart failure. These variables include age, sex, anaemia, creatinine phosphokinase, diabetes, ejection fraction, high blood pressure, platelets, serum creatinine, serum sodium, time, whether they smoke or not, and if they died. This data set includes binary variables (0 and 1). For anaemia, diabetes, high blood pressure, and smoking, 0 means false and 1 means true. For sex, 0 means female and 1 means male. For death event, 0 means they survived and 1 means they died.

### Methods used 
To analyze this data set, I first wanted to create visualizations to better understand the data. From there, I wanted to use regression models to determine which variables would be most significant in predicting death by heart failure. To start off, I used the ggplot2 library in R to create boxplots and observe any outliers and analyze the means based on death event. <br />
###### *code for box plot*
```
graph_age <- ggplot(df, aes(x=DEATH_EVENT, y=age, group=DEATH_EVENT)) +
  geom_boxplot(aes(fill=DEATH_EVENT),outlier.colour = 'red')
graph_age + ggtitle("Age by Death Event") + theme_classic() 
```
![age_box](https://user-images.githubusercontent.com/47092306/110375136-8ba32b00-801f-11eb-9df9-255bf18626ec.png) <br />
As you can see, this box plot shows only one outlier. I created box plots for all of the variables, and many of them had a lot of outliers. Here is an example of the box plot "Platelets by death event" which included numerous outliers.
```
graph_platelets <- ggplot(df, aes(x=DEATH_EVENT, y=platelets, group=DEATH_EVENT)) +
  geom_boxplot(aes(fill=DEATH_EVENT), outlier.colour = 'red')
graph_platelets + ggtitle("Platelets by Death Event") + theme_classic()
```
