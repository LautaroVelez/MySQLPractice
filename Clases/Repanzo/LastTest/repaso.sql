--delimitar para q en vez de ; sea //
DELIMITER //
--crear stored procedure
CREATE PROCEDURE GetAllProducts()
BEGIN
    SELECT * FROM products;
END //
DELIMITER ;


--llamar a un stored procedure
CALL GetAllProducts();


--definir una variable
DECLARE nombre_de_variable tipo_de_dato(tamaño) DEFAULT valor_predeterminado;
--osea
DECLARE total_sale INT DEFAULT 0;

--podes asignarle valores a esas VARIABLES

DECLARE total_count INT DEFAULT 0;
SET total_count = 10;

--o sino

DECLARE total_products INT DEFAULT 0;
SELECT COUNT(*) INTO total_products FROM products;

--Ejemplo de parámetro IN:
DELIMITER //
CREATE PROCEDURE GetOfficeByCountry(IN countryName VARCHAR(255))
BEGIN
    SELECT * 
    FROM offices
    WHERE country = countryName;
END //
DELIMITER ;

--para llamarlo y probar si anda es 
CALL GetOfficeByCountry('USA');

--Ejemplo de parámetro OUT:
DELIMITER $$
CREATE PROCEDURE CountOrderByStatus(
    IN orderStatus VARCHAR(25),
    OUT total INT
)
BEGIN
    SELECT COUNT(orderNumber)
    INTO total
    FROM orders
    WHERE status = orderStatus;
END $$
DELIMITER ;

--para llamarlo seria 
CALL CountOrderByStatus('Shipped', @total);
SELECT @total;

--Ejemplo de parámetro INOUT:

DELIMITER $$
CREATE PROCEDURE set_counter(INOUT count INT(4), IN inc INT(4))
BEGIN
    SET count = count + inc;
END $$
DELIMITER ;

--para probarlo es 

SET @counter = 1;
CALL set_counter(@counter, 1); -- 2
CALL set_counter(@counter, 1); -- 3
CALL set_counter(@counter, 5); -- 8
SELECT @counter; -- 8

--con un case

DELIMITER $$

CREATE PROCEDURE GetCustomerShipping(
    IN p_customerNumber INT(11), 
    OUT p_shipping VARCHAR(50))
BEGIN
    DECLARE customerCountry VARCHAR(50);

    SELECT country INTO customerCountry
    FROM customers
    WHERE customerNumber = p_customerNumber;

    CASE customerCountry
        WHEN 'USA' THEN
           SET p_shipping = 'Envío de 2 días';
        WHEN 'Canadá' THEN
           SET p_shipping = 'Envío de 3 días';
        ELSE
           SET p_shipping = 'Envío de 5 días';
    END CASE;

END$$

--lo llamas asi

SET @customerNo = 112;

SELECT country INTO @country
FROM customers
WHERE customernumber = @customerNo;

CALL GetCustomerShipping(@customerNo, @shipping);

SELECT @customerNo AS Cliente,
       @country AS País,
       @shipping AS Envío;
