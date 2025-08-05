
data TA00; set CRF.CRF_TA_SAMPLE;

*1. DOMAIN 생성;
DOMAIN = 'TA';

*2. ARM(치료군 이름) 수정;
put ARM:;
/* STUDY DRUG 10mg -> 수정 필요(최대한 명확하게 제시) PLACEBO*/
if ARM = 'STUDY DRUG 10mg' then ARM = 'DRUG A 10MG';

*3. ETCD, ELEMENT 수정;
put ETCD: ELEMENT:;
/*TREAT TREATMENT -> 수정 필요(최대한 명확하게 제시)*/
if ETCD = 'TREAT' then ETCD = 'TRTA';
if ELEMENT = 'TREATMENT' then ELEMENT = 'TREATMENT A';


run;

data SDTM.SDTM_TA_SAMPLE;
retain STUDYID DOMAIN ARMCD ARM TAETORD ETCD ELEMENT TABRANCH TATRANS EPOCH;
**TABRANCH: 분기점 이름, TATRANS: 전환 조건;
set TA00;

run;