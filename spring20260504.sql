CREATE TABLE BOARD (
    IDX     NUMBER(8,0)    PRIMARY KEY,
    MENU_ID VARCHAR2(6)    REFERENCES MENUS (MENU_ID),
    title   VARCHAR2(300)  NOT NULL,
    CONTENT VARCHAR2(4000) ,
    WRITER  VARCHAR2(12)   ,
    REGDATE DATE           DEFAULT SYSDATE,
    HIT     NUMBER(9,0)    DEFAULT 0
);

INSERT INTO board ( idx, menu_id, title, content, writer)
VALUES ((SELECT NVL(MAX(IDX), 0)+1 FROM BOARD), 'MENU01', 'java Hello', '자바게시판에 오신것을 환영합니다', 'java');

INSERT INTO board ( idx, menu_id, title, content, writer)
VALUES ((SELECT NVL(MAX(IDX), 0)+1 FROM BOARD), 'MENU02', 'spring Hello', '스프링게시판에 오신것을 환영합니다', 'spring');

COMMIT;

SELECT idx,
       menu_id,
       title,
       writer,
       TO_CHAR(regdate, 'YYYY-MM-DD')       regdate,
       hit
FROM   board
WHERE  menu_id = 'MENU01'
ORDER BY idx DESC;

SELECT
    IDX,
    MENU_ID,
    TITLE,
    CONTENT,
    WRITER,
    REGDATE,
    HIT
FROM
    BOARD
WHERE IDX = 1;

INSERT INTO board (idx, menu_id, title, content, writer)
VALUES (SELECT NVL(MAX(IDX),0)+1 FROM BOARD), 'MENU01', 'java Hello', '자바게시판에 오신것을 환영합니다', 'java' );
	
SELECT MENU_NAME
FROM   MENUS  
WHERE  MENU_ID = 'MENU01';

