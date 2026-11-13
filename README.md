# Digital Banking & Financial Intelligence Analytics

![SQL](https://img.shields.io/badge/SQL-MySQL-blue)
![Project](https://img.shields.io/badge/Project-Data%20Analytics-orange)
![Status](https://img.shields.io/badge/Status-Completed-success)

## 📌 Project Overview

**Digital Banking & Financial Intelligence Analytics** is a SQL-only Data Analyst portfolio project built from scratch using MySQL.

The project simulates a digital banking environment and analyzes:

- Customer behavior
- Account balances
- Transaction activity
- Loan exposure and repayment behavior
- Credit card utilization
- Customer support performance

The objective is to convert relational banking data into actionable business insights using practical SQL.

---

## 🎯 Business Objective

The bank wants to understand:

1. Who are its highest-value customers?
2. Which customer segments generate the most transaction value?
3. Which branches and channels perform best?
4. Which customers have high loan exposure?
5. Which borrowers show late or missed payment behavior?
6. Which credit cards have high utilization?
7. What support issues are most common?
8. Which customers perform above their segment average?
9. How is transaction activity changing over time?
10. How can customer-level metrics be combined without double-counting?

---

## 🗂️ Database Schema

The database contains 8 related tables:

| Table | Purpose |
|---|---|
| `customers` | Customer master data |
| `branches` | Bank branch information |
| `accounts` | Customer bank accounts |
| `transactions` | Account-level transaction history |
| `loans` | Customer loan information |
| `loan_payments` | Loan repayment history |
| `credit_cards` | Credit card and utilization data |
| `support_tickets` | Customer support interactions |

### Relationships

```text
customers
   ├── accounts
   │      └── transactions
   ├── loans
   │      └── loan_payments
   ├── credit_cards
   └── support_tickets

branches
   └── accounts
```

---

## 📊 Dataset Size

| Table | Rows |
|---|---:|
| Customers | 15 |
| Branches | 8 |
| Accounts | 15 |
| Transactions | 50 |
| Loans | 10 |
| Loan Payments | 26 |
| Credit Cards | 11 |
| Support Tickets | 15 |

The dataset is self-created and intentionally small enough to understand while still representing multiple business areas.

---

## 🛠️ Tech Stack

- **MySQL 8+**
- SQL
- MySQL Workbench
- GitHub

No external dataset or BI tool is required.

---

## 🧠 SQL Concepts Covered

### Basic SQL
- `SELECT`
- `WHERE`
- Comparison operators
- `IN`
- `BETWEEN`
- `LIKE`
- `ORDER BY`
- `LIMIT`
- `DISTINCT`

### Aggregation
- `COUNT`
- `SUM`
- `AVG`
- `MIN`
- `MAX`
- `GROUP BY`
- `HAVING`
- `ROUND`

### Functions
- `CONCAT`
- `COALESCE`
- `DATE_FORMAT`
- `DATEDIFF`
- `CASE`

### Joins
- `INNER JOIN`
- `LEFT JOIN`
- Multiple-table joins

### Advanced SQL
- Subqueries
- Correlated subqueries
- CTEs
- `ROW_NUMBER()`
- `RANK()`
- `DENSE_RANK()`
- `PARTITION BY`
- `LAG()`
- `LEAD()`
- Running totals
- Percentage contribution

### Performance & Transactions
- `CREATE INDEX`
- `SHOW INDEX`
- `EXPLAIN`
- `START TRANSACTION`
- `COMMIT`
- `ROLLBACK`

---

## 🧩 Project Phases

### Phase 1 — Planning & Database Design
Defined business objective, entities and relationships.

### Phase 2 — Database & Tables
Created the MySQL database with primary keys, foreign keys, constraints and default values.

### Phase 3 — Data Loading
Inserted realistic banking data into all 8 tables.

### Phase 4 — Data Verification
Verified row counts, foreign-key integrity and valid business-state NULLs.

### Phase 5 — Basic Analysis
Performed customer, account, transaction, loan, card and support analysis.

### Phase 6 — Joins & Intermediate Analysis
Built multi-table business analysis using joins, grouping, `CASE`, `COALESCE` and `HAVING`.

### Phase 7 — Subqueries & CTEs
Compared customers with overall and segment-level benchmarks and created customer-level summary datasets.

### Phase 8 — Window Functions
Used ranking, running totals, month-over-month analysis, `LAG`, `LEAD` and segment-level rankings.

### Phase 9 — Performance & Transactions
Introduced indexes, `EXPLAIN` and transaction-control concepts.

---

## ⭐ Key Technical Learning

### Avoiding Row Multiplication

A major analytical issue occurs when several one-to-many tables are joined together.

For example:

```text
1 customer
   ↓
3 transactions
   ↓
2 loans
```

A direct join can produce:

```text
3 × 2 = 6 rows
```

and cause incorrect `SUM()` results.

This project solves the problem by first aggregating each child table at the customer level using CTEs and then joining the summaries.

That approach is much safer for Customer 360 reporting.

---

## 📁 Repository Structure

```text
digital-banking-financial-intelligence/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── sql/
│   ├── 01_schema.sql
│   ├── 02_data.sql
│   ├── 03_verification.sql
│   ├── 04_analysis.sql
│   └── 05_performance_transactions.sql
│
└── insights/
    └── business_insights.md
```

---

## ▶️ How to Run

### Step 1 — Open MySQL Workbench

Open MySQL Workbench and connect to your MySQL server.

### Step 2 — Create the database and tables

Run:

```text
sql/01_schema.sql
```

### Step 3 — Load the data

Run:

```text
sql/02_data.sql
```

### Step 4 — Verify the data

Run:

```text
sql/03_verification.sql
```

Expected foreign-key integrity checks should return `0`.

### Step 5 — Run analysis

Run:

```text
sql/04_analysis.sql
```

This contains the complete analysis from basic SQL through window functions.

### Step 6 — Explore performance and transactions

Run:

```text
sql/05_performance_transactions.sql
```

Use the `EXPLAIN` output to understand query execution plans.

---

## 💡 Example Business Questions Answered

### Customer Analytics
- Who are the top 5 customers by transaction value?
- Which customers are above their segment average?
- Which customers have high transaction activity?

### Transaction Analytics
- Which channel generates the most transaction value?
- What is the monthly transaction trend?
- What is month-over-month transaction growth?
- What percentage of total transaction value comes from each customer?

### Loan Analytics
- Which customers have the highest loan exposure?
- Which loans have late or missed payments?
- What is the ranking of loans by amount?

### Credit Analytics
- Which cards have high utilization?
- Which customers are using more than 50% of their credit limit?

### Support Analytics
- Which issues generate the most tickets?
- Which issues take the longest to resolve?
- What is the average satisfaction score?

---

## 📌 Important Data Note

`NULL` values in `support_tickets` are intentional business-state values.

For example, an `Open` or `In Progress` ticket may not have:

- `resolution_date`
- `satisfaction_score`

These are not treated as bad data because the missing values have a valid business meaning.

---

## 🚀 Future Improvements

Possible extensions:

- Add more years of transaction history
- Add merchant-level data
- Add fraud detection analysis
- Add customer churn analysis
- Connect SQL output to Power BI/Tableau
- Add automated reporting
- Expand the dataset to thousands of records

---

## 👨‍💻 Skills Demonstrated

**SQL Data Analysis | Relational Database Design | MySQL | Data Validation | Business Analysis | Joins | CTEs | Subqueries | Window Functions | Query Optimization | Financial Analytics**

---

## 📄 Resume Project Description

> **Digital Banking & Financial Intelligence Analytics — MySQL**  
> Designed and built a relational banking database from scratch using MySQL, including 8 related tables, primary/foreign keys and data constraints. Analyzed 50+ banking transactions, customer accounts, loans, repayments, credit cards and support tickets using joins, CTEs, subqueries and window functions. Performed customer segmentation, transaction trend analysis, loan-risk analysis, credit utilization analysis and Customer 360 reporting while addressing row-multiplication and aggregation accuracy issues.

---

## 🏷️ Suggested GitHub Topics

```text
mysql
sql
data-analysis
data-analyst
banking-analytics
financial-analytics
sql-project
mysql-project
data-analytics-project
portfolio-project
```
