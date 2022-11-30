-- 6장. 서브쿼리(Sub Query)
-- 서브쿼리란, SQL 문장 안에 있는 또다른 SQL문장을 뜻함
-- 1) 서브쿼리는 괄호로 묶어서 사용
-- 2) 메인쿼리 vs 서브쿼리 : ()로 묶인 부분


-- 6.1 단일 행 (단일 컬럼) 서브쿼리 : 서브쿼리 실행 결과가 하나의 결과 행을 반환하는 서브쿼리
-- 6.2 다중 행 (단일 컬럼) 서브쿼리 :         "          여러개의 결과 행을      "
-- 6.3 (단일 / 다중 행)다중 컬럼 서브쿼리 :        "        둘 이상의 컬럼을     "
-- 6.4 상호 연관 서브쿼리 : 메인쿼리의 컬럼이 서브쿼리의 조건으로 사용되는 서브쿼리
-- 6.5 스칼라 서브쿼리 : SELECT 절에 사용되는 서브쿼리 (=컬럼)
-- 6.6 인라인 뷰 서브쿼리 : FROM 절에 사용되는 서브쿼리

-- ※ 서브쿼리는 어디든 올 수 있음, (보통 WHERE 절에 작성)
-- ※ 서브쿼리가 없어도 작업 처리는 가능! 사용이유) 처리속도 빠르고 효율적, 실무에서 서브쿼리를 사용!

[예제6-1] 평균 급여보다 더 적은 급여를 받는 사원의 사번, 이름, 성을 조회하시오

-- 1) 메인쿼리로 작성한다면?
-- 1-1) 평균 급여를 알아보자
SELECT  ROUND(AVG(salary)) avg_sal
FROM    employees; -- 6,462$

-- 1-2) 평균 급여보다 적은 급여를 받는 사원들의 정보를 알아보자
SELECT employee_id, first_name, last_name
FROM    employees
WHERE   salary <= 6462
ORDER BY 1; -- 56 rows

-- 2) 서브쿼리로 작성한다면? [SQL 안에 어느 위치라도 올수 있는 또다른 () 안의 SQL]
SELECT employee_id, first_name, last_name
FROM    employees
WHERE   salary <= ( SELECT  ROUND(AVG(salary))
                    FROM    employees )
ORDER BY 1; -- 56 rows
-- ============================================
-- 일반쿼리로 결과를 구하고 서브쿼리로 수정!!
-- ============================================


-- 6.1 단일 행 (단일컬럼) 서브쿼리 
-- 단일 행 연산자(=, >, >=, <, <=, <>, != ) 와 함께 사용한다.
-- 결과행이 하나이므로 그룹 함수 COUNT(), SUM(), AVG(), MAX(), MIN() 를 사용하는 경우가 많다
[예제6-2] 월 급여가 가장 많은 사원의 사번, 이름, 성 정보를 조회하시오

-- 1) 월급여 최고금액을 구해보기 <---> 월급여 최저금액
SELECT MAX(salary)                 -- MIN(salary)
FROM    employees; -- 24000$

-- 2) 월급여 최대치와 같은 급여를 받는 사원의 정보를 조회
SELECT  employee_id, first_name, last_name, salary
FROM    employees
WHERE   salary = 24000;

-- 서브쿼리로 바꾸어 표현한다면?
SELECT  employee_id, first_name, last_name, salary
FROM    employees
WHERE   salary = ( SELECT MAX(salary)
                   FROM    employees )
ORDER BY 1;                   


-- 월급여가 가장 적은 사원의 사번, 이름, 성 정보를 조회하시오
-- I. 일반쿼리
SELECT  MIN(salary)
FROM    employees; -- 2100$

SELECT employee_id, first_name, last_name
FROM    employees
WHERE   salary = 2100;

-- II. 서브쿼리
SELECT employee_id, first_name, last_name
FROM    employees
WHERE   salary = ( SELECT  MIN(salary)
                   FROM    employees );
                   
[예제6-3] 사번이 108인 사원의 급여보다 더 많은 급여를 받는 사원의 사번, 이름, 급여를 조회하시오
-- 108번 사원의 급여를 조회
SELECT  salary
FROM    employees
WHERE   employee_id = 108; -- 12,008$

-- 급여가 12,008$ 를 초과하는 사원의 정보를 조회
SELECT  employee_id, first_name, TO_CHAR(salary,'$99,999') salary
FROM    employees
WHERE   salary > 12008; -- 6 rows

