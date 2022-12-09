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
-- NULL 처리 : NVL(expr1, expr2), NVL2(expr1,expr2,expr3), COALESCE(null,expr1,expr2,...)
-- 오라클 IF ~ ELSE IF : DECODE, CASE WHEN~
-- 요다의 스승은 없음, null이 나오는데 --> 제다이 중 제다이 표시
SELECT *
FROM    characters;

select *
from roles;

SELECT  c.character_name, NVL(d.character_name, '제다이 중의 제다이') masters 
FROM    characters c, characters d, roles r
WHERE   c.master_id = d.character_id(+)
AND     c.role_id = r.role_id
AND     r.role_name = '제다이'
ORDER BY 1 ;

-- 연습문제 10-1, 10-2 트랜잭션 처리!
COMMIT;

-- 8. 역할이 제다이에 해당하는 배역들의 배역이름, 이메일, 마스터의 이메일을 조회하시오
-- P.92 표를 참조
SELECT  c.character_name, c.email JEDAI_EMAIL, m.email MASTER_EMAIL
--        NVL2(c.email, c.email, m.email) MASTER_EMAIL
FROM    characters c, characters m, roles r
WHERE   c.master_id = m.character_id(+)
AND     c.role_id = r.role_id
AND     r.role_name = '제다이'
ORDER BY 1;


-- 9. 스타워즈 시리즈별 출연 배우 수,
-- 에피소드 이름, 출연 배우 수, 개봉년도 순으로 조회하는 쿼리 작성
--      [ select ]           [ order by ]
-- star_wars : 영화정보 / 에피소드 아이디, 영화제목, 개봉년도
-- casting : 캐스팅정보 / 에피소드 아이디, 캐릭터 아이디, 실제 배우이름

SELECT  s.episode_name, COUNT(*) actor_count
FROM    star_wars s, casting c
WHERE   s.episode_id = c.episode_id
GROUP BY s.episode_name, s.open_year
--HAVING
--ORDER BY 1;

-- =======================================================================
--  casting 데이터 문제 : 각 배역과 실제 배우들이 모두 1회 출연한 것으로 입력된 데이터러
--  그룹함수 사용시 순위를 조회하는 경우 여러 시리즈에 중복해서 출연한 배우들에 대한 구분이
--  제대로 되지 않는 상황임을 참고하세요!!
-- =======================================================================

-- 10.전체 시리즈에서 각 배우별 배역이름, 실제이름, 출연 횟수를 조회
-- 출연횟수가 많은 배역이름 , 실제 이름 순으로 조회하시오
-- characters : 배역이름
-- casting : 실제이름
-- star_wars : 에피소드명, 개봉년도 (x)
SELECT  ch.character_name 배역이름, ca.real_name 실제이름, count(*)
FROM    characters ch, casting ca
WHERE   ch.character_id = ca.character_id
GROUP BY ch.character_name, ca.real_name;
--HAVING
--ORDER BY



--11. 10번을 참고하여 출연 횟수가 많은 상위 3명의 배역명, 실명, 출연 횟수를 조회
-- ROWNUM : 쿼리 실행 순서대로~ (상위, 하위) : 일종의 함수 ==> 의사 컬럼    vs  ROW_NUMBER()
-- RANK() OVER(ORDER BY 절), DENSE_RANK() OVER(ORER BY절)
-- 1,2,2,4,5,6...           vs   1,2,2,3,4,6...
-- 동순위 다음 순위 건너뜀     vs   동순위 다음 순위도 표시
-- 그룹함수의 조건 : HAVING에 표시

SELECT  ch.character_name 배역이름, ca.real_name 실제이름, count(*) 출연횟수
FROM    characters ch, casting ca
WHERE   ch.character_id = ca.character_id
GROUP BY ch.character_name, ca.real_name;

-- 11-1. 교재에서 사용한 방법 : ROWNUM + 인라인 뷰 서브쿼리
--
SELECT ROWNUM ranking, e.*
FROM    (   SELECT  ch.character_name 배역이름, ca.real_name 실제이름, count(*) 출연횟수
            FROM    characters ch, casting ca
            WHERE   ch.character_id = ca.character_id
            GROUP BY ch.character_name, ca.real_name
            ORDER BY 1 DESC ) e -- 인라인 뷰 : 실제로는 존재하지 않는 가상의 / 임시성 테이블 (메모리에서 처리)
WHERE   ROWNUM <= 3;

-- 11-2. RANK() 또는 DENSE_RANK() 사용한 방법
SELECT  *
FROM    (   SELECT  DENSE_RANK() OVER(ORDER BY COUNT(*)) ranking, ch.character_name 배역이름, ca.real_name 실제이름, count(*) 출연횟수
            FROM    characters ch, casting ca
            WHERE   ch.character_id = ca.character_id
            GROUP BY ch.character_name, ca.real_name    )
WHERE   ROWNUM <= 3;  


-- 12. 시리즈별 몇명의 배우가(=실제 배우) 출연 했는지 조회
-- 에피소드 시리즈 번호, 에피소드 이름, 출연 배우의 수
-- 출연 배우의 수가 많은 순으로 조회

-- star_wars : 에피소드 정보
-- casting : 실제배우 정보

SELECT  s.episode_id, s.episode_name, count(*) actor_count
FROM    star_wars s, casting c
WHERE   s.episode_id = c.episode_id
GROUP BY s.episode_id, s.episode_name
--ORDER BY    actor_count DESC;
ORDER BY 3 DESC;

-- 
COMMIT;









