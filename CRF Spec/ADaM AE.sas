

* Initial Data Processing with Error Handling */

data adam_ae;

set ae02;


/* Check for missing date values */

if missing(AESTDT) or missing(AEENDT) or missing(RFSTDTC) then do;

put "ERROR: Missing date values for AE data.";

return;

end;


/* Date conversion */

AESTDY = (AESTDT - RFSTDTC) + 1;

AEENDY = (AEENDT - RFSTDTC) + 1;


/* Recode variables */

AESER = ifc(upcase(AESER) = 'Y', 'Y', 'N');

select (upcase(AESEV));

when ('MILD') AESEV = 1;

when ('MODERATE') AESEV = 2;

when ('SEVERE') AESEV = 3;

otherwise AESEV = .; /* Handle unknown values */

end;

AEOUT = ifc(upcase(AEOUT) = 'DEATH', 'Y', 'N');

AELAST = ifn(last.USUBJID, 'Y', 'N');

run;


/* Sequence Generation */

retain AESEQ 0;

if first.USUBJID then AESEQ = 1;

else AESEQ + 1;


/* Merge with SE dataset */

proc sort data=adam_ae; by usubjid; run;

proc sort data=se; by usubjid; run;


data adam_ae;

merge adam_ae (in=a) se (in=b keep=usubjid epoch);

by usubjid;


if a; /* Only keep records from adam_ae */


/* If no matching record from 'se', handle missing EPOCH */

if not b then AESEQ = .;

run;


/* Export ADaM Dataset */

%let output_dir = C:\path\to\output;

%if %sysfunc(fileexist(&output_dir)) = 0 %then %do;

%put ERROR: Directory &output_dir does not exist!;

return;

%end;


libname adam xport "&output_dir\adam_ae.xpt";

proc copy in=work out=adam;

select adam_ae;

run;



?? ADaM Dataset Creation Project – Clinical Trial Programming Author: Prasanthi Kata Role: Statistical Programmer Therapeutic Area: General Clinical Study (Part A) Standards: CDISC (SDTM + ADaM compliant) Tools Used: Base SAS 9.4

?? Project Overview This project focuses on the transformation of raw clinical trial data (CDM) into ADaM-ready datasets, especially focusing on the Demographics (DM) domain as part of end-to-end clinical programming. The objective is to clean, merge, and derive subject-level data variables used in both SDTM and ADaM datasets.

?? Objective To derive and prepare a clean and analysis-ready dataset (ADaM-style) from raw clinical data, mapping key demographic and treatment-related variables using SAS, while ensuring adherence to CDISC standards.

?? Input Raw Datasets (from CDM folder) DEATH.xlsx: Subject-level death info

DM.xlsx: Demographics

DS.xlsx: Disposition

EX.xlsx: Exposure

IE.xlsx: Inclusion/Exclusion

SPCPKB1.xlsx: Dosing/PK data

?? Key Programming Steps

Library Setup Defined CDM, SDTM, and ADaM libraries using %LET and libname.

Macro-based Import Used macros to efficiently import all CDM Excel files using %CDM() and %SDTM().

Initial DM Creation (DM1) Created base demographics dataset with key identifiers:

STUDYID, DOMAIN, USUBJID, SUBJID

Reference Start Date (RFSTDTC) Derived using first dosing datetime (IPFD1DAT, IPFD1TIM) from SPCPKB1.

Exposure End Date (RFENDTC) Retrieved from the last exposure (EXENDAT if available, otherwise EXSTDAT).

Merged All Inputs Combined DM, SPCPKB1, EX, DS, DEATH, and IE to build subject-level timeline.

Derived Variables RFSTDTC, RFENDTC, RFXSTDTC, RFXENDTC, RFPENDTC

DTHDTC, DTHFL, BRTHDTC, AGE, AGEU

SEX, RACE, ETHNIC, ARMCD, ACTARMCD, COUNTRY

Visit-Level & Country Mapping Visit datetime (DMDTC) and country codes derived from CENTRE.

Final Formatting and Labeling Added labels and kept only essential SDTM-compliant variables in DM6.

Output Dataset Final dataset stored as: ? SDTM.DM

?? Outputs DM6: Final cleaned subject-level dataset with derived variables. SDTM.DM: SDTM-compliant DM dataset ready for submission/QC.

?? Key Skills Demonstrated Merging multiple clinical datasets Deriving variables based on CDISC rules Handling date/time formats (RFSTDTC, RFXENDTC) Population flag handling (DTHFL, IEYN) Labeling and SDTM variable naming conventions PROC COMPARE for QC Check.




Raw file:
/* Initial Data Processing with Error Handling */
data adam_ae;
    set ae02;

    /* Check for missing date values */
    if missing(AESTDT) or missing(AEENDT) or missing(RFSTDTC) then do;
        put "ERROR: Missing date values for AE data.";
        return;
    end;

    /* Date conversion */
    AESTDY = (AESTDT - RFSTDTC) + 1;
    AEENDY = (AEENDT - RFSTDTC) + 1;

    /* Recode variables */
    AESER = ifc(upcase(AESER) = 'Y', 'Y', 'N');
    select (upcase(AESEV));
        when ('MILD') AESEV = 1;
        when ('MODERATE') AESEV = 2;
        when ('SEVERE') AESEV = 3;
        otherwise AESEV = .; /* Handle unknown values */
    end;
    AEOUT = ifc(upcase(AEOUT) = 'DEATH', 'Y', 'N');
    AELAST = ifn(last.USUBJID, 'Y', 'N');
run;

/* Sequence Generation */
retain AESEQ 0;
if first.USUBJID then AESEQ = 1;
else AESEQ + 1;

/* Merge with SE dataset */
proc sort data=adam_ae; by usubjid; run;
proc sort data=se; by usubjid; run;

data adam_ae;
    merge adam_ae (in=a) se (in=b keep=usubjid epoch);
    by usubjid;
    
    if a; /* Only keep records from adam_ae */

    /* If no matching record from 'se', handle missing EPOCH */
    if not b then AESEQ = .;
run;

/* Export ADaM Dataset */
%let output_dir = C:\path\to\output;
%if %sysfunc(fileexist(&output_dir)) = 0 %then %do;
    %put ERROR: Directory &output_dir does not exist!;
    return;
%end;

libname adam xport "&output_dir\adam_ae.xpt";
proc copy in=work out=adam;
    select adam_ae;
run;
