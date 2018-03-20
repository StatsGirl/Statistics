*Breya Walker
*1.18.2018
*modified: 2.21.18
*This script analyzes the PedsQL version 4 and the Brain Tumor module data from RT2CR
*Data are from patient self report 5-18 years old
*Time frames analyzed are baseline to week 7 or proton therapy.
*We are interested in looking at the change in PedsQL subscales across time during PT;

proc import 
datafile='U:\CombinedPedsBT57PedsQL_scoresDEIDENTIFIED.xlsx'
dbms= xlsx
replace
out= APHON1857;
getnames=yes;
run;

proc import 
datafile='U:\CombinedPedsBT818PedsQL_scoresDEIDENTIFIED.xlsx'
dbms= xlsx
replace
out= APHON18818;
getnames=yes;
run;

proc contents data=APhon1857;
run;

proc contents data=APhon18818;
run;


*Only keep data from Baseline to Week 6 or 7 (Took out week 7 because it appears to have the most missing-this timepoint was optional to most (End of RT));
data APHON18_57 (drop= Cognitive EmotionScore Movement Nausea Worry Pain PhysicalScore ProAnxiety SchoolScore SocialScore);
set APHON1857;
CogTotal=input(Cognitive,best12.);
EmotionTotal=input(EmotionScore,best12.);
PhysicalTotal=input(PhysicalScore,best12.);
MoveTotal=input(Movement, best12.);
NauseaTotal=input(Nausea,best12.);
WorryTotal=input(Worry,best12.);
PainTotal=input(Pain,best12.);
ProAnixTotal=input(ProAnxiety,best12.);
SchoolTotal=input(SchoolScore,best12.);
SocialTotal=input(SocialScore,best12.);
if P_TimeFrame='T1 - Baseline' OR P_TimeFrame='T2 - Week 1' OR P_TimeFrame='T3 - Week 2' OR P_TimeFrame='T4 - Week 3' OR P_TimeFrame='T5 - Week 4' OR P_TimeFrame='T6 - Week 5' OR
P_TimeFrame='T7 - Week 6' OR P_TimeFrame='T8 - Week 7';
run;

data APHON18_818 (drop= P_MRN Cognitive EmotionScore Movement Nausea Worry Pain PhysicalScore ProAnxiety SchoolScore SocialScore);
format P_MRNN $4.;
set APHON18818;
P_MRNN=put(P_MRN,4.);
CogTotal=input(Cognitive,best12.);
EmotionTotal=input(EmotionScore,best12.);
PhysicalTotal=input(PhysicalScore,best12.);
MoveTotal=input(Movement, best12.);
NauseaTotal=input(Nausea,best12.);
WorryTotal=input(Worry,best12.);
PainTotal=input(Pain,best12.);
ProAnixTotal=input(ProAnxiety,best12.);
SchoolTotal=input(SchoolScore,best12.);
SocialTotal=input(SocialScore,best12.);
if P_TimeFrame='T1 - Baseline' OR P_TimeFrame='T2 - Week 1' OR P_TimeFrame='T3 - Week 2' OR P_TimeFrame='T4 - Week 3' OR P_TimeFrame='T5 - Week 4' OR P_TimeFrame='T6 - Week 5' OR
P_TimeFrame='T7 - Week 6' OR P_TimeFrame='T8 - Week 7';
run;

data APhon18_818;
set Aphon18_818;
rename P_MRNN=P_MRN;
run;

proc sort data = APHON18_818;
by P_Mrn;
run;

proc sort data= Aphon18_57;
by P_MRN;
run;

data CombinedData;
merge Aphon18_818  Aphon18_57;
by P_MRN;
run;

proc sort data=CombinedData;
by P_TimeFrame;
run;

%macro Desc(Name=);
%let Name=&Name;
*generate descriptives;
ods exclude all;
proc means data = CombinedData N Mean Std Min Q1 Median Q3 Max;
by P_TimeFrame;
var &Name;
ods output Summary="&Name";
run;
ods exclude none;

*Generate plots of the average scores over time for each outcome;
proc sgplot data=Work.CombinedData;
title"&Name Change over time";
vbar P_TimeFrame/response=&Name stat=mean datalabel;
run;

proc print data=Wc000001.&Name;
run;
%Mend Desc;

