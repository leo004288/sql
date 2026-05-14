-- 멀티게시판 자료실
CREATE TABLE FILES (
    FILE_NUM  NUMBER(6,0)   NOT NULL,               --파일고유넘버
    IDX       NUMBER(6,0)   NOT NULL,               --게시들 번호 : BOARD
    FILENAME  VARCHAR2(255) NOT NULL,               --파일이름
    FILEEXT   VARCHAR2(255) NOT NULL,               --파일확장자
    SFILENAME VARCHAR2(255) NOT NULL,               --저장된 실제 파일명
    
    CONSTRAINTS FILES_PK PRIMARY KEY                --기본키(복합키)
    (
        FILE_NUM,
        IDX
    ),
    CONSTRAINTS FK_BOARD_FILES_IDX
    FOREIGN KEY (IDX)
    REFERENCES  BOARD(IDX)
    ON DELETE   CASCADE
);

commit;

SELECT idx,
       menu_id,
       title,
       writer,
       (
        SELECT COUNT(FILE_NUM) FROM FILES F
        WHERE B.IDX = F.IDX
       )                                            filescount,
       regdate,
       hit
FROM   board B
WHERE  MENU_ID = 'MENU01'
ORDER BY IDX DESC;