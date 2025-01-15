CREATE DATABASE IF NOT EXISTS music_festival
DEFAULT CHARACTER SET 'utf8mb4'
DEFAULT COLLATE 'utf8mb4_general_ci';
USE music_festival;

DROP PROCEDURE IF EXISTS UpdateYearsExperience;

DELIMITER //

CREATE PROCEDURE UpdateYearsExperience()
BEGIN

    -- Update years_experience for NULL or incorrect values
    UPDATE Staff
    SET years_of_experience = 
        CASE 
            WHEN years_of_experience IS NULL OR years_of_experience < 0  OR (YEAR(current_date()) - YEAR(hire_date)) != years_of_experience THEN 
                YEAR(current_date()) - YEAR(hire_date)
            ELSE
                years_of_experience
        END;

END //

DELIMITER ;

CALL UpdateYearsExperience();


/*
The field years_of_experience is not a very good database design as it can be easily calculated with a funtion,
or a view. This way we wouldn't need to store one INT for each row, which is avoidable.
*/