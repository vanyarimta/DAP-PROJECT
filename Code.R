

###~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Import Data#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
getwd()
data = read.csv('/Users/promac/Downloads/DAP PROJECT FIX/airlinedata.csv')

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Data Exploration#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
str(data)
View(summary(data))

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Data Cleaning#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
library(dplyr)
data= data%>%select(-'X', -'id')

##Transforming categorical variables to factor class
str(data)
summary(data)
data = data%>%
  mutate(Gender = factor(Gender),
         Customer.Type = factor(Customer.Type),
         Type.of.Travel = factor(Type.of.Travel),
         Class = factor(Class),
         Inflight.wifi.service = factor(Inflight.wifi.service),
         Departure.Arrival.time.convenient = factor(Departure.Arrival.time.convenient),
         Ease.of.Online.booking = factor(Ease.of.Online.booking),
         Gate.location = factor(Gate.location),
         Food.and.drink = factor(Food.and.drink),
         Online.boarding = factor(Online.boarding),
         Seat.comfort = factor(Seat.comfort),
         Inflight.entertainment = factor(Inflight.entertainment),
         On.board.service = factor(On.board.service),
         Leg.room.service = factor(Leg.room.service),
         Baggage.handling = factor(Baggage.handling),
         Checkin.service = factor(Checkin.service),
         Inflight.service = factor(Inflight.service),
         Cleanliness = factor(Cleanliness))


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Recoding categorical variables into numbers
data = data%>%mutate(satisfaction = factor(satisfaction, levels=c('satisfied','neutral or dissatisfied'), 
                                           labels=c("0", "1")))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Correlation Analysis~~~~~~~~~~~~~~~~~~~~~~~~~~~
#correlation analysis data preparation
library(reshape2)
matrix_data = data.matrix(data)
View(head(matrix_data))
realmatrix=cor(na.omit(matrix_data))
realmatrix
cormat <- round(cor(matrix_data),2)
View(head(cormat))
melted_cormat <- melt(realmatrix)
head(melted_cormat)

#correlation heatmap
ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile(color = 'white')+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()+ 
  geom_text(aes(Var2, Var1, label = sprintf(value, fmt = '%#.2f') ), color = "black", size = 3.8) +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank())+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1)) +
  theme(axis.text.y = element_text(size = 12))


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Finding missing values~~~~~~~~~~~~~~~~~~~~~
library(DataExplorer)
plot_missing(data)
colSums(is.na(data))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Imputing missing values ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
data = data %>%
  mutate(Arrival.Delay.in.Minutes= coalesce(Arrival.Delay.in.Minutes ,Departure.Delay.in.Minutes))
colSums(is.na(data))

##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Removal of highly correlated features~~~~~~~~~~~~~~~~~~~~~
data= data%>%select(-'Arrival.Delay.in.Minutes')


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~EDA~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#1. Barplot of target variable 
satisfaction_plot = as.data.frame(table(data$satisfaction))
print(satisfaction_plot)
names(satisfaction_plot) = c('col1', 'col2')

satisfaction_plot %>% 
  count(Satisfaction = factor(col1), Frequency = col2) %>% 
  mutate(Percentage = prop.table(Frequency)) %>% 
  ggplot(aes(x = Satisfaction, y = Percentage, fill = Frequency, label = scales::percent(Percentage))) + 
  geom_col(position = 'dodge') + 
  geom_text( vjust = 0) + 
  scale_y_continuous(labels = scales::percent)

#2. Barplot of customer type vs satisfaction level
ggplot(data, aes(x = Customer.Type, fill = satisfaction)) +
  geom_bar(stat='Count', position='dodge') +
  labs(x = 'Type of Customer')+
  guides(fill = guide_legend(title.position="top", title ="Satisfaction") ) + 
  scale_fill_brewer(palette = "Set1", labels = c("0(Satisfied)", "1(Neutral/Dissastisfied)"))

#3. Barplot of travel class vs satisfaction level
ggplot(data, aes(x = Class, fill = satisfaction)) +
  geom_bar(stat='Count', position='dodge') +
  labs(x = 'Travel Class')+
  guides(fill = guide_legend(title.position="top", title ="Satisfaction") ) + 
  scale_fill_brewer(palette = "Set1", labels = c("0(Satisfied)", "1(Neutral/Dissastisfied)"))

#4. Barplot of Type of Travel vs satisfaction level
ggplot(data, aes(x = Type.of.Travel, fill = satisfaction)) +
  geom_bar(stat='Count', position='dodge') +
  labs(x = 'Type of Travel', y = 'No. Of Passengers' )+
  guides(fill = guide_legend(title.position="top", title ="Satisfaction") ) + 
  scale_fill_brewer(palette = "Set1", labels = c("0(Satisfied)", "1(Neutral/Dissastisfied)"))+
  coord_flip()

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Data Partition~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#dividing data set into train and test
library(caTools)
set.seed(1234)
split = sample.split(data$satisfaction, SplitRatio = 0.8)
training_set = subset(data, split == TRUE)
test_set = subset(data, split == FALSE)

