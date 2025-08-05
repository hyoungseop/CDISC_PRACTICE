

data VS00; set CRF.CRF_VS_SAMPLE;
attrib
USUBJID format = $30.;

*1. DOMAIN 생성;
DOMAIN = 'VS';

*2. USUBJID 생성;
**STUDYID-SITEID-SUBJID;
if length(strip(SUBJID)) = 1 then USUBJID = catt(STUDYID,"-",SITEID,"-00",SUBJID);
else if length(strip(SUBJID)) = 2 then USUBJID = catt(STUDYID,"-",SITEID,"-0",SUBJID);
else USUBJID = catt(STUDYID,"-",SITEID,"-",SUBJID);

run;


proc sort data = VS00; by USUBJID; run;


data VS01; set VS00;
retain VSSEQ;

by USUBJID;

*3. VSSEQ 생성;
**아이디별 순서;
if first.USUBJID then VSSEQ = 1;
else VSSEQ = VSSEQ + 1;

run;

*4. VSTEST, VSTESTCD 일치 여부 확인;
proc sql noprint;
select distinct catx('---',VSTESTCD,VSTEST) into : VSTEST_CHK separated by " "
from VS01;
quit;

%put &VSTEST_CHK.;
**VSTEST: PULSE -> PULSE RATE;

data VS02; set VS01;

*5. VSTEST(PULSE) 수정;
if VSTEST = 'PULSE' then VSTEST = 'PULSE RATE';

run;

*6. VSORRES 값 확인(전부 숫자형인지, 단위 확인);
proc sql noprint;
select distinct catx('---',VSORRES,VSORRESU) into : VSORRES_CHK separated by " "
from VS02;
quit;

%put &VSORRES_CHK;
**이상없음;


data VS03; set VS02;

*7. VSDTC 변수 생성(문자형);
VSDTC = put(VSDAT,e8601da.);

VSTPT = VISIT;

run;


data SDTM.SDTM_VS_SAMPLE(keep = STUDYID DOMAIN USUBJID VSSEQ VSTESTCD VSTEST VSORRES VSORRESU VISITNUM VSDTC VSTPT);
retain STUDYID DOMAIN USUBJID VSSEQ VSTESTCD VSTEST VSORRES VSORRESU VISITNUM VSDTC VSTPT;
set VS03;
run;
