libname mylib 'E:\01_SAS _pharm\05_training';
data adsl;
set mylib.adsl;
run;
***delete missing in aedecod aebodsys, create aesev need to set length;
data ae;
set mylib.adae;
length aesev $ 100;
if aetoxgr in (1,2,3);
if aetoxgr=1 then aesev='MILD';
if aetoxgr=2 then aesev='MODERATE';
if aetoxgr=3 then aesev='SERVERE';
if cmiss(aebodsys) then delete;
run;

%macro ae(adsl=, ae=, subvar=);
data adsl;
set &adsl;
if &subvar='Y';
run;

data ae;
set &ae;
if &subvar='Y';
run;

***assign adsl trtp to ae;
data adae;
merge ae(in=inadae) adsl;
by subjid;
if inadae;
run;

***assign overall rows to adsl and adae;
data adsl;
	set adsl;
	output;
	trt01pn=3;
	output;
run;

data adae;
	set adae;
	output;
	trt01pn=3;
	output;
run;

***calculate big n from adsl;

proc sql;
select count(distinct subjid) into :n1 - :n3 from adsl
group by trt01pn;
quit;


proc sql;
create table any as 
select trt01pn, count(distinct usubjid) as n, 'AAAny' as aebodsys, 'AAAny' as aedecod, 1 as ind from adae
group by trt01pn;
quit;
***soc;
*** ind trtpn n aebodsys aedecod as any aesev as any
*** ind trtpn n aebodsys aedecod as any aesev
*** by trtpn aebodsys
*** by aesev trtpn aebodsys;
proc sql;
create table soc as 
select trt01pn, AEBODSYS, "AAAny" as aedecod, count(distinct usubjid) as n, 2 as ind from adae
group by trt01pn, AEBODSYS;
quit;


***pt;
*** ind trtpn n aebodsys aedecod aesev as any
*** ind trtpn n aebodsys aedecod aesev
*** by trtpn aebodsys aedecod
*** by aesev trtpn aebodsys aedecod;
proc sql;
create table pt as 
select trt01pn, AEBODSYS, aedecod, count(distinct usubjid) as n, 3 as ind from adae
group by trt01pn, AEBODSYS, aedecod;
quit;



***whole;
***create new dataset, use length before merge, length aebodsys aedecod aesev;
data whole;
length aebodsys aedecod $ 100;
set any soc pt;
run;

***sort by alphabet;
proc sort data=whole;
by aebodsys aedecod;
run;

***sort by simmilar variable but add ind to classify different aesev in each levl;
proc transpose data=whole out=tran prefix=col;
id trt01pn;
by aebodsys aedecod ind;
var n;
run;

proc sort data=tran;
by aebodsys aedecod;
run;

*** add rank variable;
data tran;
set tran;
retain freq1;
by aebodsys aedecod;
if ind=1 then freq1=999;
else if first.aebodsys then freq1=col3;
run;

proc sort data=tran;
by descending freq1 aebodsys descending col3 aedecod;
run;

***create new variable will lead to similar results 0 or missing/whole0;
data final;
set tran;
length description $ 100;
if col1 not in (0,.) then per1= put(col1,3.)||" ("||put(col1/&n1*100,5.1)||"%)";
else per1=0;
if col2 not in (0,.) then per2= put(col2,3.)||" ("||put(col2/&n2*100,5.1)||"%)";
else per2=0;
if col3 not in (0,.) then per3= put(col3,3.)||" ("||put(col3/&n3*100,5.1)||"%)";
else per3=0;
if sum(col1,col2,col3)>1;
if ind = 1 then description='Any Event';
else if ind = 2 then description=aebodsys;
else description='#w#w#w'||aedecod;
run;

proc sort data=final;
by descending freq1 aebodsys descending col3 aedecod;
run;

data final;
set final;
by descending freq1 aebodsys descending col3 aedecod;
retain flg;
if ind=2 then flg+1;
run;

%mend;

%ae(adsl=adsl, ae=ae, subvar=SAFFL);

data finalpae;
set final;
retain brk 1;
if aedecod='AAAny' and mod(flg,3)=0 then brk+1;
run;

ods path(prepend) work.templat(update);
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


footnote;
options nodate nonumber missing = ' ' orientation=landscape;
ods escapechar='#'; 
ods rtf style=journal file='E:\01_SAS _pharm\04_output\my_ae.rtf';
proc report 
 data=finalpae
 nowindows 
 split = "|"
 headline
 headskip
 spacing=1
 missing; 
 columns brk flg description per1 per2 per3; 
 define brk /order order = internal noprint;
 define flg /order order = internal noprint; 
 define description /display style(header)=[just=left] 
 "Body System|#{nbspace 3} Preferred Term"; 
 define per1 /display "ABC-1234 5 mg+ATEZOLIZUMAB|(N=&n1)" center ; 
 define per2 /display "ABC-1234 5 mg+IPILIMUMAB|(N=&n2)" center; 
 define per3 /display "Overall|(N=&n3)" center; 
 compute after flg; 
 line '#{newline}'; 
 endcomp; 
 break after brk/page;
 compute after brk;
  		line @1 130*'_';
		line @1 "Notes: the program is based on adsl";
		line @1 "       t_cmh.sas /&sysdate &systime SAS Version: &sysver";
    endcomp; 
 title1 j=l 'Company/Trial Name'
 j=r "Page #{thispage} of #{lastpage}"; 
 title2 j=c 'Table 5.4'; 
 title3 j=c 'Adverse Events'; 
 title4 j=c "By Body System, Preferred Term, and Greatest Severity"
 j=c "Safety Population";
run; 
ods rtf close;
