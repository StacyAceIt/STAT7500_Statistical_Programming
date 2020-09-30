options center ps=60 ls=72;
dm'log;clear;out;clear;';


libname in '/folders/myfolders/STAT7500_Statistical_Programming/Mini-project1/in';
libname mp1 '/folders/myfolders/STAT7500_Statistical_Programming/Mini-project1/mp1';
proc copy inlib=in outlib=mp1 noclone datecopy ;
run;

data ae;
    set mp1.ae;
run;

proc sort data = ae;
    by SUBJID;
run;


data dm;
    set mp1.dm;
run;

proc sort data = dm;
    by SUBJID;
run;


data ex;
    set mp1.ex;
run;

proc sort data = ex;
    by SUBJID;
run;

data mp1.adae;
run;


data mp1.adae;
	merge dm ex ae;
	by SUBJID;
run;

data mp1.adae2;
	merge dm ex;
	by SUBJID;
run;

data adae;
	set mp1.adae;
run;

data adae;
	retain SUBJID IPISSUED Visit_Date;
	format Visit_Date date9. SUBJID $3. BRTHDT date9. RACE $34. SEX $6. ETHNIC $22.;
	set adae;
	SUBJID = SUBJID;
	BRTHDT = input(DTBIRTH,ddmmyy10.);
	
	ETHNIC = ETHNIC;
	if ETHNIC = '1' then ETHNIC = "Hispanic or Latino";
	if ETHNIC = '2' then ETHNIC = "Not Hispanic or Latino";
	
	if GENDER = '1' then SEX = "Male";
	if GENDER = '2' then SEX = "Female";
	
	if RACEWH = '5' then RACE = "Caucasian";
	if RACEHAW = '4' then RACE = "Haiwaiian or Other Pacific Islander";
	if RACEBL = '3' then RACE = "African American or Black";
	if RACENA = '2' then RACE = "Native American";
	if RACEAS = '1' then RACE = "Asian";
	if RACEOTH = '6' then RACE = "Other";
	

	drop DTBIRTH RACEWH RACEHAW RACEBL RACENA RACEAS RACEOTH GENDER;

run;

proc sort data = adae;
	by SUBJID IPISSUED Visit_Date;
run;

data adae;
	retain SUBJID Visit_Date IPISSUED TRTSDT;
	format TRTSDT date9.;
	set adae;

	if IPISSUED = '1' then do;
		by SUBJID;
		if first.SUBJID then TRTSDT = Visit_Date;
		retain TRTSDT;
	end;
	
run;

proc sort data = adae;
	by SUBJID IPISSUED descending Visit_Date;
run;

data adae;
	retain SUBJID Visit_Date IPISSUED TRTSDT TRTEDT; 
	format TRTEDT date9.;
	set adae;
	
	if IPISSUED = '1' then do;
		by SUBJID;
		if first.SUBJID then TRTEDT = Visit_Date;
		retain TRTEDT;
	end;
	
run;

proc sort data = adae;
	by SUBJID Visit_Date;
run;


data adae;
	set adae;
	format AGECAT $14. AETERM $37. AETRTEM $3. AESDT date9. AEEDT date9. TRTEDT date9.;
	
	
	AESDT = Date_Of_Onset;
	AEEDT = input(trim(Date_Of_Resolution),?? mmddyy10.);
	
	if AESDT ne . and TRTSDT ne . then AEDY = AESDT -TRTSDT +1;
	else AEDY =.;

	
	if TRTEDT ne . and TRTSDT ne . then TRTDUR = TRTEDT - TRTSDT +1;
	else TRTDUR =. ;
	
	if AESDT ne . and AESDT ge TRTSDT then AETRTEM = "yes"; 
	else AETRTEM = "no";
	
	if AEEDT ne . and AESDT ne . then AEDUR = AEEDT - AESDT + 1;
	else AEDUR =. ;

	if Description = "" then AETERM = "None";
	else AETERM = Description;
	
	if TRTSDT ne . and BRTHDT ne . then AGE = int((TRTSDT - BRTHDT)/365.25);
	else AGE =.;
	
	if AGE lt 65 then AGECAT = '<65 Years Old';
	if AGE ge 65 then AGECAT = '>=65 Years Old';

run;

data adae;
	set adae;
	drop  Date_Of_Onset Date_Of_Resolution Description IPISSUED Identifier Visit_Number Visit_Date;
run;

data adae;
	label SUBJID = 'Subject ID' BRTHDT = 'Date of Birth' AGE = 'Age(Years)' AGECAT = 'Age Category' RACE = 'Race'
		  SEX = 'Sex' ETHNIC = 'Ethnicity' TRTSDT = 'Treatment Start Date' TRTEDT = 'Treatment End Date' 
		  TRTDUR = 'Duration of Treatment(Days)' AESDT ='Adverse Event Start Date' AEEDT = 'Adverse Event End Date'
		  AEDY = 'Adverse Event Relative Day' AETRTEM = 'Treatment Emergent Flag' AEDUR = 'AE Duration(Days)' 
		  AETERM = 'Adverse Event Term'
		  ;
	set adae;
	retain SUBJID BRTHDT AGE AGECAT RACE SEX ETHNIC TRTSDT TRTEDT TRTDUR AESDT AEEDT AEDY AETRTEM AEDUR AETERM;

run;

proc sort data=adae noduprecs;
     by _all_ ; 
run;

data mp1.adae;
	set adae;
run;


