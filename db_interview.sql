  1*、查询课程编号为“001”的课程比“002”的课程成绩高的所有学生的学号

 SELECT
 	sc1.sno
 FROM
 	sc sc1,
 	sc sc2
 WHERE
 	sc1.score > sc2.score
 AND sc1.cno = 1
 AND sc2.cno = 2
 and sc1.sno=sc2.sno

 2、查询平均成绩大于60分的学生的学号和平均成绩

 SELECT
 	sno,
 	avg(score)
 FROM
 	sc
 GROUP BY
 	sno
 HAVING
 	avg(score) > 60

 3,查询所有学生的学号、姓名、选课数、总成绩

 SELECT
 	student.sno,
 	student.sname,
 	count(cno),
 	SUM(score)
 FROM
 	student
 INNER JOIN sc ON
 
 student.sno=sc.sno
 GROUP BY sc.sno

 4、查询姓“李”的老师的个数

SELECT
	count(tname)
FROM
	teacher
WHERE
	tname LIKE "李%"

 5,查询没学过“李美玲”老师课的学生的学号、姓名

 SELECT
 	DISTINCT
 	student.sno,
 	sname
 FROM
 	student,
 	teacher,
 	course,
 	sc
 WHERE
 	student.sno = sc.sno
 and course.cno=sc.cno
 and course.tno=teacher.tno
 and teacher.tname!="李美玲"

 6、查询学过编号为“001”的课程并且也学过编号为“002”的课程的学生的学号、姓名

 SELECT
 	student.sno,
 	sname
 FROM
 	student,
 	sc sc1,
 	sc sc2
 WHERE
 	student.sno = sc1.sno
 AND student.sno=sc2.sno
 and sc1.cno=1
 and sc2.cno=2
and sc1.sno=sc2.sno 

 7、查询学过“李多多”老师所教的所有课的学生的学号、姓名

SELECT
	student.sno,
	sname
FROM
	student,
	sc,
	course,
	teacher
WHERE
	student.sno = sc.sno
AND sc.cno=course.cno
and course.tno=teacher.tno
and teacher.tname="李老师";

8、查询课程编号为“002”的总成绩


SELECT
	SUM(score)
FROM
	sc
GROUP BY
	cno
HAVING
	cno = 2;

9、查询所有课程成绩小于60分的学生的学号、姓名

SELECT
	student.sno,
	sname
FROM
	student,
	sc
WHERE
	student.sno = sc.sno
GROUP BY
	sc.sno
HAVING
	AVG(sc.score) < 60;

10、查询没有学全所有课的学生的学号、姓名

SELECT
	student.sno,
	sname
FROM
	student,
	sc
WHERE
	student.sno = sc.sno
GROUP BY
	sc.sno
HAVING
	COUNT(sc.sno) < 5;

11、查询至少有一门课与学号为“1001”的学生所学课程相同的学生的学号和姓名

SELECT DISTINCT
	student.sno,
	sname
FROM
	student
INNER JOIN sc ON student.sno = sc.sno
WHERE
	sc.cno IN (SELECT cno FROM sc WHERE sno = 1)
  and sc.sno!=1;   

12*、查询所学课程和学号为“001”的学生所有课程一样的其他学生的学号和姓名

SELECT
	student.sno,
	student.sname
FROM
	student
INNER JOIN sc ON student.sno = sc.sno
GROUP BY sc.sno
HAVING group_concat(cno)=(select group_concat(cno) from sc where sc.sno=1)
and sc.sno!=1;  


13*、把“SC”表中“李多多”老师教的课的成绩都更改为此课程的平均成绩


UPDATE sc
INNER JOIN course ON sc.cno = course.cno
INNER JOIN teacher ON course.tno = teacher.tno
INNER JOIN (
	SELECT 
		sc.cno sc_cno,
		AVG(sc.score) avg_score
	FROM
		sc INNER JOIN course ON sc.cno = course.cno
		INNER JOIN teacher ON course.tno = teacher.tno
		GROUP BY sc.cno,teacher.tname
		having teacher.tname='李老师'
) a
on course.cno=a.sc_cno
SET sc.score =a.avg_score
WHERE
	teacher.tname = '李老师';


14、查询没有学习过“5”号课程的的学生的学号和姓名


SELECT
	sc.sno,
	student.sname
FROM
	student
INNER JOIN sc ON student.sno = sc.sno

