# 🎓 University Data Analytics & Management System
> An end-to-end pipeline integrating **SQL Engineering**, **Python EDA**, and **Orange3 Data Mining**.

[![SQL Server](https://img.shields.io/badge/Database-SQL_Server-CC2927?logo=microsoft-sql-server&logoColor=white)](https://www.microsoft.com/en-us/sql-server/)
[![Python](https://img.shields.io/badge/Analytics-Python-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![Pandas](https://img.shields.io/badge/Library-Pandas-150458?logo=pandas&logoColor=white)](https://pandas.pydata.org/)
[![Orange3](https://img.shields.io/badge/Data_Mining-Orange3-F7941D?logo=orange&logoColor=white)](https://orangedatamining.com/)

---

## 📖 Project Overview
This project provides a comprehensive solution for managing university academic records and extracting actionable intelligence. It bridges the gap between raw data storage and high-level performance analytics, focusing on **Student Success Rates** and **GPA Trends**.

---

## 🏗️ Technical Architecture

### 1. Database Engineering (SQL)
**File:** `SQLQuery1.sql`
* **Relational Schema:** Designed a robust architecture comprising `Departments`, `Programs`, `Students`, `Instructors`, and `Enrollments`.
* **Automation:** Developed modular **Stored Procedures** (e.g., `sp_AddInstructor`, `sp_AddDepartment`) to ensure referential integrity and simplify data entry.
* **ETL Process:** Optimized bulk data migration from CSV sources into SQL Server using `BULK INSERT` scripts.

### 2. Exploratory Data Analysis (Python)
**Files:** `EDA_Project.ipynb`, `EDA sheet 2.csv`
Deep-dive analysis using **Pandas**, **Seaborn**, and **Matplotlib** to understand the student lifecycle.
* **Data Sanitization:** Handled missing GPA values, filtered invalid age entries (<16), and standardized categorical formats.
* **Statistical Breakdown:**
    * **Average GPA:** 2.30 (Standard Normal Distribution).
    * **Success Rate:** 85.8% overall student success.
    * **Core Correlation:** Identified a **0.72 positive correlation** between GPA and Success Percentage.

### 3. Data Mining Workflow (Orange3)
**File:** `Project Data Mining.ows`
A visual programming pipeline used for advanced feature inspection and predictive preparation:
* **Imputation:** Strategic handling of null values to maintain dataset variance.
* **Feature Statistics:** Automated distribution analysis of "Academic Active Days."
* **Outlier Detection:** Visualized `TotalCreditsRequired` vs. `TotalGradePoints` to flag performance anomalies.

---

## 📊 Key Insights & Findings
| Metric | Finding |
| :--- | :--- |
| **Demographics** | Primary student concentration in the **18–22 age bracket**. |
| **Equity** | Statistical analysis shows **no significant GPA gap** between genders or degree levels (Bachelor vs. Master). |
| **Data Integrity** | Discovered "Zero GPA" outliers that require administrative verification. |
| **Retention** | **80% Active** status vs. only **4.7% Suspended** status. |

---

## 🛠️ Getting Started

### Prerequisites
* **Database:** SQL Server 2019+ or Azure SQL.
* **Python:** Version 3.8+ (Required: `pandas`, `seaborn`, `matplotlib`).
* **Software:** [Orange3 Data Mining](https://orangedatamining.com/download/) desktop application.

### Installation & Usage
1.  **Clone the Repository:**
    ```bash
    git clone [https://github.com/YourUsername/University-Data-Analytics.git](https://github.com/YourUsername/University-Data-Analytics.git)
    ```
2.  **Initialize Database:** Execute `SQLQuery1.sql` in SSMS to build the schema and procedures.
3.  **Run Analysis:** Open `EDA_Project.ipynb` in Jupyter Notebook or Google Colab.
4.  **Explore Mining:** Launch Orange3 and open `Project Data Mining.ows`.

---

## 📁 Repository Structure
```text
├── Data/
│   └── EDA sheet 2.csv         # Cleaned Dataset
├── SQL/
│   └── SQLQuery1.sql           # Database Scripts
├── Notebooks/
│   └── EDA_Project.ipynb       # Python Analysis
├── Workflows/
│   └── Project Data Mining.ows # Orange3 Workflow
└── README.md

