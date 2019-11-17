--Query a list of CITY names from STATION with even ID numbers only. You may print the results in any order, but must exclude duplicates from your answer.
SELECT DISTINCT CITY FROM STATION WHERE ID % 2 = 0;

--Let  be the number of CITY entries in STATION, and let  be the number of distinct CITY names in STATION; query the value of  from STATION. In other words, find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.
SELECT (SELECT COUNT(CITY) FROM STATION) - (SELECT COUNT(DISTINCT CITY) FROM STATION);

--Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.

SELECT  top 1 city, min(len(CITY)) from station group by city order by min(len(CITY));
select top 1 city, max(len(city)) from station group by city order by max(len(CITY))desc;


--Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.
select distinct city from station where left(city,1)in ('a', 'e', 'i', 'o', 'u');

select distinct city from station where city like 'a%' or city like 'e%' or city like 'i%' or city like 'o%' or city like 'u%' ;

--Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
select distinct city from station where right(city,1) in ('a','e','i','o','u');

--Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. Output one of the following statements for each record in the table:
--Equilateral: It's a triangle with  sides of equal length.
--Isosceles: It's a triangle with  sides of equal length.
--Scalene: It's a triangle with  sides of differing lengths.
--Not A Triangle: The given values of A, B, and C don't form a triangle.
select
case when (a+b>c) and (b+c>a) and (c+a>b) then
    (case 
    when(a=b) and (b=c) and (c=a) then 'Equilateral'
    when (a=b) or(b=c) or(c=a) then 'Isosceles'
    else
    'Scalene'
    end)
 else
    'Not A Triangle'
    end
from
triangles


--Use FLOOR(), if you want to round your decimal to the lower integer. Examples:

--FLOOR(1.9) => 1
--FLOOR(1.1) => 1
--Use ROUND(), if you want to round your decimal to the nearest integer. Examples:

--ROUND(1.9) => 2
--ROUND(1.1) => 1
--Use CEIL(), if you want to round your decimal to the upper integer. Examples:

--CEIL(1.9) => 2
--CEIL(1.1) => 2


--Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table,
-- but did not realize her keyboard's  key was broken until after completing the calculation. 
--She wants your help finding the difference between her miscalculation (using salaries with any zeroes removed), 
--and the actual average salary.

--Write a query calculating the amount of error (i.e.:  average monthly salaries), and round it up to the next integer.

select cast(ceiling(
avg(cast(salary as float))
-
avg(cast(replace(salary,0,'') as float))
)as int)
 from employees;

 --We define an employee's total earnings to be their monthly  worked, and the maximum total earnings to be the maximum 
 --total earnings for any employee in the Employee table. Write a query to find the maximum total earnings for all 
 --employees as well as the total number of employees who have maximum total earnings. Then print these values as  
 --space-separated integers.
 select top 1 max(salary* months), '  ', count(salary* months)
from employee
group by salary
order by max(salary* months) desc;

--Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than  and less than . 
--Truncate your answer to  decimal places.
select format(sum(lat_n),'.####') from station where lat_n >38.7880 and lat_n <137.2345;

--P(R) represents a pattern drawn by Julia in R rows. The following pattern represents P(5):
--* * * * * 
--* * * * 
--* * * 
--* * 
--*
declare @i int = 20

while @i >0
begin
select replicate('* ',@i)
set @i = @i-1
end;

