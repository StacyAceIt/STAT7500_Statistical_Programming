options linesize=78 nodate nonumber;
data mydata;
input School_District $ teachers students;
cards;
Granite                           5829                    200486
Jordan                           12433                   318992
Davis                             2358                     126331
;
run;

proc print data=mydata;
run;