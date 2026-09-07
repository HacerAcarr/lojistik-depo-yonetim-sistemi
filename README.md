# 📦 Warehouse Management System (WMS) for a Logistics Company

This project is an end-to-end Warehouse Management System (WMS) engineering implementation designed to digitize warehousing, shipping, inventory, fleet, and personnel operations in modern logistics. It leverages relational (RDBMS) and document-based (NoSQL) database architectures alongside a desktop management interface.

## 👥 Project Author
* **Hacer Acar** - GitHub Profile *(Student ID: 1030310713)*

## 🎯 Project Objectives & Scope
Critical bottlenecks in supply chain and logistics include inventory discrepancies, inefficient fleet/driver routing, redundant data entry, and slow operational reporting. The primary objectives of this project are:

* **Process Modeling:** Enterprise-level modeling of warehouse inbound/outbound flows, order fulfillment, dispatching, and procurement cycles.
* **Relational Data Integrity (RDBMS):** Normalization of raw datasets up to Third Normal Form (3NF) to eliminate anomalies on MS SQL Server.
* **Database-Level Business Logic:** Encapsulation of operational constraints and rules within the database engine via Triggers, Stored Procedures, and User-Defined Functions (UDFs).
* **Hybrid Data Architecture (SQL & NoSQL):** Migration of transactional data to MongoDB to handle analytical queries, flexible schema requirements, and aggregation pipelines.
* **Desktop Administration Interface:** Centralized fleet and driver operations managed through a fully functional C# Windows Forms CRUD application.

## 🛠 Tech Stack & Architecture
* **Development Tools:** Microsoft Visual Studio, SQL Server Management Studio (SSMS), MongoDB Compass & Mongosh
* **Programming Language:** C# (.NET Framework 4.7.2, Windows Forms, ADO.NET)
* **Relational Database:** Microsoft SQL Server (T-SQL, Triggers, Functions, Stored Procedures, DDL/DML)
* **Document Database:** MongoDB (BSON/JSON, Aggregation Framework: `$lookup`, `$unwind`, `$match`, `$group`)
* **Design & Modeling:** ER Diagram (Chen Notation), UML Class Diagrams

## 🚀 Development Lifecycle (8 Tasks)

### 📌 Task 1: Entity-Relationship (ER) Diagram
Modeled 15 core entities (*Customer, Order, OrderDetail, Invoice, Shipment, CompanyVehicle, Driver, Warehouse, Stock, Product, Category, Employee, Manager, Shift, Supplier, Supply*) along with their 1:1, 1:N, and M:N cardinality constraints.

### 📌 Task 2: UML Class Diagram (Object-Oriented Design)
Designed domain models following OOP standards, specifying attributes, access modifiers, operational methods, and inheritance hierarchies (e.g., Manager inheriting from Employee).

### 📌 Task 3: Database Normalization (1NF, 2NF, 3NF)
* **Raw Table Analysis:** Identified unnormalized datasets containing multivalued attributes and update/delete anomalies.
* **1NF:** Enforced atomic column values and defined composite primary keys.
* **2NF:** Removed partial functional dependencies by isolating functional sub-tables.
* **3NF:** Eliminated transitive dependencies (e.g., decoupled `CategoryID -> CategoryName` from the product schema, optimized derived attributes like subtotal and fill rates).

### 📌 Task 4: MS SQL Server Schema & Data Seeding
Generated normalized tables with explicit PRIMARY KEY, FOREIGN KEY, and CHECK constraints, followed by comprehensive synthetic data population via `INSERT INTO` scripts.

### 📌 Task 5: SQL Queries (Basic, DML, Advanced Analytics)
* **15 Analytical Queries:** Group aggregations and operational metrics using `GROUP BY`, `HAVING`, `SUM`, `AVG`, `COUNT`, `MIN`, and `MAX`.
* **6 DML Queries:** Dynamic conditional `INSERT`, `UPDATE`, and `DELETE` transactions.
* **11 Advanced Queries:** Multi-table joins (`INNER JOIN`, `LEFT/RIGHT OUTER JOIN`), subqueries, and correlated subqueries with `EXISTS` and `IN`.

