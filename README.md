# ADaM-AE-Mapping-Oncology-SDTM-Extension
Continuation of SDTM Mapping Project – Derivation of ADaM ADAE dataset using Base SAS for a Phase I Oncology Breast Cancer Clinical Trial

1. Study Background
This project demonstrates the derivation of the ADaM ADAE (Adverse Events) dataset using mock SDTM data for a Phase I clinical trial in breast cancer. The focus is on generating analysis-ready datasets for regulatory submission using CDISC-compliant standards.

2. Objectives
Transform SDTM AE and DM domains into ADaM ADAE format using SAS.

Apply ADaM conventions including ADSL joins, date imputation, and derivations.

Ensure traceability between source (SDTM) and target (ADaM).

Generate submission-ready .xpt and .sas7bdat datasets.

3. Input Data
sdtm_ae.csv: Adverse Events (AE)

sdtm_dm.csv: Demographics (DM)

4. Specifications
ADaM_Mapping_Spec_AE.xlsx: Contains variable-level specifications including source, derivation logic, controlled terminology.

CRF_Annotated_AE.pdf: Annotated case report form for AE domain.

5. Key Variables Derived
ADaM Variable	Derivation Logic
USUBJID	From SDTM AE
TRTA, TRTP	From ADSL/EX treatment info
AESTDTC/AEENDTC	Direct from SDTM AE, with date imputations applied
AESTDY, AEENDY	Calculated using AESTDTC and RFSTDTC
AESER, AESEV, AEACN	Direct from SDTM with CT application
AELLT, AEDECOD	MedDRA terms included
AEBODSYS	System organ class, from AE

6. Derivation Program
adam_adae_derivation.sas:
Includes all data preparation, merge logic with ADSL, derivation steps, and label formatting.

7. Validation & QC
adam_adae_qc_program.sas:
Independent QC using reverse programming and PROC COMPARE.

Checks included:

Variable presence and label consistency

Sequence consistency

Date validity

Controlled terminology application

8. Output Files
adae_final.csv: Final ADAE dataset

adae_final.xpt: Transport file for submission

.sas7bdat: Available for local SAS use

9. Challenges and Resolutions
Missing Dates: Resolved with partial date handling logic and imputations.

Treatment Assignment Merging: Used consistent merge with ADSL to bring in treatment-related variables.

Controlled Terminology: Applied via IF-ELSE logic and MedDRA mock terms.

10. Summary and Learnings
Learned ADaM workflow in alignment with CDISC standards.

Understood the differences between SDTM AE and ADaM ADAE structures.

Applied SAS techniques for merging, sequencing, imputations, and data labeling.

11. Author Info
Author: Prasanthi Kata
Role: Clinical SAS Programmer (Intern)
GitHub: https://github.com/Prasanthi-sas
