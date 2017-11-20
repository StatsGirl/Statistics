*Import Heather's data;
%let dir = path;
%put dir; 

libname Heather "&dir";
proc import out = Heather.Modules
datafile = "&dir\path"
DBMS= xlsx replace;
getnames= yes;
run;

proc print data = Heather.Modules;
run;

data Heather.NewModules (rename=(Mapped_Item_Completed_Date=FinishTime Mapped_Item_Started_Date=StartTime Score__Percent_=Score Mapped_Item_Name=ModuleName));
*(Drop=First_Name Last_Name Department Manager_Name Item_Name Item_Completed_Date);;
set Heather.Modules; 
label Mapped_Item_Completed_Date = 'FinishTime'
	  Mapped_Item_Started_Date= 'StartTime'
	  Mapped_Item_Name='ModuleName'
	  Score__Percent_='Score';
run;


data Heather.NewModules (Keep=ModuleName Score StartTime FinishTime username Duration);
	set Heather.NewModules;
	if Duration < 0 then Duration = .;
	else if Duration ^lt 0 then Duration =Duration;
run;

proc contents Data = Heather.NewModules;
run;

*Question 1: Does the intervention (modules) influence Nurse Kx (piper scale) with module interaction?;
proc sort data = Heather.NewModules;
by ModuleName;
run;

proc univariate data = Heather.NewModules;
by ModuleName;
var Duration Score;
run;

proc freq data= Heather.NewModules;
table ModuleName;
run;

data Pipper;
input PipperPretestDur PipperPretestScore PipperPosttestDur PipperPostestScore ID;
datalines;
...
;
run;

data ModuleTime;
input Module $ DurationMod ID;
datalines;
...
;
run;

proc univariate data = ModuleTime;
by Module;
var DurationMod;
run;

data Pipper;
set Pipper;
difference= PipperPostestScore-PipperPretestScore; *Difference measure for Wilicox Sign ranked sum test. After module interaction- before module interaction;
run;

proc sort data = Pipper;
by ID;
run;

proc corr data= Pipper;
var PipperPretestScore PipperPretestDur PipperPostestScore PipperPosttestDur; *Not correlation between Duration with postest and Scores Postest and Pretest;
run;

proc glm data= Pipper;
model PipperPretestScore = PipperPretestDur; *See if PipperScore Pretest was influenced by duration of pretest (time as covariate);
run;

proc glm data= Pipper;
model PipperPostestScore = PipperPosttestDur;*See if PipperScore Posttest was influenced by duration of posttest (time as covariate);
run;

proc univariate data = Pipper; 
var difference PipperPostestScore PipperPretestScore; *Obs are paired by ID;
run;

*Question 2:Does module interaction and other covariates (Pipper performance) influence Nurse Identification (woundCare) with module interaction;

data WoundCare;
input WoundCarePosttestDur	WoundCarePostScore	WoundCarePretestDur	WoundCarePretestScore ModuleDur ID; *Create Data set for WoundCare numbers;
datalines;
...

;
run;

proc sort data = WoundCare; *Sort Data set by ID;
by ID;
run;

data CombinedScores; *Combine Pipperscores with Woundcare scores;
set WoundCare Pipper;
merge WoundCare Pipper;
by ID;
run;

proc print data =CombinedScores;
run;

data CombinedScores; *Create new WoundCare difference score from post-pretest;
set CombinedScores;
WoundDiff= WoundCarePostScore-WoundCarePretestScore;
run;

proc univariate data = CombinedScores; *Get descriptives on Scores in COmbinedScores dataset;
var ModuleDur WoundCarePosttestDur WoundCarePostScore WoundCarePretestDur WoundCarePretestScore PipperPretestDur PipperPretestScore PipperPosttestDur PipperpostestScore;
run;

proc glm data= CombinedScores ;
class ID;
model PipperPostestScore= ModuleDur|PipperPosttestDur; *Pipper Postest score IS NOT influenced by Module Duration;
run;

proc univariate data = CombinedScores; *Is there a significant difference in the posttest and pretest scores on the wound care quiz? YES;
var WoundDiff;
run;

proc glm data= CombinedScores; *Is the woundCare posttest score influenced by the pipper posttest score/ pipper pretest score or the amount of time each nurse interacted with the 4 modules (ModuleDur);
class ID;
model WoundDiff= PipperPostestScore|PipperPretestScore; *WoundCare score is not influenced by the module duration MODULEDUR removed from model;
run;
 
