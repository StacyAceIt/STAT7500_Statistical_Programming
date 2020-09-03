data mydata;
input Time : hhmmss. With $ Place $ Subject $ Length_of_Meeting $;
format Time TIME5.;
cards;
11:00 Sally Room 30 Personnel Review 45 minutes
1:00 Jim Jim’s Office Brake design 30 minutes
3:00 Nancy Lab Test results 30 minutes
;
run;
proc print data=mydata;
run; 