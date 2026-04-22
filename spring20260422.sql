--Microsoft Windows [Version 10.0.19045.6218]
--(c) Microsoft Corporation. All rights reserved.

C:\Users\GGG>sqlplus /nolog

SQL*Plus: Release 21.0.0.0.0 - Production on 수 4월 22 16:08:59 2026
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.

SQL> conn /as sysdba
연결되었습니다.
SQL> alter session set "_ORACLE_SCRIPT"=true;

세션이 변경되었습니다.

SQL> CREATE USER spring IDENTIFIED BY 1234;

사용자가 생성되었습니다.

SQL> GRANT CONNECT, RESOURCE TO spring;

권한이 부여되었습니다.

SQL> ALTER USER spring DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;

사용자가 변경되었습니다.

SQL> CONN SPRING/1234
연결되었습니다.
SQL> show user
USER은 "SPRING"입니다
SQL> SELECT * FROM tab;

선택된 레코드가 없습니다.

SQL>
--------------------------------------------------------------------------------
-- 메뉴 목록
CREATE TABLE menus (

    menu_id   VARCHAR2(6)  PRIMARY KEY,
    menu_name VARCHAR(100) ,
    menu_SEQ  NUMBER(5) 

);

INSERT INTO menus VALUES ('MENU01', 'JAVA', 1);
INSERT INTO menus VALUES ('MENU02', 'SPRING', 2);
INSERT INTO menus VALUES ('MENU03', 'ORACLE', 3);

COMMIT;

