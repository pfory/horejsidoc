<%@ Page Title="" Debug="true" Language="VB" MasterPageFile="~/MasterPage/Admin.master" AutoEventWireup="false" CodeFile="SpravaObjednavek.aspx.vb" Inherits="Pages_SpravaObjednavek" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Hlavni" Runat="Server">
<script type="text/javascript" language="javascript">

    function onUpdating() {
        // get the update progress div
        var updateProgressDiv = $get('updateProgressDiv');
        // make it visible
        updateProgressDiv.style.display = '';

    }

    function onUpdated() {
        // get the update progress div
        var updateProgressDiv = $get('updateProgressDiv');
        // make it invisible
        updateProgressDiv.style.display = 'none';
    }
    
    </script>
    <h4 style="text-align: center">Filtr objednávek</h4>
    <div align="center">
    <table style="text-align:left">
        <tr>
            <td>
                Datum objednání</td>
            <td>
                <asp:TextBox ID="txb_datumObjednavky" runat="server"></asp:TextBox>
                <ajaxToolkit:CalendarExtender ID="defaultCalendarExtender" runat="server" TargetControlID="txb_datumObjednavky" />
            </td>
        </tr>
        <tr>
            <td>
            Hloubka historie
            </td>
            <td align="left">
                <asp:TextBox ID="txb_interval" runat="server" Text="" MaxLength="3" 
                    Width="30px"></asp:TextBox> 
                <asp:RangeValidator ID="RangeValidator1" runat="server" 
                                    ErrorMessage="Zadej celé èíslo" 
                                    ControlToValidate="txb_interval"
                                    ValidationGroup="vyhledej"
                                    Display="Dynamic"
                                    MinimumValue="1"
                                    MaximumValue="999">
                </asp:RangeValidator>   
                <asp:DropDownList ID="ddl_rozsah" runat="server">
                    <asp:ListItem Selected="True" Value="day">Den</asp:ListItem>
                    <asp:ListItem Value="week">Týden</asp:ListItem>
                    <asp:ListItem Value="month">Mìsíc</asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td>
                Mail zákazníka</td>
            <td>
                <asp:TextBox ID="TXB_mailZakaznik" runat="server"></asp:TextBox>
                </td>
        </tr>
        <tr>
            <td>
                Balík è.</td>
            <td>
                <asp:TextBox ID="TXB_cisloBaliku" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Objednávka è.</td>
            <td>
                <asp:TextBox ID="TXT_objednavka" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Neodeslané </td>
            <td>
                <asp:CheckBox ID="CHB_neodeslane" runat="server" AutoPostBack="False" />
            </td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: center">
                <asp:Button
                    ID="BTN_vyhledej" runat="server" Text="Vyhledej" ValidationGroup="vyhledej" 
                    style="text-align: center" />
            </td>
        </tr>
    </table>
    </div>
    <br />
    <h4 style="text-align: center">Seznam objednávek</h4>
    <asp:SqlDataSource ID="DS_Objednavky" runat="server" 
    ConnectionString="<%$ ConnectionStrings:DataHorejsi %>" 
    ProviderName="<%$ ConnectionStrings:DataHorejsi.ProviderName %>" 
        SelectCommand="SELECT DISTINCT T_Objednavky.ID_objednavky, T_Objednavky.Datum_objednavky, T_Zakaznik.ID_zakaznik, RTRIM(T_Zakaznik.Prijmeni) + ' ' + RTRIM(T_Zakaznik.Jmeno) AS Zakaznik, T_Zakaznik.Mail, T_Objednavky.Doprava, T_Objednavky.Datum_expedice, T_Objednavky.ID_baliku, T_Poznamky.Text AS Poznamka, T_Objednavky.Expedovano, T_Zakaznik.Staty_ID, T_Zakaznik.Registrovan, T_Objednavky.KurzEUR FROM T_Objednavky INNER JOIN T_Zakaznik ON T_Objednavky.ID_zakaznik = T_Zakaznik.ID_zakaznik LEFT OUTER JOIN T_Poznamky ON T_Objednavky.ID_objednavky = T_Poznamky.ID_Objednavky WHERE (1 = 1)" 
        UpdateCommand="UPDATE T_Objednavky SET Datum_expedice = CONVERT (smalldatetime, @Datum_Expedice, 104), ID_baliku = @ID_baliku WHERE (ID_objednavky = @ID_objednavky)" 
        
        InsertCommand="INSERT INTO T_Objednavky(ID_objcislo, ID_objednavky, Mnozstvi, ID_zakaznik, Storno_poznamka, Datum_objednavky, Doprava, KurzEUR) VALUES (@ID_objcislo, @ID_objednavky, @Mnozstvi, @ID_zakaznik, @Storno_poznamka, CONVERT (smalldatetime, @Datum_objednavky, 104), @Doprava, convert(real,replace(@KurzEUR,',','.')))">
        <UpdateParameters>
            <asp:Parameter Name="Datum_Expedice" />
            <asp:Parameter Name="ID_baliku" />
            <asp:Parameter Name="ID_objednavky" DbType="Int16" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="ID_objcislo" />
            <asp:Parameter Name="ID_objednavky" />
            <asp:Parameter Name="Mnozstvi" />
            <asp:Parameter Name="ID_zakaznik" />
            <asp:Parameter Name="Storno_poznamka" />
            <asp:Parameter Name="Datum_objednavky" />
            <asp:Parameter Name="Doprava" />
            <asp:Parameter Name="KurzEUR" />
        </InsertParameters>
