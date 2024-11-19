-- author테이블에 post_count 컬럼 추가
alter table author add column post_count int default 0;

-- post에 글쓴 후에, author 테이블에 post_count 값에 +1을 시키는 트랜잭션 테스트
start transaction; → transaction할 범위 지정, 묶음을 짓는 것 (큰 의미 없는 명령어지만, 쿼리가 많을 시 transaction해줄 범위 구분하기 위해 필요)
update author set post_count = post_count+1 where id = 6; 
insert into post(title, contents, author_id) values ('hello java', 'hello java is...', 300);
rollback;

start transaction;
update author set post_count = post_count+1 where id = 6; 
insert into post(title, contents, author_id) values ('hello java', 'hello java is...', 6);
commit;

-- 위 transaction은 실패시 자동으로 rollback 어려움
-- stored 프로시저를 활용하여 자동화된 rollback 프로그래밍
DELIMITER // → 여기서부터 프로시저 프로그램임을 알려주는 것(//~//)
CREATE PROCEDURE 트랜잭션테스트()
BEGIN
    DECLARE exit handler for SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;
    start transaction;
    update author set post_count = post_count+1 where id = 6; 
    insert into post(title, contents, author_id) values ('hello java', 'hello java is...', 100); → 오류가 나서 rollback 처리됨 100을 6으로 바꿔주면 commit 처리됨.
    commit;
END //
DELIMITER ;

-- 프로시저 호출 
CALL 트랜잭션테스트();

-- 사용자에게 입력받을 수 있는 프로시저 생성 
DELIMITER // 
CREATE PROCEDURE 트랜잭션테스트2(in titleInput varchar(255), in contentsInput varchar(255), in idInput bigint)
BEGIN
    DECLARE exit handler for SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;
    start transaction;
    update author set post_count = post_count+1 where id = 6; 
    insert into post(title, contents, author_id) values (titleInput, contentsInput, idInput);
    commit;
END //
DELIMITER ;