-- 서브쿼리로 표현하면
SELECT  employee_id, first_name, TO_CHAR(salary,'$99,999') salary
FROM    employees
WHERE   salary > ( SELECT  salary
                   FROM    employees
                   WHERE   employee_id = 108 ); -- 6 rows


[예제 6-4] 월 급여가 가장 많은 사원의 사번, 이름, 성, 업무 제목 정보를 조회하시오

-- 월급여 최고금액
SELECT MAX(salary)
FROM    employees; -- 24,000$

-- 사번~업무제목 정보 : JOIN 연산 + 서브쿼리
-- ※ 업무제목은 JOB_TITLE (JOBS 테이블에 있음)
SELECT  e.employee_id, e.last_name, e.salary, 
        j.job_title
FROM    employees e, jobs j
WHERE   e.job_id = j.job_id -- 조인 조건절
AND     e.salary = ( SELECT MAX(salary)
                     FROM    employees );--일반 조건절


-- 6.2 다중 행 (단일 컬럼)서브쿼리 (p.53)
-- IN, NOT IN, ANY, ALL, EXISTS 와 함께 사용한다.

-- 6.2.1 IN 연산자
-- 여러개의 값이 존재할때 사용
SELECT  employee_id, first_name, job_id
FROM    employees
--WHERE   department_id IN (10, 30, 50); -- 일반쿼리에서 IN 연산자
WHERE   department_id = 10
OR  department_id = 30
OR  department_id = 50;

[예제6-5] 근무지(=위치코드)가 영국(=UK) 부서코드, 위치코드, 부서명 정보를 조회하시오
-- 다중 행 서브쿼리로 해결
SELECT  department_id, location_id, department_name
FROM    departments
WHERE   location_id IN ( SELECT location_id
                         FROM   locations
                         WHERE  country_id = 'UK' ); -- 40, 80번 부서

SELECT  *
FROM    departments
WHERE   location_id IN (2400, 2500, 2600);

SELECT  *
FROM    locations
WHERE   country_id = 'UK'; -- 2400, 2500, 2600의 location_id 확인


-- 미국에 위치한 부서의 정보(부서코드, 부서명, 위치코드)
SELECT *
FROM    locations
WHERE   country_id = 'US';

SELECT  department_id, location_id, department_name
FROM    departments
WHERE   location_id IN ( SELECT location_id
                         FROM   locations
                         WHERE  country_id = 'JP' ); -- 23 rows



-- 6.2.2 ANY 연산자
-- 서브쿼리 결과값 중 어느 하나의 값만 만족하면 되는 행을 반환한다.
[예제6-6] 70번 부서에 근무하는 부서원의 급여보다 높은 급여를 받는 사원의 사번, 이름, 부서번호, 급여를 조회하시오

SELECT  salary
FROM    employees
WHERE   department_id = 80 -- 34명이고, (MIN)6100~14000(MAX) 까지 분포
ORDER BY 1;

SELECT  employee_id, first_name, department_id, salary
FROM    employees
WHERE   salary > ANY ( SELECT  salary
                       FROM    employees
                       WHERE   department_id = 80 ) -- 54 rows
ORDER BY salary;                       
/* 원인 : 서브쿼리 결과행이 다중 행을 반환할때
ORA-01427: 단일 행 하위 질의에 2개 이상의 행이 리턴되었습니다.
01427. 00000 -  "single-row subquery returns more than one row"
--> > ANY 로 여러개의 결과행을 비교 연산 처리
*/

-- =========================================
-- > ANY 는   > 최소값(MIN) 으로 대체가능
-- =========================================

SELECT  employee_id, first_name, department_id, salary
FROM    employees
WHERE   salary >  ( SELECT  MIN(salary)
                    FROM    employees
                    WHERE   department_id = 80 ) -- 15 rows
ORDER BY salary;

[예제6-8] 10번 부서원의 급여보다 적은 급여를 받는 사원의 사번, 이름, 부서번호, 급여를 조회하시오
-- 부서별 인원 집계
SELECT department_id, COUNT(*)
FROM    employees
GROUP BY department_id
ORDER BY    1;


SELECT salary
FROM    employees
WHERE   department_id = 10; -- 4,400$

SELECT MIN(salary)
FROM    employees;

-- 서브쿼리
-- > ANY : MIN
-- < ANY : MAX
SELECT  employee_id, last_name, department_id, salary
FROM    employees
WHERE   salary < ANY ( SELECT salary
                       FROM    employees
                       WHERE   department_id = 80 )
