CREATE DATABASE IF NOT EXISTS music_festival
DEFAULT CHARACTER SET 'utf8mb4'
DEFAULT COLLATE 'utf8mb4_general_ci';
USE music_festival;

ALTER TABLE Bar
ADD COLUMN festival_name CHAR(255),
ADD COLUMN festival_edition YEAR;

/*
DROP VIEW IF EXISTS Bar_festival;

CREATE VIEW Bar_festival AS
SELECT DISTINCT Provides.bar_id, Buys.festival_name, Buys.festival_edition
FROM Provider
JOIN Provides ON Provides.provider_id = Provider.id_provider
JOIN Product ON Product.id_product = Provides.product_id
JOIN Consumption ON Consumption.id_product = Product.id_product
JOIN Festivalgoer ON Festivalgoer.id_festivalgoer = Consumption.id_festivalgoer
JOIN Buys ON Buys.id_festivalgoer = Festivalgoer.id_festivalgoer
GROUP BY Provider.id_provider;

SELECT * FROM Bar_festival;

UPDATE Bar
JOIN Bar_festival BF ON Bar.id = BF.bar_id
SET Bar.festival_name = BF.festival_name,
	Bar.festival_edition = BF.festival_edition;
    
*/

/*
	The above would be our code to populate the two new columns of bar, but as it is not asked we won't execute it
*/

ALTER TABLE Provides
CHANGE COLUMN unit_price UnitPriceUSD DECIMAL(10, 2),
ADD COLUMN UnitPriceEUR DECIMAL(10, 2),
ADD COLUMN UnitPriceGBP DECIMAL(10, 2),
ADD COLUMN UnitPriceJPY DECIMAL(10, 2);

-- Create a table to store currency exchange rates

CREATE TABLE IF NOT EXISTS ExchangeRates (
    CurrencyCode VARCHAR(3) PRIMARY KEY,
    ExchangeRate DECIMAL(10, 2) NOT NULL
);

-- Insert initial exchange rates based on some default values

INSERT IGNORE INTO ExchangeRates (CurrencyCode, ExchangeRate) VALUES
    ('EUR', 0.93),
    ('GBP', 0.82),
    ('JPY', 151.51);


CREATE TABLE IF NOT EXISTS Attended_Show(
   	id_festivalgoer INT,
    id_show INT,
	festival_name CHAR(255),
  	festival_edition YEAR,
	PRIMARY KEY (id_festivalgoer, id_show, festival_name, festival_edition),
    CONSTRAINT FK_Festivalgoer FOREIGN KEY (id_festivalgoer) REFERENCES Festivalgoer(id_festivalgoer),
    CONSTRAINT FK_Show FOREIGN KEY (id_show) REFERENCES Show_(id),
	CONSTRAINT FK_Festival FOREIGN KEY (festival_name, festival_edition) REFERENCES Festival(festival_name, festival_edition)
);
