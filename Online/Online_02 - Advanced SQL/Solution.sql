-- Problem 01
SELECT r.region_name,
       COUNT(d.department_id) AS department_count
FROM regions r
LEFT JOIN countries c
       ON c.region_id = r.region_id
LEFT JOIN locations l
       ON l.country_id = c.country_id
LEFT JOIN departments d
       ON d.location_id = l.location_id
GROUP BY r.region_name
ORDER BY r.region_name ASC;


-- Problem 02
SELECT e.employee_id,
       e.first_name || ' ' || e.last_name AS full_name,
       e.salary,
       j.job_title,
       d.department_name
FROM employees e
JOIN jobs j
     ON j.job_id = e.job_id
JOIN departments d
     ON d.department_id = e.department_id
WHERE j.max_salary > (
          SELECT AVG(max_salary)
          FROM jobs
      )
  AND e.department_id IN (
          SELECT department_id
          FROM employees
          GROUP BY department_id
          HAVING COUNT(*) >= 6
      );


-- Problem 03
-- Use inline views in the FROM clause; no subquery in the WHERE clause.
SELECT country_name,
       department_name,
       employee_count
FROM (
    SELECT country_name,
           department_name,
           employee_count,
           ROW_NUMBER() OVER (
               PARTITION BY country_id
               ORDER BY employee_count DESC, department_id
           ) AS rn
    FROM (
        SELECT c.country_id,
               c.country_name,
               d.department_id,
               d.department_name,
               COUNT(e.employee_id) AS employee_count
        FROM countries c
        JOIN locations l
             ON l.country_id = c.country_id
        JOIN departments d
             ON d.location_id = l.location_id
        LEFT JOIN employees e
             ON e.department_id = d.department_id
        GROUP BY c.country_id,
                 c.country_name,
                 d.department_id,
                 d.department_name
    )
)
WHERE rn = 1;


-- Problem 04
-- Employees paid above the average salary for their job_id,
-- MINUS employees who work in the Sales department.
SELECT e.employee_id,
       e.first_name || ' ' || e.last_name AS full_name,
       j.job_title,
       e.salary,
       CASE
           WHEN e.commission_pct IS NOT NULL
           THEN 'Commission Eligible'
           ELSE 'Base Salary Only'
       END AS pay_type
FROM employees e
JOIN jobs j
     ON j.job_id = e.job_id
WHERE e.salary > (
          SELECT AVG(e2.salary)
          FROM employees e2
          WHERE e2.job_id = e.job_id
      )

MINUS

SELECT e.employee_id,
       e.first_name || ' ' || e.last_name AS full_name,
       j.job_title,
       e.salary,
       CASE
           WHEN e.commission_pct IS NOT NULL
           THEN 'Commission Eligible'
           ELSE 'Base Salary Only'
       END AS pay_type
FROM employees e
JOIN jobs j
     ON j.job_id = e.job_id
JOIN departments d
     ON d.department_id = e.department_id
WHERE d.department_name = 'Sales'

ORDER BY salary DESC;
