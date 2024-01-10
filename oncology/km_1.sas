/*******************************************************************************
 **-Property of xxx;

**-Program name:                 xxx.sas
 **-Compound/Study/Analysis:     xxx
 **-Programmer name:             xxx xxx
 **-Date of creation:            xx/xx/xxx
 **-Description:                 System setup 
 **-Called Routines:             

**-Input Files:                  

**-Output Files:                

**-Macro parameters:             
 **-Example:

**-Limits:                      

**-Revision History:
 **-N?   Date           Author          Description of the change
 **       
 **************************************************************************************************/
*===================================================================================;
*                        INITIALIZATION STEP                                        ;
*===================================================================================;
dm 'clear log; clear out';
%include "E:\01_SAS _pharm\06_project\template.sas";
libname adam 'E:\01_SAS _pharm\06_project\km_refine';
proc datasets lib=work kill memtype=data;
run;

%let pgmnm=km_refine;

***All treated patients ; 
    proc sort data=adam.adsl(where=(SAFFL="Y")) out= pop; 
      by usubjid ;
    run ; 

data fin  ;
  merge adam.adtte(in=a keep=usubjid param paramcd aval cnsr) pop(in=b keep=usubjid trt01an trt01a) ;
  by usubjid ;
  if a & b  ; 
  if paramcd="OS";
run ; 

proc sql;
   select ceil(max(aval)/6)*6 into :max_time
   from fin ;
quit;

/*KM Figure dataset*/
/*ods output ProductLimitEstimates=km1;*/
/*proc lifetest data=fin atrisk;*/
/* time aval*cnsr(1);*/
/* strata trt01an ;*/
/*run;*/
/*ods output close;*/

/*Additional timelist (in months) dataset for figure*/
ods graphics on;
ods output Quartiles=q survivalplot=km homtests=test;
proc lifetest data=fin plots=survival(atrisk) timelist=0 to 54 by 6 OUTSURV=surv;  
 time aval*cnsr(1);
 strata trt01an;
run;
ods output close;
ods graphics off;

ods rtf close;
ods listing;

****PFS Median Survival time  ; 
proc sort data=q ; by percent ; run ; 
data quant;
  length descr stats $100 ;
  set q ;
  grp =3 ;
  if percent =25 then descr = "First Quartile (95% CI)"; 
  else if percent =50 then descr ="Median (95% CI)"; 
  else if percent =75 then descr ="Third Quartile (95% CI)";

  if upperlimit>.Z then stats = strip(put(estimate, 6.3))||" months ("||strip(put(lowerlimit, 6.2))||' ,'||strip(put(upperlimit, 6.2))||' )';
  else stats = strip(put(estimate, 6.3))||" months ("||strip(put(lowerlimit, 6.2))||' ,'||'NA'||' )';
  drop estimate ; 
run ; 


data _null_;
  set quant (where=(percent =50)) ;
  call symput('med'||strip(put(trt01an,best.)) , strip(descr)||': '||strip(stats)) ;
run ; 

%put &med1 &med2; 

***hazard ratio;
ods output parameterestimates=estimate;
proc phreg data=fin;
	class trt01an;
	model aval*cnsr(1)=trt01an/rl;
quit;
ods output close;

***p macro;
/*%SYMDEL _all_;*/
data _null_;
set test;
if _n_=1;
call symput('P',put(ProbChiSq,pvalue6.4));
run;
***hazard ratio macro;
data _null_;
set estimate;
CI=put(hazardratio,5.2)||'('||'95%CIs, '||put(hrlowercl,5.2)||'-'||put(hruppercl,5.2)||')';
call symput('hazar',CI);
run;

%put hazard;

data final;
	set km;
	z=STRATUMNUM;
	surv=STRATUMNUM;
run;

proc format ;
   value survm  1 = "ABC-1234 5 mg+ATEZOLIZUMAB: &med1." 
                2 = "ABC-1234 5 mg+IPILIMUMAB :&med2."          
   ;  
   value trt  1 = "ABC-1234 5 mg+ATEZOLIZUMAB" 
              2 = "ABC-1234 5 mg+IPILIMUMAB"          
   ;  
run ; 

data Anno_At_Risk;
	length function label textcolor $200;
	set km end=eof;
	by stratum;
	retain id 0 function x1space y1space textsize textweight width y1 anchor;
	keep id function x1space y1space textsize textweight width y1 x1 label textcolor anchor;
	if first.stratum then
		do;
			id+1;
			function='text';
			x1space='datavalue';
			y1space='datavalue';
			textsize=8;
			textweight='normal';
			width=200;
			y1=-((id-1)*0.05+0.3);
		end;

	if tatrisk ne . then
		do;
			x1=tatrisk;
			label=put(atrisk, 3.0);
			if id=1 then textcolor='blue'; else textcolor='red';
			output;
		end;

