data random;
  do i = 1 to 10;
    bin = ranbin(23242, 20, 0.25);
	exp = ranexp(23242);
	exp3 = exp/3;
	gam5_1 = rangam(23242, 5);
	gam5_3 = 3*gam5_1;
	nor = rannor(23242);
	nor100_16 = 100 + nor*4;
	poi = ranpoi(23242, 1.5);
	uni = ranuni(23242);
	uni3_9 = (9-3)*ranuni(23242) + 3;
	output;
  end;
run;

proc print data=random;
run ;


/* The following generates 1000 random observations from a normal distribution with a mean of 80 and a standard deviation of 7 */
data random;
  do i = 1 to 1000;
	x = 80 + rannor(75647)*7;
	output;
  end;
run;

proc sgplot data=random;
  title 'Plot of 1000 observations based on a Normal(80, 49)';
  histogram x;
run;

data random1;
  set random;
  if x >= 90 then flag = 1;
  if x <  90 then flag = 0;
run;

proc freq data=random1;
  title 'Percentage of students who score above a 90';
  tables flag;
run;

quit;
