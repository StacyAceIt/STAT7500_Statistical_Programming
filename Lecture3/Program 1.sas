%let phone = (312) 555-1212 ;
data _null_ ;
phone = '(312) 555-1212';
area_cd = substr(phone, 2, 3) ;
area_cd = substr(‘(312) 555-1212’, 2, 3) ; area_cd = substr('&phone', 2, 3) ;
run ;