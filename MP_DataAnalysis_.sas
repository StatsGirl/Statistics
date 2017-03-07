/*Question 1: Assess the difference  between NE and NJ MMN responses at Cz;
libname SAS_Data '/folders/myshortcuts/MP_Senior_thesis_data';
proc import out = MP_MMN
datafile = '/folders/myshortcuts/MP_Senior_thesis_data/MMN_Overall_Data_SAS.xlsx'
DBMS= xlsx replace;
getnames= yes;
run;

proc print data=MP_MMN;
run;

*Differences in MMN amp for clustered data by Language group;
ods graphics on;
proc glimmix data=MP_MMN order =data plots=residualpanel;
Class  Language;
model MMN_Cz = Language;
Random ID ID*Language; 
lsmeans Language/ adjust= Tukey;
run;
*Differences in MMN latency at Cz by Language group;
ods graphics on;
proc glimmix data=MP_MMN order =data plots=residualpanel;
Class  Language;
model MMN_latency = Language;
Random ID ID*Language;
lsmeans Language/ adjust= Tukey; 
run;*/

*Question 2: Assess N1 amp and latency by lang. group;
libname SAS_Data '/folders/myshortcuts/MP_Senior_thesis_data';
proc import out = MP_Overall
datafile = '/folders/myshortcuts/MP_Senior_thesis_data/7.13.16_MP_Data_clustered.xlsx'
DBMS= xlsx replace;
getnames= yes;
run;

proc print data=MP_Overall;
run;

proc sort data=MP_Overall out=MP;
by StimulusType;
*by Electrode;
run;

proc print data=MP;
run;

*N1amp;
ods graphics on;
proc glimmix data=MP order =data plots= residualpanel;
*By Electrode;
Class  Language StimulusType ID;
model N1amp = Language|StimulusType ;*Assess whether N1amp differs btw Ne and NJ and for stimulus type;
Random ID ID*Language ID*StimulusType; *Do not need random effects of stimulustype b/c that is the effect I am interested in (see Breya_n1ampt_sas.sas for example line 126);
lsmeans Language*StimulusType/adjust=tukey alpha= 0.05 slicediff = (Language StimulusType) plot=mean(sliceby=Language*StimulusType);
run;
*N1 Latency;
ods graphics on;
proc glimmix data=MP order =data plots= residualpanel;
Class  Language StimulusType ID;
model N1lat = Language|StimulusType ;*Assess whether N1amp differs btw Ne and NJ and for stimulus type;
Random ID ID*Language ID*StimulusType; *Do not need random effects of stimulustype b/c that is the effect I am interested in (see Breya_n1ampt_sas.sas for example line 126);
lsmeans Language*StimulusType/adjust=tukey alpha= 0.05 slicediff = (Language StimulusType) plot=mean(sliceby=Language*StimulusType);
run;

*Question 3: P1 amp and latency;
*P1 amp;
ods graphics on;
proc glimmix data=MP order =data plots= residualpanel;
Class  Language StimulusType ID;
model P1amp = Language|StimulusType ;*Assess whether N1amp differs btw Ne and NJ and for stimulus type;
Random ID ID*Language ID*StimulusType; *Do not need random effects of stimulustype b/c that is the effect I am interested in (see Breya_n1ampt_sas.sas for example line 126);
lsmeans Language*StimulusType/adjust=tukey alpha= 0.05 slicediff = (Language StimulusType) plot=mean(sliceby=Language*StimulusType);
run;
*P1 latency;
ods graphics on;
proc glimmix data=MP order =data plots= residualpanel;
Class  Language StimulusType ID;
model P1lat = Language|StimulusType ;*Assess whether N1amp differs btw Ne and NJ and for stimulus type;
Random ID ID*Language ID*StimulusType; *Do not need random effects of stimulustype b/c that is the effect I am interested in (see Breya_n1ampt_sas.sas for example line 126);
lsmeans Language*StimulusType/adjust=tukey alpha= 0.05 slicediff = (Language StimulusType) plot=mean(sliceby=Language*StimulusType);
run;

