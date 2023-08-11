/*Directory*/
libname Qresult "/folders/myfolders/sasuser.v94/Lab1-215333511/";

/*Import Data*/
proc import out= result.LoanData 
            datafile= "/folders/myfolders/sasuser.v94/Lab1-215333511/LoanData.xls" 
            dbms=XLS replace;
			sheet="LoanData";
     getnames=YES;
	 datarow=2;
run;

/*Deletes spaces between data.*/
data result.loandata;
set result.loandata;
if BorrowerID =. then delete;
run;

/*LoanAmount '000.*/
data result.loandata;
set result.loandata;
LoanAmount_Scaled = LoanAmount/1000;
run;


title1 'Loan Amount';  
title2 'Mean, standard deviation, variance, and 5-number summary';
/*Calculate mean, standard deviation, variance & 5-number summary of LoanAmount marginally*/
proc means data = result.loandata n mean std var min p25 median p75 max maxdec=2;
       var LoanAmount_Scaled;
  
       
run;

title1 'Correlation with Market, Loan Amount by Business Line'; 
title2 'Range, interquartile range, and coefficient of variation';
/*Range, IQR, & Coefficient of Variation for Corporate and Commercial Borrowers*/
proc means data=result.loandata range qrange cv;
var CorrelwMarket LoanAmount;
class BusinessLine;
run;

title1 'Loan Amount by Region'; 
title2 'Mean, standard deviation, variance, and 5-number summary';
/*Calculate mean, standard deviation, variance & 5-number summary of LoanAmount by Region*/
proc means data=result.loandata n mean std var min p25 median p75 max clm stderr maxdec=2;
       var LoanAmount_Scaled; 
       class Region;
run;

title1 'Correlation with Market by Region'; 
title2 'Side-by-side notched box-plot';
/*Notched box-plot for Correlation with Market by Region*/
proc sort data=result.loandata out=result.loandata; by Region; run;
proc boxplot data=result.loandata;
plot CorrelwMarket*Region/notches;
run;

title1 'Loan Amount by Business Line'; 
title2 'Histogram';
/*Histograms for Loan Amounts by Corporate and Commercial Business Line*/
proc sort data=result.loandata out=result.loandata; by BusinessLine; run;
proc univariate data=result.loandata;
     by BusinessLine;
	 histogram LoanAmount;
run;

proc sort data=result.loandata out=result.loandata; by BusinessLine; run;
proc univariate data=result.loandata;
     class BusinessLine;
	 histogram LoanAmount/normal;	 
run;

proc ttest data=result.loandata h0=980000 sides=u alpha=.05;
var LoanAmount;
run;

































