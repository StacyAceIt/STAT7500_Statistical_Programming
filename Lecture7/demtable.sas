/*********************************************************************/
/*                   XXXXXX PHARMACEUTICALS,INC                      */
/*                      PROTOCOL XXX-XXX-XXX                         */
/*                                                                   */
/* Program: demtable.sas                                             */
/* Purpose: This program creates the BASELINE DEMOGRAPHICS table     */
/*          - SAFETY POPULATION                                      */
/*                                                                   */
/* Input data: ADSL                                                  */
/* Output: demtable.rtf                                              */
/*                                                                   */
/* History - Version 1.0                                             */
/* - Date Programming was Started:  November 19, 2014                */
/*********************************************************************/

options validvarname=upcase nofmterr nonumber nodate center ;
dm'log;clear;out;clear;';

%let progname=demtable;

libname ads '\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Datasets';

proc datasets nolist library=work kill;
run;
quit;

/*************************** Macros used in the program ****************************************/

%macro sort(datain=, byvar=);
  proc sort data=&datain;
    by &byvar;
  run;
%mend;

%macro means(datain= ,dataout= ,group= ,var= , basenum= ,meannum= ,stdnum= );
data group&group;
  set &datain;
  if trtpn=&group and saffl='Yes';
run;

proc univariate data=group&group noprint;
  var &var;
  output out=&dataout n=n mean=mean stderr=stderr std=sd median=median min=min max=max;
run;

data &dataout (keep= label val&group order);
  format label $50. val&group $15.;
  set &dataout;

  lb95 = mean - (tinv(0.975,n-1)*sd/sqrt(n));
  ub95 = mean + (tinv(0.975,n-1)*sd/sqrt(n));

  order=0;

  order=order+1;
  label="N";
  val&group=compress(put(n,12.0));
  output;

  order=order+1;
  label="Mean";
  val&group=compress(put(mean,&meannum));
  output;

  order=order+1;
  label="Standard Deviation";
  val&group=compress(put(sd,&stdnum));
  output;

  order=order+1;
  label="Median";
  val&group=compress(put(median,&meannum));
  output;

  order=order+1;
  label="Minimum";
  val&group=compress(put(min,&basenum));
  output;

  order=order+1;
  label="Maximum";
  val&group=compress(put(max,&basenum));
  output;

  /*
  order=order+1;
  label = "95% Confidence Interval";
  val&group="("||compress(put(lb95,&meannum))||", "||compress(put(ub95,&meannum))||")";
  output;
  */
run;
%mend;

%macro meanstot(datain= ,dataout= ,var= , basenum= ,meannum= ,stdnum= );
data &datain;
  set &datain;
  if saffl='Yes';
run;

proc univariate data=&datain noprint;
  var &var;
  output out=&dataout n=n mean=mean stderr=stderr std=sd median=median min=min max=max;
run;

data &dataout (keep= label valtot order);
  format label $50. valtot $15.;
  set &dataout;

  lb95 = mean - (tinv(0.975,n-1)*sd/sqrt(n));
  ub95 = mean + (tinv(0.975,n-1)*sd/sqrt(n));

  order=0;

  order=order+1;
  label="N";
  valtot=compress(put(n,12.0));
  output;

  order=order+1;
  label="Mean";
  valtot=compress(put(mean,&meannum));
  output;

  order=order+1;
  label="Standard Deviation";
  valtot=compress(put(sd,&stdnum));
  output;

  order=order+1;
  label="Median";
  valtot=compress(put(median,&meannum));
  output;

  order=order+1;
  label="Minimum";
  valtot=compress(put(min,&basenum));
  output;

  order=order+1;
  label="Maximum";
  valtot=compress(put(max,&basenum));
  output;

  /*
  order=order+1;
  label = "95% Confidence Interval";
  valtot="("||compress(put(lb95,&meannum))||", "||compress(put(ub95,&meannum))||")";
  output;
  */

run;
%mend;

%macro getcnt(indata=, byvar=,  outdata=) ;
   ** GET COUNT **;
   proc freq data = &indata noprint ;
      by &byvar ;
	  tables trtpn / out = &outdata ;
   run ;   

   ** TRANSPOSE TRT COUNTS **;
   proc transpose data = &outdata out=&outdata (drop=_name_ _label_) prefix=cnt ;
      by &byvar ;
      id trtpn;
      var count ;
   run ;  
%mend;

