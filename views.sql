CREATE View dept_avg_salary
AS
SELECT department_name,avg(salary) from employees  GROUP BY department_name;


SELECT department_name,avg(salary) from employees  GROUP BY department_name;

SELECT * from  dept_avg_salary ;

CREATE VIEW test_view
as
SELECT employee_name, salary, department_name 
FROM employees 
WHERE department_name in 
(SELECT department_name FROM employees WHERE department_name LIKE '%R%');

SELECT * from test_view;