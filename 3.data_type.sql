-- tinyint는 -128~127까지 표현(1byte 할당)
-- author테이블에 age 컬럼 추가
alter table author add column age tinyint;
-- data insert 테스트: 200살 insert
insert into author (id, age) values(7, 200);
*
alter table author modify column age tinyint unsigned; → 부호를 쓰지않으면 숫자의 범위가 1bit 만큼 늘어남, -128~127이 아닌 0~255 숫자를 사용할 수 있음(음수가 필요없을 때 사용)

-- decimal실습
-- decimal(정수부 자릿수, 소수부 자릿수)
alter table post add column price decimal(10, 3); → 범위 늘리고 싶으면 modify를 이용하여 늘려주면 된다(범위를 줄이는 것은 문제가 될 수 있는데 늘리는 것은 괜찮다.)

-- decimal 소수점 초과 후 값 짤림 현상
insert into post(id, title, price) values(8, 'java programming', 10.33412); → 뒤에 2개는 짤리는 결과가 나옴

cf)
숫자: 정수 실수로 나누어지고
정수: tinyint(1바이트), int(4바이트), bigint(8바이트)로 나누어진다. 
실수: 고정소수점 방식(decimal(정수부,소수부)), 부동소수점 방식(float, double)이 있다.

cf)
문자: char, varchar, text
varchar: 가변, 길이지정, index사용, 메모리(rem)활용 → 저장속도가 더 빠르다.
text: 가변, 65535, index 사용불가, 주로 디스크(hdd,sdd) 활용

-- 문자열 실습
alter table author add column self_introduction text;
insert into author(id, self_introduction) values(8, '안녕하세요. 000입니다.')

-- blob(바이너리데이터) 타입 실습
*바이너리(binary)데이터: 바이너리=2진법
  이미지 또는 동영상을 바이너리 데이터로 변환
alter table author add column profile_image longblob;
insert into author(id, profile_image) values(10, LOAD_FILE('파일경로')); → 열값에 NULL 대신 BLOB이 나오면 성공
                                                                          : 이미지 다운로드(다운시 C드라이브에 넣으면 삽입 가능) → 이미지 우클릭 속성 → 위치 복사→추가로 파일명과 확장자까지 작성

-- enum: 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- role칼럼 추가
alter table author add column role enum('user', 'admin') not null default 'user'; → default란 아무것도 입력하지 않았을 때 'user' 가 들어가게 해주는 것
-- user값 세팅 후 insert
insert into author(id, role) values(11, 'user');
-- users값 세팅 후 insert(잘못된 값)
insert into author(id, role) values(12, 'users');
-- 아무것도 안넣고 insert(default 값)
insert into author(id, name, email) values(12, 'hong', 'hong12@naver.com');
-- admin값 세팅 후 insert
insert into author(id, role) values(13, 'admin');

-- date: 날짜, datetime: 날짜 및 시분초(m옵션시: microseconds)
-- datetime은 입력, 수정, 조회 시에 문자열 형식을 활용 → update post  set created_time = '2024-11-18 19:12:16' where id =1;
alter table post add column created_time datetime default current_timestamp();      
→이미 만들어진 데이터가 있을 때 이렇게 칼럼추가시 이전 데이터의 datetime이 전부 현재시간으로 들어간다(과거의 시간을 우리가 알 수 없기 때문에), 따라서 처음부터 설정을 잘 해주어야 한다.

 -- 조회시 비교연산자
select * from author where id >= 2 and id <=4;
select * from author where id between 2 and 4; → 위 >=2 and <=4 구문과 같은 구문, between 2 and 4는 2, 4도 포함한다는 것(3만 포함되는 것 아님)
select * from author where id not(id < 2 or id > 4);
select * from author where id in(2,3,4); → in 안에 select문 넣을 수도 있음. 예) select * from author where id in(select author_id from post);
select * from author where id not in(1,5); ←전체데이터가 1~5까지 밖에 없다는 가정
















