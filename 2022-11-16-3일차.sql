-- ���̺��

-- 




*/
1) �÷�, ����, ����
2) ��������� : +, -, *, /, �񱳿����� : =, >=, <=, <, >, !=, <>, (����)���� ������ : ||
3) AND, OR, NOT : �� ������
4) LIKE, IN, BETWEEN, EXISTS, NOT
5) IS NULL, IS NOT NULL,
6) ANY, SOME. ALL
7) �Լ�(� �۾��� �����ϴ� ��ɾ��� ����) (vs ���ν���)*/

2.3 ������
2.3.1
SELECT 2 + 2
FROM dual;

[��2-4] 80�� �μ� ����� �� �� ���� ���� �޿�(=����)�� ��ȸ�Ͻÿ�
-- ������� ������ EMPLOYEES ��� ���̺� ����Ǿ� ����.
-- ����� �ٹ��ϴ� �μ��� ������ DEPARTMENTS ��� ���̺� ����Ǿ� ����.

SELECT employee_id ���, last_name ��, salary * 12 -- ��Ī(=Alias, ����)
FROM employees
WHERE department_id = 80; 

SELECT * department_id, department_name, manager_id
FROM departments;
WHERE department_id = 80;


[����2-5] (��ü ����� ��)�� �� ���� ���� �޿��� 120000�� ����� ��ȸ�Ͻÿ�
-- ��ü ����� ��ȸ
-- * : aesterisk, ���ɹ��� / ��� ���ڿ��� ��ü

SELECT *
FROM employees
WHERE salary*12 = 120000;-- salary�� ���޿�



