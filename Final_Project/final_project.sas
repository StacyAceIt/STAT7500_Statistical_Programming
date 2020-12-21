options center nodate pageno=1;
dm'log;clear;out;clear;';
libname out '/folders/myfolders/STAT7500_Statistical_Programming/Final_Project/';

data bus_schedules (keep= bus_schedule);
    N = 10; 
    bw_busses = 10; 
    
	call streaminit(123);      
	do i = 1 to N;
	   bus_schedule = N*bw_busses*rand("Uniform");    
	   output;
	end;
run;

proc sort data=bus_schedules out = out.bus_schedules;
	by bus_schedule;
run;

data bus_invervals;
	set bus_schedules;
	
	base = lag(bus_schedule);
    if _N_=1 then base = bus_schedule;
    bus_interval = bus_schedule - base;
   
run;

proc means data = bus_invervals;
	var bus_interval;
run;

data passenger_arrivals (keep=passenger_arrival);
    bw_passengers = 1/3; 
    N = 3000;
	call streaminit(123);      
	do i = 1 to N;
	   passenger_arrival = N*bw_passengers*rand("Uniform");    
	   output;
	end;

run;

proc sort data=passenger_arrivals out = passenger_arrivals;
	by passenger_arrival;
run;

data passenger_invervals;
	set passenger_arrivals;
	
	base = lag(passenger_arrival);
    if _N_=1 then base = passenger_arrival;
    passenger_interval = passenger_arrival - base;
   
run;

proc means data = passenger_invervals;
	var passenger_interval;
run;

proc print data=sashelp.cars;
run;

data convertible;
 set sashelp.cars;
 convertible_position = index(model,'convertible');
run;
 
proc print data=convertible;
 var model convertible_position;
run;
























/* wait time = bus_schedule - passenger_ arrival */


