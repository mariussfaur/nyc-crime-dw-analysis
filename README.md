# NYC Crime Complaints — Data Warehouse Design & Analysis

## Project Overview

This project designs a **Data Warehouse** to support analytical reporting on criminal complaint data from the New York City Police Department (NYPD). The goal is to enable data-driven decision-making around public safety, resource allocation, and community engagement.

---

## Business Questions Answered

- Which boroughs and precincts have the highest volume of crime complaints?
- How does crime volume vary by season, month, and time of day?
- What is the average time between a crime occurring and being reported?
- Which crime types have the longest reporting delays?
- How do victim demographics relate to crime type and reporting behavior?

---

## Data Source

- **Dataset:** NYPD Complaint Data Historic
- **Source:** [NYC Open Data](https://data.cityofnewyork.us/)
- **Scope:** Criminal complaints filed with the NYPD

---

## Data Warehouse Architecture

### Dimensional Model: Star Schema

The model is built around a central fact table — `FACT_CRIME_COMPLAINT` — surrounded by 5 dimension tables.

```
FACT_CRIME_COMPLAINT
├── DIM_DATE (x2 — Incident Date & Report Date)
├── DIM_LOCATION
├── DIM_CRIME_TYPE
├── DIM_PREMISE
└── DIM_VICTIM
```

### Fact Table — Key Measures

| Measure | Description |
|---|---|
| `Complaint_Count` | Total complaints filed (additive) |
| `Is_Completed_Flag` | 1 = completed crime, 0 = attempted |
| `Time_to_Report_Seconds` | Time lag between incident and report date |

### Dimension Tables

| Dimension | Key Attributes |
|---|---|
| `DIM_DATE` | Year, Quarter, Month, Hour, Peak Season Flag |
| `DIM_LOCATION` | Borough, Patrol Borough, Precinct, Lat/Long |
| `DIM_CRIME_TYPE` | Legal Category, Offense Description, PD Code |
| `DIM_PREMISE` | Premise Type, Location of Occurrence, Public Housing Flag |
| `DIM_VICTIM` | Age Group, Race, Sex |

---

## Analytical Hierarchies

| Hierarchy | Levels |
|---|---|
| Time | Year → Quarter → Month → Hour of Day |
| Geography | Patrol Borough → Borough → Precinct |
| Crime Classification | Legal Category → Key Code → Offense Description |
| Victim Demographics | Sex → Age Group |
| Premise Context | Location Type → Premise Type → Public Housing Flag |

---

## Tools & Skills

![SQL](https://img.shields.io/badge/SQL-Data%20Modeling-blue?style=flat)
![Data Warehouse](https://img.shields.io/badge/Data%20Warehouse-Star%20Schema-teal?style=flat)
![dbdiagram.io](https://img.shields.io/badge/dbdiagram.io-Schema%20Design-purple?style=flat)
![Excel](https://img.shields.io/badge/Excel-Data%20Exploration-green?style=flat)

---

## Key Insights

- **Radiology Bottleneck equivalent in data:** `Time_to_Report_Seconds` reveals significant delays in high-density precincts, suggesting resource strain affects public trust and reporting behavior.
- **Peak Season Flag** enables analysts to anticipate surges and pre-deploy resources.
- **Victim demographics** (Age Group, Race, Sex) allow equity-focused analysis to identify underserved communities.
- **Star Schema rationale:** fewer joins = faster queries, easier for business users to navigate.

---

## Repository Structure

```
📁 nyc-crime-dw-analysis
├── 📄 README.md
├── 📁 schema/
│   ├── star_schema_diagram.png
│   └── create_tables.sql
├── 📁 queries/
│   ├── 01_crime_volume_by_borough.sql
│   ├── 02_peak_hours_analysis.sql
│   ├── 03_reporting_delay_by_crime_type.sql
│   └── 04_victim_demographics.sql
└── 📄 insights.md
```

---

## Academic Context

This project was developed as part of the **MSc in Information Management (Digital Transformation)** at NOVA IMS, Lisbon.

**Team:** Marius Faur · Peter Osagie · Tayyaba Aftab
