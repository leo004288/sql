-- TUSER
-- 아이디   문자(20)  필수입력 중복방지
-- 이름     문자(30)  필수입력
-- 이메일   문자(320) 중복방지

CREATE TABLE TUSER (
    USERID   VARCHAR2(20)  NOT NULL PRIMARY KEY,   
    USERNAME VARCHAR2(30)  NOT NULL,
    EMAIL VARCHAR2(320) UNIQUE
);

DROP TABLE TUSER;

INSERT INTO TUSER VALUES ('sky1', '스카이1', 'sky@green.com');
INSERT INTO TUSER VALUES ('sky2', '스카이2', 'sky2@green.com');
INSERT INTO TUSER VALUES ('sky3', '스카이3', 'sky3@green.com');
INSERT INTO TUSER VALUES ('sky4', '스카이4', 'sky4@green.com');
INSERT INTO TUSER VALUES ('sky5', '스카이5', 'sky5@green.com');

COMMIT;
ROLLback;

SELECT * FROM TUSER;

SELECT * FROM TUSER
WHERE  userid = 'sky1';

UPDATE tuser
SET    username = '스카이1',
       email    = 'sky1@green.com'
WHERE  userid   = 'sky1';

DELETE
FROM  tuser
WHERE userid = 'sea';



