-- 데이터베이스 스키마 생략 (Oracle은 기본적으로 사용자 스키마를 사용)

-- user 테이블 생성
CREATE TABLE user (
    id VARCHAR2(128) PRIMARY KEY, -- "email"
    jsonstr CLOB
);

-- feed 테이블 생성
CREATE TABLE feed (
    no NUMBER PRIMARY KEY, -- 시퀀스를 통해 자동 증가 처리
    id VARCHAR2(128),
    jsonstr CLOB
);

-- friend 테이블 생성
CREATE TABLE friend (
    id VARCHAR2(128), -- "email"
    frid VARCHAR2(128), -- "email"
    CONSTRAINT fk_friend_user FOREIGN KEY (id) REFERENCES user(id), -- 외래 키 설정
    CONSTRAINT fk_friend_frid FOREIGN KEY (frid) REFERENCES user(id) -- 외래 키 설정
);

-- feed 테이블의 자동 증가 번호를 위한 시퀀스 생성
CREATE SEQUENCE seq_feed_no
START WITH 1
INCREMENT BY 1
NOCACHE;

-- feed 테이블의 자동 증가 번호를 위한 트리거 생성
CREATE OR REPLACE TRIGGER trg_feed_no
BEFORE INSERT ON feed
FOR EACH ROW
BEGIN
    IF :NEW.no IS NULL THEN
        SELECT seq_feed_no.NEXTVAL INTO :NEW.no FROM DUAL;
    END IF;
END;
/
