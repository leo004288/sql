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
 
 -- 전화번호에 100이 포함된 직원
SELECT employee_id, first_name, last_name, phone_number
 FROM  phone_number 
 ORDER BY employee_id DESC
 
 -- 50번 부서의 직원을 출력
 
 -- 부서가 없는 직원 출력