%macro getcnttot(indata=, byvar=,  outdata=) ;
   ** GET COUNT **;
   proc freq data = &indata noprint ;
      by &byvar ;
	  tables saffl / out = &outdata ;
   run ;   

   ** TRANSPOSE TRT COUNTS **;
   proc transpose data = &outdata out=&outdata (drop=_name_ _label_) prefix=cnt ;
      by &byvar ;
      id saffl;
      var count ;
   run ;  
%mend;

/*********************************************************************************************/

/* The following reads in ADSL */
data adsl ;
  set ads.adsl;
  if saffl='Yes';
run;


/* Calculates the number of patients per treatment group overall */

proc sql;
  select left(put(count(distinct subjid),1.)) into :n0 from adsl  where trtpn=0;
  select left(put(count(distinct subjid),1.)) into :n1 from adsl  where trtpn=1;
  select left(put(count(distinct subjid),1.)) into :n2 from adsl  where trtpn=2;
  select left(put(count(distinct subjid),1.)) into :n3 from adsl  where trtpn=3;
  select left(put(count(distinct subjid),1.)) into :n4 from adsl  where trtpn=4;
  select left(put(count(distinct subjid),1.)) into :n5 from adsl  where trtpn=5;
  select left(put(count(distinct subjid),1.)) into :n6 from adsl  where trtpn=6;
  select left(put(count(distinct subjid),2.)) into :ntot   from adsl  where saffl='Yes';
quit;


/* Calculates the summary statistics and outputs the dataset */
*Gender;
%sort(datain=adsl, byvar=sex);
%getcnt(indata=adsl, byvar=sex,  outdata=sexcnt) ;

data sexcnt ;
  format label $50. val0 val1 val2 val3 val4 val5 val6 $15.;
  set sexcnt;
  if sex='Female'  then do; label = 'Female';  order=1; end;
  if sex='Male'    then do; label = 'Male';    order=2; end;
  if sex=' '       then do; label = 'Missing'; order=3; end;
  ord=1;
  if cnt0=. then cnt0=0;
  if cnt1=. then cnt1=0;
  if cnt2=. then cnt2=0;
  if cnt3=. then cnt3=0;
  if cnt4=. then cnt4=0;
  if cnt5=. then cnt5=0;
  if cnt6=. then cnt6=0;
  pct0 = (cnt0 / &n0)*100;
  val0 = compress(put(cnt0,12.0))||" ("||compress(put(pct0,12.1))||"%)";
  pct1 = (cnt1 / &n1)*100;
  val1 = compress(put(cnt1,12.0))||" ("||compress(put(pct1,12.1))||"%)";
  pct2 = (cnt2 / &n2)*100;
  val2 = compress(put(cnt2,12.0))||" ("||compress(put(pct2,12.1))||"%)";
  pct3 = (cnt3 / &n3)*100;
  val3 = compress(put(cnt3,12.0))||" ("||compress(put(pct3,12.1))||"%)";
  pct4 = (cnt4 / &n4)*100;
  val4 = compress(put(cnt4,12.0))||" ("||compress(put(pct4,12.1))||"%)";
  pct5 = (cnt5 / &n5)*100;
  val5 = compress(put(cnt5,12.0))||" ("||compress(put(pct5,12.1))||"%)";
  pct6 = (cnt6 / &n6)*100;
  val6 = compress(put(cnt6,12.0))||" ("||compress(put(pct6,12.1))||"%)";
run;

%getcnttot(indata=adsl, byvar=sex,  outdata=sextot) ;

data sextot ;
  format valtot $15.;
  set sextot;
  if sex='Female' then order=1;
  if sex='Male'   then order=2; 
  if sex=' '      then order=3; 
  ord=1;
  if cntyes=. then cntyes=0;
  pcttot = (cntyes / &ntot)*100;
  valtot = compress(put(cntyes,12.0))||" ("||compress(put(pcttot,12.1))||"%)";
run;


%sort(datain=sexcnt,  byvar=order);
%sort(datain=sextot,  byvar=order);

data sexuse;
  merge sexcnt sextot;
  by order;
run;



*Race;
%sort(datain=adsl, byvar=race);
%getcnt(indata=adsl, byvar=race,  outdata=racecnt) ;

