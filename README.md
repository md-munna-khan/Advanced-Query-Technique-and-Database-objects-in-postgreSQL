## Advanced Query Technique and Database objects in postgreSQL

## 10-2 Exploring Subqueries
- a sub query is a nested Query within another SQL statement
![alt text](image-1.png)
- this is single column 
![alt text](image-2.png)

```sql
-- Retrieve all employees whose salary is greater than the highest salary of the HR department
--63000
-- ! SELECT * from employees WHERE  salary > 63000; -- wrong way

SELECT salary from employees WHERE department_name='HR';-- 63000

SELECT * from employees WHERE  salary > (SELECT max(salary) from employees WHERE department_name='HR');

-- Can return a single value
-- Can return multiple rows
-- Can return a single column


-- we used in
SELECT 
FROM
where
```