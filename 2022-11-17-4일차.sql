-- 2��. ������ ��ȸ ����
/*
DML : SELECT, INSERT, UPDATE, DELETE
DDL : CREATE, ALTER, DROP
DCL : GRANT, REVOKE, TRUNCATE
*/

-- 2.1 SELECT ����
SELECT �÷�1, �÷�2
FROM employees;


SELECT *
FROM employees;

-- 2.2 SELECT ���� + ������(=���͸�) : Ư�� ���ǿ� �´� �����͸� ��ȸ
SELECT employee_id, first_name, department_id
FROM employees
WHERE department_id = 100;


-- �ڵ����� ���� : ���ϴ� ������ �� ���� �� CTRL+F7(=�ڵ� ������ ����)
-- TAB ���� ���!

-- 2.3.3 �� ������
-- ���ں�
-- ���ں�(p.7)
[����2-11] ���� king�� ����� ������ ��ȸ�Ͻÿ�
-- last name�� king ���� ��!!(=����, ũ��, �۴�..)

SELECT  employee_id ���, last_name ��, department_id �μ�
FROM    employees
//WHERE   last_name = 'King';
WHERE   last_name = 'king';


[����2-12] �Ի����� 2004�� 1�� 1�� ������ ����� ����(=���, �̸�, �Ի��̺�
-- �Ի���� 2003�� 12�� 31�ϱ���
-- ���� �� : �̻�,����
SELECT *
FROM    employees 
WHERE   hire_date < '04/01/01';
-- ' ' : ���� ����ǥ�� ���ڿ�����, �ð�,��¥ ǥ��
-- " " : ū ����ǥ�� ??? �÷��� ��Ī(=Alias)�� ������ ��, ������ �ִ� �ܾ �����Ҷ� 



SELECT SYSDATE
FROM dual;
