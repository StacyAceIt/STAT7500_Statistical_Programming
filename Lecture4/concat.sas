options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';
 
data name;
  input first $ 1-7 last $ 9-17 building $ 19-21 office 23-25;
  cards;
Paul    Lupinacci SAC 390
Joseph  Pigeon    SAC 317
Michael Posner    SAC 387
Jesse   Frey      SAC 375
Paul    Bernhardt SAC 323
Michael Levitan   SAC 376
Yimin   Zhang     SAC 325
  ;
run;

proc print data=name;

/* The following concatenates the first and last names */

data name1;
  format fullname fullname1 fullname2 lastfirst $20.;
  set name;
  fullname  = first||last;
  fullname1 = strip(first)||strip(last);
  fullname2 = strip(first)||" "||strip(last);
  lastfirst = strip(last)||", "||strip(first);
run;

proc print data=name1;
run;

proc sort data=name1;
  by office;
run;

data name2;
  format label $60.;
  set name1;
  label = strip(fullname2)||" is located in "||strip(building)||" - Room "||strip(office);
run;

proc print data=name2;
  var label;
run;

libname paul '\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets';
data paul.name1;
  set name1;
  keep fullname2 building office;
run;

data paul.name2;
  set name2;
  keep label;
run;

quit;
