-- =============================================
-- Victim Demographics & Vulnerability Analysis
-- Business Question: Which groups need targeted outreach?
-- =============================================

SELECT
    v.Victim_Age_Group,
    v.Victim_Sex,
    c.Legal_Category,
    l.Borough_Name,
    COUNT(*)                                        AS Total_Victims,
    ROUND(AVG(f.Time_to_Report_Seconds) / 3600, 2) AS Avg_Hours_to_Report,
    SUM(f.Is_Completed_Flag)                        AS Completed_Crimes,
    ROUND(
        SUM(f.Is_Completed_Flag) * 100.0 / COUNT(*), 2
    )                                               AS Completion_Rate_Pct
FROM
    FACT_CRIME_COMPLAINT f
    JOIN DIM_VICTIM     v ON f.Victim_SK     = v.Victim_SK
    JOIN DIM_CRIME_TYPE c ON f.Crime_Type_SK = c.Crime_Type_SK
    JOIN DIM_LOCATION   l ON f.Location_SK   = l.Location_SK
WHERE
    v.Victim_Age_Group NOT IN ('UNKNOWN', '')
    AND v.Victim_Sex   NOT IN ('U', '')
GROUP BY
    v.Victim_Age_Group,
    v.Victim_Sex,
    c.Legal_Category,
    l.Borough_Name
ORDER BY
    Total_Victims DESC;
