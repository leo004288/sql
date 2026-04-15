-- 시퀀스(SEQUENCE) : 번호자동증가
-- 번호칼럼에 자동으로 번호증가
CREATE TABLE TABLE1 (
    ID    NUMBER(6)      PRIMARY KEY,
    TITLE VARCHAR2(400), 
    MEMO  VARCHAR2(4000) 
);

/*
INSERT INTO TABLE1 VALUES (1,'AA','AAAA');
INSERT INTO TABLE1 VALUES (2,'B','ㅋㅋㅋㅋ');
INSERT INTO TABLE1 VALUES (3,'A','ㅇㅇ');
*/

CREATE SEQUENCE SEQ_ID;

-- SEQ_ID.NEXTVAL
-- SEQ_ID.CURRVAL

SELECT SEQ_ID.CURRVAL FROM dual; -- 시퀸스의 현재 번호
SELECT SEQ_ID.NEXTVAL FROM dual; -- 시퀀스의 새 번호 발급
-- 중간의 데이터 삭제되면 빈 번호공간이 생김

INSERT INTO TABLE1 VALUES (SEQ_ID.NEXTVAL,'AA','AAAA');
INSERT INTO TABLE1 VALUES (SEQ_ID.NEXTVAL,'B','ㅋㅋㅋㅋ');
INSERT INTO TABLE1 VALUES (SEQ_ID.NEXTVAL,'A','ㅇㅇ');
INSERT INTO TABLE1 VALUES ( ( SELECT NVL(MAX(ID), 0)+1 FROM TABLE1 ),'A','ㅇㅇ' );

COMMIT;
DELETE FROM TABLE1;
SELECT * FROM table1;

/*
-- 번호자동증가
-- MSSQL : IDENTITIY(), SEQUENCE 
    CREATE TABLE ATABLE(
        ID INT IDENTITIY(1,1)  -- 1부터 시작해서 1씩증가
        )
        
-- MYSQL, MARIADB
    CREATE TABLE ATABLE(
        ID INT AUTO_INCREMENT
        )
*/        
-------------------------------------------------------------------------------
UPDATE TABLE1     -- 외래키 설정이 안되어 있어 수정 가능
 SET   ID = 1
 WHERE ID = 4;
 
UPDATE STUDENT    -- err 외래키 설정이 되어있어 수정 불가능
 SET   stid = 7
 WHERE stid = 1;
 
-------------------------------------------------------------------------------- 
-- 인덱스 INDEX(찾아보기 표)
-- 검색할떄 해당칼럼에 인덱스를 사용하면 검색이 빨라진다
-- 단, INSERT, DELETE, UPDATE를 사용할때 새로 인덱스를 고쳐야 해서
-- 추가, 수정같은 작업이 많으면 느려질수있다

-- WHERE 문에 사용하는 칼럼이나 JOIN ON에 사용하는 칼럼에 설정
-- PRAYMARY KEY, UNIQUE 는 자동으로 인덱스 생성
-- 검색을 자주하는 칼럼에 사용

 CREATE TABLE emp_big AS
SELECT
    e.employee_id + (lv * 100000) AS employee_id,
    e.first_name,
    e.last_name,
    e.email || lv AS email,
    e.phone_number,
    e.hire_date,
    e.job_id,
    e.salary,
    e.commission_pct,
    e.manager_id,
    e.department_id
FROM hr.employees e
CROSS JOIN (
    SELECT LEVEL AS lv
    FROM dual
    CONNECT BY LEVEL <= 10000
);

SELECT COUNT(*) FROM EMP_big; 

-- 인덱스가 지정된 칼럼으로 조건을 걸어서 검색할떄 작동
SET TIMING ON;
SELECT *
FROM   emp_big
WHERE  email = 'SKING5000';

-- 인덱스 생성 
CREATE INDEX IDX_email
 On EMP_BIG (email);
 
DROP INDEX IDX_email;
--------------------------------------------------------------------------------
-- 트리거 TRIGGER 
-- 회원정보가 추가되면 로그에 남기는 작업을 해야할때

-- 상황
-- 1.INSERT 회원정보
-- 1.INSERT 로그기록
-- 두번실행

-- 자동화
-- 1.INSERT 회원정보 -> TRIGGER 가 INSERT 로그기록 명령을 호출 실행

-- 단점 : 로직추적이 쉽지않음 / 트리거 자주사용 X
-- BEFORE TRIGGER
-- AFTER  TRIGGER = INSTEAD OF

/*
CREATE OR REPLACE TRIGGER TRG_EMP
AFTER INSERT ON EMP_BIG
FOR EACH ROW
    BEGIN
        INSERT 로그
    END;
/
*/

--------------------------------------------------------------------------------
-- 트랜젝션 tran
-- 송금
-- 1) 내 계좌에서 금액   -
-- 2) 상대 계좌에서 금액 +

-- 1) UPDATE MTABLE
--      SET   내계좌 = 내계좌 - 100
    
-- 2) UPDATE MTABLE
--      SET   내계좌 = 내계좌 + 100

-- 1번 종료후 2번이 실행되지 않으면 문제
BEGIN TRAN
    UPDATE MTABLE
      SET   내계좌 = 내계좌 - 100
    UPDATE MTABLE
      SET   내계좌 = 내계좌 + 100
COMMIT;
EXCEPTION
 ROLLBACK;
END;

-- 1, 2 번 다 한개의 단위로 묶어서 처리
-- 문제 발생시 처음으로 돌아감

--------------------------------------------------------------------------------
-- LOCK : DB 잠김
INSERT INTO TABLE1 values (7, 'C', 'ㅎㅎ');
SELECT * FROM table1

WIN+R CMD
>sqlplus SKY/1234
>INSERT INTO TABLE1 VALUES (7,'c','ㅎㅎ');
화면 멈춤

SQL DEVELOPER 에서
COMMIT;

SQL PLUS 
>INSERT INTO TABLE1 VALUES (7,'c','ㅎㅎ'); -- err
