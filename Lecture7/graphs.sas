options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

DATA auto ;
  INPUT make $  mpg rep78 weight foreign ;
  if foreign = 0 then type = 'Domestic';
  if foreign = 1 then type = 'Foreign';
CARDS;
AMC     22 3 2930 0
AMC     17 3 3350 0
AMC     22 . 2640 0
Audi    17 5 2830 1
Audi    23 3 2070 1
BMW     25 4 2650 1
Buick   20 3 3250 0
Buick   15 4 4080 0
Buick   18 3 3670 0
Buick   26 . 2230 0
Buick   20 3 3280 0
Buick   16 3 3880 0
Buick   19 3 3400 0
Cad.    14 3 4330 0
Cad.    14 2 3900 0
Cad.    21 3 4290 0
Chev.   29 3 2110 0
Chev.   16 4 3690 0
Chev.   22 3 3180 0
Chev.   22 2 3220 0
Chev.   24 2 2750 0
Chev.   19 3 3430 0
Datsun  23 4 2370 1
Datsun  35 5 2020 1
Datsun  24 4 2280 1
Datsun  21 4 2750 1
;
RUN; 

PROC PLOT DATA=auto;
  TITLE 'PROC PLOT Scatterplot of MPG vs Weight';
  PLOT mpg*weight;
RUN;

PROC GPLOT DATA=auto;
  TITLE 'PROC GPLOT Scatterplot of MPG vs Weight';
  PLOT mpg*weight;
RUN;

PROC GPLOT DATA=auto;
  TITLE 'PROC GPLOT Scatterplot of MPG vs Weight by Foreign/Domestic';
  PLOT mpg*weight=foreign;
RUN;

/***************************************************/

SYMBOL1 V=dot             C=black I=none H=1;
SYMBOL2 V=diamondfilled   C=red   I=none H=2;

PROC GPLOT DATA=auto;
     PLOT mpg*weight=foreign;
RUN; 
QUIT;

quit;

/***************************************************/

SYMBOL1 V=circle C=blue I=r;

PROC GPLOT DATA=auto;
     TITLE 'Scatterplot - With Regression Line ';
     PLOT mpg*weight ;
RUN;


SYMBOL1 V=dot             C=black I=none H=1;
SYMBOL2 V=diamondfilled   C=red   I=none H=2;
AXIS1 LABEL=(font="Courier New" h=2.3 a=90 r=0 "Miles Per Gallon")
      ORDER=(10 TO 40 BY 5);

AXIS2 LABEL=(font="Courier New" h=2.3 a=90 r=0 "Weight (lbs)")
      ORDER=(2000 TO 4500 BY 500);

LEGEND1 LABEL=(font="Courier New" h=1.5 j=c "Legend")
      POSITION=(TOP INSIDE RIGHT) MODE=PROTECT
	  VALUE = (h=1.5 tick=1 "Domestic"
	           h=1.5 tick=2 "Foregn")
	  CSHADOW = GRAY FRAME ACROSS=1 DOWN = 2;

PROC GPLOT DATA=auto;
     TITLE 'Scatterplot of MGP vs. Weight (Axis and Legend Options)';
     PLOT mpg*weight=foreign / vaxis = axis1 haxis=axis2 legend=legend1;
RUN;


/***************************************************/

SYMBOL1 V=dot      C=black I=none H=1;
SYMBOL2 V=circle   C=red   I=none H=1;
AXIS1 LABEL=(font="Courier New" h=1.5 a=-90 r=90 "Miles Per Gallon")
      ORDER=(10 TO 40 BY 5);

AXIS2 LABEL=(font="Courier New" h=1.5 a=0 r=0 "Weight (lbs)")
      ORDER=(2000 TO 4500 BY 500);

LEGEND1 LABEL=(font="Courier New" h=1.5 j=c "Legend")
      POSITION=(TOP INSIDE RIGHT) MODE=PROTECT
	  VALUE = (h=1.5 tick=1 "Domestic"
	           h=1.5 tick=2 "Foregn")
	  CSHADOW = GRAY FRAME ACROSS=1 DOWN = 2;

PROC GPLOT DATA=auto;
     TITLE 'Scatterplot of MGP vs. Weight (Axis and Legend Options)';
     PLOT mpg*weight=foreign / vaxis = axis1 haxis=axis2 legend=legend1;
RUN;


/****************Plotting Means over Time with SD Bars******************/
                                                                                                                                     
/* Create sample data */                                                                                                                
data test;                                                                                                                      
   do treat = 1 to 3; 
      do i=1 to 10;                                                                                                                        
         do time=1 to 5;                                                                                                                   
            if treat = 1 then yvar=(ranuni(0)*100) + 40;                                                                                                            
            if treat = 2 then yvar=(ranuni(0)*100) + 70;                                                                                                            
            if treat = 3 then yvar=(ranuni(0)*100) + 85;                                                                                                            
         output;                                                                                                                        
         end;
      end; 
   end;                                                                                                                                 
run;                                                                                                                                    
                                                                                                                                        
proc sort data=test;                                                                                                                    
   by treat time ;                                                                                                                             
run;

/* Calculate the mean and standard deviation for each X */                                                                                  
proc means data=test noprint;                                                                                                           
   by treat time;                                                                                                                             
   var yvar;                                                                                                                            
   output out=meansout mean=mean std=std;                                                                                         
