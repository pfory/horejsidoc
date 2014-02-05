<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="_Default" %>

<%@ Import Namespace="System.Globalization" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Hlavni" runat="Server">
    <asp:SqlDataSource ID="DS_DataUvodObsah" runat="server" ConnectionString="<%$ ConnectionStrings:DataHorejsi %>"
        SelectCommand="SELECT Obsah,ObsahEN FROM T_Obsah_ND WHERE (ID_mista = @ID_mista) AND (ID_Obsah = (SELECT MAX(ID_Obsah) AS Expr1 FROM T_Obsah_ND AS T_Obsah_1 WHERE (ID_mista = 1)))">
        <SelectParameters>
            <asp:Parameter DefaultValue="1" Name="ID_mista" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <%If CultureInfo.CurrentCulture.ToString = "cs-CZ" Then%>
    <asp:ListView runat="server" ID="DV_ObsahHomePage" DataSourceID="DS_DataUvodObsah">
        <ItemTemplate>
            <asp:Literal ID="Literal1" runat="server" Text='<%# Bind("Obsah")%>'></asp:Literal>
        </ItemTemplate>
    </asp:ListView>
    <%Else%>
    <asp:ListView runat="server" ID="DV_ObsahHomePageEN" DataSourceID="DS_DataUvodObsah">
        <ItemTemplate>
            <asp:Literal ID="Literal1" runat="server" Text='<%# Bind("ObsahEN")%>'></asp:Literal>
        </ItemTemplate>
    </asp:ListView>
    <%End If%>
</asp:Content>
