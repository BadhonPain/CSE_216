-- Problem 01
-- Create BONUS_AWARD
CREATE TABLE bonus_award (
    employee_id  NUMBER,
    tenure_years NUMBER,
    bonus_amount NUMBER(12, 2),
    awarded_by   VARCHAR2(30),
    awarded_on   DATE
);

-- (a) GET_TENURE_YEARS
CREATE OR REPLACE FUNCTION get_tenure_years (
    p_emp_id IN NUMBER
) RETURN NUMBER
IS
    v_years NUMBER;
BEGIN
    SELECT ROUND(MONTHS_BETWEEN(SYSDATE, hire_date) / 12, 2)
    INTO v_years
    FROM employees
    WHERE employee_id = p_emp_id;

    RETURN v_years;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1;
END;
/

-- (b) AWARD_TENURE_BONUS
CREATE OR REPLACE PROCEDURE award_tenure_bonus (
    p_dept_id       IN  NUMBER,
    p_budget        IN  NUMBER,
    p_awarded_count OUT NUMBER,
    p_total_bonus   OUT NUMBER,
    p_first_skipped OUT NUMBER
)
IS
    CURSOR c_emp IS
        SELECT e.employee_id,
               e.salary,
               j.min_salary,
               j.max_salary
        FROM employees e
        JOIN jobs j
          ON e.job_id = j.job_id
        WHERE e.department_id = p_dept_id
        ORDER BY e.hire_date, e.employee_id;

    v_tenure  NUMBER;
    v_pct     NUMBER;
    v_bonus   NUMBER;
    v_found   NUMBER  := 0;
    v_stopped BOOLEAN := FALSE;
BEGIN
    p_awarded_count := 0;
    p_total_bonus   := 0;
    p_first_skipped := NULL;

    DELETE FROM bonus_award
    WHERE employee_id IN (SELECT employee_id
                          FROM employees
                          WHERE department_id = p_dept_id);

    FOR r IN c_emp LOOP
        v_found  := v_found + 1;
        v_tenure := get_tenure_years(r.employee_id);

        IF r.salary < (r.min_salary + r.max_salary) / 2 AND v_tenure >= 5 THEN
            v_pct := 15;
        ELSIF v_tenure >= 10 THEN
            v_pct := 12;
        ELSIF v_tenure >= 5 THEN
            v_pct := 8;
        ELSE
            v_pct := 4;
        END IF;

        v_bonus := ROUND(r.salary * v_pct / 100, 2);

        IF NOT v_stopped THEN
            IF p_total_bonus + v_bonus > p_budget THEN
                v_stopped       := TRUE;
                p_first_skipped := r.employee_id;
            ELSE
                INSERT INTO bonus_award
                VALUES (r.employee_id, v_tenure, v_bonus, USER, SYSDATE);

                p_total_bonus   := p_total_bonus + v_bonus;
                p_awarded_count := p_awarded_count + 1;
            END IF;
        END IF;
    END LOOP;

    IF v_found = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No employees in department ' || p_dept_id);
        p_awarded_count := 0;
        p_total_bonus   := 0;
        p_first_skipped := NULL;
    END IF;
END;
/

-- (c) Anonymous block
SET SERVEROUTPUT ON;

DECLARE
    v_count   NUMBER;
    v_total   NUMBER;
    v_skipped NUMBER;
BEGIN
    award_tenure_bonus(80, 40000, v_count, v_total, v_skipped);

    DBMS_OUTPUT.PUT_LINE('Awarded Count : ' || v_count);
    DBMS_OUTPUT.PUT_LINE('Total Bonus   : ' || v_total);
    DBMS_OUTPUT.PUT_LINE('First Skipped : ' || NVL(TO_CHAR(v_skipped), 'NULL'));
END;
/

SELECT * FROM bonus_award;

ROLLBACK;

-- Problem 02
-- Create the log table
CREATE TABLE department_transfer_log (
    employee_id       NUMBER,
    old_department_id NUMBER,
    new_department_id NUMBER,
    old_manager_id    NUMBER,
    new_manager_id    NUMBER,
    changed_by        VARCHAR2(30),
    changed_on        DATE
);

-- Create the trigger
CREATE OR REPLACE TRIGGER trg_dept_transfer
BEFORE UPDATE OF department_id ON employees
FOR EACH ROW
WHEN (NEW.department_id <> OLD.department_id)
DECLARE
    v_new_mgr departments.manager_id%TYPE;
BEGIN
    SELECT manager_id
    INTO v_new_mgr
    FROM departments
    WHERE department_id = :NEW.department_id;

    IF v_new_mgr IS NOT NULL THEN
        :NEW.manager_id := v_new_mgr;
    END IF;

    INSERT INTO department_transfer_log
    VALUES (:OLD.employee_id,
            :OLD.department_id,
            :NEW.department_id,
            :OLD.manager_id,
            :NEW.manager_id,
            USER,
            SYSDATE);
END;
/

-- Test 1: Department with a manager
UPDATE employees
SET department_id = 50
WHERE employee_id = 104;

-- Test 2: Department without a manager
UPDATE employees
SET department_id = 120
WHERE employee_id = 105;

-- Test 3: Same department
UPDATE employees
SET department_id = 60
WHERE employee_id = 106;

-- Verify the log
SELECT employee_id,
       old_department_id,
       new_department_id,
       old_manager_id,
       new_manager_id
FROM department_transfer_log
ORDER BY changed_on;

SELECT * FROM department_transfer_log;

-- Verify the employees
SELECT employee_id,
       department_id,
       manager_id
FROM employees
WHERE employee_id IN (104, 105, 106)
ORDER BY employee_id;

ROLLBACK;