options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

libname paul '\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets';

* Part 1. Example of subsetting data sets using a set statement;

data club;
  set paul.newclub;
run;

proc freq data=club;
  title 'Unique team names';
  tables team;
run;


data redteam;
  set club;
  /* might be team -> table*/
  if team = 'red';
run;
 
data yelteam;
  set club;
  if team = 'yellow';
run;

proc print data=redteam;
  title 'Red Team Data';
run;

proc print data=yelteam;
  title 'Yellow Team Data';
run;

*Example of the Where statement;

proc print data=club (where=(team='red'));
  title 'Red Team Data Using the Where Statement';
run;

proc print data=club (where=(startwt>200));
  title 'Starting Data > 200 Using the Where Statement';
run;

*Example of the first. and last. commands;

proc sort data=club;
  by team percent;
run;

proc print data=club;
  title 'Sorted Data Set: Sorted by Team and Percentage';
run;

data nomiss;
  set club;
  if percent ~= .;
run;

proc print data=nomiss;
  title 'Sorted Data Set: Sorted by Team and Percentage W/O Missing ';
run;

proc sort data=nomiss;
  by team percent;
run;

data winner;
  set nomiss;
  by team;
  if first.team;
run;

proc print data=winner;
  title 'Data Set of Winners';
run;

data loser;
  set nomiss;
  by team;
  if last.team;
run;

proc print data=loser;
  title 'Data Set of Losers';
run;

*Example of Selecting Records by Letters of a Character Variable;

data allAs;
  set club;
  if name =: 'A';
run;

proc print data=allAs;
  title 'All Names that Start with the Letter A';
run;

*Example of Selecting Records by a Group of a Character Variable;

data AtoM;
  set club;
  if name <=: 'M';

proc print data=AtoM;
  title 'All Names that Start with Letters from A to M';
run;

quit;
