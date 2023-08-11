%global Inpath Outpath;
%let Inpath=/folders/myfolders/sasuser.v94/SAS_L9;
%let Outpath=/folders/myfolders/sasuser.v94/SAS_L9/Result;

LIBNAME  Mylib "&Inpath.";


/*####~~~ Fisher's Exact Test ~~~####*/
*ods rtf file="&outpath.\Lecture10-LogisticRegression.rtf" STYLE=statistical; 
data Mylib.DefaultData;
     input rating $1-3 count default $;
	 datalines;
AAA  130 N
AA   393 N
A    619 N
BBB  448 N
BB   179 N
B    124 N
AAA  3   Y
AA   6   Y
A    8   Y
BBB  19  Y
BB   10  Y
B    16  Y
;
proc print; run;

title "Contingency Table Analysis ODDS RATIO";
proc freq data=Mylib.DefaultData;
     tables rating*default/chisq exact or;
	 weight count;
	 where rating in ("A", "BBB");
run;

PROC IMPORT OUT= Mylib.admission
            DATAFILE= "&Inpath./admission.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
RUN;

PROC FREQ data=Mylib.admission;
   table school*admission/chisq nopercent nocol cl;/*Options nopercent and nocol suppress the rows �Percent� and �Col Pct�.*/
run;

proc logistic  data=Mylib.admission ;
      	class school (ref='business') / param = ref;
            /*define 'business' school as baseline*/
            /*and the dummy code 1, 0*/
      	model admission = school;
        output out=Mylib.predicted1 pred= Pred lower=LCL upper=UCL;
run;

proc genmod  data=Mylib.admission descending;
	/* 'denied' is defined as baseline*/
	 class school (ref='business') / param = ref ;
     model admission = school/dist=binomial link=logit;
     estimate "OR.school" school 1/exp;
     output out=Mylib.predicted2 p=pred lower=LCL upper=UCL;
run;

/*Example Y:  admission (�Admitted�, �Denied�),   X:   gender, school, SAT100 */    
proc logistic  data=Mylib.admission; 
     class school (ref='business') / param = ref ;
     class gender (ref='male') / param = ref ;
     model admission = gender school SAT100;
     output out =Mylib.predicted3  p=pred lower=LCL upper=UCL;
run;
/*Alternative*/
proc genmod  data=Mylib.admission; 
     class school (ref='business') / param = ref ;
     class gender (ref='male') / param = ref ;
     model admission = gender school SAT100/dist=binomial link=logit;
     estimate "OR.school" school 1/exp;
     output out =Mylib.predicted4  p=pred lower=LCL upper=UCL ;
run;

*ods rtf close;