if eof then do;
 function='text'; x1space='datavalue'; y1space='datavalue';
 textsize=8;textweight='normal'; textcolor='black';
 width=200;anchor='left'; 
 x1=-19; y1=-0.25; label='No. at Risk'; output;

  function='text'; x1space='datavalue'; y1space='datavalue';
 textsize=8;textweight='normal';textcolor='blue';
 width=200;
 x1=-19; y1=-0.3; label='ABC-1234 5 mg + ATEZOLIZUMAB'; output;

  function='text'; x1space='datavalue'; y1space='datavalue';
 textsize=8;textweight='normal';textcolor='red';
 width=200; 
 x1=-19; y1=-0.35; label='BC-1234 5 mg + IPILIMUMAB'; output;

 function='text'; x1space='datavalue'; y1space='datavalue';
 textsize=8;textweight='normal';
 width=200; 
 x1=6; y1=0.3; label='Hazard Ratio for ABC-1234 5 mg+IPILIMUMAB.&hazar P=&P'; textcolor='black';output;
 end;
run;

/*proc template;*/
/*   define style mystyle;*/
/*      style graphcolors from graphcolors / 'gctext'=blue;*/
/*   end;*/
/*run;*/


proc template;
	define style styles.custom;
	parent=styles.rtf;
		replace fonts /
	       'TitleFont2' = ("CourierNew",12pt,Bold Italic)
           'TitleFont' = ("CourierNew",9pt) /*titles, footnotes and generated text*/
           'StrongFont' = ("CourierNew",9,Bold)
           'EmphasisFont' = ("CourierNew",9pt,Italic)
           'FixedEmphasisFont' = ("Courier New, Courier",9pt,Italic)
           'FixedStrongFont' = ("Courier New, Courier",9pt,Bold)
           'FixedHeadingFont' = ("Courier New, Courier",9pt,Bold)
           'BatchFixedFont' = ("SAS Monospace, Courier New, Courier",6.7pt)
           'FixedFont' = ("Courier New, Courier",9pt)
           'headingEmphasisFont' = ("CourierNew",9pt,Bold Italic)
           'headingFont' = ("CourierNew",9pt) /*column headers*/
           'docFont' = ("CourierNew",9pt); /*cell values*/
		style table from table / 
			rules=none 
			frame=above 
			cellspacing=0.2 
			cellpadding=0.1;
		style body from document /
			leftmargin=0.75in
			rightmargin=0.75in
			topmargin=0.75in
			bottommargin=0.75in;
		replace headersandfooters from cell /
			foreground=black
			backgroundcolor=white
			font=fonts('headingFont')
			borderbottomwidth=.5pt 
			borderbottomcolor=black 
			bordertopwidth=.5pt 
			bordertopcolor=black;
	end;
run;


/**** BEGIN GRAPHING ****/
options nodate nonumber nocenter orientation = landscape;

**create RTF file **;
ods listing close;
ods rtf file = "E:\01_SAS _pharm\06_project\km_refine\&pgmnm..rtf" style=styles.custom nogtitle nogfootnote;
ods graphics on / width = 8.0 in height = 5.0in border = off;
ods rtf image_dpi=300;

  title1 j=l font=CourierNew   height = 9pt &gtitle1.; 
  title2 j=l font=CourierNew   height =9 pt "Protocol ABC1234"       j=r "CSR" ;
  title3 " "; 
  title4 j=c font=CourierNew   height = 9 pt "FIGURE 1";
  title5 j=c font=CourierNew   height = 9 pt "KM Plot of Overall Survival";
  title6 j=c font=CourierNew   height = 9 pt "Safety Population";
 
  footnote1 j=l font=CourierNew  height = 9 pt "Figure Produced on %sysfunc(today(),worddate12.). Program: &pgmnm..sas"; 


/*   symbol1 line = 1 color = red i =stepj; */
/** Dash line for trt group ; */
/*   symbol2 line =  2 color = yellow i = stepj;*/
/** Cross mark for censored points; */
/*   symbol3 color = black;*/
proc sgplot data = final sganno=Anno_At_Risk pad=(bottom=15pct)  pad=(left=30pct);
    styleattrs datacontrastcolors=(blue red)  datasymbols=(plus);
/*     styleattrs datacontrastcolors=(blue red) datasymbols=(plus circle);*/
    step x=TIME y=survival / name='SURV' group=STRATUMNUM;
/*    lineattrs=(pattern=dash thickness=2);*/
/*    keylegend 'SURV' / location=outside position=bottom title = ' Treatment:';*/

    scatter x=TIME y=censored / name='CENS' group=STRATUMNUM markerattrs=(size=12);
    keylegend 'CENS' / location=inside position=bottom title = 'Censored:' across=2;

    step x=z y=surv  / name='MEDS' group=surv ;

    keylegend 'MEDS' / location=inside position= topright title = "Median OS (95% CI):" ACROSS=1 DOWN=3; 
    
/* xaxistable TATRISK / x=time class=STRATUMNUM title='Number at Risk' location=outside colorgroup=STRATUMNUM separator;*/
/* valueattrs=(size=10 style=italic color=black) labelattrs=(weight=bold size=10 color=purple);*/

	format STRATUMNUM trt.  surv survm. ; 

    yaxis min=0 max=1.1 offsetmax=0 offsetmin=0 label="Overall Survival Probability" labelattrs=(size=10);
    xaxis values=(0 to &max_time. by 6) valueattrs=(size=10) label="Survival Time (months)" labelattrs=(size=10);
run;

ods rtf close;
ods graphics off;
ods listing close;


/*proc sgplot data = final;*/
/* step x=z y=surv  / name='MEDS' group=surv ;*/
/* run;*/