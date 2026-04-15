-- 성적처리 TABLE
/*
업무
 학생 : 학번, 이름, 전화, 입학일
 성적 : 학번, 국어, 영어, 수학, 총점, 평균, 석차 결과
 과목은 변경될 수 있다.
 
 TABLE 생성
 학생     : 학번(PK), 이름,   전화,   입학일
 STUDENT    STID      STNAME  PHONE   INDATE  
 
 성적     : 일련번호(PK), 교과목,   점수,   학번(FK)
 SCORES     SCID          SUBJECT   SCORE   STID
 
 -- 제약조건(CONSTRAINTS) - 무결성  
  TABLE 에 저장될 데이터에 조건을 부여하여 잘못된 DATA 입려되는 방지
  1. 주식별자 설정 : 기본키
     PRIMARY KEY     : NOT NULL + UNIQUE 기본 적용
      CREATE TABLE 명령안에 한번만 사용가능
  2. NOT NULL / NULL : 필수입력, 컬럼단위 제약조건
  3. UNIQUE          : 중복방지
  4. CHECK           : 값의 범위지정 , DOMAIN 제약 조건 
  5. FOREIGN KEY     : 외래키 제약조건
*/  
----------------------------------
CREATE TABLE STUDENT
(
  STID   NUMBER(6)    PRIMARY KEY       -- 학번 숫자(6) 기본키(PK)
, STNAME VARCHAR2(30) NOT NULL          -- 이름 문자(30) 필수입력
, PHONE  VARCHAR2(20) UNIQUE            -- 전화 문자(20) 중복방지
, INDATE DATE         DEFAULT SYSDATE   -- 입학일 날짜 기본값 오늘
);    

-- 학생 정보 입력 (3가지 방법)
INSERT INTO STUDENT (STID, STNAME, PHONE, INDATE)
 VALUES             (1,    '가나', '010', SYSDATE);

INSERT INTO STUDENT 
 VALUES             (2,    '나나', '011', SYSDATE);
 
INSERT INTO STUDENT (STID, STNAME, PHONE)
 VALUES             (3,    '다나', '012');

INSERT INTO STUDENT (STID, STNAME, PHONE)
 VALUES             (4,    '라나', '013');

INSERT INTO STUDENT (STID, STNAME, PHONE)
 VALUES             (5,    '라나', '014');

INSERT INTO STUDENT (STID, STNAME, PHONE)
 VALUES             (NULL, '사나', '015'); -- err : 기본키 NULL

INSERT INTO STUDENT (STID, STNAME, PHONE)
 VALUES             (5,    '라나', '014'); -- err : 기본키 중복 X

INSERT INTO STUDENT (STID, STNAME, PHONE)
 VALUES             (6,    '하나', '014'); -- err : UNIQUE 중복
 
INSERT INTO STUDENT (STID, STNAME, PHONE)
 VALUES             (7,    NULL, '018');   -- err : NOT NULL 제약조건 위반
 
INSERT INTO STUDENT (STID, STNAME, PHONE)
 VALUES             (6,    '하나', '019');
 
COMMIT;
 
SELECT * FROM STUDENT;

---------------------------------
CREATE TABLE SCORES
(
  SCID    NUMBER(7)    NOT NULL                               -- 일련번호 숫자(7) 기본키, 번호자동증가
, SUBJECT VARCHAR2(60) NOT NULL                               -- 교과목 문자(60) 필수입력
, SCORE   NUMBER(3)    CHECK (SCORE BETWEEN 0 AND 100)        -- 점수 숫자(3) 범위 0~100
, STID    NUMBER(6)   
, CONSTRAINT SCID_PK
    PRIMARY KEY (SCID, SUBJECT)
, CONSTRAINT STID_FK
    FOREIGN KEY (STID)
    REFERENCES STUDENT(STID)                                  -- 학번 숫자(6) 외래키(FK)
);

-- 점수 정보 입력
INSERT INTO SCORES VALUES (1,     '국어',  100,    1);
INSERT INTO SCORES VALUES (2,     '영어',  100,    1);
INSERT INTO SCORES VALUES (3,     '수학',  100,    1);

INSERT INTO SCORES VALUES (4,     '국어',  100,    2);
INSERT INTO SCORES VALUES (5,     '수학',   80,    2);

INSERT INTO SCORES VALUES (6,     '국어',   70,    4);
INSERT INTO SCORES VALUES (7,     '영어',   80,    4);
INSERT INTO SCORES VALUES (8,     '수학',   85,    4);

