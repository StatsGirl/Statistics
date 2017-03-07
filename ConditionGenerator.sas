*Breya Walker
this is a random condition generator
that assigns participants 
into one of 4 experimental conditions;

title1" Randomization of Experimental Conditions";
title2" A randomized 4 condition experimental design";
Proc format;
value Lesson 1="17 MEH 21 MHE"	
			 3="17 MHE 21 MEH"
			 5="21 MEH 17 MHE"
			 8="21 MHE 17 MEH";
run;

proc plan seed=1111111; *sample size = 168. 21 ppl per TABE per condition= 15 ppl per condition with 4 conditions gives168/4=42;
factors block=15 random Lesson = 4
random/noprint; *in this case with 42 ppl per condition with 4 blocks N=168;
output out=LessonConditions
Lesson nvals = (1 3 5 8) random;
run;


data LessonConditions (keep=pid block Lesson);
set LessonConditions;
pid=put(_n_,z3.);
run;
proc sort;  by pid;
run;

proc print noobs uniform split='*';
var pid Lesson;
label pid= "Participant*num"
	Lesson= "CSAL*Condition";
	format Lesson Lesson.;
run;

Title3"Number of Participants by lesson condition";
proc freq data= LEssonConditions;
table Lesson;
run;
