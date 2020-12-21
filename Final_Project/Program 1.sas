data have;
input ID       Value;
cards;
1           5
1           10
2           50
3           5
3           10
3           10
;

proc sql;
create table want as select id, sum(value) as value from have group by id;
quit; 