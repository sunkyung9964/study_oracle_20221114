-- 10장. 제약조건
-- 무결성 제약조건 : 데이터의 정확성을 보장하기 위한 제약조건 , 5가지 제약조건
-- 테이블에 잘못된 데이터가 삽입되지 않도록 일정한 규칙을 주는 것

-- 1) NOT NULL : NULL 값을 허용하지 않는 조건, NULL 데이터 입력시 오류발생!!
-- 2) CHECK : 데이터를 체크(ex. 나이, 금액, 성별..) / 도메인
-- 3) UNIQUE : 유일하게 식별하는 값을 입력받을 수 있게, 단 NULL 허용 --> 중복된 데이터는 입력시 오류발생!
-- 4) PRIMARY KEY : 유일하게 식별하는 식별자로 NOT NULL + UNIQUE 제약조건
-- 5) FOREIGN KEY : 다른 테이블의 PK를 참조하는 제약조건
--    DEFAULT : 데이터 입력시 기본으로 지정된 조건 (ex. SYSDATE)

-- ※테이블을 생성하면서 정의하거나, 또는 테이블 생성 이후에 정의하는 방법이 있다.

SELECT OWNER, CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM    user_constraints
WHERE   OWNER='HR';
-- SYS_CXXXXX 형식의 제약조건은 시스템이 이름 대신 번호개념으로 지정한 제약조건 형식
-- 사용자가 직접 제한하는 제약조건은 대게 데이터와 관련된 적당한 네이밍이 있어서, 제약조건을 파악하기 수월함.


10.1 NOT NULL
-- 1) 테이블 생성시 제약조건 정의
[예제10-1] nulltest 라는 테이블을 생성하고 col1 에 NOT NULL 제약조건을 추가하시오
CREATE TABLE nulltest (
    col1 VARCHAR2(5) NOT NULL, -- 컬럼 레벨에서 정의
    col2 VARCHAR2(5)
);
-- HR	SYS_C008435	C	NULLTEST

[예제10-2] nulltest 테이블에 데이터를 입력하시오
INSERT INTO nulltest (col1)
VALUES ('AA');
INSERT INTO nulltest (col1)
VALUES ('가나다');
INSERT INTO nulltest (col1)
VALUES ('12345');

SELECT *
FROM    nulltest;

[예제10-3] nulltest 테이블의 col2에 문자열 BB를 입력하시오
INSERT INTO nulltest (col2)
VALUES ('BB');


-- 2) 테이블 생성후 제약조건 추가
-- 데이터가 삽입되기 전에 변경을 해야 한다.
-- ALTER TABLE 명령문을 사용하여 컬럼에 NULL 데이터가 없는 경우, NOT NULL을 추가할 수 있다.
UPDATE nulltest 
SET col2='BB';

[예제10-4] nulltest 테이블의 col2에 NOT NULL 제약조건을 추가하시오
ALTER TABLE nulltest
MODIFY (col2 NOT NULL);


-- 10.2 CHECK 제약조건
-- 조건에 맞는 데이터만 저장할 수 있게 하는 제약조건 (ex. EMPLOYEES 테이블의 salary > 0)
-- 도메인 : 테이블에 입력할수 있는 데이터의 종류, 값의 범위
-- 1) 테이블 생성시 제약조건 정의 - 컬럼 레벨에서 정의
[예제10-6] check_test 테이블을 생성하면서 check 제약조건을 정의하시오
CREATE TABLE check_test (
    name VARCHAR2(10) NOT NULL,
    gender VARCHAR2(10) NOT NULL CHECK (gender IN('남성','여성','남','여','M','F','m','f')), --컬럼 레벨
    salary NUMBER(8),
    dept_id NUMBER(4),
    CONSTRAINT check_salary CHECK(salary > 2000) -- 테이블 레벨
    -- 너무 길지 않게, 하지만 간단하고 명료하게 , 일정한 규칙을 사전에 정해서 작성하는게 좋다.
);

DESC check_test;

[예제 10-7] 홍길동 사원의 정보를 check_test 테이블에 아래와 같이 입력하시오
INSERT INTO check_test 
VALUES ('홍길동','남성',3000,0001);
INSERT INTO check_test 
VALUES ('이순신','남성',2100,0002);
INSERT INTO check_test 
VALUES ('장보고','M',2500,0003);

