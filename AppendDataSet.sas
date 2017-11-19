/*Purpose: This macro will: import data from the given dir and append new data to existing table
Author:Breya Walker
Date: 9.13.17*/

libname CSAL '/folders/myshortcuts/CSAL_Data_verification';
proc import datafile= '/folders/myshortcuts/CSAL_Data_verification/Pilot3/TeacherATPilot3.xlsx'
out=Test
dbms=xlsx
replace;
getnames=yes;
sheet='#1 - Text Signals';
run;


Data Append_DT;
set Test;
if ID = '' then delete;
LessonName="Text Signals";
LessonNum=1;
OrderInPilot=2;
run;


%MACRO AppendData(Sheet=, LessonName=,LessonNum=, OrderInPilot=);
%let i=1;
%do;
proc import datafile= '/folders/myshortcuts/CSAL_Data_verification/Pilot3/TeacherATPilot3.xlsx'
out=A_&i
dbms=xlsx
replace;
getnames=yes;
sheet=&Sheet;

  Data Append_DTN;
    Set A_&i;
    if ID = '' then delete;
    LessonName=&LessonName;
    LessonNum=&LessonNum;
    OrderInPilot=&OrderInPilot;
  Run;
  
  Proc Append Base=Append_DT Data=Append_DTN force;
  Run;
  * OR:;
/*  Data Append_DT;*/
/*    Set Append_DT A_&i.;*/
/*  Run;*/

PROC PRINT DATA = APPEND_DT;
RUN;
%end;
%MEND AppendData;


*pilot 2 study file;

%AppendData(Sheet="#32 - Online Research",LessonName='Online Research',LessonNum=32,OrderInPilot=3);
%AppendData(Sheet="#4 - Prefixes & Suffixes",LessonName='Prefixed & Suffixes',LessonNum=4,OrderInPilot=4);
%AppendData(Sheet="#5 Punctuation",LessonName='Punctuation',LessonNum=5,OrderInPilot=5);
%AppendData(Sheet="#6 Context Clues",LessonName='Context Clues',LessonNum=6,OrderInPilot=6);
%AppendData(Sheet="#8 Multiple Meaning Words",LessonName='Multiple Meaning Words',LessonNum=8,OrderInPilot=7);
%AppendData(Sheet="#9 Pronouns",LessonName=' Pronouns',LessonNum=9,OrderInPilot=8);
%AppendData(Sheet="#10 Non-Literal Language",LessonName='Non-Literal Language',LessonNum=10,OrderInPilot=9);
%AppendData(Sheet="#1 Text Signals",LessonName='Text Signals',LessonNum=1,OrderInPilot=10);
%AppendData(Sheet="#11 Review",LessonName=' Review',LessonNum=11,OrderInPilot=11);
%AppendData(Sheet="Evaluating Understanding",LessonName='Evaluating Understanding',LessonNum=16,OrderInPilot=12);
%AppendData(Sheet="#20 Problem and Solution Texts",LessonName=' Problem and Solution Texts',LessonNum=20,OrderInPilot=13);
%AppendData(Sheet="#21 Cause and Effect Texts",LessonName='Cause and Effect Texts',LessonNum=21,OrderInPilot=14);
%AppendData(Sheet="#23 Compare and Contrast Texts",LessonName='Compare and Contrast Texts',LessonNum=23,OrderInPilot=15);
%AppendData(Sheet="#25 Procedural Texts",LessonName='Procedural Texts',LessonNum=25,OrderInPilot=16);
%AppendData(Sheet="Evaluating Persuasive",LessonName='Evaluating Persuasive',LessonNum=17,OrderInPilot=17);
%AppendData(Sheet="Evaluating Narrative",LessonName='Evaluating Narrative',LessonNum=18,OrderInPilot=18);
%AppendData(Sheet="Predicting Purpose",LessonName='Predicting Purpose',LessonNum=2,OrderInPilot=19);
%AppendData(Sheet="#3 Hybrid Texts",LessonName='Hybrid Texts',LessonNum=3,OrderInPilot=20);
%AppendData(Sheet="#18 Review",LessonName='Review',LessonNum=18,OrderInPilot=21);
%AppendData(Sheet="#30 Documents",LessonName='Documents',LessonNum=30,OrderInPilot=22);
%AppendData(Sheet="Applications",LessonName='Applications',LessonNum=31,OrderInPilot=23);
%AppendData(Sheet="Bridging Narrative",LessonName='Bridging Narrative',LessonNum=27,OrderInPilot=24);
%AppendData(Sheet="Elaborating Narrative ",LessonName='Elaborating Narrative',LessonNum=15,OrderInPilot=25);
%AppendData(Sheet="#28 Elaborating Informative",LessonName='Elaborating Informative',LessonNum=28,OrderInPilot=26);
%AppendData(Sheet="#29 Elaborating Persuasive",LessonName='Elaborating Persuasive',LessonNum=29,OrderInPilot=27);

*Export the study file that was created Append_DT as Pilot study file;

libname Temp '/folders/myshortcuts/CSAL_Data_verification/Pilot2';

proc import datafile='/folders/myshortcuts/CSAL_Data_verification/Pilot2/PILOT2ALL.xlsx'
out=Temp.Pilot2Fixed
dbms=xlsx
replace;
getnames=yes;
stringdate=yes;
run;

Data Pilot2Fixed;
set Temp.Pilot2Fixed;
NewDate=date_attempted-21916;
time=round(86400*input(TimeFinish,16.));
format NewDate mmddyys10.;
informat NewDate mmddyys10.;
format time timeampm11.;
informat time timeampm11.;
drop date_attempted TIMEFINISH;
run;

