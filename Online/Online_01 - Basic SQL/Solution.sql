-- Problem 01 
SELECT employee_id,
       first_name || ' ' || last_name AS full_name,
       job_id,
       salary
FROM employees
WHERE first_name LIKE 'M%k'
  AND LENGTH(first_name) >= 4;

-- Problem 02
SELECT first_name || ' ' || last_name AS full_name,
       email
FROM employees
-- REVERSE () function can be useful here
WHERE INSTR(LOWER(first_name), 'e')  
      = LENGTH(last_name)
        - INSTR(LOWER(last_name), 'e')
        + 1
  AND INSTR(LOWER(last_name), 'e') <> 0
  AND TO_CHAR(hire_date, 'MM') BETWEEN '07' AND '12';

-- Problem 03
SELECT department_id,
       SUM(salary) AS total_qualified_payroll
FROM employees
WHERE TO_CHAR(ADD_MONTHS(hire_date, 120), 'MM')
      BETWEEN '01' AND '06'
GROUP BY department_id;

-- Problem 04
-- Create Table 
CREATE TABLE projects (
    project_id   NUMBER(4),
    project_name VARCHAR2(50),
    budget       NUMBER(10, 2),
    start_date   DATE,
    end_date     DATE,
    status       CHAR(1)
);
-- Add the Constarints
ALTER TABLE projects
ADD CONSTRAINT pk_projects
PRIMARY KEY (project_id);

ALTER TABLE projects
ADD CONSTRAINT uq_project_name
UNIQUE (project_name);

ALTER TABLE projects
ADD CONSTRAINT chk_project_budget
CHECK (budget > 50000);

ALTER TABLE projects
ADD CONSTRAINT chk_project_status
CHECK (status IN ('N', 'A', 'F'));
-- Add Manager name
ALTER TABLE projects
ADD manager_name VARCHAR2(40);

-- Problem 05
-- Add is_hired_in_first_half
ALTER TABLE employees
ADD is_hired_in_first_half CHAR(1);
-- Set the value to Y or N
UPDATE employees
SET is_hired_in_first_half =
    CASE
        WHEN TO_CHAR(hire_date, 'MM') BETWEEN '01' AND '06'
        THEN 'Y'
        ELSE 'N'
    END;

COMMIT;
-- Add and populate work_email
ALTER TABLE employees
ADD work_email VARCHAR2(100);

UPDATE employees
SET work_email =
    LOWER(
        first_name || '.' ||
        SUBSTR(job_id, 1, INSTR(job_id, '_') - 1) || '.' ||
        TO_CHAR(hire_date, 'YYYY') ||
        '@company.com'
    );

COMMIT;
