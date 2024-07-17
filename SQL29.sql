CREATE DATABASE formation;

SHOW DATABASES;

USE formation;

SHOW TABLES;

CREATE TABLE contact (
	id INT PRIMARY KEY AUTO_INCREMENT, 
	lastname VARCHAR(100) NOT NULL,
	firstname VARCHAR(100) NOT NULL DEFAULT 'Toto',
	phone_number VARCHAR(20) NOT NULL,
	email VARCHAR(200) NULL UNIQUE,
    date_of_birth DATE NULL
);

DESCRIBE contact;

ALTER TABLE contact
	ADD COLUMN is_friend BOOL NOT NULL;
    
ALTER TABLE contact
	MODIFY firstname VARCHAR(150) NOT NULL DEFAULT 'Toto',
    DROP COLUMN email;

DROP TABLE contact;

CREATE TABLE booking (
	id INT PRIMARY KEY AUTO_INCREMENT,
    customer_lastname VARCHAR(100) NOT NULL,
    customer_firstname VARCHAR(100) NOT NULL,
    customer_phone_number VARCHAR(20) NOT NULL,
    customer_email VARCHAR(200) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    room_number INT NOT NULL,
    room_floor INT NOT NULL,
    room_type VARCHAR(100) NOT NULL
);

DESCRIBE booking;

ALTER TABLE booking
	ADD COLUMN notes TEXT NULL,
    DROP COLUMN room_floor,
    MODIFY room_type VARCHAR(100) NOT NULL DEFAULT 'Single';
 
 DESCRIBE booking;
 
 ALTER TABLE booking
	MODIFY notes TEXT NULL;
    
INSERT INTO contact (lastname, firstname, phone_number, date_of_birth, is_friend)
VALUES ('Aldaitz', 'Thomas', '0651351351', '1985-04-28', true);

SELECT * FROM contact;

INSERT INTO contact (firstname, lastname, is_friend, phone_number)
VALUES ('Robert', 'Test', true, '0651654156');

INSERT INTO contact (firstname, lastname, is_friend, phone_number)
VALUES ('Jean', 'Retest', false, '0651658796'), 
	   ('Clémence', 'Teston', true, '0416165131');
       
SELECT * FROM contact;

UPDATE contact
SET date_of_birth = '2002-02-02'
;


UPDATE contact
SET date_of_birth = '1985-04-28', is_friend = false
WHERE id = 1;

SELECT * FROM booking;

USE formation;

/*
1 - La réservation numéro 4, doit changer d'email
'sheila@gmail.com'*/

UPDATE booking
SET customer_email = 'sheila@gmail.com'
WHERE id = 4;

/*
2 - Modifier le nom et le prénom de la resa 9
  par "Robert Test"*/
    
  UPDATE booking
  SET customer_lastname = 'Test', customer_firstname = 'Robert'
  WHERE id = 9;
  

/*
3 - Modifier le type de chambre de toutes les
reservation dont la chambre est au 3etage (
les chambre entre 300 et 400) pour le passer à
'Premium'*/

UPDATE booking
SET room_type = 'Premium'
WHERE room_number >= 300 AND room_number < 400;


UPDATE booking
SET room_type = 'Premium'
WHERE room_number BETWEEN 300 AND 399;


SELECT * FROM booking;

USE formation;

/*1 - Supprimer la reservation numéro 28*/

DELETE FROM booking
WHERE id = 28;


/*2 - Supprimer les reservations pour 
les chambres Doubles */

DELETE FROM booking
WHERE room_type = 'Double';


/*-> Le nom, prénom et email des clients dont le prénom est "Julien"*/

SELECT customer_lastname, customer_firstname, customer_email
FROM full_order
WHERE customer_firstname = 'julien'
;

/*-> Le nom, prénom et email des clients dont l'email termine par "@gmail.com"*/

SELECT customer_lastname, customer_firstname, customer_email
FROM full_order
WHERE customer_email LIKE '%@gmail.com'
;


/*-> toutes les commandes  non payées*/

SELECT * 
FROM full_order
WHERE is_paid = false;

/*-> toutes les commandes  payées mais non livré*/

