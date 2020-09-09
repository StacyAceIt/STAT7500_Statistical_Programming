options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

libname paul '\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets';

data paper2;
  set paul.paper2;
run;

proc print data=paper2;
  title 'Full Data Set';
run;

/*This section selects only females'*/

data female;
  set paper2;
  if gender = 'Female';
run;

proc print data=female;
  title 'Only Females';
run;


/*This code keeps only demographic info*/

data femaledem;
  set female;
  keep PtID Age Gender RaceID Admit;
run;

proc print data=femaledem;
  title 'Example of the Keep Statement';
run;

/*This code drops gender*/

data femaledem (drop = gender);
  set femaledem;
run;

proc print data=femaledem;
  title 'Example of the Drop Statment';
run;


/*This code keeps the first 20 records*/
 
data femdem20obs;
  set femaledem(firstobs=1 obs=20);

proc print data=femdem20obs;
  title 'Example of Selecting a Few Records';
run;

quit;
