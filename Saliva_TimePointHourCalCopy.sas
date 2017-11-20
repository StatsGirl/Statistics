*Breya Walker
11/7/2016	

This program will allow for the computation of difference in time for a given variable
The variable of interest is time. We will compute the average difference in time between
samples collected to see if patients adhered to the 1 hour time windows;


Data SampleTimes;
format MRN $5. AgeGroup $4. Sample1T time5.0 Sample2T time5.0 Sample3T time5.0 Sample4T time5.0 Sample5T time5.0;
input @1 MRN @9 AgeGroup $4. @13 Sample1T time8.0 @25 Sample2T time8.0 @37 Sample3T time8.0 @49 Sample4T time8.0 @61 Sample5T time8.0 ;
datalines;
....
;
run;

ods options off;

Data TimeDiff;
set Sampletimes;
S1S2= intck('minutes',Sample1T,Sample2T);
S2S3= intck('minutes',Sample2T,Sample3T);
S3S4= intck('minutes',Sample3T,Sample4T);
S4S5= intck('minutes',Sample4T,Sample5T);
if S3S4<0 then S3S4= abs(S3S4/23);
if S4S5 <0 then S4S5= abs(S4S5/23);
run;

proc sort data = timeDiff;
by AgeGroup;
run;

proc univariate data= TimeDiff mu0=60;
by AgeGroup;
var S1S2 S2S3 S3S4 S4S5;
run;

proc anova data= TimeDiff;
class AgeGroup;
model S1S2 S2S3 S3S4 S4S5=AgeGroup;
means AgeGroup;
run;
