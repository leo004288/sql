ALTER SESSION SET nls_date_format='YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET nls_date_format='RR/MM/DD';

-- <앞으로 날짜 표현은 다음과 같이 표현>
SELECT sysdate FROM dual;
SELECT employee_id, TO_CHAR(hire_date, 'YYYY-MM-DD')
 FROM  employees
 WHERE TO_CHAR(hire_date, 'YYYY-MM-DD') = '2026-04-07';

-- 입사후 일주일이내인 직원 명단
SELECT employee_id, TO_CHAR(hire_date, 'YYYY-MM-DD')
FROM   employees
WHERE  hire_date >= sysdate - 7
ORDER BY employee_id;

-- 08월 입사자의 사번, 이름, 입사일순으로
SELECT   employee_id                           사번,
         first_name || '' || last_name         이름,
         TO_CHAR(hire_date, 'YYYY-MM-DD')      입사일
FROM     employees
WHERE TO_CHAR(hire_date, 'MM') = '08'   
ORDER BY employee_id;

-- 부서번호 80이 아닌 직원
SELECT *
 FROM  employees
 WHERE department_id != 80  -- = <>,^=
 ORDER BY employee_id;
 
-- +, -, *, /, MOD( , ) 
 
 ------------------------------------------------------------------------------
 -- 'YYYY-MM-DD HH24:MI:SS DAY DY AM'
 -- 2025년 07월 09일 10시 05분 04초 오전/오후 수요일 -> 한자로 출력
 --     年   月   日   時   分   秒 午前/午後 (月 化 水 木 今 土 日)
 
 -- 1) TO_CHAR
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS DAY DY AM')       날짜1,
       TO_CHAR(SYSDATE, 'YYYY"년"MM"월"DD"일" HH24"시"MI"분"SS"초" DAY AM')  날짜2,
       TO_CHAR(SYSDATE, 'YYYY"年"MM"月"DD"日" HH24"時"MI"分"SS"秒" DAY AM')  날짜3
 FROM  dual;
 
 -- 2) if 구현
 ---- 2-1) NVL(), NVL2()
   ---- 사번,이름,월급,커미션(null = 0 으로 출력)
   SELECT employee_id                                                   사번,
          first_name || '' || last_name                                 이름,
          salary                                                        월급,
          NVL(commission_pct,0)                                         커미션,
          NVL2(commission_pct, salary+(salary*commission_pct), salary)  급여
   FROM   employees  
   ORDER BY employee_id;
   
 ---- 2-2) NULLIF()
   ---- 같으면 null 같지않으면 ex1
    SELECT employee_id,
           TO_CHAR(start_date, 'YYYY')                                     start_year,
           TO_CHAR(end_date, 'YYYY')                                       end_year,
           NULLIF(TO_CHAR(end_date, 'YYYY'), TO_CHAR(start_date, 'YYYY') ) nullif_year
    FROM job_history;
    
 ---- 2-3) DECODE(expr, search1, result1,
 ----                   search2, result2,
 ----                   …,
 ----                   default)
   ---- 사번, 부서번호 (단 부서번호가 NULL 이면 '부서없음')
   SELECT employee_id                                      사번,
   --     NVL(department_id, '부서없음')                   부서번호  -- 타입이 동일해야함 문자/숫자
          DECODE(department_id, NULL, '부서없음',
                                       department_id)      부서번호
   FROM   employees
   ORDER BY employee_id;
   
   ---- 오전/오후 한자로
   SELECT TO_CHAR(sysdate, 'AM'),
          DECODE(TO_CHAR(sysdate, 'AM'), '오전', '午前',
                                                 '午後')
   FROM   dual;
   
   ---- DECODE로 사번, 이름, 부서명
