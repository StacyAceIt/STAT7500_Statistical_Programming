options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

libname paul '\\artscistore.vuad.villanova.edu\users\plupinac\MAT 7500\Spring 2018\Datasets';

/* The following illustrates the input command. the input command changes the character day, month, year variables to a numeric */
data clubdate1;
  format stdaten enddaten date9.;
  set paul.clubdate1;
  stday = input(stdy, 2.0);
  if stmo = 'MAR' then stmon = 3;
  if stmo = 'APR' then stmon = 4;
  if stmo = 'MAY' then stmon = 5;
  if stmo = 'JUN' then stmon = 6;
  styear = input(styr, 4.0);
  stdaten = mdy(stmon, stday, styear);

  if enddt ne ' ' then do;
     enday = input(endy, 2.0);
     if enmo = 'SEP' then enmon = 9;
     if enmo = 'OCT' then enmon = 10;
     enyear = input(enyr, 4.0);
  enddaten = mdy(enmon, enday, enyear);
  end;
  if enddaten ne . and stdaten ne . then days = enddaten - stdaten;
run;

proc print data=clubdate1;
run;


/* The following illustrates the put command */

data clubdate2;
  set clubdate1;
  keep id stmon stday styear;
run;

data clubdate2;
  format charday $4.;
  set clubdate1;
  charday = compress((put(stday, 2.0)));
  charmon = put(stmon, 1.0);
  charyr  = put(styear, 4.0);
run;

proc print data=clubdate2;
run;

quit;
