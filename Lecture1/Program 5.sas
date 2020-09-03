options linesize=78 nodate nonumber;
data mydata;
input zip fruit & $19. pounds;
datalines;
10034 apples, grapes kiwi  123456
92626 oranges  97654
25414 pears apple  987654
;
run;



proc print;
run;

