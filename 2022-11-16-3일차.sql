-- 테이블명

-- 




*/
1) 컬럼, 숫자, 무자
2) 산술연산자 : +, -, *, /, 비교연산자 : =, >=, <=, <, >, !=, <>, (문자)연결 연산자 : ||
3) AND, OR, NOT : 논리 연산자
4) LIKE, IN, BETWEEN, EXISTS, NOT
5) IS NULL, IS NOT NULL,
6) ANY, SOME. ALL
7) 함수(어떤 작업을 수행하는 명령어의 단위) (vs 프로시저)*/

2.3 연산자
2.3.1
SELECT 2 + 2
FROM dual;

[예2-4] 80번 부서 사원의 한 해 동안 받은 급여(=연봉)을 조회하시오
-- 사원들의 정보는 EMPLOYEES 라는 테이블에 저장되어 있음.
-- 사원이 근무하는 부서의 정보는 DEPARTMENTS 라는 테이블에 저장되어 있음.

SELECT employee_id 사번, last_name 성, salary * 12 -- 별칭(=Alias, 별명)
FROM employees
WHERE department_id = 80; 

SELECT * department_id, department_name, manager_id
FROM departments;
WHERE department_id = 80;


[예제2-5] (전체 사원들 중)한 해 동안 받은 급여가 120000인 사원을 조회하시오
-- 전체 사원을 조회
-- * : aesterisk, 만능문자 / 모든 문자열을 대체

SELECT *
FROM employees
WHERE salary*12 = 120000;-- salary는 월급여



