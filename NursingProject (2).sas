/*Created: Breya Walker
Purpose: Perform the first portion of a primary end point analysis. (1) Merge Final and Scr data sets. (2) Proc mixed on merged
Between all variables.
*/
libname NR '/folders/myshortcuts/SummerResearch_Relyea/Nursing Project/befefiles (1)';

*step1: Run BEFE file;

Proc sort data = Work.Final_VisitsR;
by ID;
run;

Proc sort data = work.Initial_VisitsR;
by ID;
run;

*merge;
data TotalData;
Merge work.Final_VisitsR work.Initial_VisitsR;
by ID;
run;	

*Tranpose data;
proc transpose data= TotalData
out=TotalData_Transpose;
by ID;
run;

proc print data=work.TotalData_transpose;
var _NAME_;
run;

Data Transposed;
Set Work.TotalData_TRanspose;
newname=upcase(_NAME_);
if _NAME_="SCR_FINAL" then delete;
if prxmatch("m/SCR/oi",_NAME_) then SCR=1;
if prxmatch("m/FINAL/oi",_Name_) then Final =2;
if Final=2 then Time=2;
else if Scr=1 then Time=1;
run;

Data New;
set transposed;
array newstring{*} _NAME_;
do i=1 to dim(newstring);
newvar1=count(newstring{i},'_');
if newvar1=1 then do
newvar2=scan((newstring{i}),1,'_');
newvar=upcase(catt(newvar2));
end;
else if newvar1>1 then do
newvar2=scan((newstring{i}),1,'_');
newvar3=scan((newstring{i}),2,'_');
newvar=UPCASE(catt(newvar2,'_',newvar3));
i+1;
end;
end;
run;

*****Marco: Loop through each variable set scr and final and perform proc mixed*******;
*use proc sql to find all data from where names equal;

proc sql;
create table VarNames as
select newvar from work.New;
quit;

proc transpose data= VarNames let out=Work.TransVarNames;
id newvar;
run;

proc transpose data=TransVarNames out=LongVarNames;
run;

*****macro for proc mixed 50 variables;
%macro Mixed(data=New, varname=);
%let variable=&varname;
%let maxdim=2;
%DO i=1 %to &maxdim;
Data Work.NEWTABLE; set &data;
where newname=catt(&variable,"_FINAL") or newname=catt(&variable,"_SCR");
%end;

proc mixed data= NEWTABLE method=reml covtest;
Class _NAME_ Time ID;
model Col1= _NAME_;
random ID/subject=ID type=cs;*test for compound symmetry;
ods output covparms=CovEstimates;
run;

proc sort data= NEWTABLE;
by _NAME_;
run;

proc means data= NEWTABLE;
by _NAME_;
var Col1;
ods output Summary=Summary_statistics;
run;

proc sgplot data=Summary_Statistics;
vbarbasic COL1_Mean/group=_NAME_;
run;
%let maxdim= %eval(&maxdim +1);
run;
%mend Mixed;
******End of macro;

%Mixed(data=New, varname='VISIT_DATE');
%Mixed(data=New, varname='VISIT_DATE');
%Mixed(data=New, varname='HR');
%Mixed(data=New, varname='TEMP');
%Mixed(data=New, varname='RR');
%Mixed(data=New, varname='PAIN');
%Mixed(data=New, varname='O2_SATURATION');
%Mixed(data=New, varname='WBC');
%Mixed(data=New, varname='RBC');
%Mixed(data=New, varname='HGB');
%Mixed(data=New, varname='HCT');
%Mixed(data=New, varname='MCV');
%Mixed(data=New, varname='MCHC');
%Mixed(data=New, varname='RDW');
%Mixed(data=New, varname='PLT');
%Mixed(data=New, varname='NEUT');
%Mixed(data=New, varname='LYMP');
%Mixed(data=New, varname='MONO');
%Mixed(data=New, varname='EOSIN');
%Mixed(data=New, varname='BASO');
%Mixed(data=New, varname='NA');
%Mixed(data=New, varname='K');
%Mixed(data=New, varname='CL');
%Mixed(data=New, varname='CO2');
%Mixed(data=New, varname='BUN');
%Mixed(data=New, varname='SCR');
%Mixed(data=New, varname='GLU');
%Mixed(data=New, varname='CA');
%Mixed(data=New, varname='TP');
%Mixed(data=New, varname='ALB');
%Mixed(data=New, varname='BIL');
%Mixed(data=New, varname='ALP');
%Mixed(data=New, varname='AST');
%Mixed(data=New, varname='ALT');
%Mixed(data=New, varname='UA_PH');
%Mixed(data=New, varname='UA_SG');
%Mixed(data=New, varname='GLOBAL01');
%Mixed(data=New, varname='GLOBAL02');
%Mixed(data=New, varname='GLOBAL03');
%Mixed(data=New, varname='GLOBAL04');
%Mixed(data=New, varname='GLOBAL05');
%Mixed(data=New, varname='GLOBAL09');
%Mixed(data=New, varname='GLOBAL06');
%Mixed(data=New, varname='GLOBAL10');
%Mixed(data=New, varname='GLOBAL08');
%Mixed(data=New, varname='GLOBAL07');
%Mixed(data=New, varname='BP_SYSTOLIC');
%Mixed(data=New, varname='BP_DIASTOLIC');
%Mixed(data=New, varname='VISIT_TIME');
%Mixed(data=New, varname='LYMPH');