INSERT INTO SCORES VALUES (9,     '국어',  805,   5); -- err 점수오류
INSERT INTO SCORES VALUES (10,    '영어',  100,   8); -- err 8번 없음

COMMIT;

SELECT * FROM SCORES;

--------------------------------------------------------------------------------
-- DML 추가, 수정 ,삭제
-- 1. INSERT - 줄(DATA) 추가
  -- 1) 하나씩 추가
  --    INSERT INTO SCORES (SCID, SUBJECT, SCORE, STID)
  --     VALUES            (1,     '국어',  100,    1)
  
  -- 2) 여러줄 추가 
  --    INSERT INTO EMP4
  --     SELECT * FROM HR.employees;
  
  -- 3) INSERT 문 여러줄 한번에 추가 : 새문법
  --    INSERT ALL 
  --     INTO EX_SKY VALUES ()
  CREATE TABLE EX_SKY
  (
    ID   NUMBER(7)    PRIMARY KEY,
    NAME VARCHAR2(30) NOT NULL
  );
  
    INSERT ALL 
     INTO EX_SKY VALUES (103,'이순신')
     INTO EX_SKY VALUES (104,'김유신')
     INTO EX_SKY VALUES (105,'강감찬')
    SELECT * FROM dual; 
    
COMMIT;

-- 2. DELETE - 줄(DATA) 삭제, WHERE 없으면 전체 대상
    DELETE
     FROM  테이블명
     WHERE 조건;
     
-- 3. UPDATE - 줄 변화 X, 칸의 있는 정보 수정, WHERE 없으면 전체 대상
    UPDATE SCORES
     SET SCORE = 70
     WHERE SCID = 6;

ROLLBACK;
COMMIT;
     
SELECT * FROM SCORES;
--------------------------------------------------------------------------------
-- DATA 제거
-- 1. DROP TABLE SCORES;      -- 구조(테이블), DATA 모두 삭제, 복구불가능
-- 2. TRUNCATE TABLE SCORES;  -- 구조남기고, DATA 만 삭제, 속도 빠름 
-- 3. DELETE TABLE SCORES;    -- 구조남기고, DATA 만 삭제, 속도 느림

-- SET TIMING ON
SELECT * FROM SCORES;
DELETE FROM SCORES;
SELECT * FROM SCORES;
ROLLBACK;

SELECT * FROM STUDENT;
DELETE FROM STUDENT;  -- err
SELECT * FROM STUDENT;

INSERT INTO STUDENT VALUES (11,'히나','0111',sysdate);
COMMIT;

DELETE FROM STUDENT
 WHERE STID = 1;      -- err

DELETE FROM STUDENT
 WHERE STID = 11;      

-- 외래키 관계에서 자식테이블의 DATA를 지우고 부모테이블의 DATA를 삭제하면 된다.
DELETE FROM scores
 WHERE STID = 1;
 
DELETE FROM STUDENT
 WHERE STID = 1;
 
-- 1. 자식먼저 삭제
DROP TABLE SCORES;
DROP TABLE STUDENT;

-- 2. 순서와 무관하게 삭제
DROP TABLE STUDENT CASCADE CONSTRAINTS PURGE; 
DROP TABLE SCORES; 

--------------------------------------------------------------------------------
-- 조회
SELECT * FROM scores;
SELECT * FROM student;

-- 학번, 이름, 점수(국어)
SELECT st.stid               학번,
       st.stname             이름,
       sc.score              국어
FROM   student st, scores sc 
WHERE  st.stid = sc.stid(+)
ORDER BY st.stid;

SELECT st.stid               학번,
       st.stname             이름,
       sc.score              국어
FROM   student st 
       LEFT JOIN scores sc ON st.stid = sc.stid
WHERE  subject = '국어';

-- 학번, 이름, 총점, 평균
SELECT st.stid                 학번,
       st.stname               이름,
       SUM(sc.score)           총점,
       ROUND(AVG(sc.score),2)  평균
FROM   scores sc 
       RIGHT JOIN student st ON st.stid = sc.stid
GROUP BY st.stid, st.stname
ORDER BY st.stid;

-- 모든학생의 학번, 이름, 총점, 평균 (점수가 NULL인 학생은 '미응시')
SELECT st.stid                                           학번,
       st.stname                                         이름,
       NVL( TO_CHAR( SUM(score) ), '미응시')             총점,
       NVL( TO_CHAR( ROUND( AVG(score),2 ) ), '미응시')  평균
FROM   scores sc 
       RIGHT JOIN student st ON st.stid = sc.stid
GROUP BY st.stid, st.stname
ORDER BY st.stid;

