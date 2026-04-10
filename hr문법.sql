-- 함수
-- 숫자
-- ABS()
-- CEIL(n) - 올림, FLOOR(n) - 내림 
SELECT CEIL(10.123), CEIL(10.541), CEIL(11.001)
FROM DUAL;

SELECT FLOOR(10.123), FLOOR(10.541), FLOOR(11.001)
FROM DUAL;

SELECT FLOOR(-10.123), FLOOR(-10.541), FLOOR(-11.001)
FROM DUAL;

--
SELECT TRUNC(-10.123), TRUNC(-10.541), TRUNC(-11.001)
FROM DUAL;

SELECT ROUND(0, 3), ROUND(115.155, -1), ROUND(115.155, -2)
FROM DUAL;

SELECT TRUNC(0, 3), TRUNC(115.155, -1), TRUNC(115.155, -2)
FROM DUAL;

--
-- POWER(2,3) : 제곱승 : 2의 3승
-- SQRT(n)    : 제곱근 : SQUARE ROOT
SELECT POWER(3, 2), POWER(3, 3), POWER(3, 3.0001)
FROM DUAL;

SELECT SQRT(2), SQRT(4)
FROM DUAL;

-- MOD(n1,n2), REMAINDER(n1,n2)
SELECT MOD(19,4), MOD(19.123, 4.2)
FROM DUAL;

SELECT REMAINDER(19,4), REMAINDER(19.123, 4.2)
FROM DUAL;

-- EXP(n), LN(n), LOG(n2,n1)
SELECT EXP(2), LN(2.713), LOG(10, 100)
FROM DUAL;

-- SIN(), COS(), TAN() : DEGREE(도) -> RADIAN(월주율/180 * 각도) -> 0.01745
-- SIN30 -> 0.5
SELECT SIN(30), SIN(30*0.01745)
FROM dual;

-- CONCAT(), SUBSTR(), SUBSTRB()
SELECT CONCAT('I Have', ' A Dream'), 'I Have' || ' A Dream'
FROM DUAL;

SELECT SUBSTR('ABCDEFG', 1, 4), SUBSTR('ABCDEFG', -5, 4)
FROM DUAL;

SELECT SUBSTRB('ABCDEFG', 1, 4), SUBSTRB('가나다라마바사', 1, 4)
FROM DUAL;

-- LTRIM(), RTRIM()
SELECT LTRIM('ABCDEFGABC', 'ABC'),
       LTRIM('가나다라', '가'),
       RTRIM('ABCDEFGABC', 'ABC'),
       RTRIM('가나다라', '라'),
       TRIM('         ABCDEFGABC         '),
       LENGTH( TRIM('         ABCDEFGABC         ') ),
       TRIM( LEADING ' ' 'FROM' ' ABCDE ' ),
       LENGTHTRIM( LEADING ' ' 'FROM' ' ABCDE ' )
FROM DUAL;

-- INSTR(str, substr, pos, occur) 
 SELECT INSTR('내가 만약 외로울 때면, 내가 만약 괴로울 때면, 내가 만약 즐거울 때면', '만약')       AS INSTR1,
        INSTR('내가 만약 외로울 때면, 내가 만약 괴로울 때면, 내가 만약 즐거울 때면', '만약', 5)    AS INSTR2,
        INSTR('내가 만약 외로울 때면, 내가 만약 괴로울 때면, 내가 만약 즐거울 때면', '만약', 5, 2) AS INSTR3
 FROM DUAL;

-- LENGTH(chr), LENGTHB(chr)    
 SELECT LENGTH('대한민국'),
        LENGTHB('대한민국')
 FROM DUAL;
--------------------------------------------------------------------------------
-- LPAD(expr1, n, expr2), RPAD(expr1, n, expr2)
CREATE TABLE ex4_1 (
                    phone_num VARCHAR2(30)
                    );

INSERT INTO ex4_1 VALUES ('111-1111');

INSERT INTO ex4_1 VALUES ('111-2222');

INSERT INTO ex4_1 VALUES ('111-3333');

SELECT *
FROM   ex4_1;

SELECT LPAD(phone_num, 12, '(02)')
FROM   ex4_1;

SELECT RPAD(phone_num, 12, '(02)')
FROM   ex4_1;

-- REPLACE(char, search_str, replace_str), TRANSLATE(expr, FROM_str, to_str)
SELECT REPLACE('나는 너를 모르는데 너는 나를 알겠는가?', '나', '너')
FROM DUAL;

SELECT LTRIM(' ABC DEF '),
       RTRIM(' ABC DEF '),
       REPLACE(' ABC DEF ', ' ', '')
FROM DUAL;

--------------------------------------------------------------------------------
-- SYSDATE, SYSTIMESTAMP
-- ADD_MONTHS (date, integer)
-- MONTHS_BETWEEN(date1, date2)
-- LAST_DAY(date)
-- ROUND(date, format), TRUNC(date, format)
-- NEXT_DAY (date, char)
-- LAST_DAY(date)
-- ROUND(date, format), TRUNC(date, format)
-- NEXT_DAY (date, char)
--------------------------------------------------------------------------------
-- TO_CHAR (숫자 혹은 날짜, format)
SELECT TO_CHAR(123456789, '999,999,999'),
       TO_CHAR(123456789, '$999,999,999'),
       TO_CHAR(123456789, 'L999,999,999'),
       TO_CHAR(1234567,   '99,999,999'),
       TO_CHAR(1234567,   '00,000,000'),
       TO_CHAR(123.45678, '000.000') -- 소수이하 자동 반올림 3자리
FROM   DUAL;

-- TO_NUMBER(expr, format)
-- TO_DATE(char, format), TO_TIMESTAMP(char, format)

-- GREATEST(expr1, expr2, …), LEAST(expr1, expr2, …)
    SELECT GREATEST(1, 2, 3, 2),
           LEAST(1, 2, 3, 2)
    FROM DUAL;