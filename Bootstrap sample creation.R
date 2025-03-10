#samples <- replicate(1000, sample(smp, replace = True))

set.seed(200) # Setting the seed for replication purposes

#sample.size <- 649 # Sample size

#n.samples <- 1000 # Number of bootstrap samples

#bootstrap.results <- c() # Creating an empty vector to hold the results

#for (i in 1:n.samples)
#{
  #obs <- sample(1:sample.size, replace=TRUE)
  #bootstrap.results[i] <- mean(myData[obs]) # Mean of the bootstrap sample
#}

sample <- sample.int(n = nrow(class), size = floor(.625*nrow(class)), replace = F)
train <- class[sample, ]
test  <- class[-sample, ]

#length(bootstrap.results) # Sanity check: this should contain the mean of 1000 different samples
resamples <- lapply(1:10, function(i) train[sample(nrow(train), replace = T),]) 
r = rbind_listdf(lists = resamples)
rTraining = r
#rTest = r[4057:6490,]
write.csv(rTraining,"C:\\Users\\taylo\\Data\\rTraining V2.csv", row.names = FALSE)
write.csv(test,"C:\\Users\\taylo\\Data\\rTest2 V2.csv", row.names = FALSE)
#"C:\Users\taylo\Data\rTest2.csv"
#ratio <- function(d, w) sum(d$x * w)/sum(d$u * w)


#bootsample <- boot(class, ratio, R=1000)
