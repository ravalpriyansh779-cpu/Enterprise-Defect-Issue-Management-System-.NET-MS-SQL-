using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using EDIMS.Models;

namespace EDIMS.Data
{
    public interface IDefectRepository
    {
        int Create(string title, string description, byte priorityId, int reportedBy, int? assignedTo);
        void Assign(int defectId, int userId);
        void ChangeStatus(int defectId, string newStatus);
        List<Defect> GetAll(string status);
    }

    public class DefectRepository : IDefectRepository
    {
        private readonly string _cs = ConfigurationManager.ConnectionStrings["EDIMS"].ConnectionString;

        public int Create(string title, string description, byte priorityId, int reportedBy, int? assignedTo)
        {
            using (var c = new SqlConnection(_cs))
            using (var cmd = new SqlCommand("dbo.usp_CreateDefect", c) { CommandType = CommandType.StoredProcedure })
            {
                cmd.Parameters.AddWithValue("@Title", title);
                cmd.Parameters.AddWithValue("@Description", (object)description ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@PriorityId", priorityId);
                cmd.Parameters.AddWithValue("@ReportedBy", reportedBy);
                cmd.Parameters.AddWithValue("@AssignedTo", (object)assignedTo ?? DBNull.Value);
                c.Open();
                return Convert.ToInt32(cmd.ExecuteScalar());
            }
        }

        public void Assign(int defectId, int userId) => Exec("dbo.usp_AssignDefect", ("@DefectId", defectId), ("@AssignedTo", userId));
        public void ChangeStatus(int defectId, string newStatus) => Exec("dbo.usp_ChangeStatus", ("@DefectId", defectId), ("@NewStatus", newStatus));

        public List<Defect> GetAll(string status)
        {
            var list = new List<Defect>();
            using (var c = new SqlConnection(_cs))
            using (var cmd = new SqlCommand("dbo.usp_GetDefects", c) { CommandType = CommandType.StoredProcedure })
            {
                cmd.Parameters.AddWithValue("@Status", (object)status ?? DBNull.Value);
                c.Open();
                using (var r = cmd.ExecuteReader())
                    while (r.Read())
                        list.Add(new Defect
                        {
                            DefectId = (int)r["DefectId"], Title = (string)r["Title"], Status = (string)r["Status"],
                            Priority = (string)r["Priority"], PriorityId = Convert.ToInt32(r["PriorityId"]),
                            Assignee = r["Assignee"] as string, CreatedAt = (DateTime)r["CreatedAt"],
                            SlaDueAt = r["SlaDueAt"] as DateTime?, SlaBreached = (int)r["SlaBreached"] == 1,
                            ReopenCount = (int)r["ReopenCount"]
                        });
            }
            return list;
        }

        private void Exec(string proc, params (string, object)[] ps)
        {
            using (var c = new SqlConnection(_cs))
            using (var cmd = new SqlCommand(proc, c) { CommandType = CommandType.StoredProcedure })
            {
                foreach (var p in ps) cmd.Parameters.AddWithValue(p.Item1, p.Item2);
                c.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}
