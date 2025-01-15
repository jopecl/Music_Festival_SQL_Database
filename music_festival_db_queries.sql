CREATE DATABASE IF NOT EXISTS music_festival
DEFAULT CHARACTER SET 'utf8mb4'
DEFAULT COLLATE 'utf8mb4_general_ci';
USE music_festival;
SET PERSIST sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));



DROP VIEW IF EXISTS query_1;
CREATE VIEW query_1 AS
SELECT COUNT(owns_glass) / 2
FROM Festivalgoer
WHERE owns_glass = 0;

-- Total rows: 1 --

SELECT * FROM query_1;


DROP VIEW IF EXISTS query_2;
CREATE VIEW query_2 AS
SELECT nationality, COUNT(*) AS quant
FROM Person
JOIN Festivalgoer ON Person.id = Festivalgoer.id_festivalgoer
GROUP BY nationality
ORDER BY nationality ASC;

-- Total rows: 243 

SELECT * FROM query_2;

DROP VIEW IF EXISTS query_3;
CREATE VIEW query_3 AS
SELECT DISTINCT Person.name, Person.surname, Person.nationality, Person.birth_date, Festivalgoer.*
FROM Festivalgoer
JOIN Person ON Person.id = Festivalgoer.id_festivalgoer
JOIN Consumption ON Festivalgoer.id_festivalgoer = Consumption.id_festivalgoer
JOIN Product ON Consumption.id_product = Product.id_product
JOIN Food ON Product.id_product = Food.id_food
WHERE Festivalgoer.is_spicy_tolerant = 0 AND Food.is_spicy = 1 AND health_status = 'dizzy'
ORDER BY Festivalgoer.id_festivalgoer ASC;
-- Total rows: 8825
SELECT * FROM query_3;


DROP VIEW IF EXISTS query_4;
CREATE VIEW query_4 AS
SELECT DISTINCT P.* 
FROM Person P
JOIN Festivalgoer ON festivalgoer.id_festivalgoer = P.id
JOIN (
	SELECT query_4_2.id_festivalgoer 
	FROM (
        SELECT DISTINCT f.id_festivalgoer, p.festival_name, p.festival_edition
        FROM Festivalgoer_show f
        JOIN Performed p ON f.id_show = p.id_show
    ) query_4_2
	LEFT JOIN (
				SELECT f.*, b.id_ticket, b.festival_name, b.festival_edition
				FROM Festivalgoer f
				JOIN Buys b ON f.id_festivalgoer = b.id_festivalgoer
    ) query_4_1 ON query_4_1.id_festivalgoer = query_4_2.id_festivalgoer
	WHERE query_4_1.id_ticket IS NULL
) query_4_3 ON Festivalgoer.id_festivalgoer = query_4_3.id_festivalgoer;
SELECT * FROM query_4;
# Total rows Q4: 10423



DROP VIEW IF EXISTS query_5;
CREATE VIEW query_5 AS
SELECT Band.*
FROM Band
GROUP BY Band.name
HAVING COUNT(Band.name) > 1;
SELECT * FROM query_5;
-- Total rows: 34

DROP VIEW IF EXISTS query_6;
CREATE VIEW query_6 AS
SELECT DISTINCT S.*, P.*
FROM Person P
JOIN Festivalgoer ON P.id = Festivalgoer.id_festivalgoer
JOIN Festivalgoer_show ON Festivalgoer.id_festivalgoer = Festivalgoer_show.id_festivalgoer
JOIN Performed ON Festivalgoer_show.id_show = Performed.id_show
JOIN Stage S ON S.id_stage = Performed.id_stage AND S.festival_name = Performed.festival_name AND S.festival_edition = Performed.festival_edition
WHERE is_gluten_free = 0 AND is_alcohol_free = 0 AND health_status='wasted'
ORDER BY Festivalgoer.id_festivalgoer ASC, Performed.id_stage ASC;
-- Total rows: 248515
SELECT * FROM query_6;

DROP VIEW IF EXISTS query_7;
CREATE VIEW query_7 AS
SELECT P.*, SocialMediaAccount.platform_name, SocialMediaAccount.followers
FROM CommunityManager
JOIN Person P ON P.id = CommunityManager.id_community_manager
JOIN SocialMediaAccount ON CommunityManager.id_community_manager = SocialMediaAccount.id_community_manager
WHERE CommunityManager.is_freelance = 1 
    AND SocialMediaAccount.festival_name = 'Creamfields' 
    AND SocialMediaAccount.followers > 500000 
    AND SocialMediaAccount.followers < 700000
