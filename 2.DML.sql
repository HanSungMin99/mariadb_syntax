-- insert into: 테이블에 데이터 삽입
insert into 테이블명(컬럼명1, 컬럼명2, 컬럼명3) values(데이터1, 데이터2, 데이터3);
-- 문자열은 일반적으로 작은 따옴표 ' '를 사용 (java에서는 큰 따옴표 "" 사용)
insert into author(id, name, email) values(3, 'kim', 'kim@naver.com');

-- select: 데이터 조회, * : 모든 컬럼을 의미 
select * from author; → 데이터가 많은 경우 서버 터질 수도 있어서 보통 조건을 걸어 조회
selcet name, email from author; → 특정한 열만 조회하고 싶을 시 select와 from 사이에 원하는 컬럼명을 넣는다. 

--(실습)post 데이터 1줄 추가
insert into post(id, title, contents) values(1, "시작", "시작 내용");
insert into post(id, title, contents, author_id) values(2, 'hello', 'hello...', 4); → 참조 에러가 발생, 에러 로그 확인해 보아야 함

-- 테이블 제약조건 조회
select * from information_schema.key_column_usage where table_name = 'post';
              →스키마 명         . →테이블명       
               :show databases;를 입력하여 조회하면 볼 수 있다, 기본적으로 만들어지는 것으로 테이블에 관한 정보가 들어가져 있다.    

--(실습)insert문을 통해 author데이터 2개 정도 추가, post 데이터 2개 정도 추가(1개는 익명)
insert into author(id, name, email, password) values(4, 'han', 'han@naver.com', 1234);
insert into author(id, name, email, password) values(5, 'ko', 'ko@naver.com', 1234);

insert into post(id, title, contents, author_id) values(3, 'swcamp', 'swcamp', 5);
insert into post(id, title, contents) values(4, 'beyond', 'beyond'); → 익명

-- update: 데이터 수정
-- where 문을 빠뜨리게 될 경우, 모든 데이터에 update문이 실행됨에 유의
update author set name = '홍길동' where id=1;
              →컬럼(열)의미 →어떤 값  →행을 의미
update author set name = '홍길동2', email= 'hongildong@naver.com' where id=2;

-- delete: 데이터 삭제
-- where조건을 생략할 경우 모든 데이터가 삭제됨에 유의 
-- 실무에서는 delete를 거의 사용하지 않는다. → 실제로는 데이터를 삭제하지 않고 Del_YN 등을 통해 더이상 사용하지 않는 데이터임을 표시해주는 update를 진행한다)
delete from author where id =4; → post에 작성한 글이 있고 외래키로 연동되어 있으면 삭제되지 않는다.

-- select: 조회
select * from author; →어떠한 조회조건없이 모든 컬럼 조회
select * from author where id=1; → where 뒤에 조회조건을 통해 조회
 → id는 기본키로 유니크하기 때문에 한 줄만 조회됨이 보장된다.
select * from author where name='hongildong';
 → 그러나 name 경우 유니크하지 않기 때문에 같은 이름의 사람이 있으면 여러줄이 조회된다(한 줄만 조회되는 것이 보장되지 않는다. )
select * from author where id>3;
select * from author where id>2 and name = 'ko'; → 또는일 경우에는 or를 사용하면 된다.

cf) update에서 쓰는 = 는 내용 삽입
    select에서 쓰는 = 는 내용 비교
    java랑 달리 삽입도 비교도 모두 '='을 하나만 사용한다. 

-- distinct: 중복제거 조회 
select name from author;
select distinct name from author;

-- 정렬: order by + 컬럼명
-- 아무런 정렬조건 없이 조회할 경우에는 pk기준으로 오름차순 정렬
-- asc: 오름차순, desc: 내림차순
select * from author order by name; → 정렬에서 디폴트값은 오름차순이라 조건을 안주면 오름차순으로 정렬됨(즉, asc 입력은 선택 & desc는 반드시 입력)
select * from author order by name desc                                   

-- 멀티컬럼 order by: 여러 컬럼으로 정렬, 먼저 쓴 컬럼 우선 정렬. 중복 시 그 다음 정렬 옵션 적용
select * from author order by name desc, email asc; → name으로 먼저 내림차순 정렬 후, name이 중복되면 email로 오름차순 정렬

cf)각각의 문자마다 고유의 숫자코드가 있음 
   → MYSQL에서 값 비교를 할 때는 대소문자를 구분하지 않는다. 

-- 결과값 개수 제한 
select * from author limit 2;
select * from author order by id desc limit 2; → 내림차순 순으로 2번째 결과까지 보여줌

-- 별칭(alias)을 이용한 select
select name as '이름', email as '이메일' from author → 출력되는 상단의 컬럼명을 바꾸어서 출력
select a.name, a.email from author as a ; → 테이블 엮어지는게 많아지면 테이블을 별칭으로 바꾼후 조건을 주어서 출력 (복잡함을 방지) 
select a.name, a.email from author a ; → as 생략 가능함 

-- null을 조회 조건으로 활용
select * from author where password is null; 
select * from author where password is not null; 