GROUP BY sc.sno HAVING instr(group_concat(cno),'5')=0


15*、删除学习“李多多”老师课的SC表记录

delete sc from sc INNER JOIN course ON sc.cno=course.cno INNER JOIN teacher ON
teacher.tno=course.tno where teacher.tname='李老师';


16*、向SC表中插入一些记录这些记录要求符合以下条件：没有上过编号为“3”课程的学生的学号、编号为2的课程的平均成绩

INSERT INTO sc (sno, cno, score) SELECT
	sno,
	8,
	(select AVG(score) from sc where cno=2)
from sc
where
	sno not in (select DISTINCT sno from sc where cno =3);
	

17、按平均成绩从高到低显示所有学生的“数据库”、“企业管理”、“英语”三门的课程成绩，其中数据库的cno为4，企业管理的cno为1，英语的cno为5，按如下形式显示：
		学生ID 数据库企业管理英语有效课程数 有效平均成绩


SELECT
DISTINCT
	sc.sno,
	a.num,
	b.avg_score
FROM
	sc
INNER JOIN
	(
		SELECT
			sno,
			COUNT(cno) num
		FROM
			sc
		WHERE
			cno = 4
		OR cno = 1
		OR cno = 5
		GROUP BY
			sno
	) a on sc.sno=a.sno
	INNER JOIN
	(
		SELECT
			sno,
			AVG(score) avg_score
		FROM
			sc
		WHERE
			cno = 4
		OR cno = 1
		OR cno = 5
		GROUP BY
			sno
	) b on sc.sno=b.sno   vc 

GROUP BY
	sc.sno
ORDER BY b.avg_score desc;



18、查询各科成绩最高和最低的分，以如下形式显示 课程ID 最高分 最低分   


select cno,MAX(score),MIN(score) from sc GROUP BY cno;



19、按各科平均成绩从低到高和及格率的百分数从高到低排列，以如下形式显示：

SELECT
	sc.sno,
	AVG(score) avg_score,
	ROUND(a.a_count / COUNT(sc.sno), 2) pass_rate
FROM
	sc
INNER JOIN (
	SELECT
		sc.sno,
		COUNT(1) a_count
	FROM
		sc
	WHERE
		score >= 60
	GROUP BY
		sc.sno
) a ON sc.sno = a.sno
GROUP BY
	sc.sno
ORDER BY avg_score,pass_rate desc;


20、查询如下课程平均成绩和及格率的百分数（用1行显示），其中企业管理为001，马克思为002，UML为003，数据库为004

SELECT
	cno,
	AVG(score) avg_score,
	ROUND(
		SUM(
			CASE
			WHEN score >= 60 THEN
				1
			ELSE
				0
			END
		) / SUM(1),
		2
	)
FROM
	sc
GROUP BY
	cno
HAVING
	cno = 1
OR cno = 2
OR cno = 3
OR cno = 4;


21、查询不同老师所教不同课程平均分从高到低显示


SELECT
	tname,
	sc.cno,
	AVG(score) avg_score
FROM
	course
INNER JOIN teacher ON course.tno = teacher.tno
INNER JOIN sc ON course.cno = sc.cno
GROUP BY
	tname,
	sc.cno
ORDER BY
	avg_score;


22*、查询如下课程成绩第3名到第6名的学生成绩单，其中企业管理为001，马克思为002，UML为003，数据库为004，以如下形式显示：
学生ID 学生姓名 企业管理 马克思 UML 数据库 平均成绩


SELECT
	sc1.sno AS '学生ID',
	student.sname AS '学生姓名',
	sc1.score AS '企业管理',
	sc2.score AS '马克思',
	sc3.score AS 'UML',
	sc4.score AS '数据库',
	a3.avg_score as '平均成绩'
FROM
	sc sc1
INNER JOIN sc sc2 ON sc1.sno = sc2.sno
INNER JOIN sc sc3 ON sc2.sno = sc3.sno
INNER JOIN sc sc4 ON sc3.sno = sc4.sno
INNER JOIN student ON sc1.sno = student.sno
INNER JOIN (
			SELECT
				sno,
				AVG(score) avg_score
			FROM
				sc
			WHERE
				cno = 1
			OR cno = 2
			OR cno = 3
			OR cno = 4
			GROUP BY
				sno
			ORDER BY
				avg_score DESC
		) a3 on sc1.sno=a3.sno
WHERE
	sc1.cno = 1
