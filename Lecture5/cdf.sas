data cdf;
  input value;
  cards;
  2.13
  0.55
  -1.00
  ;
run;

data cdf1;
  set cdf;
  a = cdf('normal', 1.645);
  stdnormal = cdf('normal', value);
  normal1_1_2 = cdf('normal', value, 1, 2);
  t10 = cdf('t', value, 10);
  if value >= 0 then binomial = cdf('binomial', value, 0.65, 10);
  if value >= 0 then exponential = cdf('exponential', value, 3);
  if value >= 0 then uniform0_4 = cdf('uniform', value, 0, 4);
run;

proc print data=cdf1;
run;

data pvalues;
  set cdf1;
  rttailpval = 1 - stdnormal;
  if value >=0 then twotailpval = (1 - stdnormal)*2;
  if value <0  then twotailpval = (stdnormal)*2;
  keep value stdnormal rttailpval twotailpval;
run;

proc print data=pvalues;
run;

quit;
