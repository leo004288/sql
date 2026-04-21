SELECT *
FROM   employees;

-- 직원번호, 직원이름, 월급, 입사일('2021-09-10 13:10:10"), 부서명을 조회하라
-- 모든 직원을 대상으로 부서가 없으면 '부서없음'으로 출력한다'
SELECT E.employee_id                                   직원번호, 
       E.first_name || ' ' || E.last_name              직원이름,
       E.salary                                        월급,    
       TO_CHAR(E.hire_date, 'YYYY-MM-DD HH24:mm:ss')   입사일,
       NVL(D.department_name, '부서없음')              부서명
FROM   employees E
       LEFT JOIN departments D ON E.department_id = D.department_id
ORDER BY E.employee_id;

-- 직원번호, 이름, 월급, 연봉(월급*12+월급*COMMISSION_PCT)을 출력하라
-- 부서번호 50,60,90 번 부서를 대상으로
-- 출력은 월급많은 순으로 한다
SELECT employee_id,
       first_name || ' ' || last_name,
       salary,
       연봉
FROM   employees
WHERE  department_id in (50,60,90)
ORDER BY salary DESC;


--월요일 입사한 사람의 명단을 출력하라



-- 부서번호, 부서이름, 부서별월급합, 부서별 평균월급을 회사의 모든 부서를 대상으로 출력