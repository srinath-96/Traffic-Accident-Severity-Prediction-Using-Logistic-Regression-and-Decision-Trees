# Load libraries
library(ggplot2)
library(readxl)
library(caret)
library(gains)
library(rpart)
library(rpart.plot)
library(pROC)
library(Boruta)

# Read data
# Cal <- read_excel('Cal.xlsx')

Cal = read.csv('CALI.csv')
Cal <- na.omit(Cal)

# Data Exploration
ggplot(Cal, aes(x = CrashType)) +
  geom_bar(fill = "blue") +
  labs(title = "CrashType Distribution")

ggplot(Cal, aes(x = Severity)) +
  geom_histogram(binwidth = 1, fill = "green", color = "black") +
  labs(title = "Severity Distribution")

ggplot(Cal, aes(x = as.factor(Severity), y = ViolCat)) +
  geom_boxplot(fill = "purple") +
  labs(title = "Box Plot of ViolCat by Severity")

ggplot(Cal, aes(x = Month, fill = as.factor(ClearWeather))) +
  geom_bar(position = "stack") +
  labs(title = "Incidents by Month and Clear Weather")

# Data Preparation
Cal$Weekday <- as.numeric(Cal$Weekday >= 6)
Cal <- subset(Cal, (CrashType == "B" | CrashType == "C" | CrashType == "D" | CrashType == "E"))


# Splitting the data into train and test sets
set.seed(123)
train_index <- createDataPartition(Cal$Severity, p = 0.7, list = FALSE)
train_data <- Cal[train_index, ]
test_data <- Cal[-train_index, ]

# Feature Importance
boruta_output <- Boruta(Severity ~ Weekday + ViolCat + ClearWeather + Month + CrashType + Highway + Daylight,
                        data = train_data, family = binomial)
boruta_output
importances <- attStats(boruta_output)
importances <- importances[importances$decision != "Rejected", c("meanImp", "decision")]
importances[order(-importances$meanImp), ]

# Logistic Regression Model
logistic_model <- glm(Severity ~ ViolCat + Month + CrashType + Highway, 
                      data = train_data, family = binomial)
predicted_probs <- predict(logistic_model, newdata = test_data, type = "response")
predicted_classes <- ifelse(predicted_probs >= 0.5, 1, 0)


# Model Evaluation
confusion_matrix <- confusionMatrix(data = as.factor(predicted_classes), reference = as.factor(test_data$Severity), positive = '1')
confusion_matrix


# K-fold Cross Validation
train_control <- trainControl(method = "cv", number = 10)
model <- train(Severity ~ .,
               data = train_data,
               trControl = train_control,
               method = "glm",
               family = binomial())
predicted_probs_cv <- predict(model, newdata = test_data, type = "raw")
predicted_classes_cv <- ifelse(predicted_probs_cv >= 0.5, 1, 0)
confusion_matrix_cv <- confusionMatrix(data = as.factor(predicted_classes_cv), reference = as.factor(test_data$Severity), positive = '1')
confusion_matrix_cv

roc_object <- roc(test_data$Severity, predicted_probs_cv)
plot.roc(roc_object)
auc_value <- auc(roc_object)
# Add AUC value to the plot
text(0.5, 0.3, paste("AUC =", round(auc_value, 3)), adj = c(0.5, 0.5), cex = 1.2)


# Decision Tree Model
default_tree <- rpart(Severity ~ ViolCat + Month + CrashType + Highway, data = train_data, method = "class")
summary(default_tree)
prp(default_tree, type = 1, extra = 1, under = TRUE)

# Pruning and evaluation
set.seed(1)
full_tree <- rpart(Severity ~ ViolCat + Month + CrashType + Highway, data = train_data, method = "class", cp = 0, minsplit = 2, minbucket = 1)
printcp(full_tree)
plotcp(full_tree)

# Get the row index of the minimum xerror value
min_xerror_index <- which.min(full_tree$cptable[, "xerror"])

# Extract the corresponding complexity parameter (cp) value
optimal_cp <- full_tree$cptable[min_xerror_index, "CP"]
print(optimal_cp)

pruned_tree <- prune(full_tree, cp = optimal_cp)
prp(pruned_tree, type = 1, extra = 1, under = TRUE)

predicted_class_tree <- predict(pruned_tree, test_data, type = "class")
confusionMatrix(predicted_class_tree, as.factor(test_data$Severity), positive = "1")

predicted_prob_tree <- predict(pruned_tree, test_data, type = 'prob')
confusionMatrix(as.factor(ifelse(predicted_prob_tree[, 2] > 0.5, '1', '0')), as.factor(test_data$Severity), positive = '1')

# Gains Table
gains_table <- gains(test_data$Severity, predicted_prob_tree[, 2])
gains_table

# Lift Chart
plot(c(0, gains_table$cume.pct.of.total * sum(test_data$Severity)) ~ c(0, gains_table$cume.obs), 
     xlab = '# of cases', ylab = "Cumulative", type = "l")
lines(c(0, sum(test_data$Severity)) ~ c(0, dim(test_data)[1]), col = "red", lty = 2)

# Decile Chart
barplot(gains_table$mean.resp / mean(test_data$Severity), names.arg = gains_table$depth, 
        xlab = "Percentile", ylab = "Lift", ylim = c(0, 3.0), main = "Decile-Wise Lift Chart")

# ROC Chart
roc_object_tree <- roc(test_data$Severity, predicted_prob_tree[, 2])
plot.roc(roc_object_tree)
auc_value <- auc(roc_object_tree)
# Add AUC value to the plot
text(0.5, 0.3, paste("AUC =", round(auc_value, 3)), adj = c(0.5, 0.5), cex = 1.2)


# Model Evaluation using Test Data
myScoreData <- read_excel("modoc_test_data.xlsx")
myScoreData <- subset(myScoreData, (CrashType == "B" | CrashType == "C" | CrashType == "D" | CrashType == "E"))

predicted_class_score_tree <- predict(pruned_tree, myScoreData, type = "class")
predicted_prob_score_tree <- predict(pruned_tree, myScoreData, type = "prob")


