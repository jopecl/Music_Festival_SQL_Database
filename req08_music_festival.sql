CREATE DATABASE IF NOT EXISTS music_festival
DEFAULT CHARACTER SET 'utf8mb4'
DEFAULT COLLATE 'utf8mb4_general_ci';
USE music_festival;

DROP PROCEDURE IF EXISTS FestivalReportExport;

DELIMITER //

CREATE PROCEDURE FestivalReportExport()
BEGIN

    SELECT b.festival_name, b.festival_edition, COUNT(fg.id_festivalgoer) AS festivalgoer_count
    INTO OUTFILE 'EXPORT_FESTIVAL_REPORT_REQ8.csv'
    FIELDS TERMINATED BY ';'
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    FROM Festivalgoer fg
		JOIN Buys b ON fg.id_festivalgoer = b.id_festivalgoer
		JOIN Festival f ON b.festival_name = f.festival_name AND b.festival_edition = f.festival_edition
    GROUP BY festival_name, festival_edition
    ORDER BY festivalgoer_count DESC;
        
END //

DELIMITER ;

CALL FestivalReportExport();
-- SELECT @@datadir; -- to check data directory
