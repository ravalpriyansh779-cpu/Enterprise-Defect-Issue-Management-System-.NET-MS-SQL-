using System;
using System.Web.UI.WebControls;
using EDIMS.Models;
using EDIMS.Services;

namespace EDIMS
{
    public partial class Default : System.Web.UI.Page
    {
        private readonly DefectService _svc = new DefectService();
        protected void Page_Load(object sender, EventArgs e) { if (!IsPostBack) Bind(); }
        protected void ddlStatus_Changed(object sender, EventArgs e) => Bind();
        private void Bind()
        {
            gvDefects.DataSource = _svc.List(string.IsNullOrEmpty(ddlStatus.SelectedValue) ? null : ddlStatus.SelectedValue);
            gvDefects.DataBind();
        }
        protected void gvDefects_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.DataItem is Defect d && d.SlaBreached) e.Row.CssClass = "breach";
        }
    }
}
