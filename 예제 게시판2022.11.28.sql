create table post (
    post_id number primary key,
    post_title varchar2(30)not null,
    post_writer number,
    post_date date default sysdate
    );
    
create table writer (
    writer_id number primary key,
    writer_name varchar2(30) not null,
    writer_date date default sysdate,
    writer_email varchar (50)
    );
    
alter table post
add constraint post_writer_fk FOREIGN key (post_writer) REFERENCES writer (writer_id);

    
insert into writer
values (1, '홍길동', sysdate,'gildong@naver.com');
insert into writer
values (2, '김길동', sysdate,'gildong2222@naver.com');
insert into writer
values (3, '박길동', sysdate,'gildong3333@naver.com');

select *
from writer;

insert into post
values (0001, '오라클 dbms에 학습하기', 1, sysdate);
insert into post
values (0002, '혼자공부하는 ajva 심화', 1, sysdate);
insert into post
values (0003, '1인 개발자릐 공부법', 2, sysdate);

select p.post_id, p.post_title,
       w.writer_name
from post p, writer w
where p.post_writer = w.writer_id;

