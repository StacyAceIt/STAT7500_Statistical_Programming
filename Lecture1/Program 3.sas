/*************************************************/
/*       Example of the various options          */
/*************************************************/

options center ps=60 ls=72;

*The following inputs the dataset;
data ex5_57;
  input oxygen @@;
  *or datalines;
  *fields must be separated by at least one space;
  *empty data in R -NA empty data in SAS;
  cards;
  5.1 4.9 5.6 4.2 4.8 4.5 5.3 5.2
  ;
run;

*The following prints the data set;

proc print data=ex5_57; 
title 'Listing of the Data Set';
run;

*The following creates a normal probability plot to check
 the normality assumption;

proc univariate data=ex5_57 noprint;
  probplot oxygen / normal;
run;

*The following performs the one sample t-test;

proc ttest data=ex5_57 h0=5 alpha=0.05;
  var oxygen;
run;

quit;
