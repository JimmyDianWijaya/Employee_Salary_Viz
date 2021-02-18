-- please start by ensuring we use the correct database
USE employees_mod;
COMMIT;

/*
Author: Jimmy Wijaya
Date: 18/02/2021
*/

-- SQL code: Task 1
-- What is the number breakdown of male and female employees in the company each year. starting from 1990?
SELECT 
    YEAR(b.from_date) AS calendar_year,
    a.gender,
    COUNT(b.emp_no) AS number_of_employees
FROM
    t_employees a
        INNER JOIN
    t_dept_emp b ON a.emp_no = b.emp_no
WHERE
    YEAR(b.from_date) >= 1990
GROUP BY 1 , 2
ORDER BY 1;

-- SQL code task 2
-- Comparison between the male and female managers from different departments for each year, starting from 1990?
select c.dept_name, d.gender, b.emp_no, b.from_date, b.to_date, a.calendar_year,
CASE
	WHEN year(b.to_date) >= a.calendar_year AND year(b.from_date) <= a.calendar_year THEN 1
    ELSE 0
END AS active_status
from (
select year(hire_date) as calendar_year
from t_employees
group by calendar_year ) as a
cross join t_dept_manager b
inner join t_departments c
on b.dept_no = c.dept_no
inner join t_employees d
on b.emp_no = d.emp_no
order by b.emp_no, a.calendar_year;

-- SQL code task 3
-- Compare the average salary of female vs male employees in the entire company until year 2002
SELECT 
    a.gender,
    d.dept_name,
    ROUND(AVG(b.salary), 2) AS average_salary,
    YEAR(b.from_date) AS calendar_year
FROM
    t_employees a
        INNER JOIN
    t_salaries b ON a.emp_no = b.emp_no
        LEFT JOIN
    t_dept_emp c ON a.emp_no = c.emp_no
        INNER JOIN
    t_departments d ON c.dept_no = d.dept_no
GROUP BY a.gender , d.dept_name , calendar_year
HAVING calendar_year <= 2002
ORDER BY a.gender;


-- SQL code task 4
-- SQL routine to obtain the average male and female salary per department. Please include a salary range filter
DROP PROCEDURE IF EXISTS average_salary;

DELIMITER $$
CREATE PROCEDURE average_salary(in p_min_salary FLOAT, in p_max_salary FLOAT)
BEGIN
	SELECT 
    a.gender,
    d.dept_name,
    ROUND(AVG(b.salary), 2) AS average_salary
	FROM
    t_employees a
        INNER JOIN
    t_salaries b ON a.emp_no = b.emp_no
        LEFT JOIN
    t_dept_emp c ON a.emp_no = c.emp_no
        INNER JOIN
    t_departments d ON c.dept_no = d.dept_no
    WHERE b.salary BETWEEN p_min_salary AND p_max_salary
	GROUP BY a.gender , d.dept_name
	ORDER BY a.gender;
END$$
DELIMITER ;
