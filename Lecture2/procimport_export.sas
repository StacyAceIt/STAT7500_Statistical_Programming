options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

* Example of importing a data set from an Excel Spreadsheet;
path = "/folders/myfolders/STAT7500_Statistical_Programming/Lecture2"
PROC IMPORT OUT= club DATAFILE= "\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets\data1.xls" 
            DBMS=xls REPLACE;
     /*SHEET="XXXX";*/ 
     GETNAMES=YES;
RUN;

/*if an xlsx worksheet */
PROC IMPORT OUT= clubxlsx DATAFILE= "\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets\data1xlsx.xlsx" 
            DBMS=xlsx REPLACE;
     /*SHEET="XXXX";*/ 
    GETNAMES=YES;
RUN;

proc print data=club;
  title 'Data Set from an Excel Spreadsheet';
run;


* Example of exporting a SAS data set to an Excel Spreadsheet;
proc export
  data=club
  dbms=xlsx
  outfile="\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets\data1export"
  replace;
run;
quit;
