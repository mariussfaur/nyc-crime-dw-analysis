-- =============================================
-- Reporting Delay Analysis by Crime Type & Premise
-- Business Question: Which crimes go unreported longest?
-- =============================================

SELECT
    c.Legal_Category,
    c.Offense_Description,
    p.Premise_Type_Desc,
    COUNT(*)                                        AS Total_Cases,
    ROUND(AVG(f.Time_to_Report_Seconds) / 3600, 2) AS Avg_Hours_to_Report,
    ROUND(MIN(f.Time_to_Report_Seconds) / 3600, 2) AS Min_Hours_to_Report,
    ROUND(MAX(f.Time_to_Report_Seconds) / 3600, 2) AS Max_Hours_to_Report,
    ROUND(
        PERCENTILE_CONT(0.5) WITHIN GROUP
        (ORDER BY f.Time_to_Report_Seconds) / 3600, 2
    )                                               AS Median_Hours_to_Report
FROM
    FACT_CRIME_COMPLAINT f
    JOIN DIM_CRIME_TYPE c ON f.Crime_Type_SK = c.Crime_Type_SK
    JOIN DIM_PREMISE    p ON f.Premise_SK    = p.Premise_SK
WHERE
    f.Time_to_Report_Seconds > 0
GROUP BY
    c.Legal_Category,
    c.Offense_Description,
    p.Premise_Type_Desc
HAVING
    COUNT(*) >= 10
ORDER BY
    Avg_Hours_to_Report DESC
LIMIT 20;
