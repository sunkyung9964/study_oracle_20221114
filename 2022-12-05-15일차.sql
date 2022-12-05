--8장. DML
-- 수동으로 COMMIT 이나 ROLLBACK      vs   자동으로 COMMIT 되는 것 (DDL : CREATE, ALTER, DROP, TRUNCATE / AUTO COMMIT)
-- 트랜잭션(Transaction, 거래 / 송금시 전기가 차단되어 송금결과를 못본 상태에서 계좌상의 금액이 옮겨지는 일이 없도록
-- 은행에서는 실제 거래가 잘 이뤄졌음을 확인하고 해당 조치를 수행)
-- 인출()
-- 송금()

-- Data 조작 언어
-- 개발자들이 가장 많이 사용하는 문법   vs   모델러, DBA, 데이터분석가...
-- SELECT, INSERT, UPDATE, DELETE 구문

--8.1 데이터 삽입
-- INSERT INTO 테이블 (컬럼명1, 컬럼명2,..) : 순서, 컬럼갯수 중요
-- VALUES (값1, 값2,...) 

-- INSERT INTO 테이블   : 모든 컬럼을 데이터 삽입(생략x)
-- VALUES (값1, 값2...)

-- emp 라는 테이블 생성
-- 12.2 수업참여자의 경우 emp 테이블을 먼저 DROP 한 뒤에~ 실행!
DROP TABLE emp;
-- 1.hr 스키마 ==> EMPLOYEES 테이블중 일부 컬럼을 가져와서 emp로 만드는 방법 : CTAS (조회된 
-- CREATE TABLE 테이블명
-- SELECT 이하~ 
CREATE TABLE emp AS
SELECT  employee_id emp_id, first_name fname, last_name lname, hire_date, job_id, salary,
        commission_pct comm_pct, department_id dept_id
FROM    employees -- 컬럼과 데이터를 함께 조회후 emp 테이블을 생성하고 데이터를 삽입
-- CTAS로 테이블을 복사하면, 관련된 제약조건들도 복사가 된다.

desc emp;
select * from emp;
-- ======================================================================
-- 테이블 제약조건을 확인하는 명령
SELECT  *
FROM    user_constraints
WHERE   table_name = 'EMP'; -- EMP 라는 테이블에 정의된 제약조건을 확인
-- ======================================================================

INSERT INTO emp (emp_id, fname, lname, hire_date, job_id)
VALUES (301, 'Bill', 'Gates', TO_DATE('2013/05/26', 'yyyy/mm/dd'), 'SA_CLERK'); -- JOB_ID NOT NULL 제약조건때문에 데이터 삽입시 오류

-- 2.emp 라는 테이블을 직접 정의 
CREATE TABLE emp (
    EMP_ID NUMBER PRIMARY KEY,
    FNAME VARCHAR2(30),
    LNAME VARCHAR2(20),
    HIRE_DATE DATE DEFAULT SYSDATE,
    JOB_ID VARCHAR2(20), -- NOT NULL 조건을 명시하지 않으면, NULL 값 허용!
    SALARY NUMBER(9,2),
    COMM_PCT NUMBER(3,2),
    DEPT_ID NUMBER(3) -- 외래키 제약조건등이 없어서 삽입이 바로 됨!!
);

[예제8-1]
INSERT INTO EMP (emp_id, fname, lname, hire_date, job_id)
VALUES (300, 'Steven', 'Jobs', SYSDATE, 'ST_MAN');

COMMIT; -- 수동으로 개발자가 커밋(메모리 --> 물리적으로 저장)

-- 자동커밋되는 명령
TRUNCATE TABLE emp; -- emp 테이블의 모든 데이터를 삭제 / 구조는 남김 + (자동으로 COMMIT;)
ROLLBACK; -- 수동으로 롤백
SELECT * FROM EMP;

-- A팀의 팀장 : GRANT CONNECT, CREATE VIEW, RESOURCES TO 팀원1;


[예제8-4] 워렌버핏의 정보를 입력 , NULL 또는 '' 빈문자열로 표시
INSERT INTO emp (emp_id, fname, lname, hire_date, job_id, salary)
VALUES (302, 'Warren', 'Buffett', SYSDATE, 'ST_CEO','');

SELECT *
FROM    emp;


[예제8-5] 
-- CTAS : CREATE TABLE 테이블명 AS SELECT 이하
-- ITAS : INSERT INTO 테이블 (AS없음) SELECT 이하
INSERT INTO emp (emp_id, fname, lname, hire_date, job_id, dept_id)
SELECT employee_id, first_name, last_name, hire_date, job_id, department_id
FROM    employees
WHERE   department_id IN (10, 20);

COMMIT;

-- 월별 급여 관리 테이블 : month_salary
-- 다중 컬럼 서브쿼리 실습에서 사용했음
DESC month_salary;

SELECT  *
FROM    month_salary;

[예제 8-6]
TRUNCATE TABLE month_salary; -- 모든 데이터를 지우고 자동 커밋!



-- ITAS
INSERT INTO month_salary (magam_date, dept_id)
SELECT  SYSDATE, department_id
FROM    employees
WHERE   department_id IS NOT NULL
GROUP BY department_id

SELECT * FROM month_salary;

-- 나머지 NULL 채우려면, 다중컬럼 서브쿼리를 사용해서 UPDATE 구문 실행

[예제8-7] emp 테이블에 employees 테이블의 30번부터 60번 부서에 근무하는 사원의 정보를 조회해서 삽입하시오
INSERT INTO emp
SELECT  employee_id, first_name, last_name, hire_date, job_id, salary, commission_pct, department_id
FROM    employees
WHERE   department_id BETWEEN 30 AND 60; -- 57 rows

SELECT * FROM EMP;

-- ===================================================================
-- INSERT INTO 테이블명 (컬럼명1, 컬럼명2,..) VALUES (값1, 값2, ...)
-- INSERT INTO 테이블명 VALUES (값1, 값2, ...컬럼수만큼)
-- INSERT INTO 테이블명 SELECT 이하~ : ITAS (AS 없음)
-- ===================================================================


-- 8.2 데이터 변경 / UPDATE
-- INSERT           VS    UPDATE
-- 새로운 데이터 삽입  vs    기존 데이터를 변경해서 저장(=갱신)

-- UPDATE 테이블명
-- SET 컬럼명=값
-- WHERE 조건절        :    where 조건절 생략시 모든 행이 변경대상
-- COMMIT or ROLLBACK;
-- UPDATE 구문 + 다중컬럼 서브쿼리 : 테이블의 여러 행의 컬럼을 한번에 업데이트할때 좋다!
SELECT *
FROM    employees;

UPDATE employees
SET salary = ( SELECT MIN(salary) FROM employees );

ROLLBACK;


[예제8-8] 사번이 300번 이상인 사원의 부서코드를 20으로 변경하시오

rollback;
UPDATE emp
SET dept_id = 20
--WHERE   emp_id >= 300; -- 조건에 일치하는 행(row)의 컬럼 데이터를 갱신

[예제8-9]emp테이블에서 사번이 300번인 사원의 급여, 커미션 백분율, 업무코드를 변경하시오
-- 급여는 2000, 커미션백분율은 0.1로, 업무코드는 IT_PROG

UPDATE emp
SET salary=2000,
    comm_pct=0.1,
    job_id='IT_PROG'
WHERE   emp_id=300;    
    
SELECT * FROM emp;
COMMIT;
[예제8-10] emp 테이블의 모든 사원들의 salary를 5000, 보너스 백분율을 0.4로 변경하여 저장하시오
UPDATE emp
SET salary=5000,
    comm_pct=0.4;
        

[예제8-11] 서브쿼리를 이용해서 emp 테이블의 103번 사원의 급여를 employees 테이블의 20번 부서의 최대 급여로 변경
하시오

-- I. 일반쿼리
SELECT  MAX(salary)
FROM    employees
WHERE   department_id = 20; -- 13000

UPDATE emp
SET salary = 13000
WHERE   emp_id = 103; -- 0개 업데이트 / 103번 사원이 : 9000 --> 13000 으로 (진급?)

INSERT INTO emp
SELECT  employee_id, first_name, last_name, hire_date, job_id, salary, commission_pct, department_id
FROM    employees
WHERE   employee_id = 103;

SELECT * FROM   emp;

-- II.서브쿼리로 데이터를 변경
-- 사용위치 따라 : SELECT절(=스칼라), FROM절(=인라인뷰), WHERE절 (=일반적인 서브쿼리)
-- 연관성(JOIN연산) 유무 : 상호연관 서브쿼리
-- 결과행 : (단일 컬럼)단일 행, (단일 컬럼)다중 행, (다중 행)다중 컬럼
ROLLBACK;

UPDATE emp
SET salary = (  SELECT  MAX(salary)
                FROM    employees
                WHERE   department_id = 20 )
WHERE   emp_id = 103;

[예제8-12] emp 테이블의 사번 180번 사원과 같은 해에 입사한 사원들의 급여를 employees 테이블 50번 부서의 평균
급여로 변경하는 쿼리를 작성하시오


UPDATE emp
SET = (50번 부서의 평균 급여)
WHERE   입사일이 180번 사원과 같은 해

-- I.일반쿼리
SELECT ROUND(AVG(salary))
FROM    employees
WHERE   department_id = 50; -- 3476

SELECT TO_CHAR(hire_date, 'yyyy') -- 2006
FROM    employees
WHERE   employee_id = 180
--COMMIT;
UPDATE emp
SET salary = 3476
WHERE   TO_CHAR(hire_date,'yyyy') = '2006';

-- II.서브쿼리를 사용한다면?
ROLLBACK;

UPDATE emp
SET salary = (  SELECT ROUND(AVG(salary))
                FROM    employees
                WHERE   department_id = 50  )
WHERE   TO_CHAR(hire_date,'yyyy') = (   SELECT TO_CHAR(hire_date, 'yyyy') -- CHAR
                        FROM    employees
                        WHERE   employee_id = 180   ); --24 rows
--SELECT 1 + '1'
--FROM    dual;

SELECT *
FROM    emp;
/*
TRUNCATE TABLE emp;

INSERT INTO emp
SELECT employee_id, first_name, last_name, hire_date, job_id, salary, commission_pct, department_id
FROM    employees;
*/

[예제8-14] 다중컬럼 서브쿼리로 month_salary의 모든 행의 컬럼 데이터를 업데이트 하시오
SELECT *
FROM    month_salary;
TRUNCATE TABLE month_salary;
-- ※ 기존의 month_salary의 데이터 삭제는 TRUNCATE TABLE emp; 후에~
-- I. magam_date, dept_id 를 먼저 INSERT
INSERT INTO month_salary (magam_date, dept_id)
SELECT  LAST_DAY(SYSDATE), department_id
FROM    employees
WHERE   department_id IS NOT NULL
GROUP BY    department_id;

SELECT *
FROM    month_salary;
-- II. 다중컬럼 서브쿼리를 이용해서 emp_cnt, sum_sal, avg_salary UPDATE
-- 단, UPDATE는 다중컬럼 서브쿼리로 작성하시오
UPDATE month_salary m
SET (emp_cnt, sum_salary, avg_salary) = (   SELECT  COUNT(*), SUM(e.salary), ROUND(AVG(e.salary))
                                            FROM    employees   e
                                            WHERE   e.department_id = m.dept_id
                                            GROUP BY e.department_id )
--WHERE                                            

COMMIT;

-- 8.3 DELETE / 데이터 삭제
-- 조건에 명시된 데이터 행(row)을 삭제하는 명령
/*
    DELETE FROM 테이블명
    WHERE   조건절
*/

-- ※ WHERE 절 생략시 모든 데이터(=레코드) 삭제
-- ROLLBACK 으로 트랜잭션 처리 이전으로 돌아가기!!

[예제8-15] emp 테이블의 60번 부서의 사원 정보를 삭제하시오
SELECT *
FROM    emp
WHERE   dept_id = 60; -- 총 107명, 60번 부서원은 5명

DELETE FROM emp
WHERE dept_id = 60;

ROLLBACK;

[예제8-16] emp 테이블에서 모든 데이터를 삭제하시오
DELETE FROM emp;
-- 102개 행 이(가) 삭제되었습니다


TRUNCATE TABLE emp;
-- Table EMP이(가) 잘렸습니다. (테이블의 구조는 남기고, 데이터는 삭제 <---> 비움)



-- 9장. DDL
-- Database Definition Language, 데이터베이스 정의 언어
-- 테이블, 뷰등의 데이터베이스 객체를 생성,변경,삭제 하는 명령어
-- SQL : Structured Query Language --> 에스큐엘, 시퀄
-- 0) DQL : SELECT
-- 1) DML : INSERT, UPDATE, DELETE
-- 2) DDL : CREATE, ALTER, DROP
-- 3) DCL : COMMIT, ROLLBACK


