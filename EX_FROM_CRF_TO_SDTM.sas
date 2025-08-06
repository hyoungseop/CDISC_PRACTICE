

data VS00; set CRF.CRF_EX_SAMPLE;
attrib
USUBJID format = $30.
;

*1. DOMAIN 생성;
DOMAIN = 'EX';

*2. USUBJID 생성;
**STUDYID-SITEID-SUBJID;
if length(strip(SUBJID)) = 1 then USUBJID = catt(STUDYID,"-",SITEID,"-00",SUBJID);
else if length(strip(SUBJID)) = 2 then USUBJID = catt(STUDYID,"-",SITEID,"-0",SUBJID);
else USUBJID = catt(STUDYID,"-",SITEID,"-",SUBJID);

*3. EXTRT(약 투여) 정제;
**해당 예시에서는 위약을 투여했다는 가정으로 정제 예정;
if EXTRT = 'STUDY DRUG' then EXTRT = 'DRUG A';

*4. 날짜 정제;
EXSTDTC = put(EXSTDAT,e8601da.);
EXENDTC = put(EXENDAT,e8601da.);

*5. EXSTDY, EXENDY 생성;
**기준일: EXSTDTC;
**첫날을 1로 표시하기 위해 +1;
EXSTDY = intck('day',EXSTDAT,EXSTDAT) + 1;
EXENDY = intck('day',EXSTDAT,EXENDAT) + 1;
run;

proc sort data = VS00; by USUBJID; run;

data VS01; set VS00;

retain EXSEQ;

by USUBJID;

*6. EXSEQ 생성;
*ID당 SEQ;
if first.USUBJID then EXSEQ = 1;
else EXSEQ = EXSEQ + 1;

run;

*EXDOSFRQ;
*QD:1일1회 / BID:1일2회 / TID:1일3회 / QID:1일4회;
*QOD:격일 / QM:월1회 / PRN:필요시 / Q12H:12시간마다;

data SDTM.SDTM_EX_SAMPLE(keep = STUDYID DOMAIN USUBJID EXSEQ EXTRT EXDOSE EXDOSU EXDOSFRM EXDOSFRQ EXROUTE EXSTDTC EXENDTC EXSTDY EXENDY); 
retain STUDYID DOMAIN USUBJID EXSEQ EXTRT EXDOSE EXDOSU EXDOSFRM EXDOSFRQ EXROUTE EXSTDTC EXENDTC EXSTDY EXENDY;
set VS01;
run;