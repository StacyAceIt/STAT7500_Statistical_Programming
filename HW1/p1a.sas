options linesize=78 nodate nonumber;
data mydata;
input name $ score1 score2 score3 score4 score5 final @@;
cards;

Gamma1 11.25 9.75 10 10 10 90 Delta1 9.5 7.5 8 10 10 95 Epsilon1 11.5 10 9.75 3.5 10 100 Theta 1 12.5 10 9.5 9 10 100
;
run;
proc print data=mydata;
run;