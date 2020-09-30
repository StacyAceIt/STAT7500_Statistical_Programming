options center ps=60 ls=72;
dm'log;clear;output;clear;';


libname in '/folders/myfolders/STAT7500_Statistical_Programming/HW3/in';
libname output '/folders/myfolders/STAT7500_Statistical_Programming/HW3/output';
proc copy inlib=in outlib=output noclone datecopy ;
run;

data vs;
    set output.vs;
run;

proc sort data = vs;
    by SUBJID;
run;


data dm;
    set output.dm;
run;

proc sort data = dm;
    by SUBJID;
run;


data ex;
    set output.ex;
run;

proc sort data = ex;
    by SUBJID;
run;

data output.advs;
run;


data output.advs;
	merge dm ex;
	by SUBJID;
run;

data advs;
	set output.advs;
run;