-- 2) 테이블 생성후에 제약조건 추가
-- 2-1) 테이블 생성시 컬럼 레벨에서 정의한 제약조건을 먼저 삭제
ALTER TABLE check_test
DROP CONSTRAINT check_salary;

-- check_salary 또는 check_salary_ck 삭제되었나 확인


-- 2-2) 테이블 생성후 제약조건을 먼저 추가
ALTER TABLE check_test
ADD CONSTRAINT salary_ck CHECK (salary > 2000);

-- 제약조건이 잘 추가되었나 확인
/*
SYS_C008437	C	CHECK_TEST
SYS_C008438	C	CHECK_TEST
SYS_C008439	C	CHECK_TEST
SALARY_CK	C	CHECK_TEST
*/

INSERT INTO check_test
VALUES ('장보고', '남', 2400, 100);

SELECT *
FROM    check_test;


10.3 UNIQUE  제약조건
-- 데이터의 중복을 허용하지 않는 (=중복되지 않도록) 유일성을 보장하는 제약조건
-- NULL은 허용
-- PK (=Primary Key) = UNIQUE + NOT NULL
-- 복합키(=Composite Key)를 생성할 수 있다.
-- 1) 테이블 생성시 컬럼레벨, 테이블레벨에서 정의
[예제10-13] UNIQUE_TEST 테이블을 생성하고 제약조건을 제약조건을 정의하시오
CREATE TABLE unique_test (
    col1 VARCHAR2(5) UNIQUE NOT NULL, -- 컬럼 레벨
    col2 VARCHAR2(5),
    col3 VARCHAR2(5) NOT NULL,
    col4 VARCHAR2(5) NOT NULL,
    CONSTRAINT uni_col2_uk UNIQUE (col2), -- 테이블 레벨
    CONSTRAINT uni_col34_uk UNIQUE (col3, col4) -- 테이블 레벨, 복합 키
);

[예제10-14]
INSERT INTO unique_test
VALUES ('A1', 'B1', 'C1', 'D1');
INSERT INTO unique_test
VALUES ('A2', 'B1', 'C1', 'D1'); -- ORA-00001: 무결성 제약 조건(HR.SYS_C008445)에 위배됩니다
INSERT INTO unique_test
VALUES ('A2', 'B2', 'C2', 'D2');
INSERT INTO unique_test
VALUES ('A3', '', 'C3', 'D3');
INSERT INTO unique_test
VALUES ('A4', NULL, 'C4', 'D4');

SELECT * FROM unique_test;
INSERT INTO unique_test
VALUES ('A5', 'B5', 'C3', 'D5');

-- 2) 테이블 생성 후 추가
-- 2-1. 테이블 생성시 정의된 제약조건을 먼저 삭제
ALTER TABLE unique_test -- 대상 테이블
DROP CONSTRAINT uni_col2_uk; -- 제약조건명

SELECT *
FROM    unique_test;
-- col2에 중복된 데이터를 삽입
INSERT INTO unique_test
VALUES ('A6', 'B5', 'C6', 'D6');
INSERT INTO unique_test
VALUES ('A7', 'B2', 'C7', 'D7');

ALTER TABLE unique_test -- 대상 테이블
DROP CONSTRAINT uni_col34_uk;

INSERT INTO unique_test
VALUES ('A8', 'B5', 'C1', 'D1');

INSERT INTO unique_test
VALUES ('A9', '', 'C2', 'D2');

-- 2-2. 다시 uni_col2_uk를 추가 / uni_col34_uk
-- 이미 입력된 데이터가 해당 컬럼에서 unique 해야 함, 그렇지 않으면 오류 발생!
ALTER TABLE unique_test
ADD CONSTRAINT uni_col2_uk UNIQUE (col2);

ALTER TABLE unique_test
ADD CONSTRAINT uni_col34_uk UNIQUE (col3, col4);

-- ORA-02299: 제약 (HR.UNI_COL2_UK)을 사용 가능하게 할 수 없음 - 중복 키가 있습니다
-- 02299. 00000 - "cannot validate (%s.%s) - duplicate keys found"

