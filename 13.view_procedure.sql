--view: 실제 데이터를 참조만 하는 가상의 테이블
--사용목적: 1) 복잡한 쿼리 대신 2)테이블의 컬럼까지 권한 분리 

--view생성
create view author_for_marketing as select name, email from author;
create view author_for_marketing as select name, email from author where user != ''; → 이런식으로 특정 조건은 조회가 안되게 할 수도 있음
--view조회
select * from author_for_marketing; → 이렇게 조회하면 as 뒤의 쿼리문이 실행되면서 조회된다. 
--view권한부여 
grant select on board.author_for_marketing to '계정명'@'localhost';
--view삭제
drop view author_for_marketing;


--프로시저 생성
--프로시저(→프로그래밍 자유도가 높다, 프로그래밍 작업이 가능하다)와 트랜잭션은 다름
DELIMITER //
create procedure hello_procedure()
begin
     select 'hello world';
end
// DELIMITER ;

--프로시저 호출
call hello_procedure();

--프로시저 삭제
drop procedure hello_procedure;

--게시글목록조회 프로시저 생성 및 조회
DELIMITER //
create procedure 게시글목록조회()
begin
     select * from post;
end
// DELIMITER ;

call 게시글목록조회();

--게시글 id 단건 조회
DELIMITER //
create procedure 게시글id단건조회(in postid bigint)
begin
     select * from post where id = postid;
end
// DELIMITER ;

call 게시글id단건조회(1);


--(실습)게시글목록조회byemail: 본인이 쓴 글 목록 조회, 본인의 email을 입력값으로 조회, 목록조회의 결과는 post의 id, title, contents 나오게
DELIMITER //
create procedure 게시글목록조회byemail(in inputEmail varchar(255))
begin
     select p.id, p.title, p.contents from post p inner join author_post ap on p.id=ap.post_id inner join author a on a.id=ap.author_id where a.email = inputEmail;
end
// DELIMITER ;

--글쓰기
DELIMITER //
create procedure 글쓰기(in inputTitle varchar(255), inputContents varchar(255), in inputEmail varchar(255))
begin
     declare authorId bigint;
     declare postId bigint;
     --post테이블에 insert
     insert into post(title, contents) values(inputTitle, inputContents);
     select id into postId from post order by id desc limit 1;
     select id into authorId from author where email=inputEmail; 
     --author_post테이블 insert: author_id, post_id필요
     insert into author_post(author_id, post_id) values(authorId, postId);
end
// DELIMITER ;

--글삭제: 입력값으로 글id, 본인email
DELIMITER //
create procedure 글삭제(in inputPostId bigint, in inputEmail varchar(255))
begin
     declare authorPostCount bigint;
     declare authorId bigint;
     select count(*) into authorPostCount from author_post where post_id  = inputPostId;
     select id into authorId from author where email=inputEmail; 
     if authorPostCount>=2 then
     --elseif까지 사용가능
         delete from author_post where post_id = inputPostId and author_id=authorId; 
     else 
         delete from author_post where post_id=inputPostId and author_id=authorId;
         delete from post where id=inputPostId;
     end if;
end
// DELIMITER ;

--반복문을 통해 post대량생성: title, 글쓴이email
DELIMITER //
create procedure 글도배(in count int, in inputEmail varchar(255))
begin
    declare countValue int default 0;
    declare authorId bigint;
    declare postId bigint;
    while countValue<count do
        --post테이블에 insert
        insert into post(title) values("안녕하세요");
        select id into postId from post order by id desc limit 1;
        select id into authorId from author where email=inputEmail; 
        --author_post테이블 insert: author_id, post_id필요
        insert into author_post(author_id, post_id) values(authorId, postId);
        set countValue = countValue+1;
    end while;
end
// DELIMITER ;