/*
10	Administration
0	Marketing 
30	Purchasing
40	Human Resources
50	Shipping
60	IT
70	Public Relations
80	Sales
90	Executive
100	Finance
110	Accounting
*/
   SELECT employee_id                                      사번,
          first_name || '' || last_name                    이름,
          DECODE(department_id, 10, 'Administration',
                                20,	'Marketing',
                                30,	'Purchasing',
                                40,	'Human Resources',
                                50,	'Shipping',
                                60, 'IT',
                                70,	'Public Relations',
                                80, 'Sales',
                                90, 'Executive',
                                100,'Finance',
                                110,'Accounting'
                                   , '부서없음')            부서명
    FROM  employees
    ORDER BY employee_id;
 
    ---- 직원명단, 직원의 월급, 보너스, 연봉 출력
    SELECT employee_id                                                          사번,
           first_name || '' || last_name                                        이름,
           NVL(salary, 0)                                                       월급,
           NVL(salary * commission_pct, 0)                                      보너스,
           NVL(salary, 0) * 12 + NVL(salary, 0) * NVL(commission_pct,0)         연봉
          -- salary + (salary * NVL2(commission_pct, commission_pct, 0) )  급여
          -- NVL(commission_pct, 0)                              보너스,
          -- NVL2(commission_pct, salary + (commission_pct * salary), salary) 급여
    FROM   employees
    ORDER BY employee_id;
    
 -- 3) CASE WHEN THEN END
 ---- 사번, 이름 ,부서명
 -- WHEN SCORE BETWEEN 99 AND 100 THEN 'A'
 -- WHEN 90 < = SCORE AND SCORE <=100 THEN 'A'
 SELECT employee_id                                   사번,
        first_name || '' || last_name                 이름,
        CASE department_id
            WHEN 60 THEN 'IT'
            WHEN 80 THEN 'Sales'
            WHEN 90 THEN 'Excutive'
            else         '그외'
        END                                           부서명
 FROM employees
 ORDER BY employee_id;
 --
 SELECT employee_id                                   사번,
        first_name || '' || last_name                 이름,
        CASE 
            WHEN department_id = 60 THEN 'IT'
            WHEN department_id = 60 THEN 'Sales'
            WHEN department_id = 60 THEN 'Excutive'
            else                         '그외'
        END                                           부서명
 FROM employees
 ORDER BY employee_id;
 
 --     年   月   日   時   分   秒 午前/午後 (月 化 水 木 今 土 日)
 SELECT TO_CHAR(sysdate, 'YYYY') || '年' ||
        TO_CHAR(sysdate, 'MM')   || '月' ||
        TO_CHAR(sysdate, 'DD')   || '日' ||
        TO_CHAR(sysdate, 'HH24') || '時' ||
        TO_CHAR(sysdate, 'MI')   || '分' ||
        TO_CHAR(sysdate, 'SS')   || '秒' ||
        CASE TO_CHAR(sysdate, 'DY')
            WHEN '일' THEN '日'
            WHEN '월' THEN '月'
            WHEN '화' THEN '化'
            WHEN '수' THEN '水'
            WHEN '목' THEN '木'
            WHEN '금' THEN '今'
            WHEN '토' THEN '土'
            END                   || '요일',
        DECODE( TO_CHAR(sysdate, 'AM'), '오전', '午前', '午後' )
 FROM   dual;
 
 ------------------------------------------------------------------------------
 -- 집계 함수 : AGGREGATE
 -- 모든 집계함수는 NULL 값은 포함 되지 않는다.
 -- SUM(), AVG(), MIN(), MAX(), COUNT(), STDDEV(), VARIANCE()
 --                                      표준편차  분산
 -- 그루핑: GROUP BY
 -- 줄 별 인원수
 
 SELECT *                    FROM  employees;
 SELECT COUNT(*)             FROM  employees;
 SELECT COUNT(employee_id)   FROM  employees;
 SELECT COUNT(department_id) FROM  employees;
 
 SELECT employee_id 
  FROM  employees
  WHERE department_id is null;

 SELECT COUNT(employee_id) 
  FROM  employees
  WHERE department_id is null;

-- 전체 직원의 월급합 : 세로합 (null 제외)
SELECT COUNT(salary)          FROM  employees;
SELECT SUM(salary)            FROM  employees;
SELECT AVG(salary)            FROM  employees;
SELECT MAX(salary)            FROM  employees;
SELECT MIN(salary)            FROM  employees;
 
