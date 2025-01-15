CREATE DATABASE IF NOT EXISTS music_festival
DEFAULT CHARACTER SET 'utf8mb4'
DEFAULT COLLATE 'utf8mb4_general_ci';
USE music_festival;

-- WE ASSUMED THAT THE IMPROVEMENTS FILE HAS BEEN RUN SO ALL THE IMPROVEMENTS, INCLUDING THE TABLES BELOW, HAVE ALREADY BEEN CREATED AND POPULATED.
/*
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

DROP TRIGGER IF EXISTS UpdatePriceUpToDate;

DELIMITER //
CREATE TRIGGER UpdatePriceUpToDate
BEFORE UPDATE ON Provides
FOR EACH ROW
BEGIN 
		
    DECLARE exchangeRateEUR DECIMAL(10, 2);
    DECLARE exchangeRateGBP DECIMAL(10, 2);
    DECLARE exchangeRateJPY DECIMAL(10, 2);
    
    SELECT ExchangeRate INTO exchangeRateEUR FROM ExchangeRates WHERE CurrencyCode = 'EUR'; #this assumes req 5 has been executed and the table required created, otherwise execute it above (line 10)
    SELECT ExchangeRate INTO exchangeRateGBP FROM ExchangeRates WHERE CurrencyCode = 'GBP';
    SELECT ExchangeRate INTO exchangeRateJPY FROM ExchangeRates WHERE CurrencyCode = 'JPY';

    IF (OLD.UnitPriceEUR <> NEW.UnitPriceUSD * exchangeRateEUR) OR (OLD.UnitPriceGBP <> NEW.UnitPriceUSD * exchangeRateGBP) OR (OLD.UnitPriceJPY <> NEW.UnitPriceUSD * exchangeRateJPY) THEN
		
        /*
			CALL(UpdatePrice(NEW.product_id));
            
            Our original idea was to call the function we had designed in requirement 5. However,
            we ran constantly into an error that did not allow us to call the function inside the trigger.
            This is a "protection" mechanism in SQL that activates when a trigger is trying to update the same table that triggers it
            to avoid running into infinite loops. We tried other solutions to call the procedure previously designed, but we came to
            the final conclusion that this (below) was the most elegant way to solve the issue. 
            If some currency exchange rate is modified, this modification will be reflected in the ExchangeRate table and
            this trigger will still perform as it is suposed to.            
        */
        
        SET NEW.UnitPriceEUR = NEW.UnitPriceUSD * exchangeRateEUR,
            NEW.UnitPriceGBP = NEW.UnitPriceUSD * exchangeRateGBP,
            NEW.UnitPriceJPY = NEW.UnitPriceUSD * exchangeRateJPY;
		
    END IF;

	
END //
DELIMITER ;
