----------------
-- DATA MODELING
----------------

---- Please refer to the attached Entity Relationship Diagram.

-------------------
-- DATA ENGINEERING
-------------------

---- Create departments table
CREATE TABLE departments (
    dept_no VARCHAR(10) NOT NULL PRIMARY KEY,
    dept_name VARCHAR(30) NOT NULL
);

---- Query the table created
SELECT * FROM departments;

---- Create employees table
CREATE TABLE employees (
    emp_no INT NOT NULL PRIMARY KEY,
    emp_title VARCHAR(10) NOT NULL,
    birth_date DATE NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    sex CHAR(1) NOT NULL,
    hire_date DATE NOT NULL
);

---- Query the table created
SELECT * FROM employees;

---- Create titles table
CREATE TABLE titles (
    title_id VARCHAR(10) NOT NULL PRIMARY KEY,
    title VARCHAR(30) NOT NULL
);

---- Query the table created
SELECT * FROM titles;

---- Create department employees table
CREATE TABLE dept_emp (
    emp_no INT NOT NULL,
    dept_no VARCHAR(10) NOT NULL,
    PRIMARY KEY (emp_no, dept_no),
    CONSTRAINT fk_dept_emp_emp_no FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
    CONSTRAINT fk_dept_emp_dept_no FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

---- Query the table created
SELECT * FROM dept_emp;

---- Create department managers table
CREATE TABLE dept_manager (
    dept_no VARCHAR(10) NOT NULL,
    emp_no INT NOT NULL,
    PRIMARY KEY (dept_no, emp_no),
    CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
    CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

---- Query the table created
SELECT * FROM dept_manager;

---- Create salaries table
CREATE TABLE salaries (
    emp_no INT NOT NULL,
    salary INT NOT NULL,
    PRIMARY KEY (emp_no),
    CONSTRAINT fk_salaries_emp_no FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

---- Query the table created
SELECT * FROM salaries;

----------------
-- DATA ANALYSIS
----------------

---- 1. List the employee number, last name, first name, sex, and salary of each employee.

------ Create view from query
CREATE VIEW employee_list AS
SELECT employees.emp_no AS "Employee number",
	employees.last_name AS "Last name",
	employees.first_name AS "First name",
	employees.sex AS "Sex",
	salaries.salary AS "Salary"
FROM employees
JOIN salaries ON employees.emp_no = salaries.emp_no
ORDER BY "Employee number" ASC;

------ Query the table view created
SELECT * FROM employee_list;

---- 2. List the first name, last name, and hire date for the employees who were hired in 1986.

------ Create view from query
CREATE VIEW employees_hired_1986 AS
SELECT employees.first_name AS "First name",
	employees.last_name AS "Last name",
	employees.hire_date AS "Hire date"
FROM employees
WHERE employees.hire_date BETWEEN '1986-01-01' AND '1986-12-31'
ORDER BY "Hire date" ASC;

------ Query the table view created
SELECT * FROM employees_hired_1986;

---- 3. List the manager of each department along with their department number, department name, employee number, last name, and first name.

------ Create view from query
CREATE VIEW manager_list AS
SELECT dept_manager.dept_no AS "Department number",
	departments.dept_name AS "Department name",
	dept_manager.emp_no AS "Employee number",
	employees.last_name AS "Last name",
	employees.first_name AS "First name"	
FROM dept_manager
JOIN departments ON dept_manager.dept_no = departments.dept_no
JOIN employees ON dept_manager.emp_no = employees.emp_no;

------ Query the table view created
SELECT * FROM manager_list;

---- 4. List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

------ Create view from query
CREATE VIEW employees_dept_no AS
SELECT dept_emp.dept_no AS "Department number",
	departments.dept_name AS "Department name",
	dept_emp.emp_no AS "Employee number",
	employees.last_name AS "Last name",
	employees.first_name AS "First name"
FROM dept_emp
JOIN departments ON dept_emp.dept_no = departments.dept_no
JOIN employees ON dept_emp.emp_no = employees.emp_no
ORDER BY "Department number" ASC, "Employee number" ASC;

------ Query the table view created
SELECT * FROM employees_dept_no;

---- 5. List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.

------ Create view from query
CREATE VIEW employees_named_hercules_b AS
SELECT employees.first_name AS "First name",
	employees.last_name AS "Last name",
	employees.sex AS "Sex"
FROM employees
WHERE employees.first_name = 'Hercules'
	AND employees.last_name LIKE 'B%'
ORDER BY "Last name" ASC;

------ Query the table view created
SELECT * FROM employees_named_hercules_b;

---- 6. List each employee in the Sales department, including their employee number, last name, and first name.

------ Create view from query
CREATE VIEW employees_sales_dept AS
SELECT dept_emp.emp_no AS "Employee number",
	employees.last_name AS "Last name",
	employees.first_name AS "First name",
	departments.dept_name AS "Department name"
FROM dept_emp
JOIN employees ON dept_emp.emp_no = employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales'
ORDER BY "Employee number" ASC;

------ Query the table view created
SELECT * FROM employees_sales_dept;

---- 7. List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.

------ Create view from query
CREATE VIEW employees_sales_dev_dept AS
SELECT dept_emp.emp_no AS "Employee number",
	employees.last_name AS "Last name",
	employees.first_name AS "First name",
	departments.dept_name AS "Department name"
FROM dept_emp
JOIN employees ON dept_emp.emp_no = employees.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales'
	OR departments.dept_name = 'Development'
ORDER BY "Department name" ASC, "Employee number" ASC;

------ Query the table view created
SELECT * FROM employees_sales_dev_dept;

---- 8. List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).

------ Create view from query
CREATE VIEW employees_last_name AS
SELECT employees.last_name AS "Last name", 
	COUNT(*) AS "Count"
FROM employees
GROUP BY employees.last_name
ORDER BY "Count" DESC;

------ Query the table view created
SELECT * from employees_last_name;