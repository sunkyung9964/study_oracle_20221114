-- 1~10��. SQL : Structured Query Language (����ȭ�� ���Ǿ�) ����
-- �η�> PL/SQL : ����Ŭ���� �����ϴ� �������� ���Ǿ�(Procedural language extension to SQL)
/*
 1. �������
 �����ּ� vs ������ �ּ� 
 ����� ������ �����ݷ�(;)
 (�Ϲ�������) ��,�ҹ��ڸ� �������� �ʴ´�.

 2.SQL ���� : ���ҿ� ���� �Ʒ��� ���� ����
 (2-0. DQL : SELECT)
 2-1. DML : SELECT, INSERT, UPDATE, DELETE [�����͸� ��ȸ, ����, �����ϴ� ��ɾ�]
 ------------------------------ �����ڰ� ����ϴ� ��� ---------------------------
 2-2. DDL : CREATE, ALTER, DROP [�����ͺ��̽� ��ü�� ����, ����, �����ϴ� ��ɾ�]
 2-3. DCL : GRANT, REVOKE [������ �ְų� ���� ��ɾ�]
------------------------------ DBA�� ����ϴ� ��� --------------------------- 
*/

-- ȸ�� ������ �����ϴ� ���̺��� �����
-- ���̵� : ���� Ű (�����͸� �����ϰ� �ĺ��ϴ� ���Ƿ� ���� Ű)
-- �̸� : ���������� �ִٸ�? �ٸ� ���̵�� ����
-- ����
-- ��ȭ��ȣ
-- �ּ�
-- �̸���
-- ������
-- 1. ���̺� ��ü ���� : DDL(Database Definition Language, �����ͺ��̽� ���Ǿ��)
CREATE TABLE userTBL (
    id NUMBER,
    name VARCHAR2(20),
    age NUMBER,
    phone CHAR(13),
    addr VARCHAR2(50),
    email VARCHAR2(30),
    reg_date DATE
);

-- 2. ���̺� ������ ���� : DML (Database Manipulation Language, �����ͺ��̽� ���۾��)
-- 2.1 ���ο� �����͸� ����/���� : INSERT
-- 2.2 ���������͸� �����ؼ� ���� : UPDATE

INSERT INTO userTBL (id, name, age, phone, addr, email, reg_date)
VALUES (1, 'ȫ�浿', 20, '010-1234-5678', 'gwangju, seo-gu', 'hong2@naver.com', SYSDATE);
-- ���� ������ �Է��� ���½ð� ����!! ȸ��, ��ǰ ���̺� �����͸� �Է��ϼ���!!
INSERT INTO userTBL (id, name, age, phone, addr, email, reg_date)
VALUES (2, '�ֱ浿', 55, '010-1234-5671', 'gwangju, seo-gu', 'hong@naver.com', SYSDATE);
INSERT INTO userTBL (id, name, age, phone, addr, email, reg_date)
VALUES (3, '��浿', 42, '010-1234-5672', 'gwangju, nam-gu', 'hong3@naver.com', SYSDATE);
INSERT INTO userTBL (id, name, age, phone, addr, email, reg_date)
VALUES (4, '�ڱ浿', 23, '010-1234-5673', 'gwangju, buk-gu', 'hong4@naver.com', SYSDATE);
INSERT INTO userTBL (id, name, age, phone, addr, email, reg_date)
VALUES (5, '�̱浿', 25, '010-1234-5674', 'gwangju, gwansan-gu', 'hong5@naver.com', SYSDATE);
INSERT INTO userTBL (id, name, age, phone, addr, email, reg_date)
VALUES (6, '���浿', 30, '010-1234-5678', 'gwangju, seo-gu', 'hong6@naver.com', SYSDATE);
INSERT INTO userTBL (id, name, age, phone, addr, email, reg_date)
VALUES (7, '��浿', 40, '010-1234-5679', 'gwangju, seo-gu', 'hong7@naver.com', SYSDATE);

-- 3. ���̺� ���� ������ ��ȸ : SELECT
SELECT * FROM userTBL; -- ���ٷ� ���°� ���,..

-- 4. ���̺� ���� �������� ���ǿ� �´� �����͸� ��ȸ : SELECT
SELECT * 
FROM userTBL 
WHERE age = 20;  -- = : ���� (equal, �� ������)


