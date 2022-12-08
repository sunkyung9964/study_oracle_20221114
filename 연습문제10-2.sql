--[연습문제10-2]


-- 1. characters 테이블에서 email 정보가 없는 배역의 모든 정보를 조회하시오
SELECT  *
FROM    characters
WHERE   email IS NULL; -- 6 rows

-- 2. characters 테이블에서 역할이 시스에 해당하는 등장인물을 조회하시오
-- 2-1. roles 테이블에서 '시스'에 해당하는 role_id를 조회 vs character 테이블의 EMAIL에 특정 문자패턴으로도~
-- 2-2. characters 테이블의 role_id가 2-1과 같은 조건의 데이터를 조회

SELECT  character_name -- 4rows
FROM    characters
--WHERE   role_id = 1002;
--WHERE   email LIKE '%sith%';
WHERE   role_id = ( SELECT role_id
                    FROM    roles
                    WHERE  role_name = '시스' ) -- 일반적인 서브쿼리의 위치
-- 사용 위치에 따라 : 스칼라 서브쿼리(SELECT절), 인라인 뷰 서브쿼리(FROM절)

-- 3. 에피소드 4에 출연한 배우들의 실제 이름을 조회하시오
SELECT real_name
FROM    casting
WHERE   episode_id = 4; --3 rows
-- 3-1. 지금까지 생성한 테이블 : characters(배역), star_wars(에피소드), roles(역할), casting(배역,실제인물)
-- 3-2. casting 테이블 정의만 하고, 실제 데이터는 입력하지 않았음
-- ※ 구글링 > https://ko.wikipedia.org/wiki/스타워즈의_출연_배우_목록
truncate table casting;

INSERT INTO casting
VALUES (4, 1, '마크 해밀');
INSERT INTO casting
VALUES (4, 2, '해리슨 포드');
INSERT INTO casting
VALUES (4, 3, '캐리 피셔');

INSERT INTO casting
VALUES (5, 4, '앨릭 기니스');
INSERT INTO casting
VALUES (5, 5, '데이비드 프로스');
INSERT INTO casting
VALUES (5, 6, '제임스 얼 존스');

INSERT INTO casting
VALUES (6, 7, '앤서니 대니얼스');
INSERT INTO casting
VALUES (6, 8, '케니 베이커');
INSERT INTO casting
VALUES (6, 9, '피터 메이휴');

INSERT INTO casting
VALUES (1, 10, '빌리 디 윌리엄스');
INSERT INTO casting
VALUES (1, 11, '프랭크 오즈');
INSERT INTO casting
VALUES (1, 12, '이더 맥더미드');

INSERT INTO casting
VALUES (2, 13, '헤이든 크리스텐슨');
INSERT INTO casting
VALUES (2, 14, '리엄 니슨');
INSERT INTO casting
VALUES (2, 15, '나탈리 포트만');

INSERT INTO casting
VALUES (3, 16, '페르닐라 오거스트');
INSERT INTO casting
VALUES (3, 17, '아메드 베스트');
INSERT INTO casting
VALUES (3, 18, '레이 파크');

INSERT INTO casting
VALUES (3, 19, '테뮤라 모리슨');
INSERT INTO casting
VALUES (3, 20, '새뮤얼 L. 잭슨');
INSERT INTO casting
VALUES (3, 21, '크리스토퍼 리');

SELECT *
FROM    casting;


-- 4. 에피소드5 출연한 배우들의 배역이름, 실제 이름을 조회하는 쿼리를 작성하시오
-- 배역정보 : characters [character_id : pk]
-- 실제이름 : casting [character_id : fk]
-- 공통컬럼 : character_id

-- 4.1 오라클 JOIN 
SELECT  ch.character_name,
        ca.real_name
FROM    characters ch, casting ca        
WHERE   ch.character_id = ca.character_id;

-- 4.2 ANSI JOIN 
SELECT  ch.character_name,
        ca.real_name
FROM    characters ch INNER JOIN casting ca        
--ON   ch.character_id = ca.character_id;
USING   (character_id);



-- 5. 주어진 오라클 조인문을 ANSI 조인으로 변경하시오
-- ANSI JOIN : 여러개 테이블이 있다면, 2개 테이블의 JOIN 결과와 다시 INNER JOIN / OUTER JOIN 하는 방식
SELECT c.character_name, p.real_name, r.role_name
FROM    characters c INNER JOIN casting p
ON   c.character_id = p.character_id
LEFT OUTER JOIN roles r
ON   c.role_id = r.role_id
WHERE     p.episode_id = 2;


SELECT c.character_name, p.real_name, r.role_name
FROM    characters c INNER JOIN casting p
USING   (character_id)
LEFT OUTER JOIN roles r
USING    (role_id)
WHERE     p.episode_id = 2;


-- 6. characters 테이블에서 배역이름, 이메일, 이메일 아이디를 조회하는 쿼리문을 작성하시오
-- 단, 이메일이 id@jedai.com일때를 참고하시오
SELECT  character_name, 
        email,
        (SUBSTR(email,1,INSTR(email,'@')-1)) email_id
FROM    characters;

SELECT 'character_name@jedai.com',
        SUBSTR('character_name@jedai,com',1,INSTR('character_name@jedai,com','@')-1) id
FROM    dual;


-- 7. 역할이 제다이에 해당하는 배역들의 배역이름, 그의 마스터 이름을 조회하는 쿼리를 작성하시오
-- 셀프조인 / 아우터 처리 : 오라클JOIN(+) vs ANSI JOIN : [LEFT|RIGHT|FULL] OUTER JOIN
-- NULL 처리 : NVL, NVL2, COALESCE
-- 오라클 IF ~ ELSE IF : DECODE, CASE WHEN~
SELECT  ch.character_name,
        ca.character_name masters -- 요다의 스승은 없음, null이 나오는데 --> 제다이 중 제다이 표시
FROM    characters ch, characters ca
WHERE   ch.master_id = ca.character_id--셀프 조인식
AND     ch.role_id = 1001; -- 알면, 모르면 서브쿼리

-- 연습문제 10-1, 10-2 트랜잭션 처리!
COMMIT;
