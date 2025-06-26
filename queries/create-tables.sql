CREATE TABLE sales.customers (
    customer_id VARCHAR PRIMARY KEY,
    cpf VARCHAR,
    first_name VARCHAR,
    last_name VARCHAR,
    country VARCHAR,
    state VARCHAR,
    city VARCHAR,
    birth_date DATE,
    income NUMERIC,
    income_symbol VARCHAR,
    professional_status VARCHAR,
    email VARCHAR,
    phone_number VARCHAR,
    gender VARCHAR
);

CREATE TABLE sales.products (
    product_id VARCHAR PRIMARY KEY,
    brand VARCHAR,
    model VARCHAR,
    model_year VARCHAR,
    price VARCHAR,
    country VARCHAR
);

CREATE TABLE sales.stores (
	store_id VARCHAR PRIMARY KEY,
	store_name VARCHAR,
	store_cnpj VARCHAR,
	city VARCHAR,
	state VARCHAR,
	country VARCHAR
);

CREATE TABLE sales.funnel (
    visit_id VARCHAR PRIMARY KEY,
    customer_id VARCHAR NOT NULL,
    store_id VARCHAR NOT NULL,
    product_id VARCHAR NOT NULL,
    visit_page_date DATE,
    add_to_cart_date DATE,
    start_checkout_date DATE,
    finish_checkout_date DATE,
    paid_date DATE,
    discount NUMERIC
);