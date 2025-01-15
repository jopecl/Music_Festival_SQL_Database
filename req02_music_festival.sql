CREATE DATABASE IF NOT EXISTS music_festival
DEFAULT CHARACTER SET 'utf8mb4'
DEFAULT COLLATE 'utf8mb4_general_ci';
USE music_festival;
SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS UpdateYearsExperienceEvent;
DELIMITER //

CREATE EVENT UpdateYearsExperienceEvent
ON SCHEDULE 
	EVERY 1 MONTH
    STARTS TIMESTAMP(CURRENT_DATE(), '08:00:00')
DO
BEGIN
    CALL UpdateYearsExperience();
END //

DELIMITER ; 		