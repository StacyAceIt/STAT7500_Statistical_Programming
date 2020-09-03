options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

libname stacy2 '/folders/myfolders/Lecture1';

* Example of the raw data entry and creating a permanent SAS data set;

data club;
  input id name $ team $ startwt endwt;
  cards;
  1023 David red 189 165
  1049 Amelia yellow 145 124
  1219 Alan red 210 192
  1246 Ravi yellow 194 .
  1078 Ashley red 127 118
  1221 Jim yellow 220 204
  ;
run;

data stacy2.permclub;
  set club;
run;

quit;