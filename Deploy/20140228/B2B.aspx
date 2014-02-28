<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="false" CodeFile="B2B.aspx.vb" Inherits="Pages_B2B" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Hlavni" Runat="Server">

<h1><asp:Localize ID="Localize1" runat="server" Text='<%$ Resources: title %>'></asp:Localize></h1>
<div class="b2b">
    <asp:Literal ID="lit_htmlFile" runat="server"></asp:Literal>
</div>    
</asp:Content>

