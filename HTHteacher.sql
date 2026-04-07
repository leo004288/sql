/*
  HTH 계정생성후
  + 버튼 클릭후
 이름       : HTHteacher
 사용자 이름: hth
 비밀번호   : 1234
 호스트 이름: 192.168.0.246 : 접속할 ip 주소 (cmd : ipconfig)
 포트       : 1521 -> 방화벽 인바운드, 아웃바운드에 포트 1521 추가 필요
 SID        : xe
*/

INSERT INTO MYCLASS
 VALUES (1, '김경규', '010-6354-4288', 'LEO004288@GMAIL.COM', SYSDATE);
 COMMIT;
 
 SELECT * FROM MYCLASS
  ORDER BY 번호 ASC;