SELECT * 
FROM full_order
WHERE is_paid = true 
AND shipment_date IS NULL
;

/*-> toutes les commandes  livré hors de France*/

SELECT * 
FROM full_order
WHERE shipment_country <> 'France'
ORDER BY shipment_country, customer_lastname
LIMIT 10;


/*-> toutes les commandes au montant de plus 8000€ ordonnées du plus grand au plus petit*/

SELECT * 
FROM full_order
WHERE amount > 8000
ORDER BY amount DESC
;


/*-> La commande au montant le plus élevé (une seule)*/

SELECT * 
FROM full_order
ORDER BY amount DESC
LIMIT 1 ;

/*-> toutes les commandes réglé en Cash en 2022 livré en France dont le montant est inférieur à 5000 €*/

SELECT *
FROM full_order
WHERE payment_type = 'Cash'
AND YEAR(date) = 2022
AND shipment_country = 'France'
AND amount < 5000
;

/*-> toutes les commandes payés par carte ou payé aprés le 15/10/2021*/

SELECT *
FROM full_order
WHERE payment_type = 'Credit Card'
OR payment_date > '2021-10-15'
;

/*-> les 3 dernières commandes envoyées en France*/

SELECT *
FROM full_order
WHERE shipment_country = 'France'
ORDER BY shipment_date DESC
LIMIT 3
;


/*-> les 10 commandes les plus élevés passé sur l'année 2021*/

SELECT * 
FROM full_order
WHERE YEAR(date) = 2021
ORDER BY amount DESC
LIMIT 10;

/*-> la somme des commandes non payés*/

SELECT ROUND(SUM(amount), 2) AS unpaid_orders
FROM full_order
WHERE is_paid = false;

/*-> la moyenne des montants des commandes payés en cash*/

SELECT ROUND(AVG(amount), 2) AS average_cash_amount
FROM full_order
WHERE payment_type = 'Cash';

/*-> le nombre de client dont le nom est "Laporte"*/
SELECT COUNT(id) AS nb_of_Laporte
FROM full_order
WHERE customer_lastname = 'Laporte';

/*-> Le nombre de jour Maximum entre la date de payment et la date de livraison -> DATEDIFF()*/

SELECT MAX(DATEDIFF(payment_date, shipment_date)) AS max_delay_payment
FROM full_order
;


/*-> Le délai moyen (en jour) de réglement d'une commande*/

SELECT ROUND(
			AVG(
				ABS(
					DATEDIFF(date, payment_date)
                    )
                )
            ) AS average_payment_delay
FROM full_order
WHERE is_paid = true
;

/*-> le nombre de commande payés en chèque sur 2021*/

SELECT COUNT(*) AS nb_check_in_2021
FROM full_order
WHERE payment_type = 'Check'
AND YEAR(payment_date) = 2021
;


SELECT customer_lastname, 
		customer_firstname, 
        SUM(amount) AS total_amount, 
        COUNT(*)
FROM full_order
WHERE customer_lastname = 'Alves'
	AND customer_firstname = 'Charles'
GROUP BY customer_lastname, customer_firstname
ORDER BY customer_lastname
;





SELECT *
FROM full_order
WHERE customer_lastname = 'Alves'
	AND customer_firstname = 'Charles'
;


/*-> Le montant total des commandes par type de paiement*/

SELECT payment_type, ROUND(SUM(amount), 2) AS total_amount
FROM full_order
WHERE is_paid = true
GROUP BY payment_type
ORDER BY payment_type
;

/*-> La moyenne des montants des commandes par Pays*/

SELECT shipment_country, ROUND(AVG(amount), 2) AS Average_amount
FROM full_order
WHERE shipment_country IS NOT NULL
GROUP BY shipment_country
ORDER BY shipment_country
;

/*-> Par année (champ date) la somme des montants des commandes*/

SELECT YEAR(date) AS order_year, ROUND(SUM(amount), 2) AS total_per_year
FROM full_order
GROUP BY order_year
ORDER BY order_year
;

/*-> Liste des clients (nom, prénom) qui ont au moins deux commandes*/