SELECT SUM(salary) / COUNT(salary)
FROM employees;

SELECT SUM(salary) / COUNT(*)
FROM employees;

-- 60번 부서의 월급평균
SELECT AVG(salary)
FROM   employees
WHERE  department_id = 60;

-- employees 테이블의 부서수
SELECT COUNT(department_id)
FROM   employees;

-- 중복을 제거(distinct)한 부서의 수를 출력 (null 포함)
SELECT COUNT(DISTINCT department_id)
FROM   employees;

-- 직원이 근무하는 부서의 수 : 부서장이 있는 부서 수 : DEPARTMENTS
SELECT COUNT(DISTINCT department_id)
FROM   employees;

SELECT COUNT(manager_id)
FROM   departments;

-- 소수점 ROUND, TRUNC
SELECT 7/2,
       ROUND(156.456, 2), ROUND(156.456, -2),
       TRUNC(156.456, 2), TRUNC(156.456, -2)
FROM dual;

-- 직원수, 월급합, 월급평균, 최대월급, 최소월급
SELECT COUNT(employee_id)             직원수,
       SUM(salary)                    월급합,
       ROUND(AVG(salary),3)           월급평균,
       MAX(salary)                    최대월급,
       MIN(salary)                    최소월급
FROM   employees;

-- SQL 실행순서 1.FROM -> 2.WHERE -> 3 SELECT -> 4.ORDER BY
-- 부서 60번 부서 인원수, 월급합, 월급평균
SELECT COUNT(employee_id)             부서인원수,
       SUM(salary)                    월급합,
       AVG(salary)                    월급평균
FROM   employees
WHERE  department_id = 60;

-- 부서 50,60,80번 부서가 아닌 인원수, 월급합, 월급평균
SELECT COUNT(employee_id)                    인원수,
       SUM(salary)                           월급합,
       ROUND( AVG(salary), 2 )               월급평균
FROM   employees
WHERE  department_id NOT IN (50,60,80);

-------------------------------------------------------------------------------
/*
SELECT   
FROM     
WHERE    
GROUP BY 
 HAVING
ORDER BY
*/
-- 부서별 사원수
SELECT   department_id,
         COUNT(employee_id)
FROM     employees
GROUP BY department_id
GROUP BY ROLLUP(department_id)
ORDER BY department_id;

-- 부서별 월급합, 월급평균
SELECT   department_id            부서,
         SUM(salary)              월급합,
         ROUND(AVG(salary),2)     월급평균
FROM     employees
GROUP BY department_id
ORDER BY department_id;

-- 부서별 사원수 통계
SELECT   department_id              부서,
         COUNT(employee_id)         사원수
FROM     employees
GROUP BY department_id
ORDER BY department_id;

-- 부서별 인원수, 월급합
SELECT department_id                부서,
       COUNT(employee_id)           인원수,
       SUM(salary)                  월급합
FROM   employees
GROUP BY department_id
ORDER BY department_id;

-- 부서별 인원수가 5명이상인 부서번호
SELECT   department_id               부서,
         COUNT(employee_id)          사원수
FROM     employees 
GROUP BY department_id
 HAVING  COUNT(employee_id) >= 5
ORDER BY department_id;

-- 부서별 월급총계가 20000이상인 부서 번호
SELECT   department_id                부서,
         SUM(salary)                  월급총계
FROM     employees
GROUP BY department_id
 HAVING  SUM(salary) >= 20000
ORDER BY department_id;

-- JOB_ID 별 인원수
SELECT   job_id                       부서,
         COUNT(employee_id)           인원수
FROM     employees
GROUP BY job_id
ORDER BY job_id;

