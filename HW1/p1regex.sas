options linesize=78 nodate nonumber;
data mydata;
pattern = prxparse("/\w *\d/");
input name & $8.
	  score1 
	  score2 
	  score3 
	  score4 
	  score5 
	  final; 

if prxmatch(pattern,name) then output;

datalines;
Gamma1  11.25 9.75 10 10 10 90 
Delta1  9.5 7.5 8 10 10 95 
Epsilon1  11.5 10 9.75 3.5 10 100 
Theta 1  12.5 10 9.5 9 10 100
Theta  12.5 10 9.5 9 10 100
Theta  1  12.5 10 9.5 9 10 100
;
run;

proc print data=mydata;
run;

/*
Data phone;
IF _N_ = 1 THEN PATTERN = PRXPARSE("/\w *\d/");
RETAIN PATTERN;
INPUT STRING $CHAR40.;
  IF PRXMATCH(PATTERN,STRING) THEN OUTPUT;

DATALINES;
 theta 1
 gamma1
 sally
 PROC PRINT DATA=PHONE NOOBS;
 TITLE "Listing of Data Set Phone";
 run;
*/
