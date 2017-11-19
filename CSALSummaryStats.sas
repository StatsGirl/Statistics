/*CSAL Summary Statistics for each pilot phase
Author: Breya Walker
Purpose: The purpose of this script is to provide summary statistics for each lesson by way of macro
Date: 10.8.17
*/

libname CSAL "/folders/myshortcuts/CSAL_Data_verification";

proc import datafile= '/folders/myshortcuts/CSAL_Data_verification/Pilot1/pilot1_allDataShopFormat.xlsx'
out=CSAL.Pilot1
dbms=xlsx
replace;
getnames=yes;
run;

Data Test;
set CSAL.Pilot1;
If ConditionType="" then delete;
run;

%macro dir(file=,i=);
%let path=/folders/myshortcuts/CSAL_Data_verification;
%let i=&i;
%let file=&file;
libname CSAL "%trim(&path)";

proc import datafile="%trim(&path)/%trim(Pilot&i)/%trim(&file)"
out=CSAL.Pilot&i
dbms=xlsx
replace;
getnames=yes;
run;

proc contents data=CSAL.Pilot&i;
run;

data CSAL.NewPilot&i;
set CSAL.Pilot&i;
if ConditionType= "" then delete;
else if AttemptNO ne 1 then delete;
run;

proc sort data=CSAL.NewPilot&i;
by School Class LessonNumber ConditionType QuestionID;
run;

proc univariate data=CSAL.NewPilot&i outtable=Summary&i;
by School Class LessonNumber ConditionType;
var Duration Score;
run;


proc sort data=CSAL.NEwPilot&i;
by School Class LessonNumber ConditionType;
run;

proc freq data=CSAL.NewPilot&i noprint;
by School Class LessonNumber ConditionType;
table Score/out= Count&i;
run;

proc sort data=CSAL.NewPilot&i;
by School Class LessonNumber ConditionType StudentID;
run;

proc freq data=CSAL.NewPilot&i;
by School Class LessonNumber ConditionType;
table StudentID Score/out=StudentID&i;
run;

proc sort data=CSAL.NewPilot&i;
by StudentID LessonNumber ConditionType;
run;

proc univariate data=CSAL.NewPilot&i outtable=StudentScore&i;
by StudentID LessonNumber conditionType;
var Score;
run;

%mend dir;
/*1)Get the summary statistics by school class lesson number and textdifficulty
2)Get the porportion/percentage of correct incorrect by school class lesson number and text difficulty
3)Get the proportion percentage of correct incorrect by studentID
4)Get the variance in StudentID Score by Lesson and ConditionType
5)Compute the mean difference btw each StudentIDs Score by Lesson???
6)Get mean difference in average score across lesson
*/

%dir(file=pilot1_allDataShopFormat.xlsx,i=1);
%dir(file=pilot2_allDataShopFormat.xlsx,i=2);
%dir(file=pilot3_allDataShopFormat.xlsx,i=3);