data racecnt ;
  format label $50. val0 val1 val2 val3 val4 val5 val6 $15.;
  set racecnt;
  if race='Asian'  then do; label = 'Asian';  order=1; end;
  if race='Black or African American'  then do; label = 'Black or African American';  order=2; end;
  if race='White'  then do; label = 'White';  order=3; end;
  if race='Other'  then do; label = 'Other';  order=4; end;
  if race=' '  then do; label = 'Missing';  order=5; end;
  ord=3;
  if cnt0=. then cnt0=0;
  if cnt1=. then cnt1=0;
  if cnt2=. then cnt2=0;
  if cnt3=. then cnt3=0;
  if cnt4=. then cnt4=0;
  if cnt5=. then cnt5=0;
  if cnt6=. then cnt6=0;
  pct0 = (cnt0 / &n0)*100;
  val0 = compress(put(cnt0,12.0))||" ("||compress(put(pct0,12.1))||"%)";
  pct1 = (cnt1 / &n1)*100;
  val1 = compress(put(cnt1,12.0))||" ("||compress(put(pct1,12.1))||"%)";
  pct2 = (cnt2 / &n2)*100;
  val2 = compress(put(cnt2,12.0))||" ("||compress(put(pct2,12.1))||"%)";
  pct3 = (cnt3 / &n3)*100;
  val3 = compress(put(cnt3,12.0))||" ("||compress(put(pct3,12.1))||"%)";
  pct4 = (cnt4 / &n4)*100;
  val4 = compress(put(cnt4,12.0))||" ("||compress(put(pct4,12.1))||"%)";
  pct5 = (cnt5 / &n5)*100;
  val5 = compress(put(cnt5,12.0))||" ("||compress(put(pct5,12.1))||"%)";
  pct6 = (cnt6 / &n6)*100;
  val6 = compress(put(cnt6,12.0))||" ("||compress(put(pct6,12.1))||"%)";
run;

%getcnttot(indata=adsl, byvar=race,  outdata=racetot) ;

data racetot ;
  format valtot $15. label $50.;
  set racetot;
  if race='Asian'  then do; label = 'Asian';  order=1; end;
  if race='Black or African American'  then do; label = 'Black or African American';  order=2; end;
  if race='White'  then do; label = 'White';  order=3; end;
  if race='Other'  then do; label = 'Other';  order=4; end;
  if race=' '  then do; label = 'Missing';  order=5; end;
  ord=3;
  if cntyes=. then cntyes=0;
  pcttot = (cntyes / &ntot)*100;
  valtot = compress(put(cntyes,12.0))||" ("||compress(put(pcttot,12.1))||"%)";
run;


%sort(datain=racecnt,  byvar=order);
%sort(datain=racetot,  byvar=order);

data raceuse;
  merge racecnt racetot;
  by order;
run;


*Ethnicity;
%sort(datain=adsl, byvar=ethnic);
%getcnt(indata=adsl, byvar=ethnic,  outdata=ethcnt) ;

data ethcnt ;
  format label $50. val0 val1 val2 val3 val4 val5 val6 $15.;
  set ethcnt;
  if ethnic='Hispanic or Latino'  then do; label = 'Hispanic or Latino';  order=1; end;
  if ethnic='Not Hispanic or Latino' then do; label = 'Not Hispanic or Latino';  order=2; end;
  if ethnic=' '       then do; label = 'Missing'; order=3; end;
  ord=4;
  if cnt0=. then cnt0=0;
  if cnt1=. then cnt1=0;
  if cnt2=. then cnt2=0;
  if cnt3=. then cnt3=0;
  if cnt4=. then cnt4=0;
  if cnt5=. then cnt5=0;
  if cnt6=. then cnt6=0;
  pct0 = (cnt0 / &n0)*100;
  val0 = compress(put(cnt0,12.0))||" ("||compress(put(pct0,12.1))||"%)";
  pct1 = (cnt1 / &n1)*100;
  val1 = compress(put(cnt1,12.0))||" ("||compress(put(pct1,12.1))||"%)";
  pct2 = (cnt2 / &n2)*100;
  val2 = compress(put(cnt2,12.0))||" ("||compress(put(pct2,12.1))||"%)";
  pct3 = (cnt3 / &n3)*100;
  val3 = compress(put(cnt3,12.0))||" ("||compress(put(pct3,12.1))||"%)";
  pct4 = (cnt4 / &n4)*100;
  val4 = compress(put(cnt4,12.0))||" ("||compress(put(pct4,12.1))||"%)";
  pct5 = (cnt5 / &n5)*100;
  val5 = compress(put(cnt5,12.0))||" ("||compress(put(pct5,12.1))||"%)";
  pct6 = (cnt6 / &n6)*100;
  val6 = compress(put(cnt6,12.0))||" ("||compress(put(pct6,12.1))||"%)";
run;

