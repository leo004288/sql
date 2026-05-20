CREATE TABLE PROMPT (
    Post_id    NUMBER(10)    NOT NULL PRIMARY KEY,               
    User_id    VARCHAR2(10)   NOT NULL,               
    Title      VARCHAR2(255)  NOT NULL,             
    Content    VARCHAR2(4000) NOT NULL,             
    Views      NUMBER(9,0)    DEFAULT 0,              
    created_at VARCHAR2(255)  NOT NULL,             
    UPDATED_AT VARCHAR2(255)  NOT NULL,             
    IS_DELETED VARCHAR2(255)  NOT NULL             
);

COMMIT;

DROP TABLE PROMPT;
