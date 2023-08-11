/*Directory*/
libname result "/folders/myfolders/sasuser.v94/Lab3-215333511/L3-Results";

/*Input Data*/
data result.CorpRateChange;
     input Year Change $ Count Default $;
	 datalines;
2018 Upgrade 206 N
2018 Same 2756 N
2018 Downgrade 360 N
2018 Default 164 Y
2017 Upgrade 249 N
2017 Same 2764 N
2017 Downgrade 222 N
2017 Default 103 Y
2016 Upgrade 305 N
2016 Same 2586 N
2016 Downgrade 234 N
2016 Default 120 Y
;

/*Population Proportion Test*/
proc freq data=result.CorpRateChange;
     tables Default/binomial(p=0.05 level="Y");
	 weight count;
	 where year=2018;
run;

/*Two-Population Proportion Test*/
proc freq data=result.CorpRateChange;
     tables Year*default/chisq;
	 weight count;
	 where Year in (2018, 2017);
run;

/*Change Data for Goodness Fit Test*/
data result.CorpRateChangeDef;
set result.CorpRateChange;
where Default='Y';

/*Goodness Fit Test*/
proc freq data=result.CorpRateChangeDef;
     tables Year/chisq;
	 weight count;	 
run;

/*Association*/
proc freq data=result.CorpRateChange;
     tables year*default/chisq;
	 weight count;
run;

/*Input Data*/
data result.CompanyX;
     input NewPlan $ ExistingPlan $ Count;
	 datalines;
Negative Negative 22
Negative Positive 9
Positive Negative 6
Positive Positive 63
;

/*McNemar's Test*/
proc freq data=result.CompanyX;
     table NewPlan*ExistingPlan;
	 exact mcnem;
	 weight count;
run;




