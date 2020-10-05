options center ps=60 ls=72;
dm'log;clear;out;clear;';
libname in '/folders/myfolders/STAT7500_Statistical_Programming/HW3/in';
libname out '/folders/myfolders/STAT7500_Statistical_Programming/HW3/out';

proc copy inlib=in outlib=out noclone datecopy;
run;

/* load dataset vs */
data vs;
	set out.vs;
run;

proc sort data=vs;
	by SUBJID;
run;

/* load dataset dm */
data dm;
	set out.dm;
run;

proc sort data=dm;
	by SUBJID;
run;

/* load dataset ex */
data ex;
	set out.ex;
run;

proc sort data=ex;
	by SUBJID;
run;

/* create dataset advs_ */
data out.advs_;
run;

data out.advs_;
	merge dm ex vs;
	by SUBJID;
run;

data advs_;
	set out.advs_;
run;

/* get 1 SUBJID 2 BRTHDT */
data advs_;
	retain SUBJID BRTHDT DTBIRTH;
	format SUBJID $3. BRTHDT date9.;
	set advs_;
	BRTHDT=input(DTBIRTH, ddmmyy10.);
run;

/* get 8 TRTSDT */
proc sort data=advs_;
	by SUBJID IPISSUED Visit_Date;
run;

data advs_;
	retain SUBJID Visit_Date IPISSUED TRTSDT;
	format TRTSDT date9.;
	set advs_;

	if IPISSUED='1' then
		do;
			by SUBJID;

			if first.SUBJID then
				TRTSDT=Visit_Date;
			retain TRTSDT;
		end;
run;

/* get 9 TRTEDT */
proc sort data=advs_;
	by SUBJID IPISSUED descending Visit_Date;
run;

data advs_;
	retain SUBJID Visit_Date IPISSUED TRTSDT TRTEDT;
	format TRTEDT date9.;
	set advs_;

	if IPISSUED='1' then
		do;
			by SUBJID;

			if first.SUBJID then
				TRTEDT=Visit_Date;
			retain TRTEDT;
		end;
run;

proc sort data=advs_;
	by SUBJID Visit_Date;
run;

/*get 3 age 4 agecat*/
data advs_;
	retain SUBJID AGE AGECAT TRTSDT BRTHDT;
	format AGE 3. AGECAT $14.;
	set advs_;

	if TRTSDT ne . and BRTHDT ne . then
		AGE=int((TRTSDT - BRTHDT)/365.25);
	else
		AGE=.;

	if AGE lt 65 then
		AGECAT='<65 Years Old';

	if AGE ge 65 then
		AGECAT='>=65 Years Old';
run;

/*get 5 race 6 sex 7 ethnic*/
data advs_;
	retain SUBJID RACE SEX ETHNIC;
	format RACE $34. SEX $6. ETHNIC $22.;
	set advs_;

	if ETHNIC='1' then
		ETHNIC="Hispanic or Latino";

	if ETHNIC='2' then
		ETHNIC="Not Hispanic or Latino";

	if GENDER='1' then
		SEX="Male";

	if GENDER='2' then
		SEX="Female";

	if RACEWH='5' then
		RACE="Caucasian";

	if RACEHAW='4' then
		RACE="Haiwaiian or Other Pacific Islander";

	if RACEBL='3' then
		RACE="African American or Black";

	if RACENA='2' then
		RACE="Native American";

	if RACEAS='1' then
		RACE="Asian";

	if RACEOTH='6' then
		RACE="Other";
	drop DTBIRTH RACEWH RACEHAW RACEBL RACENA RACEAS RACEOTH GENDER;
run;

/*get 10. VISITNUM from Visit */
data advs_;
	retain SUBJID VISITNUM Visit_Number;
	set advs_;
	format VISITNUM 3.;
	VISITNUM=input(Visit_Number, 3.);
run;

/*get 11. VISIT from Visit_Name */
data advs_;
	retain SUBJID VISIT Visit_Name;
	format VISIT $21.;
	set advs_;
	VISIT=Visit_Name;
run;

/*get 12. format VDST from Num to Date9. */
data advs_;
	retain SUBJID VSDT;
	format VSDT Date9.;
	set advs_;
run;

proc sort data=advs_;
	by SUBJID VISIT;
run;

/*
https://support.sas.com/resources/papers/proceedings09/060-2009.pdf
https://www.pharmasug.org/proceedings/2012/TF/PharmaSUG-2012-TF03.pdf
*/
proc transpose data=advs_ out=advs_ (rename=(col1=AVAL)) name=PARAM;
	by SUBJID VISIT;
	var HEIGHT WEIGHT BP_SYS BP_DIA TEMP HRTRATE;
	copy BRTHDT AGE AGECAT RACE SEX ETHNIC TRTSDT TRTEDT VISITNUM VSDT;
