
*APHON Statistical Analysis plan (2017 conference)- 
RT2CR investigating incoming and changing sleep study results.
Purpose of research is to characterize sleep study results of Cranios
Date modified: 7.17.17;

libname RT2CR 'path';
proc import out = RT2CR.RT2CR_T1T2
datafile = 'path'
DBMS= xlsx replace;
sheet="T1T2";
getnames= yes;
run;

proc import out = RT2CR.RT2CR_T1T3
datafile = 'path'
DBMS= xlsx replace;
sheet="T1T3";
getnames= yes;
run;

proc import out = RT2CR.RT2CR_T1
datafile = 'path'
DBMS= xlsx replace;
sheet="T1";
getnames= yes;
run;


*Modify the label names by removing them. Default will be label=varnames;
proc datasets lib=Work;
modify RT2CR_T1T2;
attrib _all_ label=' ';
run;

proc datasets lib=Work;
modify RT2CR_T1T3;
attrib _all_ label=' ';
run;

proc datasets lib=Work;
modify RT2CR_T1;
attrib _all_ label=' ';
run;

Data RT2CR.RT2CR_T1T2_2;
set RT2CR.RT2CR_T1T2;
if Race="A" then Race ="O";
if Race= "A & W" then Race = "O";
if Race= "B & W" then Race = "O";
if Race = "Mult" then Race= "O";
if Race = "Pacific Islander" then Race= "O";
if Race = "Black and White" then Race= "O";
if Race = "U" then Race = "O";
run;

Data RT2CR.RT2CR_T1T3_2;
set RT2CR.RT2CR_T1T3;
if Race="A" then Race ="O";
if Race= "A & W" then Race = "O";
if Race= "B & W" then Race = "O";
if Race = "Mult" then Race= "O";
if Race = "Pacific Islander" then Race= "O";
if Race = "Black and White" then Race= "O";
if Race = "U" then Race = "O";
run;

Data RT2CR.RT2CR_T1_2;
set RT2CR.RT2CR_T1;
if Race="A" then Race ="O";
if Race= "A & W" then Race = "O";
if Race= "B & W" then Race = "O";
if Race = "Mult" then Race= "O";
if Race = "Pacific Islander" then Race= "O";
if Race = "Black and White" then Race= "O";
if Race = "U" then Race = "O";
run;


proc contents data= RT2CR.RT2CR_T1T2_2;
run;

*convert all variables to numeric based on current datatype;
proc contents data = RT2CR.RT2CR_T1;
run;

*T1;
Data RT2CR.RT2CR_T1_3;
set RT2CR.RT2CR_T1_2;
TannerN=input(TannerT1,best8.);
AgeT2N=input(AgeT1,best8.);
drop TannerT1;
run;

proc contents data = RT2CR.RT2CR_T1_3;
run;

*T1T2;
Data RT2CR.RT2CR_T1T2_3;
set RT2CR.RT2CR_T1T2_2;
NapOppsT1N=Input(NapOppsT1,best8.);
NapOppsT2N=Input(NapOppsT2,best8.);
MSLTSOLT1=input(MSLT_SOlT1,best8.);
MSLTSOLT2=input(MSLT_SOLT2,best8.);
PLMT2N=input(PLMT2,best8.);
SOREMPT1N=input(SOREMPT1,best8.);
SOREMPT2N=input(SOREMPT2,best8.);
TannerT2N=input(TannerT2,best8.);
PSG_TTimeBedT2N=input(PSG_TTimeBedT2,best8.);
PSG_TSleepTT2N=input(PSG_TSleepTT2,best8.);
PSGSleepEffT2N=input(PSGSleepEffT2,best8.);
PSGLatT2N=input(PSGLatT2,best8.);
AHIT2N=input(AHIT2,best8.);
PSG_MinSatT2N=input(PSG_MinSatT2,best8.);
drop NapOppsT1 NapOppsT2 MSLT_SOlT1 MSLT_SOLT2 PLMT2 SOREMPT1 SOREMPT2 TannerT2 PSG_TTimeBedT2 PSG_TSleepTT2 PSGSleepEffT2 PSGLatT2 AHIT2 PSG_MinSatT2 ;
run;

