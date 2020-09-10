options center nodate nonumber ps=60 ls=72;
dm'log;clear;out;clear;';

*Example of Do-Loops in the Data Entry Step;

data pesticide;
    do variety = 1 to 3;
	   do pesticide = 1 to 4;
	      do k = 1 to 2;
             input yield @@; 
			 output;
          end;
	   end;
	end;
    cards;
    49 39  50 55  43 38  53 48
    55 41  67 58  53 42  85 73
	66 68  85 92  69 62  85 99
	;
run;
	
proc print data=pesticide;
  title 'Example of Using Do-Loops';
run;

* Part 2;

data pesticide;
  set pesticide;
  format location $ 10.;
  if variety = 1 then do;
      vartype = 'A';
	  location = 'Florida';
  end;
  if variety = 2 then do;
     vartype = 'B';
	 location = 'California';
  end;
  if variety = 3 then do;
     vartype = 'C';
	 location = 'Arizona';
  end;
  drop variety;
run;

proc print data=pesticide;
  title 'Example of If-Then-Do Loops';
run;


quit;
 