SELECT customer_lastname, customer_firstname, COUNT(id) AS nb_order
FROM full_order
GROUP BY customer_lastname, customer_firstname
	HAVING nb_order >= 2
ORDER BY customer_lastname, customer_firstname
;


/*-> Liste des clients (nom, prénom) avec le montant de leur commande
la plus élevé en 2021 (TOP 3)*/

SELECT customer_lastname, customer_firstname, MAX(amount) AS max_amount
FROM full_order
WHERE YEAR(date) = 2021
GROUP BY customer_lastname, customer_firstname
ORDER BY max_amount DESC
LIMIT 3
;


CREATE DATABASE billings;
USE billings;

/*-> tous les produits avec leur nom et 
le label de leur catégorie*/

SELECT pr.name, ca.label
FROM product pr
	JOIN category ca ON pr.category_id = ca.id
;


/*-> Toutes les factures avec leur id, 
ainsi que les noms et prénoms de leur client*/

SELECT bi.id, cu.lastname, cu.firstname
FROM bill bi 
	JOIN customer cu ON bi.customer_id = cu.id
ORDER BY bi.id
;


/*-> Pour chaque client (nom, prénom) remonter 
le nombre de facture associé*/

SELECT cu.id, cu.lastname, cu.firstname, COUNT(bi.id) AS nb_bill
FROM bill bi 
	JOIN customer cu ON bi.customer_id = cu.id
GROUP BY cu.id
ORDER BY cu.id
;

USE billings;
/*-> Pour chaque catégorie la moyenne des prix de produits associés*/

SELECT ca.label, ROUND(AVG(pr.unit_price), 2) AS average_price
FROM category ca 
	JOIN product pr ON pr.category_id = ca.id
GROUP BY ca.id
;

/*-> Pour Chaque produit toutes les lignes de facture avec la date et la quantité*/

SELECT pr.id, pr.name, li.quantity, bi.date
FROM product pr
	JOIN line_item li ON li.product_id = pr.id
    JOIN bill bi ON li.bill_id = bi.id
ORDER BY pr.id
;


/*-> Pour Chaque produit la quantité cumulé commandée depuis le 01/01/2021*/

SELECT pr.id, pr.name, SUM(li.quantity) as total_qty_ordered
FROM product pr
	JOIN line_item li ON li.product_id = pr.id
    JOIN bill bi ON li.bill_id = bi.id
WHERE bi.date > '2021-01-01'
GROUP BY pr.id
ORDER BY pr.id
;


/*-> La liste des Facture (ref) qui ont plus de 2 produits différends commandé*/

SELECT bi.id, COUNT(li.product_id) AS nb_product
FROM bill bi
	JOIN line_item li ON li.bill_id = bi.id
GROUP BY bi.id
	HAVING nb_product > 2
ORDER BY bi.id
;

/*-> Pour chaque Facture afficher le montant total*/

SELECT b.id, SUM(li.quantity * pr.unit_price) AS total_amount
FROM bill b
	JOIN line_item li ON li.bill_id = b.id
	JOIN product pr ON li.product_id = pr.id
GROUP BY b.id
ORDER BY b.id
;


USE formation;

/*
amount 
date
payment_mean
*/
CREATE TABLE payment (
	id INT PRIMARY KEY AUTO_INCREMENT,
    amount FLOAT NOT NULL,
    date DATETIME NOT NULL,
    payment_mean VARCHAR(50) NOT NULL,
    booking_id INT NOT NULL
);

SELECT * FROM booking;
SELECT * FROM payment;

INSERT INTO payment (amount, date, payment_mean, booking_id) 
VALUES (400, '2024-07-17 09:17:00', 'Cash', 9);

INSERT INTO payment (amount, date, payment_mean, booking_id) 
VALUES 
	(150, '2024-07-17 09:17:00', 'Cash', 5),
    (200, NOW(), 'Card', 8),
    (320, NOW(), 'Check', 12),
    (50, NOW(), 'Check', 15),
    (170, NOW(), 'Check', 15),
    (95, NOW(), 'Cash', 7)
;


SELECT bo.id, bo.customer_lastname, bo.customer_firstname, bo.start_date, SUM(pa.amount) AS total_payment
FROM payment pa
	JOIN booking bo ON  pa.booking_id = bo.id
