-- 1.创建教学系统的数据库，表，以及数据
-- student(sno,sname,sage,ssex) 学生表
-- course(cno,cname,tno) 课程表
-- sc(sno,cno,score) 成绩表
-- teacher(tno,tname) 教师表

-- 2.创建教师表
drop table if exists teacher;
CREATE TABLE if not exists teacher(
    tno int(3) NOT NULL PRIMARY KEY,
    tname nvarchar(20) NOT NULL
);

-- 教师表数据
INSERT INTO teacher(tno,tname)VALUES(1,'张老师');
INSERT INTO teacher(tno,tname)VALUES(2,'王老师');
INSERT INTO teacher(tno,tname)VALUES(3,'李老师');
INSERT INTO teacher(tno,tname)VALUES(4,'赵老师');
INSERT INTO teacher(tno,tname)VALUES(5,'刘老师');
INSERT INTO teacher(tno,tname)VALUES(6,'向老师');
INSERT INTO teacher(tno,tname)VALUES(7,'李文静');
INSERT INTO teacher(tno,tname)VALUES(8,'叶平');

-- 3.创建学员表
drop table if exists student;
CREATE TABLE if not exists student(
    sno int NOT NULL PRIMARY KEY,
    sname nvarchar(20) NOT NULL,
    sage datetime NOT NULL,
    ssex char(2) NOT NULL
);

-- 插入数据
INSERT INTO student(sno,sname,sage,ssex) VALUES(1,'张三','1980-1-23','男');
INSERT INTO student(sno,sname,sage,ssex) VALUES(2,'李四','1982-12-12','男');
INSERT INTO student(sno,sname,sage,ssex) VALUES(3,'张飒','1981-9-9','男');
INSERT INTO student(sno,sname,sage,ssex) VALUES(4,'莉莉','1983-3-23','女');
INSERT INTO student(sno,sname,sage,ssex) VALUES(5,'王弼','1982-6-21','男');
INSERT INTO student(sno,sname,sage,ssex) VALUES(6,'王丽','1984-10-10','女');
INSERT INTO student(sno,sname,sage,ssex) VALUES(7,'刘香','1980-12-22','女');

-- 4.创建课程表
drop table if exists course;
CREATE TABLE if not exists course(
    cno int NOT NULL PRIMARY KEY,
    cname nvarchar(20) NOT NULL,
    tno int NOT NULL
);

-- 5.创建外键
ALTER TABLE course ADD
CONSTRAINT FK_course_teacher FOREIGN KEY(tno)
REFERENCES teacher(tno);

-- 插入数据
insert into course(cno,cname,tno) values(1,'企业管理',3);
insert into course(cno,cname,tno) values(2,'马克思',1);
insert into course(cno,cname,tno) values(3,'UML',2);
insert into course(cno,cname,tno) values(4,'数据库',5);
insert into course(cno,cname,tno) values(5,'物理',8);

-- 5.创建成绩表
drop table if exists sc;
CREATE TABLE if not exists sc(
    sno int NOT NULL,
    cno int NOT NULL,
    score int NOT NULL
);

-- 创建外键
ALTER TABLE sc ADD CONSTRAINT FK_sc_course FOREIGN KEY(cno)
REFERENCES course(cno);
ALTER TABLE sc ADD CONSTRAINT FK_sc_student FOREIGN KEY(sno)
REFERENCES student(sno);

-- 插入数据
INSERT INTO sc(sno,cno,score)VALUES(1,1,80);
INSERT INTO sc(sno,cno,score)VALUES(1,2,86);
INSERT INTO sc(sno,cno,score)VALUES(1,3,83);
INSERT INTO sc(sno,cno,score)VALUES(1,4,89);

INSERT INTO sc(sno,cno,score)VALUES(2,1,50);
INSERT INTO sc(sno,cno,score)VALUES(2,2,36);
INSERT INTO sc(sno,cno,score)VALUES(2,3,43);
INSERT INTO sc(sno,cno,score)VALUES(2,4,59);

INSERT INTO sc(sno,cno,score)VALUES(3,1,50);
INSERT INTO sc(sno,cno,score)VALUES(3,2,96);
INSERT INTO sc(sno,cno,score)VALUES(3,3,73);
INSERT INTO sc(sno,cno,score)VALUES(3,4,69);

INSERT INTO sc(sno,cno,score)VALUES(4,1,90);
INSERT INTO sc(sno,cno,score)VALUES(4,2,36);
INSERT INTO sc(sno,cno,score)VALUES(4,3,88);
INSERT INTO sc(sno,cno,score)VALUES(4,4,99);

INSERT INTO sc(sno,cno,score)VALUES(5,1,90);
INSERT INTO sc(sno,cno,score)VALUES(5,2,96);
INSERT INTO sc(sno,cno,score)VALUES(5,3,98);
INSERT INTO sc(sno,cno,score)VALUES(5,4,99);

INSERT INTO sc(sno,cno,score)VALUES(6,1,70);
INSERT INTO sc(sno,cno,score)VALUES(6,2,66);
INSERT INTO sc(sno,cno,score)VALUES(6,3,58);
INSERT INTO sc(sno,cno,score)VALUES(6,4,79);

INSERT INTO sc(sno,cno,score)VALUES(7,1,80);
INSERT INTO sc(sno,cno,score)VALUES(7,2,76);
INSERT INTO sc(sno,cno,score)VALUES(7,3,68);
INSERT INTO sc(sno,cno,score)VALUES(7,4,59);
INSERT INTO sc(sno,cno,score)VALUES(7,5,89);