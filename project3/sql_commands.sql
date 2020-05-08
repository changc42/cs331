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
add product_rating_method varchar(20) default 'number system'

-- alter table specific_product
-- add constraint rate_only_if_purchase
--     check (NOT(
-- 				(purchase_id is null and product_rating is not null) or 
-- 				(product_rating is null and (product_rating_comment is not null or product_rating_date is not null))
-- 		))

alter table purchase
add (
	delivery_rating varchar(30), 
	delivery_rating_comment varchar(30), 
	delivery_rating_date date,
	method_of_rating varchar(30) default 'number system',
	tip number(9,2)
)

-- alter table purchase
-- add constraint rate_only_if_purchase
--     check (NOT(
-- 				(purchase_id is null and product_rating is not null) or 
-- 				(product_rating is null and (product_rating_comment is not null or product_rating_date is not null))
-- 		))

alter table purchase
rename column method to  method_of_payment

create table method_of_payment
(
    method_of_payment varchar(30) primary key
)


create table customer_method_of_payment
(
    cust_email varchar(20),
    method_of_payment varchar(30),
    card_number number(16),
    exp_date date,
    constraint pk_cust_method_of_payment
        primary key(cust_email, method_of_payment, card_number),
    constraint fk_cust_email
        foreign key(cust_email)
        references customer(cust_email),
		constraint fk_method_of_payment
        foreign key(method_of_payment)
        references method_of_payment(method_of_payment)
)

insert into method_of_payment
values('cash')

insert into method_of_payment
values('credit')

insert into method_of_payment
values('debit')

alter table purchase
add constraint fk_purchase__method_of_payment
    foreign key(method_of_payment)
    references method_of_payment(method_of_payment)

create sequence first_seq
    start with 1000
    increment by 1

grant select on purchase to customer

-- select * from specific_product
-- where product_rating_comment like '%[1:9][1:9][1:9]-[1:9][1:9][1:9]-[1:9][1:9][1:9][1:9]%' or
-- 	product_rating_comment like '%@%.com' or
-- 	product_rating_comment like '%street%' or
-- 	product_rating_comment like '%[1:9][1:9]/[1:9][1:9]/[1:9][1:9]%'

alter table purchase
modify (delivery_rating_comment varchar(150))

update purchase
set delivery_rating = '5', delivery_rating_comment = '123-576-4334 is my number. the delivery was good', delivery_rating_date='08-MAY-20', tip=2.00
where purchase_id = 1


update purchase
set delivery_rating = '4', delivery_rating_comment = 'apooli@gmail.com. the delivery was ok', delivery_rating_date='07-MAY-20', tip = 3.50
where purchase_id = 2


update purchase
set delivery_rating = '3', delivery_rating_comment = '352-335 stilop street. the delivery was ok', delivery_rating_date='07-MAY-20', tip=1.00
where purchase_id = 3

update purchase
set delivery_rating = '2', delivery_rating_comment = '324-363-7894. the delivery was bad', delivery_rating_date='06-MAY-20', tip=0.10
where purchase_id = 4

update purchase
set delivery_rating = '1', delivery_rating_comment = 'completely awful. guilo@pillo.com', delivery_rating_date='05-MAY-20', tip=0.01
where purchase_id = 5

update specific_product
set product_rating='5', product_rating_comment='this orange was delicious. my birthday is 01/21/95', product_rating_date='01-APR-20'
where product_id='1'

update specific_product
set product_rating='1', product_rating_comment='this banana was awful.', product_rating_date='02-APR-20'
where product_id='10'

update specific_product
set product_rating='3', product_rating_comment='this starfruit was okay.', product_rating_date='03-APR-20'
where product_id='22'

update specific_product
set product_rating='5', product_rating_comment='I had a great day today', product_rating_date='04-APR-20'
where product_id='23'

update specific_product
set product_rating='4', product_rating_comment='My neighbor is making a lot of noise', product_rating_date='05-APR-20'
where product_id='30'

alter table warehouse
add (warehouse_type varchar(20),
    constraint fk_warehouse__warehouse_type
    foreign key (warehouse_type)
    references warehouse_type(warehouse_type))

update warehouse
set warehouse_type = 'refrigerated'
where warehouse_id in ('12', '23', '34')

update warehouse
set warehouse_type = 'non-refrigerated'
where warehouse_id in ('45', '56')

drop table warehouse_inventory

alter table specific_product
add (warehouse_id varchar(20),
    constraint fk_specific_product__warehouse
    foreign key (warehouse_id)
    references warehouse(warehouse_id))

drop table product_type__product_name

alter table general_product
add
(
    product_type varchar(20),
    constraint fk_general_product__product_type
    foreign key (product_type)
    references product_type(product_type)
)

update general_product
set product_type = 'fruit'
where product_name in ('apple','orange','banana','starfruit','kiwi','mango','peach')

update general_product
set product_type = 'meat'
where product_name in ('beef','pork','lamb')

update general_product
set product_type = 'grain'
where product_name in ('rice','bread','gluten')

update general_product
set product_type = 'dairy'
where product_name in ('milk','chocolate_milk')

update general_product
set product_type = 'beverage'
where product_name in ('apple_juice','orange_juice','banana_smoothie','coke','fanta')

update specific_product
set warehouse_id = '12'
where warehouse_id is null

update specific_product
set warehouse_id = '45'
where product_name in (
    select product_name
    from general_product
    where product_type in ('beverage','fruit','grain')
)

alter table customer
add (borough varchar(20),
	constraint fk_customer__borough
	foreign key (borough)
	references borough(borough)


update customer
set borough = 'Staten_Island'
where cust_email in ('grappli@gmail.com','headcorn@gmail.com','mousero@gmail.com')

update customer
set borough = 'Brooklyn'
where cust_email in ('google@gmail.com','cloud@gmail.com','bottle@gmail.com')

update customer
set borough = 'Manhattan'
where cust_email in ('momi@gmail.com','totu@gmail.com','facebook@gmail.com')

update customer
set borough = 'Bronx'
where cust_email in ('sun@gmail.com','zebrasan@gmail.com','pocky@gmail.com')

update customer
set borough = 'Queens'
where cust_email in ('floor@gmail.com','door@gmail.com','ocean@gmail.com')

alter table purchase
rename column time_purchased to purchase_date

insert into purchase(purchase_id, cust_email, purchase_date, method_of_payment, delivery_address, date_delivered, delivery_rating, delivery_rating_comment, delivery_rating_date)
values('13','sun@gmail.com','03-MAY-20', 'credit', '4 apple ave', '05-MAY-20','5','great','05-MAY-20')

insert into purchase(purchase_id, cust_email, purchase_date, method_of_payment, delivery_address, date_delivered, delivery_rating, delivery_rating_comment, delivery_rating_date)
values('14','google@gmail.com','03-MAY-20', 'credit', '10 apple ave', '05-MAY-20','5','great','05-MAY-20')

insert into purchase(purchase_id, cust_email, purchase_date, method_of_payment, delivery_address, date_delivered, delivery_rating, delivery_rating_comment, delivery_rating_date)
values('15','headcorn@gmail.com','03-MAY-20', 'credit', '14 apple ave', '05-MAY-20','5','great','05-MAY-20')

update specific_product
set purchase_id = '13'
where product_id = '2'

update specific_product
set purchase_id = '14'
where product_id = '3'

update specific_product
set purchase_id = '15'
where product_id = '4'

grant select on purchase to staff