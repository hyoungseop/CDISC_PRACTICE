
**DM 데이터 IMPORT;
data DM00(index = (USUBJID) keep =USUBJID RFSTDAT); set SDTM.SDTM_DM_SAMPLE;

format RFSTDAT e8601da.;

RFSTDAT = input(RFSTDTC,e8601da.);

run;


data SV00; set CRF.CRF_SV_SAMPLE; 
attrib
USUBJID format = $30.;

*1. DOMAIN 생성;
DOMAIN = 'SV';

*2. USUBJID 생성;
**STUDYID-SITEID-SUBJID;
if length(strip(SUBJID)) = 1 then USUBJID = catt(STUDYID,"-",SITEID,"-00",SUBJID);
else if length(strip(SUBJID)) = 2 then USUBJID = catt(STUDYID,"-",SITEID,"-0",SUBJID);
else USUBJID = catt(STUDYID,"-",SITEID,"-",SUBJID);

run;

data SV01;

set SV00; 
set DM00 key = USUBJID/unique;

*3. DM 데이터 결합;
if _iorc_ = %sysrc(_dsenom) then do;
USUBJID = ''; RFSTDAT = .;
end;

run;

*4. VISIT 값 확인;
proc freq data = SV01; table VISIT/nocol norow nopercent nocum; run;
/*
BASELINE	17
WEEK 12	17
WEEK 16	15
WEEK 20	15
WEEK 4	17
WEEK 8	17
이상없음
*/

data SV02; set SV01;

format SVSTDTC $20. SVENDTC $20.;

*5. VISITDY 계산;
VISITDY = intck('day',SVSTDAT,RFSTDAT,'c') + 1;

*6. SVSTDTC, SVENDTC 생성;
SVSTDTC = put(SVSTDAT,e8601da.);
SVENDTC = put(SVENDAT,e8601da.);

*7. SVSTDY 계산;
*SVSTDAT - RFSTDAT;
SVSTDY = intck('day',SVSTDAT,RFSTDAT,'c') + 1;

*8. SVENDY 계산;
*SVENDAT - RFSTDAY;
SVENDY = intck('day',SVENDAT,RFSTDAT,'c') + 1;
run;

data SDTM.SDTM_SV_SAMPLE(keep = STUDYID DOMAIN USUBJID VISITNUM VISIT VISITDY SVSTDTC SVENDTC SVSTDY SVENDY);
retain STUDYID DOMAIN USUBJID VISITNUM VISIT VISITDY SVSTDTC SVENDTC SVSTDY SVENDY;
set SV02;
run;
