CREATE TABLE high_salary_employees AS
SELECT * FROM employees WHERE 1 = 0;

INSERT INTO high_salary_employees
SELECT * FROM employees WHERE salary > 12000;

COMMIT;


CREATE TABLE training_programs (
    training_id   NUMBER PRIMARY KEY,
    training_name VARCHAR2(100) NOT NULL,
    trainer_name  VARCHAR2(50) NOT NULL,
    duration_days NUMBER,
    start_date    DATE,
    fee           NUMBER(8,2) CHECK (fee >= 0)
);

INSERT INTO training_programs VALUES (101, 'SQL Fundamentals', 'Alice Johnson', 5, TO_DATE('10-JUL-2025', 'DD-MON-YYYY'), 8000);
INSERT INTO training_programs VALUES (102, 'Database Design', 'Bob Smith', 4, TO_DATE('15-JUL-2025', 'DD-MON-YYYY'), 7500);
INSERT INTO training_programs VALUES (103, 'PL/SQL Programming', 'Carol Davis', 6, TO_DATE('20-JUL-2024', 'DD-MON-YYYY'), 9500);
INSERT INTO training_programs VALUES (104, 'Oracle Administration', 'David Lee', 3, TO_DATE('25-JUL-2026', 'DD-MON-YYYY'), 7000);

UPDATE training_programs
SET fee = fee * 1.10
WHERE training_name = 'Database Design';

UPDATE training_programs
SET trainer_name = 'Emily Brown'
WHERE training_name = 'Oracle Administration';

DELETE FROM training_programs
WHERE training_id = 102;

ALTER TABLE training_programs ADD (mode VARCHAR2(15));

UPDATE training_programs SET mode = 'Online';

COMMIT;


CREATE TABLE it_employees AS
SELECT e.*
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'IT';

ALTER TABLE it_employees ADD CONSTRAINT pk_it_employees PRIMARY KEY (employee_id);

ALTER TABLE it_employees ADD (project_name VARCHAR2(50));

UPDATE it_employees SET project_name = 'HRMS Upgrade';

INSERT INTO it_employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id, project_name)
VALUES (300, 'Rahim', 'Uddin', 'RUDDIN', '515.124.9999', SYSDATE, 'IT_PROG', 6000, NULL, 103, 60, 'HRMS Upgrade');

COMMIT;


CREATE TABLE emp_bonus (
    bonus_id     NUMBER PRIMARY KEY,
    employee_id  NUMBER NOT NULL,
    bonus_amount NUMBER(10,2) NOT NULL,
    CONSTRAINT fk_bonus_employee FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CONSTRAINT chk_bonus_amount CHECK (bonus_amount >= 0)
);

INSERT INTO emp_bonus (bonus_id, employee_id, bonus_amount) VALUES (1, 100, 5000);

COMMIT;


CREATE TABLE recent_employees AS
SELECT * FROM employees
WHERE hire_date >= TO_DATE('01-JAN-2005', 'DD-MON-YYYY');

ALTER TABLE recent_employees ADD (training_status VARCHAR2(20));

UPDATE recent_employees SET training_status = 'Pending';

UPDATE recent_employees
SET training_status = 'Completed'
WHERE salary > 10000;

DELETE FROM recent_employees WHERE salary < 6000;

COMMIT;


CREATE TABLE sales_departments AS
SELECT * FROM departments
WHERE department_name LIKE '%Sales%';

ALTER TABLE sales_departments ADD CONSTRAINT pk_sales_departments PRIMARY KEY (department_id);

INSERT INTO sales_departments (department_id, department_name, manager_id, location_id)
VALUES (280, 'Sales Support', NULL, 1700);

ALTER TABLE sales_departments RENAME COLUMN department_name TO dept_name;

DELETE FROM sales_departments WHERE department_id = 280;

COMMIT;