proc contents data = RT2CR.RT2CR_T1T2_3 out=meta (keep=name);
run;

proc print data=meta;
run;

*T1T3;
Data RT2CR.RT2CR_T1T3_3;
set RT2CR.RT2CR_T1T3_2;
NapOppsT1N=Input(NapOppsT1,best8.);
NapOppsT3N=Input(NapOppsT3,best8.);
MSLTSOLT1=input(MSLT_SOlT1,best8.);
MSLTSOLT3=input(MSLT_SOLT3,best8.);
PLMT1N=input(PLMT1,best8.);
SOREMPT1N=input(SOREMPT1,best8.);
SOREMPT3N=input(SOREMPT3,best8.);
TannerT3N=input(TannerT3,best8.);
PSG_TTimeBedT3N=input(PSG_TTimeBedT3,best8.);
PSG_TSleepTT3N=input(PSG_TSleepTT3,best8.);
PSGSleepEffT3N=input(PSGSleepEffT3,best8.);
PSG_MinSatT3N=input(PSG_MinSatT3,best8.);
PSGLatT3N=input(PSGLatT3,best8.);
AHIT1N=input(AHIT1,best8.);
AHIT3N=input(AHIT3,best8.);
PSG_MinSatT3N=input(PSG_MinSatT3,best8.);
PLMT3N=input(PLMT3,best8.);
drop NapOppsT1 NapOppsT3 MSLT_SOlT1 MSLT_SOLT3 PLMT1 SOREMPT1 SOREMPT3 TannerT3 PSG_TTimeBedT3 PSG_TSleepTT3 PSGSleepEffT3 PSG_MinSatT3 PSGLatT3 AHIT1 AHIT3 PSG_MinSatT2 PLMT3 ;
run;

*Data Analysis section;
TITLE1 'CHARACTERISTICS OF patients at BASELINE';
Title2 'Descriptives FOR continuous data';
proc univariate data = RT2CR.RT2CR_T1_3;
var AgeT1 MSLT_SOLT1 SOREMPT1 PLMT1 PSG_TSleepTT1 TannerN; 
run;

Title2 'Descriptives for categorical for patients at baseline ';
proc freq data = RT2CR.RT2CR_T1_3;
table Gender Race HyperT1 NarcoT1 StimREcT1 StimPresT1;
run;

*Data Analysis section;
TITLE1 'CHARACTERISTICS OF patients at BASELINE and T2';
Title2 'Descriptives FOR continuous data';
proc univariate data = RT2CR.RT2CR_T1T2_3 normal;
var  TannerT1 TannerT2N AgeT1 MSLTSOLT1 MSLTSOLT2 SOREMPT1N SOREMPT2N PLMT1 PLMT2N PSG_TSleepTT1 PSG_TSleepTT2N; 
run;

Title2 'Descriptives for categorical for patients at baseline and T2';
proc freq data = RT2CR.RT2CR_T1T2_3;
table Gender Race HyperT1  NarcoT1 StimREcT1 StimPresT1 HyperT2 NarcoT2 StimREcT2 StimPresT2;
run;


*Data Analysis section;
TITLE1 'CHARACTERISTICS OF patients at BASELINE and T3';
Title2 'Descriptives FOR continuous data';
proc univariate data = RT2CR.RT2CR_T1T3_3 normal;
var AgeT1 MSLTSOLT1 MSLTSOLT3 TannerT1 TannerT3N SOREMPT1N SOREMPT3N PLMT1N PLMT3N PLMT3N PSG_TSleepTT1 PSG_TSleepTT3N; 
run;

Title2 'Descriptives for categorical for patients at baseline and T3';
proc freq data = RT2CR.RT2CR_T1T3_3;
table Gender Race HyperT1 NarcoT1 StimREcT1 StimPresT1 HyperT3 NarcoT3 StimREcT3 StimPresT3;
run;

*******************************************************************PAIRED DATA ANALYSIS;
Data RT2CR.RT2CR_T1T2_Diff;
set RT2CR.RT2CR_T1T2_3;
diffMSLT=MSLTSOLT2-MSLTSOLT1;
diffPLM=PLMT2N-PLMT1;
diffSOREMP=SOREMPT2N-SOREMPT1N;
diffSleepTime=PSG_TSleepTT2N-PSG_TSleepTT1;
run;