ORDER BY 4;                  

-- =========================================
-- < ANY 는   < 최대값(MAX) 으로 대체가능
-- =========================================

SELECT  employee_id, last_name, department_id, salary
FROM    employees
WHERE   salary <  ( SELECT MAX(salary) -- 서브쿼리의 그룹함수 : 단일행 결과를 반환 (count,sum,max,min,avg...)
                    FROM    employees
                    WHERE   department_id = 80 )
ORDER BY 4 DESC;             


-- 6.2.3 ALL 연산자
-- ANY : 하나라도 일치하면
-- ALL : 모두 일치하면
-- 서브쿼리의 결과 값 모두에 만족하는 결과행을 반환한다.
[예제6-10] 100번 부서원 모두의 급여보다 높은 급여를 받는 사원의 사번, 이름, 부서번호, 급여를 
급여의 오름차순으로 정렬하여 조회하시오

SELECT salary
FROM    employees
WHERE   department_id = 100;

SELECT employee_id, last_name, department_id, salary
FROM    employees
WHERE   salary > ALL (SELECT salary
                  FROM    employees
                  WHERE   department_id = 100 ) -- 6900 ~ 12008
ORDER BY 4;

-- ================================
-- > ALL은 > 최대값(MAX)로 대체가능
-- ================================

[예제6-12] 30번 부서원 모두의 급여보다 적은 급여를 받는 사원의 사번, 이름, 부서번호, 급여를 급여 순으로 조회하시오
SELECT  salary
FROM    employees
WHERE   department_id = 30; -- 2500 ~ 11000


SELECT  employee_id, last_name, department_id, salary
FROM    employees
WHERE   salary < ALL ( SELECT  salary
                       FROM    employees
                       WHERE   department_id = 30 ); --5rows

/* 비교 연산자로 다중행 결과를 비교하려면 발생하는 오류!
ORA-01427: 단일 행 하위 질의에 2개 이상의 행이 리턴되었습니다.
01427. 00000 -  "single-row subquery returns more than one row"
--> ANY나 ALL 을 붙인다.
*/ 

-- ================================
-- < ALL은 < 최저값(MIN)로 대체가능
-- ================================

SELECT  employee_id, last_name, department_id, salary
FROM    employees
WHERE   salary < ( SELECT  MIN(salary)
                   FROM    employees
                   WHERE   department_id = 30 ); -- 5rows

--------------------------------------------
-- 서브쿼리 연산자     |    대체가능
--------------------------------------------
--   > ANY           |    MIN()
--   < ANY           |    MAX()
--   > ALL           |    MAX()
--   < ALL           |    MIN()
--------------------------------------------


-- p.56
-- = ANY : IN 연산자와 동일한 기능을 한다.
SELECT employee_id, last_name, department_id
FROM    employees
--WHERE   department_id IN (10, 20, 30); -- 9rows
--WHERE   department_id = ANY (10, 20, 30); -- 10번 부서원 이거나 20번 부서원 이거나 30번 부서원이면 (=OR)
WHERE   department_id = ALL (10, 20, 30); -- 10번 부서원 이면서 20번 부서원 이면서 30번 부서원이면(=AND)
                                          -- 오류는 발생하지 않지만, 10,20,30번 부서에 동시에 소속된 사원은 없음(말이 안되는 조건)
/*
ORA-01797: 연산자의 뒤에 ANY 또는 ALL을 지정해 주십시오
01797. 00000 -  "this operator must be followed by ANY or ALL"
*/

[예제6-14] 20번 부서원의 급여와 같은 급여를 받는 사원의 사번, 이름, 부서번호, 급여를 부서코드 순 / 급여 순으로 조회하시오
SELECT  employee_id, last_name, department_id, salary
FROM    employees
--WHERE   salary = ANY (13000, 6000);
--WHERE   salary IN (13000, 6000);
WHERE   salary = 13000
OR      salary = 6000;


SELECT salary
FROM    employees
WHERE   department_id = 20; -- Marketing

SELECT  department_name
FROM    departments
WHERE   department_id = 20;


-- ===============================
-- = ANY 는 IN 으로 대체 가능
-- ===============================

-- NOT IN <> ANY != ANY로 대체 불가능

-- NOT IN 연산자는 <> ALL 대체 가능
SELECT  employee_id, last_name, department_id, salary
FROM    employees
WHERE   department_id <> ANY (10, 20)
ORDER BY 3; -- 103 rows

