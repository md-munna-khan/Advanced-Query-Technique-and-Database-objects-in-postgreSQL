CREATE Table departments(
    id SERIAL PRIMARY KEY,
department_name VARCHAR(50)
    
);
INSERT INTO departments (department_name) VALUES
('Computer Science'),
('Mathematics'),
('Physics'),
('Chemistry'),
('Biology'),
('Economics'),
('History'),
('English'),
('Philosophy'),
('Engineering');


DROP Table departments;


CREATE Table students(
    id SERIAL PRIMARY KEY,
    student_name VARCHAR(50),
    student_age INT,
    student_score NUMERIC(6,2),
    department_id INT ,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);
INSERT INTO students (student_name, student_age, student_score, department_id) VALUES
('Munna', 21, 88.50, 1),
('Mezba', 22, 91.00, 2),
('Miraz', 23, 85.75, 3),
('Rony', 20, 79.40, 4),
('Sadia', 24, 95.25, 5),
('Nusaiba', 22, 89.90, 6),
('Rahim', 23, 81.30, 7),
('Karim', 25, 87.00, 8),
('Ayman', 21, 90.10, 9),
('Mahi', 22, 76.45, 10);


DROP Table students;


CREATE Table course_enrollments (
    id SERIAL PRIMARY KEY,
    student_id INT, 
    course_title TEXT,
    enrolled_on DATE,
    FOREIGN KEY (student_id) REFERENCES students(id)
);
INSERT INTO course_enrollments (student_id, course_title, enrolled_on) VALUES
(1, 'Database Systems', '2025-01-10'),
(2, 'Linear Algebra', '2025-01-11'),
(3, 'Quantum Mechanics', '2025-01-12'),
(4, 'Organic Chemistry', '2025-01-13'),
(5, 'Genetics', '2025-01-14'),
(6, 'Microeconomics', '2025-01-15'),
(7, 'World History', '2025-01-16'),
(8, 'Shakespeare Studies', '2025-01-17'),
(9, 'Ethics & Logic', '2025-01-18'),
(10, 'Electrical Circuits', '2025-01-19');


drop Table course_enrollments;
 SELECT * from course_enrollments;

 
SELECT * from departments;
 
 SELECT * from students;


 

 --Retrieve all students who scored higher than the average score.
 SELECT * FROM students WHERE student_score > (SELECT avg(student_score) from students );

 ---Find students whose age is greater than the average age of all students.

 SELECT * from students WHERE student_age > ( SELECT avg(student_age) FROM students );

 --Get names of students who are enrolled in any course (use IN with subquery)
 SELECT student_name from students
  join course_enrollments on students.id = course_enrollments.student_id;

 SELECT student_name from students
 WHERE id in( SELECT student_id from course_enrollments);

--Retrieve departments with at least one student scoring above 90 (use EXISTS).
 SELECT * from departments d WHERE EXISTS 
  ( SELECT 1 FROM students s where s.department_id = d.id AND s.student_score >90 )

---Views in PostgreSQL (Based on 10-4)-------------------
--Create a view to show each student’s name, department, and score.

CREATE View student_info
as 
SELECT department_id, student_name,student_score,department_name FROM students 
join departments on students.department_id= departments.id;

SELECT * from student_info;
DROP View student_info

-- Create a view that lists all students enrolled in any course with the enrollment date.

CREATE View student_enrolled
as 
SELECT student_name, course_title, enrolled_on from students
join course_enrollments on students.id=course_enrollments.student_id

SELECT * from student_enrolled;
DROP View student_enrolled

--- Functions in PostgreSQL (Based on 10-5)     

-- Create a function that takes a student's score and returns a grade (e.g., A, B, C, F).

CREATE or REPLACE FUNCTION student_grade(score NUMERIC)
RETURNS text
LANGUAGE plpgsql
as 

$$
BEGIN
if score >=90 THEN RETURN 'A';
ELSEIF score >=80 THEN RETURN 'B';
ELSEIF score >=70 THEN RETURN 'C';
ELSE  RETURN 'F';
end if;
end
$$;

SELECT student_grade(67);

--Create a function that returns the full name and department of a student by ID.

-- CREATE or REPLACE FUNCTION return_nam_dep(p_stu_id int)
-- RETURNS text
-- LANGUAGE plpgsql
-- AS
-- $$
-- BEGIN
-- SELECT  department_name from departments WHERE department.id=(p_stu_id);
-- end
-- $$;

-- DROP FUNCTION return_nam_dep

-- SELECT return_nam_dep(8);

-- Stored Procedures (Based on 10-6)

--- Write a stored procedure to update a student's department.
CREATE Procedure Update_department(
   p_student_id int,
   p_new_department_id int
)
LANGUAGE plpgsql
as 
$$
BEGIN
UPDATE students 
set department_id= p_new_department_id
WHERE id= p_student_id ;

END
$$;
call update_department(2,4);

SELECT * FROM departments;
SELECT * FROM students;

SELECT * FROM students WHERE id = 2;

SELECT * FROM departments WHERE id = 4;

SELECT id, student_name, department_id FROM students WHERE id = 2;

---Create a trigger that automatically logs enrollment when a student is added to course_enrollments.
CREATE Table logs_enroll(
    inserted_user_name VARCHAR(50),
    insertAt TIMESTAMP
);



SELECT * from logs_enroll;

CREATE  Function insert_update_enrolled()
RETURNS TRIGGER
LANGUAGE PLPGSQL
as 
$$
BEGIN
INSERT INTO logs_enroll VALUES(NEW.student_name,now());
RAISE NOTICE 'insert students logs';
RETURN NEW
END
$$


CREATE Trigger save_enroll_users
AFTER INSERT
on course_enrollments
for EACH row 
EXECUTE FUNCTION  insert_update_enrolled();

INSERT INTO course_enrollments (student_id, course_title, enrolled_on)
VALUES (1, 'Web Development', CURRENT_DATE);