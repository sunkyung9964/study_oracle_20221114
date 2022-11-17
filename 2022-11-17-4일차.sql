-- 2장. 데이터 조회 구문
/*
DML : SELECT, INSERT, UPDATE, DELETE
DDL : CREATE, ALTER, DROP
DCL : GRANT, REVOKE, TRUNCATE
*/

-- 2.1 SELECT 구문
SELECT 컬럼1, 컬럼2
FROM employees;


SELECT *
FROM employees;

-- 2.2 SELECT 구문 + 조건절(=필터링) : 특정 조건에 맞는 데이터만 조회
SELECT employee_id, first_name, department_id
FROM employees
WHERE department_id = 100;


-- 자동서식 적용 : 원하는 쿼리를 블럭 씌운 후 CTRL+F7(=자동 서식이 적용)
-- TAB 자주 사용!

-- 2.3.3 비교 연산자
-- 숫자비교
-- 문자비교(p.7)
[예제2-11] 성이 king인 사원의 정보를 조회하시오
-- last name이 king 인지 비교!!(=같다, 크다, 작다..)

SELECT  employee_id 사번, last_name 성, department_id 부서
FROM    employees
//WHERE   last_name = 'King';
WHERE   last_name = 'king';


[예제2-12] 입사일이 2004년 1월 1일 이전인 사원의 정보(=사번, 이름, 입사이브
-- 입사부터 2003년 12월 31일까지
-- 범위 비교 : 이상,이하
SELECT *
FROM    employees 
WHERE   hire_date < '04/01/01';
-- ' ' : 작은 따옴표는 문자에이터, 시간,날짜 표기
-- " " : 큰 따옴표는 ??? 컬럼의 별칭(=Alias)을 지정할 때, 공백이 있는 단어를 조합할때 



SELECT SYSDATE
FROM dual;
