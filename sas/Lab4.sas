 proc import out= work.StatsCanG3 
            datafile= "/folders/myfolders/sasuser.v94/MT/HPI_CPI_StatsCan_G3.xlsx" 
            dbms=XLSX replace;
			sheet="G3_AB_ON_QC";
     getnames=YES;
	 datarow=2;
run;

proc means data = work.statscang3 mean var std range min p25 median p75 max stderr maxdec=2 clm;
       var NHPI;
       Class GEO;
       output out=work.StatsCanG4 var=var n=n;
run;

data work.statscang5;
set work.StatsCanG4;
MOE = 1.96*sqrt(var/n);
run;

data work.statscang3uni;
set work.statscang3;
if GEO ="Quebec" then delete;
run;

proc univariate data=work.statscang3uni plot;
     class GEO;
	 histogram NHPI/normal ctext=blue;
run;

proc sort data=work.statscang3uni out=work.statscang3bp; by GEO; run;
proc boxplot data = work.statscang3bp;
    plot NHPI*GEO/notches; 
run;

proc means data = work.statscang3 mean alpha=.05 clm stderr  maxdec=2 ;
       var NHPI;
       Class GEO;
run;

proc anova data=work.statscang3;
class GEO;
Model NHPI = GEO;
run;

data work.G3_dd1;
     set work.StatsCanG3;
	 if GEO = "Alberta" then  AB=1; else AB=0;
	 if GEO = "Quebec" then QC=1; else QC=0;
	 Gas_AB = Gasoline*AB;
	 Gas_QC = Gasoline*QC;
	 Gds_AB = Goods*AB;
	 Gds_QC = Goods*QC;
run;

proc reg data=work.G3_dd1;
     model NHPI = Gasoline Goods AB QC Gas_AB Gas_QC Gds_AB Gds_QC/slstay=0.05 slentry=0.05 selection=stepwise sse;
run;

proc reg data=work.G3_dd1 plots=diagnostics;
     model NHPI = Gasoline Goods AB QC Gas_AB Gas_QC Gds_AB Gds_QC/influence r;
	 output out=work.G3_dd12 rstudent=studentizedres predicted=pred h=lev cookd=cookd;
run;

data work.G4_dd1;
     set work.StatsCanG3;
	 if GEO = "Alberta" then  AB=1; else AB=0;
	 if GEO = "Ontario" then  ON=1; else ON=0;
	 if GEO = "Quebec" then QC=1; else QC=0;
	 Gas_AB = Gasoline*AB;
	 Gas_ON = Gasoline*ON;
	 Gas_QC = Gasoline*QC;
	 Gds_AB = Goods*AB;
	 Gds_ON = Goods*ON;
	 Gds_QC = Goods*QC;
run;

proc reg data=work.G3_dd1;
     model NHPI = Gasoline Goods AB QC ON Gas_AB Gds_ON Gas_QC Gds_AB Gds_ON Gds_QC/slstay=0.05 slentry=0.05 selection=stepwise sse;
run;

proc reg data=work.G3_dd1 plots=diagnostics;
     model NHPI = Gasoline Goods AB QC Gas_AB Gas_QC Gds_AB Gds_QC/influence r;
	 output out=work.G3_dd12 rstudent=studentizedres predicted=pred h=lev cookd=cookd;
run;

proc surveymeans data = work.statscang3;
       Class GEO;
       var NHPI;
run;

data work.G5_dd1;
  set work.StatsCanG3;
  if GEO='Ontario' then do 
      AB=0; 
      QC=0; 
  end;
  else if GEO='Alberta' then do 
      AB=1; 
      QC=0; 
  end;
  else if GEO='Quebec' then do 
      AB=0; 
      QC=1; 
  end;
  
  Gas_AB = Gasoline*AB;
	 Gas_QC = Gasoline*QC;
	 Gds_AB = Goods*AB;
	 Gds_QC = Goods*QC;
run;

proc reg data=work.G5_dd1;
     model NHPI = Gasoline Goods AB QC Gas_AB  Gas_QC Gds_AB  Gds_QC/slstay=0.05 slentry=0.05 selection=stepwise sse;
run;





