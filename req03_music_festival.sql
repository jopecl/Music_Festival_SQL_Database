CREATE DATABASE IF NOT EXISTS music_festival
DEFAULT CHARACTER SET 'utf8mb4'
DEFAULT COLLATE 'utf8mb4_general_ci';
USE music_festival;


DROP VIEW IF EXISTS Bar_capacity;
CREATE VIEW Bar_capacity AS
SELECT B.bar_id, COUNT(B.id_bartender) AS capacity
FROM Bartender B
GROUP BY B.bar_id
ORDER BY capacity ASC;


DROP VIEW IF EXISTS Security_capacity;
CREATE VIEW Security_capacity AS
SELECT S.id_stage, S.festival_name, S.festival_edition, COUNT(S.id_security) AS capacity
FROM Security S
WHERE S.id_stage IS NOT NULL
GROUP BY S.id_stage, S.festival_name, S.festival_edition
ORDER BY capacity ASC;

DROP TRIGGER IF EXISTS add_bartender;
DROP TRIGGER IF EXISTS add_security;

DELIMITER //
CREATE TRIGGER add_bartender BEFORE INSERT ON Bartender
	FOR EACH ROW
	IF (NEW.bar_id IS NULL) THEN
		SET NEW.bar_id = (SELECT bar_id FROM Bar_capacity LIMIT 1);
	END IF
    //
    
    
DELIMITER //
CREATE TRIGGER add_security BEFORE INSERT ON Security
	FOR EACH ROW
	IF (NEW.id_stage IS NULL OR NEW.festival_name IS NULL OR NEW.festival_edition IS NULL) THEN
		SET NEW.id_stage = (SELECT id_stage FROM Security_capacity LIMIT 1);
		SET NEW.festival_name = (SELECT festival_name FROM Security_capacity LIMIT 1);
		SET NEW.festival_edition = (SELECT festival_edition FROM Security_capacity LIMIT 1);
	END IF
    //  
    
    