AND sc2.cno = 2
AND sc3.cno = 3
AND sc4.cno = 4
AND sc1.sno IN (
	SELECT
		a1.sno
	FROM
		(
			SELECT
				sno,
				AVG(score) avg_score
			FROM
				sc
			WHERE
				cno = 1
			OR cno = 2
			OR cno = 3
			OR cno = 4
			GROUP BY
				sno
			ORDER BY
				avg_score DESC
		) a1
	INNER JOIN (
		SELECT
			b.sno a2_sno,
			(@i :=@i + 1) num
		FROM
			(
				SELECT
					sno,
					AVG(score) avg_score
				FROM
					sc
				WHERE
					cno = 1
				OR cno = 2
				OR cno = 3
				OR cno = 4
				GROUP BY
					sno
				ORDER BY
					avg_score DESC
			) b,
			(SELECT @i := 0) s
	) a2 ON a1.sno = a2.a2_sno
	WHERE
		num BETWEEN 3
	AND 6
) ORDER BY a3.avg_score desc



23、使用分段[100-85],[85-70],[70-60],[<60]来统计各科成绩，分别统计各分数段人数：课程ID和课程名称



SELECT
	sc.cno,
	cname,
	SUM(
		CASE
		WHEN score >= 85
		AND score <= 100 THEN
			1
		ELSE
			0
		END
	) AS '[100-85]',
	SUM(
		CASE
		WHEN score >= 70
		AND score < 85 THEN
			1
		ELSE
			0
		END
	) AS '[85-70]',
  SUM(
		CASE
		WHEN score >= 60
		AND score < 70 THEN
			1
		ELSE
			0
		END
	) AS '[70-60]',   
	SUM(
		CASE
		WHEN 
		 score < 60 THEN
			1
		ELSE
			0
		END
	) AS '[<60]'
FROM course INNER JOIN sc on course.cno=sc.cno
GROUP BY sc.cno



24、查询学生平均成绩及其名次


SELECT
			b.sno as '学号',
			b.avg_score as '平均成绩',
			(@i :=@i + 1) as '名次'
		FROM
			(
				SELECT
					sno,
					AVG(score) avg_score
				FROM
					sc
				GROUP BY
					sno
				ORDER BY
					avg_score DESC
			) b,
			(SELECT @i := 0) s

 
25*、查询各科成绩前三名的记录（不考虑成绩并列情况）


SELECT
	sc1.sno,
	sc1.cno,
	sc1.score,
	SUM(
		CASE
		WHEN sc2.score > sc1.score THEN
			1
		ELSE
			0
		END
	) + 1 rank
FROM
	sc sc1  
INNER JOIN sc sc2 ON sc1.cno = sc2.cno

GROUP BY
	sc1.cno,
	sc1.sno,
	sc1.score

HAVING rank<=3





26、查询每门课程被选修的学生数

SELECT cno, count(1) as student_num from sc GROUP BY cno;


27、查询出只选修了一门课程的全部学生的学号和姓名

SELECT sc.sno,sname FROM sc INNER JOIN student on sc.sno=student.sno GROUP BY sc.sno HAVING COUNT(cno)=1



28、查询男生、女生人数

SELECT SUM(CASE WHEN ssex='男' then 1 else 0 END) as '男生',SUM(CASE WHEN ssex='女' then 1 else 0 END) as '女生' from student;



29、查询姓“张”的学生名单
SELECT * from student WHERE sname like '张%'


30、查询同名同姓学生名单并统计同名人数


SELECT
	s1.sname,
	count(*) AS '人数'
FROM
	student s1,
	student s2
WHERE
	s1.sno != s2.sno
AND s1.sname = s2.sname
GROUP BY
	s1.sname


31、1981年出生的学生名单（注：STUDENT表中SAGE列的类型是DATE）

select * FROM student where sage LIKE '1981%'



32、查询每门课程的平均成绩，结果按平均成绩升序排列，平均成绩相同时按课程号降序排列

SELECT cno as '课程号', AVG(score) as avg_score from sc GROUP BY cno ORDER BY avg_score,cno desc



33、查询平均成绩大于85的所有学生的学号、姓名和平均成绩

SELECT sc.sno,sname,AVG(score) as avg_score FROM sc INNER JOIN student on sc.sno=student.sno
GROUP BY sc.sno HAVING avg_score>85



34、查询课程名称为“数据库”且分数低于60的学生姓名和分数