%getcnttot(indata=adsl, byvar=ethnic,  outdata=ethtot) ;

data ethtot ;
  format label $50. valtot $15.;
  set ethtot;
  if ethnic='Hispanic or Latino'  then do; label = 'Hispanic or Latino';  order=1; end;
  if ethnic='Not Hispanic or Latino' then do; label = 'Not Hispanic or Latino';  order=2; end;
  if ethnic=' '       then do; label = 'Missing'; order=3; end;
  ord=4;
  if cntyes=. then cntyes=0;
  pcttot = (cntyes / &ntot)*100;
  valtot = compress(put(cntyes,12.0))||" ("||compress(put(pcttot,12.1))||"%)";
run;


%sort(datain=ethcnt,  byvar=order);
%sort(datain=ethtot,  byvar=order);

data ethuse;
  merge ethcnt ethtot;
  by order;
run;


*Age;
proc means data=adsl (where=(trtpn=0));
  var age;
  output out=temp n=n mean=mean stderr=stderr std=sd median=median min=min max=max;
run;

%sort(datain=adsl, byvar=trtpn);
%means(datain=adsl, dataout=age0, group=0,var= age, basenum=12.0 ,meannum=12.1 ,stdnum=12.2 );
%means(datain=adsl, dataout=age1, group=1,var= age, basenum=12.0 ,meannum=12.1 ,stdnum=12.2 );
%means(datain=adsl, dataout=age2, group=2,var= age, basenum=12.0 ,meannum=12.1 ,stdnum=12.2 );
%means(datain=adsl, dataout=age3, group=3,var= age, basenum=12.0 ,meannum=12.1 ,stdnum=12.2 );
%means(datain=adsl, dataout=age4, group=4,var= age, basenum=12.0 ,meannum=12.1 ,stdnum=12.2 );
%means(datain=adsl, dataout=age5, group=5,var= age, basenum=12.0 ,meannum=12.1 ,stdnum=12.2 );
%means(datain=adsl, dataout=age6, group=6,var= age, basenum=12.0 ,meannum=12.1 ,stdnum=12.2 );
%sort(datain=age0, byvar=order);
%sort(datain=age1, byvar=order);
%sort(datain=age2, byvar=order);
%sort(datain=age3, byvar=order);
%sort(datain=age4, byvar=order);
%sort(datain=age5, byvar=order);
%sort(datain=age6, byvar=order);
data ageout;
  merge  age0 age1 age2 age3 age4 age5 age6;
  by order;
  ord = 2;
run;


%meanstot(datain=adsl ,dataout=agetot ,var=age , basenum=12.0 ,meannum=12.1 ,stdnum=12.2 );

%sort(datain=ageout,  byvar=order);
%sort(datain=agetot,  byvar=order);

data ageuse;
  merge ageout agetot;
  by order;
run;

data all;
  set ageuse sexuse raceuse ethuse ;
run;

%sort(datain=all,  byvar=ord order);

data dummy;
  input ord order;
  cards;
  1 0
  2 0
  3 0
  4 0
  ;
run;

data dummy;
  format label $50.;
  set dummy;
  if ord = 1 then label = 'GENDER';
  if ord = 2 then label = 'AGE (YEARS)';
  if ord = 3 then label = 'RACE';
  if ord = 4 then label = 'ETHNICITY';
run;

data all1;
  set all dummy;
run;

%sort(datain=all1,  byvar=ord order);

/* The following gets the data ready for the table */

data table;
  format printname $70.;
  set all1;
  if order = 0 then printname = trim(left(label));   
  if order > 0 then printname = "^R'\li300 '"||trim(left(label)) ;
  pag = 1;
  dummy1 = ' ';
  dummy2 = ' ';
  dummy3 = ' ';
run;

%sort(datain=table, byvar= ord order);

/* The following creates the table */

