DROP SCHEMA IF EXISTS music_festival;
CREATE DATABASE IF NOT EXISTS music_festival
DEFAULT CHARACTER SET 'utf8mb4'
DEFAULT COLLATE 'utf8mb4_general_ci';
USE music_festival;

CREATE TABLE IF NOT EXISTS Festival (
    festival_name CHAR(255),
    festival_edition YEAR,
    start_time DATETIME,
    end_time DATETIME,
    city CHAR(255),
    description TEXT,
    CONSTRAINT PK_Festival PRIMARY KEY (festival_name, festival_edition)
);

CREATE TABLE IF NOT EXISTS Stage (
    id_stage INT,
    capacity INT,
    common_name CHAR(255),
    festival_name CHAR(255),
    festival_edition YEAR,
    CONSTRAINT PK_Stage PRIMARY KEY (id_stage, festival_name, festival_edition),
    CONSTRAINT FK_Festival_Stage FOREIGN KEY (festival_name, festival_edition) REFERENCES Festival(festival_name, festival_edition)
);

CREATE TABLE IF NOT EXISTS Person (
    id INT,
    name CHAR(255),
    surname CHAR(255),
    nationality CHAR(255),
    birth_date DATE,
    CONSTRAINT PK_Person PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Festivalgoer (
    id_festivalgoer INT,
    is_vegetarian BOOL,
    is_gluten_free BOOL,
    is_spicy_tolerant BOOL,
    is_alcohol_free BOOL,
    health_status CHAR(255),
    owns_glass BOOL,
    CONSTRAINT PK_Festivalgoer PRIMARY KEY (id_festivalgoer),
    CONSTRAINT FK_Person_Festivalgoer FOREIGN KEY (id_festivalgoer) REFERENCES Person(id)
);

CREATE TABLE IF NOT EXISTS Friend (
    id_festivalgoer INT,
    id_festivalgoer_friend INT,
    festival_name CHAR(255),
    festival_edition YEAR,
    CONSTRAINT PK_Friend PRIMARY KEY (id_festivalgoer, id_festivalgoer_friend, festival_name, festival_edition),
    CONSTRAINT FK_Festivalgoer_Friend FOREIGN KEY (id_festivalgoer) REFERENCES Festivalgoer(id_festivalgoer),
    CONSTRAINT FK_Festivalgoerfriend_Friend FOREIGN KEY (id_festivalgoer_friend) REFERENCES Festivalgoer(id_festivalgoer),
    CONSTRAINT FK_Festival_Friend FOREIGN KEY (festival_name, festival_edition) REFERENCES Festival(festival_name, festival_edition)
);

CREATE TABLE IF NOT EXISTS Ticket (
    id INT,
    type CHAR(255),
    barcode BIGINT,
    start_time DATETIME,
    end_time DATETIME,
    CONSTRAINT PK_Ticket PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Vendor (
    id INT,
    name CHAR(255),
    type CHAR(255),
    CONSTRAINT PK_Vendor PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS Buys (
    id_ticket INT,
    id_festivalgoer INT,
    id_vendor INT,
    festival_name CHAR(255),
    festival_edition YEAR,
    price INT,
    CONSTRAINT PK_Buys PRIMARY KEY (id_ticket, id_vendor, id_festivalgoer, festival_name, festival_edition),
    CONSTRAINT FK_Ticket_Buys FOREIGN KEY (id_ticket) REFERENCES Ticket(id),
    CONSTRAINT FK_Vendor_Buys FOREIGN KEY (id_vendor) REFERENCES Vendor(id),
    CONSTRAINT FK_Festivalgoer_Buys FOREIGN KEY (id_festivalgoer) REFERENCES Festivalgoer(id_festivalgoer),
    CONSTRAINT FK_Festival_Buys FOREIGN KEY (festival_name, festival_edition) REFERENCES Festival(festival_name, festival_edition)
);

CREATE TABLE IF NOT EXISTS Staff (
    id_staff INT,
    hire_date DATE,
    contract_expiration_date DATE,
    years_of_experience INT,
    CONSTRAINT PK_Staff PRIMARY KEY (id_staff),
    CONSTRAINT FK_Person_Staff FOREIGN KEY (id_staff) REFERENCES Person(id)
);

CREATE TABLE IF NOT EXISTS Beerman (
    id_beerman INT,
    tank_capacity INT,
    CONSTRAINT PK_Beerman PRIMARY KEY (id_beerman)
);

CREATE TABLE IF NOT EXISTS Beerman_sells (
    id_beerman_sells INT,
    id_beerman INT,
    id_festivalgoer INT,
    festival_name CHAR(255),
    festival_edition YEAR,
    id_stage INT,
    CONSTRAINT PK_Beerman_sells PRIMARY KEY (id_beerman_sells),
    CONSTRAINT FK_Festivalgoer_Beerman_sells FOREIGN KEY (id_festivalgoer) REFERENCES Festivalgoer(id_festivalgoer),
    CONSTRAINT FK_Festival_Beerman_sells FOREIGN KEY (festival_name, festival_edition) REFERENCES Festival(festival_name, festival_edition),
    CONSTRAINT FK_Stage_Beerman_sells FOREIGN KEY (id_stage) REFERENCES Stage(id_stage),
    CONSTRAINT FK_Beerman_Beerman_sells FOREIGN KEY (id_beerman) REFERENCES Beerman(id_beerman)
);

CREATE TABLE IF NOT EXISTS Bar (
    id_bar INT,
    bar_name VARCHAR(255),
    is_foodtruck BOOL,
    is_indoor BOOL,
    CONSTRAINT PK_Bar PRIMARY KEY (id_bar)
);

CREATE TABLE IF NOT EXISTS Product (
    id_product INT,
    name CHAR(255),
    description TEXT,
    CONSTRAINT PK_Product PRIMARY KEY (id_product)
);

CREATE TABLE IF NOT EXISTS Food (
    id_food INT,
    is_veggie_friendly BOOL,
    is_gluten_free BOOL,
    is_spicy BOOL,
    CONSTRAINT PK_Food PRIMARY KEY (id_food),
    CONSTRAINT FK_Product_Food FOREIGN KEY (id_food) REFERENCES Product(id_product)
);

CREATE TABLE IF NOT EXISTS Beverage (
    id_beverage INT,
    is_alcoholic BOOL,
    is_hot BOOL,
    is_served_with_ice BOOL,
    CONSTRAINT PK_Beverage PRIMARY KEY (id_beverage),
    CONSTRAINT FK_Product_Beverage FOREIGN KEY (id_beverage) REFERENCES Product(id_product)
);

CREATE TABLE IF NOT EXISTS Provider (
    id_provider INT,
    name CHAR(255),
    address CHAR(255),
    phone BIGINT,
    email CHAR(255),
    base_country CHAR(255),
    CONSTRAINT PK_Provider PRIMARY KEY (id_provider)
);

CREATE TABLE IF NOT EXISTS Provides (
    id_provides INT,
    product_id INT,
    bar_id INT,
    provider_id INT,
    order_date DATE,
    unit_price INT,
    delivery_date DATE,
    quantity INT,
    CONSTRAINT PK_Provides PRIMARY KEY (id_provides),
    CONSTRAINT FK_Product_Provides FOREIGN KEY (product_id) REFERENCES Product(id_product),
    CONSTRAINT FK_Bar_Provides FOREIGN KEY (bar_id) REFERENCES Bar(id_bar),
    CONSTRAINT FK_Provider_Provides FOREIGN KEY (provider_id) REFERENCES Provider(id_provider)
);
CREATE TABLE IF NOT EXISTS Consumption (
    id_buy INT,
    id_festivalgoer INT,
    id_bar INT,
    id_product INT,
    CONSTRAINT PK_Consumption PRIMARY KEY (id_buy),
    CONSTRAINT FK_Festivalgoer_Consumption FOREIGN KEY (id_festivalgoer) REFERENCES Festivalgoer(id_festivalgoer),
    CONSTRAINT FK_Bar_Consumption FOREIGN KEY (id_bar) REFERENCES Bar(id_bar),
	CONSTRAINT FK_Product_Consumption FOREIGN KEY (id_product) REFERENCES Product(id_product)

);

CREATE TABLE IF NOT EXISTS Bartender (
    id_bartender INT,
    bar_id INT,
    is_cocktail_master BOOL,
    is_cooker BOOL,
    CONSTRAINT PK_Bartender PRIMARY KEY (id_bartender),
    CONSTRAINT FK_Staff_Bartender FOREIGN KEY (id_bartender) REFERENCES Staff(id_staff),
    CONSTRAINT FK_Bar_Bartender FOREIGN KEY (bar_id) REFERENCES Bar(id_bar)
);

CREATE TABLE IF NOT EXISTS Security (
    id_security INT,
    is_armed BOOL,
    knows_martial_arts BOOL,
    festival_name CHAR(255),
    festival_edition YEAR,
    id_stage INT,
    CONSTRAINT PK_Security PRIMARY KEY (id_security),
	CONSTRAINT FK_Festival_Security FOREIGN KEY (festival_name, festival_edition, id_stage) REFERENCES Stage(festival_name, festival_edition, id_stage),
    CONSTRAINT FK_Staff_Security FOREIGN KEY (id_security) REFERENCES Staff(id_staff)
);

CREATE TABLE IF NOT EXISTS CommunityManager (
    id_community_manager INT,
    is_freelance BOOL,
    CONSTRAINT PK_CommunityManager PRIMARY KEY (id_community_manager),
    CONSTRAINT FK_Staff_CommunityManager FOREIGN KEY (id_community_manager) REFERENCES Staff(id_staff)
);

CREATE TABLE IF NOT EXISTS SocialMediaPlatform (
	id_community_manager INT,
    platform_name CHAR(255),
    impact_index INT,
    CONSTRAINT PK_SocialMediaPlatform PRIMARY KEY (platform_name, id_community_manager),
    CONSTRAINT FK_CommunityManager_SocialMediaPlatform FOREIGN KEY (id_community_manager) REFERENCES CommunityManager(id_community_manager)
);

CREATE TABLE IF NOT EXISTS SocialMediaAccount (
	id_community_manager INT,
    platform_name CHAR(255),
    account_name CHAR(255),
    festival_name CHAR(255),
    festival_edition YEAR,
    creation_date DATE, 
    followers INT, 
    CONSTRAINT PK_SocialMediaAccount PRIMARY KEY (account_name, platform_name),
    CONSTRAINT FK_Socialmediaplatform_SocialMediaAccount FOREIGN KEY (platform_name) REFERENCES SocialMediaPlatform(platform_name),
    CONSTRAINT FK_Festival_SocialMediaAccount FOREIGN KEY (festival_name, festival_edition) REFERENCES Festival(festival_name, festival_edition),
    CONSTRAINT FK_CommunityManager_SocialMediaAccount FOREIGN KEY (id_community_manager) REFERENCES CommunityManager(id_community_manager)
);

CREATE TABLE IF NOT EXISTS Band (
	name CHAR(255),
	country CHAR(255),
	type_of_music CHAR(255),
	bio TEXT,
	is_solo_artist BOOL,
	CONSTRAINT PK_band PRIMARY KEY (name, country)
);

CREATE TABLE IF NOT EXISTS Artist(
	id_artist INT,
	bio TEXT,
	prefered_instrument CHAR(255),
	band_name CHAR(255),
	band_country CHAR(255),
	PRIMARY KEY (id_artist),
    CONSTRAINT FK_Person_Artist FOREIGN KEY (id_artist) REFERENCES Person(id),
	CONSTRAINT FK_Band_Artist FOREIGN KEY (band_name, band_country) REFERENCES Band(name, country)
);

CREATE TABLE IF NOT EXISTS Song (
	title CHAR(155),
	version INT,
	written_by CHAR(155),
	duration INT,
	band_name CHAR(155),
	band_country CHAR(100),
	release_date DATE,
	type_of_music CHAR(255),
	album_name CHAR(255),
	CONSTRAINT PK_Song PRIMARY KEY (title, version, written_by, band_name, band_country),
	CONSTRAINT FK_Band_Song FOREIGN KEY (band_name, band_country) REFERENCES Band(name, country)
);

CREATE TABLE IF NOT EXISTS Show_ (
	id INT,
	band_name CHAR(155),
	band_country CHAR(100),
	start_time DATETIME,
	end_time DATETIME,
	CONSTRAINT PK_Show PRIMARY KEY (id),
	CONSTRAINT FK_Band_Show FOREIGN KEY (band_name, band_country) REFERENCES Band(name, country)
);

CREATE TABLE IF NOT EXISTS Performed (
	title CHAR(155),
	version INT,
	written_by CHAR(155),
    id_show INT,
	band_name CHAR(155),
	band_country CHAR(100),
	id_stage INT,
    festival_name CHAR(155),
    festival_edition YEAR,
	ordinality INT,
	CONSTRAINT PK_Performed PRIMARY KEY (title, version, written_by, id_show, band_name, band_country, id_stage, festival_name, festival_edition),
	CONSTRAINT FK_Show_Performed FOREIGN KEY (id_show) REFERENCES Show_(id),
	CONSTRAINT FK_Stage_Performed FOREIGN KEY (id_stage, festival_name, festival_edition) REFERENCES Stage(id_stage, festival_name, festival_edition),
	CONSTRAINT FK_Band_Performed FOREIGN KEY (band_name, band_country) REFERENCES Band(name, country)
);

CREATE TABLE IF NOT EXISTS Collaborate (
	band_name CHAR(100),
	band_country CHAR(100),
	collaborator_name CHAR(100),
	collaborator_country CHAR(100),
	CONSTRAINT PK_Collaborate PRIMARY KEY (band_name, band_country, collaborator_country , collaborator_name),
	CONSTRAINT FK_Band_Collaborate FOREIGN KEY (band_name, band_country) REFERENCES Band(name, country),
	CONSTRAINT FK_Band_Collaborators FOREIGN KEY (collaborator_name, collaborator_country) REFERENCES Band(name, country)
);
CREATE TABLE IF NOT EXISTS Festivalgoer_show (
	id_festivalgoer INT,
	id_show INT,
	sings BOOL,
	CONSTRAINT PK_Festivalgoer_Show PRIMARY KEY (id_show,id_festivalgoer),
	CONSTRAINT FK_Show_Festivalgoer_Show FOREIGN KEY (id_show) REFERENCES Show_(id),
	CONSTRAINT FK_Festivalgoer_Festivalgoer_Show FOREIGN KEY (id_festivalgoer) REFERENCES Festivalgoer(id_festivalgoer)
);

