CREATE DATABASE IF NOT EXISTS music_festival
DEFAULT CHARACTER SET 'utf8mb4'
DEFAULT COLLATE 'utf8mb4_general_ci';
USE music_festival;

DROP VIEW IF EXISTS Music_types;
CREATE VIEW Music_types AS
SELECT type_of_music, COUNT(DISTINCT name, country) AS count
FROM Band B
GROUP BY type_of_music
ORDER BY count ASC;
-- SELECT * FROM Music_types;

DROP VIEW IF EXISTS SongMT;
CREATE VIEW SongMT AS
SELECT DISTINCT type_of_music
FROM Song;
-- SELECT * FROM SongMT;


DROP PROCEDURE IF EXISTS CorrectMusicType;

DELIMITER //

CREATE PROCEDURE CorrectMusicType()
BEGIN

		UPDATE Band
		SET type_of_music =
			CASE
				WHEN Band.type_of_music NOT IN (SELECT SongMT.type_of_music FROM SongMT)
				THEN 
					(SELECT type_of_music FROM Music_Types LIMIT 1)
			
				ELSE
					type_of_music
            
			END; 
END //

CALL CorrectMusicType();
