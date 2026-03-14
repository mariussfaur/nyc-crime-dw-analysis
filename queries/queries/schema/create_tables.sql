-- =============================================
-- NYC Crime Complaints — Data Warehouse Schema
-- Dimensional Model: Star Schema
-- =============================================

-- --------------------------------------------
-- DIM_DATE
-- Used twice: Incident Date & Report Date
-- --------------------------------------------
CREATE TABLE DIM_DATE (
    Date_SK             INT           PRIMARY KEY,
    Calendar_Date       DATE          NOT NULL,
    Calendar_Year       INT           NOT NULL,
    Calendar_Quarter    INT           NOT NULL CHECK (Calendar_Quarter BETWEEN 1 AND 4),
    Calendar_Month      INT           NOT NULL CHECK (Calendar_Month BETWEEN 1 AND 12),
    Hour_of_Day         INT                    CHECK (Hour_of_Day BETWEEN 0 AND 23),
    Is_Peak_Season_Flag SMALLINT      NOT NULL DEFAULT 0
                                      CHECK (Is_Peak_Season_Flag IN (0, 1))
);

-- --------------------------------------------
-- DIM_LOCATION
-- Geographic & administrative hierarchy
-- --------------------------------------------
CREATE TABLE DIM_LOCATION (
    Location_SK          INT           PRIMARY KEY,
    Borough_Name         VARCHAR(50),
    Patrol_Borough_Name  VARCHAR(50),
    Precinct_Code        INT,
    Latitude             FLOAT,
    Longitude            FLOAT
);

-- --------------------------------------------
-- DIM_CRIME_TYPE
-- Offense classification hierarchy
-- --------------------------------------------
CREATE TABLE DIM_CRIME_TYPE (
    Crime_Type_SK       INT           PRIMARY KEY,
    Legal_Category      VARCHAR(20),   -- Felony, Misdemeanor, Violation
    Offense_Description VARCHAR(100),
    Key_Code            INT,
    PD_Code             INT,
    PD_Description      VARCHAR(100)
);

-- --------------------------------------------
-- DIM_PREMISE
-- Physical setting of the crime
-- --------------------------------------------
CREATE TABLE DIM_PREMISE (
    Premise_SK              INT           PRIMARY KEY,
    Premise_Type_Desc       VARCHAR(100),
    Location_of_Occurrence  VARCHAR(50),  -- Inside, Outside, On Street
    Is_Public_Housing_Flag  SMALLINT      NOT NULL DEFAULT 0
                                          CHECK (Is_Public_Housing_Flag IN (0, 1)),
    Is_Park_Flag            SMALLINT      NOT NULL DEFAULT 0
                                          CHECK (Is_Park_Flag IN (0, 1))
);

-- --------------------------------------------
-- DIM_VICTIM
-- Victim demographic information
-- --------------------------------------------
CREATE TABLE DIM_VICTIM (
    Victim_SK        INT           PRIMARY KEY,
    Victim_Age_Group VARCHAR(20),  -- <18, 18-24, 25-44, 45-64, 65+
    Victim_Race      VARCHAR(50),
    Victim_Sex       CHAR(1)       CHECK (Victim_Sex IN ('M', 'F', 'U'))
);

-- --------------------------------------------
-- FACT_CRIME_COMPLAINT
-- Central fact table — one row per complaint
-- --------------------------------------------
CREATE TABLE FACT_CRIME_COMPLAINT (
    Complaint_SK            INT       PRIMARY KEY,
    Incident_Date_SK        INT       NOT NULL REFERENCES DIM_DATE(Date_SK),
    Report_Date_SK          INT       NOT NULL REFERENCES DIM_DATE(Date_SK),
    Location_SK             INT       NOT NULL REFERENCES DIM_LOCATION(Location_SK),
    Crime_Type_SK           INT       NOT NULL REFERENCES DIM_CRIME_TYPE(Crime_Type_SK),
    Premise_SK              INT       NOT NULL REFERENCES DIM_PREMISE(Premise_SK),
    Victim_SK               INT       NOT NULL REFERENCES DIM_VICTIM(Victim_SK),

    -- Measures
    Complaint_Count         INT       NOT NULL DEFAULT 1,
    Is_Completed_Flag       SMALLINT  NOT NULL DEFAULT 0
                                      CHECK (Is_Completed_Flag IN (0, 1)),
    Time_to_Report_Seconds  INT                CHECK (Time_to_Report_Seconds >= 0)
);

-- --------------------------------------------
-- Indexes for query performance
-- --------------------------------------------
CREATE INDEX idx_fact_incident_date  ON FACT_CRIME_COMPLAINT(Incident_Date_SK);
CREATE INDEX idx_fact_report_date    ON FACT_CRIME_COMPLAINT(Report_Date_SK);
CREATE INDEX idx_fact_location       ON FACT_CRIME_COMPLAINT(Location_SK);
CREATE INDEX idx_fact_crime_type     ON FACT_CRIME_COMPLAINT(Crime_Type_SK);
CREATE INDEX idx_fact_victim         ON FACT_CRIME_COMPLAINT(Victim_SK);