%Desc(Name=CogTotal);
%Desc(Name=EmotionTotal);
%Desc(Name=PhysicalTotal);
%Desc(Name=SocialTotal);
%Desc(Name=SchoolTotal);
%Desc(Name=MoveTotal);
%Desc(Name=NauseaTotal);
%Desc(Name=WorryTotal);
%Desc(Name=PainTotal);
%Desc(Name=ProAnixTotal);



/*

resume here after next steps

BSW 2.21.2018
*/

proc means data=CombinedData;
by P_TimeFrame;
var CogTotal EmotionTotal PhysicalTotal SocialTotal SchoolTotal MoveTotal NauseaTotal WorryTotal PainTotal ProAnixTotal;
run;

proc contents data = CombinedData;
run;

proc sort data= CombinedData;
by P_TimeFrame;
run;

*create new dataset that is transposed into wide;
proc sort data= CombinedData;
by P_MRN;
run;

proc transpose data=CombinedData out=WideAPhon18 let;
   by P_MRN;
   id P_TimeFrame;
   var PhysicalTotal SchoolTotal EmotionTotal SocialTotal CogTotal MoveTotal NauseaTotal PainTotal ProAnixTotal WorryTotal;
run;


proc sort data= CombinedData;
by P_TimeFrame;
run;

********************;
**************PedsQL v4 PhysicalTotal;
/*proc freq data=CombinedData;
tables P_MRN*P_TimeFrame*PhysicalTotal / 
cmh2 scores=rank noprint;
run;*/


/*
proc rank data= CombinedData out=rankedPhy;
by P_TimeFrame;
var PhysicalTotal;
ranks ranked_YIELD;
run;

proc glm data= rankedPhy;
class P_TimeFrame;
model ranked_YIELD=P_TimeFrame;
lsmeans P_TimeFrame;
run;*/

proc freq data=CombinedData;
tables P_MRN*P_TimeFrame*PhysicalTotal / 
cmh2 scores=rank noprint;
run;

proc glimmix data= CombinedData;
class P_TimeFrame P_MRN;
model PhysicalTotal=P_TimeFrame/solution dist=exponential;
random _residual_/subject=P_MRN;
lsmeans P_TimeFrame/ adjust=Tukey pdiff;
run;
 
*************PedsQL v4 social Total;

/*proc rank data= CombinedData out=rankedSoc;
by P_TimeFrame;
var SocialTotal;
ranks ranked_YIELD;
run;

proc glm data= rankedSoc;
class P_TimeFrame;
model ranked_YIELD=P_TimeFrame;
lsmeans P_TimeFrame;
run;*/

proc freq data=CombinedData;
tables P_MRN*P_TimeFrame*SocialTotal / 
cmh2 scores=rank noprint;
run;  

proc glimmix data= CombinedData;
class P_TimeFrame P_MRN;
model SocialTotal=P_TimeFrame/solution dist=exponential;
random _residual_/subject=P_MRN;
lsmeans P_TimeFrame/ adjust=tukey pdiff;
run;

****************PedsQL v4 Emotion Total;
/*proc rank data= CombinedData out=rankedEmo;
by P_TimeFrame;
var EmotionTotal;
ranks ranked_YIELD;
run;

proc glm data= rankedEmo;
class P_TimeFrame;
model ranked_YIELD=P_TimeFrame;
lsmeans P_TimeFrame;
run;*/

proc freq data=CombinedData;
tables P_MRN*P_TimeFrame*EmotionTotal / 
cmh2 scores=rank noprint;
run; 

proc glimmix data= CombinedData;
class P_TimeFrame P_MRN;
model EmotionTotal=P_TimeFrame/solution dist=exponential;
random _residual_/subject=P_MRN;
lsmeans P_TimeFrame/ adjust=tukey pdiff;
run;
******PedsQL v4 School Score;
/*
proc rank data= CombinedData out=rankedSchool;
by P_TimeFrame;
var SchoolTotal;
ranks ranked_YIELD;
run;

proc glm data= rankedSchool;
class P_TimeFrame;
model ranked_YIELD=P_TimeFrame;
lsmeans P_TimeFrame;
run;*/

proc freq data=CombinedData;
tables P_MRN*P_TimeFrame*SchoolTotal / 
cmh2 scores=rank noprint;
run; 

proc glimmix data= CombinedData;
class P_TimeFrame P_MRN;
model SchoolTotal=P_TimeFrame/solution dist=exponential;
random _residual_/subject=P_MRN;
lsmeans P_TimeFrame/ adjust=tukey pdiff;
run;

