
create view list_of_customers as
select c.customer_id, concat(c.first_name, ' ', c.last_name) as full_name, a.address, a.postal_code, a.phone, ci.city, co.country, CASE 
    WHEN customer_id = 1 THEN 'active'  
    ELSE  'inactive'
END as status, s.store_id 
from customer c
join store s using(address_id)
join address a using(address_id)
join city ci using(city_id)
join country co using(country_id);

select * from list_of_customers;


CREATE or replace VIEW `OrderReport` AS
SELECT 
    `Shippers`.`ShipperID`, 
    `Categories`.`CategoryID`, 
    COUNT(`Orders`.`OrderID`) AS `cantOrdenes`, 
    SUM(`Order Details`.`Quantity`) AS `cantTotal`, 
    SUM(`Order Details`.`Quantity` * (`Order Details`.`UnitPrice` - `Order Details`.`Discount`)) AS `gananciasNetas`, 
    SUM(`Order Details`.`Quantity` * `Order Details`.`UnitPrice`) AS `gananciasPrecActual`, 
    MAX(`Orders`.`OrderDate`) AS `ordenMasReciente`, 
    MIN(`Orders`.`OrderDate`) AS `ordenMasAntigua` 
FROM 
    `Orders` 
    JOIN `Shippers` ON `Orders`.`ShipVia` = `Shippers`.`ShipperID` 
    JOIN `Order Details` ON `Orders`.`OrderID` = `Order Details`.`OrderID` 
    JOIN `Products` ON `Order Details`.`ProductID` = `Products`.`ProductID` 
    JOIN `Categories` ON `Products`.`CategoryID` = `Categories`.`CategoryID` 
WHERE 
    YEAR(`Orders`.`OrderDate`) = (SELECT YEAR(MAX(`OrderDate`)) - 1 FROM `Orders`)
GROUP BY 
    `Shippers`.`ShipperID`, `Categories`.`CategoryID`;



SELECT 
    *,(`gananciasPrecActual` - `gananciasNetas`) AS `Diferencia`
FROM
    `OrderReport`
WHERE
    (`gananciasPrecActual` - `gananciasNetas`) > 4000;



drop view `OrderReport`