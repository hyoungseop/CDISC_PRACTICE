
crf에서부터 sdtm 데이터셋까지 만드는 저의 첫 실습 프로젝트입니다.
*CRF에서 수집한 데이터를 CSV파일로 저장하여 SDTM 데이터셋으로 변환

폴더 구조
-crf_sample_data: crf 샘플 데이터, 프로토콜 샘플 데이터(프로토콜을 보고 만들었다는 가정의 데이터입니다.)
-sdtm_sample_data: sdtm 샘플 데이터, trial 샘플 데이터
-code: sas 코드(crf->sdtm)

실습 내용
1. CDISC 표준 문서를 활용하여 sdtm 데이터셋까지 생성
- 변수명, 변수값 등 정제, 파생변수 생성 등

2. 처음하는 실습이기에 CDISC IG 기준 꼭 필요한 변수(REQ) 위주로 생성하였습니다.