proc means data=Pilot2Fixed;
var NewDate;
output out=sumstatDate mean=AverageDate;
run;

proc means data=Pilot2Fixed;
var Time;
output out=sumstatTime mean=AverageTime;
run;

proc freq data=Pilot2fixed;
table NewDate;
run;

*Pilot3 study data;

%AppendData(Sheet="#2 Writer's Purpose",LessonName='Writers Purpose',LessonNum=2,OrderInPilot=3);
%AppendData(Sheet="#3 Hybrid Texts",LessonName='Hybrid Texts',LessonNum=3,OrderInPilot=4);
%AppendData(Sheet="#4 Affixes",LessonName='Affixes',LessonNum=4,OrderInPilot=5);
%AppendData(Sheet="#5 Punctuation",LessonName='Punctuation',LessonNum=5,OrderInPilot=6);
%AppendData(Sheet="#6 Context Clues",LessonName='Context Clues',LessonNum=6,OrderInPilot=7);
%AppendData(Sheet="#7 Acquiring New Words",LessonName='Acquiring New Words',LessonNum=7,OrderInPilot=8);
%AppendData(Sheet="#8 Multiple Meaning Words",LessonName='Multiple Meaning Words',LessonNum=8,OrderInPilot=9);
%AppendData(Sheet="#9 Pronouns",LessonName='Pronouns',LessonNum=9,OrderInPilot=10);
%AppendData(Sheet="#10 Non-Literal Language",LessonName='Non-Literal Language',LessonNum=10,OrderInPilot=11);
%AppendData(Sheet="#11 Review",LessonName='Review',LessonNum=11,OrderInPilot=12);
%AppendData(Sheet="#12 Using Key Information",LessonName='Using Key Information',LessonNum=12,OrderInPilot=13);
%AppendData(Sheet="#13 Questioning Narrative",LessonName='Questioning Narrative',LessonNum=13,OrderInPilot=14);
%AppendData(Sheet="#14 Bridge Building",LessonName='Bridge Building',LessonNum=14,OrderInPilot=15);
%AppendData(Sheet="#15 Summarizing Narrative",LessonName='Summarizing Narrative',LessonNum=15,OrderInPilot=16);
%AppendData(Sheet="#16 Questioning Informational",LessonName='Questioning Informational',LessonNum=16,OrderInPilot=17);
%AppendData(Sheet="#17 Questioning Persuasive",LessonName='Questioning Persuasive',LessonNum=17,OrderInPilot=18);
%AppendData(Sheet="#18 Review",LessonName='Review',LessonNum=18,OrderInPilot=19);
%AppendData(Sheet="#19 Statement and Explanation",LessonName='Statement and Explanation',LessonNum=19,OrderInPilot=20);
%AppendData(Sheet="#20 Problem Solution",LessonName='Problem Solution',LessonNum=20,OrderInPilot=21);
%AppendData(Sheet="#21 Cause and Effect",LessonName='Cause and Effect',LessonNum=21,OrderInPilot=22);
%AppendData(Sheet="#22 Description and Spatial",LessonName='Description and Spatial',LessonNum=2,OrderInPilot=23);
%AppendData(Sheet="#23 Compare and Contrast",LessonName='Compare and Contrast',LessonNum=23,OrderInPilot=24);
%AppendData(Sheet="#24 Time Order",LessonName='Time Order',LessonNum=24,OrderInPilot=25);
%AppendData(Sheet="#25 Procedural",LessonName='Procedural',LessonNum=25,OrderInPilot=26);
%AppendData(Sheet="#27 Elaborating Narrative",LessonName='Elaborating Narrative',LessonNum=27,OrderInPilot=27);
%AppendData(Sheet="#28 Elaborating Informative",LessonName='#28 Elaborating Informative',LessonNum=28,OrderInPilot=28);
%AppendData(Sheet="#29 Elaborating Persuasive",LessonName='#29 Elaborating Persuasive',LessonNum=29,OrderInPilot=29);
%AppendData(Sheet="#30 Documents",LessonName='#30 Documents',LessonNum=30,OrderInPilot=30);
%AppendData(Sheet="#31 Applications",LessonName='Applications',LessonNum=31,OrderInPilot=31);
%AppendData(Sheet="#32 Online Research",LessonName='Online Research',LessonNum=32,OrderInPilot=32);
%AppendData(Sheet="#33 Email",LessonName='Email',LessonNum=33,OrderInPilot=33);
%AppendData(Sheet="#34 Social Media",LessonName='Social Media',LessonNum=34,OrderInPilot=34);


*Export the study file that was created Append_DT as Pilot study file;

libname Temp '/folders/myshortcuts/CSAL_Data_verification/Pilot3';

proc import datafile='/folders/myshortcuts/CSAL_Data_verification/Pilot3/PILOT3ALL.xlsx'
out=Temp.Pilot3Fixed
dbms=xlsx
replace;
getnames=yes;
stringdate=yes;
run;

Data Pilot3Fixed;
set Temp.Pilot3Fixed;
NewDate=date_attempted-21916;
time=round(86400*input(TimeFinished,16.));
format NewDate mmddyys10.;
informat NewDate mmddyys10.;
format time timeampm11.;
informat time timeampm11.;
drop date_attempted TIMEFINISHed;
run;

proc means data=Pilot3Fixed;
var NewDate;
output out=sumstatDate mean=AverageDate;
run;

proc means data=Pilot3Fixed;
var Time;
output out=sumstatTime mean=AverageTime;
run;

proc freq data=Pilot3fixed;
table NewDate;
run;

