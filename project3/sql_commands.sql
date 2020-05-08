alter session set container = XEPDB1
create user staff identified by 12345678
create user customer identified by 12345678
grant connect to staff
grant create session to staff
grant connect to customer
grant create session to customer

-- create view <view name> as
-- 	select *
-- 	from tablename
-- 	where ...

drop table purchase__product

alter table specific_product
add purchase_id varchar(20) constraint fk_purchase references purchase(purchase_id)

update specific_product
set purchase_id='2'
where product_id='1'

update specific_product
set purchase_id='2'
where product_id='10'

update specific_product
set purchase_id='3'
where product_id='22'

update specific_product
set purchase_id='12'
where product_id='23'

update specific_product
set purchase_id='4'
where product_id='30'

update specific_product
set purchase_id='4'
where product_id='39'

update specific_product
set purchase_id='4'
where product_id='40'

update specific_product
set purchase_id='4'
where product_id='41'

update specific_product
set purchase_id='11'
where product_id='56'

update specific_product
set purchase_id='5'
where product_id='42'

update specific_product
set purchase_id='6'
where product_id='43'

update specific_product
set purchase_id='10'
where product_id='49'

update specific_product
set purchase_id='10'
where product_id='44'

update specific_product
set purchase_id='10'
where product_id='45'

update specific_product
set purchase_id='9'
where product_id='48'

update specific_product
set purchase_id='8'
where product_id='47'

update specific_product
set purchase_id='7'
where product_id='46'

alter table specific_product
add product_rating_comment varchar(30)

alter table specific_product
add product_rating varchar(30)

alter table specific_product
add product_rating_date date

alter table specific_product
add constraint rate_only_if_purchase
    check (NOT(
				(purchase_id is null and product_rating is not null) or 
				(product_rating is null and (product_rating_comment is not null or product_rating_date is not null))
		))

alter table purchase
add (delivery_rating varchar(30), delivery_rating_comment varchar(30), delivery_rating_date date)

alter table purchase
add constraint rate_only_if_purchase
    check (NOT(
				(purchase_id is null and product_rating is not null) or 
				(product_rating is null and (product_rating_comment is not null or product_rating_date is not null))
		))

member = product
employer = purchase
location rating
