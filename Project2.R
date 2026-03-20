# INSTALL PACKAGES - the next two lines of code can be removed or commented out
# if user already has packages installed to mitigate error messages (optional). 

install.packages("devtools")
install.packages("Hmisc")

# LOAD LIBRARIES  
library(devtools)
library(Hmisc)

# IMPORTING DATA FROM CDC
# NOTE: IT IS IMPORTNAT THAT YOU HAVE PROPERLY DOWNLOADED THE WORKING DIRECTORY 
# FROM GIT FOR THE DATA TO BE LOADED PROPERLY

path <- getwd() # Path to current current working

# NOTE: If the data files are NOT in the same working directory as this file,
# user should change 'path' to be the directory that holds the data files. 

physAct <- sasxport.get(paste0(path,"/Y_PAQ.xpt")) # Physical Activity Data
physFunct <- sasxport.get(paste0(path,"/Y_PFQ.xpt")) # Physical Functioning Data

# NOTE: if data set(s) names were changed, text between the '/' and the'.xpt' should
# be changed to the updated name.

# EXTRACTING VARIABLES OF INTEREST FROM THE DATA SETS: MINUTES OF SEDENTARY 
# ACTIVITY AND WALK, CRAWL, PLAY LIMITATIONS

minsSedentaryDataOriginal <- physAct$pad680 #Minutes Sedentary Activity
mobilLimitData <- physFunct$pfq020 # Crawl, Walk, Run, Play Limitations

# DATA SETUP

# CREATING TABLE FOR mobilLimitData IN RESPONSE TO minsSedentaryData TO CLEAN
# THE DATA DUE TO MISSING ENTRIES OF MINUTES OF SENDENTARY ACTIVITY 

cleanData <- table(minsSedentaryDataOriginal, mobilLimitData) # mobilLimitData vs mobilLimitData

# EXTRACTING CLEAN DATA
mobilLimitYesData <- cleanData[,1] # 'Yes' responses
mobilLimitNoData <- cleanData[,2] # 'No' responses
mobilLimit <- c(mobilLimitYesData,mobilLimitNoData) # mobil Limit data
minsSedentaryData <- as.integer(rownames(cleanData))


# GROUPED SAMPLING FROM mobilLimitYesData

numIterations <- 0 # number of times the four loop has been run
check <- 0 # checks if the current iteration is the first nonzero occurrence
for(data in mobilLimitYesData){
  numIterations <- (numIterations + 1)
  if(data == 0){
    next
  }
  if(!check){
    minsSedentaryYesData <- minsSedentaryData[numIterations]
    check <- 1
    next
  }
  i <- 1
  while(i <= data){
    minsSedentaryYesData <- c(minsSedentaryYesData, minsSedentaryData[numIterations])
    i <- (i + 1)
  }
}


numIterations <- 0 #number of times the four loop has been run
check <- 0 # checks if the current iteration is the first nonzero occurrence
for(data in mobilLimitNoData){
  numIterations <- (numIterations + 1)
  if(data == 0){
    next
  }
  if(!check){
    minsSedentaryNoData <- minsSedentaryData[numIterations]
    check <- 1
    next
  }
  i <- 1
  while(i <= data){
    minsSedentaryNoData <- c(minsSedentaryNoData, minsSedentaryData[numIterations])
    i <- (i + 1)
  }
}

# DISPLAY SUMMARY STATISTICS
minsSedentaryData <- c(minsSedentaryYesData,minsSedentaryNoData)
print("Summary:")
print(summary(minsSedentaryData))
print("Description:")
print(describe(minsSedentaryData))

# CHECKING FOR NORMALITY AND INDEPENDENCE

hist <- hist(minsSedentaryData)
yesHist <- hist(minsSedentaryYesData)
noHist<- hist(minsSedentaryNoData)
par(mfrow = c(1,1))
plot(hist,main="Minutes of Sedentary Activity", xlab = "Minutes of Sedentary Activity" )

#Cleaning the original, unordered data
minsSedentaryDataUnord <- minsSedentaryDataOriginal[!is.na(minsSedentaryDataOriginal)] 

x <- seq(1,(10*length(minsSedentaryDataUnord)),10) #Setting x-values for graph
plot(x,minsSedentaryDataUnord,xlab="",ylab="Minutes of Sedentary Activity",main="Sedentary Activity Scatterplot")

par(mfrow = c(2,1))
plot(yesHist,main="Minutes of Sedentary Activity for People With Crawl, Walk, Run, and/or Play Limitations", xlab = "Minutes of Sedentary Activity" )
plot(noHist,main="Minutes of Sedentary Activity for People Without Crawl, Walk, Run, and/or Play Limitations", xlab = "Minutes of Sedentary Activity" )
par(mfrow = c(1, 1))

# PERFORMING WELCH TWO SAMPLE T-TEST

results <- t.test(minsSedentaryYesData, minsSedentaryNoData)
pdfYes <- dnorm(minsSedentaryYesData, mean(minsSedentaryYesData), sd(minsSedentaryYesData))
pdfNo <- dnorm(minsSedentaryNoData, mean(minsSedentaryNoData), sd(minsSedentaryNoData))

#DISPLAYING RESULTS

x <- seq(0,450)
length(pdfYes)<-451
length(pdfNo)<-451
plot(x,pdfYes,col="green",main="Minutes of Sedentary Activity",ylab="Probability Density")
lines(x,pdfNo,col="red")
legend("bottom", legend = c("People With Crawl, Walk, Run, and/or Play Limitations", "People With Crawl, Walk, Run, and/or Play Limitations"), 
       col = c("green", "red"), lty = c(1, 1, 2))
print("Conclusion:")
if(results$p.value < .05){
  print(paste0("With a p value of ", round(results$p.value, digits = 2), ", 
                   there is sufficient evidence that there is a significant difference in the average number of minutes of sedentary activity between individuals with and without mobility limitations with 95% confidence"))
} else {
  print(paste0("With a p value of ", round(results$p.value, digits = 2), ",
                   there is insufficient evidence that there is a significant difference in the average number of minutes of sedentary activity between individuals with and without mobility limitations with 95% confidence"))
}


