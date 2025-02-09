-- 1. Identify purchases for customer headcorn@gmail.com between 1/20/16 -1/22/16. Display the customer name, products ordered, price and delivery date. Order the output by date and product. 

SELECT
  customer.full_name, 
  purchase__product.product_name,  
  TO_CHAR(unit_PRICE,'$99,999.00') unit_price,
  date_delivered, 
  quantity  
FROM 
  CUSTOMER, 
  PURCHASE, 
  purchase__product, 
  general_product
WHERE
    CUSTOMER.CUST_EMAIL='facebook@gmail.com' and 
    purchase.cust_email=customer.cust_email and 
    purchase__product.purchase_id=purchase.purchase_id and 
    general_product.product_name=purchase__product.product_name
ORDER BY
    date_delivered,
    product_name;



-- 2. Identify customers who have not placed an order on or after January 27, 2016. Display the customer name and email. Order the output the name. 

SELECT
  customer.cust_email,
  full_name
FROM
  purchase,
  customer
WHERE
  time_purchased<'27-JAN-16' and
  customer.cust_email = purchase.cust_email
ORDER BY
  full_name;


-- 3. Identify customers who made orders over $40 in the last month. Display the customer name and email. Display the customers who spent the most first. 

select
  full_name,
  c.cust_email
from
  purchase__product,
  general_product,
  purchase p,
  customer c
where
  purchase__product.product_name = general_product.product_name and
  purchase__product.purchase_id = p.purchase_id and
  c.cust_email = p.cust_email
group by
  purchase__product.purchase_id,
  unit_price,
  c.cust_email,
  full_name
having
  sum(unit_price * quantity) > 40
order by
  sum(unit_price * quantity) desc;


-- 4. Identify the inventory of products by all locations. Display two columns: product name and number of products. Display one row for each distinct product. Display the output alphabetically by product. 

select
    product_name,
    sum(quantity) as quantity
from
    warehouse w,
    warehouse_inventory wi
where
    w.warehouse_id = wi.warehouse_id
group by
    product_name
order by
    product_name;

-- 5. Identify beverage products not purchased on or after january 20, 2016. Display the product name, quantity and expiration date. Order the output by product name. 



-- 6. Identify the most purchased products on or after january 20, 2016. Display three columns: product type, product name and number of purchases. Display one row for each distinct product type and product name. Display the product most purchased first. 

select
    product_type,
    g.product_name,
    sum(quantity) as amount_sold
from
    purchase__product pp,
    general_product g,
    product_type__product_name pt_pn,
    purchase p
where
    pp.product_name = g.product_name and
    g.product_name = pt_pn.product_name and
    p.purchase_id = pp.purchase_id and
    time_purchased > '20-jan-2016'
group by
    g.product_name,
    product_type
order by
    sum(quantity) desc;

-- 7. Using purchases made on or after jan 20, 2016, identify customers who eat meat. Display the customer name and email. Order the output by customer name. Note, you can replace children with other demographic characteristics. For instance, dog owners, seniors, vegetarians, Tesla car owners, etc. 

select 'customers who eat meat' as title
select
    full_name,
    c.cust_email
from
    purchase__product pp,
    purchase p,
    customer c,
    general_product g,
    product_type__product_name pt_pn
where
    pp.purchase_id = p.purchase_id and
    p.cust_email = c.cust_email and
    pp.product_name = g.product_name and
    g.product_name = pt_pn.product_name and
    product_type = 'meat' and
    time_purchased > '20-jan-16'
order by
    full_name;

-- 8. Using purchases made on or after january 20, 2016, identify customers who have not bought dairy products. Display two columns: customer zip code and number of customers. Display one row for each distinct zip code. Order the output by zip code. 

select
    count(*) as number_of_cust_who_didnt_buy_dairy,
    zipcode
from
    purchase__product pp,
    purchase p,
    customer c,
    general_product g,
    product_type__product_name pt_pn
where
    pp.product_name = g.product_name and
    g.product_name = pt_pn.product_name and
    pp.purchase_id = p.purchase_id and
    c.cust_email=p.cust_email and
    time_purchased > '20-jan-16' and
    NOT product_type = 'dairy'
group by
    zipcode
order by 
    zipcode;

-- 9. Identify staff with the most deliveries on or after jan 22, 2016. Display two columns: staff and number of deliveries. Display one row for each distinct staff. Display the staff with the most deliveries first. 

select
    staff_email,
    count(p.purchase_id) as deliveries
from
    purchase__staff ps,
    purchase p
where
    p.purchase_id = ps.purchase_id and
    time_purchased >= '22-jan-16'
group by
    staff_email
order by
    count(p.purchase_id) desc;

-- 10. Identify products with low inventory(quantity<6). Display the product name, warehouse location and quantity. Order the output by product name. 

select
    product_name,
    address_,
    quantity
from
    warehouse_inventory wi,
    warehouse w
where
    w.warehouse_id = wi.warehouse_id and
    quantity<6
order by
    product_name;

-- 11.Display the structure of ALL tables using SQL Describe. 

describe customer
describe customer__delivery_address
describe general_product
describe job_
describe product_type
describe product_type__product_name
describe purchase
describe purchase__product
describe purchase__staff
describe specific_product
describe staff
describe staff_job_record
describe warehouse
describe warehouse__warehouse_type
describe warehouse_inventory
describe warehouse_type
describe warehouse_type__product_type



-- 12.Display the version of Oracle. Enter: SELECT * FROM v$version;

SELECT * FROM v$version;

