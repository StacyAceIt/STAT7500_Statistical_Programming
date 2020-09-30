data random;
  do i = 1 to 1000;
	val1 = 20 + 2*rannor(0);
	val2 = 20 + 2*rannor(0);
	val3 = 20 + 2*rannor(0);
	val4 = 20 + 2*rannor(0);
	val5 = 20 + 2*rannor(0);
	output;
  end;
run;

data random1;
  set random;
  sampmean = (val1 + val2 + val3 + val4 + val5) /5;
  Zscore = (sampmean - 20)/(2/sqrt(5));
  if Zscore > 1.645 then flag = 1;
  else flag = 0;
run;

proc freq data=random1;
  title 'Type I Error Rate';
  tables flag;
run;

quit;
