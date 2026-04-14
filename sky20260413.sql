--------------------------------------------------------------------------------
-- DDL (Data Dfinition Language) - 데이터 정의어
-- 구조를 생성(CREATE), 변경(ALTER), 제거(DROP)

-- 계정생성 id:sky 비번:1234
Microsoft Windows [Version 10.0.19045.6218]
(c) Microsoft Corporation. All rights reserved.

C:\Users\GGG>sqlplus /nolog

SQL*Plus: Release 21.0.0.0.0 - Production on 월 4월 13 14:06:08 2026
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.

SQL> conn /as sysdba
연결되었습니다.
SQL> show user
USER은 "SYS"입니다
SQL> ALTER SESSION SET "_ORACLE_SCRIPT"=true;

세션이 변경되었습니다.

SQL> CREATE USER SKY IDENTIFIED BY 1234;

사용자가 생성되었습니다.

SQL> GRANT CONNECT, RESOURCE TO SKY;

권한이 부여되었습니다.

SQL> ALTER USER SKY DEFAULT TABLESPACE
  2  USERS QUOTA UNLIMITED ON USERS;

사용자가 변경되었습니다.

SQL> CONN SKY/1234
연결되었습니다.
SQL> show user
USER은 "SKY"입니다
--------------------------------------------------------------------------------
-- 새 계정 작업
-- sky에서 hr 계정의 데이터를 가져오기
-- sqlplus에서 작업
-- 1. hr 로그인
win+r : cmd
>sqlplus hr/1234

-- 2. hr 에서 가른 계정인 sky에게 select할 수 있는 권한 부여
>GRANT SELECT ON EMPLOYEES TO SKY;

-- 3. sky 로그인
> CONN SKY/1234\
> SELECT * FROM TAB

-- 4. sky에서 hr 계정의 employees 조회
> SELECT * FROM HR.EMPLOYEES;  -- 성공
...
> SELECT * FROM HR.DEPARTMENTS; -- 실패

--------------------------------------------------------------------------------
-- ORACLE TABLE 복사
-- hr의 employees TABLE 을 복사해서 sky
-- 1. 테이블 생성 CREATE
  -- 1) 테이블 복사 
  -- 대상 : 테이블 구조, 데이터 (제약 조건의 일부만 복사(NOT NULL))
  
  -- {1} 구조, 데이터 다 복사, 제약조건은 일부만 복사(NULL 관련)
  CREATE TABLE EMP1
  AS 
    SELECT * FROM HR.EMPLOYEES;
  
  -- {2} 구조, 데이터 다 복사, 50번 80번 부서만 복사
  CREATE TABLE EMP2
  AS
    SELECT * FROM HR.EMPLOYEES
    WHERE department_id IN (50,80);
    
  DROP TABLE EMP2;
  
  -- {3} DATA 빼고 구조만 복사
  CREATE TABLE EMP3
  AS
    SELECT * FROM HR.employees
    WHERE 1 = 0;
  
  -- {4} 구조만 복사된 TABLE에 DATA만 추가
  CREATE TABLE EMP4
  AS
    SELECT * FROM HR.employees
    WHERE 1 = 0;
    
  INSERT INTO EMP4
    SELECT * FROM HR.employees;
  COMMIT;
  
  -- {5} 일부칼럼만 복사해서 새로운 테이블 생성
  CREATE TABLE EMP5
  AS
    SELECT employee_id                      empid,
           first_name || '' || last_name    ename,
           salary                           sal,
           salary * commission_pct          bouns,
           manager_id                       mgr,
           department_id                    deptid
    FROM HR.employees;

--------------------------------------------------------------------------------
SELECT * FROM TAB;
--------------------------------------------------------------------------------
-- SQL DEVELOPER 메뉴에서 TABLE 생성
-- sky 계정 
  -- 테이블 메뉴클릭 -> 새 테이블 -> TABLE1 생성: EMP6
