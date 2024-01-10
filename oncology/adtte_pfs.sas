***** Clean up the WORK directory;
proc datasets lib=work nolist kill memtype=data;
run;
quit;

%let program=qc_adtte;

%include "D:\projects\env\setup.sas";

libname proj "D:\SAS\materials\project\project11_adtte";

data adsl;
	set proj.adsl;
	if ittfl='Y';

	keep usubjid randdt dthdt TRTSDT;
run;

*** baseline tumor assessment flag ***;
data tmblfl; 
	set proj.tu;
	if not missing(tutest) and tublfl='Y';
	tmblfl='Y';

	keep usubjid tmblfl; 
run;

proc sort data=tmblfl nodupkey; by usubjid; run;

*** post-baseline tumor assessment flag ***;
data tmpblfl;
	set proj.rs;
	if rsstat='  ' and ^missing(rsdtc) and rsdy>0 and rsstresc in ('CR', 'PR', 'SD', 'PD', 'Non CR or Non PD');
	tmpblfl='Y';

	keep usubjid tmpblfl;
run;

proc sort data=tmpblfl nodupkey; by usubjid; run;

*** First PD date ***;
data pddt;
	merge proj.rs(in=a) adsl(keep=usubjid randdt);
	by usubjid;
	if a;
	if rsstat='  ' and rstestcd='OVRLRESP' and rsstresc='PD' and input(rsdtc, yymmdd10.)>=randdt>.;

	pddt=input(rsdtc, yymmdd10.); format pddt date9.;
	keep usubjid pddt;
run;

proc sort data=pddt; by usubjid pddt; run;

data pddt;
	set pddt;
	by usubjid pddt;
	if first.usubjid;
run;

*** LOST TO FOLLOW-UP,  WITHDRAWAL BY SUBJECT ***;
data ds;
	set proj.ds;
	if upcase(dsdecod) in ('LOST TO FOLLOW-UP' 'WITHDRAWAL BY SUBJECT');

	dsdt=input(dsstdtc, yymmdd10.); format dsdt date9.;
run;

data ds(keep=usubjid dsdecod dsdt);
	merge ds(in=a) adsl;
	by usubjid;
	if a;
	if dsdt>=randdt>.;
run;

*** Date of Last Adequate Assessment ***;
data lrsdt;
	merge proj.rs(in=a) adsl(keep=usubjid randdt);
	by usubjid;
	if a;
	if rsstat='  ' and rstestcd='OVRLRESP' and rsstresc in ('CR', 'PR', 'SD', 'PD','Non CR or Non PD') and input(rsdtc, yymmdd10.)>=randdt>.;

	lrsdt=input(rsdtc, yymmdd10.); format lrsdt date9.;

	keep usubjid lrsdt;
run;

proc sort data=lrsdt; by usubjid lrsdt; run;

data lrsdt;
	set lrsdt;
	by usubjid lrsdt;
	if last.usubjid;
run;


*** Final dataset ***;
data pfs;
	length paramcd $ 8 evntdesc param $ 200;
	merge adsl(in=a) tmblfl tmpblfl pddt lrsdt ds;
	by usubjid;
	if a;

	if not missing(dthdt) or not missing(pddt) then dth_pddt=min(dthdt,pddt); format dth_pddt date9.;

	format adt date9.;
	
	paramcd='PFS1';
	param='Progression-free Survival time';
	startdt=randdt;

	* item 1: no baseline;
	if tmblfl=' ' then do;
		cnsr=1;
    	adt=randdt; 
    	evntdesc='No Baseline Tumor Assessment';
	end;

	* item 2: no post-baseline tumor assessment and no death;
	else if tmpblfl=' ' and missing(dthdt) then do;
		cnsr=1;
    	adt=randdt; 
    	evntdesc='No Post-Baseline Tumor Assessment';
    end;

	*** item 3: First PD  ***;
	*** item 4: Death ***;
	else if not missing(dth_pddt) then do;
		cnsr=0;
		adt=dth_pddt;
		if adt=pddt  then evntdesc='PD';
		if adt=dthdt then evntdesc='Death without PD';	
	end;

	*** item 5: LOST TO FOLLOW-UP ***;
	*** item 6: WITHDRAWAL BY SUBJECT ***;
	*** item 7: No documented PD with regular assessment ***;
	else if missing(dth_pddt) then do;
		cnsr=1;
	    adt=lrsdt; 
        if ^missing(dsdecod)then evntdesc=dsdecod;
        else                     evntdesc='No documented PD with regular assessment'; 
    end;

	aval=adt-startdt+(adt>=startdt);

	format startdt  adt e8601da.;

run;


data qc_adtte;
	retain usubjid paramcd param startdt adt aval cnsr evntdesc;
	set pfs;
	label paramcd='Parameter Code'
		  param='Parameter'
		  startdt='Time to Event Origin Date for Subject'
		  adt='Analysis Date'
		  aval='Analysis Value'
		  cnsr='Censor'
		  eventdesc='Event or Censoring Description';
	keep usubjid paramcd param startdt adt aval cnsr evntdesc;
run;

proc compare base=proj.adtte comp=qc_adtte listall;
run;
