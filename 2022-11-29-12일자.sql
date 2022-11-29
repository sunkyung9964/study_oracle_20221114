-- 6장. 서브쿼리(Sub Query)
-- 서브쿼리란, SQL 문장 안에 있는 또다른 SQL문장을 뜻함
-- 1) 서브쿼리는 괄호로 묶어서 사용
-- 2) 메인쿼리 vs 서브쿼리 : ()로 묶인 부분


-- 6.1 단일 행 서브쿼리 : 서브쿼리 실행 결과가 하나의 결과 행을 반환하는 서브쿼리
-- 6.2 다중 행 서브쿼리 :         "          여러개의 결과 행을      "
-- 6.3 다중 컬럼 서브쿼리 :        "        둘 이상의 컬럼을         "
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


-- 6.1 단일 행 서브쿼리 
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





























