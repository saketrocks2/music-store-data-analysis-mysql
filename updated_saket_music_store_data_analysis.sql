use music_store;
select * from genre;
-- /1. Who is the senior most employee based on job title?
select concat(first_name,' ',last_name),employee_id from employee order by substring(levels,2,1) desc limit 1;

-- /2.Which countries have the most Invoices?
select billing_country,count(*) as'total invoice' from invoice group by billing_country order by sum(total) desc;

-- /3. What are top 3 values of total invoice?
select * from invoice order by total desc limit 3;

-- /4. Which city has the best customers? We would like to throw a promotional Music event there
select billing_city,sum(total) from invoice group by billing_city order by sum(total) desc limit 1;
-- /5.Who is the best customer?The customer who has spent the most money
select c.customer_id,round(sum(total),2) from customer as  c
inner join invoice as i using(customer_id)
group by c.customer_id
order by sum(total) desc limit 1;

-- /6. Write query to return the email, first name, last name, & Genre of all Rock Music
-- /listeners. Return your list ordered alphabetically by email starting with A

select distinct email,first_name,last_name,g.name from customer c 
inner join invoice i using(customer_id)
inner join invoice_line using(invoice_id)
inner join track using (track_id)
inner join genre g using (genre_id)
where lower(g.name)='rock'
order by email;

-- /7.. Let's invite the artists who have written the most rock music in our dataset. Write a
-- / query that returns the Artist name and total track count of the top 10 rock bands
select a.artist_id,a.name,count(a.artist_id) as 't' from artist a inner join album2 using(artist_id)
 inner join track using(album_id) inner join genre g using(genre_id) where g.name='Rock' group by a.artist_id,a.name
 order by t desc limit 10;

-- 8./Return all the track names that have a song length longer than the average song length.
-- /Return the Name and Milliseconds for each track. Order by the song length with the
-- /longest songs listed first
WITH av AS (  SELECT AVG(milliseconds) AS avg_duration  FROM track)
SELECT name, milliseconds FROM track
WHERE milliseconds > (SELECT avg_duration FROM av)
ORDER BY milliseconds DESC;
describe music_store;
--  9.select most expensive album
select name,media_type_id,unit_price
 from track
 order by unit_price desc 
limit 1;
-- 10.select top 10 cheapest album
select name,media_type_id,unit_price 
from track 
order by unit_price limit 10;

-- 11 COUNTRYWISE MOST SPENDING CUSTOMERS

with x as(
select c.customer_id,first_name,last_name,billing_country,sum(total) as s,
row_number()over(partition by billing_country order by sum(total) desc) as r 
from customer c join invoice i 
using(customer_id)
group by 1,2,3,4  )
select * from x;

-- 12 country top selling music genres

with x as(
select count(quantity)as 'total_genre_count',country,genre.name,track.genre_id,
row_number()over(partition by country order by count(quantity) desc) as r
 from invoice join customer using(customer_id) join invoice_line using(invoice_id)
join track using(track_id) join genre 
using(genre_id)
 group by 2,3,4
)
select * from x where r<=1;


-- 13.list all artist starting with vowels
SELECT  name
FROM artist
WHERE left(name,1) in ('a','e','i','o','u','A','E','I','O','U');

-- 12.   select top 10 customers according to their expenditure
select c.customer_id,concat(first_name," ",last_name)as full_name,round(sum(total),2) from customer as  c
inner join invoice as i using(customer_id)
group by 1,2
order by sum(total) desc limit 10;

-- 13.select all names of all employees and replace a with x.
select replace(first_name,'a','x') 
from employee;
 -- 14.   select top 10 customers according to their expenditure
select c.customer_id,concat(first_name," ",last_name) as full_name,
 round(sum(total),2) from customer as  c
inner join invoice as i using(customer_id)
group by 1,2
order by sum(total) desc limit 10;
-- 15.select all names of all employees and replace a with x.
select replace(first_name,'a','x') 
from employee;


-- 16. Let's invite the top artist who have written the most rock music in our dataset. Write a
-- query that returns the Artist name and total track count .
select a.artist_id,a.name,count(a.artist_id) as 't' 
from artist a
 inner join album2 using(artist_id)
 inner join track using(album_id)
 inner join genre g using(genre_id) where g.name='Rock'
 group by a.artist_id,a.name
 order by t desc limit 1;
 
 -- 17 select dob of employee end with a
select birthdate,first_name from employee 
where first_name like '%A';
-- 18 select customer name,quantity,total bill
select first_name,sum(total),sum(quantity) from customer join invoice using(customer_id) 
inner join invoice_line using(invoice_id) group by 1;
-- 19 select bill of 2nd top customer
select first_name,city,total from customer join invoice using(customer_id) order by total desc limit 1 offset 1;
-- 20 Write query to return the email, first name, last name, & Genre of all Rock Music
-- /listeners.order by first_name

select distinct email,first_name,last_name,g.name from customer c 
inner join invoice i using(customer_id)
inner join invoice_line using(invoice_id)
inner join track using (track_id)
inner join genre g using (genre_id)
where lower(g.name)='rock'
order by first_name;

-- 21 select customer name,quantity,total bill
select first_name,sum(total),sum(quantity) from customer join invoice using(customer_id) 
inner join invoice_line using(invoice_id) group by 1;
-- 22 total bill with customer name
select first_name,round(sum(total),2) from invoice join customer using(customer_id) group by 1;

-- 23 select countries with most bill
select billing_country,round(sum(total),2)as total_bill from invoice group by 1;
-- 24 select statewise  bill per country
select distinct billing_country,billing_state,
round((sum(total)over(partition by billing_country order by billing_state)),2)
  as total_bill from invoice;
 -- 25 select max billing state from each country
 with x as (select  billing_country,billing_state,round(sum(total),2)as total_bill,
 row_number()over(partition by billing_country order by sum(total) desc) as r from invoice group by 1,2)
 select * from x where r<=1;