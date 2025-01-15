# MusicFest Database Project Repository

This repository contains all the necessary files and scripts for the MusicFest database project, which involves SQL development to manage music festival data.

You can find an export of the final database in the following [Google Drive Link](https://drive.google.com/file/d/172WD36xIhwnBl9MzHzDT_UPorV802d7G/view?usp=sharing).
You can access all the festival raw csv data in the following [Google Drive Link](https://drive.google.com/file/d/1x3v2y8N32uP7UcbM4tjAvyhzqa9y4_q4/view?usp=sharing).

## Repository Contents

### 1. Database Model
- **File:** `music_festival_db_models.pdf`
- **Description:** A PDF document containing the conceptual and V1 relational model of the MusicFest database.
- **File:** `music_festival_db_new_models.pdf`
- **Description:** A PDF document outlining proposed improvements to the V1 relational model of the MusicFest database. It includes justifications for each change and visual representations of the latest version of the database schema.
- **File:** `music_sql_improvements.sql`
- **Description:** An SQL script that implements the proposed changes to the V1 database schema, including structural modifications.

### 2. PL/SQL Requirements
- **Files:** `req01_music_festival.sql`, `req02_music_festival.sql`, ..., `reqNN_music_festival.sql`
- **Description:** A set of SQL scripts, each addressing a specific requirement for the database. These scripts include:
  - Procedures for data maintenance and calculations.
  - Triggers to automate data integrity checks.
  - Events to schedule periodic database operations.

### 3. SQL Queries
- **File:** `music_festival_db_queries.sql`
- **Description:** This file contains a series of SQL queries developed to extract specific data from the MusicFest database. Each query includes the necessary filters, joins, and calculations, along with comments indicating the expected row count.

## Usage Instructions

1. **Setting Up the Database:**
   - Import the initial database schema and data as required by your setup.
   - Execute `music_sql_improvements.sql` to apply the structural changes to the database.
  
2. **PL/SQL Script Execution:**
   - Execute each PL/SQL script (`reqNN_music_festival.sql`) to implement the respective functionalities like triggers, procedures, or events.

3. **Running Queries:**
   - Load `music_festival_db_queries.sql` into your SQL environment and execute each query to retrieve the specified information.

This project is part of the Databases course (24303) for the academic year 2023-2024. Special thanks to the course instructors for their guidance and support.

