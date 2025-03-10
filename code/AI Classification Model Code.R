vhlibrary('randomForest')

 #randomforest example
colnames(cluster_live)[colnames(cluster_live) == 'k$cluster'] <- 'cluster'
colnames(cluster_live)[colnames(cluster_live) == 'Physical Exam'] <- 'PE'
colnames(cluster_live)[colnames(cluster_live) == 'SOAP Note'] <- 'SOAP'
rf <- randomForest(cluster ~ ., data=cluster_live, importance=TRUE,
                   proximity=TRUE)
summary(rf)
print(rf)

plot(rf)

summary(rf$call)
importance(rf)
varImpPlot(rf)
library("nnet")

#multinomial logistic regression example
library("caret")
index <- createDataPartition(cluster_live$cluster, p = .70, list = FALSE)
train <- cluster_live[index,]
test <- cluster_live[-index,]
model <- multinom(cluster ~ ., data = cluster_live)
summary(model)
z <- summary(model)$coefficients/summary(model)$standard.errors
z
p <- (1 - pnorm(abs(z), 0, 1)) * 2
p
exp(coef(model))
head(pp <- round(fitted(model),2))
plot(round(model$residuals,2))
train$clusterPredicted <- predict(model, newdata = train, "class")
# Building classification table
tab <- table(train$cluster, train$clusterPredicted)
# Calculating accuracy - sum of diagonal elements divided by total obs
round((sum(diag(tab))/sum(tab))*100,2)

test$clusterPredicted <- predict(model, newdata = test, "class")
# Building classification table
tab <- table(test$cluster, test$clusterPredicted)
tab
chisq.test(cluster_live$cluster,predict(model))

#bootstrao aggregating (bagging) example

library(dplyr)       # for data wrangling
library(ggplot2)     # for awesome plotting
library(doParallel)  # for parallel backend to foreach
library(foreach)     # for parallel processing with for loops

# Modeling packages
library(caret)       # for general model fitting
library(rpart)       # for fitting decision trees
library(ipred)

#varImp(ames_bag1$call)
set.seed(1)

#fit the bagged model
bag <- bagging(
  formula = Ozone ~ .,
  data = airquality,
  nbagg = 150,   
  coob = TRUE,
  control = rpart.control(minsplit = 2, cp = 0)
)

#display fitted bagged model
bag

VI <- data.frame(var=names(airquality[,-1]), imp=varImp(bag))

#sort variable importance descending
VI_plot <- VI[order(VI$Overall, decreasing=TRUE),]

#visualize variable importance with horizontal bar plot
barplot(VI_plot$Overall,
        names.arg=rownames(VI_plot),
        horiz=TRUE,
        col='steelblue',
        xlab='Variable Importance')
view(bag[["X"]])
#neural network 
data(iris)

#shuffle the vector
iris <- iris[sample(1:nrow(iris),length(1:nrow(iris))),1:ncol(iris)]

irisValues <- iris[,1:4]
irisTargets <- decodeClassLabels(iris[,5])
#irisTargets <- decodeClassLabels(iris[,5], valTrue=0.9, valFalse=0.1)

iris <- splitForTrainingAndTest(irisValues, irisTargets, ratio=0.15)
iris <- normTrainingAndTestSet(iris)

model <- mlp(iris$inputsTrain, iris$targetsTrain, size=5, learnFuncParams=c(0.1), 
             maxit=50, inputsTest=iris$inputsTest, targetsTest=iris$targetsTest)

summary(model)
model
weightMatrix(model)
extractNetInfo(model)

par(mfrow=c(2,2))
plotIterativeError(model)

predictions <- predict(model,iris$inputsTest)

plotRegressionError(predictions[,2], iris$targetsTest[,2])

confusionMatrix(iris$targetsTrain,fitted.values(model))
confusionMatrix(iris$targetsTest,predictions)

plotROC(fitted.values(model)[,2], iris$targetsTrain[,2])
plotROC(predictions[,2], iris$targetsTest[,2])

#confusion matrix with 402040-method
confusionMatrix(iris$targetsTrain, encodeClassLabels(fitted.values(model),
                                                     method="402040", l=0.4, h=0.6))
# }