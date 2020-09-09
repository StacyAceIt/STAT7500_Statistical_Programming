options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

libname paul '\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets';

* Example of creating new variables;

data club;
  set paul.permclub;
run;

data club_a;
  set club;
  difference = endwt - startwt;
  percent = ((difference)/startwt)*100;
run;

proc print data=club_a;
  title 'Data Set with New Variables';
run;

/* The following formats the difference variable to have two decimal places*/
data club1;
  set paul.permclub;
run;

data club1;
  set club;
  difference = endwt - startwt;
  percent = ((endwt - startwt)/startwt)*100;
  format percent 8.2;
run;

proc print data=club1;
  title 'Data Set with New Variables';
run;

proc means data=club_a;
  title 'Mean of Percent from Unformatted Variable';
  var percent;
run;

proc means data=club1;
  title 'Mean of Percent from Formatted Variable';
  var percent;
run;

quit;
