*Import Actigraphy baseline data from RT2CR patients in ;
Data ActRT2_T1;
format sdate mmddyy10. stime time5.; *Fix data and time formats;
input ID TimePoint IntName: $4. ActMode: $3. sday: $3. sdate: mmddyy10. stime: time5.;
datalines;
...
;
run;

*Create a new dataset that contains the medians by ID;
proc freq data= Actrt2_t1 nlevels;
table ID;
run;

proc sql;
create table MEDS as select ID, stime from actrt2_t1 group by ID;
run;

data NewMed;
set MEds;
by ID;
NewTime=median(stime);
drop stime;
run;

Proc univariate data= Actrt2_t1;
class ID;
var stime;
output out= Tests_For_Location median=Tests_for_Location;
run;

Data NewMEd;
set Tests_for_location;
format Tests_for_location time5.;
run;

Data SampleTimes2;
set SampleTimes;
ID=input(MRN, best12.);
run;

proc sort data= sampletimes2;
by ID;
run;

proc sort data=NewMed;
by ID;
run;

Data NewTime;
merge SampleTimes2 NewMEd;
by ID;
run;

proc corr data=NewTime;
var Sample4T Tests_for_location; *sample 4 is the reported bedtime for melatonin collection;
run;