### 📌 Task 6: Programmable Database Objects
* **7 Triggers:**
  * `Trg_PersonelSil`: Archives deleted employee records into `TabloEskiPersonel`.
  * `Trg_MaasGuncelleme`: Restricts salary deductions and logs salary increments into `Guncelleme`.
  * `Trg_SoforuPasifYapma`: Soft-deletes drivers by updating status to `PASIF` via `INSTEAD OF DELETE` to preserve foreign key references.
  * `Trg_Koruma`: DDL trigger preventing accidental schema alterations (`FOR DROP_TABLE`, `ALTER_TABLE`).
  * `Trg_DepoDolulukOrani`: Validates warehouse capacity thresholds (100% capacity check) and assigns occupancy tiers.
  * `Trg_UrunRafaYerlesme` & `Trg_TedarikBilgi`: Automates inbound goods acceptance and inventory placement.
* **7 User-Defined Functions (UDFs):** Table-valued functions (`TedarikciUrunleri`, `UrunBilgisi`) and scalar functions for driving license validation, age calculations, and vehicle availability lookups.
* **5 Stored Procedures:** Cursor-driven driver shipment dispatching (`SoforGorevAta`), dynamic employee bonuses (`PersonelePrim`), tiered invoice discounts (`Indirim`), and inventory summaries (`DepoBilgi`).

### 📌 Task 7: JSON Transformation & MongoDB Pipeline
* Exported relational datasets using SQL Server's `FOR JSON AUTO` clause.
* Populated 11 collections in MongoDB and configured indexes on document keys.
* Executed Aggregation Pipelines using `$lookup` and `$unwind` for document joins, alongside `$group` and `$match` stages for analytical reports.

### 📌 Task 8: C# Windows Forms Admin Panel
* Centralized desktop dashboard structured with `MenuStrip` controls.
* **Fleet Management:** Vehicle registration, status tracking, license plate/model updates, and dynamic tabular viewing via `DataGridView`.
* **Driver Management:** Registration, license validation, real-time availability tracking, and soft-delete routines.
* Secure database interactions built with parameterized queries (`SqlParameter`) against SQL injection vulnerabilities.

## 📂 Project Directory Structure

```text
📦 Logistics-Warehouse-Management-System
├── 📁 docs
│   ├── final-report.pdf              # Academic Project Final Report
│   ├── normalization-details.pdf     # 1NF, 2NF, 3NF Normalization Documentation
│   └── midterm-report.pdf            # Midterm Database Design Report
├── 📁 diagrams
│   ├── er-diagram.pdf                # Entity-Relationship Diagram (Task 1)
│   ├── uml-diagram.pdf               # UML Class Diagram (Task 2)
│   └── er-diagram.dwg                # AutoCAD Source Drawing
├── 📁 mongodb
│   ├── 📁 data                       # Exported JSON collections
│   └── mongodb-pipeline-queries.sql  # Mongosh and Compass Aggregation Scripts (Task 7)
├── 📁 sql
│   ├── 00-init-database.sql          # Database and Table DDL Schema
│   ├── 01-data-seed.sql              # Mock Data and INSERT Scripts
│   ├── task-5-queries.sql            # Basic and Advanced SQL Queries
│   └── task-6-programmability.sql    # Triggers, Stored Procedures, Functions
├── 📁 src
│   └── 📁 DepoYonetimApp             # C# Windows Forms Application Source Code
│       ├── DepoYonetimApp.sln        # Visual Studio Solution File
│       ├── App.config                # Database Connection String
│       └── ...                       # Form Views and Controller Logic
└── README.md                         # Project Documentation
```
⚙️ Installation & Setup
1. Database Setup (MS SQL Server)
Launch SQL Server Management Studio (SSMS) and connect to your SQL Server instance.

Open and execute sql/00-init-database.sql followed by sql/01-data-seed.sql to initialize schema definitions and seed data.

Open and execute sql/task-6-programmability.sql to register all triggers, stored procedures, and functions.

2. NoSQL Configuration (MongoDB)
Open MongoDB Compass or initialize mongosh connected to your local instance (mongodb://localhost:27017/).

Create or switch to the target database:

JavaScript
use Grup26
Import the JSON datasets located in mongodb/data/ into their corresponding collections (depo, musteri, personel, etc.).

Run analytical aggregation queries from mongodb/mongodb-pipeline-queries.sql.

3. Running the C# Desktop Client
Open src/DepoYonetimApp/DepoYonetimApp.sln in Visual Studio.

Update the connectionString in App.config or within the form code behind to match your local SQL Server instance:

C#
SqlConnection baglanti = new SqlConnection("Data Source=.;Initial Catalog=Grup26;Integrated Security=True");
Build the solution (Ctrl + Shift + B) and run the application (F5).

📜 License
This project is distributed under the MIT License. Refer to the LICENSE file for full terms and conditions.