</asp:SqlDataSource>
    
    <asp:SqlDataSource ID="DS_DetailObjednavky" runat="server" 
        ConnectionString="<%$ ConnectionStrings:DataHorejsi %>" 
        ProviderName="<%$ ConnectionStrings:DataHorejsi.ProviderName %>" 
        SelectCommand="SELECT T_Produkt.ID_objcislo, T_Produkt.Text_CZ, CAST(T_Objednavky.Mnozstvi AS varchar) + ' ' + T_Produkt.Jednotka AS Mnozstvi, T_Objednavky.Storno, T_Objednavky.Storno_poznamka FROM T_Objednavky INNER JOIN T_Produkt ON T_Objednavky.ID_objcislo = T_Produkt.ID_objcislo WHERE (T_Objednavky.ID_objednavky = @ID_objednavky)" 
        UpdateCommand="UPDATE T_Objednavky SET Storno = @Storno, Storno_poznamka = @Storno_poznamka WHERE (ID_objcislo = @ID_objcislo) AND (ID_objednavky = @ID_objednavky)">
        <SelectParameters>
            <asp:ControlParameter ControlID="GV_Objednavky" Name="ID_objednavky" 
                PropertyName="SelectedValue" />
        </SelectParameters>
        <UpdateParameters>
            <asp:Parameter Name="Storno" />
            <asp:Parameter Name="Storno_poznamka" />
            <asp:Parameter Name="ID_objcislo" />
            <asp:ControlParameter ControlID="GV_Objednavky" Name="ID_objednavky" 
                PropertyName="SelectedValue" />
        </UpdateParameters>
    </asp:SqlDataSource>
    
    <asp:SqlDataSource ID="DS_VypisObjednavky" runat="server" 
        ConnectionString="<%$ ConnectionStrings:DataHorejsi %>" 
        ProviderName="<%$ ConnectionStrings:DataHorejsi.ProviderName %>" 
        SelectCommand="SELECT T_Objednavky.ID_objednavky, T_Objednavky.Mnozstvi, T_Produkt.Jednotka, T_Objednavky.Datum_objednavky, 
        T_Objednavky.Storno, T_Objednavky.Storno_poznamka, T_Objednavky.ID_baliku, T_Objednavky.ID_objcislo, T_Produkt.Text_CZ, 
        T_Produkt.Text_EN, T_Produkt.VC,T_Produkt.VC*(1+ T_Produkt.DPH/100.0)AS VCDPH, T_Produkt.MC, T_Produkt.MC*(1+ T_Produkt.DPH/100.0)AS MCDPH , T_Produkt.DPH, T_Produkt.PHE711, T_Produkt.PHE715, T_Zakaznik.Prijmeni, T_Zakaznik.Jmeno, T_Zakaznik.Mail, T_Objednavky.Doprava, 
        T_Zakaznik.Mesto, T_Zakaznik.Ulice, T_Zakaznik.PSC, T_Objednavky.Datum_expedice, T_Objednavky.Jazyk, 
        T_Zakaznik.VC AS Obchodnik,  T_Zakaznik.Registrovan as Registrovan, T_Produkt.Marze, T_Produkt.Poznamka, T_Zakaznik.Staty_ID, T_Objednavky.KurzEUR 
        FROM T_Objednavky INNER JOIN T_Produkt ON T_Objednavky.ID_objcislo = T_Produkt.ID_objcislo INNER JOIN T_Zakaznik ON T_Objednavky.ID_zakaznik = T_Zakaznik.ID_zakaznik WHERE (1 = 1)">
    </asp:SqlDataSource>
    
    <asp:SqlDataSource ID="DS_Produkty" runat="server" 
        ConnectionString="<%$ ConnectionStrings:DataHorejsi %>" 
        ProviderName="<%$ ConnectionStrings:DataHorejsi.ProviderName %>" 
        SelectCommand="SELECT ID_objcislo, RTRIM(ID_objcislo) + ' - ' + RTRIM(Text_CZ) AS Produkt FROM T_Produkt order by ID_objcislo">
    </asp:SqlDataSource>
    
    <asp:SqlDataSource ID="DS_Zakaznik" runat="server" 
        ConnectionString="<%$ ConnectionStrings:DataHorejsi %>" 
        ProviderName="<%$ ConnectionStrings:DataHorejsi.ProviderName %>" 
        SelectCommand="SELECT T_Zakaznik.Prijmeni, T_Zakaznik.Jmeno, T_Zakaznik.Mail, T_Zakaznik.Telefon, T_Zakaznik.Mesto, T_Zakaznik.Ulice, T_Zakaznik.PSC, T_Zakaznik.Firma,  T_Zakaznik.IC, T_Zakaznik.DIC, T_Zakaznik.F_mesto, T_Zakaznik.F_ulice, T_Zakaznik.F_PSC, T_Zakaznik.Registrovan, T_Zakaznik.Obchodnik, 
                         T_Zakaznik.Uzivatel, T_Zakaznik.Heslo, T_Staty.nazev AS zem, T_Zakaznik.ICOAdresa, T_Zakaznik.DICAdresa, T_Zakaznik.FirmaAdresa
