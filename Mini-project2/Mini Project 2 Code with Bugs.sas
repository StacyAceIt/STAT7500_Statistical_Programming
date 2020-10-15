options center nodate pageno=1;
dm'log;clear;out;clear;';

libname in '/folders/myfolders/STAT7500_Statistical_Programming/Mini-project2/in';
libname out '/folders/myfolders/STAT7500_Statistical_Programming/Mini-project2/out';
proc copy inlib=in outlib=out noclone datecopy ;
run;

/* The following reads in the DM dataset and formats the demographic variables */
data dm;
  format RACE $34. SEX $6. ETHNIC_ $22.;
  set out.dm;
  if RACENA  = '1' then RACE = 'Native American';
  if RACEAS  = '2' then RACE = 'Asian';
  if RACEBL  = '3' then RACE = 'African American or Black';
  if RACEHAW = '4' then RACE = 'Hawaiian or Other Pacific Islander';
  if RACEWH  = '5' then RACE = 'Caucasian';
  if RACEOTH = '6' then RACE = 'Other';

  if ETHNIC = '1' then ETHNIC_ = 'Hispanic or Latino';
  if ETHNIC = '2' then ETHNIC_ = 'Not Hispanic or Latino';

  if GENDER = '1' then SEX = 'Male';
  if GENDER = '2' then SEX = 'Female';

  BRTHDY = input(substr(DTBIRTH,1,2),best8.);
  BRTHMO = input(substr(DTBIRTH,4,2),best8.);
  BRTHYR = input(substr(DTBIRTH,7,4),best8.);

  keep SUBJID RACE SEX ETHNIC_ BRTHDY BRTHMO BRTHYR;
run;

data dm1;
  format ETHNIC $22.;
  set dm;
  ETHNIC = ETHNIC_;
  
  BRTHDT = mdy(BRTHMO, BRTHDY, BRTHYR);
  format BRTHDT date9.;
  drop ETHNIC_ BRTHMO BRTHDY BRTHYR;
run;

/* The following reads in the EX data set and formats the exposure variables */
data ex;
  set out.ex;
  if IPISSUED = '1';
run;

proc sort data=ex;
  by SUBJID VISIT_NUMBER;
run;

data starttx;
  format TRTSDT date9.;
  set ex;
  by SUBJID;
  if first.SUBJID;
  TRTSDT = VISIT_DATE;
  keep SUBJID TRTSDT;
run;

data endtx;
  format TRTEDT date9.;
  set ex;
  by SUBJID;
  if last.SUBJID;
  TRTEDT = VISIT_DATE;
  keep SUBJID TRTEDT;
run;

proc sort data=starttx;
  by SUBJID;
run;

proc sort data=endtx;
  by SUBJID;
run;

data ex1;
  merge starttx endtx;
  by SUBJID;
  TRTDUR = TRTEDT - TRTSDT + 1;
run;

proc sort data=ex1;
  by SUBJID;
run;

proc sort data=dm1;
  by SUBJID;
run;

data dmex;
  format AGECAT $15.;
  merge dm1 ex1;
  by SUBJID;
  AGE = int((TRTSDT - BRTHDT)/365.25);
  if AGE ne . and AGE < 65 then AGECAT = '<65 Years Old';
  if AGE ne . and AGE >= 65 then AGECAT = '>= 65 Years Old';
run;

/* The following reads in the AE dataset and formats the adverse event variables */
data ae;
  format AESDT date9. AETERM $37.;
  set out.ae;
  if DATE_OF_ONSET ne . then AESDT = DATE_OF_ONSET;
  else AESDT = .;
  if DATE_OF_RESOLUTION ne '--' then do;
     AEENDDY = input(scan(DATE_OF_RESOLUTION,2,'/'),best8.);
     AEENDMO = input(scan(DATE_OF_RESOLUTION,1,'/'),best8.);
     AEENDYR = input(scan(DATE_OF_RESOLUTION,3,'/'),best8.);
  AEEDT = mdy(AEENDMO, AEENDDY, AEENDYR);
  format AEEDT date9.;
  end;
  if DATE_OF_RESOLUTION eq '--' then AEEDT = .;

  if AESDT ne . and AEEDT ne . then AEDUR = AEEDT - AESDT + 1;

  if Description ne ' ' then AETERM = Description;
  if Description eq ' ' then AETERM = "None";
  
  keep SUBJID AESDT AEEDT AEDUR AETERM;
run;

proc sort data=ae;
  by SUBJID;
run;

proc sort data=dmex;
  by SUBJID;
run;

data all;
  merge dmex ae;
  by SUBJID;
run;

data all1;
  format AETRTEM $3.;
  set all;
  if AETERM eq ' ' then AETERM = 'None';
  if AESDT ne . and TRTSDT ne . then AEDY = AESDT - TRTSDT + 1;
  if AEDY > 1 then AETRTEM = 'Yes';
  else AETRTEM = 'No';
run;

proc sort data=all1;
  by SUBJID AESDT;
run;

data out.miniproj2;
  label SUBJID = 'Subject ID'
        BRTHDT = 'Date of Birth '
		AGE    = 'Age (Years)'
		AGECAT = 'Age Category'
		RACE   = 'Race'
		SEX    = 'Sex'
		ETHNIC = 'Ethnicity'
		TRTSDT = 'Treatment Start Date'
		TRTEDT = 'Treatment End Date'
		TRTDUR = 'Duration of Treatment (Days)'
		AESDT  = 'Adverse Event Start Date'
		AEEDT  = 'Adverse Event End Date'
		AEDY   = 'Adverse Event Relative Day'
		AETRTEM = 'Treatment Emergent Flag'
		AEDUR  = 'AE Duration (Days)'
		AETERM = 'Adverse Event Term'
	;
  set all1;
run;

proc compare base=out.miniproj2
             compare=out.adae novalues;
run;

quit;
