data quant;
  input p;
  cards;
  0.95
  0.5
  0.15
  0.3487
  ;
run;

data quant1;
  set quant;
  a = quantile('normal', 0.95);
  stdnormal = quantile('normal', p);
  normal100_16 = stdnormal*4 + 100;
  normal100_16_2 = quantile('normal', p, 100, 4);
  t10 = quantile('t', p, 10);
  binomial = quantile('binomial', p, 0.65, 10);
  exponential = quantile('exponential', p, 3);
  uniform = quantile('uniform', p);
  uniform10_20 = (20-10)*uniform + 10;
  uniform10_20_2 = quantile('uniform', p, 10, 20);
run;

proc print data=quant1;
run;

quit;
