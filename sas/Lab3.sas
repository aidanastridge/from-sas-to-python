/*Directory*/
libname Qresult "/folders/myfolders/sasuser.v94/Q1/";

proc import out= Qresult.NHPI_GEO_G3 
            datafile= "/folders/myfolders/sasuser.v94/Q1/NHPI_G3.xlsx" 
            dbms=XLSX replace;
			sheet="NHPI_GEO_G3";
     getnames=YES;
	 datarow=2;
run;

proc means data = Qresult.nhpi_geo_g3 mean var std range min p25 median p75 max maxdec=1 ;
       var NHPI;
       Class GEO;
run;


title 'Histogram & Q-Q Plot (Univariate Procedure)';
proc univariate data=Qresult.nhpi_geo_g3 plot;
     class GEO;
	 histogram NHPI/normal ctext=blue;
	 qqplot NHPI;
run;

proc sort data=Qresult.nhpi_geo_g3 out=Qresult.nhpi_geo_g3; by GEO; run;
title 'Boxplot';
proc boxplot data = Qresult.nhpi_geo_g3;
    plot NHPI*GEO/notches; 
run;

proc sort data=Qresult.nhpi_geo_g3 out=Qresult.nhpi_geo_g3; by GEO; run;
proc ttest data=Qresult.nhpi_geo_g3 h0=93 sides=u alpha=.05;
var NHPI;
by GEO;
run;

proc ttest data=Qresult.nhpi_geo_g3 h0=93 sides=l alpha=.05;
var NHPI;
by GEO;
run;

proc ttest data=Qresult.nhpi_geo_g3 h0=93 sides=u alpha=.05;
var NHPI;
class geo;
run;


