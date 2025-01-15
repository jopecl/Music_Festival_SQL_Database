CREATE DATABASE IF NOT EXISTS music_festival
DEFAULT CHARACTER SET 'utf8mb4'
DEFAULT COLLATE 'utf8mb4_general_ci';
USE music_festival;

-- WE ASSUMED THAT THE IMPROVEMENTS FILE HAS BEEN RUN SO ALL THE IMPROVEMENTS, INCLUDING THE TABLES BELOW, HAVE ALREADY BEEN CREATED AND POPULATED.
/*
ALTER TABLE Provides
CHANGE COLUMN unit_price UnitPriceUSD DECIMAL(10, 2),
ADD COLUMN UnitPriceEUR DECIMAL(10, 2),
ADD COLUMN UnitPriceGBP DECIMAL(10, 2),
ADD COLUMN UnitPriceJPY DECIMAL(10, 2);


-- Create a table to store currency exchange rates
DROP TABLE IF EXISTS ExchangeRates;
CREATE TABLE IF NOT EXISTS ExchangeRates (
    CurrencyCode VARCHAR(3) PRIMARY KEY,
    ExchangeRate DECIMAL(10, 2) NOT NULL
);

-- Insert initial exchange rates
INSERT IGNORE INTO ExchangeRates (CurrencyCode, ExchangeRate) VALUES
    ('EUR', 0.93),
    ('GBP', 0.82),
    ('JPY', 151.51);
*/
DROP PROCEDURE IF EXISTS UpdatePrice;
DELIMITER //

CREATE PROCEDURE UpdatePrice(IN productId INT)
BEGIN

	DECLARE exchangeRateEUR DECIMAL(10, 2);
    DECLARE exchangeRateGBP DECIMAL(10, 2);
    DECLARE exchangeRateJPY DECIMAL(10, 2);
    DECLARE productCount INT;
    
    -- check if productId exists
    SELECT COUNT(*) INTO productCount
    FROM Provides
    WHERE product_id = productId;

    IF (productId > 0 AND productCount = 0) THEN
        -- warning message and exit
        SELECT 'Warning: There is no product with this identifier.';
    END IF;
	
	SELECT ExchangeRate INTO exchangeRateEUR FROM ExchangeRates WHERE CurrencyCode = 'EUR';
    SELECT ExchangeRate INTO exchangeRateGBP FROM ExchangeRates WHERE CurrencyCode = 'GBP';
    SELECT ExchangeRate INTO exchangeRateJPY FROM ExchangeRates WHERE CurrencyCode = 'JPY';


    IF productId = 0 THEN
        -- update all 
        UPDATE Provides
        SET UnitPriceEUR = UnitPriceUSD * exchangeRateEUR,
            UnitPriceGBP = UnitPriceUSD * exchangeRateGBP,
            UnitPriceJPY = UnitPriceUSD * exchangeRateJPY
        WHERE UnitPriceUSD IS NOT NULL;

    ELSE
        -- single product
        UPDATE Provides
        SET UnitPriceEUR = UnitPriceUSD * exchangeRateEUR,
            UnitPriceGBP = UnitPriceUSD * exchangeRateGBP,
            UnitPriceJPY = UnitPriceUSD * exchangeRateJPY
        WHERE Provides.product_id = productId AND UnitPriceUSD IS NOT NULL;
        
    END IF;
   
    -- not informed prices to value 0
    UPDATE Provides
    SET UnitPriceEUR = IFNULL(UnitPriceEUR, 0),
        UnitPriceGBP = IFNULL(UnitPriceGBP, 0),
        UnitPriceJPY = IFNULL(UnitPriceJPY, 0)
    WHERE UnitPriceUSD IS NULL;
	
END //
DELIMITER ;

UPDATE Provides SET UnitPriceUSD = 10 WHERE product_id = 1 ; 
CALL UpdatePrice(1); 
SELECT * FROM PROVIDES; -- to see the changes