-- DBMS LAB PBL PROJECT
-- College Internship & Placement Management System
-- MySQL 8.x

DROP DATABASE IF EXISTS internship_placement_db;
CREATE DATABASE internship_placement_db;
USE internship_placement_db;

CREATE TABLE Department (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    roll_no VARCHAR(20) NOT NULL UNIQUE,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(15),
    year_of_study INT NOT NULL,
    department_id INT NOT NULL,
    cgpa DECIMAL(3,2),
    FOREIGN KEY (department_id) REFERENCES Department(department_id),
    CHECK (year_of_study BETWEEN 1 AND 4),
    CHECK (cgpa BETWEEN 0 AND 10)
);

CREATE TABLE Company (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(120) NOT NULL UNIQUE,
    industry VARCHAR(80),
    location VARCHAR(100),
    website VARCHAR(150)
);

CREATE TABLE Job (
    job_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    job_title VARCHAR(120) NOT NULL,
    job_type ENUM('Internship','Full-Time') NOT NULL,
    stipend_or_ctc DECIMAL(12,2),
    required_cgpa DECIMAL(3,2),
    openings INT NOT NULL,
    deadline DATE NOT NULL,
    FOREIGN KEY (company_id) REFERENCES Company(company_id),
    CHECK (required_cgpa BETWEEN 0 AND 10),
    CHECK (openings > 0)
);

CREATE TABLE Skill (
    skill_id INT PRIMARY KEY AUTO_INCREMENT,
    skill_name VARCHAR(80) NOT NULL UNIQUE,
    category VARCHAR(80)
);

