-----------------------------------------------------------------------------------
--1.Identifycustomers who have not completed a purchase/delivery survey since Jan 1st, 2020.  Display the customer name and email. Use a nested select to answer this question.
------------------------------------------------------------------------------------

select cust_email, full_name
from customer
where
    cust_email not in(
        select cust_email
        from purchase p
        where delivery_rating_date > '01-JAN-20'
    )

-----------------------------------------------------------------------------------
--2.Identify the most popular product purchased since Jan 1st, 2000. Display fourcolumns: warehouse,productname,product typeand number of orders. Display one distinct row for eachwarehouse, productand product type.Display the productwith the most ordersfirst.
------------------------------------------------------------------------------------



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
select a.borough, number_of_orders, to_char(total_sales_dollars,'$99.99') total_sales_dollars
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

--customers can view orders. part a
select * from project2.purchase

--customers cannot change past orders. part b
update project2.purchase
set delivery_rating='5'
where purchase_id='1'

-----------------------------------------------------------------------------------
--7.Staff are restricted from accessing customer credit card number and expiration dates. Create SQL to implement. Demonstrate your implementation will prevent staff from viewing customer credit carddata.
------------------------------------------------------------------------------------

--as project2 user
create view view_staff__purchase as
    select purchase_id, cust_email, purchase_date, method_of_payment, delivery_address, date_delivered, delivery_rating, delivery_rating_comment, delivery_rating_date, method_of_rating, tip
    from purchase

grant select on view_staff__purchase to staff

--as staff user
select * from project2.view_staff__purchase


-----------------------------------------------------------------------------------
--8. Staff can’t delete purchases after they are entered in the database.Create SQL to implement.  Demonstrate your implementationwill prevent staff from deleting purchases.
------------------------------------------------------------------------------------

--no implementation required. delete was never granted to staff. if it were, do the following
--as user project2
revoke delete on view_staff__purchase from staff

--try to delete
delete from project2.view_staff__purchase
where cust_email='floor@gmail.com'

-----------------------------------------------------------------------------------
--9.The product Raisin Branis no longer being offered by the grocery store and being available for 3 years.  Identify the SQL to implement.
------------------------------------------------------------------------------------

delete from specific_product
where product_name='Raisin Bran'

-----------------------------------------------------------------------------------
--10.In one SQL window, delete all customers.  Don’t commit. In another SQL window, addfive new customers. Don’t commit. In each SQL window, identify the number of customers.  Explain your results. Disable the autocommit flag at the top of the windowbefore performing this operation. Show all SQL to perform these operations.Demonstrate the functionallyof your SQL by displaying the before and after results.
------------------------------------------------------------------------------------

--before
create table customer_copy as select * from customer

--original data, part a
select * from customer_copy

--as user1
delete from customer_copy

--as user2
insert into customer_copy(cust_email, full_name, billing_address, password_, phone)
values('iamdog@gmail.com','doggert yop', 'address st', '2332', '223455')

--as user1, after mod, part b
select * from customer_copy

--as user2, after mod, part c
select * from customer_copy

--as user1
rollback

--as user2
rollback

--exit both windows and open new window, part d
select * from customer_copy

-----------------------------------------------------------------------------------
--11.In one SQL window, delete all dairyproducts. Don’t commit. In another SQL window, delete all productsDon’t commit. Explain your results. Resolve the problem. Create a backup of your table before implementing. To create a backup table, enter CREATE TABLE <NEWTABLE> AS SELECT * FROM <ORIGINALTABLE>; COMMIT; Then you can rename a table using the RENAME TABLE commit.  Disable the autocommit flag at the top of the windowbefore performing this operation.Show all SQL to perform these operations.Demonstrate the functionally of your SQL by displaying the before and after results.

------------------------------------------------------------------------------------

create table specific_product_copy as
(
select * from specific_product
)

--original data, part a
select * from specific_product

--in window1
delete from specific_product
where product_name in(
select product_name
from general_product
where product_type = 'dairy')

--in window2
delete from specific_product

--in window2, there is a stall

--to resolve problem, delete all the non-dairy products
delete from specific_product
where product_name not in(
select product_name
from general_product
where product_type = 'dairy')

--in window1 part b
select * from specific_product

--in window 2, partc
select * from specific_product

--exit both windows, open new window part d
select * from specific_product