SELECT
	sname,
	score
FROM
	student
INNER JOIN sc ON student.sno = sc.sno INNER JOIN course on sc.cno=course.cno
WHERE
	cname = "数据库"
AND score < 60


35、查询所有学生的选课情况


SELECT sno,GROUP_CONCAT(cno) from sc GROUP BY sno;


36、查询任何一门课程成绩在70分以上的姓名、课程名称和分数


SELECT
	sname,
	cname,
	score
FROM
	student
INNER JOIN sc ON student.sno = sc.sno
INNER JOIN course ON sc.cno = course.cno
WHERE
	sc.sno IN (
		SELECT
			sno
		FROM
			sc
		WHERE
			score > 70
	)
GROUP BY
	sname,
	cname,
	score


37、查询不及格的课程并按课程号从大到小排列


  select  DISTINCT cno from sc where score <60 order by cno desc



38、查询课程编号为003且课程成绩在80分以上的学生的学号和姓名


SELECT
	student.sno,
	sname
FROM
	student
INNER JOIN sc ON student.sno = sc.sno
WHERE
	cno = 3
AND score > 80


39、查询选了课程的学生人数

SELECT COUNT(sno_count) from (SELECT COUNT(sno) as sno_count from sc GROUP BY sno HAVING COUNT(cno)>0) a


40、查询选修“李多多”老师所授课程的学生中成绩最高的学生姓名及其成绩

SELECT sname,score from student INNER JOIN sc on student.sno=sc.sno
where score=

(SELECT
	MAX(score) max_score
FROM
	student
INNER JOIN sc ON student.sno = sc.sno
INNER JOIN course on course.cno=sc.cno
INNER JOIN teacher ON course.tno=teacher.tno
where tname="李老师"
GROUP BY teacher.tno
) 


41、查询各个课程及相应的选修人数


SELECT cno, COUNT(sno) FROM sc GROUP BY cno


42*、查询有2门不同课程成绩相同的学生的学号、课程号、学生成绩


SELECT sno,GROUP_CONCAT(cno),score FROM sc GROUP BY sno,score HAVING COUNT(score)=2


43*、查询每门课程成绩最好的前两名(分组topN)
(每门课程选修的每个学生与每门课程选修的所有学生的成绩相比较)

SELECT
* from(
SELECT
	sc1.cno,
sc1.sno,
	SUM(CASE WHEN sc2.score>sc1.score then 1 else 0 end)+1 as rank_score
FROM
	sc sc1 INNER JOIN sc sc2 on sc1.cno=sc2.cno

GROUP BY sc1.cno,sc1.sno

) a
WHERE a.rank_score<=2



44、查询每门课程的学生选修人数，超过5人的课程才统计。
要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同按课程号升序排列


SELECT cno,COUNT(sno) sno_num FROM sc GROUP BY cno HAVING sno_num>=5 ORDER BY sno_num desc,cno



45、查询至少选修两门课程的学生学号

SELECT sno ,COUNT(cno) cno_num from sc GROUP BY sno HAVING cno_num>=2



46、查询全部学生都选修的课程的课程号和课程名

SELECT course.cno,cname from sc INNER JOIN course on sc.cno=course.cno GROUP BY cno HAVING COUNT(sno)=(SELECT COUNT(DISTINCT sno) FROM sc)


47、查询没学过“李多多”老师讲授的任一门课程的学生姓名

SELECT
a.sname
FROM
(
SELECT
	sname,SUM(CASE WHEN sname="李老师" then 1 else 0 end) sum_value
FROM
	student
INNER JOIN sc ON student.sno = sc.sno
INNER JOIN course ON sc.cno=course.cno
INNER JOIN teacher on course.tno=teacher.tno
GROUP BY sname
) a

where a.sum_value=0                                                                          



48、查询两门以上不及格课程的同学的学号及其平均成绩


SELECT sno,AVG(score) from sc WHERE sno in (SELECT sno from (SELECT sno,SUM(case WHEN score<60 THEN 1 ELSE 0 end)+1 sum_score from sc GROUP BY sno HAVING sum_score>=2) a ) GROUP BY sno


49、检索课程编号为“004”且分数小于60的学生学号，结果按按分数降序排列


SELECT sno from sc  where cno=4 and score <60 ORDER BY score desc



50、删除学生编号为“002”的课程编号为“001”的课程的成绩


update sc set score=0 where sno=2 and cno=1

















