SELECT * FROM TAB;

-- IT 부서의 직원 정보 출력

SELECT   employee_id,
         first_name || '' || last_name,
         department_id
FROM     employees
WHERE    job_id LIKE 'IT%'
ORDER BY employee_id;

------------------------------------------------------------------------------
-- IT 부서의 직원 정보 출력

-- subquery : SQL문안에 SQL문을 넣어서 실행
--            반드시 () 안에 있어야함 
--            ()안에는 ORDER BY 사용불가 
--            WHERE조건에 맞도록 사용
--            쿼리실행하는 순서가 필요할때

  -- 1) IT,Sales 부서 의 부서 번호를 찾음
        SELECT department_id
        FROM   departments
        WHERE  department_NAME in ('IT','Sales');

  -- 2) 60,80번 부서의 직원정보를 출력
        SELECT employee_id,
               first_name || '' || last_name,
               department_id
        FROM   employees
        WHERE  department_id in (
            SELECT department_id
            FROM   departments
            WHERE  department_NAME in ('IT','Sales')
            );

-- 평균월급보다 많은 월급을 받는 사람 명단
  -- 1) 평균월급 
        SELECT   AVG(salary)
        FROM     employees;
        
  -- 2) 평균이상 월급
        SELECT employee_id,
               first_name || '' || last_name,
               salary
        FROM   employees
        WHERE  salary >= (
            SELECT   AVG(salary)
            FROM     employees
            );
            
-- IT 부서의 평균월급보다 많은 월급을 받는 사람의 명단
  -- 1) IT부서의 번호
        SELECT department_id
        FROM   departments
        WHERE  department_name = 'IT';        
                
  -- 2) 60번부서의 평균월급
        SELECT AVG(salary)
        FROM   employees
        WHERE  department_id = (
            SELECT department_id
            FROM   departments
            WHERE  department_name = 'IT'
            );        

  -- 3) 
        SELECT employee_id,
               first_name || '' || last_name,
               salary
        FROM   employees
        WHERE  salary >= (
            SELECT AVG(salary)
            FROM   employees
            WHERE  department_id = (
                SELECT department_id
                FROM   departments
                WHERE  department_name = 'IT'
                ) 
            );
 
-- 50번 부서의 최고 월급자 이름
  -- 1) 50번 부서의 최고월급
        SELECT MAX(salary)
        FROM   employees
        WHERE  department_id = 50;
 
  -- 2) 최고월급자의 이름
        SELECT employee_id,
               first_name || '' || last_name,
               salary
        FROM   employees
        WHERE  salary = (
            SELECT MAX(salary)
            FROM   employees
            WHERE  department_id = 50
            )
        AND department_id = 50;
 
-- Sales 부서의 평균월급보다 많은 월급을 받는 사람의 명단
  -- 1) Sales 부서의 부서번호
        SELECT department_id
        FROM   departments
        WHERE  UPPER(department_name) = 'SALES';
        
  -- 2) 1)의 부서의 평균 월급
        SELECT AVG(salary)
        FROM   employees
        WHERE  department_id = (
            SELECT department_id
            FROM   departments
            WHERE  UPPER(department_name) = 'SALES'
            );

  -- 3) 명단
        SELECT employee_id,
               first_name || '' || last_name,
               salary
        FROM   employees
        WHERE  salary >= (
            SELECT AVG(salary)
            FROM   employees
            WHERE  department_id = (
                SELECT department_id
                FROM   departments
                WHERE  UPPER(department_name) = 'SALES'
                )
            );
            
-- 다중열 서브쿼리
SELECT *
FROM employees 
WHERE (job_id, salary) IN (
    SELECT job_id, MIN(salary) 
    FROM employees
    GROUP BY job_id
    )
ORDER BY salary DESC;

