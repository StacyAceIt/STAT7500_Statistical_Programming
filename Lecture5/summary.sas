options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

libname paul '\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets';

* Example of using proc univariate to summarize the weight loss data overall;

data grades;
  set paul.grades;
run;

proc univariate data=grades;
  title 'Summary Statistics for Grades';
  var final;
run;

proc univariate data=grades noprint;
  title 'Summary Statistics for Grades';
  var final;
  output out=stats n=n mean=mean std=stdev var=variance min=minimum max=maximum;
run;

proc print data=stats;
run;

data stats1;
  format n1 12.0 mean1 12.2 stdev1 12.3 stderr 12.3 variance1 12.3 minimum1 maximum1 12.1;
  set stats;
  n1 = n;
  mean1 = mean;
  stdev1 = stdev;
  variance1 = variance;
  minimum1 = minimum;
  maximum1 = maximum;
  drop n mean stdev variance minimum maximum;
  stderr = mean1 / stdev1;
run;

proc print data=stats1;
run;

/* The following calculates the summary statistics by section */

proc sort data=grades;
  by section;
run;

proc univariate data=grades ;
  title 'Summary Statistics for Grades by Section';
  class section;
  var final;
  output out=statsgen n=n mean=mean std=stdev var=variance min=minimum max=maximum;
run;

proc print data=statsgen;
run;

data statsgen1;
  format n1 12.0 mean1 12.2 stdev1 12.3 stderr 12.3 variance1 12.3 minimum1 maximum1 12.1;
  set statsgen;
  n1 = n;
  mean1 = mean;
  stdev1 = stdev;
  variance1 = variance;
  minimum1 = minimum;
  maximum1 = maximum;
  drop n mean stdev variance minimum maximum;
  stderr = mean1 / stdev1;
run;

proc print data=statsgen1;
run;

proc plot data=grades;
  title 'Dotplot of the Grades Data by Section';
  plot section*final;
run;

proc boxplot data=grades;
  title 'Boxplot of the Grades Data by Section';
  plot final*section;
run;


/********************************************************************/

/* PROC MEANS */

proc means data=grades;
  title 'Proc Means for the Grades';
  var final;
  output out=meansout n=n mean=mean std=stdev min=min max=max;
run;

proc print data=meansout;
run;

proc sort data=grades;
  by section;
run;

proc means data=grades;
  title 'Proc Means for the Grades';
  class section;
  var final;
  output out=meansoutgen n=n mean=mean std=stdev min=min max=max;
run;

proc print data=meansoutgen;
run;

/* PROC FREQ */

data grades1;
  set grades;
  if final ge 90.0 then flag = 1;
run;

proc freq data=grades1;
 title 'Proc Freq of Flag Overall and by Section';
 tables flag section*flag;
run;

proc freq data=grades1;
 title 'Proc Freq of Flag Overall and by Section';
 tables flag section*flag / missing;
run;

proc freq data=grades;
  title 'Frequency of IDs';
  tables id;
run;


/*PROC SORT WITH NODUPKEY*/
proc sort data=grades nodupkey out=nodupes;
  by id;
run;

proc print data=nodupes;
run;



quit;
