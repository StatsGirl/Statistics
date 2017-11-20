*Match BT patients with SIOP  data
Breya Walker
10.24.17;

data SIOP; 
input ID Age Gender$ Race$;
datalines;
...
;
run;


data BTSLEP; 
input ID Age Race$ Gender$;
datalines;
...
;
run;

Data Siop;
set SIOP;
Age=ceil(Age); *Round up age to nearest whole number;
run;

proc sql; create table Matches as select one.ID as SiopID, one.Age as SIOPage, 
one.Gender as SIOPGender, one.Race as SIOPRace,two.ID as BTID, two.Age as BTage, two.Gender as BTGender, two.Race as BTRace from SIOP one, BTSLEP two where (one.Age=two.Age and one.Gender=two.Gender);
quit;
