CREATE TABLE ProjectUsers (
    ProjectUserID VARCHAR2(50) PRIMARY KEY,  -- 사용자 ID
    Email VARCHAR2(255) NOT NULL,            -- 이메일
    Name VARCHAR2(100) NOT NULL,             -- 이름
    Password VARCHAR2(255) NOT NULL,         -- 비밀번호
    CreatedAt DATE DEFAULT SYSDATE           -- 생성일
);
/

CREATE TABLE ProjectTeams (
    ProjectTeamID NUMBER PRIMARY KEY,            -- 팀 ID
    TeamName VARCHAR2(100) NOT NULL,             -- 팀 이름
    ProjectUserID VARCHAR2(50) REFERENCES ProjectUsers(ProjectUserID), -- 팀장 (사용자 ID 참조)
    CreatedAt DATE DEFAULT SYSDATE               -- 생성일
);

-- 시퀀스 생성
CREATE SEQUENCE ProjectTeam_Seq START WITH 1 INCREMENT BY 1;

-- 트리거 생성
CREATE OR REPLACE TRIGGER ProjectTeam_Trigger
BEFORE INSERT ON ProjectTeams
FOR EACH ROW
BEGIN
    IF :NEW.ProjectTeamID IS NULL THEN
        SELECT ProjectTeam_Seq.NEXTVAL INTO :NEW.ProjectTeamID FROM DUAL;
    END IF;
END;
/
CREATE TABLE Projects (
    ProjectID NUMBER PRIMARY KEY,               -- 프로젝트 ID
    ProjectName VARCHAR2(100) NOT NULL,         -- 프로젝트 이름
    ProjectTeamID NUMBER REFERENCES ProjectTeams(ProjectTeamID), -- 팀 ID 참조
    CreatedAt DATE DEFAULT SYSDATE              -- 생성일
);

-- 시퀀스 생성
CREATE SEQUENCE Project_Seq START WITH 1 INCREMENT BY 1;

-- 트리거 생성
CREATE OR REPLACE TRIGGER Project_Trigger
BEFORE INSERT ON Projects
FOR EACH ROW
BEGIN
    IF :NEW.ProjectID IS NULL THEN
        SELECT Project_Seq.NEXTVAL INTO :NEW.ProjectID FROM DUAL;
    END IF;
END;
/

CREATE TABLE ProjectGanttCharts (
    ProjectChartID NUMBER PRIMARY KEY,          -- 간트 차트 ID
    ProjectID NUMBER REFERENCES Projects(ProjectID), -- 프로젝트 ID 참조
    TaskName VARCHAR2(200) NOT NULL,            -- 작업명
    CreatedAt DATE DEFAULT SYSDATE              -- 생성일
);

-- 시퀀스 생성
CREATE SEQUENCE ProjectChart_Seq START WITH 1 INCREMENT BY 1;

-- 트리거 생성
CREATE OR REPLACE TRIGGER ProjectChart_Trigger
BEFORE INSERT ON ProjectGanttCharts
FOR EACH ROW
BEGIN
    IF :NEW.ProjectChartID IS NULL THEN
        SELECT ProjectChart_Seq.NEXTVAL INTO :NEW.ProjectChartID FROM DUAL;
    END IF;
END;
/

CREATE TABLE ProjectIssues (
    ProjectIssueID NUMBER PRIMARY KEY,          -- 이슈 ID
    ProjectUserID VARCHAR2(50) REFERENCES ProjectUsers(ProjectUserID), -- 사용자 ID 참조
    ProjectID NUMBER REFERENCES Projects(ProjectID), -- 프로젝트 ID 참조
    Title VARCHAR2(200) NOT NULL,               -- 제목
    Description CLOB,                           -- 설명
    CreatedAt DATE DEFAULT SYSDATE              -- 생성일
);

-- 시퀀스 생성
CREATE SEQUENCE ProjectIssue_Seq START WITH 1 INCREMENT BY 1;

-- 트리거 생성
CREATE OR REPLACE TRIGGER ProjectIssue_Trigger
BEFORE INSERT ON ProjectIssues
FOR EACH ROW
BEGIN
    IF :NEW.ProjectIssueID IS NULL THEN
        SELECT ProjectIssue_Seq.NEXTVAL INTO :NEW.ProjectIssueID FROM DUAL;
    END IF;
END;
/

CREATE TABLE ProjectComments (
    ProjectCommentID NUMBER PRIMARY KEY,       -- 코멘트 ID
    ProjectUserID VARCHAR2(50) REFERENCES ProjectUsers(ProjectUserID), -- 사용자 ID 참조
    ProjectIssueID NUMBER REFERENCES ProjectIssues(ProjectIssueID),    -- 이슈 ID 참조
    CommentText CLOB NOT NULL,                 -- 코멘트 내용
    CreatedAt DATE DEFAULT SYSDATE             -- 생성일
);

-- 시퀀스 생성
CREATE SEQUENCE ProjectComment_Seq START WITH 1 INCREMENT BY 1;

-- 트리거 생성
CREATE OR REPLACE TRIGGER ProjectComment_Trigger
BEFORE INSERT ON ProjectComments
FOR EACH ROW
BEGIN
    IF :NEW.ProjectCommentID IS NULL THEN
        SELECT ProjectComment_Seq.NEXTVAL INTO :NEW.ProjectCommentID FROM DUAL;
    END IF;
END;
/

CREATE TABLE ProjectDashboards (
    ProjectDashboardID NUMBER PRIMARY KEY,         -- 대시보드 ID
    ProjectID NUMBER REFERENCES Projects(ProjectID), -- 프로젝트 ID 참조
    Content CLOB,                             -- 대시보드 내용
    UpdatedAt DATE DEFAULT SYSDATE            -- 업데이트 날짜
);

-- 시퀀스 생성
CREATE SEQUENCE ProjectDashboard_Seq START WITH 1 INCREMENT BY 1;

-- 트리거 생성
CREATE OR REPLACE TRIGGER ProjectDashboard_Trigger
BEFORE INSERT ON ProjectDashboards
FOR EACH ROW
BEGIN
    IF :NEW.ProjectDashboardID IS NULL THEN
        SELECT ProjectDashboard_Seq.NEXTVAL INTO :NEW.ProjectDashboardID FROM DUAL;
    END IF;
END;
/

