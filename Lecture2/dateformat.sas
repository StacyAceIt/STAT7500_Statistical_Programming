/*****************************************/
/* This program illustrates date formats */
/*****************************************/

options center nodate pageno=1 ls=70 ps=60;
dm'log;clear;out;clear;';

data hospital;
  input id hospyn $ day month year;
  cards;
  1  no .  .    .
  2 yes 22  3 2004
  3 yes 17  1 2006
  4 yes 18 10 2005
  5  no  .  .    .
  6 yes  1  6 2007
;
run;

proc print data=hospital;
  title 'Print of Hospital Data';
run;

data hosp1;
  set hospital;
  hospdate = mdy(month, day, year);
run;

proc print data=hosp1;
  title 'Print of Hospital Data with Date';
run;

data hosp2;
  format hosp1 date9. hosp2 date8. hosp3 ddmmyy8. hosp4 ddmmyy9. hosp5 ddmmyy10. 
         hosp6 ddmmyyd10. hosp7 ddmmyyp10. hosp8 worddate. hosp9 e8601DA.;
  set hosp1;
  hosp1 = hospdate;
  hosp2 = hospdate;
  hosp3 = hospdate;
  hosp4 = hospdate;
  hosp5 = hospdate;
  hosp6 = hospdate;
  hosp7 = hospdate;
  hosp8 = hospdate;
  hosp9 = hospdate;
run;

proc print data=hosp2;
  title 'Print of Hospital Data with Date Formats';
run;

proc export
  data=hosp2
  dbms=xlsx
  outfile="\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets\hosp2.xls"
  replace;
run;
quit;
