#덤프파일 생성: dumpfile.sql이라는 이름의 덤프파일생성
mysqldump -u root -p board > dumpfile.sql
#한글깨질때
mysqldump -u root -p board -r dumpfile.sql
#덤프파일 적용(복원) → 이전하고자하는 곳에 board라는 스키마를 먼저 만들어야 함.
mysql -u root -p board < dumpfile.sql
#<가 특수문자로 인식되어, window에서는 적용이 안될 경우, git bash 터미널 창을 활용

<리눅스에 dumpfile설치해보기>
#dump파일을 git hub에 업로드

#리눅스에서 mariadb설치
sudo apt-get install mariadb-server

#mariadb서버 실행
sudo systemctl start mariadb

#mariadb 접속: 1234
mariadb -u root -p
create database board;

#git 설치
sudo apt install git

#git에서 repository clone
git clone 레포지토리주소

#mariadb 덤프파일 복원 작업
mysql -u root -p board < dumpfile.sql


