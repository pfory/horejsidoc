<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/Admin.master" AutoEventWireup="false" CodeFile="SpravaZakazniku.aspx.vb" Inherits="Pages_SpravaObjednavek" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Hlavni" Runat="Server">
    <h4 style="text-align: center">Filtr zákazníků</h4>
    <center>
    <table>
        <tr>
            <td>
                Žádající obchodník</td>
            <td>
                <asp:CheckBox ID="chb_zadajici" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                Potvrzený obchodník</td>
            <td>
                <asp:CheckBox ID="chb_potvrzeny" runat="server" />
            </td>
        </tr>
        <tr>
            <td>
                Zákazník (i část jména)</td>
            <td>
                <asp:TextBox ID="txb_zakaznik" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: center">
                <asp:Button
                    ID="BTN_vyhledej" runat="server" Text="Vyhledej" 
                    style="text-align: center" />
            </td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: center">
                &nbsp;</td>
        </tr>
    </table>
    </center>
    <br />
    <h4 style="text-align: center">Seznam registrovaných zákazníků</h4>
    <asp:SqlDataSource ID="DS_Zakaznik" runat="server" 
    ConnectionString="<%$ ConnectionStrings:DataHorejsi %>" 
    ProviderName="<%$ ConnectionStrings:DataHorejsi.ProviderName %>" 
        SelectCommand="SELECT DISTINCT ID_zakaznik, RTRIM(Prijmeni) + ' ' + RTRIM(Jmeno) AS Zakaznik, Mail, VC, Obchodnik, Firma, IC, DIC,Uzivatel,Heslo,Jazyk FROM T_Zakaznik WHERE (1 = 1) AND (Registrovan = 1)" 
        UpdateCommand="UPDATE T_Zakaznik SET VC = @VC WHERE (ID_zakaznik = @ID_zakaznik)">
        <UpdateParameters>
            <asp:Parameter Name="VC" />
            <asp:Parameter Name="Obchodnik" />
            <asp:Parameter Name="ID_zakaznik" />
        </UpdateParameters>
</asp:SqlDataSource>
    
    <asp:SqlDataSource ID="DS_Kontakty" runat="server" 
        ConnectionString="<%$ ConnectionStrings:DataHorejsi %>" 
        InsertCommand="INSERT INTO T_Kontakty(MailAdresa, Aktivni, Tester, DatumRegistrace, Obchodnik) VALUES (@MailAdresa, @Aktivni, @Tester, @DatumRegistrace, @Obchodnik)" 
        ProviderName="<%$ ConnectionStrings:DataHorejsi.ProviderName %>" 
        SelectCommand="SELECT ID_kontakt, MailAdresa, Aktivni, Tester, DatumRegistrace, Obchodnik FROM T_Kontakty WHERE (MailAdresa = @MailAdresa)">
        <SelectParameters>
            <asp:Parameter Name="MailAdresa" />
        </SelectParameters>
    </asp:SqlDataSource>
    
    Záznamů:
    <asp:DropDownList ID="ddl_pageSize" runat="server" AutoPostBack="True">
        <asp:ListItem>5</asp:ListItem>
        <asp:ListItem>10</asp:ListItem>
        <asp:ListItem>20</asp:ListItem>
        <asp:ListItem>40</asp:ListItem>
        <asp:ListItem>80</asp:ListItem>
        <asp:ListItem>100</asp:ListItem>
    </asp:DropDownList>
    <center>
    <asp:GridView ID="GV_Zakaznici" runat="server" AllowPaging="True" AutoGenerateColumns="False"
        DataKeyNames="ID_zakaznik" PageSize="5" DataSourceID="DS_Zakaznik">
        <Columns>
            <asp:CommandField ShowEditButton="True" />
            <asp:BoundField DataField="Zakaznik" HeaderText="Zákazník"
                SortExpression="Zakaznik" ReadOnly="True">
            </asp:BoundField>
            <asp:BoundField DataField="Firma" HeaderText="Firma" 
                SortExpression="Firma" ReadOnly="True" >
            </asp:BoundField>
            <asp:BoundField DataField="IC" HeaderText="IČO" 
                SortExpression="IC" ReadOnly="True">
            </asp:BoundField>
            <asp:BoundField DataField="Mail" HeaderText="Mail" SortExpression="Mail" 
                ReadOnly="True" />
            <asp:BoundField DataField="Uzivatel" HeaderText="Uživatel"  
                ReadOnly="True" /> 
            <asp:BoundField DataField="Heslo" HeaderText="Heslo"  
                ReadOnly="True" />        
            <asp:CheckBoxField DataField="Obchodnik" HeaderText="Chce obchodovat" 
                SortExpression="Potvrzen">
            <ItemStyle HorizontalAlign="Center" />
            </asp:CheckBoxField>
            <asp:CheckBoxField DataField="VC" HeaderText="Obchodník" SortExpression="VC">
            <ItemStyle HorizontalAlign="Center" />
            </asp:CheckBoxField>
        </Columns>
        <SelectedRowStyle BackColor="#C0FFC0" />
        <HeaderStyle BackColor="Teal" ForeColor="#80FF80" />
        <AlternatingRowStyle BackColor="Silver" />
    </asp:GridView>
        <br />
    </center>
</asp:Content>

