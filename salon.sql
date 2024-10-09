-- Connect to PostgreSQL
CREATE DATABASE salon;
\c salon;

-- Create customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    phone VARCHAR(15) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL
);

-- Create services table
CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Create appointments table
CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id) NOT NULL,
    service_id INT REFERENCES services(service_id) NOT NULL,
    time VARCHAR(255) NOT NULL
);

INSERT INTO services (name) VALUES 
('cut'), 
('color'), 
('perm'),
('style'),
('trim');
