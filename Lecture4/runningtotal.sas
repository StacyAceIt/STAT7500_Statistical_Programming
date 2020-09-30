options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

libname paul '\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets';

* Example of importing a permanent SAS data set;

data club;
  set paul.permclub;
run;

data club1;
  set club;
  difference = startwt - endwt;
  totalwt + difference;
run;

proc print data=club1;
  title 'Example of the Keeping a Cumulative Sum';
run;

*Part 2;

proc sort data=club;
  by team;
run;

data club2;
 set club;
 by team;
 difference = startwt - endwt;
 if first.team then totalwt = 0;
 totalwt + difference;

proc print data=club2;
  title 'Example of the Keeping a Cumulative Sum by Group';
run;

proc sort data=club2;
  by team;
run;

data teamtot;
 set club2;
 by team;
 if last.team;
 keep team totalwt;

proc print data=teamtot;
  title 'Team Totals';
run;

quit;
