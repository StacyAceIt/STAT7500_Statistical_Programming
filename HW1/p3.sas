data mydata;
input Time : hhmmss.
	  With $
	  Place & $ 12.
	  Subject & $ 15.
;
format Time TIME5.;
cards;
11:00 Sally Room 30 Personal Review
1:00 Jim Jim's Office Brake design
3:00 Nancy Lab Test results
;
run;
proc print data=mydata;
run;