Data RT2CR.RT2CR_T1T3_Diff;
set RT2CR.RT2CR_T1T3_3;
diffMSLT=MSLTSleepLatT2N-MSLTSleepLatT1N;
diffPLM=PLMT3N-PLMT1N;
diffSOREMP=SOREMPT3N-SOREMPT1N;
diffSleepTime=PSG_TSleepTT3N-PSG_TSleepTT1;
run;

*If differences (Diff variables) between timepoints are normally distributed than I can use parametric statistics if not use wilcoxon signed rank below for diff variables;
Title 'Patients baseline to t12-18 MSLT and SOREMP';
proc univariate data = RT2CR.RT2CR_T1T2_Diff normal;
var diffMSLT diffSOREMP;
run;


*Changes in frequency counts acros time;
*Freq Counts of Dx and Stims;
Title"Change in patients baseline to T12-T18 on Dx";
proc freq data = RT2CR.RT2CR_T1T2_Diff ;
table HyperT1 NarcoT1 HyperT2 NarcoT2 StimREcT2 StimPresT2 StimREcT1 StimPresT1;
run;

ods html;
proc freq data = RT2CR.RT2CR_T1T2_Diff;
title"McNemar's test for paired samples T1T2: NArco Dx";
tables NarcoT1*NarcoT2/agree expected norow nocol;
run;

proc freq data = RT2CR.RT2CR_T1T2_Diff;
title"McNemar's test for paired samples T1T2: Hyper Dx";
tables HyperT1*HyperT2/agree expected norow nocol;
run;


proc freq data = RT2CR.RT2CR_T1T2_Diff;
title"McNemar's test for paired samples: Stimulant recomm";
tables StimRecT1*StimRecT2/agree expected norow nocol;
run;

proc freq data = RT2CR.RT2CR_T1T2_Diff;
title"McNemar's test for paired samples: Stimulant prescribed";
tables StimPresT1*StimPresT2/agree expected norow nocol;
run;

****************************************************************************************************************************************;
*T1T3;

Data RT2CR.RT2CR_T1T3_Diff;
set RT2CR.RT2CR_T1T3_3;
diffMSLT=MSLTSOLT3-MSLTSOLT1;
diffPLM=PLMT3N-PLMT1N;
diffSOREMP=SOREMPT3N-SOREMPT1N;
diffSleepTime=PSG_TSleepTT3N-PSG_TSleepTT1;
run;


*If differences (Diff variables) between timepoints are normally distributed than I can use parametric statistics if not use wilcoxon signed rank below for diff variables;
Title 'Patients baseline to T3 MSLT and SOREMP';
proc univariate data = RT2CR.RT2CR_T1T3_Diff normal;
var diffMSLT diffSOREMP;
run;


*Changes in frequency counts acros time;
*Freq Counts of Dx and Stims;
Title"Change in patients baseline to T3 on Dx";
proc freq data = RT2CR.RT2CR_T1T3_Diff ;
table HyperT1 NarcoT1 HyperT3 NarcoT3 StimREcT3 StimPresT3 StimREcT1 StimPresT1;
run;

ods html;
proc freq data = RT2CR.RT2CR_T1T3_Diff;
title"McNemar's test for paired samples T1T3: NArco Dx";
tables NarcoT1*NarcoT3/agree expected norow nocol;
run;

proc freq data = RT2CR.RT2CR_T1T3_Diff;
title"McNemar's test for paired samples T1T3: Hyper Dx";
tables HyperT1*HyperT3/agree expected norow nocol;
run;


proc freq data = RT2CR.RT2CR_T1T3_Diff;
title"McNemar's test for paired samples T1T3: Stimulant recomm";
tables StimRecT1*StimRecT3/agree expected norow nocol;
run;

proc freq data = RT2CR.RT2CR_T1T3_Diff;
title"McNemar's test for paired samples T1T3: Stimulant prescribed";
tables StimPresT1*StimPresT3/agree expected norow nocol;
run;


*COMPARE T1T2 VS T1T3 PATIENTS ON DIFFMSLT;
Data RT2CR_INDSamples;
input Timepoint DiffMSLT;
datalines;
...
;
run;

