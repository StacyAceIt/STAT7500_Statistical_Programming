options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

libname paul '\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets';

* Example of importing a permanent SAS data set;

data newclub;
  set paul.newclub;
run;

proc contents data=newclub varnum;
  title 'Before Labels';
run;

data newclub1(label="Club Weight Loss Dataset");
  label id         = 'Club Member Identifier'
        team       = 'Weight Loss Team'
		name       = 'First Name'
		startwt    = 'Starting Weight (lbs)'
		endwt      = 'Ending Weight (lbs)'
		difference = 'Weight Lost (lbs)'
		percent    = 'Weight Loss Percentage'
		;
  set newclub;
run;

proc contents data=newclub1 varnum;
  title 'After Labels';
run;

quit;
