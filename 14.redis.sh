#redis 설치
sudo apt-get install redis server

#redis 접속
redis-cli 
cli-comnand line interface의 약어 

#나가려면 
^c 또는 exit 

#redis는 0~15번 까지의 database로 구성 (default는 0번 db)
#데이터베이스 선택
select db번호

#데이터베이스 내 모든 키 조회
keys * 

#일반적인 String 자료구조
set key명 value값(string일때도 있고 숫자도 있지만, 숫자로 입력해도 string값으로 저장된다)
#set을 통해 key:value값 세팅. 맵에서 set은 이미 존재할 때 덮어쓰기 한다. 
set email_1 hong1@naver.com
set user:email:1 hong1@naver.com
set user:name:1 hong
→ :가 아무 의미 없어서 이렇게 입력해도 괜찮음, 이메일과 이름 등 다양한 값을 저장하고 싶을때 사용가능.
#nx: 이미 존재하면 pass 없으면 set
set email_1 hong1@naver.com nx 
#ex: 만료시간(초단위) - ttl(time to live)
set email_1 hong1@naver.com ex 10
#get을 통해 value값 얻기
get email_1
#특정 key 삭제
del email_1
#현재 DB 내 모든 key 삭제 
flushdb

#redis 활용예시 : 동시성 이슈
#1. 좋아요 기능 구현
set likes:posting:1 0
#좋아요 눌렀을 경우
incr likes:posting:1 → 특정 key값의 value를 1만큼 증가 
decr likes:posting:1 → 특정 key값의 value를 1만큼 감소 
get likes:posting:1
#2. 재고관리
set stocks:product:1 100
decr stocks:product:1 
get stocks:product:1

#bash 쉘을 활용하여 재고 감소 프로그램 작성
for i in {1..200}; do
 quantity=$(redis-cli -h localhost -p 6379 get stocks:product:1)
 if [ "$quantity" -;t 1 ];then 
    echo "stock is not available"
    break;
 fi
redis-cli -h localhost -p 6379 decr stocks:product:1
echo "stocks : $quantity"

done

#redis활용예시: 캐싱 기능 구현
#1번 author 회원 정보 조회
#select name, email, age from author where id=1;
#위 데이터의 결과값을 redis로 캐싱 → json형식으로 저장(key:value 형식으로 저장, {"name":"hong", "email":"hong@naver.com", "age":30}처럼 중괄호를 열고 닫아야 한다.)
set author:info:1 "{\"name\":\"hong\", \"email\":\"hong@naver.com\", \"age\":30}" ex 20 

#list자료 구조
#redis의 list는 java의 deque와 같은 자료구조, 즉 double-ended queue구조

#lpush: 데이터를 왼쪽에 삽입
#rpush: 데이터를 오른쪽에 삽입
#lpop: 데이터를 왼쪽에서 꺼내기
#rpop: 데이터를 오른쪽에서 꺼내기

lpush hongildongs(→list를 담는 상자명이 된다) hong1 → hongildongs=[hong1]
lpush hongildongs hong2 → hongildongs=[hong2,hong1]
lpush hongildongs hong3 → hongildongs=[hong3,hong2,hong1]
rpop hongildongs → "hong1"
lpop hongildongs → "hong3"
1pop hongildongs → "hong2"
lpop hongildongs → "nil"

#list조회: lrange
#-1은 리스트의 끝자리를 의미, -2는 끝에서 2번째를 의미
lrange hongildongs 0 -1 :처음부터 마지막 → 모든 데이터 보기
lrange hongildongs 0 0 : 첫번째 값 →  hong3만 보고 싶다, lpop과 다른점: lpop은 꺼내서 보는 것이라 데이터 값이 없어짐, lrange는 단순 조회라서 데이터값 안 없어짐
lrange hongildongs -1 -1: 마지막 값 → hong1 보고싶다
lrange hongildongs -3 -1
lrange hongildongs 0 2

#데이터 개수 조회
llen hongildongs: 데이터 개수 조회 → 3 나옴
#ttl 적용
expire hongildongs 20 → 만료시간 지정, 20초 지나면 데이터 사라져 있음
#ttl 조회
ttl hongildongs
#pop과 push를 동시에
#A리스트에서 pop하여 B리스트로 PUSH
rpoplpush A리스트 B리스트

#최근 방문한 페이지
#5개정도 데이터 PUSH
#최근 방문한 테이지 3개만 보여주는
rpush mypages www.naver.com
rpush mypages www.google.com
rpush mypages www.daum.net
rpush mypages www.chatgpt.com
rpush mypages www.daum.net
lrange mypages -3 -1

#set 자료구조: 중복없음, 순서없음
sadd memberlist member1
sadd memberlist member2
sadd memberlist member1

#set 조회
smembers memberlist
#set멤버 개수 조회
scard memberlist
#set에서 멤버 삭제
srem memberlist member2
#특정 멤버가 set 안에 있는지 존재여부 확인
sismember memberlist member1

#좋아요 구현
sadd likes:posting:1 member1
sadd likes:posting:1 member2
sadd likes:posting:1 member1
scard likes:posting:1 
sismember likes:posting:1 member1

#zset: sorted set
#사이의 숫자는 score라고 불리고, score를 기준으로 정렬이 가능
zadd memberlist 3 member1
zadd memberlist 4 member2
zadd memberlist 1 member3
zadd memberlist 2 member4

#조회방법
#score기준 오름차순 정렬
zrange memberlist 0 -1
#score기준 내림차순 정렬
zrevrange memberlist 0 -1

#zset 삭제
zrem memberlist member4

#zrank: 특정 멤버가 몇번째(index 기준) 순서인지 출력
zrank memberlist member4

#최근 본 상품목록 => zset을 활용해서 최근시간순으로 정렬
#zset도 set이므로 같은 상품을 add할 경우에 시간만 업데이트되고 중복이 제거
#같은 상품을 더할 경우 시간만 마지막에 넣은 값으로 업데이트(중복제거)
zadd recent:products 151930 pineapple
zadd recent:products 152030 banana
zadd recent:products 152130 orange
zadd recent:products 152230 apple
zadd recent:products 152330 apple
#최근 본 상품목록 3개 조회
zrevrange recent:products 0 2 withscores 

#hashes: map형태의 자료구조(key:value key:value ...형태의 자료구조)
hset author:info:1 name "hong" email "hong@naver.com" age 30 

*cf)
set author:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" ex 20
=> 목적: 캐싱
=> 문자열이라서 수정,삭제 어려움
hset author:info:1 name "hong" email "hong@naver.com" age 30 
=> 자료구조임 해당 부분 조회,수정,삭제 가능

#특정값 조회
hget author:info:1 name 
#모든 객체값 조회
hgetall author:info:1

#특정 요소값 수정
hset author:info:1 name kim



