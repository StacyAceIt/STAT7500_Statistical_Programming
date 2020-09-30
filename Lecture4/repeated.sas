options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

libname paul '\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets';

data repeated;
  set paul.repeated;
run;

proc sort data=repeated;
  by group subject;
run;

proc print data=repeated;
  title 'Original Data Set';
run;

*The following transposes the dataset and creates one variable for the response;

proc transpose data=repeated out=transrepeated;
  by group subject;
  var baseline time1 time2;
run;

proc print data=transrepeated;
  title 'Transposed Data Set';
run;

*The following code renames the newly created variables;

data transrepeated;
  set transrepeated;
  rename col1 = fev;
  rename _name_ = time;
run;

proc print data=transrepeated;
  title 'Transposed Data Set';
run;

*The following code illustrates the retain statement;

data transrepeated;
  set transrepeated;
  if time = 'Baseline' then fevbase = fev;
  retain fevbase;
  chgefrombase = fev-fevbase;

proc print data=transrepeated;
  title 'Change from Baseline';
run;

data transrepwobase;
  set transrepeated;
  if time ne 'Baseline';
run;

proc print data=transrepwobase;
  title 'Change from Baseline';
run;

proc sort data=transrepwobase;
  by group time;
run;

proc means data=transrepwobase n mean sum median std stderr min max ;
  by group time;
  var fev fevbase;
run;
quit;