ORDER BY P.id ASC;

-- Total rows: 6

SELECT * FROM query_7;


DROP VIEW IF EXISTS query_8;
CREATE VIEW query_8 AS
SELECT P.*, (COUNT(Beerman_sells.id_beerman_sells) * 0.33) AS litres_sold
FROM Beerman_sells
JOIN Person P ON P.id = Beerman_sells.id_beerman
WHERE Beerman_sells.festival_name  LIKE 'Primavera Sound%' 
GROUP BY Beerman_sells.id_beerman
ORDER BY litres_sold DESC;
SELECT * FROM query_8;
-- Total rows: 2000 (number of beermen in the database)


DROP VIEW IF EXISTS query_9;
CREATE VIEW query_9 AS
SELECT DISTINCT P.*, S.capacity, S.common_name
FROM Performed P
JOIN Stage S ON S.id_stage = P.id_stage AND S.festival_name = P.festival_name AND S.festival_edition = P.festival_edition
WHERE P.band_name = 'Rosalia';
-- Total rows: 129
SELECT * FROM query_9;

DROP VIEW IF EXISTS query_9_Extra;
CREATE VIEW query_9_Extra AS
SELECT SUM(Song.duration) AS duartion
FROM Performed
JOIN Song ON Song.title = Performed.title AND Song.version = Performed.version AND Song.written_by = Performed.written_by AND Song.band_name = Performed.band_name AND Song.band_country = Performed.band_country 
WHERE Performed.band_name = 'Rosalia';
-- Total rows: 1
SELECT * FROM query_9_Extra;

DROP VIEW IF EXISTS query_10; 
CREATE VIEW query_10 AS
SELECT DISTINCT Provider.*
FROM Provider
-- Veggie product
JOIN Provides ON Provides.provider_id = Provider.id_provider
JOIN Product ON Product.id_product = Provides.product_id
JOIN Food ON Food.id_food = Product.id_product
-- From festival Tomorrowland
JOIN Consumption ON Consumption.id_product = Product.id_product
JOIN Festivalgoer ON Festivalgoer.id_festivalgoer = Consumption.id_festivalgoer
JOIN Buys ON Buys.id_festivalgoer = Festivalgoer.id_festivalgoer
WHERE Food.is_veggie_friendly = 1 AND Buys.festival_name = 'Tomorrowland'
GROUP BY Provider.id_provider
ORDER BY Provider.id_provider ASC;
SELECT * FROM query_10;

-- Total rows: 42

DROP VIEW IF EXISTS query_11;
CREATE VIEW query_11 AS
SELECT Show_.id, SUM(SONG.duration) AS Show_duration
FROM Show_
JOIN Performed ON Show_.id = Performed.id_show
JOIN Song ON Song.title = Performed.title AND Song.version = Performed.version AND Song.written_by = Performed.written_by AND Song.band_name = Performed.band_name AND Song.band_country = Performed.band_country 
GROUP BY Show_.id
ORDER BY Show_duration DESC;
-- Total rows: 1620
SELECT * FROM query_11;

DROP VIEW IF EXISTS query_12;
CREATE VIEW query_12 AS
SELECT Stage.capacity / COUNT(Buys.id_ticket) * 100 AS occupancy_percentage
FROM Stage
JOIN Buys ON Stage.festival_name = Buys.festival_name AND Stage.festival_edition = Buys.festival_edition
GROUP BY Stage.capacity;
 SELECT * FROM query_12;
-- Total rows: 185

DROP VIEW IF EXISTS query_13; 
CREATE VIEW query_13 AS
SELECT P.name, P.surname, F.id_festivalgoer, COUNT(DISTINCT PR.festival_edition) as attended_editions
FROM Person P
JOIN Festivalgoer F ON F.id_festivalgoer = P.id
LEFT JOIN Festivalgoer_show FS ON FS.id_festivalgoer = F.id_festivalgoer
LEFT JOIN Performed PR ON FS.id_show = PR.id_show
WHERE PR.festival_name = 'Primavera Sound'
GROUP BY P.name, P.surname, F.id_festivalgoer
HAVING attended_editions = 10
ORDER BY attended_editions DESC, P.surname, P.name;
SELECT * FROM query_13;
-- Total rows: 0


