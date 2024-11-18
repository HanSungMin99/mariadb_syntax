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


















