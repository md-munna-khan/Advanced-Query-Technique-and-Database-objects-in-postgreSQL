SELECT * from  employees;

EXPLAIN ANALYSE
SELECT * from employees WHERE department_name ='HR';

CREATE INDEX idx_employees_department_name
on employees (department_name);

SHOW data_directory;