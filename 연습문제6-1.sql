[연습문제6-1]

--1. 급여가 가장 적은 사원의 사번, 이름, 부서코드, 급여를 조회하는 쿼리를 작성하시오
--단, 일반쿼리와 서브쿼리로 나누어서 작성해보시오

SELECT MIN(salary)
FROM    employees; -- 2100$

SELECT employee_id, first_name, department_id, salary
FROM    employees
WHERE   salary = 2100; -- 일반 쿼리, 1 rows

SELECT employee_id, first_name, department_id, salary
FROM    employees
WHERE   salary = ( SELECT MIN(salary)
                   FROM    employees ); -- 일반 쿼리, 1 rows

2. 부서명이 Marketing 인 부서에 속한 모든 사원의 사번, 이름, 부서코드, 업무코드를 조회하시오
SELECT  employee_id, first_name, department_id, job_id
FROM    employees
WHERE   department_id = ( SELECT department_id
                          FROM    departments
                          WHERE   department_name LIKE 'Marketing' );

desc employees;
desc departments; -- department_name : 부서명

SELECT department_id
FROM    departments
WHERE   department_name LIKE 'Marketing';


--3. 회사의 사장보다 더 먼저 입사한 사원들의 사번, 이름, 입사일을 조회하는 쿼리문을 작성하시오
--(단, 사장은 그를 관리하는 매니저가 없는 사원이다)
SELECT employee_id, first_name, hire_date
FROM    employees
WHERE   hire_date < ( SELECT hire_date
                      FROM    employees
                      WHERE manager_id IS NULL )
ORDER BY 1;                      




SELECT hire_date
FROM    employees
--WHERE manager_id IS NULL -- 03/06/17
ORDER BY 1;