proc glm data= CombinedScores; *Is the woundCare posttest score influenced by the pipper posttest score/ pipper pretest score or the amount of time each nurse interacted with the 4 modules (ModuleDur);
class ID;
model WoundCarePostScore= PipperPostestScore|PipperPretestScore; *WoundCare score is not influenced PipperPosttest Score or pretest score;
run;

proc glm data= CombinedScores; *Is the woundCare posttest score influenced by the pipper posttest score/ pipper pretest score or the amount of time each nurse interacted with the 4 modules (ModuleDur);
class ID;
model WoundCarePretestScore= PipperPostestScore; *WoundCare score is not influenced by the module duration MODULEDUR removed from model;
run;

proc corr data= CombinedScores;
var woundCarepostScore PipperPostestScore PipperPretestScore;
run;

proc corr data= CombinedScores;
var woundDiff PipperPostestScore PipperPretestScore;
run;

proc gplot data= combinedscores;
plot PipperPostestScore*WoundCarepostscore;
run;

*Without measures for module completion It is hard to say if the module interaction influenced the woundcare difference and pipper difference seen in;

*Question3: Is there a significant Difference between Nurses BRaden Scores vs. Team Scores;
data BradenScore;
input ID Age Measure $	RN	Team; *Create Data set for WoundCare numbers;
datalines;
...
;
run;

proc univariate data=BradenScore;
var Age;
run;

proc Univariate data=BRadenScore;
by Measure;
var RN Team;
run;

data BradenScoreONly;
input Person $ Score; *Create Data set for BRadenScores only;
datalines;
...
run;

proc npar1way data= BradenScoreOnly wilcoxon;
class person;
var Score;
run;

data BradenScoreQ;
input Person $ Score; *Create Data set for BRadenScores Q;
datalines;
...
;
run;

proc npar1way data= BradenScoreQ wilcoxon;
class person;
var Score;
run;


options nocenter formdlim='-';
ods rtf;
Title  'Pressure Ulcer Data report';
Title2 'By';
Title3 'Breya Walker';
Title4 'Mean time spent per module';
proc univariate data = ModuleTime;
by Module;
var DurationMod;
run;
Title5 'There is a significant difference between the Pipper Pretest Score and the Pipper Posttest Score';
proc univariate data = Pipper; 
var difference PipperPostestScore PipperPretestScore; *Obs are paired by ID;
run;
Title6'Combined Data set containing: Wound Care, Pipper, Module interaction time';
proc print data =CombinedScores;
run;
Title7'Descriptive statistics on all variables of interest';
proc univariate data = CombinedScores; *Get descriptives on Scores in COmbinedScores dataset;
var ModuleDur WoundCarePosttestDur WoundCarePostScore WoundCarePretestDur WoundCarePretestScore PipperPretestDur PipperPretestScore PipperPosttestDur PipperpostestScore;
run;
Title8' There is a significant difference between the Wound care posttest and wound care pretest score';
proc univariate data = CombinedScores; *Is there a significant difference in the posttest and pretest scores on the wound care quiz? YES;
var WoundDiff;
run;
Title9' WoundCare Scores (posttest) were shown NOT to be influenced by the Pipper test performance(pre and post): Did Nursing Knowledge influence the Nurse identification?';
proc glm data= CombinedScores; *Is the woundCare posttest score influenced by the pipper posttest score/ pipper pretest score or the amount of time each nurse interacted with the 4 modules (ModuleDur);
class ID;
model WoundDiff= PipperPostestScore|PipperPretestScore; *WoundCare score is not influenced by the module duration MODULEDUR removed from model;
run;
Title10' Also the Module interaction time was shown NOT to influence the Wound Care scores and the pipper Scores: So module interaction time was not a co-variate that influenced the wound care or pipper performance (that was one of your concerns)';
Title1 ' With the lack of a score to measure Module performance is it hard to REALLY say whether the Wound care or Pipper posttest scores were influenced by the module interaction. With the change in scores from pretest to posttest on the wound care and pipper scale it can be inferred that the modules may have played apart';
Title2 ' Descriptive stats on the Braden and BradenQ scores';
proc univariate data=BradenScore;
var Age;
run;
proc Univariate data=BradenScore;
by Measure;
var RN Team;
run;
Title3' There was a significant difference in Nurses Braden scores compared to the Team scores given';
proc npar1way data= BradenScoreOnly wilcoxon;
class person;
var Score;
run;
Title4' There was a significant difference in Nurses Braden Q scores compared to the Team Scores given';
proc npar1way data= BradenScoreQ wilcoxon;
class person;
var Score;
run;
ods rtf close;

