desc employees

select employee_id, first_name, department_id,
     d.department_name
from employees e, departments d
where e.department_id = d.department_id(+)
and e.manager_id is not null
order by 1;

select e.employee_id, e.first_name, e.department_id,
     d.department_name
from employees e inner join departments d
on e.department_id = d.department_id
order by e.employee_id;


select e.employee_id, e.first_name, e.department_id,
        d.department_name
from employees e, departments d
where e.department_id = d.department_id
and e.employee_id in (110, 130, 150)
order by 1;

select e.employee_id, e.first_name, e.department_id,
        d.department_name
from employees e inner join departments d
on e.department_id = d.department_id
and e.employee_id in (110, 130, 150)
order by 1;

select e.employee_id, e.first_name, e.department_id,
        d.department_name,
        j.job_id, j.job_title
from  employees e, departments d, jobs j
where e.department_id = d.department_id
and e.job_id = j.job_id(+)
and e.manager_id is not null
order by 1;

select e.employee_id, e.first_name, e.department_id,
        d.department_name,
        j.job_id, j.job_title
from  employees e full outer join departments d
on e.department_id = d.department_id
full outer join jobs j
on e.job_id = j.job_id
where e.manager_id is not null
order by 1;

        
        
        