-- =============================================================================
-- NOT IN 연산자를 <> ANY 로 변경하면 <---> 모든 부서를 조회한 것과 같은 결과가 추출
-- =============================================================================


-- 6.3 다중 컬럼 서브쿼리
-- 서브쿼리의 실행 결과가 여러 개의 컬럼을 반환하는 것
-- ★ UPDATE, DELETE, INSERT 시 한번에 여러 행의 컬럼 데이터를 변경하고자 할때

[예제6-18] 매니저가 없는 사원이 매니저로 있는 부서코드, 부서명을 조회하시오
-- manager_id IS NULL : 사장님  (사번 : 100, 부서코드 : 90, 급여 : 24000)
-- II.서브쿼리로 해결
SELECT  department_id, department_name
FROM    departments
WHERE   (department_id, manager_id) IN ( SELECT department_id, employee_id
                                         FROM   employees
                                         WHERE  manager_id IS NULL );

-- I.일반쿼리 3~4 단계
SELECT  employee_id
FROM    employees
WHERE   manager_id IS NULL; -- 사번 100이 manager_id가 NULL 즉, 사장님

SELECT  department_id
FROM    employees -- 사원테이블에서 조회하면~
WHERE   manager_id = 100; -- 14rows : 사장님이 직접 관리하는 사원 수

SELECT  department_id
FROM    departments -- 부서테이블에서 조회하면~
WHERE   manager_id = 100; -- 1 rows : 사장님이 소속된 부서코드와 이름

SELECT department_name
FROM    departments
WHERE   department_id = 90; -- Executive : 경영진, 경영부, 운영부, 관리부,...

select *
from    departments;

/* 
    다중컬럼 서브쿼리 예제  : 좀더 이해하기 위한~    
    EMPLOYEES 테이블 : 사원정보, 급여정보, 부서, ...
    
    매달 말 부서별로/사원별로 지급되는 급여에 대한 집계를 하고자 할때 ==> 테이블을 생성, 집계해서 추가/업데이트!
    --> 스케줄러 등록(PL/SQL)    
*/
-- 부서별로 월별 지급된 사원의 수, 급여 합계, 급여 평균, 급여 최고, 급여 최소..
-- 마감 : magam ==> 월별 집계/통계
-- 날짜 정보
-- 사원 수 정보
-- 급여 합계 정보
-- 급여 평균 정보
-- ...etc...

-- I. 월별 업무 마감시 사원들의 통계정보를 집계해서 저장할 테이블을 설계
CREATE TABLE month_salary (
    magam_date  DATE NOT NULL,
    dept_id NUMBER,
    emp_cnt NUMBER,
    sum_salary NUMBER, 
    avg_salary NUMBER(9,2)-- 급여평균, 총 9자, 소수점 이하 2자 vs 정수부 7자
);

DESC month_salary;

SELECT *
FROM    month_salary;

-- II. 부서별 집계 
-- 사원의 수
SELECT department_id, COUNT(*)
FROM    employees
GROUP BY department_id
ORDER BY 1;

-- 급여 합계
SELECT department_id, SUM(salary)
FROM    employees
GROUP BY department_id
ORDER BY 1;

-- 급여 합계
SELECT department_id, ROUND(AVG(salary))
FROM    employees
GROUP BY department_id
ORDER BY 1;

-- (매)달의 마지막 날짜
SELECT LAST_DAY(TO_DATE('22/10/01')) LAST_DATE
FROM   dual;

-- III. 실제 데이터를 삽입하자
-- ITAS : INSERT INTO 테이블 AS SELECT ~ 이하 [한번에 조회된 결과를 다른 테이블에 삽입하는 구문]
-- CTAS : CREATE TABLE 테이블 AS SELECT ~ 이하 [한번에 조회된 결과를 다른 테이블을 생성하여 삽입]
INSERT INTO month_salary (magam_date, dept_id)
SELECT  LAST_DAY(SYSDATE), department_id
FROM    employees
GROUP BY department_id
ORDER BY 2; -- 12 rows --> 삽입 성공

-- IV. 데이터 확인
SELECT *
FROM    month_salary;
--ROLLBACK;
-- V. 다중컬럼 서브쿼리로 EMP_CNT(사원수), SUM_SALARY(급여합), AVG_SALARY(급여평균)을 NULL인 값들을 갱신
UPDATE month_salary m
SET EMP_CNT=( SELECT    COUNT(*)
              FROM      employees e
              WHERE     e.department_id = m.dept_id
              GROUP BY  e.department_id ),              
    SUM_SALARY=( SELECT    SUM(salary)
                 FROM      employees e
                 WHERE     e.department_id = m.dept_id
                 GROUP BY  e.department_id ),
    AVG_SALARY=( SELECT    ROUND(AVG(salary))
                 FROM      employees e
                 WHERE     e.department_id = m.dept_id
                 GROUP BY  e.department_id );