-- 5. ���̺��� ����(=����, ��)�� ��ȸ : desc, describe (=�����ϴ�, �����ϴ�)
DESC itemTBL;
/* itemTBL�� ��(=����)
�̸�        ��? ����           
--------- -- ------------ 
ID           NUMBER       
BUYER        NUMBER       
TITLE        VARCHAR2(50) 
QTY          NUMBER       
PRICE        NUMBER       
SELL_DATE    VARCHAR2(20)
*/

--6. ��ǰ ���̺� ��ǰ �����͸� ����
INSERT INTO itemTBL
VALUES (0001, 1, 'TV ����� 30W ����Ŀ', 1, 20000, SYSDATE); --SYSDATE �Լ� : �ý����� ���ڸ� �Է�����
INSERT INTO itemTBL
VALUES (0002, 2, 'Java �����ڿ� ��ǻ��', 1, 2000000, SYSDATE); --SYSDATE �Լ� : �ý����� ���ڸ� �Է�����
INSERT INTO itemTBL
VALUES (0003, 3, '�߱ٽ� ������ ��� ������', 1, 10000, SYSDATE); --SYSDATE �Լ� : �ý����� ���ڸ� �Է�����
INSERT INTO itemTBL
VALUES (0004, 4, '��ǰ���� �Կ��� DSLRī�޶�', 1, 1200000, SYSDATE); --SYSDATE �Լ� : �ý����� ���ڸ� �Է�����
INSERT INTO itemTBL
VALUES (0005, 5, '��Ʈ��, �º� ������ ����', 1, 100000, SYSDATE); --SYSDATE �Լ� : �ý����� ���ڸ� �Է�����

-- 7. ��ǰ ���̺� ��ȸ
SELECT ID, BUYER, PRICE
FROM itemTBL;

-- 8. �����ͺ��̽� ��ü ����
-- DROP TABLE ���̺��;      -- �����ͺ��̽� ����(=�����͵� ���ư�) 
-- DELETE ���̺�� WHERE ����; -- ���ǿ� �´� �����͸� ����(=���̺��� ����) 
-- TRUNCATE TABLE ���̺��;    -- ���̺��� ����, �����ʹ� ��� ����

--DROP TABLE userTBL;
--DROP TABLE itemTBL;

SELECT *
FROM userTBL;

-- ���� �����͸� ���������� ���� ��ǻ�� ����ҿ� �����ϴ� ���
COMMIT;






CREATE TABLE itemTBL (
    id NUMBER(4),--��ǰ ���̵� : 0001, 0002.....
    buyer number,-- ������ ���̵� : Ȧ�浿
    title varchar2(100), -- ��ǰ�� : 100����Ʈ
    qty number, -- ��ǰ ����
    price VARCHAR2(50), -- ��ǰ ����
    sell_date date -- �Ǹ���
   );

-- number : ���� Ÿ��/�Ҽ���
-- char : ��������
-- varchar2 : ���� ���� vs varchar : ����Ŭ���� �ٽ� � �������� �����ϱ����� ������ ������� �ʵ���!!
-- ncharm, nvarchar : national (�ٱ���, ��� �ƴ� �ѱ���/�Ϻ���/�߱���/�ƶ���,.. �� ���� ��� ����)
-- date : (�ð�)��¥  vs timezone, timestamp : �и���������� ���� (ex.���Ա��)
-- lob(large object), clob, blob : �̹���, ������� �뷮�� ū ���̳ʸ� ���ϵ��� �����ϴ� Ÿ��
-- bfile : �׶����Ʈ ����..


-- * dba, modeler�� �ַ� �����ϰ� ����, developer�� �׷��� ������� �����ͺ��̽��� ������ �����, ������ ���

-- ������ ������ ���
-- ������ �������� ������ ���̺� ���� �״�� ���Ѽ� �Է�!
select sysdate
from dual;

INSERT INTO itemTBL
values (0001, 1,�������� ������ 1�ڽ�', 100, 15000, tomdate('2022/10/15','rrrr/mm/dd hh:mi:ss'));

INSERT INTO itemTBL
values (0002, 2,���ִ�', 100, 15000, tomdate('2022/10/15','rrrr/mm/dd hh:mi:ss'));

INSERT INTO itemTBL
values (0001, 1,�������� ������ 1�ڽ�', 100, 15000, tomdate('2022/10/15','rrrr/mm/dd hh:mi:ss'));

INSERT INTO itemTBL
values (0001, 1,�������� ������ 1�ڽ�', 100, 15000, tomdate('2022/10/15','rrrr/mm/dd hh:mi:ss'));

insert into itemTBL

