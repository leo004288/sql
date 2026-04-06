SELECT * FROM TAB;

DESC EMPLOYEES;

SELECT * FROM employees;

-- 직원번호가 100인 사람을 출력
SELECT *
 FROM  employees
 WHERE employee_id = 100;
 
 -- 직원이름이 king인 사람 출력
SELECT *
 FROM  employees
 WHERE last_name = 'King';
 
 -- 월급순으로 출력
SELECT  employee_id, first_name, last_name, salary
 FROM   employees
 WHERE  salary >= 5000
 ORDER  BY salary DESC; 
 
 -- 전화번호에 010이 포함된 직원
SELECT employee_id, first_name, last_name, phone_number
 From  employees
 WHERE phone_number LIKE '%010%'
 ORDER BY employee_id ASC;
 
 -- 50번 부서의 직원을 출력
SELECT    employee_id                    "사 번",  -- 사번 : alias, 별칭
          first_name || '' || last_name   이름,
          department_id                   부서
 FROM     employees
 WHERE    department_id = 50
 --ORDER BY first_name ASC, last_name ASC;
 ORDER BY first_name || '' || last_name ASC;
 
 -- 부서가 없는 직원 출력
SELECT employee_id                       "사 번",
       first_name || '' || last_name      ENAME,
       department_id
 FROM  employees
 WHERE department_id IS NULL;    -- = NULL -> X / IS NULL, IS NOT NULL 사용