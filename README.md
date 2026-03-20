# IDE-360-Project-2

*There may be formating issues due to platform differences.

This repository is made for the purpose of sampling data from the 2012 The National Health and Nutrition Examination Survey (NHANES)
([url](https://wwwn.cdc.gov/nchs/nhanes/search/nnyfsdata.aspx?Component=Questionnaire)) 
on Physical Activity([url](https://wwwn.cdc.gov/Nchs/Data/Nnyfs/Public/2012/DataFiles/Y_PAQ.htm])) 
and Physical Functioning([url](https://wwwn.cdc.gov/Nchs/Data/Nnyfs/Public/2012/DataFiles/Y_PFQ.htm))
using RStudio to answer the research question "Is there a link between how many
minutes someone aged 3-19 spends sitting and how much difficulty they have with
crawling, walking, running and/or playing?".

OVERVIEW

  This repository will utilize devtools and Hmisc. If the user does not have the
  relevant packages for these libraries installed, it is     
  important that the user first updates RStudio, then installs the packages for
  these libraries. The user may be prompted to install the packages when sourcing
  the code for the first time. After the user has installed the packages, it is 
  likely they may be prompted to restart RStudio in any subsequent sources of the code. 
  It will give a warning message, stating the user should restart RStudio to 
  install the packages; As long as the user has already installed the relevant 
  packages, any response is okay, as the code has likely already executed. 
  IF THERE ARE OTHER ISSUES NOT ASSOCIATED WITH INSTALLING PACKAGES, however,
  it is advised that the user does choose to restart RStudio. 

IMPORTING DATA
  The data sets are included in the repository. It is important to install the 
  entire working directory and to ensure ALL FILES REMAIN WITHIN THE SAME WORKING 
  DIRECTORY when performing analysis with this code, as the working directory of 
  the code will be used to allow the code to find the necessary data. Otherwise, 
  the user will have to edit the code to change the path so that the code can 
  find the data files. There is documentation on where to do this within the code. 

  It is also important to ENSURE ALL DATA FILES (*.xpt) MAINTAIN THE SAME NAME.
  This is also to ensure the code is able to locate the data files. The user can,
  again, alter the code if they should choose to edit the name of the data file(s).
  There is documentation on where to do this within the code.

EXPLORATORY ANALYSIS
  
  After data sets are imported, the code will find the data for minutes of sedentary 
  activity and mobility limitations. The code will the create a table to remove the 
  missing data from the minutes of sedentary activity and the related responses 
  of mobility limitations. The code will then split the minutes of sedentary data 
  based on whether or not the responder had limitations crawling, walking, running 
  or playing. After that, the code will display some summary statistics to describe 
  the data of minutes spent sitting aswell as visuals for both samples combined. 
  This is done to assess the quality of the data and select an appropriate method of analysis.

NB: It is important to note that the test will execute this way regardless of whether assumptions are met. This test is extremely robust and provides a reliable conclusion for comparisons of most datasets, however, it is important that the user reviews the outputs of the exploratory analysis in consideration of the [assumptions associated with Welch's t-test]([url](https://en.wikipedia.org/wiki/Welch%27s_t-test#Assumptions)) before forming their final conclusion.


STATISTICAL ANALYSIS AND CONCLUSION

  Finally, the code will perform a Welch's t-test (the default configuration for
  t.test()) to determine if there is a significant difference in the average number
  of minutes spent sitting between individuals with and without mobility limitations
  and print a conclusion based on the p-value calculated in the t-test. As 
  aforementioned, it is important to review the Exploratory Analysis results to 
  confirm the accuracy of this conclusion. It is also important that the user 
  reviews the docs for the data sets (linked where mentioned above) to search 
  for possible biases in wording, sampling, etc. 
  
  The code will also produce a visual overlaying the probability density function 
  of both groups. This can be used to visually assess the validity of the 
  conclusion that was drawn.
  



