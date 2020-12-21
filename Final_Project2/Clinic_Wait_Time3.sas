options center nodate pageno=1;
dm'log;clear;out;clear;';
libname out '/folders/myfolders/STAT7500_Statistical_Programming/Final_Project2/';


data customer_arrivals (keep= day patient arrival_interval treat_time);
    num_of_patients = 10; 
    num_of_days = 10*365; 
    
	call streaminit(123);  
	
	do day = 1 to num_of_days;
		do patient = 1 to num_of_patients;
		   /* more customers, shorter treatement time */
		    rand_arrival = rand("Uniform");
		   	if rand_arrival lt 0.5 then arrival_interval = 10;
		   	else if rand_arrival lt 0.7 then arrival_interval = 20;
		   	else if rand_arrival lt 1 then arrival_interval = 30;
			
			rand_treat = rand("Uniform");
		   	if rand_treat lt 0.4 then treat_time = 10;
		   	else if rand_treat lt 0.6 then treat_time = 20;
		   	else if rand_treat lt 1 then treat_time = 30;
			
		   output;
		end;
	end;
run;

proc means data = customer_arrivals;
	var arrival_interval treat_time;
run;

proc freq data=customer_arrivals;
	tables arrival_interval treat_time;
run;

data customer_arrivals (keep= day patient arrival_time start_time treat_time finish_time wait_time);
	retain  day patient arrival_time start_time treat_time finish_time wait_time;
	set customer_arrivals;
	
	by day;
	if first.day then do;
		arrival_time = arrival_interval;
		start_time = arrival_time;

	end;	
		retain arrival_time;
	else do;
		arrival_time = arrival_interval + arrival_time;
		if finish_time lt arrival_time then start_time = arrival_time;
		else start_time = finish_time;
    end; 
    
    finish_time = start_time + treat_time;
    retain finish_time;
    wait_time = start_time - arrival_time;
  
run;

data out.wait_time3;
run;

data out.wait_time3;
	set customer_arrivals;
run;

proc means data = out.wait_time3;
	var wait_time;
run;

proc freq data=out.wait_time3;
	tables wait_time;
run;

proc sgplot data=out.wait_time3;
	histogram wait_time / scale = count binstart=5 binwidth=10;
	xaxis label='Waiting Time at the Clinic (Minutes)' values=(0 to 120 by 10);
	yaxis label='Frequency' values=(0 to 15000 by 1000);
	
run;


