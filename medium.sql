--Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically and displayed underneath its corresponding Occupation.
-- The output column headers should be Doctor, Professor, Singer, and Actor, respectively.
--Note: Print NULL when there are no more names corresponding to an occupation.

select Doctor, Professor, Singer, Actor 
from 
(select name, occupation, row_number()over(partition by occupation order by name) as rn from occupations) t
pivot (max(name)
       for occupation in
       (Doctor, Professor, Singer, Actor)) as p;

	   --Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter
--	    of each profession as a parenthetical (i.e.: enclosed in parentheses). For example: AnActorName(A), 
--		ADoctorName(D), AProfessorName(P), and ASingerName(S).
--Query the number of ocurrences of each occupation in OCCUPATIONS. 
--Sort the occurrences in ascending order, and output them in the following format:
--There are a total of [occupation_count] [occupation]s.
--where [occupation_count] is the number of occurrences of an occupation in OCCUPATIONS and [occupation] is the 
--lowercase occupation name. If more than one Occupation has the same [occupation_count], they should be ordered
-- alphabetically.

select name + '('+substring(occupation,1,1)+')'from occupations order by name ;
select 'There are a total of ' + cast(count(occupation) as varchar(2)) +' '+lower(occupation)+'s.' from occupations
group by occupation
order by count(occupation), occupation;


--You are given a table, BST, containing two columns: N and P, where N represents the value of a node in Binary Tree, 
--and P is the parent of N.
--Write a query to find the node type of Binary Tree ordered by the value of the node. 
--Output one of the following for each node:

Root: If node is root node.
Leaf: If node is leaf node.
Inner: If node is neither root nor leaf node.
select n , case when p is null then 'Root'
                when n not in (select distinct p FROM BST where p is not null) then 'Leaf'
                else 'Inner'
                end as node
                from BST
                ORDER BY N;

--Amber's conglomerate corporation just acquired some new companies. Each of the companies follows this hierarchy: 
--Given the table schemas below, write a query to print the company_code, founder name, total number of lead managers,
-- total number of senior managers, total number of managers, and total number of employees. Order your output by 
-- ascending company_code.
--The tables may contain duplicate records.
--The company_code is string, so the sorting should not be numeric. For example, 
--if the company_codes are C_1, C_2, and C_10, then the ascending company_codes will be C_1, C_10, and C_2.

select e.company_code, c.founder, count(distinct l.lead_manager_code), count(distinct s.senior_manager_code), 
count(distinct m.manager_code), count(distinct e.employee_code)
from employee e
join company c on c.company_code = e.company_code 
join lead_manager l on l.company_code = e.company_code and l.lead_manager_code = e.lead_manager_code
join senior_manager s on s.company_code = e.company_code and s.senior_manager_code = e.senior_manager_code
join manager m  on m.company_code = e.company_code and s.senior_manager_code = e.senior_manager_code
group by e.company_code, c.founder
order by e.company_code;

 --A median is defined as a number separating the higher half of a data set from the lower half. 
 --Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to  decimal places.
 
select cast(lat_n as decimal(7,4)) from(
select lat_n, row_number()over(order by lat_n) as rn
from station)t
where rn = (select (count(lat_n)+1)/2 from station);

--You are given three tables: Students, Friends and Packages. Students contains two columns: ID and Name. 
--Friends contains two columns: ID and Friend_ID (ID of the ONLY best friend). Packages contains two columns: ID 
--and Salary (offered salary in $ thousands per month).
--Write a query to output the names of those students whose best friends got offered a higher salary than them. 
--Names must be ordered by the salary amount offered to the best friends. It is guaranteed that no two students got
-- same salary offer.

select name from students s
join friends f on f.id = s.id
join packages p on p.id = s.id
join packages p1 on p1.id = f.friend_id
where p.salary< p1.salary
order by p1.salary;

--Write a query to print the respective hacker_id and name of hackers who achieved full scores for more than one 
--challenge. Order your output in descending order by the total number of challenges in which the hacker earned a 
--full score. If more than one hacker received full scores in same number of challenges, then sort them by ascending
-- hacker_id.
select s.hacker_id, h.name from submissions s
join challenges c on c.challenge_id = s.challenge_id
join hackers h on h.hacker_id = s.hacker_id
join difficulty d on d.difficulty_level = c.difficulty_level
where s.score = d.score
group by s.hacker_id,h.name
having count(s.hacker_id)>1
order by count(s.hacker_id) desc,hacker_id; 



--Julia asked her students to create some coding challenges. Write a query to print the hacker_id, name, 
--and the total number of challenges created by each student. Sort your results by the total number of challenges
-- in descending order. If more than one student created the same number of challenges, then sort the result by 
-- hacker_id. If more than one student created the same number of challenges and the count is less than the maximum 
-- number of challenges created, then exclude those students from the result.
select c.hacker_id, h.name, count(c.challenge_id)
from hackers h 
join challenges c on c.hacker_id = h.hacker_id
group by c.hacker_id, h.name
having
count(c.challenge_id) = (select max(maxcount) from (select hacker_id, count(challenge_id) as maxcount from challenges group by hacker_id)t) or
 count(c.challenge_id) not in (select count(c1.challenge_id) from challenges c1 group by c1.hacker_id having c.hacker_id<>c1.hacker_id)
order by count(c.challenge_id) desc, c.hacker_id;