proc template ;
   define style TStyleRTF ;
      parent=styles.rtf ;
 
      style table from table /
         Background=_UNDEF_
         rules=groups   /* PUTS BOTTOM BORDER ON ROW HEADERS */
         frame=hsides 
		 frame=above    /* TOP FRAME ONLY/NO BOTTOM FRAME */
         cellspacing=0
         cellpadding=0  /* MUST HAVE - REMOVES PARAGRAPH SPACING BEFORE AND AFTER CELL CONTENTS */
         borderwidth=1.5pt
         ;

      replace fonts /
         'TitleFont2'         = ("Courier New",8.0pt,Bold)
         'TitleFont'          = ("Courier New",8.0pt,Bold)
         'StrongFont'         = ("Courier New",8.0pt,Bold)
         'EmphasisFont'       = ("Courier New",8.0pt,Italic)
         'FixedEmphasisFont'  = ("Courier New",8.0pt,Italic)
         'FixedStrongFont'    = ("Courier New",8.0pt,Bold)
         'FixedHeadingFont'   = ("Courier New",8.0pt)
         'BatchFixedFont'     = ("Courier New",8.0pt)
         'FixedFont'          = ("Courier New",8.0pt)
         'headingEmphasisFont'= ("Courier New",8.0pt,Italic)
         'headingFont'        = ("Courier New",8.0pt,Bold)    /* FONT FOR COLUMN HEADERS */
         'docFont'            = ("Courier New",8.0pt)
         ;

      replace Body from Document /
         bottommargin = 1.0in
         topmargin    = 1.0in
         rightmargin  = 1.0in
         leftmargin   = 1.0in
         ;

      replace HeadersAndFooters from cell /
         font = fonts('HeadingFont')
         foreground = colors('headerfg')
         background = _undef_
         ;

      replace TitlesAndFooters from Container /
         font = Fonts('TitleFont')
         background = _undef_
         foreground = colors('systitlefg')
         rules = ALL
         just  = CENTER
         ;

      replace PageNo from Container /
         font        = Fonts('docFont')
         background  = colors('systitlebg')
         foreground  = colors('systitlefg')
         cellspacing = 0
         cellpadding = 0
         ;

   end ;

run;

options orientation=landscape nodate nonumber;
ods rtf file="\\artscistore.vuad.villanova.edu\users\plupinac\STAT 7500\Fall 2020\Lecture 8\&progname..rtf" style=TStyleRTF;
ods escapechar='^';

/* Final Report */

DATA _NULL_;
EXEDATE=DATE();
EXETIME=TIME();
CALL SYMPUT('EXEDATE', PUT(EXEDATE,DATE9.));
CALL SYMPUT('EXETIME', PUT(EXETIME,TIME5.));
RUN;

proc report data=table missing headline headskip center nowindows split="|"
    STYLE(HEADER)=[/*frame=void font_size=1 font_face=TIMES*/ just=center /*font_weight=bold*/];
    column pag ord order printname ("^R'\brdrb\brdrth\brdrw10\brsp20\qc\ LUPI DRUG" val1 val2 val3 val4 val5 val6) val0 valtot;
	define pag / order noprint;
	define ord / order noprint;
	define order / order noprint;
	define printname / display "^R'\ql Characteristic \par\li300 Statistic" 
                     style(column)=[just =left cellwidth=2.3in];
	define val1 / display "1.6 ug | (N=&n1)" 
                     style(column)=[just=center cellwidth=0.8in];
	define val2 / display "8 ug | (N=&n2)" 
                     style(column)=[just=center cellwidth=0.8in];
	define val3 / display "16 ug | (N=&n3)" 
                     style(column)=[just=center cellwidth=0.8in];
	define val4 / display "64 ug | (N=&n4)" 
                     style(column)=[just=center cellwidth=0.8in];
	define val5 / display "128 ug | (N=&n5)" 
                     style(column)=[just=center cellwidth=0.8in];
	define val6 / display "160 ug | (N=&n6)" 
                     style(column)=[just=center cellwidth=0.8in];
	define val0 / display "Placebo | (N=&n0)" 
                     style(column)=[just=center cellwidth=0.8in];
	define valtot / display "Total | (N=&ntot)" 
                     style(column)=[just=center cellwidth=0.8in];

    compute after ord;
	  line " ";
	endcomp;

	compute before pag ;
	  line " ";
	endcomp;

    break after pag / page;
 				
	
title1 j=l "LUPINACCI PHARMACEUTICALS, INC." ;
title2 j=l "PROTOCOL LUP-INA-CCI" ;
title3 ; 
title4 j=c "TABLE 14.1.2";
title5 j=c "BASELINE DEMOGRAPHICS";
title6 j=c "(SAFETY POPULATION)";
title7 ;

footnote1 j=l "^S={protectspecialchars=off "  "pretext='\brdrt\brdrs\brdrw1 '}Reference: Listing 16.2.4.1";
footnote2 j=l "&progname..sas" j=c "Date: &exedate Time: &exetime" j=r "Page ^{thispage} of ^{lastpage}";
run;

/* Close RTF */

ods rtf close;
ods listing;

footnote ;
title ;


proc datasets nolist library=work kill;
run;


quit;
