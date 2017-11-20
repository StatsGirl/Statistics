/*Purpose: analyze the association between baseline actigraphy data and hypocretin. Utilizing the actigraphy data that is closest to the baseline Day 0 date.
Author: Breya Walker
Date 9.13.2017
*/

libname BTSLEP 'path';

proc import datafile= 'path'
out=BTSLEP.Combined
dbms=xlsx
replace;
getnames=yes;
run;

proc contents data = BTSLEP.Combined;
run;

Data Dates;
set BTSLEP.Combined;
dayb4= intnx('day',BaselineDay0,-4);
dayafter=intnx('day',BaselineDay0,+4);
dayof=intnx('day',BaselineDay0,0);
format dayb4 mmddyy10.;
put dayb4;
format dayof mmddyy10.;
format dayafter mmddyy10.;
put dayafter;
NewDate=median(sdate);
format NewDate mmddyy10.;
if sdate < dayafter AND sdate > dayb4 then output; *output variable list to dataset;
	else delete;
drop dayb4 dayafter;
rename MRN=MRNT;
run;

proc freq data= Dates nlevels;
table MRNT;
run;

proc means data =Dates;
class MRNT;
var sdate;
output out=Work.data median=sdate_median;
run;

Data NewData;
set Data;
rename MRNT= MRN;
run;


proc freq data=BTSLEP.Combined nlevels;
table MRN;
run;

proc print data=imldata;
run;

proc sort data= BTSLEP.Combined;
by MRN sdate; *Sort by date;
run;

data NewBTSLEP;
set BTSLEP.Combined;
by MRN;
IF First.MRN then output; *We select the date that is closest to the Concentration reading of hypocretin;
run;

*Makes sense to use the median or date closest to the hypocretin data collection as the measure of association between hypocretin and actigraphy;
Title'Correlation between Hypocretin concentration and Actigraphy variables';
proc corr data= NewBTSLEP; 
with con;
var dur--lgsep;
run;

proc sort data= NewBTSLEP;
by Arm;
run;


proc univariate data=NewBTSLEP normal;
by Arm;
var Con;
run;

proc ttest data= NewBTSLEP;
class Arm;
var Con;
run;

*perform bootstrap with replacement on sample of 27 observations with original data NewBTSLEP being used;
%let NumSamples=200; *urs is resample with replacement;
proc surveyselect data=NewBTSLEP Noprint seed=30459584
out=BootData(rename=(Replicate=SampleID))
method=urs
samprate=100
outhits
reps=&NumSamples; *outhits allows us to track which obs are repeated in URS;
run;

ods output PearsonCorr=PValues;
Title 'BootStrap with replacement:Correlation btw Hypocretin and Actigraphy variables';
ods select PValues;
proc corr data= BootData outp=CorrStatistics;
by SampleID;
freq NumberHits;
with Con;
var dur--lgsep;
run;

ods listing select none;
proc glm data=BootData outstat=Summary;
by SampleID;
class Arm;
model Con= Arm Waso Actx Seff; 
run;

ods listing select none;
proc glm data=BootData outstat=SummaryNoArm;
by SampleID;
model Con= Waso Actx Seff; *See if Arm is important to outcome. Same Model without Arm include;
run;

proc glm data=BootData outstat=SummaryArmOnly;
by SampleID;
model con=Arm;
run;


Data NewBTSLEP_Bt;
set NewBTSlep;
if Arm="SOC" then ArmN=1;
if Arm="Intervention" then ArmN=0;
run;


proc multtest data=NewBTSLEP_Bt bootstrap nsample=200 seed=30459584 outsamp=MulttTest out=Example nocenter;
test mean(con waso seff actx);
class ArmN;
contrast 'SOC vs. Int' -1 1;
run;

ods html close;

ods html;

Data PValues_Boot (drop = Pdur--Nlgsep);
set Pvalues;
run;


proc univariate data=PValues_Boot cibasic;
var dur;
output out=final pctlpts=2.5 97.5 pctlpre=ci;
run;

proc print data=Final;
run;

proc means data=PValues_Boot clm mean std;
var dur--lgsep;
output out=Summary_Statistics;
run;

Data SummaryStatistics_Boot;
set Summary_Statistics;
if _Stat_ ="STD" then
z= _Mean_/_STD_;
pvalue=1-cdf('normal',z,0,1);
run;
