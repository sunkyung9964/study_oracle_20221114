-- 테이블 구조 조회
DESC 테이블명

-- 테이블 데이터 조회
SELECT 컬럼1, 컬럼2 
FROM 테이블

-- 테이블 데이터 조회 + 조건(=필터링)
SELECT 컬럼1, 컬럼2 
FROM 테이블
WHERE 조건들 나열...

-- SQL 조건절에 department_id [부서코드] 라는 컬럼, 비교연산자 (=), 상수값 80 으로 구성되어서 
-- 연산을 수행


/* ============================================
    조건절을 구성하는 항목의 분류 (p.5)
============================================ */

1) 컬럼, 숫자, 문자
2) 산술연산자(+, -, *, /), 비교 연산자(=, >=, <=, <, >, !=, <>), (문자)연결 연산자(||)
3) AND, OR, NOT : 논리 연산자
4) LIKE, IN, BETWEEN, EXISTS, NOT
5) IS NULL, IS NOT NULL
6) ANY, SOME, ALL
7) 함수(어떤 작업을 수행하는 명령어의 단위)  (vs 프로시저)


2.3 연산자
2.3.1 산술연산자 : +, -, *, /
-- SELECT 절, WHERE 절에 사용함.
SELECT 2 + 2, 2 - 1, 2 * 3, 4 / 2
FROM dual; -- dual : 가짜 테이블 (=실제 존재하지 않는 가상의 테이블인 dual로 연산 처리)

[예제2-4] 80번 부서 사원의 한 해 동안 받은 급여(=연봉)을 조회하시오
-- 사원들의 정보는 EMPLOYEES 라는 테이블에 저장되어 있음.
-- 사원이 근무하는 부서의 정보는 DEPARTMENTS 라는 테이블에 저장되어 있음.
SELECT  employee_id emp_id, last_name, salary * 12 "Annual Salary" -- 별칭(=Alias, 별명)
FROM    employees
WHERE   department_id = 80; -- 34 rows, 34명이나 근무하는 80번 부서는 무슨일을 하는 곳일까? SALE(=판매부서)

--SELECT department_id, department_name, manager_id
--FROM departments
--WHERE department_id = 80;

[예제2-5] (전체 사원들 중) 한 해 동안 받은 급여가 120000인 사원을 조회하시오
-- 전체 사원을 조회
-- * : aesterisk, 만능문자 / 모든 문자열을 대체 (= 모든 컬럼을 뜻함. 사번~ 부서코드까지)
SELECT *
FROM    employees
WHERE   salary*12 = 120000; -- salary는 월급여 <---> 12000은 연봉(=한 해동안 받은 급여)


2.3.2 연결 연산자 : ||
-- ex. 이름과 성을 연결해서 이름/성명 이라는 컬럼으로 조회할때
SELECT employee_id, last_name, salary * 12 "Annual Salary" -- 별칭
FROM employees;

SELECT employee_id, first_name ||' '||last_name full_name -- 연결 연산자 vs CONCAT() 함수 : 뒤에 나옵니다.
FROM employees;

[예제2-6] 사번이 101번인 사원의 성명을 조회하시오
-- 여기서 성명은 이름+성의 조합, 흔히 FullName 이라고 함.

SELECT  'oracle' company, employee_id 사번, first_name ||' '|| last_name 성명, department_id 부서, manager_id 매니저번호
FROM    employees
WHERE   employee_id = 101;

-- 별칭(=Alias)은 컬럼의 별명 ==> AS는 생략가능, Option!
-- 1) 공백을 두고 사용한다. ex> 컬럼명 별칭Alias명
-- 2) 키워드로는 AS 또는 as를 사용한다. ex> 컬럼명 AS 별칭   또는  컬럼명 as 별칭
-- 3) 별칭에 공백이 있으면 큰 따옴표(")로 묶어서 사용한다.   ex>salary * 12 [AS] "Annual Salary"


[예제 2-8] 사번이 101인 사원의 정보중 사번, 성명, 연봉, 부서코드를 조회하시오
SELECT  'hanul' company, employee_id, first_name ||' '||last_name , salary * 12 AS "Annual Salary", department_id
FROM    employees
WHERE   employee_id = 101;

2.3.3 비교 연산자 (=, >, >=, <, <=)
-- 값을 비교 : 문자, 숫자 비교

[예제2-9] 급여가 3000 이하인 사원의 정보중 사번, 성, 급여, 부서코드를 조회하시오
SELECT employee_id emp_id, last_name, salary, department_id dept_id
FROM    employees
WHERE   salary <= 3000;

-- 10번 ~ 270번 : 총 27개의 부서를 갖는 회사
-- 20번 부서 : Marketing (마케팅 부서)
-- 30번 부서 : Purchasing (구매 부서)
-- 50번 부서 : Shipping (배송 부서)
-- 80번 부서 : Sales (판매 부서)
-- ※ 부서코드는 10씩 증가하면서 다른 부서코드를 식별
SELECT *
FROM    departments
WHERE   department_id = :num; --바인드 변수, PL/SQL 파트에서!!

[예제2-10] 부서코드가 80번 초과인 사원의 정보를 조회하시오
-- 부서코드가 80번을 초과하는 부서에 소속된 사원의 정보
SELECT employee_id emp_id, last_name, salary, department_id dept_id
FROM    employees
WHERE   department_id > 80;





