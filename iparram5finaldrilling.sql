-- Database: dvdrental

-- customer
SELECT * FROM customer;
INSERT INTO customer(
	customer_id, store_id, first_name, last_name, email, address_id, activebool, create_date, last_update, active)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);

UPDATE customer
SET customer_id=?, store_id=?, first_name=?, last_name=?, email=?, address_id=?, activebool=?, create_date=?, last_update=?, active=?
WHERE <condition>;

DELETE FROM customer
WHERE <condition>;

-- staff
SELECT * FROM staff;
INSERT INTO staff(
	staff_id, first_name, last_name, address_id, email, store_id, active, username, password, last_update, picture)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);

UPDATE staff
SET staff_id=?, first_name=?, last_name=?, address_id=?, email=?, store_id=?, active=?, username=?, password=?, last_update=?, picture=?
WHERE <condition>;

DELETE FROM staff
WHERE <condition>;

-- actor
select * from actor;
INSERT INTO actor(
	actor_id, first_name, last_name, last_update)
VALUES (?, ?, ?, ?);

UPDATE actor
set actor_id=?, first_name=?, last_name=?, last_update=?
WHERE <condition>;

DELETE FROM actor
WHERE <condition>;

-- min rental_date = 2005-05-24
-- max rental_date = 2006-02-14
--  Listar todas las “rental” con los datos del “customer” dado un año y mes.
select * from rental;
select * from customer;

SELECT rental.rental_date AS "Fecha", customer.customer_id, customer.store_id, customer.first_name AS "Nombre", 
	customer.last_name AS "Apellido", customer.email, customer.address_id AS "Dirección", customer.activebool, 
	customer.create_date, customer.last_update, customer.active, rental.rental_id, 
	rental.inventory_id, rental.return_date, rental.staff_id, rental.last_update
FROM customer
INNER JOIN rental ON customer.customer_id = rental.customer_id
WHERE EXTRACT(YEAR FROM rental.rental_date) = 2005
AND EXTRACT(MONTH FROM rental.rental_date) = 05;


-- Listar Número, Fecha (payment_date) y Total (amount) de todas las “payment”.
select min(payment_date) from payment; -- 2007-02-14
select max(payment_date) from payment; -- 2007-05-14

SELECT COUNT(payment_id) AS "Número", DATE(payment_date) AS "Fecha", SUM(amount) AS "Total"
FROM payment
GROUP BY DATE(payment_date)
ORDER BY DATE(payment_date) asc;

-- Listar todas las “film” del año 2006 que contengan un (rental_rate) mayor a 4.0.
SELECT * FROM film;
SELECT film_id, title AS "Título", description AS "Descripción", rental_rate AS "Tarifa de Alquiler"
FROM film
WHERE release_year = 2006
AND rental_rate > 4
ORDER BY title ASC;

------------------------------------
select * from actor;
SELECT actor, actor.first_name, is_nullable, data_type
FROM information_schema.columns
WHERE table_schema = 'public';

-- Realiza un Diccionario de datos que contenga el nombre de las tablas y columnas, 
-- si éstas pueden ser nulas, y su tipo de dato correspondiente.
SELECT
	t1.TABLE_NAME AS tabla_nombre,
	t1.COLUMN_NAME AS columna_nombre,
	t1.IS_NULLABLE AS columna_nulo,
	t1.DATA_TYPE AS columna_tipo_dato,
COALESCE(t1.NUMERIC_PRECISION,
	t1.CHARACTER_MAXIMUM_LENGTH) AS columna_longitud
FROM
	INFORMATION_SCHEMA.COLUMNS t1
	INNER JOIN PG_CLASS t2 ON (t2.RELNAME = t1.TABLE_NAME)
WHERE
	t1.TABLE_SCHEMA = 'public'
ORDER BY
	t1.TABLE_NAME;