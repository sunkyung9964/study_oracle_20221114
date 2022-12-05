--[연습문제8-1]

--1. EMP 테이블에서 다음과 같은 데이터 행을 저장한다.
SELECT * FROM EMP;

INSERT INTO EMP (emp_id, fname, lname, hire_date, salary, job_id)
VALUES (400, 'Johns', 'Hopkins', TO_DATE('08/10/15','RRRR/MM/DD'), 5000, 'IT_DEV');
INSERT INTO EMP (emp_id, fname, lname, hire_date, salary, job_id)
VALUES (401, 'Abraham', 'Lincoln', TO_DATE('2010/03/03','YYYY/MM/DD'), 12500, 'IT_DEV');
INSERT INTO EMP (emp_id, fname, lname, hire_date, salary, job_id)
VALUES (402, 'Tomas', 'Edison', TO_DATE('13/10/15','YYYY/MM/DD'), 6300, 'IT_DEV');

-- 현재 시스템의 NLS 정보
SELECT *
FROM    v$nls_parameters;

-- date format 변경 (=일시적, 다음번  접속시 또 실행해야 바뀜)
ALTER SESSION SET NLS_DATE_FORMAT = 'RRRR/mm/dd';


--2. EMP 테이블에서 사번 401번 사원의 부서코드를 90, 업무코드를 SA_MAN으로 변경하고 데이터행의 저장을 확정한다.
UPDATE emp
SET dept_id = 90,
    job_id='SA_MAN' -- 각 컬럼은 ,로 구분하고 변경하려는 값은 =로 표시
WHERE   emp_id=401; -- 1rows updated


SELECT * FROM EMP;
-- 3. EMP 테이블의 급여가 8000 미만인 모든 사원의 부서코드는 80으로 변경하고, 급여는 EMPLOYEES 테이블의
-- 80번 부서의 평균 급여를 가져와 변경한다.
-- 단, 평균급여는 반올림된 정수를 사용한다.
UPDATE  emp
SET dept_id = 80,
    salary = (  SELECT ROUND(AVG(salary))
                FROM    employees
                WHERE   department_id = 80  )
WHERE   salary < 8000; -- 2rows updated

SELECT * FROM EMP;
-- 4. EMP 테이블에서 2010년 이전에 입사한 사원의 정보를 삭제하시오
-- Tomas Edison의 hire_date를 YYYY/MM/DD 형식에 맞춰 업데이트 선행!! (RR과 YY 형식비교를 위한 데이터)
UPDATE  emp
SET hire_date = TO_DATE('2013/10/15','YYYY/MM/DD')
WHERE   emp_id = 402; 

SELECT * FROM EMP;

DELETE emp
WHERE   TO_CHAR(hire_date, 'YYYY') < '2010'; -- 400 Johns Hopkins 행이 삭제됨, 1rows


ROLLBACK;

