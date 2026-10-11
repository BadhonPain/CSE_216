-- Problem 01
SELECT employee_id,
       first_name,
       last_name,
       salary
FROM employees
WHERE department_id = 50
ORDER BY salary DESC;


-- Problem 02
SELECT first_name,
       last_name,
       salary
FROM employees
WHERE salary > 10000
ORDER BY last_name ASC;


-- Problem 03
SELECT employee_id,
       first_name,
       last_name,
       salary
FROM employees
WHERE job_id = 'SA_REP'
ORDER BY employee_id ASC;


-- Problem 04
SELECT job_id,
       job_title,
       min_salary,
       max_salary
FROM jobs
WHERE min_salary >= 4000
ORDER BY min_salary ASC;


-- Problem 05
SELECT country_id,
       country_name
FROM countries
WHERE country_id IN ('US', 'UK', 'CA')
ORDER BY country_name ASC;
