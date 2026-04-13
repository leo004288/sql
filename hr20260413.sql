-- 부프로그램 : 프로시저, 함수 : user가 함수를 만듦 (USER DEFINE FUNCTION)
-- 1. 프로시저 - PROCEDURE (SUBROUTINE) , 함수보다 많이 사용
  -- 리턴값이 0개 이상
  -- STORED PROCEDURE : 저장 프로시저
  
-- 2. 함수 - FUNCTION
  -- 반드시 리턴값이 1개
-------------------------------------------------------------------------------- 
-- 107번 직원의 이름과 월급 조회
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
CREATE PROCEDURE get_empsal ( in_empid IN NUMBER )
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
DROP PROCEDURE get_empsal;
-- ORACLE로 프로시저 생성

-- 부서번호입력, 해당부서의 최고월급자의 이름, 월급 출력
SELECT department_id,
       first_name || last_name,
       MAX(salary)
FROM   employees
GROUP BY department_id;



-- 90번 부서번호입력, 직원들 출력
SELECT 