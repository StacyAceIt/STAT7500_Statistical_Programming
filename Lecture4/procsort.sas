options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

libname paul '\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets';

data clubdate;
  set paul.clubdate;
run;

proc sort data=clubdate;
  by id;
run;

proc print data=clubdate;
  title 'Original Data Set Sorted by ID';
run;

proc sort data=clubdate;
  by name;
run;

proc print data=clubdate;
  title 'Original Data Set Sorted by name';
run;

proc sort data=clubdate;
  by team percent;
run;

proc print data=clubdate;
  title 'Original Data Set Sorted by Team and Percent';
run;

/* Example of sorting by descending order */

proc sort data=clubdate;
  by team descending percent;
run;

proc print data=clubdate;
  title 'Original Data Set Sorted by Team and Descending Percent';
run;
quit;
