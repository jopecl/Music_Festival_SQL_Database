CREATE DATABASE IF NOT EXISTS music_festival
DEFAULT CHARACTER SET 'utf8mb4'
DEFAULT COLLATE 'utf8mb4_general_ci';
USE music_festival;

DROP PROCEDURE IF EXISTS FestivalReportExport_Dynamic;

DELIMITER //

CREATE PROCEDURE FestivalReportExport_Dynamic()
BEGIN

    -- Declare variables
	SET @FileName = CONCAT('EXPORT_FESTIVAL_REPORT_REQ8_', DATE_FORMAT(CURDATE(), '%Y%m%d'), '.csv');
	SET @main_query = CONCAT(
		'SELECT b.festival_name, b.festival_edition, COUNT(fg.id_festivalgoer) AS festivalgoer_count ',
		'INTO OUTFILE "', @FileName, '" ',
		'FIELDS TERMINATED BY \';\' OPTIONALLY ENCLOSED BY \'"\' LINES TERMINATED BY ''\n'' ',
		'FROM Festivalgoer fg ',
		'JOIN Buys b ON fg.id_festivalgoer = b.id_festivalgoer ',
		'JOIN Festival f ON b.festival_name = f.festival_name AND b.festival_edition = f.festival_edition ',
		'GROUP BY festival_name, festival_edition ',
		'ORDER BY festivalgoer_count DESC;'
	);

	-- Prepare and execute the query
	PREPARE req8 FROM @main_query; #takes the string we created and "converts" it into a sql statement, allowing to use variables as parameters
	EXECUTE req8; #executes the query that has been prepared (allows to provide values for some placeholders and execute the statement with those specific values)
	DEALLOCATE PREPARE req8; #important for resource management, basically erases the prepared statement
        
END //

DELIMITER ;

CALL FestivalReportExport_Dynamic();
-- SELECT @@datadir; -- to check data directory
