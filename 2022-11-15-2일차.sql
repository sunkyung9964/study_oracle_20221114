-- 2.1 ������ ��ȸ(p.4)
-- SQL�� ��,�ҹ��ڸ� �������� ���� vs Java�� ��,�ҹ��ڸ� ������ ������!
-- ���̺��� ������ ���캸�� ��� : desc, describe

desc countries; -- countries ��� ���̺��� ������ �Ʒ��� ����.
describe countries; -- ���̺��� �� �÷�
/*
�̸�           ��?       ����           
------------ -------- ------------ 
COUNTRY_ID   NOT NULL CHAR(2)      : ������ �ڵ�
COUNTRY_NAME          VARCHAR2(40) : ������ �̸�
REGION_ID             NUMBER       : ������ ���Ե�(=�Ҽӵ�) ��� �ڵ�
*/
-- countries ���̺�� ���� *(=All) �÷�(��)�� ��ȸ�ϴ� ���
SELECT * FROM countries;

SELECT country_id, country_name, region_id         -- select ��(=clause)
FROM countries;  -- from ��

SELECT *         -- select ��(=clause)
FROM countries;  -- from ��

SELECT country_id, country_name
FROM countries;

[����2-1] employees ���̺��� ������ ��ȸ�Ͻÿ�
DESC employees;
/*
�̸�             ��?       ����           
-------------- -------- ------------------------------------ 
EMPLOYEE_ID    NOT NULL NUMBER(6)   : ����� ���̵�(=���) 
FIRST_NAME              VARCHAR2(20) : ����� �̸�
LAST_NAME      NOT NULL VARCHAR2(25) : ����� ��
EMAIL          NOT NULL VARCHAR2(25) : ����� �̸���
PHONE_NUMBER            VARCHAR2(20) : ����� ��ȭ��ȣ(=����ó)
HIRE_DATE      NOT NULL DATE         : �Ի���
JOB_ID         NOT NULL VARCHAR2(10) : �����ڵ�(=����)
SALARY                  NUMBER(8,2)  : �� �޿�
COMMISSION_PCT          NUMBER(2,2)  : ����(=���ʽ�)
MANAGER_ID              NUMBER(6)    : �Ŵ��� ���̵�(=���)
DEPARTMENT_ID           NUMBER(4)    : �ҼӺμ� ���̵�(=�μ��ڵ�)
*/
[����2-2] employess ���̺��� �����͸� ��� ��ȸ�Ͻÿ� vs ���, �̸�, ��, ���޿��� ��ȸ�Ͻÿ�
SELECT *        
FROM employees;

SELECT employee_id, first_name, last_name, salary
FROM employees;





2.2 ������
��ü �����Ϳ��� Ư�� �� �����͸� �����Ͽ� ��ȸ�ϱ� ���ؼ� �������� ����մϴ�.
/*
SELECT �÷�1, �÷�2,...          (3) ���ϴ� �÷��� ��ȸ
FROM ���̺� �̸�                 (1) ����
WHERE ������ ����;               (2) ����(=���͸�)
*/

[����2-3] 80�� �μ����� ��� ������ ��ȸ�Ͻÿ�
-- Ű������ Space Bar�� ���� ��ɰ� �÷�, ���ǵ��� ���� �����Ͽ� �������� ����
SELECT * 
FROM employees 
WHERE department_id = 80; -- ���� ������ : = (equal)

-- Ű������ Tab Ű�� ���� ������ ������ �����ϸ鼭 ���������� �������� ����
SELECT  *
FROM    employees
WHERE   department_id = 80;

-- �� ����� CTRL+F7 : �ڵ����� SQL ���������� ����
SELECT
    *
FROM
    employees
WHERE
    department_id = 80;

-- �׷��� , ��ü �μ��� ���? � �μ��ڵ带 ���� �ִ��� ��ȸ
DESC departments;

SELECT  *
FROM    departments; -- 27 rows



