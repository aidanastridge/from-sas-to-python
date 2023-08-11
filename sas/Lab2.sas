/*Directory*/
libname result "/folders/myfolders/sasuser.v94/Lab2-215333511/L2-Results";

/*Import Data*/
proc import out= result.CorrelationData 
            datafile= "/folders/myfolders/sasuser.v94/Lab2-215333511/CorrelationData.xls" 
            dbms=XLS replace;
			sheet="CorrelationData";
     getnames=YES;
	 datarow=2;
run;

/*Independent T-test*/
proc ttest data=result.correlationdata alpha=.05 side=2 h0=0;
var Correlation;
class BusinessLine;
where BusinessLine in ('Commercial', 'Corporate');
run;

/*Paired T-test*/
proc ttest data=result.correlationdata side=u alpha=.05;
paired CompanySizeScore*CompanyLeverageScore;
run;

/*ANOVA*/
proc anova data=result.correlationdata;
class BusinessLine;
Model Correlation = BusinessLine;
run;

/*Simple Linear Regression*/
proc reg data=result.correlationdata;
model Correlation = CompanySizeScore/clb;
run;

data result.correlationdata3;
set result.correlationdata;
if BusinessLine = "Commercial" then do Comm= 1;
Corp= 0;
end;
if BusinessLine = "Corporate"
then do Comm = 0;
Corp = 1;
end;
if BusinessLine = "SmallBusiness"
then do Comm = 0;
Corp = 0;
end;

CorrComm=CompanySizeScore*Comm;
  CorrCorp=CompanySizeScore*Corp;
run;

data result.correlationdata4;
set result.correlationdata;
if BusinessLine = "Commercial" then do Comm= 1;
Corp= 0;
end;
if BusinessLine = "Corporate"
then do Comm = 0;
Corp = 1;
end;
if BusinessLine = "SmallBusiness"
then do Comm = 0;
Corp = 0;
end;


proc reg data=result.correlationdata3;
model Correlation = CorrComm CorrCorp CompanySizeScore;
run;


/*BaseLine Commercial Common Slope*/
PROC FORMAT;
  VALUE  $BusinessLineComm "Commercial"="3.Commercial"
                  "Corporate"="2.Corporate" 
				  "SmallBusiness"="1.SmallBusiness";
RUN;

proc glm data=result.correlationdata;
format BusinessLine $BusinessLineComm.;
class BusinessLine;
model Correlation = CompanySizeScore BusinessLine/solution;
run;

/*BaseLine Corporate Common Slope*/
PROC FORMAT;
  VALUE  $BusinessLineCorp "Commercial"="2.Commercial"
                  "Corporate"="3.Corporate" 
				  "SmallBusiness"="1.SmallBusiness";
RUN;

proc glm data=result.correlationdata;
format BusinessLine $BusinessLineCorp.;
class BusinessLine;
model Correlation = CompanySizeScore BusinessLine/solution;
run;

/*BaseLine SmallBusiness Common Slope*/
PROC FORMAT;
  VALUE  $BusinessLineSmB "Commercial"="1.Commercial"
                  "Corporate"="2.Corporate" 
				  "SmallBusiness"="3.SmallBusiness";
RUN;

proc glm data=result.correlationdata;
format BusinessLine $BusinessLineSmB.;
class BusinessLine;
model Correlation = CompanySizeScore BusinessLine/solution;
run;

/*Interaction Commercial Uncommon Slope*/
proc glm data=result.correlationdata;
format BusinessLine $BusinessLineComm.;
class BusinessLine;
model Correlation = CompanySizeScore BusinessLine CompanySizeScore*BusinessLine/solution;
run;

/*Interaction Corporate Uncommon Slope*/
proc glm data=result.correlationdata;
format BusinessLine $BusinessLineCorp.;
class BusinessLine;
model Correlation = CompanySizeScore BusinessLine CompanySizeScore*BusinessLine/solution;
run;

/*Interaction SmallBusiness Uncommon Slope*/
proc glm data=result.correlationdata;
format BusinessLine $BusinessLineSmB.;
class BusinessLine;
model Correlation = CompanySizeScore BusinessLine CompanySizeScore*BusinessLine/solution;
run;




proc reg data=result.correlationdata;
     model Correlation = CompanySizeScore CompanyLeverageScore /slstay=0.05 slentry=0.05 selection=stepwise clm sse;
run;
proc reg data=result.correlationdata;
     model Correlation = CompanySizeScore CompanyLeverageScore /slstay=0.05 slentry=0.05 selection=backward sse;
run;
proc reg data=result.correlationdata;
     model Correlation = CompanySizeScore CompanyLeverageScore /slstay=0.05 slentry=0.05 selection=forward sse;
run;

proc reg data=result.correlationdata plots=diagnostics;
     model Correlation = CompanySizeScore CompanyLeverageScore/influence r;
	 output out=result.correlationdata2 rstudent=studentizedres predicted=pred h=lev cookd=cookd;
run;

data result.corrpred;
set result.correlationdata2;
cutoff=2*3/720;
diff=lev-cutoff;
	 if diff>0;
	 keep CompanySizeScore lev cutoff diff;
	run;

proc reg data=result.correlationdata3;
model Correlation = CompanySizeScore Comm Corp CorrComm CorrCorp;
run;

proc reg data=result.correlationdata3;
model Correlation = CompanySizeScore Comm Corp CorrComm CorrCorp;
run;








