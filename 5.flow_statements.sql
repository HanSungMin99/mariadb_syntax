-- case문 
select 컬럼1, 컬럼2, 컬럼3,
-- if (컬럼 4==비교값1){결과값1출력}else if(컬럼4==비교값2){결과값2출력}else{결과값3출력} → 밑에 case랑 같은 조건
case 칼럼4
 when 비교값1 then 결과값1
 when 비교값2 then 결과값2
 else 결과값3
end → 반드시 찍어주어야 함
from 테이블명;

select id, email,
case  
 when name is null then '익명사용자'
 else name
end 
from author;


-- ifnull(a,b): 만약에 a가 null이면 b를 반환, null 아니면(a가 있으면) a반환
select id, email, ifnull(name, '익명사용자') as '사용자명' from author;

--(실습-프로그래머스)경기도에 위치한 식품창고 목록 출력하기
1. select WAREHOUSE_ID, WAREHOUSE_NAME, ADDRESS,
  case 
   when FREEZER_YN is null then 'N'
   else FREEZER_YN
 end
from FOOD_WAREHOUSE where ADDRESS like '%경기도%' ORDER BY WAREHOUSE_ID;
→ select ~~from 구조 먼저 하고 조건을 걸 것!(중요)

2.select WAREHOUSE_ID, WAREHOUSE_NAME, ADDRESS,
  ifnull(FREEZER_YN, 'N')
  from FOOD_WAREHOUSE where ADDRESS like '%경기도%' ORDER BY WAREHOUSE_ID;


-- if(a,b,c): a조건이 참이면 b반환, a조건이 거짓이면 c반환
select id, email, if(name is null, '익명사용자', name) as '사용자명' from author;


-- (실습-프로그래머스)조건에 부합하는 중고거래 상태 조회하기
select BOARD_ID, WRITER_ID, TITLE, PRICE, 
 case 
  when STATUS = 'SALE' then '판매중'
  when STATUS = 'RESERVED' then '예약중'
  else '거래완료'
 end as 'STATUS'
from USED_GOODS_BOARD where CREATED_DATE = '2022-10-05' order by BOARD_ID desc;

-- (실습-프로그래머스)12세 이하인 여자 환자 목록 출력하기
select PT_NAME, PT_NO, GEND_CD, AGE,
 case 
  when  TLNO is null then 'NONE'
  else TLNO
 end
from PATIENT where AGE <= 12 and GEND_CD = 'W' order by AGE desc, PT_NAME;