#check proportion of target variable 
prop.table(table(data$satisfaction))
prop.table(table(training_set$satisfaction))
prop.table(table(test_set$satisfaction))


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Building SVM Model~~~~~~~WARNING : BUILDING THIS MODEL WILL TAKE TIME~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(kernlab)
library(e1071)
library(caret)
classifier = ksvm(satisfaction~., data = training_set, kernel = "vanilladot")
classifier

#predicting the model with training data
predict_train = predict(classifier, training_set)

#evaluating model prediction with confusion matrix
cm_vanilladot = table(predict_train, training_set$satisfaction)
confusionMatrix(cm_vanilladot)

#predicting the model with test data
predict_test = predict(classifier, test_set)

#evaluating model prediction with confusion matrix
cm = table(predict_test, test_set$satisfaction)
confusionMatrix(cm)

#building svm model with rbf kernel 
classifier_rbf = ksvm(satisfaction~., data = training_set,
                  kernel = 'rbfdot')  
classifier_rbf

#predicting the model with training data
predict_train_rbf = predict(classifier_rbf, training_set)

#evaluating model prediction with confusion matrix
cm_train_rbf = table(predict_train_rbf, training_set$satisfaction)
confusionMatrix(cm_train_rbf)

#predicting the model with test data
predict_test_rbf = predict(classifier_rbf, test_set)

#evaluating model prediction with confusion matrix
cm_rbf = table(predict_test_rbf, test_set$satisfaction)
confusionMatrix(cm_rbf)

#building svm model with tanhdot
classifier_tanhdot = ksvm(satisfaction~., data = training_set,
                      kernel = 'tanhdot')  
classifier_tanhdot

#predicting the model with training data
predict_train_tanhdot = predict(classifier_tanhdot, training_set)

#evaluating model prediction with confusion matrix
cm_tanhdot_train = table(predict_train_tanhdot, training_set$satisfaction)
confusionMatrix(cm_tanhdot_train)

#predicting the model with test data
predict_test_tanhdot = predict(classifier_tanhdot, test_set)

#evaluating model prediction with confusion matrix
cm_tanhdot = table(predict_test_tanhdot, test_set$satisfaction)
confusionMatrix(cm_tanhdot)

#building svm model with polydot
classifier_polydot = ksvm(satisfaction~., data = training_set,
                          kernel = 'polydot')  
classifier_polydot

#predicting the model with training data
predict_train_polydot = predict(classifier_polydot, training_set)

#evaluating model prediction with confusion matrix
cm_polydot_train = table(predict_train_polydot, training_set$satisfaction)
confusionMatrix(cm_polydot_train)

#predicting the model with test data
predict_test_polydot = predict(classifier_polydot, test_set)

#evaluating model prediction with confusion matrix
cm_polydot = table(predict_test_polydot, test_set$satisfaction)
confusionMatrix(cm_polydot)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Tuning SVM Model~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Model Tuning 1 ~~~~~~~~~~~~~~~~~~~~~
#building svm model with rbf kernel + increase Cost parameter to 3
classifier_rbf_cost3= ksvm(satisfaction~., data = training_set,
                      kernel = 'rbfdot', C = 3)  
classifier_rbf_cost3

#Tuned Model Testing
#predicting the model with training data
predict_train_rbf_cost3 = predict(classifier_rbf_cost3, training_set)

#evaluating model prediction with confusion matrix
cm_train_rbf_cost3 = table(predict_train_rbf_cost3, training_set$satisfaction)
confusionMatrix(cm_train_rbf_cost3)

#predicting the model with test data
predict_test_rbf_cost3 = predict(classifier_rbf_cost3, test_set)

#evaluating model prediction with confusion matrix
cm_rbf_cost3 = table(predict_test_rbf_cost3, test_set$satisfaction)
confusionMatrix(cm_rbf_cost3)

#ROC Curve + AUC Score 
library(pROC)
roc(training_set$satisfaction, classifier_rbf_cost3$votes[,1], plot=TRUE, legacy.axes=TRUE, percent=TRUE, xlab="False Positive Percentage", ylab="True Postive Percentage", col="#4daf4a", lwd=4, print.auc=TRUE)

roc_svm_test = roc(training_set$satisfaction, predictor =as.numeric(classifier_rbf_cost3))
plot(roc_svm_test, add = TRUE,col = "red", print.auc=TRUE, print.auc.x = 0.5, print.auc.y = 0.3)
legend(0.3, 0.2, legend = c("test-svm"), lty = c(1), col = c("blue"))

pred_ROCR <- prediction(training_set$satisfaction, classifier_rbf_cost3)