FROM    T_Zakaznik INNER JOIN   T_Staty ON T_Zakaznik.Staty_ID = T_Staty.id_stat
WHERE        (T_Zakaznik.ID_zakaznik = @ID_zakaznik)">
        <SelectParameters>
            <asp:Parameter Name="ID_zakaznik" Type="Int64" />
        </SelectParameters>
    </asp:SqlDataSource>
    
  <div align="center">
  <asp:UpdatePanel ID="updatePanel" runat="server" UpdateMode="Conditional">
  <ContentTemplate>
    <div align="left" style="margin-left:20px">
    Záznamù:
    <asp:DropDownList ID="ddl_pageSize" runat="server" AutoPostBack="True">
        <asp:ListItem>5</asp:ListItem>
        <asp:ListItem>10</asp:ListItem>
        <asp:ListItem>20</asp:ListItem>
        <asp:ListItem>40</asp:ListItem>
        <asp:ListItem>80</asp:ListItem>
        <asp:ListItem>100</asp:ListItem>
    </asp:DropDownList>
  </div>
    <asp:GridView ID="GV_Objednavky" runat="server" AllowPaging="True" AutoGenerateColumns="False"
        DataKeyNames="ID_objednavky" PageSize="5" DataSourceID="DS_Objednavky">
        <Columns>
            <asp:BoundField DataField="ID_objednavky" HeaderText="Objednávka"
                SortExpression="ID_objednavky" ReadOnly="True">
            <ItemStyle HorizontalAlign="Center" Font-Size="Smaller" />
            </asp:BoundField>
            <asp:BoundField DataField="Datum_objednavky" HeaderText="Objednáno" DataFormatString="{0:dd.MM.yyyy}" 
                SortExpression="Datum_objednavky" ReadOnly="True" >
            <ItemStyle HorizontalAlign="Center" Font-Size="Smaller" />
            </asp:BoundField>
            <asp:TemplateField HeaderText="Zákazník" SortExpression="Zakaznik">
                <ItemTemplate>
                    <asp:LinkButton ID="lnk_zakaznikDetail" runat="server" Text='<%# Bind("Zakaznik") %>' CommandArgument='<%# Bind("ID_zakaznik") %>' OnClick="lnk_zakaznikDetail_Click"></asp:LinkButton>
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("Zakaznik") %>'></asp:Label>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Mail" HeaderText="Mail" SortExpression="Mail" 
                ReadOnly="True" >
            <ItemStyle Font-Size="Smaller" />
            </asp:BoundField>
