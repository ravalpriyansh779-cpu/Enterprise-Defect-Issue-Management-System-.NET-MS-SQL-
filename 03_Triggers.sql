USE EDIMS;
GO
CREATE TRIGGER dbo.trg_Defects_StatusAudit ON Defects AFTER UPDATE
AS BEGIN
 SET NOCOUNT ON;
 INSERT DefectAudit(DefectId,OldStatus,NewStatus)
 SELECT i.DefectId,d.Status,i.Status FROM inserted i JOIN deleted d ON d.DefectId=i.DefectId WHERE i.Status<>d.Status;
END
GO
