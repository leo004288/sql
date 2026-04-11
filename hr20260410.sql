-- VIEW : 뷰 - SQL문을 저장해 놓고 TABLE처럼 호출해서 사용하는 객체
  -- 1) INLINE VIEW   -> SELECT 할떄만 VIEW로 작동 : 임시존재
    SELECT *
    FROM   (
            SELECT employee_id                          사번,
                   first_name || last_name              이름,
                   email      || '@green.com'           이메일,
                   phone_number                         전화
            FROM   employees
            ORDER BY 이름
            ) t
    WHERE   t.사번 IN (100,101,102);
    
    --
    SELECT *
    FROM   (
            SELECT   department_id             DEPT_ID,
                     COUNT(salary)             COM_SAL,
                     SUM(salary)               SUM_SAL,
                     AVG(salary)               AVG_SAL
            FROM     employees
            GROUP BY department_id
            ORDER BY DEPT_ID
            ) t
    WHERE   t.AVG_SAL >= 4000;
    
  -- 2) 일반적인 VIEW -> 영구저장된 객체
  -- VIEW 생성 - 영구보관   /   OR REPLACE                                      뷰 / 테이블
    CREATE OR REPLACE VIEW "HR"."VIEW_EMP" ("사번","이름","이메일","전화")
    AS 
            SELECT   employee_id                          사번,
                     first_name || '' || last_name        이름,
                     email      || '@green.com'           이메일,
                     phone_number                         전화
            FROM     employees
            ORDER BY 이름;
            
    SELECT *
    FROM   VIEW_EMP
    WHERE  UPPER(이름) LIKE '%KING%';

-- WITH - 가상의 테이블 생성
WITH A ("사번","이름","이메일","전화")
AS     (
           SELECT    employee_id                          사번,
                     first_name || '' || last_name        이름,
                     email      || '@green.com'           이메일,
                     phone_number                         전화
            FROM     employees
            ORDER BY 이름
        )
SELECT *
FROM   A;
--------------------------------------------------------------------------------
-- SELF_JOIN
-- 직원번호, 직속상사번호
SELECT employee_id,            
       manager_id
FROM   employees
ORDER BY employee_id;
       
-- 직원이름, 직속상사이름 (상사E1, 부하 E2) / 사장출력 X
SELECT   e2.employee_id                                        직원사번,
         e2.first_name || '' || e2.last_name                   직원이름,
         e1.employee_id                                        상사사번,
         e1.first_name || '' || e1.last_name                   상사이름
FROM     employees e1 RIGHT JOIN employees e2
ON       e1.employee_id = e2.manager_id
ORDER BY e2.employee_id;

--------------------------------------------------------------------------------
-- 계층형쿼리, CASCADING or HIRERACHY
-- LEVEL : 예약어, 계층형 쿼리를 레벨을 구하는

SELECT e.employee_id                                                 직원번호,
       LPAD(' ',3*(LEVEL-1)) || e.first_name || '' || last_name      직원이름, 
       LEVEL,                       
       d.department_name                                             부서명
FROM   employees        e
       JOIN departments d ON e.department_id = d.department_id
START WITH e.manager_id is null
CONNECT BY PRIOR e.employee_id = e.manager_id;

-------------------------
-- EQUI JOIN     : 등가 JOIN   - 조건이 = 인것 
-- NON-EQUI JOIN : 비등가 JOIN - 조건이 = 이 아닌것
/*
직원등급
월급           등급
0000   초과   : S
15001 ~ 20000  : A
10001 ~ 15000  : B
5001  ~ 10000  : C
3001  ~ 5000   : D
0     ~ 3000   : E
*/

SELECT employee_id                          직원번호,
       first_name || '' || last_name        직원명,
       salary                               월급,
       CASE
        WHEN salary > 20000                 THEN 'S'
        WHEN salary BETWEEN 15001 AND 20000 THEN 'A'
        WHEN salary BETWEEN 10000 AND 15000 THEN 'B'
        WHEN salary BETWEEN 5001  AND 10000 THEN 'C'
        WHEN salary BETWEEN 3001  AND 5000  THEN 'D'
        WHEN salary BETWEEN 0     AND 3000  THEN 'E'
        ELSE                                     '등급없음'
       END                                  등급
FROM   employees;

-- 등급 테이블 생성
DROP   TABLE salgrade;
CREATE TABLE salgrade
             (
             grade VARCHAR2(1) PRIMARY KEY,
             Losal NUMBER(11),
             hisal NUMBER(11)
             );
             
