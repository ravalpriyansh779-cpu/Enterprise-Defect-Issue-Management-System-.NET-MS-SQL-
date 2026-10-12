using System;
namespace EDIMS.Models
{
    public class Defect
    {
        public int DefectId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Status { get; set; }
        public string Priority { get; set; }
        public int PriorityId { get; set; }
        public string Assignee { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? SlaDueAt { get; set; }
        public bool SlaBreached { get; set; }
        public int ReopenCount { get; set; }
    }
}
