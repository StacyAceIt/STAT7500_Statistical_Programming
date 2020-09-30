options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

libname paul '\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets';

* Example of importing a permanent SAS data set;

data dm;
  set paul.dm;
run;

data dmdiff;
  format racewh_ $1.;
  set paul.dmdiff;
  racewh_ = put(racewh,1.0);
  drop racewh;
run;

data dmdiff1;
  format racewh $1.;
  set dmdiff;
  racewh = racewh_;
  drop racewh_;
run;


proc sort data=dm;
  by subjid;
run;

proc sort data=dmdiff1;
  by subjid;
run;

proc compare base=dm compare=dmdiff1;
run;

quit;
