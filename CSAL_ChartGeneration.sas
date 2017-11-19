*Breya Walker
*Purpose: Create CSAL dataset that contains all the following information to be used for plotting:
CompletionRate (100%), CorrectRate(100%), TimeOnTask(1 hour) for each lesson and each pilot phase
*date 10.22.17;

*Pilot1;
libname CSAL '/folders/myshortcuts/CSAL_Data_verification';
proc import datafile= '/folders/myshortcuts/CSAL_Data_verification/Pilot1/pilot1_allData_DSFormat.csv'
out=CSAL.Pilot1
dbms=csv
replace;
getnames=yes;
run;

Data CSAL.Pilot1New;
set CSAL.Pilot1;
where(CF__Lesson_Attempt_)=1;
if CF__IsCompleted_="Completed" then Complete=1;
else if CF__IsCompleted_="Incomplet" then Complete=0;
run;

proc sort data=CSAL.Pilot1New;
by KC__Lesson_;
run;

Title'Pilot1';
proc means data= CSAL.pilot1New;
by KC__Lesson_;
var Complete CF__Score_ Time; *Time is in seconds, convert to minutes;
output out=SummaryStatisticsP1;
run;

Data SummaryStatsP1New;
set SummaryStatisticsP1;
where _STAT_ = "MEAN";
run;

proc freq data= CSAL.Pilot1New;
table KC__Lesson_*Level__Lesson_ID_;
run;

*Pilot2;
proc import datafile= '/folders/myshortcuts/CSAL_Data_verification/Pilot2/pilot2_allData_DSFormat.csv'
out=CSAL.Pilot2
dbms=csv
replace;
getnames=yes;
run;

Data CSAL.Pilot2New;
set CSAL.Pilot2;
where(CF__Lesson_Attempt_)=1;
if CF__IsCompleted_="Completed" then Complete=1;
else if CF__IsCompleted_="Incomplet" then Complete=0;
run;

proc sort data=CSAL.Pilot2New;
by KC__Lesson_;
run;

title'Pilot2';
proc means data= CSAL.pilot2New;
by KC__Lesson_;
var Complete CF__Score_ Time; *Time is in seconds, convert to minutes;
output out=SummaryStatisticsP2;
run;

Data SummaryStatsP2New;
set SummaryStatisticsP2;
where _STAT_ = "MEAN";
run;

*Pilot3;
proc import datafile= '/folders/myshortcuts/CSAL_Data_verification/Pilot3/pilot3_allData_DSFormat.csv'
out=CSAL.Pilot3
dbms=csv
replace;
getnames=yes;
run;

Data CSAL.Pilot3New;
set CSAL.Pilot3;
where(CF__Lesson_Attempt_)=1;
if CF__IsCompleted_="Completed" then Complete=1;
else if CF__IsCompleted_="Incomplet" then Complete=0;
run;

proc sort data=CSAL.Pilot3New;
by KC__Lesson_;
run;

Title'Pilot3';
proc means data= CSAL.pilot3New;
by KC__Lesson_;
var Complete CF__Score_ Time; *Time is in seconds, convert to minutes;
output out=SummaryStatisticsP3;
run;

Data SummaryStatsP3New;
set SummaryStatisticsP3;
where _STAT_ = "MEAN";
run;

