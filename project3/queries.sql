-----------------------------------------------------------------------------------
--1.Identifycustomers who have not completed a purchase/delivery surveyin the last 6 months.  Display the customer name and email. Use a nested select to answer this question.
------------------------------------------------------------------------------------
--nested select way
select c.cust_email, full_name
from customer c, purchase p
where
	c.cust_email = p.cust_email and
	c.cust_email in
		(select c.cust_email
		from customer c, purchase p
		where 
			c.cust_email = p.cust_email and
			delivery_rating_date is null)
group by c.cust_email, full_name

--normal way
select c.cust_email, full_name
from customer c, purchase p
where
	c.cust_email = p.cust_email and
	delivery_rating_date is null
group by c.cust_email, full_name

-----------------------------------------------------------------------------------
--2.Identify the most popular product purchased in the last month. Display fourcolumns: warehouse,productname,product typeand number of orders. Display one distinct row for eachwarehouse, productand product type.Display the productwith the most ordersfirst.
------------------------------------------------------------------------------------

select s.warehouse_id, s.product_name, product_type, count(*) as number_of_orders
from specific_product s, general_product g
where
	s.product_name = g.product_name and
    purchase_id is not null
group by
	s.warehouse_id, s.product_name, product_type
order by number_of_orders desc

-----------------------------------------------------------------------------------
--3.Identify customers with the most purchases of fruit on or after jan 01, 2016 by customer location.  Display five rows in your output –one row for each borough.  Display three columns: borough, number of orders, total dollar amount of order. The borough with the most orders is displayed first.  You may need multiple SQL to answer this question.
------------------------------------------------------------------------------------

--get dollar total

select borough, sum(unit_price) as total_sales_dollars
from customer c, specific_product s, general_product g, purchase p
where
	c.cust_email = p.cust_email and
	s.product_name = g.product_name and
	s.purchase_id = p.purchase_id and
	g.product_type = 'fruit' and
	purchase_date > '01-JAN-16'
group by borough

--get number of orders per borough
select borough, count(*) as number_of_orders
from(
		select borough, p.purchase_id
		from customer c, specific_product s, general_product g, purchase p
		where
			c.cust_email = p.cust_email and
			s.product_name = g.product_name and
			s.purchase_id = p.purchase_id and
			g.product_type = 'fruit' and
			purchase_date > '01-JAN-16'
		group by borough, p.purchase_id
)
group by borough

--combine results
select a.borough, number_of_orders, total_sales_dollars
from 
		(
				select borough, count(*) as number_of_orders
				from(
						select borough, p.purchase_id
						from customer c, specific_product s, general_product g, purchase p
						where
							c.cust_email = p.cust_email and
							s.product_name = g.product_name and
							s.purchase_id = p.purchase_id and
							g.product_type = 'fruit' and
							purchase_date > '01-JAN-16'
						group by borough, p.purchase_id
				)
				group by borough
		) a,
		(
				select borough, sum(unit_price) as total_sales_dollars
				from customer c, specific_product s, general_product g, purchase p
				where
					c.cust_email = p.cust_email and
					s.product_name = g.product_name and
					s.purchase_id = p.purchase_id and
					g.product_type = 'fruit' and
					purchase_date > '01-JAN-16'
				group by borough
		) b
where a.borough = b.borough
order by number_of_orders desc

-----------------------------------------------------------------------------------
--4. Identify customers with no comments in the product survey.  Display the customername.
------------------------------------------------------------------------------------

select full_name
from specific_product s, purchase p, customer c
where
	s.purchase_id = p.purchase_id and
	c.cust_email = p.cust_email and
	product_rating_comment is null

-----------------------------------------------------------------------------------
--6.Customers can view, but not change past orders. Create SQL to implement. Demonstrate your implementation will not edit past ordersby attempting to change data.
------------------------------------------------------------------------------------

--administrative user is called 'project2'
--logged in as customer
select * from project2.purchase

update project2.purchase
set delivery_rating='5'
where purchase_id='1'

-----------------------------------------------------------------------------------
--7.Staff are restricted from accessing customer credit card number and expiration dates. Create SQL to implement. Demonstrate your implementation will prevent staff from viewing customer credit carddata.
------------------------------------------------------------------------------------

select * from project2.purchase

select * from project2.customer_method_of_payment