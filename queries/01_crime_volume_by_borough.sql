-- =============================================
-- Crime Volume by Borough and Precinct
-- Business Question: Where are resources most needed?
-- =============================================

SELECT
    l.Borough_Name,
    l.Precinct_Code,
    d.Calendar_Year,
    d.Calendar_Month,
    SUM(f.Complaint_Count)       AS Total_Complaints,
    SUM(f.Is_Completed_Flag)     AS Completed_Crimes,
    COUNT(*) - SUM(f.Is_Completed_Flag) AS Attempted_Crimes,
    ROUND(
        SUM(f.Is_Completed_Flag) * 100.0 / SUM(f.Complaint_Count), 2
    )                            AS Completion_Rate_Pct
FROM
    FACT_CRIME_COMPLAINT f
    JOIN DIM_LOCATION l ON f.Location_SK = l.Location_SK
    JOIN DIM_DATE d      ON f.Incident_Date_SK = d.Date_SK
WHERE
    d.Calendar_Year = 2023
GROUP BY
    l.Borough_Name,
    l.Precinct_Code,
    d.Calendar_Year,
    d.Calendar_Month
ORDER BY
    Total_Complaints DESC;