*Question4: P2 amp and Latency;
*P2 amp;
ods graphics on;
proc glimmix data=MP order =data plots= residualpanel;
Class  Language StimulusType ID;
model P2amp = Language|StimulusType ;*Assess whether N1amp differs btw Ne and NJ and for stimulus type;
Random ID ID*Language ID*StimulusType; *Do not need random effects of stimulustype b/c that is the effect I am interested in (see Breya_n1ampt_sas.sas for example line 126);
lsmeans Language*StimulusType/adjust=tukey alpha= 0.05 slicediff = (Language StimulusType) plot=mean(sliceby=Language*StimulusType);
run;
*P2 latency;
ods graphics on;
proc glimmix data=MP order =data plots= residualpanel;
Class  Language StimulusType ID;
*By Electrode;
model P2lat = Language|StimulusType ;*Assess whether N1amp differs btw Ne and NJ and for stimulus type;
Random ID ID*Language ID*StimulusType; *Do not need random effects of stimulustype b/c that is the effect I am interested in (see Breya_n1ampt_sas.sas for example line 126);
lsmeans Language*StimulusType/adjust=tukey alpha= 0.05 slicediff = (Language StimulusType) plot=mean(sliceby=Language*StimulusType);
run;

*Question 5: Assess derived N1-P2 amp measure and group differences;
ods graphics on;
proc glimmix data=MP order =data plots= residualpanel;
Class  Language StimulusType ID;
model N1P2mag = Language|StimulusType ;*Assess whether N1amp differs btw Ne and NJ and for stimulus type;
Random ID ID*Language ID*StimulusType; *Do not need random effects of stimulustype b/c that is the effect I am interested in (see Breya_n1ampt_sas.sas for example line 126);
lsmeans Language*StimulusType/adjust=tukey alpha= 0.05 slicediff = (Language StimulusType) plot=mean(sliceby=Language*StimulusType);
run;

/*Question 6: Assess overall categorical like response magnitude in NJ and Ne to see if there is a difference in detecttion of freq and rare stimuli;
libname SAS_Data '/folders/myshortcuts/MP_Senior_thesis_data';
proc import out = MP_MagVar
datafile = '/folders/myshortcuts/MP_Senior_thesis_data/N1P2mag.xlsx'
DBMS= xlsx replace;
getnames= yes;
run;

proc print data=MP_MagVar;
run;

ods graphics on;
proc glimmix data=MP order =data plots= residualpanel;
Class  Language StimulusType ID Electrode;
By Electrode;
model N1P2amp = Language|StimulusType|Electrode ;*Assess whether N1amp differs btw Ne and NJ and for stimulus type;
Random ID ID*Electrode ID*Language ID*StimulusType; *Do not need random effects of stimulustype b/c that is the effect I am interested in (see Breya_n1ampt_sas.sas for example line 126);
lsmeans Language*StimulusType*Electrode/adjust=tukey alpha= 0.05 slicediff = (Language StimulusType Electrode) plot=mean(sliceby=Language*StimulusType*Electrode);
run;*/

*Question7: Assess whether years and age of NJ can be used to predict N1P2mag. 1 subject was excluded from analysis because they failed to report their years and age;
libname SAS_Data '/folders/myshortcuts/MP_Senior_thesis_data';
proc import out = MP_NJ
datafile = '/folders/myshortcuts/MP_Senior_thesis_data/PredictiveRegression.xlsx'
DBMS= xlsx replace;
getnames= yes;
run;

*proc sort data= MP_NJ;
*by Electrode;
*run;

proc glm data=MP_NJ plots=diagnostics;
class ID;
By Stim;
model P1amp P1lat N1amp N1lat= Age/solution tolerance;
run;

proc glm data=MP_NJ plots=diagnostics;
class ID;
*By Electrode;
model P1amp= Age/solution tolerance;
run;

proc glm data=MP_NJ plots=diagnostics;
class ID;
*By Electrode;
model P1lat= Age/solution tolerance;
run;

proc glm data=MP_NJ plots=diagnostics;
class ID;
*By Electrode;
model P2amp= Age/solution tolerance;
run;

proc glm data=MP_NJ plots=diagnostics;
class ID;
*By Electrode;
model P2lat= Age/solution tolerance;
run;

proc glm data=MP_NJ plots=diagnostics;
class ID;
*By Electrode;
model N1amp= Age/solution tolerance;
run;

proc glm data=MP_NJ plots=diagnostics;
class ID;
*By Electrode;
model N1lat= Age/solution tolerance;
run;

proc glm data= MP_NJ plots=diagnostics;
class ID;
model MMNamp=MMNAge/solution tolerance;
run;



