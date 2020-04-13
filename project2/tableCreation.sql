CREATE TABLE CUSTOMER
(
cust_email varchar2(20) NOT NULL PRIMARY KEY,
full_name varchar2(20) NOT NULL,
billing_address varchar2(20) NOT NULL,
password_ varchar2(20) NOT NULL,
phone number NOT NULL,
zipcode number
);

CREATE TABLE CUSTOMER__DELIVERY_ADDRESS
(
cust_email varchar2(20) NOT NULL,
delivery_address varchar(20) NOT NULL,
constraint pk_customer__delivery_address
  PRIMARY KEY (cust_email, delivery_address),
CONSTRAINT fk_customer
  FOREIGN KEY (CUST_EMAIL) 
  REFERENCES CUSTOMER(CUST_EMAIL)
);
create table staff
(
staff_email varchar(20) not null primary key,
full_name varchar(20) not null,
address_ varchar(20) not null
)

create table job_
(
job_ varchar(20) not null primary key,
department varchar(20) not null,
salary number(9,2) not null
);

create table staff_job_record
(
record_id number not null primary key,
staff_email varchar(20) not null,
job_ varchar(20) not null,
start_date date not null,
end_date date,
constraint FK_staff
  foreign key (staff_email)
  references staff(staff_email),
constraint FK_job_
  foreign key (job_)
  references job_(job_)
);

create table Warehouse
(
warehouse_id varchar(20) primary key,
address_ varchar(20),
date_opened date,
date_closed date
);

create table General_Product
(
  product_name varchar(20) primary key,
  calories number,
  sodium number,
  price number(9,2)
);

create table product_type
(
  product_type varchar(20) primary key
);

create table Product_Type__Product_Name
(
  product_type varchar(20),
  product_name varchar(20),
  constraint pk_Product_Type__Product_Name
    primary key (product_type, product_name),
  constraint fk_general_product
    foreign key (product_name)
    references general_product(product_name),
  constraint fk_product_type
    foreign key (product_type)
    references product_type(product_type)
);

create table warehouse_type
(
warehouse_type varchar(20) primary key
);

create table Warehouse__Warehouse_Type
(
  warehouse_id varchar(20),
  warehouse_type varchar(20),
  constraint pk_Warehouse__Warehouse_Type
    primary key (warehouse_id, warehouse_type),
  constraint fk_warehouse
    foreign key (warehouse_id)
    references warehouse(warehouse_id)
);

create table Warehouse_Type__Product_Type
(
  warehouse_type varchar(20),
  product_type varchar(20),
  constraint pk_Warehouse_Type__Product_Type
    primary key (warehouse_type, product_type),
  constraint fk_product_Type2
    foreign key (product_type)
    references product_type(product_type),
  constraint fk_warehouse_type
    foreign key (warehouse_type)
    references warehouse_type(warehouse_type)
);

create table Warehouse_Inventory
(
  warehouse_id varchar(20),
  product_name varchar(20),
  quantity number,
  constraint pk_Warehouse_Inventory
    primary key (warehouse_id, product_name),
  constraint fk_warehouse2
    foreign key (warehouse_id)
    references warehouse(warehouse_id),
  constraint fk_general_product2
    foreign key (product_name)
    references general_product(product_name)
);
create table Specific_Product
(
  product_id varchar(20) primary key,
  product_name varchar(20),
  expiration_date date,
  constraint fk_general_product3
    foreign key (product_name)
    references general_product(product_name)
);
create table Purchase
(
  purchase_id varchar(20) primary key,
  cust_email varchar(20),
  time_purchased date,
  method varchar(20),
  delivery_address varchar(20),
  date_delivered date,
  constraint fk_customer2
    foreign key (cust_email)
    references customer(cust_email)
);
create table Purchase__Product
(
  purchase_id varchar(20),
  product_name varchar(20),
  quantity number,
  constraint pk_Purchase__Product
    primary key (purchase_id, product_name),
  constraint fk_purchase
    foreign key (purchase_id)
    references purchase(purchase_id),
  constraint fk_general_product4
    foreign key (product_name)
    references general_product(product_name)
);



create table purchase__Staff
(
  purchase_id varchar(20),
  staff_email varchar(20),
  constraint pk_Delivery__Staff
    primary key (purchase_id, staff_email),
  constraint fk_staff2
    foreign key (staff_email)
    references staff(staff_email),
  constraint fk_purchase2
    foreign key (purchase_id)
    references purchase(purchase_id)
);