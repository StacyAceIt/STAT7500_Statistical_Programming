options center nodate pageno=1;
dm'log;clear;out;clear;';
libname out '/folders/myfolders/STAT7500_Statistical_Programming/Mini-project3/';

%macro getTrial;
	do patient = 1 to 30;
		
		if patient eq 1 then do;
			denominator = 2;
			nominator = 1;
						
		end;
		
		if patient ne 1 then do;
			denominator = denominator + 1;
			nominator = nominator + count;
		end;
		
		prob_a = nominator/denominator;
		prob_b = 1-prob_a;
			
		/* 1 is drug A; 0 is drug B */
		randomized_to_ = rand('Bernoulli',prob_a);
		if randomized_to_ eq 1 then randomized_to = 'A';
		if randomized_to_ eq 0 then randomized_to = 'B';
		
		/* 1 is yes; 0 is no */
		successful_ = rand('Bernoulli',0.5);
		if successful_ eq 1 then successful = 'Yes';
		if successful_ eq 0 then successful = 'No';
		
		if randomized_to = 'A' and successful = 'Yes' then count = 1;
		if randomized_to = 'A' and successful = 'No' then count = 0;
		if randomized_to = 'B' and successful = 'Yes' then count = 0;
		if randomized_to = 'B' and successful = 'No' then count = 1;
	
		
		output;
	end;

%mend getTrial;



data patient(keep = trial patient nominator denominator count prob_a prob_b randomized_to successful);
	do trial = 1 to 500;
		%getTrial;
	end;
		
run;

data out.mp3;
run;

proc freq data = patient;
	by trial;
	tables randomized_to;
run;


