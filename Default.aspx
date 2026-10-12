<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="EDIMS.Default" %>
<!DOCTYPE html>
<html><head runat="server"><title>Defect Tracker</title>
<link href="Content/site.css" rel="stylesheet"/><script src="Scripts/site.js"></script></head>
<body><form id="form1" runat="server">
<h1>Defect &amp; Issue Management</h1>
<div class="filters"><asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStatus_Changed">
<asp:ListItem Value="">All</asp:ListItem><asp:ListItem>Open</asp:ListItem><asp:ListItem>In Progress</asp:ListItem><asp:ListItem>Resolved</asp:ListItem><asp:ListItem>Closed</asp:ListItem></asp:DropDownList></div>
<asp:GridView ID="gvDefects" runat="server" CssClass="grid" AutoGenerateColumns="false" OnRowDataBound="gvDefects_RowDataBound">
<Columns><asp:BoundField DataField="DefectId" HeaderText="ID"/><asp:BoundField DataField="Title" HeaderText="Title"/>
<asp:BoundField DataField="Status" HeaderText="Status"/><asp:BoundField DataField="Priority" HeaderText="Priority"/>
<asp:BoundField DataField="Assignee" HeaderText="Assignee"/><asp:BoundField DataField="SlaDueAt" HeaderText="SLA Due"/></Columns>
</asp:GridView></form></body></html>
