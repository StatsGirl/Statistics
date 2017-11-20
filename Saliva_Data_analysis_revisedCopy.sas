*Import saliva data for time point 1 baseline;
libname Saliva 'path';
proc import out = S_T1
datafile = 'path'
DBMS= xlsx replace;
getnames= yes;
run;

proc print data = S_T1;
run;

proc sort data = S_T1;
by MRN;
run;

*rename variables;
data S_T1_clean;
 set S_T1(rename= (Sample1= Sample1T1 Sample2= Sample2T1 Sample3= Sample3T1 Sample4= Sample4T1 Sample5= Sample5T1));
 run;

 proc print data = S_T1_clean;
 run;

*KEEP variables ;
data S_T1_sm (KEEP = MRN Age age_group Sample1T1 Sample2T1 Sample3T1 Sample4T1 Sample5T1 MissingData SQData Qns1 Qns2 Qns3 Qns4 Qns5); *KEEP these variables;
set S_T1_clean; *From this data set;
run;

proc print data = S_T1_sm; *Print a copy of consolidated data set;
run;

*DESCRIPTIVES------------------------------------------------------------------------------------------------------------------------------------------------------------------------;
*Descriptives: sample size of age groups;
Title 'Descriptives';
proc freq data = S_T1_sm;
title ' Sample size by Age';
table age_group;
run;

*Descriptives: means of each age group;
proc univariate data = S_T1_sm;
title 'Descriptives for Age_group';
Class age_group;
var Age;
run;

*Descriptive through datalines;
data Demos;
input AgeGroup $ Age Gender $ Race $;
datalines;
...

;

proc means data=Demos;
var Age;
run;

proc sort data = Demos;
by AgeGroup;
run;

proc means data=Demos;
by AgeGroup;
var Age;
run;

proc freq data= Demos;
table Race Gender;
run;

proc sort data =Demos;
by AgeGroup;
run;

proc freq data=Demos;
by AgeGroup;
table Gender;
run;

*frequency of missing data by age group;
proc freq data = S_T1_sm;
title'Frequency of Missing Data';
table age_group*MissingData;*age group by missing data;
run;

*frequency of sufficient quantity by age group 0= qns is NOT present in cell;
proc freq data = S_T1_sm;
Title'Frequency of Quality Data';
table age_group*SQData; *age by quality;
run;

*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------;

*Question 1a: Which age group was associated with the most missing data?Report Row Pct. COMPLIANCE *Question 1b:  Overall was age associated with missing data?Report both Col Pct and phi coef;
proc freq data = S_T1_sm;
Title' Association between Age group and Missing Data ALSO Differences in Missing Data by age group';
table Age_group*MissingData/expected chisq exact measures; *MissingData: 0=none 1= data missing overall across samples;
run;

proc logistic data=S_T1_sm;
class Age_group;
model MissingData=Age_group;
run;

proc sgplot data = S_T1_sm;
title 'Proportion missing data by Age group';
vbar MissingData/group = age_group stat=sum groupdisplay=stack;
run;

proc sgplot data = S_T1_sm;
title 'Proportion of missing data';
vbar MissingData;
run;

*Question 1c:Is there a significant difference in the amount of missing vs. non-missing data reported OVERALL;
proc freq data =S_T1_sm;
title 'Difference in missing vs. non-missing data reported';
table MissingData/chisq exact cl;
run;

proc freq data=S_T1_sm;
title 'Age group by Missing data per sample';
table Age_group*Sample1T1*Sample2T1*Sample3T1*Sample4T1*Sample5T1/exact cl;
run;

*Question 1d:Is there a significant difference between samples and missing data;
data SampleMiss;
input SampleNum$ MissData$ count; *Overall summation of each samples S and NS counts. Total in excel sheet M= Missing NM=Not Missing;
Datalines; 
...
;
run;
proc freq data = SampleMiss;
Title'Difference in the amount of missing vs. non missing data by sample';
Table MissData*SampleNum/expected chisq exact relrisk;
weight count;
run;

*Question 1e: IS there a significant difference in the propotion of missing vs nonmissing data collected by sample;
proc freq data = SampleMiss;
title'Test whether proportion of missing vs. non-missing data summed for each sample differed';
Table MissData/chisq exact relrisk;
weight count;
run;

*Question 1f: Count which samples collected had the most missing data: COMPLIANCE;
Title 'Samples and their counts on missing data';
proc freq data =S_T1_sm;
table (Sample1T1 Sample2T1 Sample3T1 Sample4T1 Sample5T1);
run;

*Question2a: count the amount of S and NS in each sample: QUALITY;
Title 'Samples and their counts of QNS';
proc freq data = S_T1_sm;
table (Qns1 Qns2 Qns3 Qns4 Qns5);*All samples S and NS counts;
run;

*Question2b: Count the amount of qns in overall data set;
Title'Overall QNS counts';
proc freq data=S_T1_sm;
table SQData; *SQdata is amount of qns reported for all samples: 1= qns was present 0= qns was not present;
run;

*Question2c: Difference btw S and NS collection by sample reported from the summation of SampleQNSC in original file;
Title'Difference btw Qns and non-Qns by sample';
data SampleVar;
input SampleNum$ QNSData$ count; 
Datalines; 
...
;
run;
proc freq data = SampleVar;
Table QNSdata*SampleNum/expected exact measures cl cmh;
weight count;
run;

*There is a difference btw QNSdata overall?;
proc freq data = SampleVar;
Table QNSdata/chisq exact;
weight count;
run;

*Question 2d:  Difference in S and NS by age group;
proc freq data = S_T1_sm;
Title 'Difference between QNS and Age';
table age_group*SQData/expected chisq exact relrisk;
run;

proc logistic data = S_T1_sm;
class age_group;
model SQData= Age_group;
run;

*Question 2e: Difference in S and NS OVERALL;
Title 'Overall difference in Qns and non-Qns';
proc freq data= S_T1_sm;
table SQData/chisq exact;
run;

proc sgplot data = S_T1_sm;
title 'Proportion of QNS by Age group';
vbar SQData/group = age_group stat=sum groupdisplay=stack;
run;

proc sgplot data = S_T1_sm;
title 'Proportion of QNS data';
vbar SQData;
run;