/*
CREATE TABLE EMP6 
    EMPID   NUMBER(8,2)  NOT NULL PRIMARY KEY,
    ENAME   VARCHAR2(46) NOT NULL,
    TEL     VARCHAR2(20), 
    EMAIL   VARCHAR2(320)      
*/

DROP TABLE EMP6;

-- SCRIPT로 생성
CREATE TABLE EMP7 
(
  EMPID NUMBER(8,2)  NOT NULL 
, ENAME VARCHAR2(46) NOT NULL
, TEL   VARCHAR2(20)  
, EMAIL VARCHAR2(320)  
, CONSTRAINT EMP7_PK PRIMARY KEY 
  (
    EMPID 
  )
  ENABLE 
);

--------------------------------------------------------------------------------
-- 테이블 제거 - 영구적으로 구조와 데이터가 제거된다
-- DROP 되는 테이블이 부모테이블일 경우 자식을 먼저 지워야 제거 가능
-- 1. DROP TABLE EMP1;
DROP TABLE EMP1;

-- 2. DROP TABLE employees CASCADE; -- 부모자식관계의 데이터를 전체삭제 
CREATE TABLE EMP1
AS 
    SELECT * FROM employees;
    
DROP TABLE EMP1;
DROP TABLE employees; -- 삭제 X
-- 부모키를 가진 부모테이블은 자식테이블에 데이터가 있다면 테이블이 삭제되지 않는다
 
DROP TABLE employees CASCADE; -- 부모자식관계의 데이터를 전체삭제

--------------------------------------------------------------------------------
-- 구조변경 (ALTER)
  -- 1. 칼럼추가
    ALTER TABLE EMP5
     ADD (LOC VARCHAR2(6)); -- 추가된 칼럼은 NULL로 채워짐
     
  -- 2. 칼럼제거
    ALTER TABLE EMP5
     DROP COLUMN LOC;
     
  -- 3. 테이블 이름 변경 
    RENAME EMP5 TO NEWEMP5;  -- 오라클 전용명령
  
  -- 4. 칼럼속성변경 - 데이터칸의 크기를 늘리거나 줄인다
  -- 크기를 줄일때 데이터의 내용이 짤릴수있다
    ALTER TABLE EMP5
     MODIFY ( ENAME VARCHAR2(60) ); -- 46 -> 60
     
--------------------------------------------------------------------------------
-- TABLE 생성하고 데이터를 파일에서 가져옴
CREATE TABLE ZIPCODE
(
 ZIPCODE VARCHAR2(7)           -- 우편번호
,SIDO    VARCHAR2(6)           -- 시도
,GUGUN   VARCHAR2(26)          -- 구군
,DONG    VARCHAR2(78)          -- 읍명동리건물명
,BUNJI   VARCHAR2(26)          -- 번지
,SEQ     NUMBER(5) PRIMARY KEY -- 일련번호
);

-- 테이블 생성후 ZIPCODE 테이블 선택하고 
    -- -> 우클릭으로 데이터 임포트
        -- -> ZIPCODE_UTF8.CSV 선택
        
SELECT * FROM ZIPCODE;
SELECT COUNT(*) FROM ZIPCODE;

-- 부산 개수
SELECT COUNT(*)
FROM ZIPCODE
WHERE SIDO = '부산';

-- 시도별 우편번호 개수
SELECT   sido                  시도,      
         COUNT(zipcode)        우편번호개수
FROM     zipcode
GROUP BY sido;

-- 우편번호 중복제거 개수
SELECT COUNT(zipcode),
       COUNT(DISTINCT zipcode) 
FROM   zipcode;

-- 부전2동포함 출력
SELECT '['    || zipcode || '] ' ||
        sido  || ' ' ||
        gugun || ' ' ||
        dong  || ' ' ||
        bunji || ' ' AS address

FROM zipcode
WHERE dong LIKE '%부전2동%'
ORDER BY SEQ;