******Cognitive;
/*proc rank data= CombinedData out=rankedCog;
by P_TimeFrame;
var CogTotal;
ranks ranked_YIELD;
run;

proc glm data= rankedCog;
class P_TimeFrame;
model ranked_YIELD=P_TimeFrame;
lsmeans P_TimeFrame;
run;*/

proc freq data=CombinedData;
tables P_MRN*P_TimeFrame*CogTotal / 
cmh2 scores=rank noprint;
run;

proc glimmix data= CombinedData;
class P_TimeFrame P_MRN;
model CogTotal=P_TimeFrame/solution dist=exponential;
random _residual_/subject=P_MRN;
lsmeans P_TimeFrame/ adjust=tukey pdiff;
run;
 
*****Movement;
/*proc rank data= CombinedData out=rankedMove;
by P_TimeFrame;
var MoveTotal;
ranks ranked_YIELD;
run;

proc glm data= rankedMove;
class P_TimeFrame;
model ranked_YIELD=P_TimeFrame;
lsmeans P_TimeFrame;
run;*/

proc freq data=CombinedData;
tables P_MRN*P_TimeFrame*MoveTotal / 
cmh2 scores=rank noprint;
run; 

proc glimmix data= CombinedData;
class P_TimeFrame P_MRN;
model MoveTotal=P_TimeFrame/solution dist=exponential;
random _residual_/subject=P_MRN;
lsmeans P_TimeFrame/ adjust=tukey pdiff;
run;
*****Nausea;
/*proc rank data= CombinedData out=rankedNaus;
by P_TimeFrame;
var NauseaTotal;
ranks ranked_YIELD;
run;

proc glm data= rankedNaus;
class P_TimeFrame;
model ranked_YIELD=P_TimeFrame;
lsmeans P_TimeFrame;
run;*/

proc freq data=CombinedData;
tables P_MRN*P_TimeFrame*NauseaTotal / 
cmh2 scores=rank noprint;
run; 

proc glimmix data= CombinedData;
class P_TimeFrame P_MRN;
model NauseaTotal=P_TimeFrame/solution dist=exponential;
random _residual_/subject=P_MRN;
lsmeans P_TimeFrame/ adjust=tukey pdiff;
run;
******Pain Total;
/*proc rank data= CombinedData out=rankedPain;
by P_TimeFrame;
var PainTotal;
ranks ranked_YIELD;
run;

proc glm data= rankedPain;
class P_TimeFrame;
model ranked_YIELD=P_TimeFrame;
lsmeans P_TimeFrame;
run;*/

proc freq data=CombinedData;
tables P_MRN*P_TimeFrame*PainTotal / 
cmh2 scores=rank noprint;
run; 

proc glimmix data= CombinedData;
class P_TimeFrame P_MRN;
model PainTotal=P_TimeFrame/solution dist=exponential;
random _residual_/subject=P_MRN;
lsmeans P_TimeFrame/ adjust=tukey pdiff;
run;

*******ProAnixTotal;
/*proc rank data= CombinedData out=rankedAnx;
by P_TimeFrame;
var ProAnixTotal;
ranks ranked_YIELD;
run;

proc glm data= rankedAnx;
class P_TimeFrame;
model ranked_YIELD=P_TimeFrame;
lsmeans P_TimeFrame;
run;*/

proc freq data=CombinedData;
tables P_MRN*P_TimeFrame*ProAnixTotal / 
cmh2 scores=rank noprint;
run; 

proc glimmix data= CombinedData;
class P_TimeFrame P_MRN;
model ProAnixTotal=P_TimeFrame/solution dist=binomial;
random _residual_/subject=P_MRN;
lsmeans P_TimeFrame/ adjust=tukey pdiff;
run;

*******WorryTotal;
/*proc rank data= CombinedData out=rankedWor;
by P_TimeFrame;
var WorryTotal;
ranks ranked_YIELD;
run;

proc glm data= rankedWor;
class P_TimeFrame;
model ranked_YIELD=P_TimeFrame;
lsmeans P_TimeFrame;
run;*/

proc freq data=CombinedData;
tables P_MRN*P_TimeFrame*WorryTotal / 
cmh2 scores=rank noprint;
run; 

proc glimmix data= CombinedData;
class P_TimeFrame P_MRN;
model WorryTotal=P_TimeFrame/solution dist=exponential;
random _residual_/subject=P_MRN;
lsmeans P_TimeFrame/ adjust=tukey pdiff;
run;

