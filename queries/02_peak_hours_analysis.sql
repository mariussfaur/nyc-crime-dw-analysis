-- =============================================
-- Peak Hours & Seasonal Crime Analysis
-- Business Question: When should patrols be deployed?
-- =============================================

SELECT
    d.Hour_of_Day,
    d.Is_Peak_Season_Flag,
    c.Legal_Category,
    SUM(f.Complaint_Count)  AS Total_Complaints,
    ROUND(
        SUM(f.Complaint_Count) * 100.0 /
        SUM(SUM(f.Complaint_Count)) OVER (PARTITION BY d.Hour_of_Day), 2
    )                       AS Pct_of_Hour
FROM
    FACT_CRIME_COMPLAINT f
    JOIN DIM_DATE       d ON f.Incident_Date_SK = d.Date_SK
    JOIN DIM_CRIME_TYPE c ON f.Crime_Type_SK = c.Crime_Type_SK
GROUP BY
    d.Hour_of_Day,
    d.Is_Peak_Season_Flag,
    c.Legal_Category
ORDER BY
    Total_Complaints DESC;