-- I.데이터베이스 객체 > 개발자가 프로젝트에서는 만듦 : 테이블
-- 1) 새 테이블 생성과 구조 정의 (=컬럼)
--CREATE TABLE 테이블명 (
--    컬럼명 데이터타입(BYTE길이) 제약조건,
--    ....등등..
--);

-- 2) CTAS : 다른 테이블의 조회된 데이터를 참조해서 (=복사하듯 기존 테이블의 구조와 데이터를 가져와서 생성)
--CREATE TABLE 테이블명 AS 
-- SELECT   컬럼1, 컬럼2,...
-- FROM     참조테이블명
-- WHERE    조건절
-- 제약조건중 일부 복사(NN)되었으나 PK,FK등은 복사 안되었음

DESC departments;
-- =============== 특정 테이블에 정의된 제약 조건을 조회하는 명령 ====================
-- 이름 : 관계(PK-FK : 식별관계, JOIN 연산)
-- A테이블의 PK를 B 테이블에서 FK로 사용하는 관계 : 식별관계 (종속적인, 수직, 상하 관계)
SELECT  *
FROM    user_constraints
WHERE   table_name='EMPLOYEES';
-- =============================================================================

9.1 데이터 타입
1) 문자형 : 고정문자 vs 가변문자
1-1) 고정문자
- CHAR(n) : n 바이트 길이의 고정된 문자데이터 타입
   └ 영문 1자 : 1byte
