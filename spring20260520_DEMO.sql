CREATE TABLE PROMPT (
    Post_id    NUMBER(10, 0)      NOT NULL PRIMARY KEY,               
    User_id    VARCHAR2(50 BYTE)  NOT NULL,               
    Title      VARCHAR2(300 BYTE) NOT NULL,             
    Content    CLOB               NOT NULL,             
    Views      NUMBER(10, 0)      DEFAULT 0,              
    created_at DATE               DEFAULT SYSDATE,             
    UPDATED_AT DATE               ,             
    IS_DELETED CHAR(1 BYTE)       DEFAULT 'N' NOT NULL            
);

CREATE OR REPLACE TRIGGER TRG_PROMPT_UPDATE
BEFORE UPDATE ON PROMPT
FOR EACH ROW
BEGIN
    :NEW.UPDATED_AT := SYSDATE;
END;

INSERT INTO PROMPT (Post_id, User_id, Title, Content)
VALUES ((SELECT NVL(MAX(Post_id), 0) + 1 FROM PROMPT), 'aaa', 'sapmle', 'aiedhid');

DELETE 
FROM   PROMPT
WHERE  POST_id = 1

COMMIT;

DROP TABLE PROMPT;

