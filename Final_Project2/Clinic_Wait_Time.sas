options center nodate pageno=1;
dm'log;clear;out;clear;';
libname out '/folders/myfolders/STAT7500_Statistical_Programming/Final_Project2/';

%macro get_avg_wait_time(arrival1, arrival2, treat1, treat2);
num_of_patients = 10; 
    num_of_days = 10*365; 
    
	call streaminit(123);  
	
	index = 0;
	do day = 1 to num_of_days;
		do patient = 1 to num_of_patients;
			index = index + 1;
		   /* more customers, shorter treatement time */
		    rand_arrival = rand("Uniform")*10;
		   	if rand_arrival lt &arrival1 then arrival_interval = 10;
		   	else if rand_arrival lt &arrival2 then arrival_interval = 20;
		   	else if rand_arrival lt 10 then arrival_interval = 30;
			
			rand_treat = rand("Uniform")*10;
		   	if rand_treat lt &treat1 then treat_time = 10;
		   	else if rand_treat lt &treat2 then treat_time = 20;
		   	else if rand_treat lt 10 then treat_time = 30;


			if patient eq 1 then do;
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
		    
		    /* get current wait time*/
		    wait_time = start_time - arrival_time;
		    retain wait_time;
		    
		    /* get cumulative wait time*/
		    if index ne 1 then total_wait_time = total_wait_time + wait_time;
		    if index eq 1 then total_wait_time = wait_time;
		    retain total_wait_time;
		    
		    avg_wait_time = total_wait_time/index;
		   
		end;
	end;


%mend get_avg_wait_time;

%macro get_results(arrive_1,arrive_2,treat_1,treat_2);
	arrive_10 = 10*&arrive_1;
	arrive_20 = 10*&arrive_2;
	arrive_30 = 10*(10 - &arrive_1 - &arrive_2);
	
	treat_10 = 10*&treat_1;
	treat_20 = 10*&treat_2;
	treat_30 = 10*(10 - &treat_1 - &treat_2);
	
	%get_avg_wait_time(&arrive_1, &arrive_1 + &arrive_2, &treat_1, &treat_1 + &treat_2);
	output;

%mend get_results;

data customer_arrivals(keep= avg_wait_time arrive_10 arrive_20 arrive_30 
						treat_10 treat_20 treat_30);
	retain avg_wait_time arrive_10 arrive_20 arrive_30 
						treat_10 treat_20 treat_30;
	do arrive_1 = 0 to 10;			
		do arrive_2 = 0 to (10-arrive_1);
			do treat_1 = 0 to 10;
				do treat_2 = 0 to (10-treat_1);
					%get_results(arrive_1,arrive_2,treat_1,treat_2);
				end;
			end;
		end;		
	end;

run;

data out.avg_wait_time;
run;

data out.avg_wait_time;
	set customer_arrivals;
run;

proc means data=out.avg_wait_time;
	var avg_wait_time;
run;

proc freq data=out.avg_wait_time;
	tables avg_wait_time;
run;

proc sgplot data=out.avg_wait_time;
	histogram avg_wait_time / scale = count;
	xaxis label='Average Waiting Time at the Clinic (Minutes) in 10 Years' values=(0 to 90 by 5);
	yaxis label='Frequency' values=(0 to 1300 by 100);
	
run;

proc sgscatter data=out.avg_wait_time;                                                                                                            
     matrix avg_wait_time arrive_10 arrive_20 arrive_30;                                                                                                     
run; 

proc sgscatter data=out.avg_wait_time;                                                                                                            
     matrix avg_wait_time treat_10 treat_20 treat_30;                                                                                                     
run; 





