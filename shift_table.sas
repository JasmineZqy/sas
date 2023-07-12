data ADSL; 
length USUBJID $ 3; 
label USUBJID = "Unique Subject Identifier" 
 TRTPN = "Planned Treatment (N)"; 
input USUBJID $ TRTPN @@; 
datalines; 
101 1 102 0 103 0 104 1 105 0 106 0 107 1 108 1 109 1 110 1 
; 
run; 
**** INPUT SAMPLE LABORATORY DATA AS SDTM LB DATA;
data LB; 
label USUBJID = "Unique Subject Identifier" 
 VISITNUM = "Visit Number" 
 LBCAT = "Category for Lab Test" 
 LBTEST = "Laboratory Test" 
 LBSTRESU = "Standard Units" 
 LBSTRESN = "Numeric Result/Finding in Standard Units" 
 LBSTNRLO = "Reference Range Lower Limit-Std Units" 
 LBSTNRHI = "Reference Range Upper Limit-Std Units" 
 LBNRIND = "Reference Range Indicator"; 
input USUBJID $ 1-3 VISITNUM 6 LBCAT $ 9-18 LBTEST $ 20-29 
 LBSTRESU $ 32-35 LBSTRESN 38-41 LBSTNRLO 45-48 
 LBSTNRHI 52-55 LBNRIND $ 59; 
datalines;
101  0  HEMATOLOGY HEMATOCRIT  %     31     35     49     L
101  1  HEMATOLOGY HEMATOCRIT  %     39     35     49     N 
101  2  HEMATOLOGY HEMATOCRIT  %     44     35     49     N 
101  0  HEMATOLOGY HEMOGLOBIN  g/dL  11.5   11.7   15.9   L 
101  1  HEMATOLOGY HEMOGLOBIN  g/dL  13.2   11.7   15.9   N 
101  2  HEMATOLOGY HEMOGLOBIN  g/dL  14.3   11.7   15.9   N 
102  0  HEMATOLOGY HEMATOCRIT  %     39     39     52     N 
102  1  HEMATOLOGY HEMATOCRIT  %     39     39     52     N 
102  2  HEMATOLOGY HEMATOCRIT  %     44     39     52     N 
102  0  HEMATOLOGY HEMOGLOBIN  g/dL  11.5   12.7   17.2   L 
102  1  HEMATOLOGY HEMOGLOBIN  g/dL  13.2   12.7   17.2   N 
102  2  HEMATOLOGY HEMOGLOBIN  g/dL  18.3   12.7   17.2   H 
103  0  HEMATOLOGY HEMATOCRIT  %     50     35     49     H 
103  1  HEMATOLOGY HEMATOCRIT  %     39     35     49     N 
103  2  HEMATOLOGY HEMATOCRIT  %     55     35     49     H 
103  0  HEMATOLOGY HEMOGLOBIN  g/dL  12.5   11.7   15.9   N 
103  1  HEMATOLOGY HEMOGLOBIN  g/dL  12.2   11.7   15.9   N 
103  2  HEMATOLOGY HEMOGLOBIN  g/dL  14.3   11.7   15.9   N 
104  0  HEMATOLOGY HEMATOCRIT  %     55     39     52     H 
104  1  HEMATOLOGY HEMATOCRIT  %     45     39     52     N 
104  2  HEMATOLOGY HEMATOCRIT  %     44     39     52     N 
104  0  HEMATOLOGY HEMOGLOBIN  g/dL  13.0   12.7   17.2   N 
104  1  HEMATOLOGY HEMOGLOBIN  g/dL  13.3   12.7   17.2   N 
104  2  HEMATOLOGY HEMOGLOBIN  g/dL  12.8   12.7   17.2   N 
105  0  HEMATOLOGY HEMATOCRIT  %     36     35     49     N 
105  1  HEMATOLOGY HEMATOCRIT  %     39     35     49     N 
105  2  HEMATOLOGY HEMATOCRIT  %     39     35     49     N 
105  0  HEMATOLOGY HEMOGLOBIN  g/dL  13.1   11.7   15.9   N 
105  1  HEMATOLOGY HEMOGLOBIN  g/dL  14.0   11.7   15.9   N 
105  2  HEMATOLOGY HEMOGLOBIN  g/dL  14.0   11.7   15.9   N 
106  0  HEMATOLOGY HEMATOCRIT  %     53     39     52     H 
106  1  HEMATOLOGY HEMATOCRIT  %     50     39     52     N 
106  2  HEMATOLOGY HEMATOCRIT  %     53     39     52     H 
106  0  HEMATOLOGY HEMOGLOBIN  g/dL  17.0   12.7   17.2   N 
106  1  HEMATOLOGY HEMOGLOBIN  g/dL  12.3   12.7   17.2   L 
106  2  HEMATOLOGY HEMOGLOBIN  g/dL  12.9   12.7   17.2   N 
107  0  HEMATOLOGY HEMATOCRIT  %     55     39     52     H 
107  1  HEMATOLOGY HEMATOCRIT  %     56     39     52     H 
107  2  HEMATOLOGY HEMATOCRIT  %     57     39     52     H 
107  0  HEMATOLOGY HEMOGLOBIN  g/dL  18.0   12.7   17.2   N 
107  1  HEMATOLOGY HEMOGLOBIN  g/dL  18.3   12.7   17.2   H 
107  2  HEMATOLOGY HEMOGLOBIN  g/dL  19.2   12.7   17.2   H 
108  0  HEMATOLOGY HEMATOCRIT  %     40     39     52     N 
108  1  HEMATOLOGY HEMATOCRIT  %     53     39     52     H 
108  2  HEMATOLOGY HEMATOCRIT  %     54     39     52     H 
108  0  HEMATOLOGY HEMOGLOBIN  g/dL  15.0   12.7   17.2   N 
108  1  HEMATOLOGY HEMOGLOBIN  g/dL  18.0   12.7   17.2   H 
108  2  HEMATOLOGY HEMOGLOBIN  g/dL  19.1   12.7   17.2   H 
109  0  HEMATOLOGY HEMATOCRIT  %     39     39     52     N 
109  1  HEMATOLOGY HEMATOCRIT  %     53     39     52     H 
109  2  HEMATOLOGY HEMATOCRIT  %     57     39     52     H 
109  0  HEMATOLOGY HEMOGLOBIN  g/dL  13.0   12.7   17.2   N
109  1  HEMATOLOGY HEMOGLOBIN  g/dL  17.3   12.7   17.2   H 
109  2  HEMATOLOGY HEMOGLOBIN  g/dL  17.3   12.7   17.2   H 
110  0  HEMATOLOGY HEMATOCRIT  %     50     39     52     N 
110  1  HEMATOLOGY HEMATOCRIT  %     51     39     52     N 
110  2  HEMATOLOGY HEMATOCRIT  %     57     39     52     H 
110  0  HEMATOLOGY HEMOGLOBIN  g/dL  13.0   12.7   17.2   N 
110  1  HEMATOLOGY HEMOGLOBIN  g/dL  18.0   12.7   17.2   H 
110  2  HEMATOLOGY HEMOGLOBIN  g/dL  19.0   12.7   17.2   H
; 
run;
; 
run; 