SELECT st.stid                                                 학번,
       st.stname                                               이름,
       DECODE( SUM(sc.score), NULL, '미응시', SUM(sc.score))   총점,
       CASE
        WHEN ROUND( AVG(sc.score), 2) IS NULL THEN '미응시'
        ELSE                                     TO_CHAR( AVG(sc.score), '999.00' )             
       END                                                     평균
FROM   scores sc 
       RIGHT JOIN student st ON st.stid = sc.stid
GROUP BY st.stid, st.stname
ORDER BY st.stid;

SELECT 학번, 이름,
       DECODE(총점, NULL, '미응시', TO_CHAR( SUM(sc.score), '999.00' ) ),
       DECODE(총점, NULL, '미응시', TO_CHAR( AVG(sc.score), '999.00' ) )
FROM 
(
SELECT st.stid                 학번,
       st.stname               이름,
       SUM(sc.score)           총점,
       ROUND(AVG(sc.score),2)  평균
FROM   scores sc 
       RIGHT JOIN student st ON st.stid = sc.stid
GROUP BY st.stid, st.stname
ORDER BY st.stid
);

-- 모든학생의 학번, 이름, 총점, 평균, 등급, 석차

SELECT st.stid                                           학번,
       st.stname                                         이름,
       NVL( TO_CHAR( SUM(score) ), '미응시')             총점,
       NVL( TO_CHAR( ROUND( AVG(score),2 ) ), '미응시')  평균,
       NVL( CASE
             WHEN AVG(score) >= 90 THEN 'A'
             WHEN AVG(score) >= 80 THEN 'B'
             WHEN AVG(score) >= 70 THEN 'C'
             WHEN AVG(score) >= 60 THEN 'D'
             WHEN AVG(score) <  60 THEN 'F'
            END, '미응시' )                                   등급,
       RANK() OVER (ORDER BY AVG(score) DESC NULLS LAST)      석차
FROM   scores sc  
       right JOIN student st ON st.stid = sc.stid
GROUP BY st.stid, st.stname 
ORDER BY 석차;

SELECT st.stid                                                         학번,
       st.stname                                                       이름,
       CASE 
        WHEN SUM(sc.score) IS NULL THEN '미응시'
        ELSE                             TO_CHAR(SUM(sc.score), '999.99')
       END                                                             총점,
       CASE 
        WHEN AVG(sc.score) IS NULL THEN '미응시'
        ELSE                             TO_CHAR(AVG(sc.score), '999.00')
       END                                                             평균,
       CASE 
        WHEN ROUND( AVG(sc.score), '2' ) BETWEEN 90 AND 100   THEN 'A'
        WHEN ROUND( AVG(sc.score), '2' ) BETWEEN 80 AND 89.99 THEN 'B'
        WHEN ROUND( AVG(sc.score), '2' ) BETWEEN 70 AND 79.99 THEN 'C'
        WHEN ROUND( AVG(sc.score), '2' ) BETWEEN 60 AND 69.99 THEN 'D'
        ELSE                                                       'F'
       END                                                             등급,
       RANK() OVER (ORDER BY SUM(SC.SCORE) DESC NULLS LAST)            석차
FROM   student st
       LEFT JOIN scores sc  ON st.stid = sc.stid
GROUP BY st.stid, st.stname;

--------------------------------------------------------------------------------
-- 학번, 이름, 국어, 영어, 수학, 총점, 평균, 등급, 석차
-- 1. ORACLE 10G 방식
-- 1) 학번, 국어, 영어, 수학
SELECT sc.stid                                    학번,
       DECODE(sc.subject, '국어', sc.score)       국어,
       DECODE(sc.subject, '영어', sc.score)       영어,
       DECODE(sc.subject, '수학', sc.score)       수학
FROM   scores sc;

-- 2) 학번, 국어, 영어, 수학 : JOIN 추가
SELECT   sc.stid                                     학번,
         SUM( DECODE(sc.subject, '국어', sc.score) ) 국어,
         SUM( DECODE(sc.subject, '영어', sc.score) ) 영어,
         SUM( DECODE(sc.subject, '수학', sc.score) ) 수학
FROM     scores sc
GROUP BY sc.stid;

-- 3) 학번, 이름, 국어, 영어, 수학 : JOIN 추가
SELECT   st.stid                                     학번,
         st.stname                                   이름,
         SUM( DECODE(sc.subject, '국어', sc.score) ) 국어,
         SUM( DECODE(sc.subject, '영어', sc.score) ) 영어,
         SUM( DECODE(sc.subject, '수학', sc.score) ) 수학