*comparison between Patients T1 to T12-18 and T1 to T36;
Title' COMPARISON BTW PATIENTS from T1 to T2 vs. PATIENTS from T1 to T3';
proc ttest data = RT2CR_INDSamples;
class Timepoint;
var diffMSLT;
run;

*Can we predict T3 MSLT sleep latency based on other sleep study factors related to MSLT?;
*Can MSLT T3 sleep latency values be predicted by T1 MSLT and other T1 MSLT measures?
That would be T3MSLT= T1MSLT SOREMPT1;
/*proc corr data = RT2CR_sleeppaired;
var T2MSLTSleepN T1MLSTSleepN T1AHIN T1BedTimeN T1Min_SatN T1PLMN T1PSGSleeplatN T1SOREMPN T1SleepTimeN T1SleepEffN;
run;

*T1MSLT T1SOREMP and T1SleepTimeN shown to correlate with T2 MSLTSleep;
Title" Crude model";
proc glm data= RT2CR_Sleeppaired;
model T2MSLTSleepN= T1MLSTSleepN/solution;
run;
Title "Adjusted Model: T1SleepTimeN";
proc glm data =RT2CR_Sleeppaired;
Model T2MSLTSleepN= T1MLSTSleepN T1SleepTimeN/solution;
run;
Title "Adjusted Model: T1SOREMPN";
proc glm data =RT2CR_Sleeppaired;
Model T2MSLTSleepN= T1MLSTSleepN T1SOREMPN/solution;
run;*/

*Crude slope of MSLTSleeLatT3N= 0.313170132. % change= adjusted -crude/adjusted*100;
*Adjusted slope of T1MSLST with TotalSleepTime in model=0.299933487. %change = (0.299933487-0.313170132)/(0.299933487)*100=-4.4;
*Adjusted sleope of T1MLST with T1SOREMP in model= 0.326727719. % change = (0.326727719-0.313170132)/(0.326727719)*100=4.14;
*No confounds observed;


proc glm data = RT2CR_T1T3Sleep2 plots (unpack)=diagnostic;
model MSLTSleepLatT3N= MSLTSleepLatN SOREMPT1N MinSat SleepEff SleepLatency TotalSleepTime/tolerance; *All baseline sleep results included;
run;

proc glm data = RT2CR_T1T3Sleep2 plots (unpack)=diagnostic;
model MSLTSleepLatT3N= MSLTSleepLatN TotalSleepTime MSLTSleepLatN*TotalSleepTime/tolerance; *Got rid of insignificant vars;
run;


Title' Can we predict T36 MSLT sleep latency from baseline MSLT and PSG total Sleep time for T1 to T3 patients';
proc glm data = RT2CR_T1T3Sleep2 plots (unpack)=diagnostic;
model MSLTSleepLatT3N= MSLTSleepLatN TotalSleepTime/tolerance; *Interaction was not significant so it was removed;
run;

Title" Baseline MSLT by T3 MSLT";
proc sgplot data= RT2CR_T1T3Sleep2;
reg x=MSLTSleepLatN y = MSLTSleepLatT3N/clm cli;
run;

Title" Baseline TotalSleepTime by T3 MSLT";
proc sgplot data= RT2CR_T1T3Sleep2;
reg x=TotalSleepTime y = MSLTSleepLatT3N/clm cli;
run;


Title" Predict Cohort 1 SOL based on Cohort 2 SOL and SleepTime";
data Cohort1predict;
input T3SOL T3SleepT T3PredT2;
datalines;
....
;
run;

Title' Can we predict Cohort 1s T3 SOL based on cohort 2 baseline SOL and TotalSleepTime';
proc reg data = Cohort1predict;
model T3PredT2= T3SOL /r cli clm; *Interaction was not significant so it was removed;
run;


data Pooled;
infile datalines delimiter=''; 
input Age Race$ Gender$ Timepoint;
datalines;
....
;
run;

Title "Demographic differences between cohorts T2 and T3";
proc ttest data=Pooled;
class timepoint;
var Age;
run;

proc sort data =pooled;
by timepoint;
run;

proc freq data = Pooled order=data;
by timepoint;
table race gender/chisq exact;
run;


