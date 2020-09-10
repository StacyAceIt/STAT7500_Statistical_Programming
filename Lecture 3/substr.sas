options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

libname paul '\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets';
data name1;
  set paul.name1;
run;

/* The following illustrates the substr command */
data clubdate;
  set paul.clubdate;
run;

data clubdate1;
   set clubdate;
   if startdt ne ' ' then do;
      stdy = substr(startdt,1,2);
	  stmo = substr(startdt,4,3);
	  styr = substr(startdt,8,4);
   end;
   if enddt ne ' ' then do;
      endy = substr(enddt,1,2);
	  enmo = substr(enddt,4,3);
	  enyr = substr(enddt,8,4);
   end;
   keep id startdt stdy stmo styr enddt endy enmo enyr;
run;

proc print data=clubdate1;
run;

data paul.clubdate1;
  set clubdate1;
run;

