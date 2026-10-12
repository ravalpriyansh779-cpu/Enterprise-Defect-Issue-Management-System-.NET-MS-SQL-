using System;
using System.Collections.Generic;
using EDIMS.Data;
using EDIMS.Models;

namespace EDIMS.Services
{
    public class DefectService
    {
        private readonly IDefectRepository _repo;
        public DefectService() : this(new DefectRepository()) { }
        public DefectService(IDefectRepository repo) { _repo = repo; }

        public int Report(string title, string description, byte priorityId, int reportedBy)
        {
            if (string.IsNullOrWhiteSpace(title)) throw new ArgumentException("Title is required.");
            return _repo.Create(title.Trim(), description, priorityId, reportedBy, null);
        }

        public void Assign(int defectId, int userId) { _repo.Assign(defectId, userId); _repo.ChangeStatus(defectId, "In Progress"); }
        public void Resolve(int defectId) => _repo.ChangeStatus(defectId, "Resolved");
        public void Close(int defectId) => _repo.ChangeStatus(defectId, "Closed");
        public List<Defect> List(string status = null) => _repo.GetAll(status);
    }
}
