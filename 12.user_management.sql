-- 사용자 관리
-- 사용자 목록조회
select * from mysql.user;

<mysql에 새로운 계정 만들고 권한부여 해보는 실습 진행>
--사용자 생성
create user 'kimseonguk'@'localhost' identified by '비밀번호(4321)';
select * from mysql.user;
--%는 원격 포함한 anywhere 접속
create user '계정명'@'%' identified by '비밀번호';

--권한부여하기(사용자에게 select 권한 부여)
grant select on board.author to 'kimseonguk'@'localhost'; → author테이블의 조회 권한만 부여, 수정 등은 되지 않음

--사용자 권한 회수
revoke select on board.author from 'kimseonguk'@'localhost';

--권한을 볼 수 있는 명령어
show grants for 'kimseonguk'@'localhost';

--사용자 계정 삭제
drop user 'kimseonguk'@'localhost';
