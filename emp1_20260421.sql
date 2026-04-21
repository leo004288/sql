 CREATE TABLE mem (
 
    USERID         VARCHAR2(30)  NOT NULL PRIMARY KEY,   
    USERNAME       VARCHAR2(30)  NOT NULL,
    EMAIL          VARCHAR2(320) ,
    PHONE_NUMBER   VARCHAR2(30)  ,
    DEPARTMENTNAME VARCHAR2(30)  
 
 ); 
 
INSERT INTO mem VALUES ('ive1',   '장원영', 'JWY@ive.com',     '010-1234-5678', '아이브');
INSERT INTO mem VALUES ('aespa1', '카리나', 'krina@aespa.com', '010-5432-9876', '에스파');
INSERT INTO mem VALUES ('nmixx1', '설윤',   'SY@nmixx.com',    '010-1111-9999', '엔믹스');
INSERT INTO mem VALUES ('itzy1',  '유나',   'YuNa@itzy.com',   '010-1357-2468', '있지');
INSERT INTO mem VALUES ('ive2',   '안유진', 'YJ@ive.com',      '010-9764-8531', '아이브');

COMMIT;

SELECT *
FROM   mem;

UPDATE mem
 SET   phone_number = '010-2345-6789'
 WHERE userid = 'ive2';
 
DELETE  
 FROM  mem
 WHERE userid = 'ive2';
