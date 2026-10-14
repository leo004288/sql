INSERT INTO 학생 VALUES ('2020021', '철수', '전기', 90, '서울');
INSERT INTO 학생 VALUES ('2020001', '민수', '컴퓨터', 70, '대전');
INSERT INTO 학생 VALUES ('20211022', '영희', '건축', 85, '서울');
INSERT INTO 학생 VALUES ('2022013', '민호', '건축', 95, '원주');
INSERT INTO 학생 VALUES ('2020007', '병희', '컴퓨터', 100, '울산');
INSERT INTO 학생 VALUES ('2020008', '병희', NULL, 100, '울산');


-- 1. 학과별 튜플 수 조회 (COUNT(*) 사용)
SELECT 학과, COUNT(*) AS 학과별튜플수 
FROM 학생 
GROUP BY 학과;

-- 2. 학과별 튜플 수 조회 (COUNT(학번) 사용)
SELECT 학과, COUNT(학과) AS 학과별튜플수 
FROM 학생 
GROUP BY 학과;

SELECT COUNT(*)
FROM 학생 
WHERE 성적 >= 90;