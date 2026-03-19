# INSTALL PACKAGES

  install.packages("devtools")
  library(devtools)
  install.packages("Hmisc")
  library(Hmisc)

# IMPORTING DATA FROM CDC
# NOTE: IT IS IMPORTNAT THAT YOU HAVE PROPERLY DOWNLOADED THE WORKING DIRECTORY 
# FROM GIT FOR THE DATA TO BE LOADED PROPERLY
  path <- getwd()
  physAct <- sasxport.get(paste0(path,"/Y_PAQ.xpt")) # Physical Activity Data
  physFunct <- sasxport.get(paste0(path,"/Y_PFQ.xpt")) # Physical Functioning Data

# EXTRACTING VARIABLES OF INTEREST FROM THE DATA SETS: MINUTES OF SEDENTARY 
# ACTIVITY AND WALK, CRAWL, PLAY LIMITATIONS

  minsSedentaryData <- physAct$pad680 #Minutes Sedentary Activity
  mobilLimitData <- physFunct$pfq020 # Crawl, Walk, Run, Play Limitations

# DATA SETUP
  
  # CREATING TABLE FOR mobilLimitData IN RESPONSE TO minsSedentaryData TO CLEAN
  # THE DATA DUE TO MISSING ENTRIES OF MINUTES OF SENDENTARY ACTIVITY 
  
    cleanData <- table(minsSedentaryData, mobilLimitData) # mobilLimitData vs mobilLimitData
    
    # EXTRACTING CLEAN DATA
      mobilLimitYesData <- cleanData[,1] # 'Yes' responses
      mobilLimitNoData <- cleanData[,2] # 'No' responses
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
  
    describe(mobilLimitYesData)
    
# CHECKING FOR NORMALITY AND INDEPENDENCE
    
  yesHist <- hist(minsSedentaryYesData)
  noHist<- hist(minsSedentaryNoData)
  par(mfrow = c(3,1))
  plot(yesHist,main="Minutes of Sedentary Activity for People With Crawl, Walk, Run, and/or Play Limitations", xlab = "Minutes of Sedentary Activity" )
  plot(noHist,main="Minutes of Sedentary Activity for People Without Crawl, Walk, Run, and/or Play Limitations", xlab = "Minutes of Sedentary Activity" )


# PERFORMING WELCH TWO SAMPLE T-TEST
  
  results <- t.test(minsSedentaryYesData, minsSedentaryNoData)
  pdfYes <- dnorm(minsSedentaryYesData, mean(minsSedentaryYesData), sd(minsSedentaryYesData))
  pdfNo <- dnorm(minsSedentaryNoData, mean(minsSedentaryNoData), sd(minsSedentaryNoData))
  #DISPLAYING RESULTS
    min <- min(minsSedentaryYesData) # Minimum x-value for PDF plot
    max <- max(minsSedentaryYesData) # Maximum x-value for PDF plot
    if(min(min(minsSedentaryNoData)) < min(minsSedentaryYesData)){
      min <- min(minsSedentaryYesData)
    } 
    if(max(min(minsSedentaryNoData)) < max(minsSedentaryYesData)){
      max <- max(minsSedentaryYesData)
    } 
    x <- seq(min,max)
    plot(x,pdfYes,col="green",main="Minutes of Sedentary Activity")
    lines(x,pdfNo,col="red")
    if(results$p.value < .05){
      print(paste0("With a p value of ", round(results$p.value, digits = 2), ", there is sufficient evidence that there is a significant difference in the average numer of minutes of sedentary activity between individuals with and without mobility limitations"))
    } else {
      print(paste0("With a p value of ", round(results$p.value, digits = 2), ", there is insufficient evidence that there is a significant difference in the average numer of minutes of sedentary activity between individuals with and without mobility limitations"))
    }
  
  
