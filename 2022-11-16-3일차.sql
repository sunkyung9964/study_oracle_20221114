-- ���̺� ���� ��ȸ
DESC ���̺��

-- ���̺� ������ ��ȸ
SELECT �÷�1, �÷�2 
FROM ���̺�

-- ���̺� ������ ��ȸ + ����(=���͸�)
SELECT �÷�1, �÷�2 
FROM ���̺�
WHERE ���ǵ� ����...

-- SQL �������� department_id [�μ��ڵ�] ��� �÷�, �񱳿����� (=), ����� 80 ���� �����Ǿ 
-- ������ ����


/* ============================================
    �������� �����ϴ� �׸��� �з� (p.5)
============================================ */

1) �÷�, ����, ����
2) ���������(+, -, *, /), �� ������(=, >=, <=, <, >, !=, <>), (����)���� ������(||)
3) AND, OR, NOT : �� ������
4) LIKE, IN, BETWEEN, EXISTS, NOT
5) IS NULL, IS NOT NULL
6) ANY, SOME, ALL
7) �Լ�(� �۾��� �����ϴ� ��ɾ��� ����)  (vs ���ν���)


2.3 ������
2.3.1 ��������� : +, -, *, /
-- SELECT ��, WHERE ���� �����.
SELECT 2 + 2, 2 - 1, 2 * 3, 4 / 2
FROM dual; -- dual : ��¥ ���̺� (=���� �������� �ʴ� ������ ���̺��� dual�� ���� ó��)

[����2-4] 80�� �μ� ����� �� �� ���� ���� �޿�(=����)�� ��ȸ�Ͻÿ�
-- ������� ������ EMPLOYEES ��� ���̺� ����Ǿ� ����.
-- ����� �ٹ��ϴ� �μ��� ������ DEPARTMENTS ��� ���̺� ����Ǿ� ����.
SELECT  employee_id emp_id, last_name, salary * 12 "Annual Salary" -- ��Ī(=Alias, ����)
FROM    employees
WHERE   department_id = 80; -- 34 rows, 34���̳� �ٹ��ϴ� 80�� �μ��� �������� �ϴ� ���ϱ�? SALE(=�Ǹźμ�)

--SELECT department_id, department_name, manager_id
--FROM departments
--WHERE department_id = 80;

[����2-5] (��ü ����� ��) �� �� ���� ���� �޿��� 120000�� ����� ��ȸ�Ͻÿ�
-- ��ü ����� ��ȸ
-- * : aesterisk, ���ɹ��� / ��� ���ڿ��� ��ü (= ��� �÷��� ����. ���~ �μ��ڵ����)
SELECT *
FROM    employees
WHERE   salary*12 = 120000; -- salary�� ���޿� <---> 12000�� ����(=�� �ص��� ���� �޿�)


2.3.2 ���� ������ : ||
-- ex. �̸��� ���� �����ؼ� �̸�/���� �̶�� �÷����� ��ȸ�Ҷ�
SELECT employee_id, last_name, salary * 12 "Annual Salary" -- ��Ī
FROM employees;

SELECT employee_id, first_name ||' '||last_name full_name -- ���� ������ vs CONCAT() �Լ� : �ڿ� ���ɴϴ�.
FROM employees;

[����2-6] ����� 101���� ����� ������ ��ȸ�Ͻÿ�
-- ���⼭ ������ �̸�+���� ����, ���� FullName �̶�� ��.

SELECT  'oracle' company, employee_id ���, first_name ||' '|| last_name ����, department_id �μ�, manager_id �Ŵ�����ȣ
FROM    employees
WHERE   employee_id = 101;

-- ��Ī(=Alias)�� �÷��� ���� ==> AS�� ��������, Option!
-- 1) ������ �ΰ� ����Ѵ�. ex> �÷��� ��ĪAlias��
-- 2) Ű����δ� AS �Ǵ� as�� ����Ѵ�. ex> �÷��� AS ��Ī   �Ǵ�  �÷��� as ��Ī
-- 3) ��Ī�� ������ ������ ū ����ǥ(")�� ��� ����Ѵ�.   ex>salary * 12 [AS] "Annual Salary"


[���� 2-8] ����� 101�� ����� ������ ���, ����, ����, �μ��ڵ带 ��ȸ�Ͻÿ�
SELECT  'hanul' company, employee_id, first_name ||' '||last_name , salary * 12 AS "Annual Salary", department_id
FROM    employees
WHERE   employee_id = 101;

2.3.3 �� ������ (=, >, >=, <, <=)
-- ���� �� : ����, ���� ��

[����2-9] �޿��� 3000 ������ ����� ������ ���, ��, �޿�, �μ��ڵ带 ��ȸ�Ͻÿ�
SELECT employee_id emp_id, last_name, salary, department_id dept_id
FROM    employees
WHERE   salary <= 3000;

-- 10�� ~ 270�� : �� 27���� �μ��� ���� ȸ��
-- 20�� �μ� : Marketing (������ �μ�)
-- 30�� �μ� : Purchasing (���� �μ�)
-- 50�� �μ� : Shipping (��� �μ�)
-- 80�� �μ� : Sales (�Ǹ� �μ�)
-- �� �μ��ڵ�� 10�� �����ϸ鼭 �ٸ� �μ��ڵ带 �ĺ�
SELECT *
FROM    departments
WHERE   department_id = :num; --���ε� ����, PL/SQL ��Ʈ����!!

[����2-10] �μ��ڵ尡 80�� �ʰ��� ����� ������ ��ȸ�Ͻÿ�
-- �μ��ڵ尡 80���� �ʰ��ϴ� �μ��� �Ҽӵ� ����� ����
SELECT employee_id emp_id, last_name, salary, department_id dept_id
FROM    employees
WHERE   department_id > 80;





