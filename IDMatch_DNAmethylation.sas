/*Breya Walker
Purpose: The purpose of this script is to identify which IDs within the data set (covar072302017.csv) or any other
dataset are located in the overall IOW and assign asthma status or any other variable of interest to the covar07230271.csv file
Date: 10.30.2017*/

libname IOW "/folders/myshortcuts/DrZhangMeeting";
run;

proc import datafile= "/folders/myshortcuts/DrZhangMeeting/covar07232017.xlsx"
out= IOW.COVAR07232017
dbms=xlsx
replace;
getnames= yes;
run;

proc import datafile= "/folders/myshortcuts/DrZhangMeeting/IOW_V35.xlsx"
out= IOW.IOW_V35New
dbms=xlsx
replace;
getnames= yes;
run;

proc contents data=IOW.IOW_V35NEW;
run;

proc print data=IOW.IOW_V35NEW;
var Sex_18;
run;

proc contents data=IOW.covar07232017;
run;

proc sort data=IOW.IOW_V35NEW;
by STUDYid;
run;

proc sort data= IOW.covar07232017;
by StudyId;
run;

Data IOWNew;
set IOW.IOW_V35New;
keep M_INVESTIGATORDIAGNOSEDASTHMA_10 M_INVESTIGATORDIAGNOSEDASTHMA_18 Sex_18 StudyId;
rename StudyId=NewStudyId;
rename Sex_18=Gender;
run;

proc sort data= IOWNEW;
by NewStudyID;
run;

proc sql; create table Subsample as select * from IOW.Covar07232017 as C inner join IOWNEw as I
on C.StudyId= I.NewStudyID;
quit;

proc contents data=Subsample;
run;

*assuming males=2 females=1;

Data SubsampleAdd;
set Subsample;
if M_INVESTIGATORDIAGNOSEDASTHMA_10=0 and M_INVESTIGATORDIAGNOSEDASTHMA_18=0 then
Status=0;
else if M_INVESTIGATORDIAGNOSEDASTHMA_10=1 and M_INVESTIGATORDIAGNOSEDASTHMA_18=0 then
Status=1;
else if M_INVESTIGATORDIAGNOSEDASTHMA_10=0 and M_INVESTIGATORDIAGNOSEDASTHMA_18=1 then
Status=2;
else if M_INVESTIGATORDIAGNOSEDASTHMA_10=1 and M_INVESTIGATORDIAGNOSEDASTHMA_18=1 then
Status=3;
else Status=.
;
run;

Data IOWNEWAdd;
set IOWNEw;
if M_INVESTIGATORDIAGNOSEDASTHMA_10=0 and M_INVESTIGATORDIAGNOSEDASTHMA_18=0 then
Status=0; *Free=0;
else if M_INVESTIGATORDIAGNOSEDASTHMA_10=1 and M_INVESTIGATORDIAGNOSEDASTHMA_18=0 then
Status=1; *Neg=1;
else if M_INVESTIGATORDIAGNOSEDASTHMA_10=0 and M_INVESTIGATORDIAGNOSEDASTHMA_18=1 then
Status=2;*Post=2;
else if M_INVESTIGATORDIAGNOSEDASTHMA_10=1 and M_INVESTIGATORDIAGNOSEDASTHMA_18=1 then
Status=3; *Pers=3;
else Status= .;
run;

proc sort data=SubsampleAdd;
by Status;
run;

title'Subsample';
Proc freq data=SubsampleAdd nlevels;
by Status;
tables Gender/missprint chisq fisher;
run;

proc sort data=IOWNEWAdd;
by Status;
run;

title'Cohort';
proc freq data=IOWNEWAdd;
by Status;
tables Gender/missprint chisq fisher;
run;

Data Combined;
input Group Status Gender Count;
Datalines; 
1 1 1 14
1 1 2 4
1 2 1 14
1 2 2 12
1 3 1 20
1 3 2 11
1 0 1 137
1 0 2 112
2 1 1 41
2 1 2 18
2 2 1 36
2 2 2 59
2 3 1 63
2 3 2 59
2 0 1 473
2 0 2 485
;
run;

proc sort data=Combined;
by Status;
run;

proc sort data=Combined;
by Gender Status;
run;

title'Subsample vs. cohort';
proc freq data= Combined;
by Gender Status;
table Group/binomial (p=0.5 level=1);
weight count;
run;







