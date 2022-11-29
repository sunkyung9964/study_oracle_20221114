-- 직접 만들어서 JOIN 연산을 해보자

-- 무엇을 만들지 생각?! 서비스, 기능...
-- ======================== 모델링 =============================
-- 사원 vs 부서 <---> 업무로 파악 : ex> ERP 시스템 (사내 자원을 관리 시스템)
-- 엔터티 : 현실세계의 객체(사람, 물건,..) ==> 컴퓨터 세계 ===> TABLE
-- 애트리뷰트(=속성) : 이름, 사번, 급여 ...              ===> COLUMN
-- 사원은 부서에 포함된다 (관계)     vs    글      : (게시판에) 포함된다     vs   고객      : 구매한다\
                                       작성자   
-- 부서는 사원을 포함한다 (관계)     vs    게시판   :          포함한다     vs   상품      : 구매되어진다
-- 현실의 업무를 컴퓨터 상으로 옮기는 과정 <--> 모델링! [모델러, DBA]
--        시스템을 구동하는 프로그램을 제작, UI 작성 : 개발자

-- 글 엔터티 <--> POST 테이블을 작성
-- 한줄 게시판 : ex> 출석 게시판, 낙서 게시판....
CREATE TABLE POST (
    post_id NUMBER PRIMARY KEY,
    post_title VARCHAR2(30) NOT NULL,
    post_writer NUMBER NOT NULL,
    post_date DATE DEFAULT SYSDATE
);

-- 게시판ID 컬럼이 추가되고 제약조건이 추가되어야 함
ALTER TABLE POST
ADD post_board NUMBER(4);

DESC POST;

ALTER TABLE POST
ADD CONSTRAINT post_board_id_fk FOREIGN KEY (post_board) REFERENCES BOARD (board_id);

SELECT *
FROM    POST;

/*
    이미 기존 데이터가 있는 상태에서 새로운 컬럼을 추가하면, null이 삽입
    --> 옳지 않음..update 해주거나, 삭제후 다시 삽입
    post_id   post_title    post_writer  post_date  post_board
    ----------------------------------------------------------
    1	오라클 DBMS에 학습하기	1	22/11/28	null
    2	혼자공부하는 JAVA 심화	1	22/11/28	null
    3	1인 개발자의 공부법	2	22/11/28	null
*/
-- 테이블의 구조는 유지하고, 데이터 행을 모두 삭제 (null 처리 목적)
TRUNCATE TABLE POST;

-- 작성자 게시판 : 어느글을 누가 썼는지 상세한 정보를 담는..이름/이메일/전화번호
CREATE TABLE WRITER (
    writer_id NUMBER PRIMARY KEY,
    writer_name VARCHAR2(30) NOT NULL,
    writer_date DATE DEFAULT SYSDATE,
    writer_email VARCHAR2(50)
)



-- 외래키 제약조건(FK)
ALTER TABLE POST
ADD CONSTRAINT post_writer_fk FOREIGN KEY (post_writer) REFERENCES WRITER (writer_id);

-- 아무 작성자를 입력 가능  +  FK 제약조건 : writer에 없는 사용자가 post를 등록하지 못하게
-- 1. writer 정보를 입력
INSERT INTO WRITER
VALUES (1, '홍길동', SYSDATE, 'gildong@naver.com');
INSERT INTO WRITER
VALUES (2, '김길동', SYSDATE, 'gildong222222@naver.com');
INSERT INTO WRITER
VALUES (3, '박길동', SYSDATE, 'gildong333333@naver.com');

SELECT *
FROM    post;

-- 2. post 정보를 입력
INSERT INTO POST
VALUES (0001, '홍길동, 출석완료!', 1, SYSDATE, 0001);
INSERT INTO POST
VALUES (0002, '오늘 정말 추워요!', 1, SYSDATE, 0002);
INSERT INTO POST
VALUES (0003, 'ORACLE 설치방법?', 2, SYSDATE, 0003);

SELECT *
FROM    post;
-- JOIN 조회
-- 오라클 조인
SELECT  p.post_id, p.post_title, p.post_date write_date,
        w.writer_name, w.writer_email
FROM    post p, writer w
WHERE   p.post_writer = w.writer_id;

--BOARD 테이블 추가
CREATE TABLE BOARD (
    board_id NUMBER(4) PRIMARY KEY,
    board_name VARCHAR2(30) NOT NULL,
    board_date DATE DEFAULT SYSDATE
);

-- 샘플데이터
INSERT INTO BOARD
VALUES  (0001, '출석 게시판', TO_DATE('22/11/14'));
INSERT INTO BOARD
VALUES  (0002, '자유 게시판', TO_DATE('22/11/14'));
INSERT INTO BOARD
VALUES  (0003, '질문답변 게시판', TO_DATE('22/11/14'));


SELECT * 
FROM    POST;

SELECT * 
FROM    BOARD;

-- POST에 BOARD 이름 정보를 조회
SELECT  p.POST_ID, p.POST_TITLE, p.POST_DATE, 
        b.BOARD_NAME
FROM    POST p, BOARD b       
WHERE   p.POST_BOARD = b.board_id;