proc sort 
   data = lb; 
      by usubjid lbcat lbtest lbstresu visitnum; 
run; 

proc sort 
    data = adsl; 
       by usubjid; 
run; 

**** MERGE TREATMENT INFORMATION WITH LAB DATA.; 
data lb; 
 merge adsl(in = inadsl) lb(in = inlb); 
    by usubjid; 
    if inlb and not inadsl then 
    put "WARN" "ING: Missing treatment assignment for subject "
    usubjid=; 
    if inadsl and inlb; 
run;
*** carry forward baseline flg;
proc sort data=lb;
	by usubjid lbcat lbtest lbstresu visitnum;
run;

data lb;
   set lb;
   by usubjid lbcat lbtest lbstresu visitnum;
   retain base;
   if first.lbtest then base = lbnrind;
   if visitnum > 0;
   shift=catx(' ', base, 'to', lbnrind);
run;

proc sort data=lb;
by trtpn visitnum lbcat lbtest shift;
run;

proc sql;
    create table freq as
	select distinct trtpn, visitnum, lbcat, lbtest, shift, count(distinct usubjid)as n,base,lbnrind from lb
	group by trtpn, visitnum, lbcat, lbtest, shift;
run;

***informat;
proc format;
invalue shift
'L to L'=1
'L to N'=2
'L to H'=3
'N to L'=4
'N to N'=5
'N to H'=6
'H to L'=7
'H to N'=8
'H to H'=9
;
run;

data freq;
	set freq;
	cat=input(shift,shift.);
run;

data freq1;
	set freq;
	if lbtest='HEMATOCRIT';
run;

data freq2;
	set freq;
	if lbtest='HEMOGLOBIN';
run;
***dummy;
data dummy;
	do visitnum=1 to 2;
		do trtpn=0 to 1;
			do cat=1 to 9;
			output;
			end;
		end;
	end;
run;

***merge dummy and freq table;
proc sort data=dummy;
	by visitnum trtpn cat;
run;

proc sort data=freq1;
	by visitnum trtpn cat;
run;

proc sort data=freq2;
	by visitnum trtpn cat;
run;

proc sql;
	select sum(n) into :n1 -:n4 from freq1
	group by visitnum, trtpn;
