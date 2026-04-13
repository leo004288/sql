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
-- 1. 테이블 생성
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
    
  