options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

libname paul '\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets';

data paper2;
  set paul.paper2;
run;

data sexhosp;
  set paper2;
  if gender = 'Male' and age <=40 then group = 1;
  if gender = 'Male' and age  >40 then group = 2;
  if gender = 'Female' and age <=40 then group = 3;
  if gender = 'Female' and age >40 then group = 4;
  keep ptid age gender group;
run;

proc print data=sexhosp;
  title 'Example of the And statement in and If-Then Statement';
run;

*Part 2;

data femaleoraa;
  set paper2;
  if gender = 'Female' or raceid = 3 then flag = 1;
  else flag = 0;
  keep ptid age gender raceid admit flag;
run;

proc print data=femaleoraa;
  title 'Example of the Or statement in and If-Then Statement';
run;


quit;
