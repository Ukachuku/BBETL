options
ls=120 ps=60
yearcutoff=1920
nocenter
mprint macrogen symbolgen
source source2
NOXWAIT noxsync
;

%let drive=c;
%let level1=\consulting\boot\mdriveboot\;
%let level2=boot;
%let dsb_&level2  =&drive.:\dsb&level1\&level2;
%let sas_&level2  =&drive.:\dsb&level1\&level2\sas;
%let log_&level2  =&drive.:\dsb&level1\&level2\log;
%let out_&level2  =&drive.:\dsb&level1&level2\out;

libname data81 "&drive.:\dsb&level1&level2\data\sas81";

%LET PROGNAME=BOOTDIM;
%LET PV=P0V005;
%LET PVS=P0V006;

%LET PROGNAMEIN1=BOOTSPLIT;
%LET PVIN1=P0V004;
%LET PVin=p0v004;

%GLOBAL
PROGNAME PV
PVS
;




proc sort force data=data81.boot319792s_&PVIN1 OUT=BOOTDIM0;
by obs nupc;
run;

DATA BOOTDIM1;
SET BOOTDIM0;
BY OBS NUPC;

ATTRIB
DIM1_COLOR_DESC      FORMAT=$10.
DIM1_COLOR      FORMAT=$15.
DIM1_COLOR_POS  LABEL="ORIG DIM"
DIM2_SIZE_DESC       FORMAT=$10.
DIM2_SIZE       FORMAT=$15.
DIM2_SIZE_POS  LABEL="ORIG DIM"
DIM3_MISC_DESC1                    FORMAT=$10.
DIM3_MISC1            FORMAT=$10.
DIM3_MISC_POS1   LABEL="ORIG DIM"
DIM3_MISC_DESC2                    FORMAT=$10.
DIM3_MISC2            FORMAT=$10.
DIM3_MISC_POS2   LABEL="ORIG DIM"
DIM3_MISC_DESC3                    FORMAT=$10.
DIM3_MISC3            FORMAT=$10.
DIM3_MISC_POS3   LABEL="ORIG DIM"
;

ARRAY DIMDESC (DIMDESC_) $ DIM1_DESCRIPTION DIM2_DESCRIPTION DIM3_DESCRIPTION;
ARRAY DIMVALU (DIMVALU_) $ DIM1-DIM3;
ARRAY MISCD   (MISCD_)   $ DIM3_MISC_DESC1-DIM3_MISC_DESC3;
ARRAY MISCV   (MISCV_)   $ DIM3_MISC1-DIM3_MISC3;
ARRAY MISCP   (MISCP_)   DIM3_MISC_POS1-DIM3_MISC_POS3;

NMISC=0;
DO I=1 TO 3;
  DIMDESC_=I;
  DIMVALU_=I;
  SELECT(UPCASE(DIMDESC));
    WHEN ("COLOR","#COLLOR","#COLOR","#-COLLOR","#-COLOR") DO;
DIM1_COLOR_POS=I;
      DIM1_COLOR_DESC=DIMDESC;
      DIM1_COLOR=DIMVALU;
      END;
    WHEN ("SIZE","SIXE","SISE") DO;
DIM2_SIZE_POS=I;
      DIM2_SIZE_DESC =DIMDESC;
      DIM2_SIZE =DIMVALU;
      END;
    OTHERWISE DO;
      NMISC=NMISC+1;
      MISCP_=NMISC;
      MISCP=I;
      MISCD_=NMISC;
      MISCD=DIMDESC;
      MISCV_=NMISC;
      MISCV=DIMVALU;
      END;
    END;
  END;
DROP
DIMDESC_ DIMVALU_ MISCD_ MISCV_ MISCP_
I
;
RUN;

PROC FREQ DATA=BOOTDIM1;
TABLES
DIM1_COLOR_DESC DIM1_COLOR_POS
DIM2_SIZE_DESC  DIM2_SIZE_POS
DIM3_MISC_DESC1 DIM3_MISC_POS1
DIM3_MISC_DESC2 DIM3_MISC_POS2
DIM3_MISC_DESC3 DIM3_MISC_POS3
NMISC
/MISSING LIST;
RUN;

%macro boot319792(pvs);
proc sort force data=BOOTDIM1 OUT=DATA81.boot319792s_&PVS;
by obs nupc;
run;
%mend  boot319792     ;
*%boot319792(p0v006);

/*
dim1_description
dim1
dim2_description
dim2
dim3_description
dim3

proc sort force data=boot299276s&PV out=data81.boot319792s_&PV;
by obs nupc;
run;
PROC FREQ DATA=data81.boot319792s_&PV;
TABLES
NUPC UPCMSTRSOURCE
NUPC*UPCMSTRSOURCE
upc_type activation_date in_house_upc_first_part_length
upc_type*activation_date*in_house_upc_first_part_length
nupc*upc_type

/MISSING LIST;
RUN;


    */

