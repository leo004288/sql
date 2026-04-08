SELECT * FROM tab;

/*
SELECT 칼럼명1     별칭1, 칼럼명2     별칭2, 칼럼명3     별칭3,
 FROM  테이블명
 WHERE 조건
 ORDER BY 정렬할 칼럼 ASC / DESC
 */
 
 -- 직원이름
SELECT first_name || '' || last_name      empname,
       first_name, last_name
 FROM  employees
 ORDER BY empname;
 -- ORDER BY 3;               -- 3번째 칼럼 
 
 -- 부서번호가 60인 직원정보 (번호,이름,이메일,부서번호)
 -- 조건 : =, !=(<>,^=)
 --        not, and, or
 SELECT employee_id                        번호,
        first_name || '' || last_name      이름,
        email                            이메일,
        department_id                   부서번호
 FROM   employees
 WHERE  department_id=60
 ORDER BY employee_id;
 
 -- 부서번호가 90인 직원정보
 SELECT employee_id                        번호,
        first_name || '' || last_name      이름,
        email                              이메일,
        department_id                      부서번호
 FROM   employees
 WHERE  department_id=90
 ORDER BY employee_id;
 
 -- 부서번호가 60,90인 직원정보
SELECT E.EMPLOYEE_ID                         번호,
       E.first_name || '' || E.last_name     이름,
       E.email                               이메일,
       E.department_id                       부서번호
FROM   employees                             E
WHERE  department_id=60 OR department_id=90
ORDER BY 부서번호;

-- OR 대신 IN 명령
SELECT E.EMPLOYEE_ID                         번호,
       E.first_name || '' || E.last_name     이름,
       E.email                               이메일,
       E.department_id                       부서번호
FROM   employees                             E
WHERE  department_id IN (60,80,90)
ORDER BY 부서번호, 이름;  -- 부서번호가 같으면 이름 순

 -- 월급이 12000 이상인 직원의 번호,이름,이메일,월급을 월급순으로 출력
SELECT employee_id                           번호,
       first_name || '' || last_name         이름,
       email                                 이메일,
       salary                                월급,
       department_id                         부서번호
FROM   employees
WHERE  salary >= 12000
ORDER BY salary DESC;
 
 -- 월급이 12000~15000 인 직원의 사번,이름,월급,부서번호
SELECT employee_id                           번호,
       first_name || '' || last_name         이름,
       email                                 이메일,
       salary                                월급,
       department_id                         부서번호
FROM   employees
WHERE  salary >= 12000 AND salary <= 15000
ORDER BY salary DESC;

 -- 월급이 12000~15000 인 직원의 사번,이름,월급,부서번호 - 2
SELECT employee_id                           번호,
       first_name || '' || last_name         이름,
       email                                 이메일,
       salary                                월급,
       department_id                         부서번호
FROM   employees
WHERE  salary BETWEEN 10000 AND 15000
ORDER BY salary DESC;

 -- 직업 ID가 IT_PROG인 직원 명단
SELECT employee_id                           번호,
       first_name || '' || last_name         이름,
       email                                 이메일,
       job_id                                직업ID,
       department_id                         부서번호
FROM   employees
WHERE  job_id = 'IT_PROG'
OR     job_id = 'it_prog'
ORDER BY employee_id;

 -- UPPER(), LOWER(), INITCAP() 
SELECT employee_id                           번호,
       first_name || '' || last_name         이름,
       email                                 이메일,
       job_id                                직업ID,
       department_id                         부서번호
FROM   employees
WHERE  Lower(job_id) ='it_prog'
ORDER BY employee_id;

-- 직원이름이 GRANT 인 직원
SELECT employee_id                           번호,
       first_name || '' || last_name         이름,
       email                                 이메일,
       job_id                                직업ID,
       department_id                         부서번호
FROM   employees
WHERE  UPPER(first_name) = 'GRANT' 
OR     UPPER(last_name)  = 'GRANT'
ORDER BY employee_id;

-- 사번, 월급, 10% 인상한 월급
SELECT employee_id                           EMPID,
       first_name || '' || last_name         ENAME,
       email                                 EMAIL,
       salary                                SAL,
       salary * 1.1                          SAL2
FROM   employees
 -- WHERE  
ORDER BY SAL2 DESC;

-- 50번 부서의 직원명단, 월급, 부서번호
SELECT employee_id                           번호,
       first_name || '' || last_name         이름,
       salary                                월급,
       department_id                         부서번호
FROM   employees
WHERE  department_id = 50
ORDER BY employee_id;

-- 20,80,60,90 번 부서의 직원명단, 월급, 부서번호
SELECT employee_id                           번호,
       first_name || '' || last_name         이름,
       salary                                월급,
       department_id                         부서번호
FROM   employees
WHERE  department_id IN (20,80,60,90)
ORDER BY department_id;

-----------------------------------------------------
-- 중요 데이터를 2개 입력
-- 전체 자료수 - row 자료수 107
SELECT COUNT(*) 
FROM   employees;

-- 오늘 날짜 - 년월일시분초
SELECT SYSDATE
FROM   dual;

-- 신입시원 입사 (박보검,장원영)
INSERT INTO employees
VALUES (207,'보검','박','BOKUM','1.650.555.8888',SYSDATE,'IT_PROG',null,null,null,null);

INSERT INTO employees
VALUES (208,'리나','카','LINA','1.650.555.9999',SYSDATE,'IT_PROG',null,null,null,null);

--
SELECT * FROM employees;
SELECT COUNT(*) FROM employees;

