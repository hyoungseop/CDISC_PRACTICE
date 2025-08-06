

data dm00(drop = SITEID SUBJID); set CRF.CRF_DM_SAMPLE;
attrib
USUBJID length = $30.;
;

*1. SITEID, SUBJID 문자형으로;
SITEID_1 = put(SITEID,2.);
if length(strip(SUBJID)) = 1 then SUBJID_1 = "00"||strip(SUBJID);
else if length(strip(SUBJID)) = 2 then SUBJID_1 = "0"||strip(SUBJID);
else SUBJID_1 = strip(SUBJID);

*2. DOMAIN 생성;
DOMAIN = 'DM';

*3. USUBJID 생성;
USUBJID = CATX("-",STUDYID,SITEID_1,SUBJID_1);

*4. BRTHDTC 생성;
/*BRTHDTC = BRTHDAT;*/
**250806 문자형으로 변경**;
BRTHDTC = put(BRTHDAT,e8601da.);

*5. RFSTDTC 생성;
/*RFSTDTC = DMDAT;*/
**250806 문자형으로 변경**;
RFSTDTC = put(DMDAT,e8601da.);

*6. ETHNIC 불필요한 값 확인;
if ETHNIC not in ('HISPANIC OR LATINO' 'NOT HISPANIC OR LATINO' 'UNKNOWN') then put "ETHNIC Confirmation required " ETHNIC: ;

*7. RACE 불필요한 값 확인;
*2건 확인(MULTIPLE);
if RACE not in (
'WHITE' 'ASIAN' 'BLACK OR AFRICAN AMERICAN' 
'AMERICAN INDIAN OR ALASKA NATIVE' 'NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER' 'OTHER') then put "RACE Confirmation required " RACE: ;

*8. 불필요한 값 수정(임의 수정);
if RACE = 'MULTIPLE' then RACE = 'WHITE';

run;

*순서 정리 및 필요 변수 추출;
data SDTM.SDTM_DM_SAMPLE(keep = STUDYID DOMAIN USUBJID SUBJID SITEID BRTHDTC RFSTDTC SEX RACE ETHNIC); 
retain STUDYID DOMAIN USUBJID SUBJID SITEID BRTHDTC RFSTDTC SEX RACE ETHNIC;
set dm00(rename = (SUBJID_1 = SUBJID SITEID_1 = SITEID));
run;


