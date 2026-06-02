--Creating the table

CREATE TABLE patients (
    col1 TEXT,
    col2 TEXT,
    col3 TEXT,
    col4 TEXT,
    col5 TEXT,
    col6 TEXT,
	col7 TEXT,
	col8 TEXT,
	col9 TEXT,
    col10 TEXT,
    col11 TEXT,
    col12 TEXT,
    col13 TEXT,
    col14 TEXT
);

--Confirming proper importing

SELECT*FROM hospitals
LIMIT 10;

SELECT COUNT(*)FROM hospitals;

--Renaming the columns

ALTER TABLE hospitals RENAME COLUMN col1 TO name;
ALTER TABLE hospitals RENAME COLUMN col2 TO age;
ALTER TABLE hospitals RENAME COLUMN col3 TO gender;
ALTER TABLE hospitals RENAME COLUMN col4 TO blood_type;
ALTER TABLE hospitals RENAME COLUMN col5 TO medical_condition;
ALTER TABLE hospitals RENAME COLUMN col6 TO date_of_admission;
ALTER TABLE hospitals RENAME COLUMN col7 TO billing;
ALTER TABLE hospitals RENAME COLUMN col8 TO admission_type;
ALTER TABLE hospitals RENAME COLUMN col9 TO discharge_date;
ALTER TABLE hospitals RENAME COLUMN col10 TO medication;
ALTER TABLE hospitals RENAME COLUMN col11 TO test_results;
ALTER TABLE hospitals RENAME COLUMN col12 TO length_of_stay;
ALTER TABLE hospitals RENAME COLUMN col13 TO age_group;
ALTER TABLE hospitals RENAME COLUMN col14 TO month;

--Check for missing values

SELECT COUNT(*)
FROM hospitals
WHERE medical_condition IS NULL;

SELECT COUNT(*)
FROM hospitals
WHERE age IS NULL;

SELECT COUNT(*)
FROM hospitals
WHERE billing IS NULL;

SELECT COUNT(*)
FROM hospitals
WHERE admission_type IS NULL;

SELECT admission_type, COUNT(*)
FROM hospitals
GROUP BY admission_type;

--Actual ANALYSIS Starts here

--most common medical condition

SELECT medical_condition, COUNT(*) AS total
FROM hospitals
GROUP BY medical_condition
ORDER BY total DESC;

--most used medication
SELECT medication, COUNT(*) AS total
FROM hospitals
GROUP BY medication
ORDER BY total DESC;

--Average billing by condition
SELECT medical_condition, AVG(billing) AS avg_bill
FROM hospitals
GROUP BY medical_condition
ORDER BY avg_bill DESC;

--Patient volume by Admission Type
SELECT admission_type, COUNT(*)
FROM hospitals
GROUP BY admission_type;

--Monthly Admission Trend
SELECT 
    EXTRACT(MONTH FROM date_of_admission::date) AS admission_month,
    COUNT(*) AS total
FROM hospitals
GROUP BY EXTRACT(MONTH FROM date_of_admission::date)
ORDER BY admission_month;

--Checking billing values
SELECT *
FROM hospitals
WHERE (
    CASE 
        WHEN billing LIKE '(%)' THEN '-' || regexp_replace(billing, '[$,() ]', '', 'g')
        ELSE regexp_replace(billing, '[$, ]', '', 'g')
    END
)::numeric < 0;

--Age check
SELECT *
FROM hospitals
WHERE age::numeric < 0 OR age::numeric > 120;


--Final version

CREATE VIEW hospital_summary AS
SELECT
    medical_condition,
    admission_type,
    AVG(
        (CASE 
            WHEN billing LIKE '(%)' THEN '-' || regexp_replace(billing, '[$,() ]', '', 'g')
            ELSE regexp_replace(billing, '[$, ]', '', 'g')
        END)::numeric
    ) AS avg_bill,
    COUNT(*) AS total_patients
FROM hospitals
GROUP BY medical_condition, admission_type;