<asp:BoundField DataField="Poznamka" HeaderText="Poznámka" SortExpression="Poznamka" 
                ReadOnly="True">
            <ItemStyle Font-Size="Smaller" />
            </asp:BoundField>
            <asp:BoundField DataField="KurzEUR" HeaderText="Kurz" NullDisplayText="-" 
                SortExpression="KurzEUR" ReadOnly="True">
            <ItemStyle Font-Size="Smaller" />
            </asp:BoundField>
            <asp:TemplateField HeaderText="Expedováno" SortExpression="Datum_expedice">
                <EditItemTemplate>
                    <asp:TextBox ID="txb_updateExpedovano" runat="server" Width="70px" 
                        Text='<%# Bind("Datum_expedice") %>'></asp:TextBox>
                    <ajaxToolkit:MaskedEditExtender ID="txb_updateExpedovano_MaskedEditExtender" 
                        runat="server"
                        Enabled="True" 
                        TargetControlID="txb_updateExpedovano"
                        AutoComplete="true"
                        Mask="99/99/9999" 
                        MaskType="Date"/>
                    <ajaxToolkit:MaskedEditValidator ID="MaskedEditValidator1" 
                        runat="server" 
                        ControlToValidate="txb_updateExpedovano" 
                        ControlExtender="txb_updateExpedovano_MaskedEditExtender" 
                        Display="Dynamic" 
                        IsValidEmpty="true" 
                        InvalidValueMessage="Nesprávný datum." />    
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" 
                        Text='<%# Bind("Datum_expedice", "{0:dd.MM.yyyy}") %>'></asp:Label>
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Center" Font-Size="Smaller" />
            </asp:TemplateField>
            <asp:BoundField DataField="ID_baliku" HeaderText="Balík è." 
                SortExpression="ID_baliku" NullDisplayText="-">
            <ItemStyle HorizontalAlign="Center" Font-Size="Smaller"/>
            </asp:BoundField>
            <asp:CommandField SelectText="Vyber" ShowSelectButton="True" >
            <ItemStyle Font-Size="Smaller" />
            </asp:CommandField>
            <asp:CommandField ShowEditButton="True" >
            <ItemStyle Font-Size="Smaller" />
            </asp:CommandField>
        </Columns>
        <SelectedRowStyle BackColor="#C0FFC0" />
        <HeaderStyle BackColor="Teal" ForeColor="#80FF80" />
        <AlternatingRowStyle BackColor="Silver" />
    </asp:GridView>
    <br />
    <asp:GridView ID="GV_DetailObjednavky" runat="server" AutoGenerateColumns="False" 
            DataKeyNames="ID_objcislo" DataSourceID="DS_DetailObjednavky" 
            ShowFooter="True">
            <Columns>
                <asp:TemplateField HeaderText="Obj.èíslo" SortExpression="ID_objcislo">
                    <EditItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("ID_objcislo") %>'></asp:Label>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:DropDownList ID="ddl_newObjCislo" runat="server" 
                            AppendDataBoundItems="True" DataSourceID="DS_Produkty" DataTextField="Produkt" 
                            DataValueField="ID_objcislo" Width="250px">
                            <asp:ListItem Value="0">- Vyber produkt -</asp:ListItem>
                        </asp:DropDownList>
                    </FooterTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("ID_objcislo") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Popis" SortExpression="Text_CZ">
                    <EditItemTemplate>
                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("Text_CZ") %>'></asp:Label>
                    </EditItemTemplate>
                    <FooterTemplate>
                        -
                    </FooterTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("Text_CZ") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Množství" SortExpression="Mnozstvi">
                    <EditItemTemplate>
                        <asp:Label ID="Label3" runat="server" Text='<%# Eval("Mnozstvi") %>'></asp:Label>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="txb_newMnozstvi" runat="server" Width="50px"></asp:TextBox>
                    </FooterTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label3" runat="server" Text='<%# Bind("Mnozstvi") %>'></asp:Label>
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Storno" SortExpression="Storno">
                    <EditItemTemplate>
                        <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Storno") %>' />
                    </EditItemTemplate>
                    <FooterTemplate>
                        -
                    </FooterTemplate>
                    <ItemTemplate>
                        <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Storno") %>' 
                            Enabled="false" />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Poznámka" SortExpression="Storno_poznamka">
                    <EditItemTemplate>
                        <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Storno_poznamka") %>'></asp:TextBox>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:TextBox ID="txb_newPoznamka" runat="server"></asp:TextBox>
                    </FooterTemplate>
                    <ItemTemplate>
                        <asp:Label ID="Label4" runat="server" Text='<%# Bind("Storno_poznamka") %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField ShowHeader="False">
                    <EditItemTemplate>
                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="True" 
                            CommandName="Update" Text="Update"></asp:LinkButton>
                        &nbsp;<asp:LinkButton ID="LinkButton2" runat="server" CausesValidation="False" 
                            CommandName="Cancel" Text="Cancel"></asp:LinkButton>
                    </EditItemTemplate>
                    <FooterTemplate>
                        <asp:Button ID="btn_pridat" runat="server" onclick="btn_pridat_Click" 
                            Text="Pøidej zboží" />
                    </FooterTemplate>
                    <ItemTemplate>
                        <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" 
                            CommandName="Edit" Text="Edit"></asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <FooterStyle BackColor="#FFCC99" BorderColor="#FF6600" BorderStyle="Solid" 
                BorderWidth="1px" HorizontalAlign="Center" VerticalAlign="Middle" />
        </asp:GridView>
    </ContentTemplate>
        <Triggers>
        <asp:AsyncPostBackTrigger ControlID="BTN_vyhledej" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="ddl_pageSize" EventName="SelectedIndexChanged" />
        <asp:AsyncPostBackTrigger ControlID="GV_Objednavky" EventName="RowCommand" />
        </Triggers>
    </asp:UpdatePanel>
        <ajaxToolkit:UpdatePanelAnimationExtender ID="upae" BehaviorID="animation" runat="server" TargetControlID="updatePanel">
    <Animations>
        <OnUpdating>
            <Parallel duration="0">
                <ScriptAction Script="onUpdating();" />  
                <%-- disable the search button --%>                       
                <EnableAction AnimationTarget="BTN_vyhledej" Enabled="false" />
                <%-- fade-out the GridView --%>
                <FadeOut minimumOpacity=".5" />
             </Parallel>
        </OnUpdating>
        <OnUpdated>
                        <Parallel duration="0">
                            <%-- fade back in the GridView --%>
                            <FadeIn minimumOpacity=".5" />
                            <%-- re-enable the search button --%>  
                            <EnableAction AnimationTarget="BTN_vyhledej" Enabled="true" />
                            <%--find the update progress div and place it over the gridview control--%>
                            <ScriptAction Script="onUpdated();" /> 
                        </Parallel> 
                    </OnUpdated>
        </Animations>
