USE EDIMS;
GO
CREATE FUNCTION dbo.fn_SlaDue(@PriorityId TINYINT, @From DATETIME2) RETURNS DATETIME2
AS BEGIN RETURN (SELECT DATEADD(HOUR, SlaHours, @From) FROM Priorities WHERE PriorityId=@PriorityId); END
GO
CREATE PROCEDURE dbo.usp_CreateDefect @Title NVARCHAR(200), @Description NVARCHAR(MAX), @PriorityId TINYINT, @ReportedBy INT, @AssignedTo INT=NULL
AS BEGIN
 SET NOCOUNT ON;
 DECLARE @now DATETIME2=SYSUTCDATETIME();
 INSERT Defects(Title,Description,PriorityId,ReportedBy,AssignedTo,CreatedAt,SlaDueAt)
 VALUES(@Title,@Description,@PriorityId,@ReportedBy,@AssignedTo,@now,dbo.fn_SlaDue(@PriorityId,@now));
 SELECT SCOPE_IDENTITY() AS DefectId;
END
GO
CREATE PROCEDURE dbo.usp_AssignDefect @DefectId INT, @AssignedTo INT
AS UPDATE Defects SET AssignedTo=@AssignedTo WHERE DefectId=@DefectId;
GO
CREATE PROCEDURE dbo.usp_ChangeStatus @DefectId INT, @NewStatus NVARCHAR(20)
AS BEGIN
 SET NOCOUNT ON;
 DECLARE @old NVARCHAR(20)=(SELECT Status FROM Defects WHERE DefectId=@DefectId);
 IF NOT ((@old='Open' AND @NewStatus='In Progress') OR (@old='In Progress' AND @NewStatus='Resolved')
      OR (@old='Resolved' AND @NewStatus IN ('Closed','In Progress')) OR (@old='Closed' AND @NewStatus='Open'))
 BEGIN RAISERROR('Invalid status transition %s -> %s',16,1,@old,@NewStatus); RETURN; END
 UPDATE Defects SET Status=@NewStatus,
   ResolvedAt=CASE WHEN @NewStatus='Resolved' THEN SYSUTCDATETIME() ELSE ResolvedAt END,
   ClosedAt=CASE WHEN @NewStatus='Closed' THEN SYSUTCDATETIME() ELSE ClosedAt END,
   ReopenCount=ReopenCount+CASE WHEN (@old='Resolved' AND @NewStatus='In Progress') OR (@old='Closed' AND @NewStatus='Open') THEN 1 ELSE 0 END
 WHERE DefectId=@DefectId;
END
GO
CREATE PROCEDURE dbo.usp_GetDefects @Status NVARCHAR(20)=NULL
AS SELECT d.*, p.Name AS Priority, u.FullName AS Assignee,
   CASE WHEN d.Status NOT IN ('Resolved','Closed') AND SYSUTCDATETIME()>d.SlaDueAt THEN 1 ELSE 0 END AS SlaBreached
   FROM Defects d JOIN Priorities p ON p.PriorityId=d.PriorityId LEFT JOIN Users u ON u.UserId=d.AssignedTo
   WHERE @Status IS NULL OR d.Status=@Status ORDER BY d.PriorityId, d.CreatedAt;
GO
