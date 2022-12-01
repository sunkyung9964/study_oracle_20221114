--[연습문제 6-4]
--
--1. 급여가 적은 상위 5명의 순위, 사번 , 이름, 급여를 조회하시오
--서브쿼리를 사용하여 작성해보시오

SELECT e.* --e라는 테이블의 모든 컬럼을 SELECT
FROM    (   
            SELECT  RANK() OVER (ORDER BY SALARY) "RANK",
                    DENSE_RANK() OVER (ORDER BY SALARY) "DENSE_RANK",
                    employee_id,
                    last_name,
                    salary
            FROM    employees                    
        ) e
WHERE   ROWNUM <= 5; -- 5rows     


--2. 부서별로 가장 급여를 많이 받는 사원의 사번, 이름, 부서번호, 급여, 업무코드를 조회하는 쿼리문을 작성하시오
-- 10~110번 부서 11명, 부서없는 1명 ==> 12명
--(단, 인라인 뷰 서브쿼리를 사용해야 함)
-- NULL 처리 함수
-- NVL(expr1, expr2) : expr1이 NULL이면, expr2를 반환 아니면 expr1을 반환 [데이터 타입이 expr1,expr2가 같아야 함]
-- NVL2(expr1, expr2, expr3) : expr1이 NULL이면 expr3을 반환 아니면 expr2를 반환
SELECT  e.employee_id, e.last_name, e.department_id,
        e.salary, e.job_id
FROM    employees e, (  SELECT  department_id, MAX(salary) max_sal
                        FROM    employees
                        GROUP BY department_id  ) k
WHERE   NVL(e.department_id, 0) = NVL(k.department_id, 0) -- NULL 데이터는 무조건 처리!! (비교x)
AND     e.salary = k.max_sal
ORDER BY 1; -- 12rows


-- 부서별 최고급여, 사원수 조회하고 ROLLUP 함수로 총계
SELECT  department_id, MAX(salary), COUNT(*)
FROM    employees
GROUP BY ROLLUP(department_id)
ORDER BY 1;                        