</ajaxToolkit:UpdatePanelAnimationExtender>
   </div>     
    <%--ModalPopup zakaznika--%>
        <asp:Panel ID="pnlPopUp" runat="server" Width="400px" style="display:none" CssClass="detail">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
            <asp:Button id="btnShowPopup" runat="server" style="display:none" />
    		<ajaxToolKit:ModalPopupExtender ID="mdlPopup" runat="server" 
    		    TargetControlID="btnShowPopup" PopupControlID="pnlPopup" 
    		    CancelControlID="btnClose" BackgroundCssClass="modalBackground" 
    		/>
                <div align="center">
                    <asp:DetailsView ID="dtv_Zakaznik" runat="server" AutoGenerateRows="False" CssClass="detailgrid"
                        DataSourceID="DS_Zakaznik" EmptyDataText="Neni nic k zobrazeni" Visible="false"
                        Caption="Detail zákazníka">
                        <Fields>
                            <asp:BoundField DataField="Prijmeni" HeaderText="Pøíjmení" SortExpression="Prijmeni" />
                            <asp:BoundField DataField="Jmeno" HeaderText="Jméno" SortExpression="Jmeno" />
                            <asp:BoundField DataField="Telefon" HeaderText="Telefon" SortExpression="Telefon" />
                            <asp:BoundField DataField="Mesto" HeaderText="Mìsto" SortExpression="Mesto" />
                            <asp:BoundField DataField="Ulice" HeaderText="Ulice" SortExpression="Ulice" />
                            <asp:BoundField DataField="PSC" HeaderText="PSÈ" SortExpression="PSC" />
                            <asp:BoundField DataField="zem" HeaderText="Zemì" />
                            <asp:BoundField DataField="Firma" HeaderText="Název firmy" SortExpression="Firma" />
                            <asp:BoundField DataField="IC" HeaderText="IÈ" SortExpression="IC" />
                            <asp:BoundField DataField="DIC" HeaderText="DIÈ" SortExpression="DIC" />
                            <asp:BoundField DataField="FirmaAdresa" HeaderText="Název firmy (A)" SortExpression="FirmaAdresa" />
                            <asp:BoundField DataField="ICOAdresa" HeaderText="IÈ (A)" SortExpression="ICOAdresa" />
                            <asp:BoundField DataField="DICAdresa" HeaderText="DIÈ (A)" SortExpression="DICAdresa" />
                            <asp:BoundField DataField="F_mesto" HeaderText="Mìsto(f)" SortExpression="F_mesto" />
                            <asp:BoundField DataField="F_ulice" HeaderText="Ulice(f)" SortExpression="F_ulice" />
                            <asp:BoundField DataField="F_PSC" HeaderText="PSÈ(f)" SortExpression="F_PSC" />
                            <asp:BoundField DataField="Uzivatel" HeaderText="Uživatel" />
                            <asp:BoundField DataField="Heslo" HeaderText="Heslo" />
                        </Fields>
                        <AlternatingRowStyle BackColor="#CCCCCC" />
                        <HeaderStyle BackColor="#006666" />
                    </asp:DetailsView>
                </div>
                <div class="footer">
                    <asp:LinkButton ID="btnClose" runat="server" Text="Zavøít" CausesValidation="false" />
                </div>
            </ContentTemplate>
            <Triggers>
            <asp:AsyncPostBackTrigger ControlID="GV_Objednavky" EventName="RowCommand" />
            </Triggers>
            </asp:UpdatePanel>
        </asp:Panel>
        <br />
        <%-- Plovouci gif progressbar, margin-left je 1/2sirky gifu aby to bylo pekne v pulce--%> 
        <div style="position: absolute; left: 50%; top: 50%; margin-left:-107px">
            <div style="position: fixed;">
                <div id="updateProgressDiv" style="display: none; padding-top: 0px;">
                    <img src="../WebImages/progressBar.gif" />
                </div>
            </div>
        </div>
</asp:Content>

