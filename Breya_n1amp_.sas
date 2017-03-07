
/*Average over 'F1' 'FZ' 'F2' 'FCz' 'FC1' 'FC2'; CAR reference*/

/**********To store the results as a pdf file********/
ods pdf file='C:\Users\breya\Desktop\SAS Data\CP Thesis Data\Breya_N1amps';
OPTIONS LS=80 PS=70 PAGENO=1 formdlim="~";

dm 'clear output';  /* Clear output window */
dm 'clear log';     /* Clear log window */;


data CP;
input subject domain $ condition $ cat $ n1amp ;
*n1amp=sqrt(n1amp);
cards;
1	speech 	act	vw1/vw5	-0.833802974
2	speech 	act	vw1/vw5	-0.160793046
3	speech 	act	vw1/vw5	-0.497005893
4	speech 	act	vw1/vw5	-1.041589103
5	speech 	act	vw1/vw5	-0.513314315
6	speech 	act	vw1/vw5	-0.982468991
7	speech 	act	vw1/vw5	-0.326985153
8	speech 	act	vw1/vw5	-0.424010495
9	speech 	act	vw1/vw5	0.033708542
10	speech 	act	vw1/vw5	-0.420674569
1	speech 	pass	vw1/vw5	-1.20470573
2	speech 	pass	vw1/vw5	-0.035553719
3	speech 	pass	vw1/vw5	-0.96574007
4	speech 	pass	vw1/vw5	-1.035682106
5	speech 	pass	vw1/vw5	-0.46897205
6	speech 	pass	vw1/vw5	-1.119341181
7	speech 	pass	vw1/vw5	-0.563979207
8	speech 	pass	vw1/vw5	-0.157151705
9	speech 	pass	vw1/vw5	0.175597866
10	speech 	pass	vw1/vw5	0.171709046
1	speech 	act	vw3	-0.416678327
2	speech 	act	vw3	0.221164462
3	speech 	act	vw3	0.083504114
4	speech 	act	vw3	-1.257622482
5	speech 	act	vw3	-0.726691655
6	speech 	act	vw3	-0.770345861
7	speech 	act	vw3	0.468155958
8	speech 	act	vw3	-0.521133564
9	speech 	act	vw3	0.070784334
10	speech 	act	vw3	0.190699867
1	speech 	pass	vw3	-1.116559698
2	speech 	pass	vw3	0.050867862
3	speech 	pass	vw3	-0.785581547
4	speech 	pass	vw3	-0.756103487
5	speech 	pass	vw3	-0.442542694
6	speech 	pass	vw3	-1.609248909
7	speech 	pass	vw3	-0.737952562
8	speech 	pass	vw3	-0.339728209
9	speech 	pass	vw3	0.032473121
10	speech 	pass	vw3	-0.196346994
1	music	act	vw1/vw5	-0.713816006
2	music	act	vw1/vw5	0.124961978
3	music	act	vw1/vw5	-0.346529451
4	music	act	vw1/vw5	-0.386837455
5	music	act	vw1/vw5	-0.286822726
6	music	act	vw1/vw5	-0.777970671
7	music	act	vw1/vw5	-0.288742036
8	music	act	vw1/vw5	-0.186154941
9	music	act	vw1/vw5	0.338120059
10	music	act	vw1/vw5	0.637598079
1	music	pass	vw1/vw5	-0.28824382
2	music	pass	vw1/vw5	0.047069086
3	music	pass	vw1/vw5	-0.49049869
4	music	pass	vw1/vw5	-0.275602136
5	music	pass	vw1/vw5	0.037972741
6	music	pass	vw1/vw5	-0.751158534
7	music	pass	vw1/vw5	-0.524787105
8	music	pass	vw1/vw5	0.074731681
9	music	pass	vw1/vw5	0.22215644
10	music	pass	vw1/vw5	-0.020662557
1	music	act	vw3	-0.820113087
2	music	act	vw3	0.057233076
3	music	act	vw3	-0.276596416
4	music	act	vw3	-0.474301534
5	music	act	vw3	0.150207224
6	music	act	vw3	-0.003798575
7	music	act	vw3	-0.015573845
8	music	act	vw3	-0.171696976
9	music	act	vw3	0.394575237
10	music	act	vw3	0.232377532
1	music	pass	vw3	-0.348649945
2	music	pass	vw3	0.013567046
3	music	pass	vw3	-0.164523218
4	music	pass	vw3	-0.229354846
5	music	pass	vw3	0.135845039
6	music	pass	vw3	-0.829201805
7	music	pass	vw3	-0.554610097
8	music	pass	vw3	0.159109423
9	music	pass	vw3	0.228702927
10	music	pass	vw3	0.765556045



;

run;


PROC SORT DATA=CP OUT=sortout;
	BY domain condition cat subject;
RUN;


/*TITLE2 'Means';*/
/*/*proc print data=sortout;run; */*/
/*proc means data=sortout; */
/*by domain condition;*/
/*run;*/


TITLE2 'Omnibus ANOVAs';
/***************************************************/
/*				Univariate ANOVAs           		*/
/***************************************************/

ods graphics on;
PROC GLIMMIX DATA=sortout ORDER=data plots=residualpanel;
by domain;
	CLASS condition domain cat subject;
	MODEL n1amp=condition|cat;
	RANDOM subject subject*condition subject*condition subject*cat;
	LSMEANS condition*cat/ADJUST=tukey ALPHA=0.05  plot=mean(sliceby=cat join) SLICEDIFF=(cat condition);

	RUN;



/*proc rank data=sortout out=sortout2;*/
/*   var n1p2amp;*/
/*   ranks n1p2amp_ranked; /*ranked*/
/*run;*/
/**/
/**/
/*PROC GLIMMIX DATA=sortout2 ORDER=data plots=residualpanel;*/
/*   BY domain;*/
/*   CLASS domain condition cat subject;*/
/*   model n1p2amp_ranked= cat|condition;*/
/*	RANDOM subject;*/
/*	RANDOM _residual_;*/
/*	LSMEANS condition*cat/ADJUST=tukey ALPHA=0.05  plot=mean(sliceby=cat join) SLICEDIFF=(cat condition);*/
/**/
/*	RUN;*/




ods pdf close; 
quit;