run;                                                                                                                                    
                                                                                                                                        
/* Reshape the data to contain three Y values for */                                                                                    
/* each X for use with the HILOC interpolation.   */                                                                                    
data reshape(keep=treat time timeuse yvar mean);                                                                                                      
   set meansout;                                                                                                                        
  if treat = 1 then timeuse = time-0.05;
  if treat = 2 then timeuse = time;
  if treat = 3 then timeuse = time+0.05;
   yvar=mean;  
   output;                                                                                                                              
                                                                                                                                        
   yvar=mean - std;                                                                                                                  
   output;                                                                                                                              
                                                                                                                                        
   yvar=mean + std;                                                                                                                  
   output;                                                                                                                              
run;                                                                                                                                    
 
/* Define the axis characteristics */
   axis1 label=(font="Courier New" h=1.5 a=90 r=0 'Response Variable (Units)')
         order=(0 to 200 by 25);                                                                                                                  
   axis2 label=(font="Courier New" h=1.5 a=0 r=0 'Time Point')
         order=(0 to 6 by 1);                                                                                                                  

/* Define the symbol characteristics */
   symbol1 color = black l=1 interpol=hiloctj value=dot;                                                                                          
   symbol2 color = red   l=2 interpol=hiloctj value=circle;                                                                                          
   symbol3 color = blue  l=3 interpol=hiloctj value=square;                                                                                          

   symbol4 color = black l=1 interpol=hiloctj value=dot;                                                                                          
   symbol5 color = red   l=2 interpol=hiloctj value=circle;                                                                                          
   symbol6 color = blue  l=3 interpol=hiloctj value=square;                                                                                          
 
/* Define the legend characteristics */
   legend1 label=(font="Courier New" h=1.0 j=l "Treatment")
           position = (bottom inside center) mode=protect
           value=( h=1.0 tick=1 "Placebo (N=10)"
                   h=1.0 tick=2 "Drug 5 mg (N=10)"
                   h=1.0 tick=3 "Drug 10 mg (N=10)")
		   cshadow=gray frame across = 3 down = 1;

/* Plot the error bars using the HILOCTJ interpolation */                                                                               
/* and overlay symbols at the means. */                                                                                                 
proc gplot data=reshape;                                                                                                                
   title1 'Plot of Means over Time with Standard Deviation Bars from Calculated Data'; 
   plot yvar*timeuse=treat  / vaxis=axis1 vminor=0 haxis=axis2 hminor=0 caxis=black legend=legend1;
   plot2 mean*timeuse=treat / vaxis=axis1  caxis=black legend=legend1;
   footnote 'I made up this data.  He he he!';
run;    
quit;    


/************************Verical Bar Graph ***************************/
axis1 order=(0 to 25 by 5) minor=none                                                                                                   
      label=("Count") ;                                                                                                                     
axis2 label=("Type of Vehicle");                                                                                                                       
                                                                                                                                        
proc gchart data=auto; 
   title 'Bar Gaph of the Number of Vehicles by Type'; 
   vbar type / raxis=axis1 maxis=axis2                                                                                      
               width=9 space=3;  
   footnote ' '; 
run;                                                                                                                                    
quit;

/***************************************************/


axis1 order=(0 to 10 by 2) minor=none                                                                                                   
      label=("Count") ;                                                                                                                     
axis2 label=("Make of Vehicle");                                                                                                                       
                                                                                                                                        
proc gchart data=auto; 
   title 'Bar Gaph of the Number of Vehicles by Make'; 
   vbar make / raxis=axis1 maxis=axis2                                                                                      
               width=9 space=3;  
   footnote ' '; 
run;                                                                                                                                    
quit;


/******************Horizontal Bar Graph with Summary Statistics****************8/

 /* Define response axis characteristics */
axis1 order=(0 to 15 by 3) label=('Number of Vehicles');
axis2 label=('Number of Repairs');

 /* Define legend characteristics */
legend1 label=none value=('Domestic' 'Foreign');

 /* Chart the values of Repairs */
proc gchart data=auto;
   title 'Repairs by Type of Vehicle';
   hbar rep78 / midpoints=(1 2 3 4 5)
              subgroup=type
              legend=legend1
              autoref
              clipref
              coutline=black
              raxis=axis1
			  maxis=axis2;
run;

quit;


/********************Pie Charts**************************/

proc gchart data=auto;
   title 'Pie Chart for Type of Vehicle';
   pie type / value=none
              percent=arrow
              slice=arrow
              noheading 
              plabel=(font='Courier New' h=1.3 color=depk);
run;
quit; 




proc gchart data=auto; 
   title 'Pie Chart for Number of Repairs by Type'; 
   pie rep78 /    midpoints=(1 2 3 4 5)
                  group=type
                  across=2
                  clockwise
                  value=none
                  slice=outside
                  percent=outside
                  coutline=black
                  noheading;
run;
quit;



 /* Donut Graph */

legend1 label=none
        shape=bar(4,1.5)
        position=(middle left)
        offset=(5,)
        across=1
        mode=share;

 /* Generate donut chart */
proc gchart data=auto;
   donut rep78 / midpoints=(1 2 3 4 5)
                subgroup=type
                noheading
                donutpct=30
                label=('All' justify=center 'Vehicles')
                legend=legend1
                coutline=black
                ctext=black;
run;
quit;

QUIT; 
