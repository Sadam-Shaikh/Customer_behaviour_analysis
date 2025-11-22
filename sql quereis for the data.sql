select * from customer limit(20);

--Q.1. What is the total revenue genrated by the male and female customer
select gender,sum(purchase_amount) as revenue
from customer
group by gender

--Q2 which customer used a discount but still spent more than the average purchase amount?
SELECT customer_id,purchase_amount
from customer
where discount_applied = 'Yes' and purchase_amount>=(select avg(purchase_amount) from customer)

-- Q4.which are the top 5 products with the highest average review ratings 
select item_purchased,avg(review_rating) as "Average_ratings"
from customer
group by item_purchased 
order by avg(review_rating) desc
limit 5;
--Q4. compare the average purchase amount between standard and express shipping
select shipping_type,
Round(avg(purchase_amount),2)
from customer
where shipping_type in ('Standard','Express')
group by shipping_type


--Q5 Do subscribed customers spend more? Compare average spend total revenue between subscriber and non-subscribers
SELECT 
    subscription_status,
    COUNT(customer_id) AS total_customers,
    ROUND(AVG(purchase_amount), 2) AS avg_spend,
    ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue DESC, avg_spend DESC;

-- Q6 which 5 products have the highest percentage of purchased with discount applied?
select item_purchased,
Round(100*sum(Case When discount_applied = 'Yes' Then 1 else 0 end)/count(*)*100,2) as discount_rate
from customer 
group by item_purchased 
order  by discount_rate  desc
limit 5;

--Q7. segment customer into New, Returning , and loyal based on their total
--number of previous purchased, and show the count of each segemnt

with customer_type as (
select customer_id,previous_purchases,
Case
    When previous_purchases = 1 then 'New'
	when previous_purchases between 2 and 10 then 'Returning'
	Else 'Loyal'
	End As customer_segment
from customer

)

select customer_segment,count(*) as "Number of Customer"
from customer_type
group by customer_segment


--Q8 . What are the top 3 most purchased products within each category

with item_counts as (
select category,
item_purchased,
count(customer_id) as total_orders,
Row_Number() over(partition by category order by count(customer_id) desc) as item_rank
from customer
group by category,item_purchased
)
select item_rank,category,item_purchased,total_orders
from item_counts
where item_rank<=3;

--Q9 Are customer who are repeat buyers (more than 5 previous) also likely to subscribe?

select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases>5
group by subscription_status

--Q10 what is the revenue contribustion of each age group?
select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;