--
UPDATE employees
 SET   email        = 'KRINA',
       phone_number = '010-1234-5678'
 WHERE employee_id  = 208;

-- TCL
COMMIT;
ROLLBACK;

----------------------------------------------------------
-- 보너스 없는 직원명단 (COMMISSION_PCT가 없음)
SELECT *
 FROM employees
 WHERE commission_pct IS NULL
-- WHERE commission_pct IS NOT NULL
 ORDER BY employee_id;

-- 전화번호가 010으로 시작하는
-- PATTERUN MACTCHING : LIKE 
-- % : 0자 이상의 모든 숫자 글자
-- _ : 1자의 모든 숫자 글자
SELECT *
 FROM  employees
 WHERE phone_number LIKE '010%'       -- '%%' : 포함되는 , ' %' : 시작되는, '% ' : 끝나는
-- WHERE phone_number LIKE '%16'
-- WHERE phone_number LIKE '%555%'
 ORDER BY employee_id;

-- LAST_NAME 세번째,네번째 글자가 LL인것
SELECT *
 FROM  employees
 WHERE last_name LIKE '__ll%'
 ORDER BY employee_id;
 
-----------------------------------------------------------
-- 날짜
SELECT employee_id, first_name, hire_date
FROM   employees;
-- 26/04/06    - 년/월/일 틀린 표현
-- 2026-04-06  - ANSI 표준
-- 04/07/26    - 월/일/년 미국식
-- 07/04/26    - 일/월/년 영국식

ALTER SESSION SET nls_date_format='YYYY-MM-DD HH24:MI:SS';                      

SELECT sysdate      FROM DUAL;
SELECT 7/2          FROM DUAL;
SELECT 0/2          FROM DUAL;
SELECT 2/0          FROM DUAL;
SELECT systimestamp FROM DUAL;
SELECT sysdate -7,   -- 일주일 전
       sysdate,      -- 오늘
       sysdate +7    -- 일주일 후
FROM DUAL;
-- 날짜 + N, 날짜 - N : 일자 전/후
-- 날짜1 - 날짜2      : 일 수
-- 날짜1 + 날짜2      : 오류

-- 크리스마스 -day
-- SELECT to_date('26/12/25') - sysdate                                        
SELECT to_date('2026-12-25') - sysdate
 FROM DUAL;

-- 소수이하 3자리로 반올림     : ROUND(VAL,3)
-- 소수이하 3자리로 절사       : TRUNC(VAL,3)
-- 15일을 기준으로 반올림 날짜 : ROUND(sysdate,'month')                         
-- 해당 달의 첫번째 날짜       : TRUNC(sysdate,'month')
-- 해당 달의 마지막 날짜       : last_day(sysdate)
-- 다음 월요일                 : next_day(sysdate, '월요일')
SELECT sysdate, ROUND(sysdate,'month'), TRUNC(sysdate,'month')  
 FROM DUAL;

SELECT next_day(sysdate, '금요일') FROM dual;                                   
SELECT TRUNC(sysdate, 'month') FROM dual;
SELECT last_day(sysdate) FROM dual;

----------------------------------------------------------------
-- 입사년월이 17년 2월인 사원출력 
ALTER SESSION SET nls_date_format='YYYY-MM-DD HH24:MI:SS';
SELECT *
 FROM  employees
 WHERE hire_date 
  BETWEEN '2017-02-01'
  AND     LAST_DAY('2017-02-01')
 ORDER BY employee_id;
 
-- '17/02/07' 에 입사한 사원출력 -1
ALTER SESSION SET nls_date_format='YYYY-MM-DD HH24:MI:SS';
SELECT *
 FROM  employees
 WHERE hire_date                                                                
  BETWEEN '2017/02/07 00:00:00'
  AND     '2017/02/07 23:59:59'
 ORDER BY employee_id;
 
-- '17/02/07' 에 입사한 사람출력
ALTER SESSION SET nls_date_format='YYYY-MM-DD HH24:MI:SS';
SELECT *
 FROM  employees
 WHERE hire_date = '2017-02-07'
 ORDER BY employee_id;

-- 오늘 입사한 사람출력
ALTER SESSION SET nls_date_format='YYYY-MM-DD HH24:MI:SS';
SELECT *
 FROM  employees
 WHERE '2026-04-07 00:00:00' <= hire_date
 AND   '2026-04-07 23:59:59' >= hire_date
 ORDER BY employee_id;
 
-----------------------------------------------------------
-- type 변환
-- TO_DATE(문자) -> 날짜
-- TO_NUMBER(문자) -> 숫자
-- TO_CHAR(숫자,'포멧') -> 글자
-- TO_CHAR(날짜,'포멧') -> 날짜 형태의 문자
-- 포멧 : yyyy-mm-dd hh24:mi:ss day dy am

-- 입사년월이 17년 2월인 사원출력
ALTER SESSION SET nls_date_format='YYYY-MM-DD HH24:MI:SS';
SELECT *
 FROM  employees
 WHERE TO_CHAR(hire_date, 'YYYY-MM') = '2017-02'
 ORDER BY employee_id;

-- 화요일 입사자를 출력
ALTER SESSION SET nls_date_format='YYYY-MM-DD HH24:MI:SS';
SELECT employee_id,
       first_name || '' || last_name,
       TO_CHAR(hire_date, 'YYYY-MM-DD'),
       TO_CHAR(hire_date, 'DAY')
 FROM  employees
 WHERE TO_CHAR(hire_date, 'DY') = '화'
 ORDER BY employee_id;
 