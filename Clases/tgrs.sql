CREATE TRIGGER before_employees_instert
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
SET new.lastUpdate = NOW();
END


DELIMITER //

CREATE TRIGGER `InsertOrderDetail` BEFORE INSERT ON `Order Details`
FOR EACH ROW
BEGIN
    DECLARE product_price DECIMAL(10,4);
    DECLARE product_stock INT;

    SELECT `UnitPrice` INTO product_price FROM `Products` WHERE `ProductID` = NEW.ProductID;

    SELECT `UnitsInStock` INTO product_stock FROM `Products` WHERE `ProductID` = NEW.ProductID;

    UPDATE `Products` SET `UnitsInStock` = product_stock - NEW.Quantity WHERE `ProductID` = NEW.ProductID;
END //
DELIMITER ;
drop trigger InsertOrderDetail;