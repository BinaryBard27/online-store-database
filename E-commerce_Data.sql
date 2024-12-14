-- Create user demographics table
CREATE TABLE users (
    user_id VARCHAR(10) PRIMARY KEY,
    gender CHAR(1) CHECK (gender IN ('M', 'F')),
    age VARCHAR(10),
    occupation INTEGER,
    city_category CHAR(1) CHECK (city_category IN ('A', 'B', 'C')),
    stay_in_current_city_years VARCHAR(5),
    marital_status INTEGER CHECK (marital_status IN (0, 1))
);
-- Create products table
CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_category INTEGER
);

-- Create purchases table
CREATE TABLE purchases (
    purchase_id SERIAL PRIMARY KEY,
    user_id VARCHAR(10) REFERENCES users(user_id),
    product_id VARCHAR(10) REFERENCES products(product_id),
    purchase_amount INTEGER,
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Create indexes for better query performance
CREATE INDEX idx_purchases_user ON purchases(user_id);
CREATE INDEX idx_purchases_product ON purchases(product_id);
CREATE INDEX idx_products_category ON products(product_category);

-- First, create a temporary table to hold all the data
CREATE TEMPORARY TABLE temp_import (
    User_ID VARCHAR(10),
    Product_ID VARCHAR(10),
    Gender CHAR(1),
    Age VARCHAR(10),
    Occupation INTEGER,
    City_Category CHAR(1),
    Stay_In_Current_City_Years VARCHAR(5),
    Marital_Status INTEGER,
    Product_Category INTEGER,
    Purchase INTEGER
);


-- First, create a temporary table to hold all the data
CREATE TEMPORARY TABLE temp_import (
    User_ID VARCHAR(10),
    Product_ID VARCHAR(10),
    Gender CHAR(1),
    Age VARCHAR(10),
    Occupation INTEGER,
    City_Category CHAR(1),
    Stay_In_Current_City_Years VARCHAR(5),
    Marital_Status INTEGER,
    Product_Category INTEGER,
    Purchase INTEGER
);

-- Copy data using absolute path
COPY temp_import FROM 'C:\Users\SHERWIN\Desktop\pp\ecommerce_data.csv' WITH CSV HEADER;

-- Insert data into respective tables
INSERT INTO users (user_id, gender, age, occupation, city_category, 
                  stay_in_current_city_years, marital_status)
SELECT DISTINCT User_ID, Gender, Age, Occupation, City_Category,
                Stay_In_Current_City_Years, Marital_Status
FROM temp_import;

INSERT INTO products (product_id, product_category)
SELECT DISTINCT Product_ID, Product_Category
FROM temp_import;

INSERT INTO purchases (user_id, product_id, purchase_amount)
SELECT User_ID, Product_ID, Purchase
FROM temp_import;

-- Drop temporary table
DROP TABLE temp_import;
SELECT * FROM users;