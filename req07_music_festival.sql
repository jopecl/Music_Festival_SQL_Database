CREATE DATABASE IF NOT EXISTS music_festival
DEFAULT CHARACTER SET 'utf8mb4'
DEFAULT COLLATE 'utf8mb4_general_ci';
USE music_festival;
SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS update_prices_event;


DELIMITER //

CREATE EVENT update_prices_event
ON SCHEDULE
    EVERY 1 day
    STARTS '2023-11-15 08:00:00'
    ENDS '2024-01-31 23:59:59'
DO
BEGIN
    CALL UpdatePrice(0);
END //

DELIMITER ;