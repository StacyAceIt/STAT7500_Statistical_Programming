options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

libname paul '\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets';
data name1;
  set paul.name1;
run;

/* The following illustrates the scan command */
data name1;
  format last1 last2 last3 $9. first1 first2 $7.;
  set name1;
  first1 = scan(fullname2,1);
  first2 = scan(fullname2,-2);
  last1 = scan(fullname2,2);
  last2 = scan(fullname2,-1);
  last3 = scan(fullname2,2, ' ');
run;

proc print data=name1;
run;

data name2;
  format last $9. room $3.;
  set paul.name2;
  last = scan(label,2," ");
  room = scan(label,9," ");
run;

proc print data=name2;
run;

data clubdate2;
   set paul.clubdate;
   if startdt ne ' ' then do;
      stdy = scan(startdt,1,'-');
	  stmo = scan(startdt,2,'-');
	  styr = scan(startdt,3,'-');
   end;
   if enddt ne ' ' then do;
      endy = scan(enddt,1,'-');
	  enmo = scan(enddt,2,'-');
	  enyr = scan(enddt,3,'-');
   end;
   keep id startdt stdy stmo styr enddt endy enmo enyr;
run;

proc print data=clubdate2;
run;
quit;