INSERT INTO salgrade VALUES ( 'S', 20001, 99999999999 );
INSERT INTO salgrade VALUES ( 'A', 15001, 20000 );
INSERT INTO salgrade VALUES ( 'B', 10001, 15000 );
INSERT INTO salgrade VALUES ( 'C',  5001, 10000 );
INSERT INTO salgrade VALUES ( 'D',  3001, 5000 );
INSERT INTO salgrade VALUES ( 'E',     0, 3000 );

COMMIT;

SELECT e.employee_id                            직원번호,
       e.first_name || '' || e.last_name        직원명,
       NVL(TO_CHAR(e.salary), '미정')           월급,
       NVL(sg.grade, '등급없음')                등급
FROM   employees e
       LEFT JOIN salgrade sg ON e.salary BETWEEN sg.losal AND sg.hisal
ORDER BY employee_id;
--------------------------------------------------------------------------------
-- 분석함수와 WINDOW 함수
-- 1. ROW_NUMBER() : 줄번호        (1,2,3,4,5,..........)
  -- 자료를 10개만 - 페이징 기술
  SELECT   employee_id,
           first_name || '' || last_name,
           salary
  FROM     employees
  ORDER BY salary DESC NULLS LAST;   -- NULLS LAST : NULL을 제일 밑으로 / 기본값: NULL FIRST

  -- 1) old 문법 : ROWNUM - 의사(psuedo)칼럼
  SELECT ROWNUM,
         employee_id,
         first_name || '' || last_name,
         salary
  FROM  employees
  WHERE ROWNUM BETWEEN 1 AND 10
  ORDER BY salary DESC NULLS LAST;
  
  --
  SELECT ROWNUM, employee_id, first_name, last_name, salary
   FROM (  
            SELECT   employee_id,
                     first_name || '' || last_name,
                     salary
            FROM     employees
            ORDER BY salary DESC NULLS LAST
         );
       
  -- 2) new 문법 (ANSI) : ROW_NUMBER 
  SELECT *
  FROM (
       SELECT   ROW_NUMBER() OVER (ORDER BY salary DESC NULLS LAST) rn,
                employee_id,
                first_name || '' || last_name,
                salary
       FROM     employees
       ) t
  WHERE t.rn BETWEEN 11 AND 20;
  
  -- 3) ORACLE 12C 부터는 OFFSET
  SELECT   *
  FROM     employees
  ORDER BY salary DESC NULLS LAST
  OFFSET   11 ROWS FETCH NEXT 10 ROWS ONLY;

-- 2. RANK()       : 석차          (1,2,2,4,5,5,7,......)
-- 월급순으로 석차 출력
SELECT employee_id                                    사번,
       first_name || '' || last_name                  이름, 
       salary                                         월급,
       RANK() OVER (ORDER BY salary DESC NULLS LAST)  석차    
FROM   employees;

-- 월급순으로 석차 출력 (1~11등)
SELECT *
FROM (
    SELECT employee_id                                    사번,
           first_name || '' || last_name                  이름, 
           salary                                         월급,
           RANK() OVER (ORDER BY salary DESC NULLS LAST)  석차    
    FROM   employees    
    ) t
WHERE  t.석차 BETWEEN 1 AND 11;

-- 3. DENSE_RANK() : 석차          (1.2.2.3.4.5.5.6,....)
-- 월급순으로 석차 출력
SELECT employee_id                                              사번,
       first_name || '' || last_name                            이름, 
       salary                                                   월급,
       DENSE_RANK() OVER (ORDER BY salary DESC NULLS LAST)      석차    
FROM   employees;

-- 월급순으로 석차 출력 (1~11등)
SELECT *
FROM (
    SELECT employee_id                                          사번,
           first_name || '' || last_name                        이름, 
           salary                                               월급,
           DENSE_RANK() OVER (ORDER BY salary DESC NULLS LAST)  석차    
    FROM   employees    
    ) t
WHERE  t.석차 BETWEEN 1 AND 11;

-- 4. NTILE()      : 그룹으로 분류

-- 5. LIST_AGG()     
-- LISTAGG 여러줄을 한줄짜리 문자열로 변경
SELECT department_id FROM employees;

SELECT DISTINCT department_id FROM employees;

SELECT LISTAGG(DISTINCT department_id) FROM   employees;

SELECT LISTAGG(DISTINCT department_id, ',')
 WITHIN GROUP(ORDER BY department_id DESC)
FROM   employees;