- CHAR(char n) : n개의 문자로 고정하는 문자데이터 타입   
- NCHAR(n) : National CHAR(n) : 지역별로 다른 n 바이트 길이를 갖는 문자데이터
   └ 한글 1자 :  3~4 byte로 셋팅 [Oracle 판단]

1-2) 가변문자 : 바캐릭터2 vs 바차2
- VARCHAR(n) <---> 오라클에서 사용금지 : 다른 용도로 사용할 계획이라서, 가변문자는 VARCHAR2를 사용할 것!
- VARCHAR2(n) :  n 바이트 길이
- NVARCHAR2(n) :  National VARCHAR2(n)
※ sqlDeveloper > 메뉴 > 도구 > 환경설정 > 데이터베이스 > NLS > 길이 : BYTE 로 되어있음
   
   
2) 숫자형 : 정수 vs 소수
    - NUMBER : 제한x
    - NUMBER(9,2) : 소수부 2, 정수부 7자, 총 9자
3) 날짜형 : DATE
SELECT SYSDATE, SYSTIMESTAMP
FROM    dual;
4) LOB, BLOB, LONG, RAW, ...개발자가 사용하지 않는 타입들
-- Double, Float 타입 --> 오라클에서는 NUMBER로 처리


-- ===============================
--  테이블 생성 규칙
-- ===============================
-- 반드시 문자로 시작
-- 숫자도 사용 가능(문자+숫자)
-- 최대 30바이트(11g 기준, 21c라면, 256바이트 제한)
-- 오라클 예약어를 사용할 수 없음
-- =======================================================
-- 시스템이 사용하는 예약어(Keyword)로는 객체를 생성할 수 없음.
-- =======================================================
-- SYSTEM 계정으로 변경해서 실행해볼것 (권한)
-- Oracle 버전마다 갯수가 다름 : 21c는 2555개
SELECT  keyword
FROM    v$reserved_words
ORDER BY 1;

-- 그럼에도 불구하고 꼭 사용해야하는 예약어는 "예약어" 형태 (큰따옴표로 묶어서)


[예제9-1] TMP 라는 테이블은 3byte 숫자 id 컬럼과 20byte 문자 fname 컬럼으로 이루어진 테이블이다. 이것을
생성하는 SQL을 작성하시오
CREATE TABLE TMP (
    id NUMBER(3),
    fname VARCHAR2(20)
);

[예제9-2]-- 홍길동 데이터 삽입
INSERT INTO TMP
VALUES (1, '홍길동');

[예제9-3] 홍길동을 홍명보로 1번 선수를 변경
UPDATE TMP
SET fname='홍명보'
WHERE   id=1;

-- 삭제하세요
DELETE FROM TMP; -- ROLLBACK, COMMIT을 수동
--TRUNCATE TABLE TMP -- AUTO COMMIT;

COMMIT;

