-- 상관 서브쿼리 CORELATIVE SUBQUARY
-- job_history에 있는 부서번호와 departments 에 있는 부서번호가 같은 부서를 찾아
-- departments 에 있는 부서번호와 부서명을 출력
SELECT a.department_id, a.department_name
FROM   departments a
WHERE EXISTS ( SELECT 1
               FROM job_history b
               WHERE a.department_id = b.department_id 
               );

-- SHIPPING 부서의 직원 명단
SELECT employee_id,
       first_name || '' || last_name,
       department_id
FROM   employees
WHERE  department_id = (
    SELECT department_id
    FROM   departments
    WHERE  UPPER(department_name) = 'SHIPPING'
    );
    
--------------------------------------------------------------------------------
-- JOIN 
-- 오라클 old 문법
-- 직원이름, 부서명 - 출력 줄 수 109줄
-- 1) 직원이름, 부서명
-- 카티션 프로덕트: 109 * 27 -> CROSS JOIN, 조건없는
SELECT first_name || '' || last_name            직원이름,
       department_name                          부서명
FROM   employees, departments;

-- 2)내부조인: 양쪽 다 존재한 데이터의 NULL은 제외 -> INNER JOIN
-- 조건 추가 : 106명 - 3명 빠짐 (NULL은 제외함)
-- 109 - 3(null) -> INNER JOIN
SELECT employees.first_name || '' || last_name                직원이름,
       departments.department_name                            부서명
FROM   employees, departments
WHERE  employees.department_id = departments.department_id;
--
SELECT e.first_name || '' || last_name                직원이름,
       d.department_name                              부서명
FROM   employees e, departments d
WHERE  e.department_id = d.department_id;

-- 3) 모든 직원 출력 (NULL도 출력)
-- (+): 기준이 되는 조건의 반대방향에 붙힌다. (NULL이 출력 될 곳)
--                                             left outter join
SELECT   e.first_name || '' || e.last_name,
         d.department_name
FROM     employees e, departments d
WHERE    e.department_id = d.department_id(+)
ORDER BY e.employee_id;

-- 4) 모든 직원 출력 (정보없음도 출력)         right outter join
SELECT   e.first_name || '' || e.last_name,
         d.department_name
FROM     employees e, departments d
WHERE    e.department_id(+) = d.department_id
ORDER BY e.employee_id;

-- 5) 모든 작원과 모든 부서 출력              full outter join 
-- old문법에 존재 x

--------------------------------------------------------------------------------
-- JOIN
-- 표준 SQL 문법

-- 1. CROSS JOIN
SELECT e.first_name, e.last_name, d.department_name
FROM   employees e CROSS JOIN departments d;

-- 2. (INNER) JOIN
SELECT e.first_name, e.last_name, d.department_name
FROM   employees e JOIN departments d 
ON     e.department_id = d.department_id; 

-- 3. OUTTER JOIN
  -- 1) left outter join
  SELECT e.first_name, e.last_name, d.department_name
  FROM   employees e LEFT JOIN departments d 
  ON     e.department_id = d.department_id; 

  -- 2) right outter join
  SELECT e.first_name, e.last_name, d.department_name
  FROM   employees e RIGHT JOIN departments d 
  ON     e.department_id = d.department_id;  

  -- 3) full outter join
  SELECT e.first_name, e.last_name, d.department_name
  FROM   employees e FULL JOIN departments d 
  ON     e.department_id = d.department_id
  ORDER BY employee_id;
  
-- 직원이름, 담당업무(JOB_TITLE)
SELECT   first_name || '' || last_name            직업이름,
         job_title                                담당업무
FROM     employees e join jobs j
ON       e.job_id = j.job_id
ORDER BY e.employee_id;

-- 부서명, 부서위치(CITY, STREET_ADDRESS)
SELECT d.department_name                          부서명,
       l.city                                     도시,
       l.street_address                           주소
FROM   departments d FULL join locations l
ON     d.location_id = l.location_id
ORDER BY l.city;

