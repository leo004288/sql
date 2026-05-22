-- PROMPT 테이블
CREATE TABLE PROMPT (
    Post_id    NUMBER(10, 0)      NOT NULL PRIMARY KEY,
    cat_id     VARCHAR2(10 BYTE)  NOT NULL,
    User_id    VARCHAR2(50 BYTE)  NOT NULL,               
    Title      VARCHAR2(300 BYTE) NOT NULL,             
    Content    CLOB               NOT NULL,             
    Views      NUMBER(10, 0)      DEFAULT 0,              
    created_at DATE               DEFAULT SYSDATE,             
    UPDATED_AT DATE               ,             
    IS_DELETED CHAR(1 BYTE)       DEFAULT 'N' NOT NULL            
);

-- 카테고리 테이블
CREATE TABLE PROMPT_CATEGORY (
    cat_id   VARCHAR2(10 BYTE)    NOT NULL PRIMARY KEY, 
    cat_name VARCHAR2(100 BYTE)   NOT NULL,              
    cat_seq  VARCHAR2(100 BYTE)   NOT NULL             
);

-- 트리거
CREATE OR REPLACE TRIGGER TRG_PROMPT_UPDATE
BEFORE UPDATE ON PROMPT
FOR EACH ROW
BEGIN
    :NEW.UPDATED_AT := SYSDATE;
END;

-- PROMPT 추가
INSERT INTO PROMPT (Post_id, cat_id, User_id, Title, Content)
VALUES ((SELECT NVL(MAX(Post_id), 0) + 1 FROM PROMPT),'MM_PMT','aaa', 'sapmle', 'aiedhid');
INSERT INTO PROMPT (Post_id, cat_id, User_id, Title, Content)
VALUES ((SELECT NVL(MAX(Post_id), 0) + 1 FROM PROMPT),'EDU_PMT','aaa', 'sapmle', 'aiedhid');

-- 카테고리 추가
INSERT INTO PROMPT_CATEGORY VALUES ('MM_PMT', '이미지, 영상 프롬프트', 1);
INSERT INTO PROMPT_CATEGORY VALUES ('EDU_PMT', '공부 프롬프트', 2);
INSERT INTO PROMPT_CATEGORY VALUES ('RES_PMT', '리서치 프롬프트', 3);
INSERT INTO PROMPT_CATEGORY VALUES ('MYO_PMT', '명리학 프롬프트', 4);
INSERT INTO PROMPT_CATEGORY VALUES ('ETC_PMT', '기타 프롬프트', 5);

-------------------------------------------------------------------------------
COMMIT;

DROP TABLE PROMPT_CATEGORY;


