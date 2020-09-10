options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

*Example of merging two datasets: 1 to 1 match;

data data1;
  input ID A B @@;
  cards;
  10 1 2  20 3 4  30 5 6  40 7 8
;
 
proc print data=data1;
  title 'Dataset 1';
run;

data data2;
  input ID C @@;
  cards;
  10 12  40 14  30 16  20 18
;

proc print data=data2;
  title 'Dataset 2';
run;

proc sort data=data1;
  by id;
run;

proc sort data=data2;
  by id;
run;

data data12;
  merge data1 data2;
  by id;
run;

proc print data=data12;
  title 'Merged Datasets';
run;
 
*The following illustrates the merge on unbalanced data;

data data3;
  input ID D @@;
  cards;
  10 0  20 1  40 2
;

proc print data=data3;
  title 'Dataset 3';
run;

proc sort data=data3;
  by id;
run;

data data13;
  merge data1 data3;
  by id;
run;

proc print data=data13;
  title 'Merged datasets- Unbalanced';
run;

*The following merges two datasets and only keeps matches;

data match;
  merge data1(in=x) data3(in=y);
  by id;
  if x=1 and y=1;
run;

proc print data=match;
  title 'Merged data for matches';
run;

*The following merges two datasets and keeps track of the matches;

data match
     inxonly
	 inyonly;
	 merge data1(in=x) data3(in=y);
	 by id;
	 if x=1 and y=1 then output match;
     if x=1 and y=0 then output inxonly;
     if x=0 and y=1 then output inyonly;
run;

proc print data=match;
  title 'only matches';
run;

proc print data=inxonly;
  title 'in x only';
run;

proc print data=inyonly;
  title 'in y only';
run;

*The following code illustrates a many to one merge;

data data4;
 input ID E @@;
 cards;
 10 1  10 2  10 3  20 2  30 3  30 4  40 5  40 6
 ;

proc print data=data1;
  title 'Dataset1';
run;

proc print data=data4;
  title 'Dataset 4';
run;

data mergemany;
  merge data1 data4;
  by id;
run;

proc print data=mergemany;
  title 'Merged Datasets with Different Records';
run;


quit;