run;

/* fill missing values in
BRTHDT AGE AGECAT RACE SEX ETHNIC TRTSDT TRTEDT VISITNUM VSDT
*/
/* https://www.creative-wisdom.com/pub/DIN_Yu.pdf
https://communities.sas.com/t5/SAS-Programming/Fill-missing-values-with-the-previous-values/td-p/326233
*/
%macro process(variable);
	if &variable ne . then _&variable=&variable;
	retain _&variable;
	if &variable eq . then &variable=_&variable;
	drop _&variable;
%mend;

%macro process1(variable);
	if &variable ne ' ' then _&variable=&variable;
	retain _&variable;
	if &variable eq ' ' then &variable=_&variable;
	drop _&variable;
%mend;

data advs_;
	set advs_;
	%process(BRTHDT);
	%process(AGE);
	%process1(AGECAT);
	%process1(RACE);
	%process1(SEX);
	%process1(ETHNIC);
	%process(TRTSDT);
	%process(TRTEDT);
	%process(VISITNUM);
	%process(VSDT);
run;

/*get 13. get PARAMN and PARAM (char)
1 for HEIGHT
2 for WEIGHT
3 for BP_SYS
4 for BP_DIA
5 for TEMP
6 for HRTRATE
*/
data advs_;
	retain SUBJID PARAMN PARAM AVAL;
	format PARAMN 2. PARAM $40.;
	set advs_;

	if PARAM='HEIGHT' then
		do;
			PARAMN=1;
			PARAM='Height(cm)';
		end;

	if PARAM='WEIGHT' then
		do;
			PARAMN=2;
			PARAM='Weight(kg)';
		end;

	if PARAM='BP_SYS' then
		do;
			PARAMN=3;
			PARAM='Systolic Blood Pressure(mmHg)';
		end;

	if PARAM='BP_DIA' then
		do;
			PARAMN=4;
			PARAM='Diastolic Blood Pressure(mmHg)';
		end;

	if PARAM='TEMP' then
		do;
			PARAMN=5;
			PARAM='Temperature(F)';
		end;

	if PARAM='HRTRATE' then
		do;
			PARAMN=6;
			PARAM='Heart Rate(beats/min)';
		end;
run;


/*get 15. ABLFL char $3.*/
data advs_;
	retain SUBJID ABLFL VISIT;
	format ABLFL $3.;
	set advs_;

	if VISIT ne 'Randomization' then ABLFL = ' ';
	else ABLFL = 'YES';

run;

/*
proc print data=advs_;
run;
*/

/* get BASE CHG */
proc sort data=advs_ out=advs_1;
	by SUBJID PARAMN VISIT;
run;


data advs_2;
	retain SUBJID temp PARAMN ABLFL BASE AVAL CHG;
	set advs_1;
	format CHG 8.1;
   
    if AVAL eq '--' then AVALn=.;
    if AVAL ne '--' then AVALn=input(AVAL,6.);
    
    /* cannot directly change type like AVAL = input(AVAL,6.); */   

	if ABLFL='YES' and AVALn ne . then
		BASE=AVALn;
	else
		BASE=.;

	by SUBJID PARAMN;
	if first.PARAMN then
		temp=BASE;
	else
		BASE=temp;
	drop temp;


	if AVALn ne . and BASE ne . then
		CHG=AVALn - BASE;
	else
		CHG=.;
    
    drop AVAL;
    rename AVALn = AVAL;
    
    /*
    %gettype(AVALn);
    drop AVALn_;
    %gettype(AVAL);
    drop AVAL_;
    */
run;

proc print data=advs_2(obs = 10);
run;


data advs_2;
	label SUBJID='Subject Identifier' BRTHDT='Birth Date' AGE='Age' 
		AGECAT='Age Category' RACE='Race' SEX='Sex' ETHNIC='Ethnicity' 
		TRTSDT='Treatment Start Date' TRTEDT='Treatment End Date' 
		VISITNUM='Visit Number' VISIT='Visit' VSDT='Vital Signs Assessment Date' 
		PARAMN='Vital Signs Assessment Date' PARAM='Parameter' 
		ABLFL='Baseline Flag for Analysis' AVAL='Analysis Value' 
		BASE='Baseline Value' CHG='Change from Baseline';
	set advs_2;
	retain SUBJID BRTHDT AGE AGECAT RACE SEX ETHNIC TRTSDT TRTEDT VISITNUM VISIT 
		VSDT PARAMN PARAM ABLFL AVAL BASE CHG;
run;

proc print data=advs_2;
run;

proc sort data=advs_2 noduprecs out=out.advs_1;
	by SUBJID PARAMN VISITNUM;
run;