--find the different payment method and numberof transctions , number of qty sold
select payment_method ,
count(*) as no_payment,sum(quantity)as no_qty_sold
from walmart group by payment_method;

select*from walmart
--identify the highest rated category to each branch, displaying the branch , category, avg rating

select* from(
select branch, category, avg(rating)
as avg_rating,
rank() over(partition by branch order by avg (rating)desc) as rank
from walmart group by 1,2 )

where rank =1;


--identify the busiest day for each branch based  on the number of transctions
select*from(
select branch, to_char(to_date(date,'dd/mm/yy'),'Day') as day_name,
count(*) as transaction_count,
rank() over(partition by branch order by count(*) desc) as rank
from walmart 
group by 1,2
) 
where rank =1;


--calculate the total qty of item sold per payment method , list payment_method , and total_qty.

select payment_method,
--count(*) as payment_method, 
sum(quantity)as total_qty
from walmart group by payment_method;

--determine the avg , min and max rating of category for each city .
--list the city , avg_rating, min_rating , max_rating.

select city, category,
min(rating) as min_rating,
avg(rating)as avg_rating,
max(rating) as max_rating
from walmart
group by 1,2;

--calculate the total profit of each category by considering total_profit as 
--(unit_price *quantity * profit_margin).
--list category and total_profit , ordered from highest to lowest profit.
select * from walmart


select category,sum(total)as revenue,
sum(total * profit_margin)as profit
from walmart
group by 1;

--determine the most common payment method for each Brsnch .
--Display  branch  and the preferred_payment_methode.

select branch ,
payment_method,
count(*)as total_trans,
rank () over(partition by branch order by count(*) desc)as rank
from walmart
group by 1,2;

--AND

with cte as(
select branch ,
payment_method,
count(*)as total_trans,
rank () over(partition by branch order by count(*) desc)as rank
from walmart
group by 1,2)
select * from cte
where rank=1;

-- category sales into 3 group morning , evining , afternoon 
-- find out each of the shift and  number  of invoices 
select time::time from walmart


select  case 
when extract (hour from (time::time))<12 then 'Morning'
when extract (hour from (time::time)) between 12 and 17 then 'Afternoon'
else 'Evening'
end day_time ,
count (*)
from walmart
group by 1;

-- identify  5 branch with highest decrese ratio in revenue compare to last year (current year 2023 and last year 2022).
select *,
extract (year from to_date(date,'dd/mm/yy') )as formeted_date
from walmart 
--2022 sales
with revenue_2022 
as (
select branch , sum(total) as revenue
from walmart 
where extract (year from to_date(date,'dd/mm/yy') )=2022
group by 1),


--2023 sales
revenue_2023 as(
select branch , sum(total) as revenue
from walmart 
where extract (year from to_date(date,'dd/mm/yy') )=2023
group by 1)
select ls.branch,
ls.revenue as last_year_revenue,
cs.revenue as current_year_revenue,
round((ls.revenue-cs.revenue)::numeric/ls.revenue::numeric*100,2 ) as rev_dec_retio
from revenue_2022 as ls
join revenue_2023 as cs
on ls.branch=cs.branch
where ls.revenue>cs.revenue
order by 4 desc

