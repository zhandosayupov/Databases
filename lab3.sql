-- FIRST TASK --
--	a.
--
SELECT * FROM course WHERE course.credits > 3;
--	b.
--
SELECT * FROM classroom 
WHERE (classroom.building = 'Watson' OR 
classroom.building = 'Packard');
-- 	c.
--
SELECT * FROM course WHERE course.dept_name = 'Comp. Sci.';
--	d.
--
SELECT course.course_id, title, dept_name, credits 
FROM course,section WHERE course.course_id = section.course_id 
AND section.semester = 'Fall';
-- 	e.
--
SELECT* FROM student WHERE student.tot_cred > 45 AND 
student.tot_cred < 90;
--	f.
--
SELECT * FROM student WHERE student.name ~ '[aeiuoy]$';
--	g.
--
SELECT course.course_id, title, dept_name, credits
FROM course, prereq
WHERE prereq.course_id = course.course_id and prereq_id='CS-101';
-- SECOND TASK --
--	a.
--
SELECT dept_name, avg(instructor.salary) 
FROM instructor GROUP BY dept_name 
ORDER BY avg(instructor.salary) ASC;
--	b.
--
SELECT department.building, count(1) FROM department, section
WHERE department.building = section.building
GROUP BY department.building
HAVING count(1) = (
	SELECT MAX(second.number) FROM (
		SELECT count(1) AS number FROM department, section 
		WHERE department.building = section.building
		GROUP BY department.building) 
	AS second);
--  c.
--
SELECT department.dept_name, count(1) FROM department, course
WHERE department.dept_name = course.dept_name
GROUP BY department.dept_name
HAVING count(1) = (
	SELECT MIN(second.number) FROM (
		SELECT count(1) AS number FROM department, course
		WHERE department.dept_name = course.dept_name
		GROUP BY department.dept_name) 
	AS second);
--	d.
--
SELECT student.id, student.name FROM student
WHERE student.id IN (
	SELECT third.id FROM (
		SELECT student.id, count(1) AS number
		FROM student,takes,course 
		WHERE student.id = takes.id 
		AND takes.course_id = course.course_id 
		AND course.dept_name = 'Comp. Sci.' 
		GROUP BY student.id)
	AS third WHERE third.number>3);
--	e.
--
SELECT * FROM instructor 
WHERE instructor.dept_name = 'Biology' 
OR instructor.dept_name = 'Philosophy' 
OR instructor.dept_name = 'Music';
--  f.
--
SELECT DISTINCT instructor.id, instructor.name, 
instructor.dept_name, instructor.salary
FROM instructor, teaches
WHERE instructor.id = teaches.id and teaches.year = 2018
AND teaches.id NOT IN (
	SELECT DISTINCT instructor.id 
	FROM instructor, teaches
	WHERE instructor.id = teaches.id and teaches.year = 2017);
--	THIRD TASK --
--  a.
--
SELECT DISTINCT student.id, student.name, 
student.dept_name, student.tot_cred 
FROM student, takes, course 
WHERE student.id = takes.id AND takes.course_id = course.course_id 
AND course.dept_name = 'Comp. Sci.' 
AND (takes.grade = 'A' OR takes.grade = 'A-')
ORDER BY student.name;
--  b.
--
SELECT * FROM instructor WHERE instructor.id IN(
	SELECT DISTINCT advisor.i_id FROM advisor,student,takes
	WHERE advisor.s_id = student.id AND takes.id = student.id
	AND (takes.grade != 'A' AND takes.grade != 'A-' 
	AND takes.grade != 'B+'AND takes.grade != 'B' 
	OR takes.grade IS NULL));
--  c.
--
SELECT * FROM department 
WHERE department.dept_name NOT IN (
	SELECT DISTINCT department.dept_name 
	FROM department,student,takes
	WHERE department.dept_name = student.dept_name 
	AND student.id=takes.id 
	AND (takes.grade ='F' OR takes.grade = 'C'));
--  d.
--
SELECT * FROM instructor 
WHERE instructor.id NOT IN (
	SELECT DISTINCT instructor.id FROM instructor, teaches, takes
	WHERE instructor.id = teaches.id AND 
	teaches.course_id = takes.course_id AND takes.grade = 'A');
--	e.
--
SELECT course.course_id,course.title,course.dept_name, course.credits 
FROM course, section, time_slot 
WHERE section.time_slot_id = time_slot.time_slot_id 
AND ((time_slot.end_hr <= 12 AND time_slot.end_min <= 59) 
OR (time_slot.end_hr = 13 and time_slot.end_min = 0));