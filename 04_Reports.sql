USE EDIMS;
GO
-- Bug aging (open defects)
CREATE PROCEDURE dbo.rpt_BugAging AS
SELECT DefectId,Title,Status,DATEDIFF(DAY,CreatedAt,SYSUTCDATETIME()) AS AgeDays,
 CASE WHEN DATEDIFF(DAY,CreatedAt,SYSUTCDATETIME())<=7 THEN '0-7' WHEN DATEDIFF(DAY,CreatedAt,SYSUTCDATETIME())<=30 THEN '8-30' ELSE '30+' END AS AgeBucket
FROM Defects WHERE Status IN ('Open','In Progress');
GO
-- Resolution time per assignee
CREATE PROCEDURE dbo.rpt_ResolutionTimePerAssignee AS
SELECT u.FullName, COUNT(*) AS Resolved, AVG(DATEDIFF(HOUR,d.CreatedAt,d.ResolvedAt)) AS AvgHours,
 SUM(CASE WHEN d.ResolvedAt>d.SlaDueAt THEN 1 ELSE 0 END) AS SlaBreaches
FROM Defects d JOIN Users u ON u.UserId=d.AssignedTo WHERE d.ResolvedAt IS NOT NULL GROUP BY u.FullName;
GO
-- Reopen rate
CREATE PROCEDURE dbo.rpt_ReopenRate AS
SELECT u.FullName, COUNT(*) AS Total, SUM(CASE WHEN d.ReopenCount>0 THEN 1 ELSE 0 END) AS Reopened,
 CAST(100.0*SUM(CASE WHEN d.ReopenCount>0 THEN 1 ELSE 0 END)/COUNT(*) AS DECIMAL(5,2)) AS ReopenRatePct
FROM Defects d JOIN Users u ON u.UserId=d.AssignedTo GROUP BY u.FullName;
GO