-- 부득이하지만,..모든 데이터를 삭제
TRUNCATE TABLE unique_test;


-- 10.4 PRIMARY KEY / 주 키, 주식별자
-- 테이블 내의 데이터를 유일하게 식별하는 제약조건
-- 2개 이상의 컬럼을 사용해서 복합키 지정가능
-- 1) 테이블 생성시 컬럼레벨, 테이블 레벨에서 정의
CREATE TABLE dept_test (
    dept_id NUMBER(4),
    dept_name VARCHAR2(30) NOT NULL, -- 컬럼레벨
    CONSTRAINT dept_test_id_pk PRIMARY KEY (dept_id) -- 테이블 레벨
);

[예제10-22] 10번 부서 영업부의 정보를 dept_test 테이블에 입력하시오
INSERT INTO dept_test
VALUES (10, '영업부');
INSERT INTO dept_test
VALUES (10, '개발부');
INSERT INTO dept_test
VALUES ('', '개발부');
INSERT INTO dept_test
VALUES (NULL, '개발부');

-- 2) 테이블 생성 후 추가
-- 2-1. 기존 dept_test_id_pk 제약조건을 삭제
ALTER TABLE dept_test
--ADD CONSTRAINT
DROP CONSTRAINT dept_test_id_pk;


SELECT constraint_name, constraint_type, table_name
FROM    user_constraints
WHERE   table_name='DEPT_TEST'; -- 소문자로 테이블명 작성시 조회가 제대로 안되는 경우가 있음.
-- 2-2. 다시 id_pk 라고 제약조건을 추가
-- 이미 데이터가 있다면, 추가하려면 PK 제약조건에 위배되지 않는지 확인 --> UPDATE / DELTE / TRUNCATE
-- 데이터가 없을때 제약조건을 추가하는게 안전

ALTER TABLE dept_test
ADD CONSTRAINT id_name_complex_pk PRIMARY KEY (dept_id, dept_name); -- 복합키
-- (모델링) 용어사전이 없다면, 30자정도 이내에서 제약조건명을 정하는 규칙을 만들어서 사용하면 됨.


-- 10.5 FOREIGN KEY / 참조키, 외래키, FK
-- 모델링 : 개념 -> 논리 : PK,FK, 관계정의, 엔터티와 속성을 정의, 데이터타입 결정 -> 물리
-- 종속적인 관계, 수직관계 ==> 부모, 자식   vs   상사, 부하   vs  부품,  부속
-- 부모 테이블의 컬럼을 참조하는 자식테이블의 컬럼에 데이터의 무결성을 보장하기 위해 지정하는 제약조건,
-- NULL 허용한다.
-- 컬럼레벨, 테이블 레벨에서 정의하고 테이블 생성 후 추가할 수 있다.
-- 복합키를 생성할 수 있다.

-- 1) 테이블 생성시 정의(=컬럼레벨, 테이블 레벨)
[예제10-26] emp_test 라는 테이블에 사번, 이름, 부서코드, 업무코드 컬럼을 정의하고 departments 테이블의 부서코드를
                    -- employee_id vs emp_id vs id,...
참조하는 제약조건을 정의하시오
desc emp_test;
select *
from departments;

CREATE TABLE emp_test (
    emp_id NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(30) NOT NULL,
    --dept_id NUMBER(4) REFERENCES departments (department_id) -- 컬럼 레벨에서 정의(1)
    --dept_id NUMBER(4) CONSTRAINT dept_id_fk REFERENCES departments (department_id) -- 컬럼 레벨에서 정의(2)
    dept_id NUMBER(4),
    job_id VARCHAR2(10),
    CONSTRAINT emp_test_dept_fk FOREIGN KEY (dept_id) REFERENCES departments (department_id) -- 테이블 레벨에서 정의
);

SELECT constraint_name, constraint_type, table_name
FROM    user_constraints
WHERE   table_name='EMP_TEST';

-- departments 테이블 : 10 ~ 270 (부서코드)
INSERT INTO emp_Test
VALUES (100,'홍길동',10, 'SA_CLERK');
INSERT INTO emp_Test
VALUES (101,'김길동',1000, 'SA_CLERK');

COMMIT;



-- 2) 테이블 생성 후 추가
