GROUP BY bo.id
	HAVING total_payment >= 250
;



SELECT bo.id, bo.customer_lastname, bo.customer_firstname, bo.start_date, SUM(pa.amount) AS total_payment
FROM payment pa
	RIGHT JOIN booking bo ON  pa.booking_id = bo.id
GROUP BY bo.id
	HAVING total_payment < 250 OR total_payment IS NULL
ORDER BY  total_payment DESC
;



SELECT *
FROM payment pa JOIN booking bo ON  pa.booking_id = bo.id
;


SELECT * 
FROM payment, booking
WHERE payment.booking_id = booking.id
;

USE formation;
SELECT * FROM booking;
SELECT * FROM payment;

DELETE FROM booking
WHERE id = 25;


ALTER TABLE payment
ADD CONSTRAINT FK_payment_booking
FOREIGN KEY payment (booking_id)
REFERENCES booking (id);

CREATE TABLE room (
	id INT PRIMARY KEY AUTO_INCREMENT,
    room_number INT NOT NULL,
    room_type VARCHAR(50) NOT NULL
);


ALTER TABLE booking 
	ADD COLUMN room_id INT NULL;
    
SELECT * FROM booking;


ALTER TABLE booking
	ADD CONSTRAINT FK_booking_room
    FOREIGN KEY booking (room_id)
    REFERENCES room (id);
    
INSERT INTO room (room_number, room_type)
VALUES 
	(101, 'Single'),
	(102, 'Single'),
	(103, 'Single'),
	(104, 'Single'),
	(201, 'Double'),
	(202, 'Double'),
	(301, 'Premium'),
	(304, 'Premium')
;

SELECT * FROM room;
SELECT * FROM booking;


SELECT * 
FROM booking bo
	JOIN room ro ON bo.room_id = ro.id
;


USE billings;


SELECT * FROM bill;
SELECT * FROM customer;

SELECT cu.id, cu.lastname, cu.firstname, COUNT(bi.id) AS nb_Bills
FROM customer cu
	JOIN bill bi ON cu.id = bi.customer_id
GROUP BY cu.id
ORDER BY cu.id
;


SELECT * 
FROM table_1 t1
	JOIN table_2 t2 ON t1.id = t2.table_1_id
;



SELECT * FROM customer
WHERE id = 4005
;

SELECT * FROM bill
WHERE customer_id = 4005
;



/*-> Pour chaque client compter le nombre de produit différents qu'il a commandé*/

SELECT cu.id, cu.lastname, cu.firstname, COUNT(li.product_id) AS nb_products
FROM customer cu
	JOIN bill bi ON cu.id = bi.customer_id
    JOIN line_item li ON bi.id = li.bill_id
GROUP BY cu.id
ORDER BY cu.id
;

/*-> Pour chaque produit compter le nombre de client différents qu'ils l'ont commandé*/

SELECT pr.id, pr.name, COUNT(bi.customer_id) AS nb_customer
FROM product pr
	JOIN line_item li ON pr.id = li.product_id
    JOIN bill bi ON bi.id = li.bill_id
GROUP BY pr.id
ORDER BY pr.id
;

/*-> pour chaque catégorie de produit la somme des facture payées*/
SELECT ca.label, SUM(pr.unit_price * li.quantity) AS total_amount
FROM category ca
	JOIN product pr ON ca.id = pr.category_id
	JOIN line_item li ON pr.id = li.product_id
    JOIN bill bi ON bi.id = li.bill_id
WHERE bi.is_paid = true
GROUP BY ca.id
ORDER BY total_amount DESC
;

/*-> par Année (de facture) la moyenne d'age des clients*/
SELECT YEAR(bi.date) AS bill_year, ROUND(AVG(TIMESTAMPDIFF(YEAR, cu.date_of_birth, bi.date))) AS Age
FROM bill bi
	JOIN customer cu ON cu.id = bi.customer_id
GROUP BY bill_year
ORDER BY bill_year
;

/*-> les nom, prénom et num de tel des clients qui ont commandes des produit de 
camping ces deux dernières années*/

