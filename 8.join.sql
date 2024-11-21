-- inner join 
-- 두 테이블 사이에 지정된 조건에 맞는 레코드만 반환. on 조건을 통해 교집합 찾기
select * from author inner join post on author.id = post.author_id;
select * from author a inner join post p on a.id = p.author_id;
-- 출력순서만 달라질 뿐 조회결과는 동일. 
select * from post inner join author on author.id = post.author_id;
-- 글쓴이가 있는 글 목록과 글쓴이의 이메일만을 출력하시오. 
-- post의 글쓴이가 없는 데이터는 포함 X, 글쓴이 중에 글을 한번도 안 쓴 사람 포함X
select p.*, a.email from post p inner join author a on a.id=p.author_id;
-- 글쓴이가 있는 글의 제목, 내용, 그리고 글쓴이의 이메일만 출력하시오.
select p.title, p.contents, a.email from post p inner join author a on a.id=p.author_id;

-- 모든 글 목록을 출력하고 만약에 글쓴이가 있다면 이메일 정보를 출력.
-- left outer join → left join으로 생략가능
-- 글을 한번도 안 쓴 글쓴이 정보는 포함X
select p.*, a.email from post p left join author a on a.id=p.author_id;

-- 글쓴이를 기준으로 left join할 경우, 글쓴이가 n개의 글을 쓸 수 있으므로 같은 글쓴이가 여러번 출력될 수 있음.
-- author와 post가 1:n 관계이므로 
-- 글쓴이가 없는 글은 포함X
select * from author a left join post p on a.id=p.author_id; 

-- 실습) 글쓴이가 있는 글 중에서 글의 title과 저자의 이메일만을 출력하되, 
-- 저자의 나이가 30세 이상인 글만 출력.
select p.title, a.email from post p inner join author a on a.id=p.author_id where age >= 30;

-- 글의 내용과 글의 저자의 이름이 있는, 글 목록을 출력하되 2024-06 이후에 만들어진 글만 출력
select p.* from post p inner join author a on p.author_id=a.id where p.contents is not null and a.name is not null and date_format(p.created_time, '%Y-%m') >= '2024-06'; 

-- (프로그래머스) 조건에 맞는 도서와 저자 리스트 출력 
select b.BOOK_ID, a.AUTHOR_NAME, DATE_FORMAT(b.PUBLISHED_DATE, '%Y-%m-%d') as PUBLISHED_DATE from book b left join author a on b.AUTHOR_ID = a.AUTHOR_ID where b.CATEGORY='경제' order by PUBLISHED_DATE;

-- union: 두 테이블의 select결과를 횡으로 결합(기본적으로 distinct 적용)
-- 컬럼의 개수와 컬럼의 타입이 같아야 함에 유의
-- union all: 중복까지 모두 포함
select name, email from author union select title, contents from post;


-- 서브쿼리: select문 안에 또다른 select문을 서브쿼리라 한다. 
-- where절 안에 서브쿼리
-- 한번이라도 글을 쓴 author 목록 조회
select distinct a.* from author a inner join post p on a.id=p.author_id
select * from author where id in (select author_id from post);
-- select절 안에 서브쿼리
-- author의 이메일과 author 별로 본인이 쓴 글의 개수를 출력
select a.email, (select count(*)from post where author_id=a.id) from author a; 
-- from절 안에 서브쿼리
select a.name from(select * from author) as a;

---------------------------------------------------------------------------------------------------------------------------------------

-- 없어진 기록 찾기
-- 서브쿼리 활용 
select ANIMAL_ID, NAME from ANIMAL_OUTS where ANIMAL_ID not in (select ANIMAL_ID from ANIMAL_INS) order by ANIMAL_ID;
-- 조인 활용
select o.ANIMAL_ID, o.NAME from ANIMAL_OUTS o left join ANIMAL_INS i on i.ANIMAL_ID=o.ANIMAL_ID where i.ANIMAL_ID is null order by i.ANIMAL_ID;

-- 집계함수
select count(*) from author; 〓 select count(id) from author; 
select count(id) from author; 와 select count(name) from author; 은 다르다 → null 값은 count에서 제외
select sum(price) from post;
select avg(price) from post; → 소수점을 정해서 구하고 싶을때 round함수 사용: select round(avg(price),0) from post; <소수점 첫번째자리에서 반올림해서 소수점을 없앰>

-- group by: 그룹화된 데이터를 하나의 행(row)처럼 취급.
-- author_id로 그룹핑 하였으면, 그외의 컬럼을 조회하는 것은 적절치 않음
select author_id from post group by author_id
-- group by와 집계함수
-- 아래 쿼리에서 *은 그룹화된 데이터 내에서의 개수
select author_id, count(*) from post group by author_id;
select author_id, count(*), sum(price) from post group by author_id;
*실습: author의 이메일과 author 별로 본인이 쓴 글의 개수를 출력: select a.email, (select count(*)from post where author_id=a.id) from author a; 
       = join과 group by, 집계함수 활용한 글의 개수 출력: select a.email, count(p.author_id) from author a left join post p on a.id=p.author_id group by a.email;
         (*글을 쓰지 않은 경우 0이 나오게)
       = join과 group by, 집계함수 활용한 글의 개수 출력:  select a.email, 
         (*글을 쓰지 않은 경우 '글 쓴 적 없음' 문구 나오게)  case
                                                          when count(p.author_id)  = 0 then '글쓴적없음'
                                                          else cast(count(p.author_id) as char)
                                                          end
                                                         from author a left join post p on a.id=p.author_id group by a.email;
         
-- 순서: select from join on where group by having order by → 잘 알아야 함

-- where와 group by
-- 연도별 post 글의 개수 출력, 연도가 null인 값은 제외
select YEAR(created_time), count(id) from post where year(created_time) is not null group by year(created_time); → select YEAR(created_time), count(id) from post where created_time is not null group by year(created_time);
select date_format(created_time, '%Y') as year, count(*) from post where created_time is not null group by year;

-- (프로그래머스) 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
select CAR_TYPE, count(CAR_TYPE) as 'CARS' from CAR_RENTAL_COMPANY_CAR where OPTIONS like'%통풍시트%' or OPTIONS like '%열선시트%' or OPTIONS like '%가죽시트%' group by CAR_TYPE order by CAR_TYPE;

-- (프로그래머스) 입양 시각 구하기(1)
select HOUR(DATETIME) AS HOUR, COUNT(*) FROM ANIMAL_OUTS WHERE HOUR(DATETIME)>=9 AND HOUR(DATETIME)<=19 GROUP BY HOUR(DATETIME) ORDER BY HOUR(DATETIME);

-- having: group by를 통해 나온 집계값에 대한 조건
-- 글을 2개 이상 쓴 사람에 대한 정보조회
select author_id from post group by author_id having count(*)>=2;
select author_id, count(*) as count from post group by author_id having count >=2;

-- 동명 동물 수 찾기
select NAME, count(ANIMAL_ID) as 'count' from ANIMAL_INS where name is not null group by NAME having count(ANIMAL_ID)>=2 order by NAME;

-- 다중열 group by 
-- post에서 작성자별로 만든 제목의 개수를 출력하시오.
select author_id, title , count(*) from post group by author_id, title;

-- 재구매가 일어난 상품과 회원리스트 구하기 
select USER_ID, PRODUCT_ID from ONLINE_SALE group by USER_ID, PRODUCT_ID having count(*)>=2 order by USER_ID, PRODUCT_ID desc;