--WHERE 조건절; -- 조건절 생략하면 모든 레코드가 업데이트 되므로 주의!!    

-- magam_date, dept_id에 입력한 데이터를 실제 저장공간에 저장 : 현재는 메모리에서 기억하고 있지만,..
COMMIT;

-- update 구문 연습
UPDATE employees
SET salary = 2009; -- 조건절을 생략 ==> 모든 레코드의 salary를 (체크 제약조건) 2008으로 업데이트 하는 결과

SELECT *
FROM EMPLOYEES;

--ROLLBACK;

-- VI. 최종적으로 업데이트된 부서별 사원수, 부서별 급여합계, 부서별 급여평균을 조회 (month_salary)
SELECT *
FROM    month_salary;

ROLLBACK;
-- VII. 12번 행의 null 값을 업데이트 하려면? (부서가 배정되지 않은 사원 Kimberely의 데이터를 업데이트 해보시오)
UPDATE month_salary
SET EMP_CNT = ( SELECT COUNT(*)
                FROM    employees
                WHERE   department_id IS NULL ),
    SUM_SALARY = (  SELECT SUM(salary)
                    FROM    employees
                    WHERE   department_id IS NULL ),
    AVG_SALARY = ( SELECT ROUND(AVG(salary))
                   FROM    employees
                   WHERE   department_id IS NULL )
WHERE   dept_id IS NULL;                   

-- kimberely의 정보를 조회
SELECT salary
FROM    employees
WHERE   department_id IS NULL;

-- IX. 최종 커밋
-- 메모리에 있는 데이터를 DBMS가 관리하는 저장공간에 (파일로) 저장
COMMIT;

SELECT *
FROM month_salary
WHERE   TO_CHAR(magam_date,'MONTH') = '11월'; -- 언어가 한글이라서 11이 아닌 11월로 조회 vs NOVEMBER

SELECT TO_CHAR(magam_date,'MM')
FROM   month_salary;


-- DBA 가 설계한 테이블에, 매달 말 자동으로 (스케쥴) 데이터를 집계하고 삽입과 업데이트를 실시해서 저장해두면,
-- 개발자는 사용자 또는 관리자가 사용할 수 있는 화면과 버튼을 만들어서, ex> 월별 급여통계 버튼 클릭시~ 테이블에
-- 데이터를 조회하고, 그래프나 차트로 변환한 화면을 [출력]하거나 [전송]하는 버튼을 눌러 원하는 기능을 수행하는
-- 프로그램을 제작할 수 있다.


-- 6.4 상호연관 서브쿼리
-- 대게는 JOIN 연산의 형식 ★
-- 메인 쿼리의 컬럼이 서브쿼리의 조건절에 사용되는 서브쿼리로, 메인 쿼리에 독립적이지 않는 형식이다.
[예제6-19] 매니저가 있는 부서코드에 소속된 사원들의 수를 조회하시오
-- 매니저가 없는 사람 : 사장님, 90번 경영부
-- 매니저가 있는 사람 : 사장님 제외 전원 (106명)


-- <서브쿼리 사용 위치에 따른 구분 >
-- 1.WHERE 절에 서브쿼리 : (일반적인) 서브쿼리
-- 2.SELECT 절에 서브쿼리 : 스칼라 서브쿼리
-- 3.FROM 절에 서브쿼리 : 인라인 뷰 서브쿼리

SELECT  COUNT(*) cnt
FROM    employees e
WHERE   department_id IN ( SELECT department_id
                           FROM   employees d
                           WHERE   manager_id IS NOT NULL
                           AND     e.department_id = d.department_id  )

--SELECT department_id
--FROM   employees
--WHERE   manager_id IS NOT NULL;

-- ==========================================
-- IN 연산자를 EXISTS 연산자로 대체 가능
-- ==========================================
SELECT  COUNT(*) cnt
FROM    employees e
WHERE   EXISTS ( SELECT SYSDATE
                           FROM   employees d
                           WHERE   manager_id IS NOT NULL
                           AND     e.department_id = d.department_id  );
/*
ORA-00920: 관계 연산자가 부적합합니다
00920. 00000 -  "invalid relational operator"
*/

