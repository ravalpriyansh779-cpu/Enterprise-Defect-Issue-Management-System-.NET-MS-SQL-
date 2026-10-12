# Enterprise Defect & Issue Management System (.NET + MS SQL)

ASP.NET (C#) defect tracker with workflow Open -> In Progress -> Resolved -> Closed, priority, assignment and SLA tracking.

**Stack:** C#, .NET Framework, ASP.NET, MS SQL Server, HTML, CSS, JavaScript, SSRS

## Structure
- `Database/` - schema, stored procedures/functions, audit triggers, T-SQL report queries (run in order 01 to 04)
- `Web/` - Models, Data (data-access layer), Services (business layer), pages, CSS, JS
- `Reports/` - SSRS report notes (datasets map to Database/04_Reports.sql)

## Setup
1. Run the SQL scripts in `Database/` against a new database named `EDIMS`.
2. Update the connection string in `Web/Web.config`.
3. Open the `Web` folder in Visual Studio and run.
