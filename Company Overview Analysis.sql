-- ====================================================================================================
-- HR & SALES PERFORMANCE ANALYTICS DOCUMENTATION
-- Tables: employees, sales
-- ====================================================================================================

SELECT * FROM employees LIMIT 10;
SELECT * FROM sales LIMIT 10;

-- ----------------------------------------------------------------------------------------------------
-- SECTION 1: WORKFORCE & HR ANALYSIS
-- ----------------------------------------------------------------------------------------------------

-- 1. TOTAL HEADCOUNT AND AVERAGE SALARY BY DEPARTMENT
SELECT 
    Department,
    COUNT(EmployeeID) AS total_employees,
    ROUND(AVG(Salary), 2) AS avg_salary
FROM employees
GROUP BY Department
ORDER BY avg_salary DESC;

-- 2. AVERAGE PERFORMANCE SCORE BY DEPARTMENT
SELECT 
    Department,
    ROUND(AVG(PerformanceScore), 2) AS avg_performance_score
FROM employees
GROUP BY Department
ORDER BY avg_performance_score DESC;

-- 3. GENDER DIVERSITY & SALARY METRICS PER DEPARTMENT
SELECT 
    Department,
    Gender,
    COUNT(EmployeeID) AS employee_count,
    ROUND(AVG(Salary), 2) AS avg_salary
FROM employees
GROUP BY Department, Gender
ORDER BY Department, Gender;

-- 4. EMPLOYEE DISTRIBUTION BY WORK CITY
SELECT 
    City,
    COUNT(EmployeeID) AS total_employees,
    ROUND(AVG(Salary), 2) AS avg_salary
FROM employees
GROUP BY City
ORDER BY total_employees DESC;

-- 5. TOP 10 HIGHEST PAID EMPLOYEES
SELECT 
    EmployeeID,
    Name,
    Department,
    Role,
    Salary,
    Experience
FROM employees
ORDER BY Salary DESC
LIMIT 10;

-- 6. TOP PERFORMING EMPLOYEES (PERFORMANCE SCORE >= 4.5)
SELECT 
    EmployeeID,
    Name,
    Department,
    Role,
    PerformanceScore,
    Salary
FROM employees
WHERE PerformanceScore >= 4.5
ORDER BY PerformanceScore DESC, Salary DESC;

-- 7. SALARY TIER CLASSIFICATION
SELECT 
    EmployeeID,
    Name,
    Department,
    Salary,
    CASE 
        WHEN Salary >= 100000 THEN 'High Earner'
        WHEN Salary BETWEEN 70000 AND 99999 THEN 'Mid-Level Earner'
        ELSE 'Entry-Level / Baseline'
    END AS salary_tier
FROM employees
ORDER BY Salary DESC;

-- ----------------------------------------------------------------------------------------------------
-- SECTION 2: SALES & REGIONAL PERFORMANCE ANALYSIS
-- ----------------------------------------------------------------------------------------------------

-- 1. TOTAL SALES AND TOTAL PROFIT BY REGION
SELECT 
    Region,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM sales
GROUP BY Region
ORDER BY total_sales DESC;

-- 2. AVERAGE SALES AND AVERAGE PROFIT PER ORDER BY REGION
SELECT 
    Region,
    ROUND(AVG(Sales), 2) AS avg_sales_per_order,
    ROUND(AVG(Profit), 2) AS avg_profit_per_order
FROM sales
GROUP BY Region
ORDER BY avg_profit_per_order DESC;

-- 3. TOTAL ORDER VOLUME BY REGION
SELECT 
    Region,
    COUNT(OrderID) AS total_orders
FROM sales
GROUP BY Region
ORDER BY total_orders DESC;

-- 4. AVERAGE DISCOUNT OFFERED BY REGION
SELECT 
    Region,
    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct
FROM sales
GROUP BY Region
ORDER BY avg_discount_pct DESC;

-- 5. RANK REGIONS BY TOTAL SALES
SELECT 
    Region,
    ROUND(SUM(Sales), 2) AS total_sales,
    RANK() OVER(ORDER BY SUM(Sales) DESC) AS sales_rank
FROM sales
GROUP BY Region;

-- 6. REGIONS EXCEEDING AVERAGE REGIONAL SALES
SELECT 
    Region,
    ROUND(SUM(Sales), 2) AS total_sales
FROM sales
GROUP BY Region
HAVING SUM(Sales) > (
    SELECT AVG(region_total) 
    FROM (
        SELECT SUM(Sales) AS region_total 
        FROM sales 
        GROUP BY Region
    ) AS sub
)
ORDER BY total_sales DESC;

-- ----------------------------------------------------------------------------------------------------
-- SECTION 3: PRODUCT CATEGORY ANALYSIS
-- ----------------------------------------------------------------------------------------------------

-- 1. TOTAL SALES, PROFIT, AND MARGIN BY PRODUCT CATEGORY
SELECT 
    Category,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM sales
