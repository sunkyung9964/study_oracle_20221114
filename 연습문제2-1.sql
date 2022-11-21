--1
SELECT employee_id, first_name||''||last_name full_name
FROM employees
WHERE employee_id = 200;

SELECT employee_id, first_name||''||last_name full_name, salary
FROM employees
--WHERE NOT salary BETWEEN 3000 AND 15000;
WHERE salary < 3000
OR salary > 15000;

SELECT  employee_id, first_name, department_id, salary
FROM employees
WHERE department_id = 30
OR    department_id = 60;
ORDER BY first_name ;