-- job_title 별 인원수
SELECT   DECODE(job_id, 'AD_PRES', 'President',
                        'AD_VP', 'Administration Vice President',
                        'AD_ASST', 'Administration Assistant',
                        'FI_MGR', 'Finance Manager',
                        'FI_ACCOUNT', 'Accountant',
                        'AC_MGR', 'Accounting Manager',
                        'AC_ACCOUNT', 'Public Accountant',
                        'SA_MAN', 'Sales Manager',
                        'SA_REP', 'Sales Representative',
                        'PU_MAN', 'Purchasing Manager',
                        'PU_CLERK', 'Purchasing Clerk',
                        'ST_MAN', 'Stock Manager',
                        'ST_CLERK', 'Stock Clerk',
                        'SH_CLERK', 'Shipping Clerk',
                        'IT_PROG', 'Programmer',
                        'MK_MAN', 'Marketing Manager',
                        'MK_REP', 'Marketing Representative',
                        'HR_REP', 'Human Resources Representative',
                        'PR_REP', 'Public Relations Representative')            부서명,
                        COUNT(employee_id)                                      인원수  
FROM     employees
GROUP BY job_id;

-- 입시일 기준 월별 인원수,2017기준
SELECT   TO_CHAR(hire_date, 'MM')     입사월,
         COUNT(employee_id)           인원수
FROM     employees
WHERE    TO_CHAR(hire_date, 'YYYY') >= '2017'
GROUP BY TO_CHAR(hire_date, 'MM') 
ORDER BY TO_CHAR(hire_date, 'MM');

-- 부서별 최대 월급이 14000이상인 부서의 부서번호와 최대월급
SELECT   department_id                부서,
         MAX(salary)                  최대월급
FROM     employees
GROUP BY department_id
 HAVING  MAX(salary) >= 14000
ORDER BY department_id;

-- 부서별 모으고 같은부서는 직업별 인원수, 월급평균
SELECT   department_id                                                          부서id,
         DECODE(job_id, 'AD_PRES', 'President',
                        'AD_VP', 'Administration Vice President',
                        'AD_ASST', 'Administration Assistant',
                        'FI_MGR', 'Finance Manager',
                        'FI_ACCOUNT', 'Accountant',
                        'AC_MGR', 'Accounting Manager',
                        'AC_ACCOUNT', 'Public Accountant',
                        'SA_MAN', 'Sales Manager',
                        'SA_REP', 'Sales Representative',
                        'PU_MAN', 'Purchasing Manager',
                        'PU_CLERK', 'Purchasing Clerk',
                        'ST_MAN', 'Stock Manager',
                        'ST_CLERK', 'Stock Clerk',
                        'SH_CLERK', 'Shipping Clerk',
                        'IT_PROG', 'Programmer',
                        'MK_MAN', 'Marketing Manager',
                        'MK_REP', 'Marketing Representative',
                        'HR_REP', 'Human Resources Representative',
                        'PR_REP', 'Public Relations Representative')            부서명,
         COUNT(job_id)                                                          인원수,
         ROUND( AVG(salary),2 )                                                 월급평균
FROM     employees
GROUP BY department_id,  DECODE(job_id, 'AD_PRES', 'President',
                        'AD_VP', 'Administration Vice President',
                        'AD_ASST', 'Administration Assistant',
                        'FI_MGR', 'Finance Manager',
                        'FI_ACCOUNT', 'Accountant',
                        'AC_MGR', 'Accounting Manager',
                        'AC_ACCOUNT', 'Public Accountant',
                        'SA_MAN', 'Sales Manager',
                        'SA_REP', 'Sales Representative',
                        'PU_MAN', 'Purchasing Manager',
                        'PU_CLERK', 'Purchasing Clerk',
                        'ST_MAN', 'Stock Manager',
                        'ST_CLERK', 'Stock Clerk',
                        'SH_CLERK', 'Shipping Clerk',
                        'IT_PROG', 'Programmer',
                        'MK_MAN', 'Marketing Manager',
                        'MK_REP', 'Marketing Representative',
                        'HR_REP', 'Human Resources Representative',
                        'PR_REP', 'Public Relations Representative')
--GROUP BY CUBE(department_id, job_id)
ORDER BY department_id;