GROUP BY Category
ORDER BY total_sales DESC;

-- 2. AVERAGE DISCOUNT APPLIED PER PRODUCT CATEGORY
SELECT 
    Category,
    ROUND(AVG(Discount) * 100, 2) AS avg_discount_pct
FROM sales
GROUP BY Category
ORDER BY avg_discount_pct DESC;

-- 3. CLASSIFY PRODUCT CATEGORIES BY PROFITABILITY
SELECT 
    Category,
    ROUND(SUM(Profit), 2) AS total_profit,
    CASE 
        WHEN SUM(Profit) >= 300000 THEN 'High Profit'
        WHEN SUM(Profit) BETWEEN 200000 AND 299999 THEN 'Moderate Profit'
        ELSE 'Low Profit'
    END AS profit_category
FROM sales
GROUP BY Category
ORDER BY total_profit DESC;

-- 4. RANK PRODUCT CATEGORIES BY TOTAL PROFIT
SELECT 
    Category,
    ROUND(SUM(Profit), 2) AS total_profit,
    RANK() OVER(ORDER BY SUM(Profit) DESC) AS category_profit_rank
FROM sales
GROUP BY Category;

-- ----------------------------------------------------------------------------------------------------
-- SECTION 4: CROSS-FUNCTIONAL EMPLOYEE SALES PERFORMANCE (JOIN ANALYSIS)
-- ----------------------------------------------------------------------------------------------------

-- 1. TOTAL SALES AND PROFIT ATTRIBUTED TO EACH EMPLOYEE DEPARTMENT
SELECT 
    e.Department,
    COUNT(s.OrderID) AS total_orders_handled,
    ROUND(SUM(s.Sales), 2) AS total_sales,
    ROUND(SUM(s.Profit), 2) AS total_profit
FROM sales s
JOIN employees e ON s.EmployeeID = e.EmployeeID
GROUP BY e.Department
ORDER BY total_sales DESC;

-- 2. TOP 10 REVENUE GENERATING EMPLOYEES
SELECT 
    e.EmployeeID,
    e.Name,
    e.Department,
    e.Role,
    COUNT(s.OrderID) AS orders_closed,
    ROUND(SUM(s.Sales), 2) AS total_sales,
    ROUND(SUM(s.Profit), 2) AS total_profit
FROM sales s
JOIN employees e ON s.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, e.Name, e.Department, e.Role
ORDER BY total_sales DESC
LIMIT 10;

-- 3. TOP 10 MOST PROFITABLE EMPLOYEES
SELECT 
    e.EmployeeID,
    e.Name,
    e.Department,
    e.Role,
    ROUND(SUM(s.Profit), 2) AS total_profit,
    ROUND(SUM(s.Sales), 2) AS total_sales
FROM sales s
JOIN employees e ON s.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, e.Name, e.Department, e.Role
ORDER BY total_profit DESC
LIMIT 10;

-- 4. EMPLOYEE SALES RETURN VS SALARY RATIO (SALARY ROI)
SELECT 
    e.EmployeeID,
    e.Name,
    e.Department,
    e.Salary,
    ROUND(SUM(s.Sales), 2) AS total_sales_generated,
    ROUND(SUM(s.Sales) / e.Salary, 2) AS sales_to_salary_ratio
FROM sales s
JOIN employees e ON s.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID, e.Name, e.Department, e.Salary
ORDER BY sales_to_salary_ratio DESC
LIMIT 10;

-- 5. IDENTIFY EMPLOYEES GENERATING ABOVE-AVERAGE REVENUE
WITH employee_sales_summary AS (
    SELECT 
        e.EmployeeID,
        e.Name,
        e.Department,
        SUM(s.Sales) AS total_sales
    FROM sales s
    JOIN employees e ON s.EmployeeID = e.EmployeeID
    GROUP BY e.EmployeeID, e.Name, e.Department
)
SELECT 
    EmployeeID,
    Name,
    Department,
    ROUND(total_sales, 2) AS total_sales
FROM employee_sales_summary
WHERE total_sales > (SELECT AVG(total_sales) FROM employee_sales_summary)
ORDER BY total_sales DESC;

-- ----------------------------------------------------------------------------------------------------
-- SECTION 5: CUSTOMER & TIME-TREND ANALYSIS
-- ----------------------------------------------------------------------------------------------------

-- 1. TOP 10 CUSTOMERS BY REVENUE
SELECT 
    CustomerName,
    COUNT(OrderID) AS total_purchases,
    ROUND(SUM(Sales), 2) AS total_spent,
    ROUND(SUM(Profit), 2) AS total_profit_generated
FROM sales
GROUP BY CustomerName
ORDER BY total_spent DESC
LIMIT 10;

-- 2. ANNUAL SALES AND PROFIT TREND
SELECT 
    SUBSTR(Date, 7, 4) AS order_year,
    COUNT(OrderID) AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM sales
GROUP BY SUBSTR(Date, 7, 4)
ORDER BY order_year ASC;