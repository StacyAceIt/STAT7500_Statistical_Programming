options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

libname paul '\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets';

* Example of subsetting data sets using a set statement;

data club;
  set paul.newclub;
run;

* Part 1. Example of If-Then-Statements;

data club;
  set club;
  if percent <= -10 then succeed = 'yes';
  else succeed = 'no';
run;

proc print data=club;
  title 'Creating the Succeed Variable with If-Then-Else Statement';
run;

* Part 2. Example of Multiple If-Then Statements;

data club;
  set club;
  if percent = . then succeed = ' ';
  if percent ne . and percent <= -10 then succeed = 'yes';
  if percent > -10 then succeed = 'no';
run;

*What is wrong?;

proc print data=club;
  title 'Creating the Succeed Variable with Multiple If-Then Statements';
run;


quit;