-- 직원명, 부서명, 국가, 부서위치(CITY,STREET_ADDRESS)
SELECT e.first_name || '' || e.last_name              직원명,
       d.department_name                              부서명,
       c.country_name                                 국가,
       l.city                                         도시,
       l.street_address                               주소
FROM   employees             e 
       LEFT JOIN departments d ON  e.department_id = d.department_id
       LEFT JOIN locations   l ON  d.location_id   = l.location_id
       LEFT JOIN countries   c ON  l.country_id    = c.country_id                
ORDER BY c.country_name;

-- 부서명, 국가 : 모든 부서 : 27줄이상
SELECT d.department_id                                 부서명,
       c.country_name                                  국가
FROM   departments          d 
       RIGHT JOIN locations l ON d.location_id = l.location_id
       RIGHT JOIN countries c ON l.country_id  = c.country_id
ORDER BY d.department_id;

-- 직원명, 부서위치 단 IT 부서만
SELECT e.first_name || '' || last_name                                           직원명,
       l.state_province || '' || l.city || '' || l.street_address                부서위치
FROM   employees        e 
       JOIN departments d ON e.department_id = d.department_id
       JOIN locations   l ON d.location_id   = l.location_id
WHERE  d.department_name = 'IT';

-- 부서명별 월급평균 (부서명 기준 월급평균 출력 / NULL은 '직원없음'으로 출력)
SELECT   d.department_name                                                      부서명,
--       NVL(ROUND(AVG(salary),2),0)                                            월급평균
--      NVL2(ROUND(AVG(salary),2), ROUND(AVG(salary),2), 0)                     월급평균
         DECODE(ROUND(AVG(salary),2),NULL,'직원없음'
                                           ,ROUND(AVG(salary),2))               월급평균
FROM     employees e 
         RIGHT JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY d.department_name;

-- 직원의 근무연수
-- MONTH_BETWEEN(날짜1,날짜2) : 날짜1 - 날짜2 : 월단위
-- ADD_MONTH(날짜, n) :  날짜+n개월 / 날짜-n개월
SELECT first_name || '' || last_name                                            직원명,
       TO_CHAR(hire_date, 'YYYY-MM-DD')                                         입사일,
       TO_CHAR( TRUNC(hire_date, 'MONTH'), 'YYYY-MM-DD')                        입사월첫번째날,
       TO_CHAR( LAST_DAY(hire_date), 'YYYY-MM-DD')                              입사월마지막날,
       TRUNC(SYSDATE - hire_date)                                               근무일수,
       TO_CHAR(sysdate, 'YYYY') - TO_CHAR(hire_date, 'YYYY')                    근무연수,
       TRUNC( (SYSDATE - hire_date) / 365.2422 )                                근무연수,
       TRUNC( MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12 )                         근무연수
FROM   employees;

-- 60번 부서 최소월급과 같은 월급자의 명단출력
SELECT first_name || '' || last_name,
       salary,
       department_id
FROM   employees
WHERE  salary = (
    SELECT   MIN(salary)
    FROM     employees
    WHERE    department_id = 60
    );

-- 부서명, 부서장의 이름   
SELECT d.department_name                                   부서명,
       e.first_name || '' || e.last_name                   부서장
FROM   departments         d
       LEFT JOIN employees e ON d.manager_id = e.employee_id
ORDER BY employee_id;

--------------------------------------------------------------------------------
-- 결합연산자 : 줄 단위 결합
-- 조건 - 두 테이블의 칸수와 타입이 동일해야함
-- 1) UNION     : 중복제거 
-- 2) UNION ALL : 중복포함
-- 3) INTERSECT : 교집합 : 곹오부분
-- 2) MINUS     : 차집합 a - b
SELECT * FROM   employees WHERE  department_id = 80;
SELECT * FROM   employees WHERE  department_id = 50;

SELECT * FROM   employees WHERE  department_id = 80
UNION
SELECT * FROM   employees WHERE  department_id = 50;

