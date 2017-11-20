libname POE 'path';
proc import out = POE.POE1
datafile = 'path'
DBMS= xlsx replace;
getnames= yes;
run;

proc contents data= POE.POE1 out=Variables;
run;

*Data with missing codes will be recoded as .;
data POE.POE2;
set POE.POE1;
put AgeT1 best12.;put Tanner best12.;put MSLTSOL best12.;Newverb = input(Verb,best12.);NewProcess=input(process,best12.);NewWM=input(WM,best12.); NewPerc=input(Perc,best12.); NewFSIQ=input(FSIQ,best12.);
if NewVerb=. or NewVerb=. then
delete;
else if NEwProcess=. or NewProcess=. then
delete;
else if NewWM=. or NewWM=. then
delete;
else if NewPerc=. or NewPerc=. then
delete;
else if NewFSIQ=. or NewFSIQ=. then
delete;
drop Verb WM Perc Process FSIQ;
run;

*Data with codes-9999 and -9996 recoded as missing=.;
data POE.POE3;
set POE.POE2;
if NewVerb=-9999 or NewVerb=-9996 then
Newverb=.;
if NewProcess=-9999 or NewProcess=-9996 then
NewProcess=.;
if NewWM=-9999 or NewWM=-9996 then
NewWM=.;
if NewPerc=-9999 or NewPerc=-9996 then
NewPerc=.;
if NewFSIQ=-9999 or NewFSIQ=-9996 then
NewFSIQ=.;
run;

* cases deleted due to missing data in the neurocog. -9999 and -9996 were converted to .;
proc contents data =POE.POE2;
run;

title'Descriptives';
proc univariate data= POE.POE3 normal;
var AgeT1 Tanner MSLTSOL NewVerb NewWM NewPerc NewProcess NewFSIQ;
run;

proc sort data =POE.Poe3;
by group;
run;

proc univariate data=POE.POE2;
by Group;
var MSLTSOL;
run;

proc freq data = POE.POE3;
table Group Gender Race;
run;

*Assume the data are not normally distributed. Majority of data are not normally distributed;
proc univariate data=POE.POE3 outtable=Moments;
by Group;
var Newverb NewWM NewPerc NewProcess NewFSIQ;
run;


*Wilcoxon rank sum test;
title'Wilcoxon rank sum';
proc npar1way wilcoxon correct=no data=POE.POE3;
class Group;
var Newverb NewWM NewPerc NewProcess NewFSIQ;; 
run;

*Patients without Narcolepsy/Hypersomnia compared to those with it;
proc import out = POE.POEWO
datafile = 'path'
DBMS= xlsx replace;
getnames= yes;
run;

data POE.POEWO2;
set POE.POEWO;
NewAge=Input(AgeT1,best12.);NewTanner= input(TannerT1, best12.);MSLTSOL=input( MSLT_SOLT1, best12.);Newverb = input(Verb,best12.);NewProcess=input(process,best12.);NewWM=input(WM,best12.); NewPerc=input(Perc,best12.); NewFSIQ=input(FSIQ,best12.);
if NewVerb=-9999 or NewVerb=-9996 then
Newverb=.;
if NewProcess=-9999 or NewProcess=-9996 then
NewProcess=.;
if NewWM=-9999 or NewWM=-9996 then
NewWM=.;
if NewPerc=-9999 or NewPerc=-9996 then
NewPerc=.;
if NewFSIQ=-9999 or NewFSIQ=-9996 then
NewFSIQ=.;
if MSLT_SOLT1=. then delete;

run;
drop Verb WM Perc Process FSIQ;
run;

title'Descriptives Patients without DX';
proc univariate data= POE.POEWO2 normal;
var NewAge NewTanner MSLTSOL NewVerb NewWM NewPerc NewProcess NewFSIQ;
run;
proc univariate data= POE.POE3 normal;
by Group;
var AgeT1 Tanner MSLTSOL NewVerb NewWM NewPerc NewProcess NewFSIQ;
run;
proc freq data = POE.POE3;
table Group Gender Race;
run;
title'Wilcoxon rank sum';
proc npar1way wilcoxon correct=no data=POE.POE3;
class Group;
var Newverb NewWM NewPerc NewProcess NewFSIQ;; 
run;
ods pdf close;
