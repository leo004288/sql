-- users 테이블
CREATE TABLE USERS (
    user_num        NUMBER(10)    NOT NULL PRIMARY KEY,
    user_id         VARCHAR2(255) NOT NULL UNIQUE,
    password        VARCHAR2(255) NOT NULL,
    email           VARCHAR2(320) NOT NULL,
    role            VARCHAR2(20)  CHECK (ROLE IN ('MEMBER', 'ADMIN')),
    is_deleted      NUMBER(1,0)   DEFAULT 0, 
    created_at      DATE          DEFAULT SYSDATE,
    updated_at      DATE          DEFAULT SYSDATE,
    deleted_at      DATE          ,
    last_login_date TIMESTAMP(6)     
);

-- 카테고리 테이블
CREATE TABLE pmt_categories (
    cat_id   VARCHAR2(10)    NOT NULL PRIMARY KEY, 
    cat_name VARCHAR2(100)   NOT NULL UNIQUE,              
    cat_seq  NUMBER(10)      NOT NULL             
);

-- PROMPT 테이블
CREATE TABLE PROMPT (
    id          NUMBER(10)         NOT NULL PRIMARY KEY,
    cat_id      VARCHAR2(10)       NOT NULL,
    user_num    NUMBER(10)         NOT NULL,               
    title       VARCHAR2(255)      NOT NULL,             
    content     VARCHAR2(4000)     NOT NULL,
    img         VARCHAR2(300)      ,
    Views       NUMBER(10)         DEFAULT 0, 
    like_cnt    NUMBER(10, 0)      DEFAULT 0,
    status      VARCHAR2(20)       DEFAULT 'NORMAL' NOT NULL 
                                   CONSTRAINT CK_PROMPT_STATUS CHECK (status IN ('NORMAL', 'DELETED', 'REPORTED')),
    created_at  DATE               DEFAULT SYSDATE,             
    updated_at  DATE               ,             
    deleted_at  DATE               ,
    reported_at DATE               ,
    
    CONSTRAINT FK_PROMPT_CAT_ID   FOREIGN KEY (cat_id)   REFERENCES pmt_categories (cat_id),
    CONSTRAINT FK_PROMPT_USER_NUM FOREIGN KEY (user_num) REFERENCES users          (user_num)
);

-- 프롬프트 추천 테이블 -- 중복방지
CREATE TABLE pmt_like (
    id        NUMBER(10) NOT NULL,
    user_num  NUMBER(10) NOT NULL,
    
    CONSTRAINT FK_PMT_LIKE_ID       FOREIGN KEY (id)       REFERENCES PROMPT     (id),
    CONSTRAINT FK_PMT_LIKE_USER_NUM FOREIGN KEY (user_num) REFERENCES users (user_num),
    
    CONSTRAINT PK_PMT_LIKE PRIMARY KEY (id, user_num)
);

-- 댓글 테이블
CREATE TABLE reply (
    re_id     NUMBER(10)     NOT NULL PRIMARY KEY,
    id        NUMBER(10)     NOT NULL,
    user_num  NUMBER(10)     NOT NULL,
    content   VARCHAR2(1000) NOT NULL,
    regdate   DATE           DEFAULT SYSDATE,

    CONSTRAINT FK_REPLY_ID       FOREIGN KEY (id)       REFERENCES PROMPT (id)      ON DELETE CASCADE,
    CONSTRAINT FK_REPLY_USER_NUM FOREIGN KEY (user_num) REFERENCES users  (user_num) ON DELETE CASCADE
);

--------------------------------------------------------------------------------
-- 게시판 수정일 트리거
CREATE OR REPLACE TRIGGER TRG_PROMPT_UPDATE
BEFORE UPDATE OF TITLE, CONTENT, IMG ON PROMPT
FOR EACH ROW
BEGIN
    :NEW.UPDATED_AT := SYSDATE;
END;
/
--------------------------------------------------------------------------------
-- 카테고리 추가
INSERT INTO pmt_categories VALUES ('MM_PMT', '이미지, 영상 프롬프트', 1);
INSERT INTO pmt_categories VALUES ('EDU_PMT', '공부 프롬프트', 2);
INSERT INTO pmt_categories VALUES ('RES_PMT', '리서치 프롬프트', 3);
INSERT INTO pmt_categories VALUES ('MYO_PMT', '명리학 프롬프트', 4);
INSERT INTO pmt_categories VALUES ('ETC_PMT', '기타 프롬프트', 5);

-- 유저추가
INSERT INTO users (
    user_num,
    user_id,
    password,
    email,
    role
) VALUES ( 1,
           'admin',
           :v2,
           :v3,
           :v4,
           :v5,
           :v6,
           :v7,
           :v8,
           :v9 );

-- PROMPT 추가
INSERT INTO PROMPT (id, cat_id, user_num, Title, Content)
VALUES ((SELECT NVL(MAX(id), 0) + 1 FROM PROMPT),'MM_PMT', 1, 'sapmle', 'aiedhid');
INSERT INTO PROMPT (id, cat_id, user_num, Title, Content)
VALUES ((SELECT NVL(MAX(id), 0) + 1 FROM PROMPT),'EDU_PMT','admin', 'sapmle', 'aiedhid');

-------------------------------------------------------------------------------
COMMIT;
DROP TABLE USERS;