-- 칼럼수와 칼럼 타입이 같으면 합쳐진다 -> 의미없는 결합이 가능
SELECT employee_id, first_name FROM employees
UNION
SELECT department_id, department_name FROM departments;

-- 직원정보, 담당업무
SELECT first_name || '' || last_name            직원이름,
       job_title                                담당업무
FROM   employees e 
       JOIN jobs j ON e.job_id = j.job_id;

-- 직원명, 담당업무, 담당업무 히스토리
SELECT   employee_id,
         first_name || '' || last_name,
         job_id
FROM     employees      e 
UNION
SELECT   j.employee_id,
         e.first_name || '' || e.last_name,
         j.job_id
FROM     job_history    j
         JOIN employees e ON j.employee_id = e.employee_id
ORDER BY employee_id;

-- 
SELECT *
FROM   ( SELECT  employee_id,
                 job_id
         FROM    employees 
         UNION
         SELECT  employee_id,
                 job_id
         FROM    job_history    
                 ) -- INLINE VIEW : ORDER BY 사용가능 : FROM 뒤에 사용
ORDER BY employee_id;

-- 사번, 업무시작일, 업무종료일, 담당업무, 부서번호
--SELECT 사번, 업무시작일, 업무종료일, 담당업무, 부서번호
--FROM  
--(
SELECT employee_id                                       사번,
       TO_CHAR(hire_date, 'YYYY-MM-DD')                  업무시작일,
       '제직중'                                          업무종료일,
       job_id                                            담당업무,
       department_id                                     부서번호 
FROM   employees
UNION
SELECT employee_id                                       사번,
       TO_CHAR(start_date, 'YYYY-MM-DD')                 업무시작일,
       TO_CHAR(end_date, 'YYYY-MM-DD')                   업무종료일,
       job_id                                            담당업무,
       department_id                                     부서번호 
FROM   job_history
--)
ORDER BY 사번, 업무시작일;
       
-- 사번, 직원명, 업무시작일, 엄무종료일, 담당업무명, 부서이름
SELECT e.employee_id                                         사번,
       e.first_name || '' || last_name                       직원명,
       e.hire_date                                           업무시작일,
       '제직중'                                              업무종료일,
       j.job_title                                           담당업무명,
       d.department_name                                     부서이름
FROM   employees        e
       JOIN departments d ON e.department_id = d.department_id
       JOIN jobs        j ON e.job_id        = j.job_id
UNION
SELECT h.employee_id                                         사번,
       e.first_name || '' || last_name                       직원명,
       h.start_date                                          업무시작일,
       h.end_date                                            업무종료일,
       j.job_title                                           담당업무명,
       d.department_name                                     부서이름
FROM   job_history      h
       JOIN employees   e ON h.employee_id   = e.employee_id
       JOIN departments d ON h.department_id = d.department_id
       JOIN jobs        j ON h.job_id        = j.job_id;
       
--                   ///////////////////////////////   

SELECT e.employee_id                                         사번,
       e.first_name || '' || last_name                       직원명,
       TO_CHAR(e.hire_date, 'YYYY-MM-DD')                    업무시작일,
       '제직중'                                              업무종료일,
       j.job_title                                           담당업무명,
       d.department_name                                     부서이름
FROM   employees        e
       JOIN departments d ON e.department_id = d.department_id
       JOIN jobs        j ON e.job_id        = j.job_id
UNION
SELECT h.employee_id                                         사번,
       e.first_name || '' || last_name                       직원명,
       TO_CHAR(h.start_date, 'YYYY-MM-DD')                   업무시작일,
       TO_CHAR(h.end_date,   'YYYY-MM-DD')                   업무종료일,
       j.job_title                                           담당업무명,
       d.department_name                                     부서이름
FROM   job_history      h
       JOIN employees   e ON h.employee_id   = e.employee_id
       JOIN departments d ON h.department_id = d.department_id
       JOIN jobs        j ON h.job_id        = j.job_id;       