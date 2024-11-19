제약조건 종류: pk, fk, not null, unique

pk, fk 적용할 때 제약조건 추가 방법 2가지
1. 칼럼에 추가
2. 테이블 차원에서 추가 → fk는 주로 테이블차원에서 설정한다
                      → 두가지를 제약 조건 걸고 싶을 때 fk(a, b), unique(a, b) 처럼 콤마를 써서 해주면 된다. 
3. not null은 테이블 차원에서 안됨, unique는 칼럼과 테이블차원에서 둘 다 된다. 

-- not null 제약조건 추가
alter table author modify column email varchar(255) not null;

-- unique 제약조건 추가 
alter table author modify column email varchar(255) unique;
alter table author modify column email varchar(255) not null unique; → modify할 때는 컬럼차원에서 unique를 걸어주는 것이 좋다. 

*index → 조회 성능 향상, 용량 차지
 자주 조회되는 컬럼에 대해서 index 생성 
 index 조회 방법: show index from author;

-- foreign key 제약조건 삭제 및 추가 (테이블 차원에 제약 조건이 걸려있을 때) → 제약조건의 이름 확인 후 삭제 및 추가 가능
1. 제약조건 조회: describe는 걸린 조건이 구체적으로 안나옴 → select * from information_schema.key_column_usage where table_name = 'post'; 통해 조회 
2. 제약조건 삭제: alter table post drop foreign key post_ibfk_1;
3. 제약조건 추가: alter table post add constraint post_author_fk(제약조건명 들어가야함) foreign key(author_id) references author(id);

-- delete, update  관련 제약조건 테스트
 - on delete cascade 테스트 
   1.제약조건 삭제: alter table post drop foreign key post_author_fk;
   2.제약조건 추가: alter table post add constraint post_author_fk foreign key(author_id) references author(id) on delete cascade;
 -다음 테스트 하기 전에 추가한 fk 삭제 먼저: alter table post drop foreign key post_ibfk_1;
 - on delete set null 테스트 
   1.제약조건 삭제: alter table post drop foreign key post_author_fk;
   2.제약조건 추가: alter table post add constraint post_author_fk foreign key(author_id) references author(id) on delete set null on update set null;

-- default 옵션
alter table author modify column name varchar(255) default 'anonymous';

-- auto_increment(반드시 알아야 하는 내용)→내가 id를 차례로 추가하지 않아도 자동으로 순서대로 id가 추가되도록 설정
alter table author modify column id bigint auto_increment; → 이게 안되면 이것을 외래키로 받는 author_id의 타입도 bigint로 바꿔야 한다.
alter table post modify column id bigint auto_increment;

-- uuid
alter table post add column use_id char(36) default (UUID());

