SET global local_infile = 1;

CREATE DATABASE IF NOT EXISTS music_festival
DEFAULT CHARACTER SET 'utf8mb4'
DEFAULT COLLATE 'utf8mb4_general_ci';
USE music_festival;

CREATE TABLE IF NOT EXISTS Bars_temp (
    id_bar INT,
    bar_name CHAR(255),
    is_foodtruck BOOLEAN,
    is_indoor BOOLEAN,
    bar_product_unit_price FLOAT,
    bar_product_stock INT,
    id_product INT,
    name VARCHAR(500),
    description TEXT,
    id_food INT,
    is_veggie_friendly BOOLEAN,
    is_gluten_free BOOLEAN,
    is_spicy BOOLEAN,
    id_beverage INT,
    is_alcoholic BOOLEAN,
    is_hot BOOLEAN,
    is_served_with_ice BOOLEAN
);

CREATE TABLE IF NOT EXISTS CommunityManagers_temp (
    id_community_manager INT,
    platform_name CHAR(255),
    account_name CHAR(255),
    festival_name CHAR(255),
    festival_edition YEAR
);

CREATE TABLE IF NOT EXISTS Festivals_temp (
    festival_name CHAR(255),
    festival_edition YEAR,
    start_time DATETIME,
    end_time DATETIME,
    city CHAR(255),
    description TEXT,
    id_stage INT,
    capacity INT,
    common_name CHAR(255)
);

CREATE TABLE IF NOT EXISTS Buy_temp (
    id_buy INT,
    id_festivalgoer INT,
    id_bar INT,
    id_product INT
);

CREATE TABLE IF NOT EXISTS FestivalgoerShows_temp (
    id_festivalgoer INT,
    id_show INT,
    sings CHAR(255)
);

CREATE TABLE IF NOT EXISTS Provides_temp (
    id_provides int,
    id_bar INT,
    id_product INT,
    id_provider INT,
    provider_name CHAR(255),
    provider_address CHAR(255),
    provider_phone CHAR(255),
    provider_email CHAR(255),
    provider_base_country CHAR(255),
    unit_price FLOAT,
    order_date DATE,
    delivery_date DATE,
    quantity INT
);

CREATE TABLE IF NOT EXISTS Shows_temp (
    id_show INT,
    start_datetime DATETIME,
    end_datetime DATETIME,
    band_name CHAR(255),
    band_country CHAR(255),
    festival_name CHAR(255),
    festival_edition YEAR,
    id_stage INT,
    ordinality INT,
    title CHAR(255),
    version CHAR(255),
    written_by CHAR(255),
    duration INT,
    release_date DATE,
    type_of_music CHAR(255),
    album CHAR(255)
);

CREATE TABLE IF NOT EXISTS SocialMediaAccounts_temp (
    platform_name CHAR(255),
    impact_index FLOAT,
    account_name VARCHAR(255),
    creation_date DATE,
    followers INT
);

CREATE TABLE IF NOT EXISTS FestivalStaff_temp (
    id_staff INT,
    hire_date DATE,
    contract_expiration_date DATE,
    years_experience INT,
    id_beerman INT,
    tank_capacity FLOAT,
    id_bartender INT,
    is_cocktail_master BOOLEAN,
    is_cooker BOOLEAN,
    id_bar INT,
    id_security INT,
    is_armed BOOLEAN,
    knows_martial_arts BOOLEAN,
    festival_name CHAR(255),
    festival_edition YEAR,
    id_stage INT,
    id_community_manager INT,
    is_freelance BOOLEAN
);

CREATE TABLE IF NOT EXISTS Tickets_temp (
    id_ticket INT,
    type CHAR(255),
    Barcode BIGINT,
    start_date DATETIME,
    end_date DATETIME,
    festival_name CHAR(255),
    festival_edition YEAR,
    id_festivalgoer INT,
    id_vendor INT,
    price FLOAT 
);

LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/festival_stage_v1.csv"
INTO TABLE Festivals_temp 
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES; 
INSERT INTO Festival SELECT distinct festival_name, festival_edition, start_time, end_time, city, description FROM Festivals_temp;
INSERT INTO Stage SELECT distinct id_stage, capacity, common_name, festival_name, festival_edition FROM Festivals_temp;

LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/person_v1.csv"
INTO TABLE Person 
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES; 

LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/festivalgoer_v1.csv"
INTO TABLE Festivalgoer
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES; 

LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/festivalgoer_friends_v1.csv"
INTO TABLE Friend
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES; 

LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/ticket_v1.csv"
INTO TABLE Tickets_temp 
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES; 
INSERT INTO Ticket SELECT distinct id_ticket, type, barcode, start_date, end_date FROM Tickets_temp;

LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/vendor_v1.csv"
INTO TABLE Vendor
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

INSERT INTO Buys SELECT DISTINCT id_ticket, id_festivalgoer, id_vendor, festival_name, festival_edition, price FROM Tickets_temp;

LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/staff_v1.csv"
INTO TABLE FestivalStaff_temp 
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES; 
INSERT INTO Staff (id_staff, hire_date, contract_expiration_date, years_of_experience) 
SELECT DISTINCT id_staff, hire_date, contract_expiration_date, years_experience FROM FestivalStaff_temp;

INSERT INTO Beerman SELECT DISTINCT id_beerman, tank_capacity FROM FestivalStaff_temp WHERE id_beerman IS NOT NULL;

LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/beerman_sells_v1.csv"
INTO TABLE Beerman_sells 
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES; 

LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/bar_products_v1.csv"
INTO TABLE Bars_temp 
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

INSERT INTO Bar SELECT DISTINCT id_bar, bar_name, is_foodtruck, is_indoor FROM Bars_temp;
INSERT INTO Product SELECT DISTINCT id_product, name, description FROM Bars_temp;
INSERT INTO Food SELECT DISTINCT id_food, is_veggie_friendly, is_gluten_free, is_spicy FROM Bars_temp WHERE id_food IS NOT NULL;
INSERT INTO Beverage SELECT DISTINCT id_beverage, is_alcoholic, is_hot, is_served_with_ice FROM Bars_temp WHERE id_beverage IS NOT NULL;

LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/provides_v1.csv"
INTO TABLE Provides_temp 
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES; 

INSERT INTO Provider SELECT DISTINCT id_provider, provider_name, provider_address, provider_phone, provider_email, provider_base_country FROM Provides_temp;

INSERT INTO Provides SELECT DISTINCT id_provides, id_product, id_bar, id_provider, order_date, unit_price, delivery_date, quantity FROM Provides_temp;

LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/festivalgoer_consumes_v1.csv"
INTO TABLE Consumption 
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES; 

INSERT INTO Bartender SELECT DISTINCT id_bartender, id_bar, is_cocktail_master, is_cooker FROM FestivalStaff_temp WHERE id_bartender IS NOT NULL;
INSERT INTO Security SELECT DISTINCT id_security, is_armed, knows_martial_arts, festival_name, festival_edition, id_stage FROM FestivalStaff_temp WHERE id_security IS NOT NULL;

 
LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/community_manager_account_festival_v1.csv"
INTO TABLE CommunityManagers_temp 
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES; 

LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/social_accounts_v1.csv"
INTO TABLE SocialMediaAccounts_temp 
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES; 

INSERT INTO CommunityManager SELECT DISTINCT id_community_manager, is_freelance FROM FestivalStaff_temp WHERE id_community_manager IS NOT NULL;  -- YA ESTA

INSERT INTO SocialMediaPlatform (id_community_manager, platform_name, impact_index)
SELECT DISTINCT cm.id_community_manager, sma.platform_name, sma.impact_index
FROM SocialMediaAccounts_temp AS sma
JOIN CommunityManagers_temp AS cm ON sma.platform_name = cm.platform_name;

INSERT INTO SocialMediaAccount (id_community_manager, platform_name, account_name, festival_name, festival_edition, creation_date, followers)
SELECT DISTINCT cm.id_community_manager, cm.platform_name, cm.account_name, cm.festival_name, cm.festival_edition, sma.creation_date, sma.followers
FROM SocialMediaAccounts_temp AS sma
JOIN CommunityManagers_temp AS cm ON sma.account_name = cm.account_name
AND sma.platform_name = cm.platform_name;

LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/band_v1.csv"
INTO TABLE Band 
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES; 

LOAD DATA INFILE '/ProgramData/MySQL/MySQL Server 8.0/Uploads/artist_v1.csv'
INTO TABLE Artist
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES; 

LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/show_song_v1.csv"
INTO TABLE Shows_temp 
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES; 

INSERT INTO Song SELECT DISTINCT title, version, written_by, duration, band_name, band_country, release_date, type_of_music, album FROM Shows_temp;

INSERT INTO Show_ SELECT DISTINCT id_show, band_name, band_country, start_datetime, end_datetime FROM Shows_temp;

INSERT INTO Performed SELECT DISTINCT title, version, written_by, id_show, band_name, band_country, id_stage, festival_name, festival_edition, ordinality FROM Shows_temp;

LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/band_collab_v1.csv"
INTO TABLE Collaborate 
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES; 

LOAD DATA INFILE "/ProgramData/MySQL/MySQL Server 8.0/Uploads/festivalgoer_show_v1.csv"
INTO TABLE Festivalgoer_show 
COLUMNS TERMINATED BY ';' 
OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;  