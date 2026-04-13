-- 부프로그램 : 프로시저, 함수 : user가 함수를 만듦 (USER DEFINE FUNCTION)
-- 1. 프로시저 - PROCEDURE (SUBROUTINE) , 함수보다 많이 사용
  -- 리턴값이 0개 이상
  -- STORED PROCEDURE : 저장 프로시저
  
-- 2. 함수 - FUNCTION
  -- 반드시 리턴값이 1개
-------------------------------------------------------------------------------- 
-- 107번 직원의 이름과 월급 조회 -----------------------------------------------
SELECT first_name || last_name          이름,
       salary                           월급
FROM   employees
WHERE  employee_id = 107; 

-- 익명 프로시저
SET SERVEROUTPUT ON;
DECLARE
    v_name    VARCHAR2(46);
    v_sal     NUMBER(8, 2);
BEGIN
    v_name := '카리나';
    v_sal  := 10000;
    DBMS_OUTPUT.put_line(v_name);
    DBMS_OUTPUT.put_line(v_sal);
    IF v_sal >= 10000 THEN
        DBMS_OUTPUT.put_line('GOOD'); 
    ELSE
        DBMS_OUTPUT.put_line('not GOOD');
    END IF;
END;
/

-- 저장 프로시저 (IN : INPUT, OUT : OUTPUT, INOUT : INPUTOUT)
-- 파라미터는 in_empid IN NUMBER 괄호와 숫자사용 X
-- 내부변수는 v_name 반드시 괄호와 숫자사용
CREATE OR REPLACE PROCEDURE get_empsal ( in_empid IN NUMBER )
IS
v_name VARCHAR2(46);
v_sal  NUMBER(8, 2);
    BEGIN
        SELECT first_name || last_name, salary
         INTO  v_name                 , v_sal
        FROM   employees
        WHERE  employee_id = 107;
        
    DBMS_OUTPUT.put_line('이름:' || v_name);
    DBMS_OUTPUT.put_line('월급:' || v_sal);
    
    END;
/

SET SERVEROUTPUT ON;  -- DBMS_OUTPUT.put_line() 의 결과를 출력
CALL get_empsal(107);

-- 부서번호입력, 해당부서의 최고월급자의 이름, 월급 출력 -----------------------
-- 90번 부서의 최고월급자의 이름, 월급 출력
/*
SELECT first_name || last_name,
       salary
FROM   employees
WHERE  salary = (
            SELECT MAX(salary)
            FROM   employees
            WHERE  department_id = 90
            );
*/

CREATE OR REPLACE PROCEDURE get_name_maxsal (
    in_deptid IN  NUMBER,
    o_name    OUT VARCHAR2,
    o_sal     OUT NUMBER
    )
IS
    v_maxsal number(8,2);
    BEGIN
        
        SELECT first_name || last_name, salary
         INTO  o_name                 , o_sal
        FROM   employees
        WHERE  salary = ( 
                        SELECT MAX(salary)
                         --INTO  v_maxsal
                        FROM  employees
                        WHERE department_id = in_deptid
                        )
         AND   department_id = in_deptid;
         
         DBMS_OUTPUT.put_line(o_name);
         DBMS_OUTPUT.put_line(o_sal);
         
    END;
/
-- 테스트 -> java에서 호출해서 사용
SET SERVEROUTPUT ON;
VAR o_name VARCHAR2;
VAR o_sal  NUMBER;
CALL get_name_maxsal(90, :o_name, :o_sal);
PRINT o_name;
PRINT o_sal;

SET SERVEROUTPUT ON;  -- DBMS_OUTPUT.put_line() 의 결과를 출력
CALL get_name_maxsal(90, :o_name, :o_sal);

-- 90번 부서번호입력, 직원들 출력 : 결과가 여러줄 ------------------------------
CREATE OR REPLACE PROCEDURE getemplist(
    in_deptid NUMBER
)
IS 
    v_empid NUMBER(6);
    v_name  VARCHAR2(50);
    v_phone VARCHAR2(25);
    BEGIN
        SELECT employee_id, first_name || last_name, phone_number
         INTO  v_empid    , v_name                 , v_phone
        FROM   employees
        WHERE  department_id = in_deptid;
          
        DBMS_OUTPUT.put_line(v_empid);  
        
    END;
/

-- 테스트 err
SET SERVEROUTPUT ON;
EXECUTE getemplist(90);

-- *SELECT INTO는 결과가 한줄일때만 사용* --------------------------------------
-- CURSOR 사용
CREATE OR REPLACE PROCEDURE get_emplist(
    in_deptid IN  NUMBER,
    o_cur     OUT SYS_REFCURSOR
)
IS 
    BEGIN
    
        OPEN o_cur FOR
            SELECT employee_id, first_name || last_name, phone_number
            FROM   employees
            WHERE  department_id = in_deptid;
          
    END;
/

-- 테스트
VARIABLE o_cur REFCURSOR; 
EXECUTE get_emplist(50, :o_cur);
PRINT o_cur;