quit;

proc sql;
	select sum(n) into :n5 -:n8 from freq2
	group by visitnum, trtpn;
quit;

data merg1;
	merge dummy(in=indummy) freq1;
	by visitnum trtpn cat;
	length per $100;
	if indummy;
	if n=. then per='  0(  0%)';
    else if visitnum=1 and trtpn=0 then per=put(n,3.)||'('||put(n/&n1*100,3.)||'%)';
    else if visitnum=1 and trtpn=1 then per=put(n,3.)||'('||put(n/&n2*100,3.)||'%)';
	else if visitnum=2 and trtpn=0 then per=put(n,3.)||'('||put(n/&n3*100,3.)||'%)';
	else if visitnum=2 and trtpn=1 then per=put(n,3.)||'('||put(n/&n4*100,3.)||'%)';

run;

data merg2;
	merge dummy(in=indummy) freq2;
	by visitnum trtpn cat;
	length per $100;
	if indummy;
	if n=. then per='  0(  0%)';
    else if visitnum=1 and trtpn=0 then per=put(n,3.)||'('||put(n/&n5*100,3.)||'%)';
    else if visitnum=1 and trtpn=1 then per=put(n,3.)||'('||put(n/&n6*100,3.)||'%)';
	else if visitnum=2 and trtpn=0 then per=put(n,3.)||'('||put(n/&n7*100,3.)||'%)';
	else if visitnum=2 and trtpn=1 then per=put(n,3.)||'('||put(n/&n8*100,3.)||'%)';
run;
data merg1;
set merg1;
if cat=1 then do;base='L';lbnrind='L';end;
if cat=2 then do;base='L';lbnrind='N';end;
if cat=3 then do;base='L';lbnrind='H';end;
if cat=4 then do;base='N';lbnrind='L';end;
if cat=5 then do;base='N';lbnrind='N';end;
if cat=6 then do;base='N';lbnrind='H';end;
if cat=7 then do;base='H';lbnrind='L';end;
if cat=8 then do;base='H';lbnrind='N';end;
if cat=9 then do;base='H';lbnrind='H';end;
lbcat='HEMATOLOGY';
lbtest='HEMATOCRIT';
run;

proc sort data=merg1;
by visitnum trtpn lbcat lbtest lbnrind;
run;

proc transpose data=merg1 out=data1;
by visitnum trtpn lbcat lbtest lbnrind;
id base;
var per;
run;

data merg2;
set merg2;
if cat=1 then do;base='L';lbnrind='L';end;
if cat=2 then do;base='L';lbnrind='N';end;
if cat=3 then do;base='L';lbnrind='H';end;
if cat=4 then do;base='N';lbnrind='L';end;
if cat=5 then do;base='N';lbnrind='N';end;
if cat=6 then do;base='N';lbnrind='H';end;
if cat=7 then do;base='H';lbnrind='L';end;
if cat=8 then do;base='H';lbnrind='N';end;
if cat=9 then do;base='H';lbnrind='H';end;
lbcat='HEMATOLOGY';
lbtest='HEMATOCRIT';
run;


data merg1label;
set merg1;
if trtpn=0 and base='H' then posi=1;
if trtpn=0 and base='N' then posi=2;
if trtpn=0 and base='L' then posi=3;
if trtpn=1 and base='H' then posi=4;
if trtpn=1 and base='N' then posi=5;
if trtpn=1 and base='L' then posi=6;

run;

proc sort data=merg1label;
	by lbcat lbtest visitnum lbnrind;
run;

proc transpose data=merg1label out=merg1tran;
	by lbcat lbtest visitnum lbnrind;
	id posi;
	var per;
run;

data final1;
set merg1tran;
drop _name_ ;
if lbnrind='L' then po=1;
else if lbnrind='N' then po=2;
else po=3;
run;

proc sort data=final1 out=final1(drop= po);
	by visitnum po;
run;

data merg2label;
set merg2;
if trtpn=0 and base='H' then posi=1;
if trtpn=0 and base='N' then posi=2;
if trtpn=0 and base='L' then posi=3;
if trtpn=1 and base='H' then posi=4;
if trtpn=1 and base='N' then posi=5;
if trtpn=1 and base='L' then posi=6;

run;

proc sort data=merg2label;
	by lbcat lbtest visitnum lbnrind;
run;

proc transpose data=merg2label out=merg2tran;
	by lbcat lbtest visitnum lbnrind;
	id posi;
	var per;
run;

data final2;
set merg2tran;
drop _name_ ;
if lbnrind='L' then po=1;
else if lbnrind='N' then po=2;
else po=3;
run;

proc sort data=final2 out=final2(drop= po);
	by visitnum po;
run;

