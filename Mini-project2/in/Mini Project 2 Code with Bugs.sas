options center nodate pageno=1;
dm'log;clear;out;clear;';

libname hw '\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets';

/* The following reads in the DM dataset and formats the demographic variables */
data dm;
  format RACE $34. SEX $2. ETHNIC_ $22.;
  set hw.dm;
  if RACENA  = 1 then RACE = 'Native American';
  if RACEAS  = 2 then RACE = 'Asian';
  if RACEBL  = 3 then RACE = 'African American or Black';
  if RACEHAW = 4 then RACE = 'Hawaiian or Other Pacific Islander';
  if RACEWH  = 5 then RACE = 'Caucasian';
  if RACEOTH = 6 then RACE = 'Other';

  if ETHNIC = 1 then ETHNIC_ = 'Hispanic or Latino';
  if ETHNIC = 2 then ETHNIC_ = 'Not Hispanic or Latino';

  if GENDER = 1 then SEX = 'Male';
  if GENDER = 2 then SEX = 'Female';

  BRTHDY = input(substr(DTBIRTH,1,2),best8.);
  BRTHMO = input(substr(DTBIRTH,4,2),best8.);
  BRTHYR = input(substr(DTBIRTH,7,4),best8.);

  keep SUBJID RACE SEX ETHNIC_ BRTHDY BRTHMO BRTHYR.
run;

data dm1;
  format ETHNIC $22. BRTHDATE date10.;
  set dm;
  ETHNIC = ETHNIC_;
  BRTHDT = mdyy(BRTHMO, BRTHDY, BRTHYR);
  drop ETHNIC_ BRTHMO BRTHDY BRTHYR;
run

/* The following reads in the EX data set and formats the exposure variables */
data ex;
  set hw.ex;
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
  if first.SUBJID;
  TRTEDT = VISIT_DAT;
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
  TRTDUR = TRTSDT - TRTEDT;
run;

proc sort data=ex1;
  by SUBJID;
run;

proc sort data=dm1;
  by SUBJID;
run;

data dmex;
  format AGECAT $15.;
  merge dm1 ex;
  by SUBJID;
  AGE = int((TRTSDT - BRTHDT)/365.25);
  if AGE ne . and AGE < 65 then AGECAT = '<65 Years Old';
  if AGE >= 65 then AGECAT = '>= 65 Years Old';
run;

/* The following reads in the AE dataset and formats the adverse event variables */
data ae;
  format AESDT date9. AETERM $37.;
  set hw.ae;
  if DATE_OF_ONSET ne . then AESDT = DATE_OF_ONSET;
  else AESDT = .;
  if DATE_OF_RESOLUTION ne '-' then do;
     AEENDDY = input(scan(DATE_OF_RESOLUTION,2,' '),best8.);
     AEENDMO = input(scan(DATE_OF_RESOLUTION,1,' '),best8.);
     AEENDYR = input(scan(DATE_OF_RESOLUTION,3,' '),best8.);
  AEEDT = mdy(AEENDMO, AEENDDY, AEENDYR);
  end;
  if DATE_OF_RESOLUTION eq '--' then AEEDT = .;

  if AESDT ne . and AEEDT ne . then AEDUR = AEEDT - AESDT + 1;

  AETERM = DESCRIP;
  keep SUBJID AESDT AEEDT AEDUR;
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

data hw.miniproj2;
  label SUBJID = 'Unique Subject Identifier'
        BRTHDT = 'Birth Date'
		AGE    = 'Age'
		AGECAT = 'Age Category'
		RACE   = 'Race'
		SEX    = 'Gender'
		ETHNIC = 'Ethnicity'
		TRTSDT = 'Treatment Start Date'
		TRTEDT = 'Treatment End Date'
		TRTDUR = 'Treatment Duration (Days)'
		AESDT  = 'Adverse Event Start Date'
		AEEDT  = 'Adverse Event End Date'
		AEDY   = 'Adverse Event Start Day'
		AETRTEM = 'Treatment Emergent Flag'
		AEDUR  = 'Adverse Event Duration'
		AETERM = 'Adverse Event Term'
	;
  set all;
run;

quit;