FROM     scores sc
         RIGHT JOIN STUDENT st ON sc.stid = st.stid
GROUP BY st.stid, st.stname
ORDER BY 학번;

-- 4) 학번, 이름, 국어, 영어, 수학, 총점, 평균
SELECT   st.stid                                     학번,
         st.stname                                   이름,
         SUM( DECODE(sc.subject, '국어', sc.score) ) 국어,
         SUM( DECODE(sc.subject, '영어', sc.score) ) 영어,
         SUM( DECODE(sc.subject, '수학', sc.score) ) 수학, 
         SUM(sc.score)                               총점,
         ROUND( AVG(sc.score), 2 )                   평균
FROM     scores sc
         RIGHT JOIN STUDENT st ON sc.stid = st.stid
GROUP BY st.stid, st.stname
ORDER BY 학번;

-- 5) 학번, 이름, 국어, 영어, 수학, 총점, 평균, 등급, 석차 
-- NULL은 '미응시'로 출력
-- 등급 : 비등가 조인
CREATE TABLE SCOREGRADE
(
    GRADE   VARCHAR2(1) PRIMARY KEY,
    LOSCORE NUMBER(6,2),
    HISCORE NUMBER(6,2)
);
-- DROP TABLE SCOREGRADE;

INSERT INTO SCOREGRADE VALUES ('A', 90,   100);
INSERT INTO SCOREGRADE VALUES ('B', 80, 89.99);
INSERT INTO SCOREGRADE VALUES ('C', 70, 79.99);
INSERT INTO SCOREGRADE VALUES ('D', 60, 69.99);
INSERT INTO SCOREGRADE VALUES ('F', 0 ,  59.99);
COMMIT;

SELECT t.학번, t.이름,
       DECODE( t.국어, NULL, '미응시', t.국어)           국어,
       DECODE( t.영어, NULL, '미응시', t.영어)           영어,
       DECODE( t.수학, NULL, '미응시', t.수학)           수학,
       DECODE( t.총점, NULL, '미응시', t.총점)           총점,
       DECODE( t.평균, NULL, '미응시', t.평균)           평균,
       DECODE( sg.grade, NULL, '미응시', sg.grade)       등급,
       RANK() OVER(ORDER BY t.총점 DESC NULLS LAST)      석차
FROM 
(
SELECT   st.stid                                     학번,
         st.stname                                   이름,
         SUM( DECODE(sc.subject, '국어', sc.score) ) 국어,
         SUM( DECODE(sc.subject, '영어', sc.score) ) 영어,
         SUM( DECODE(sc.subject, '수학', sc.score) ) 수학, 
         SUM(sc.score)                               총점,
         ROUND( AVG(sc.score), 2 )                   평균
FROM     scores sc
         RIGHT JOIN STUDENT st ON sc.stid = st.stid
GROUP BY st.stid, st.stname
ORDER BY 학번
) t LEFT JOIN SCOREGRADE sg ON t.평균 BETWEEN sg.loscore AND sg.hiscore; 

-- 2. ORACLE 11G 방식 - PIVOT 명령 사용 : 통계를 생성 / 집계함수와 같이 사용
-- 1) 학번, 국어, 영어, 수학
SELECT * FROM (
    SELECT stid, subject, score
    FROM   scores
)
PIVOT
(
    SUM(SCORE)
        FOR subject
            IN('국어' AS 국어, '영어' AS 영어, '수학' AS 수학)
);

-- 1) 학번, 이름, 국어, 영어, 수학, 총점, 평균, 등급, 석차
SELECT st.stid 학번, st.stname 이름, t.국어, t.영어, t.수학, 
       NVL(t.국어,0) + NVL(t.영어,0) + NVL(t.수학,0)                                        총점, 
       ROUND( (NVL(t.국어,0) + NVL(t.영어,0) + NVL(t.수학,0))/3, 2)                         평균, 
       sg.grade                                                                             등급, 
       RANK() OVER( ORDER BY NVL(t.국어,0) + NVL(t.영어,0) + NVL(t.수학,0) DESC NULLS LAST) 석차
FROM (
    SELECT * FROM (
        SELECT stid, subject, score
        FROM   scores
    )   
    PIVOT
    (
        SUM(SCORE)
            FOR subject
                IN('국어' AS 국어, '영어' AS 영어, '수학' AS 수학)
    )
) t RIGHT JOIN student    st ON t.stid = st.stid
    LEFT  JOIN SCOREGRADE sg ON (NVL(t.국어,0) + NVL(t.영어,0) + NVL(t.수학,0))/3
                             BETWEEN sg.loscore AND sg.hiscore;
