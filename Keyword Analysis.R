library(readxl)
Student_Keyword_Data <- read_excel("C:/Users/taylo/anaconda3/Keyword Algorithm/Student Keyword Data V2.xlsx")
View(Student_Keyword_Data)
result <- Student_Keyword_Data[, c(-1, -8)]
head(result)
#heatmap(as.numeric(result))
library("mclust")
#result <- result[, -c(1,2)]
#rownames(result) <- paste0("Student.", 1:nrow(result))
word <- result[, c(-1, -2,-3,-4,-5,-6,-7,-8,-9,-10)]
class <- result[, c(-1, -2,-3,-5,-6)]
library('janitor')
 class <- clean_names(class)

## Random Forest ##

library('randomForest')
library('readr')

rTraining<- read_csv("C:\\Users\\taylo\\Data\\rTraining V2.csv",col_types = cols(keyword_position = col_skip(),
                                                           correct_words_percent = col_skip(),
                                                           wrong_words_percent = col_skip(),
                                                           keyword_sequence = col_skip()))
rTest<- read_csv("C:\\Users\\taylo\\Data\\rTest2 V2.csv",col_types = cols(keyword_position = col_skip(),
                                                    correct_words_percent = col_skip(),
                                                    wrong_words_percent = col_skip(),
                                                   keyword_sequence = col_skip()))
set.seed(1000)
## Random Forest
#rTraining = train
#rTest = test
#rTest = rTest[1:6084,]
rf <- randomForest(factor(rTraining$nyha_classification) ~ ., data=rTraining[-1], importance=TRUE,
                   proximity=TRUE, ntree=150)
summary(rf)
print(rf)

plot(rf)

summary(rf$call)
importance(rf)
varImpPlot(rf)

1-mean(as.character(factor(rTraining$nyha_classification)) == as.character(factor(rf$predicted)))

ypred <- predict(rf, newdata=rTest[-1])

ypred

cm <- table(factor(t(rTest[1])), ypred)
plot(cm)
1-mean(as.character(factor(rTest$nyha_classification)) == t(ypred))
plot(rf)
MDSplot(rf, factor(rTraining$nyha_classification))
MDSplot(rf, factor(rTest$nyha_classification))
mcr <- multiclass.roc(as.numeric(factor(rTest$nyha_classification)),as.numeric(t(ypred)))
auc(mcr)
rs <- mcr[['rocs']]
plot.roc(rs[[1]])
sapply(2:length(rs), function(i) lines.roc(rs[[i]],col=i))
rf_prep <- rf_prep(rTraining[-1],factor(rTraining$nyha_classification))
bxc <- rf_viz(rf_prep, input=TRUE,imp=TRUE, cmd=TRUE)
plotProximity(rf, point.size=.5, circle.size=NULL, group.alpha= 0.5)
## Bootstrap Aggregating ##

#Fits the data into the model 

My_bagged_model <- bagging(
  formula = factor(rTraining$nyha_classification) ~ .,
  data = rTraining[-1],
  nbagg = 150,   
  coob = TRUE,
  control = rpart.control(minsplit = 2, cp = 0) 
)

My_bagged_model
My_bagged_model$call
summary(My_bagged_model)
VI <- data.frame(var=names(rTraining[,-1]), imp=varImp(My_bagged_model))
ypredB <- predict(My_bagged_model, newdata=rTest[-1])

ypredB
cm2 <- table(factor(t(rTest[1])), ypredB)
cm2
plot(cm2)
1-mean(as.character(factor(rTest$nyha_classification)) == t(ypredB))
plot(My_bagged_model)
#sort variable importance descending
VI_plot <- VI[order(VI$Overall, decreasing=TRUE),]
#plot(VI_plot)
#visualize variable importance with horizontal bar plot
barplot(VI_plot$Overall,
        names.arg=rownames(VI_plot),
        horiz=TRUE,
        col='steelblue',
        xlab='Variable Importance')


bag2 <- train(rTraining[-1],
  factor(rTraining$nyha_classification),
  method = "treebag",
  trControl = trainControl(method = "cv", number = 5),
  control = rpart.control(minsplit = 2, cp = 0)
)
bag2

cr.pred <- predict(bag2, rTest[-1])

cr.df <- data.frame(predicted = cr.pred, actual = rTest[1])
#print(cr.df)
1-mean(as.character(factor(rTest$nyha_classification)) == cr.pred)

##neural network

nn=neuralnet(factor(rTraining$nyha_classification)~.,data=rTraining[-1], hidden=3,act.fct = "logistic",
             linear.output = FALSE, err.fct='sse')
plot(nn)
nn$result.matrix
pN = neuralnet::compute(nn,rep=1,rTest[,-1])
p1=pN$net.result
pred1 <- ifelse(p1 > 0.5, 1, 0)
pred1
nnet_pred = as.data.frame(pred1)
nnet_pred$id = rownames(nnet_pred)
melt_1=melt(nnet_pred,id.vars=c("id"))
m <- melt_1[melt_1$value == 1,]
m <- m[order(as.numeric(m$id)),]
unique(m)
prediction1 <- as.vector(m$variable)
tab1 <- table(prediction1,rTest)
tab1
1-mean(as.character(factor(rTest$nyha_classification)) == pN)
### knn classification
library('class')
##run knn function

split <- sample.split(class$nyha_classification, SplitRatio = 0.7)
train_cl <- subset(class, split == "TRUE")
test_cl <- subset(class, split == "FALSE")

# Feature Scaling
train_scale <- scale(train_cl)
test_scale <- scale(test_cl)

# Fitting KNN Model 
# to training dataset
classifier_knn <- knn(train = train_cl[,-1],
                      test = test_cl[,-1],
                      cl = as.factor(train_cl$nyha_classification),
                      k = 1)
classifier_knn

# Confusiin Matrix
cm <- table(test_cl$nyha_classification, classifier_knn)
cm

# Model Evaluation - Choosing K
# Calculate out of Sample error
misClassError <- mean(classifier_knn != test_cl$nyha_classification)
print(paste('Accuracy =', 1-misClassError))

# K = 18
classifier_knn <- knn(train = train_cl[,-1],
                      test = test_cl[,-1],
                      cl = as.factor(train_cl$nyha_classification),
                      k = 21)
misClassError <- mean(classifier_knn != test_cl$nyha_classification)
print(paste('Accuracy =', 1-misClassError))
cm <- table(test_cl$nyha_classification, classifier_knn)
cm
ACC <- 100 * sum(test_cl$nyha_classification == classifier_knn)/NROW(test_cl$nyha_classification)
ACC
confusionMatrix(table(classifier_knn ,test_cl$nyha_classification))
plot(classifier_knn)

## multinominal regression

#$prog <- relevel(mdata$prog, ref=1)

# Load the package
library(nnet)
# Run the model
model <- multinom(as.factor(nyha_classification) ~ ., data=class)
summary(model)
coefs <- coef(model)
coef
zvalues <- summary(model)$coefficients / summary(model)$standard.errors
# Show z-values
zvalues
pnorm(abs(zvalues), lower.tail=FALSE)*2
chisq.test(as.factor(class$nyha_classification),predict(model))
ctable <- table(as.factor(class$nyha_classification),predict(model))
ctable

#ratio <- function(d, w) sum(d$x * w)/sum(d$u * w)


#bootsample <- boot(class, ratio, R=1000)

#class$nyha_classification <- as.numeric(as.factor(class$nyha_classification))
#resamples <- lapply(1:1000, function(i) sample(class, replace = T))
#resamples[1]
#r.median <- sapply(resamples, median)
#r.median