DROP VIEW IF EXISTS query_14;
CREATE VIEW query_14 AS
SELECT staff_type, unemployed_count
FROM (
	SELECT 'Beerman' AS staff_type, 
           (SELECT COUNT(Beerman.id_beerman)
            FROM Beerman
            LEFT JOIN Beerman_sells ON Beerman.id_beerman = Beerman_sells.id_beerman
            WHERE Beerman_sells.id_beerman IS NULL) AS unemployed_count
    UNION
    SELECT 'Bartender' AS staff_type, 
           (SELECT COUNT(Bartender.id_bartender)
            FROM Bartender
            WHERE id_bartender IS NULL) AS unemployed_count
    UNION
    SELECT 'Security' AS staff_type, 
           (SELECT COUNT(Security.id_security)
            FROM Security
            WHERE id_stage IS NULL AND festival_name IS NULL AND festival_edition IS NULL) AS unemployed_count
    UNION
    SELECT 'CommunityManager' AS staff_type, 
           (SELECT COUNT(CommunityManager.id_community_manager)
            FROM CommunityManager
            LEFT JOIN SocialMediaAccount ON SocialMediaAccount.id_community_manager = CommunityManager.id_community_manager
            WHERE SocialMediaAccount.platform_name IS NULL AND SocialMediaAccount.account_name IS NULL) AS unemployed_count
) AS subquery
ORDER BY unemployed_count DESC;

-- Total rows: 4

SELECT * FROM query_14;

DROP VIEW IF EXISTS query_15; 
CREATE VIEW query_15 AS
SELECT SUM(count) AS total_count
FROM (
    SELECT COUNT(DISTINCT Security.id_security) AS count
    FROM Security
    WHERE festival_name LIKE 'Primavera Sound%'
    UNION
    SELECT COUNT(DISTINCT Beerman.id_beerman) AS count
    FROM Beerman
    JOIN Beerman_sells ON Beerman.id_beerman = Beerman_sells.id_beerman
    WHERE festival_name LIKE 'Primavera Sound%'
    UNION 
    SELECT COUNT(DISTINCT CommunityManager.id_community_manager) AS count
    FROM CommunityManager
    JOIN SocialMediaAccount ON SocialMediaAccount.id_community_manager = CommunityManager.id_community_manager
    WHERE festival_name LIKE 'Primavera Sound%'
) AS subquery;

SELECT * FROM query_15;

-- Total rows: 1

DROP VIEW IF EXISTS query_16;
CREATE VIEW query_16 AS
SELECT 
    Festivalgoer.id_festivalgoer,
    ticket_spending.total_ticket_spending,
    beer_spending.total_beer_spending,
    product_spending.total_bar_spending
FROM Festivalgoer
LEFT JOIN (
    SELECT 
        Buys.id_festivalgoer, 
        SUM(Buys.price) AS total_ticket_spending
    FROM Buys
    WHERE Buys.id_festivalgoer = '27577'
    GROUP BY Buys.id_festivalgoer
) AS ticket_spending ON Festivalgoer.id_festivalgoer = '27577'
LEFT JOIN (
    SELECT 
        Beerman_sells.id_festivalgoer, 
        COUNT(Beerman_sells.id_beerman_sells) * 3 AS total_beer_spending
    FROM Beerman_sells
    WHERE Beerman_sells.id_festivalgoer = '27577'
    GROUP BY Beerman_sells.id_festivalgoer
) AS beer_spending ON Festivalgoer.id_festivalgoer = '27577'
LEFT JOIN (
    SELECT 
        Consumption.id_festivalgoer, 
        SUM(Provides.unit_price) AS total_bar_spending
    FROM Consumption
    JOIN Provides ON Consumption.id_product = Provides.product_id AND Consumption.id_bar = Provides.bar_id
    WHERE Consumption.id_festivalgoer = '27577'
    GROUP BY Consumption.id_festivalgoer
) AS product_spending ON Festivalgoer.id_festivalgoer = '27577'
WHERE Festivalgoer.id_festivalgoer = '27577';
SELECT * FROM query_16;
-- Total rows: 1



    