SELECT cu.lastname, cu.firstname, cu.phone_number
FROM category ca
	JOIN product pr ON ca.id = pr.category_id
	JOIN line_item li ON pr.id = li.product_id
    JOIN bill bi ON bi.id = li.bill_id
    JOIN customer cu ON cu.id = bi.customer_id
WHERE ca.label = 'Camping'
AND YEAR(bi.date) >= 2022
GROUP BY cu.id
ORDER BY cu.id
;

/*-> La moyenne d'age des consomateurs pour chaque catégorie de produit*/
SELECT ca.label, ROUND(AVG(TIMESTAMPDIFF(YEAR, cu.date_of_birth, NOW()))) AS average_age
FROM category ca
	JOIN product pr ON ca.id = pr.category_id
	JOIN line_item li ON pr.id = li.product_id
    JOIN bill bi ON bi.id = li.bill_id
    JOIN customer cu ON cu.id = bi.customer_id
GROUP BY ca.id
;

/*-> la liste des produits, avec le nom de leur catégorie, commandés plus de 10 fois en quantité en 2022*/

SELECT pr.id, pr.name, ca.label, SUM(li.quantity) as nb_ordered
FROM category ca
	JOIN product pr ON ca.id = pr.category_id
	JOIN line_item li ON pr.id = li.product_id
    JOIN bill bi ON bi.id = li.bill_id
WHERE YEAR(bi.date) = 2022
GROUP BY pr.id
	HAVING nb_ordered > 10
;



/*-> la liste des 10 produits les plus vendus en 2021 (ne compter que les factures payés)*/

/*-> les 3 clients qui ont commandé le plus de produits streetwear*/


CREATE VIEW ca_by_category AS
	SELECT ca.label, SUM(pr.unit_price * li.quantity) AS total_amount
	FROM category ca
		JOIN product pr ON ca.id = pr.category_id
		JOIN line_item li ON pr.id = li.product_id
		JOIN bill bi ON bi.id = li.bill_id
	WHERE bi.is_paid = true
	GROUP BY ca.id
	ORDER BY total_amount DESC
;


SELECT * FROM bill;
SELECT * FROM ca_by_category;


CREATE VIEW bills_with_amount AS
SELECT b.*, SUM(li.quantity * pr.unit_price) AS total_amount
FROM bill b
	JOIN line_item li ON li.bill_id = b.id
	JOIN product pr ON li.product_id = pr.id
GROUP BY b.id
ORDER BY b.id
;

SELECT * FROM bills_with_amount;
SELECT * FROM customer;



SELECT cu.lastname, cu.firstname, SUM(bwa.total_amount) AS total_bills, COUNT(BWA.id) AS nb_bills
FROM bills_with_amount bwa
	JOIN customer cu ON bwa.customer_id = cu.id
GROUP BY cu.id
ORDER BY nb_bills DESC
LIMIT 3
;

SELECT cu.lastname, cu.firstname, SUM(bwa.total_amount) AS total_bills, MAX(bwa.total_amount) AS max_bill
FROM bills_with_amount bwa
	JOIN customer cu ON bwa.customer_id = cu.id
GROUP BY cu.id
ORDER BY max_bill DESC
LIMIT 3
;

SELECT cu.lastname, cu.firstname, SUM(bwa.total_amount) AS total_bills
FROM bills_with_amount bwa
	JOIN customer cu ON bwa.customer_id = cu.id
GROUP BY cu.id
ORDER BY total_bills DESC
LIMIT 3
;


ALTER TABLE customer 
	ADD COLUMN is_vip BOOL NOT NULL; 
    
    
DROP PROCEDURE update_vips;
DELIMITER //
CREATE PROCEDURE update_vips(vip_limit FLOAT) 
BEGIN
    
    UPDATE customer
    SET is_vip = false;
    
    UPDATE customer
    SET is_vip = true
    WHERE id IN (
		SELECT customer_id
		FROM bills_with_amount
		GROUP BY customer_id
			HAVING SUM(total_amount) > vip_limit
    );

END//

CALL update_vips(20000);


SELECT * FROM customer;