CREATE TABLE Student_Skill (
    student_id INT NOT NULL,
    skill_id INT NOT NULL,
    proficiency ENUM('Beginner','Intermediate','Advanced') NOT NULL,
    PRIMARY KEY (student_id, skill_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES Skill(skill_id) ON DELETE CASCADE
);

CREATE TABLE Application (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    job_id INT NOT NULL,
    application_date DATE NOT NULL,
    status ENUM('Applied','Shortlisted','Interview','Selected','Rejected') DEFAULT 'Applied',
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (job_id) REFERENCES Job(job_id),
    UNIQUE (student_id, job_id)
);

INSERT INTO Department (department_name) VALUES
('Computer Science & Engineering'),
('Information Technology'),
('Electronics & Telecommunication');

INSERT INTO Student
(roll_no, student_name, email, phone, year_of_study, department_id, cgpa) VALUES
('CSE101','Shivraj Dhumale','shivraj@example.com','9000000001',2,1,8.10),
('CSE102','Mangesh Dhamke','mangesh@example.com','9000000002',2,1,8.45),
('CSE103','Gauree Dikkatwar','gauree@example.com','9000000003',2,1,8.70),
('CSE104','Shravani Deshmukh','shravani@example.com','9000000004',2,1,7.95),
('IT201','Aarav Patil','aarav@example.com','9000000005',3,2,8.90),
('ET301','Riya Joshi','riya@example.com','9000000006',3,3,7.60);

INSERT INTO Company (company_name, industry, location, website) VALUES
('TechNova Solutions','Software','Pune','https://example.com/technova'),
('DataSphere AI','Artificial Intelligence','Bengaluru','https://example.com/datasphere'),
('CloudBridge Systems','Cloud Computing','Hyderabad','https://example.com/cloudbridge'),
('SecureNet Labs','Cybersecurity','Mumbai','https://example.com/securenet');

INSERT INTO Job
(company_id, job_title, job_type, stipend_or_ctc, required_cgpa, openings, deadline) VALUES
(1,'Python Developer Intern','Internship',25000,7.50,5,'2026-09-15'),
(2,'Machine Learning Intern','Internship',30000,8.00,3,'2026-09-20'),
(3,'Cloud Engineer Intern','Internship',28000,7.80,4,'2026-09-25'),
(4,'Cybersecurity Intern','Internship',22000,7.00,3,'2026-09-30'),
(1,'Junior Software Engineer','Full-Time',650000,8.00,2,'2026-10-15');

INSERT INTO Skill (skill_name, category) VALUES
('Python','Programming'),
('Java','Programming'),
('SQL','Database'),
('Machine Learning','AI/ML'),
('Data Structures','CS Fundamentals'),
('Cloud Computing','Cloud'),
('Cybersecurity','Security'),
('Git','Tools');

INSERT INTO Student_Skill VALUES
(1,1,'Advanced'),(1,3,'Advanced'),(1,5,'Intermediate'),(1,8,'Intermediate'),
(2,1,'Advanced'),(2,4,'Intermediate'),(2,3,'Advanced'),(2,8,'Advanced'),
(3,1,'Intermediate'),(3,4,'Advanced'),(3,3,'Intermediate'),(3,8,'Intermediate'),
(4,2,'Intermediate'),(4,3,'Intermediate'),(4,5,'Intermediate'),
(5,1,'Advanced'),(5,6,'Advanced'),(5,3,'Advanced'),(5,8,'Advanced'),
(6,2,'Advanced'),(6,7,'Intermediate'),(6,3,'Intermediate');

INSERT INTO Application
(student_id, job_id, application_date, status) VALUES
(1,1,'2026-08-20','Shortlisted'),
(1,2,'2026-08-20','Applied'),
(2,1,'2026-08-20','Interview'),
(2,2,'2026-08-20','Shortlisted'),
(3,2,'2026-08-21','Selected'),
(3,1,'2026-08-21','Rejected'),
(4,1,'2026-08-21','Applied'),
(5,3,'2026-08-21','Selected'),
(6,4,'2026-08-21','Shortlisted');

-- =========================
-- DEMONSTRATION QUERIES
-- =========================

-- 1. Display all students with department names.
SELECT s.roll_no, s.student_name, d.department_name, s.cgpa
FROM Student s
JOIN Department d ON s.department_id = d.department_id;

-- 2. List all available jobs with companies.
SELECT j.job_title, c.company_name, j.job_type,
       j.stipend_or_ctc, j.required_cgpa, j.deadline
FROM Job j
JOIN Company c ON j.company_id = c.company_id
ORDER BY j.deadline;

-- 3. Find students eligible for Machine Learning Intern.
SELECT s.student_name, s.cgpa
FROM Student s
JOIN Application a ON s.student_id = a.student_id
JOIN Job j ON a.job_id = j.job_id
WHERE j.job_title = 'Machine Learning Intern'
  AND s.cgpa >= j.required_cgpa;

-- 4. Show every application with student, company and job.
SELECT s.student_name, c.company_name, j.job_title, a.status
FROM Application a
JOIN Student s ON a.student_id = s.student_id
JOIN Job j ON a.job_id = j.job_id
JOIN Company c ON j.company_id = c.company_id
ORDER BY s.student_name;

-- 5. Count applications for each job.
SELECT j.job_title, COUNT(a.application_id) AS total_applications
FROM Job j
LEFT JOIN Application a ON j.job_id = a.job_id
GROUP BY j.job_id, j.job_title;

-- 6. Find selected students.
SELECT s.student_name, c.company_name, j.job_title
FROM Application a
JOIN Student s ON a.student_id = s.student_id
JOIN Job j ON a.job_id = j.job_id
JOIN Company c ON j.company_id = c.company_id
WHERE a.status = 'Selected';

-- 7. Find students having Advanced Python skills.
SELECT s.student_name, s.cgpa
FROM Student s
JOIN Student_Skill ss ON s.student_id = ss.student_id
JOIN Skill sk ON ss.skill_id = sk.skill_id
WHERE sk.skill_name = 'Python'
  AND ss.proficiency = 'Advanced';

-- 8. Find companies offering stipend/CTC above 25000.
SELECT c.company_name, j.job_title, j.stipend_or_ctc
FROM Company c
JOIN Job j ON c.company_id = j.company_id
WHERE j.stipend_or_ctc > 25000;

-- 9. Average CGPA by department.
SELECT d.department_name, ROUND(AVG(s.cgpa),2) AS average_cgpa
FROM Department d
JOIN Student s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name;

-- 10. Subquery: students whose CGPA is above overall average.
SELECT student_name, cgpa
FROM Student
WHERE cgpa > (SELECT AVG(cgpa) FROM Student);

-- 11. View for application tracking.
CREATE OR REPLACE VIEW Application_Tracking AS
SELECT a.application_id, s.roll_no, s.student_name,
       c.company_name, j.job_title, a.application_date, a.status
FROM Application a
JOIN Student s ON a.student_id = s.student_id
JOIN Job j ON a.job_id = j.job_id
JOIN Company c ON j.company_id = c.company_id;

SELECT * FROM Application_Tracking;

-- 12. Update example.
UPDATE Application
SET status = 'Interview'
WHERE application_id = 1;

-- 13. Delete example (use only if required for demonstration).
-- DELETE FROM Application WHERE application_id = 9;
