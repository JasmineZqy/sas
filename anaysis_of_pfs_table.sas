title;
footnote;
data ADTTE; 
label TRTA = "Actual Treatment" 
 AVAL = "Analysis Value"
 CNSR = "Censor"; 
input TRTA $ AVAL CNSR @@; 
datalines; 
A 52 0 A 825 1 C 693 1 C 981 1 
B 279 0 B 826 1 B 531 1 B 15 1 
C 1057 1 C 793 1 B 1048 1 A 925 1 
C 470 1 A 251 0 C 830 1 B 668 0 
B 350 1 B 746 1 A 122 0 B 825 1 
A 163 0 C 735 1 B 699 1 B 771 0 
C 889 1 C 932 1 C 773 0 C 767 1 
A 155 1 A 708 1 A 547 1 A 462 0 
B 114 0 B 704 1 C 1044 1 A 702 0 
A 816 1 A 100 0 C 953 1 C 632 1 
C 959 1 C 675 1 C 960 0 A 51 1 
B 33 0 B 645 1 A 56 0 A 980 0 
C 150 1 A 638 1 B 905 1 B 341 0 
B 686 1 B 638 1 A 872 0 C 1347 1 
A 659 1 A 133 0 C 360 1 A 907 0 
C 70 1 A 592 1 B 112 1 B 882 0 
A 1007 1 C 594 1 C 7 1 B 361 1 
B 964 1 C 582 1 B 1024 0 A 540 0 
C 962 1 B 282 1 C 873 1 C 1294 1 
B 961 1 C 521 1 A 268 0 A 657 1 
C 1000 1 B 9 0 A 678 1 C 989 0 
A 910 1 C 1107 1 C 1071 0 A 971 1 
C 89 1 A 1111 1 C 701 1 B 364 0 
B 442 0 B 92 0 B 1079 1 A 93 1 
B 532 0 A 1062 1 A 903 1 C 792 1 
C 136 1 C 154 1 C 845 1 B 52 1 
A 839 1 B 1076 1 A 834 0 A 589 1 
A 815 1 A 1037 1 B 832 1 C 1120 1 
C 803 1 C 16 0 A 630 1 B 546 1 
A 28 0 A 1004 1 B 1020 1 A 75 1 
C 1299 1 B 79 1 C 170 1 B 945 1 
B 1056 1 B 947 1 A 1015 1 A 190 0 
B 1026 1 C 128 0 B 940 1 C 1270 1 
A 1022 0 A 915 1 A 427 0 A 177 0 
C 127 1 B 745 0 C 834 1 B 752 1 
A 1209 1 C 154 1 B 723 1 C 1244 1 
C 5 1 A 833 1 A 705 1 B 49 1 
B 954 1 B 60 0 C 705 1 A 528 1 
A 952 1 C 776 1 B 680 1 C 88 1 
C 23 1 B 776 1 A 667 1 C 155 1 
B 946 1 A 752 1 C 1076 1 A 380 0 
B 945 1 C 722 1 A 630 1 B 61 0 
C 931 1 B 2 1 B 583 1 A 282 0 
A 103 0 C 1036 1 C 599 1 C 17 1 
C 910 1 A 760 1 B 563 1 B 347 0 
B 907 1 B 896 1 A 544 1 A 404 0 
A 8 0 A 895 1 C 525 1 C 740 1 
C 11 1 C 446 0 C 522 1 C 254 1
A 868 1 B 774 1 A 500 1 A 27 1 
B 842 1 A 268 0 B 505 1 B 505 0 
; 
run; 
proc lifetest 
 data=adtte; 
 time aval * cnsr(1); 
 strata trta; 
run; 
****calculate number of patients in censored and event group;
proc sql;
	create table censor as
	select trta, count(cnsr) as cn from adtte
	where cnsr=1
	group by trta;
	create table event as
	select trta, count(cnsr) as en from adtte
	where cnsr=0
	group by trta;
quit;
***merge together;
data table1;
	merge censor event;
	by trta;
run;

***transpose make trta as column;
proc transpose data=table1;
	id trta;
	var cn en;
quit;
***estimated survival quartile and 95%CIs;
ods trace on;
ods output quartiles=quartile;
proc lifetest 
 data=adtte; 
 time aval * cnsr(1); 
 strata trta; 
run; 
ods trace off;
ods output close;

proc sort data=quartile;
	by trta;
run;


data quartile;
	set quartile;
	estimatec=put(estimate, 8.2);
	lowerlimitc=put(lowerlimit, 8.2);
	upperlimitc=put(upperlimit, 8.2);
	array change{3} estimatec lowerlimitc upperlimitc;
        do i=1 to 3;
            if change[i]=. then change[i]='NA';
        end;
	CI=strip(estimatec)||' ('||strip(lowerlimitc)||' ,'||strip(upperlimitc)||')';
run;

proc sort data=quartile;
	by percent;
run;

proc transpose data=quartile out=table2;
	id trta;
	var CI;
	by percent;
quit;