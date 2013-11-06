<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="false" CodeFile="Registrace.aspx.vb" Inherits="Pages_Registrace" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Hlavni" Runat="Server">
    <h1><asp:Localize ID="Localize1" runat="server" Text='<%$ Resources: popisBlok %>'></asp:Localize></h1>
<asp:SqlDataSource ID="DS_Zakaznik" runat="server" 
        ConnectionString="<%$ ConnectionStrings:DataHorejsi %>" 
        DeleteCommand="DELETE FROM [T_Zakaznik] WHERE [ID_zakaznik] = @ID_zakaznik" 
        InsertCommand="INSERT INTO T_Zakaznik(Prijmeni, Jmeno, Mail, Telefon, Mesto, Ulice, IC, Firma, VC, PSC, DIC, F_mesto, F_ulice, F_PSC, Heslo, Uzivatel, Obchodnik, Registrovan, Jazyk, Staty_ID) VALUES (@Prijmeni, @Jmeno, @Mail, @Telefon, @Mesto, @Ulice, @IC, @Firma, 0, @PSC, @DIC, @F_mesto, @F_ulice, @F_PSC, @Heslo, @Uzivatel, @Obchodnik, 1, @Jazyk, @Staty_ID)" 
        SelectCommand="SELECT ID_zakaznik, RTRIM(Prijmeni) AS Prijmeni, RTRIM(Jmeno) AS Jmeno, RTRIM(Mail) AS Mail, Telefon, RTRIM(Mesto) AS Mesto, Ulice, IC, Firma, VC, PSC, DIC, RTRIM(F_mesto) AS F_mesto, F_ulice, F_PSC, Heslo, Uzivatel, Obchodnik, Registrovan, Staty_ID FROM T_Zakaznik WHERE (ID_zakaznik = @ID_zakaznik)" 
        
        UpdateCommand="UPDATE T_Zakaznik SET Prijmeni = @Prijmeni, Jmeno = @Jmeno, Mail = @Mail, Telefon = @Telefon, Mesto = @Mesto, Ulice = @Ulice, IC = @IC, Firma = @Firma, PSC = @PSC, DIC = @DIC, F_mesto = @F_mesto, F_ulice = @F_ulice, F_PSC = @F_PSC, Staty_ID=@Staty_ID WHERE (ID_zakaznik = @ID_zakaznik)" 
        ProviderName="<%$ ConnectionStrings:DataHorejsi.ProviderName %>">
        <SelectParameters>
            <asp:CookieParameter CookieName="zakaznik" Name="ID_zakaznik" Type="Int32" />
        </SelectParameters>
        <DeleteParameters>
            <asp:Parameter Name="ID_zakaznik" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Prijmeni" Type="String" />
            <asp:Parameter Name="Jmeno" Type="String" />
            <asp:Parameter Name="Mail" Type="String" />
            <asp:Parameter Name="Telefon" Type="String" />
            <asp:Parameter Name="Mesto" Type="String" />
            <asp:Parameter Name="Ulice" Type="String" />
            <asp:Parameter Name="IC" Type="String" />
            <asp:Parameter Name="Firma" Type="String" />
            <asp:Parameter Name="PSC" Type="String" />
            <asp:Parameter Name="DIC" Type="String" />
            <asp:Parameter Name="F_mesto" Type="String" />
            <asp:Parameter Name="F_ulice" Type="String" />
            <asp:Parameter Name="F_PSC" Type="String" />
            <asp:Parameter Name="ID_zakaznik" Type="Int32" />
            <asp:Parameter Name="Staty_ID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="Prijmeni" Type="String" />
            <asp:Parameter Name="Jmeno" Type="String" />
            <asp:Parameter Name="Mail" Type="String" />
            <asp:Parameter Name="Telefon" Type="String" />
            <asp:Parameter Name="Mesto" Type="String" />
            <asp:Parameter Name="Ulice" Type="String" />
            <asp:Parameter Name="IC" Type="String" />
            <asp:Parameter Name="Firma" Type="String" />
            <asp:Parameter Name="PSC" Type="String" />
            <asp:Parameter Name="DIC" Type="String" />
            <asp:Parameter Name="F_mesto" Type="String" />
            <asp:Parameter Name="F_ulice" Type="String" />
            <asp:Parameter Name="F_PSC" Type="String" />
            <asp:Parameter Name="Heslo" Type="String" />
            <asp:Parameter Name="Uzivatel" Type="String" DefaultValue="" />
            <asp:Parameter Name="Obchodnik" Type="Boolean" DefaultValue="False" />
            <asp:Parameter Name="Jazyk" Type="String" DefaultValue="" />
            <asp:Parameter Name="Staty_ID" Type="Int32" />
        </InsertParameters>
    </asp:SqlDataSource>
<asp:SqlDataSource ID="DS_Staty" runat="server" 
        ConnectionString="<%$ ConnectionStrings:DataHorejsi %>" 
        ProviderName="<%$ ConnectionStrings:DataHorejsi.ProviderName %>" 
        SelectCommand="SELECT id_stat, nazev, kod FROM T_Staty"></asp:SqlDataSource>

<div class="registrace">    
    <asp:FormView ID="FRV_zakaznik" runat="server" DataSourceID="DS_Zakaznik" 
        DefaultMode="Insert" HorizontalAlign="Center">
        <InsertItemTemplate>
            <table>
                <tr>
                    <td class="nazev" colspan="2">
                        <asp:Literal ID="Literal1" runat="server" Text="<%$ Resources: FRV_title1%>" /></td>
                </tr>
                <tr>
                    <td style="text-align: right; " >
                        <asp:Literal ID="Literal2" runat="server" Text="<%$ Resources: FRV_row1%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_insertPrijmeni" runat="server" 
                            Text='<%# Bind("Prijmeni") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="val_prijmeni" runat="server" 
                            ControlToValidate="txb_insertPrijmeni" Display="None" ErrorMessage="<%$ Resources: VAL6%>" 
                            ValidationGroup="valInsert"></asp:RequiredFieldValidator>
                        <cc1:ValidatorCalloutExtender ID="val_prijmeni_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="val_prijmeni">
                        </cc1:ValidatorCalloutExtender>
                        <asp:RegularExpressionValidator ID="rval_prijmeni" runat="server" 
                            ControlToValidate="txb_insertPrijmeni" Display="None" 
                            ErrorMessage="<%$ Resources: VAL1%>" ValidationExpression="\D{3,}" 
                            ValidationGroup="valInsert"></asp:RegularExpressionValidator>
                            <cc1:ValidatorCalloutExtender ID="rval_prijmeni_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="rval_prijmeni">
                        </cc1:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; " >
                        <asp:Literal ID="Literal3" runat="server" Text="<%$ Resources: FRV_row2%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_insertJmeno" runat="server" 
                            Text='<%# Bind("Jmeno") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="val_jmeno" runat="server" 
                            ControlToValidate="txb_insertJmeno" Display="None" ErrorMessage="<%$ Resources: VAL6%>"
                            ValidationGroup="valInsert"></asp:RequiredFieldValidator>
                        <cc1:ValidatorCalloutExtender ID="val_jmeno_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="val_jmeno">
                        </cc1:ValidatorCalloutExtender>
                        <asp:RegularExpressionValidator ID="rval_jmeno" runat="server" 
                            ControlToValidate="txb_insertJmeno" Display="None" 
                            ErrorMessage="<%$ Resources: VAL1%>" ValidationExpression="\D{3,}" 
                            ValidationGroup="valInsert"></asp:RegularExpressionValidator>
                            <cc1:ValidatorCalloutExtender ID="rval_jmeno_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="rval_jmeno">
                        </cc1:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; " >
                        <asp:Literal ID="Literal4" runat="server" Text="<%$ Resources: FRV_row3%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_insertMail" runat="server" Text='<%# Bind("Mail") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="val_mail" runat="server" 
                            ControlToValidate="txb_insertMail" Display="None" ErrorMessage="<%$ Resources: VAL6%>" 
                            ValidationGroup="valInsert"></asp:RequiredFieldValidator>
                            <cc1:ValidatorCalloutExtender ID="val_mail_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="val_mail">
                        </cc1:ValidatorCalloutExtender>
                        <asp:RegularExpressionValidator ID="rval_mail" runat="server" 
                            ControlToValidate="txb_insertMail" Display="None" 
                            ErrorMessage="<%$ Resources: VAL2%>" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                            ValidationGroup="valInsert"></asp:RegularExpressionValidator>
                            <cc1:ValidatorCalloutExtender ID="rval_mail_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="rval_mail">
                        </cc1:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; " >
                        <asp:Literal ID="Literal5" runat="server" Text="<%$ Resources: FRV_row4%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_insertTelefon" runat="server" 
                            Text='<%# Bind("Telefon") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="val_telefon" runat="server" 
                            ControlToValidate="txb_insertTelefon" Display="None" ErrorMessage="<%$ Resources: VAL6%>" 
                            ValidationGroup="valInsert"></asp:RequiredFieldValidator>
                            <cc1:ValidatorCalloutExtender ID="val_ins_telefon_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="val_telefon">
                            </cc1:ValidatorCalloutExtender>
                    </td>    
                </tr>
                <tr>
                    <td style="text-align: right; " >
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
                
                <tr>
                    <td colspan="2" style="cursor:pointer">
                        <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" runat="server"
                        TargetControlID="ContentPanel"
                        ExpandControlID="TitlePanel" 
                        CollapseControlID="TitlePanel" 
                        Collapsed="True"
                        TextLabelID="Popis" 
                        ExpandedText='<%$Resources: CollapsiblePanelExtender1.ExpandedText %>' 
                        CollapsedText='<%$Resources: CollapsiblePanelExtender1.CollapsedText %>'
                        ImageControlID="Image1" 
                        ExpandedImage="../WebImages/collapse.jpg" 
                        CollapsedImage="../WebImages/expand.jpg"
                        ExpandDirection="Vertical"
                        SuppressPostBack="true">
                        </cc1:CollapsiblePanelExtender>
                        <asp:Panel ID="TitlePanel" runat="server"> 
                        <asp:Image ID="Image1" runat="server" ImageUrl="../WebImages/expand.jpg" />&nbsp;
                           <asp:Label ID="Label1" runat="server" CssClass="nazev" Text="<%$ Resources: FRV_title2%>"></asp:Label> &nbsp;
                           <asp:Label ID="Popis" runat="server" Text='<%$Resources: Popis.Text %>'></asp:Label>
                        </asp:Panel>
                        <asp:Panel ID="ContentPanel" runat="server">
                        <p style="text-align:justify; margin-top:5px; width:290px">
                        <asp:Literal ID="Literal7" runat="server" Text="<%$ Resources: CLP_description%>" /></p>
                        <table>
                        <tr><td style="text-align: right"><asp:Literal ID="Literal8" runat="server" Text="<%$ Resources: FRV_row5%>" /></td>
                        <td align="center">
                            <asp:TextBox ID="txb_insertFirma" runat="server" Text='<%# Bind("Firma") %>'></asp:TextBox></td>
                        </tr>
                            <tr>
                                <td style="text-align: right">
                                    <asp:Literal ID="Literal9" runat="server" Text="<%$ Resources: FRV_row6%>" /></td>
                                <td align="center">
                                    <asp:TextBox ID="txb_insertICO" runat="server" Text='<%# Bind("IC") %>'></asp:TextBox>
                                    <asp:RegularExpressionValidator ID="rval_ICO" runat="server" 
                            ControlToValidate="txb_insertICO" Display="None" 
                            ErrorMessage="<%$ Resources: VAL7%>" ValidationExpression="\s*.+\s*" 
                            ValidationGroup="valInsert"></asp:RegularExpressionValidator>
                            <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender1" 
                            runat="server" Enabled="True" TargetControlID="rval_ICO">
                        </cc1:ValidatorCalloutExtender>
                                </td>
                            </tr>
                            <%If CultureInfo.CurrentCulture.ToString = "cs-CZ" Then%>
                            <tr>
                                <td style="text-align: right">
                                    <asp:Literal ID="Literal10" runat="server" Text="<%$ Resources: FRV_row7%>" /></td>
                                <td align="center">
                                    <asp:TextBox ID="txb_insertDIC" runat="server" Text='<%# Bind("DIC") %>'></asp:TextBox>
                                </td>
                            </tr>
                            <%End If%>
                        </table>
                        </asp:Panel>
                    </td>
                </tr>
                
                <tr>
                    <td style="text-align: right; " >
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
                
                <tr>
                    <td colspan="2" class="nazev"><asp:Literal ID="Literal11" runat="server" Text="<%$ Resources: FRV_title3%>" /></td>
                </tr>
                <tr>
                    <td style="text-align: right; " >
                       <asp:Literal ID="Literal12" runat="server" Text="<%$ Resources: FRV_row8%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_insertMesto" runat="server" Text='<%# Bind("Mesto") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="val_mesto" runat="server" 
                            ControlToValidate="txb_insertMesto" Display="None" ErrorMessage="<%$ Resources: VAL6%>" 
                            ValidationGroup="valInsert"></asp:RequiredFieldValidator>
                            <cc1:ValidatorCalloutExtender ID="val_mesto_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="val_mesto">
                            </cc1:ValidatorCalloutExtender>
                        <asp:RegularExpressionValidator ID="rval_mesto" runat="server" 
                            ControlToValidate="txb_insertMesto" Display="None" 
                            ErrorMessage="<%$ Resources: VAL3%>" ValidationExpression="\D{2,}\s*\d*" 
                            ValidationGroup="valInsert"></asp:RegularExpressionValidator>
                            <cc1:ValidatorCalloutExtender ID="rval_mesto_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="rval_mesto">
                            </cc1:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; " >
                        <asp:Literal ID="Literal13" runat="server" Text="<%$ Resources: FRV_row9%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_insertUlice" runat="server" Text='<%# Bind("Ulice") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="val_ulice" runat="server" 
                            ControlToValidate="txb_insertUlice" Display="None" ErrorMessage="<%$ Resources: VAL6%>"
                            ValidationGroup="valInsert"></asp:RequiredFieldValidator>
                            <cc1:ValidatorCalloutExtender ID="val_ulice_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="val_ulice">
                            </cc1:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; " >
                        <asp:Literal ID="Literal14" runat="server" Text="<%$ Resources: FRV_row10%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_insertPSC" runat="server" Text='<%# Bind("PSC") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="val_psc" runat="server" 
                            ControlToValidate="txb_insertPSC" Display="None" ErrorMessage="<%$ Resources: VAL6%>" 
                            ValidationGroup="valInsert"></asp:RequiredFieldValidator>
                            <cc1:ValidatorCalloutExtender ID="val_psc_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="val_psc">
                            </cc1:ValidatorCalloutExtender>
                        
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; " >
                        <asp:Literal ID="Literal23" runat="server" Text="<%$ Resources: FRV_row14%>"></asp:Literal>
                    </td>
                    <td  >
                        <asp:DropDownList ID="ddl_insertstat" runat="server" DataSourceID="DS_Staty" 
                            DataTextField="nazev" DataValueField="id_stat" CssClass="zeme"  
                            ondatabound="ddl_insertstat_DataBound">
                        </asp:DropDownList>
                    </td>
                </tr>
                 <tr>
                    <td style="text-align: right; ">
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
                <tr>
                    <td align="left" colspan="2">
                        <asp:Label ID="Label2" CssClass="nazev" runat="server" Text="<%$ Resources: FRV_title4%>"></asp:Label>
                        <asp:Label ID="Label3"  runat="server" Text="<%$ Resources: FRV_title4_1%>"></asp:Label></td>
                    
                </tr>
                <tr>
                    <td style="text-align: right">
                        <asp:Literal ID="Literal18" runat="server" Text="<%$ Resources: FRV_row8%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_insertFMesto" runat="server" Text='<%# Bind("F_mesto") %>'></asp:TextBox>
                        <asp:RegularExpressionValidator ID="rval_Fmesto" runat="server" 
                            ControlToValidate="txb_insertFMesto" Display="None" 
                            ErrorMessage="<%$ Resources: VAL3%>" ValidationExpression="\D{2,}\s*\d*" 
                            ValidationGroup="valInsert"></asp:RegularExpressionValidator>
                            <cc1:ValidatorCalloutExtender ID="rval_Fmesto_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="rval_Fmesto">
                            </cc1:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">
                        <asp:Literal ID="Literal17" runat="server" Text="<%$ Resources: FRV_row9%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_insertFUlice" runat="server" 
                             Text='<%# Bind("F_ulice") %>'></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">
                        <asp:Literal ID="Literal16" runat="server" Text="<%$ Resources: FRV_row10%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_insertFPSC" runat="server" Text='<%# Bind("F_PSC") %>'></asp:TextBox>
                        
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; ">
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
                
               
                <tr>
                    <td align="left" colspan="2" style="padding-left: 5px;" class="nazev" >
                        <asp:Literal ID="Literal19" runat="server" Text="<%$ Resources: FRV_title5%>" /></td>
                </tr>
                <tr>
                    <td style="text-align: right; " >
                        <asp:Literal ID="Literal20" runat="server" Text="<%$ Resources: FRV_row11%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_insertUziv" runat="server" Width="155px" Text='<%# Bind("Uzivatel") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="val_uzivatel" runat="server" 
                            ControlToValidate="txb_insertUziv" Display="None" ErrorMessage="<%$ Resources: VAL6%>"
                            ValidationGroup="valInsert"></asp:RequiredFieldValidator>
                            <cc1:ValidatorCalloutExtender ID="val_uzivatel_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="val_uzivatel">
                            </cc1:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right" >
                        <asp:Literal ID="Literal21" runat="server" Text="<%$ Resources: FRV_row12%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_insertHeslo" runat="server" Text='<%# Bind("Heslo") %>' 
                            TextMode="Password" Width="155px"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="val_heslo" runat="server" 
                            ControlToValidate="txb_insertHeslo" Display="None" ErrorMessage="<%$ Resources: VAL6%>"
                            ValidationGroup="valInsert"></asp:RequiredFieldValidator>
                            <cc1:ValidatorCalloutExtender ID="val_heslo_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="val_heslo">
                            </cc1:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right" >
                        <asp:Literal ID="Literal22" runat="server" Text="<%$ Resources: FRV_row13%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_insertHeslo2" runat="server" 
                            TextMode="Password" Width="155px"></asp:TextBox>
                        <asp:CompareValidator ID="CompareValidator1" runat="server" 
                            ControlToCompare="txb_insertHeslo" ControlToValidate="txb_insertHeslo2" 
                            Display="None" ErrorMessage="<%$ Resources: VAL5%>" 
                            ValidationGroup="valInsert"></asp:CompareValidator>
                            <cc1:ValidatorCalloutExtender ID="CompareValidator1_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="CompareValidator1">
                            </cc1:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="2" >
                        &nbsp;</td>
                </tr>
                <tr>
                    <td align="center" colspan="2" >
                        <asp:Button ID="BTN_registrace" runat="server" CommandName="insert" CssClass="button" 
                            Text='<%$Resources: BTN_registrace.Text %>' ValidationGroup="valInsert" />
                    </td>
                </tr>
            </table>
        </InsertItemTemplate>
        <EditItemTemplate>
        <table class="obsah" >
                <tr>
                    <td style="text-align: left; padding-left: 5px;" colspan="2" 
                        class="nazev" >
                        <asp:Literal ID="Literal1" runat="server" Text="<%$ Resources: FRV_title1%>" /></td>
                </tr>
                <tr>
                    <td style="text-align: right; " >
                        <asp:Literal ID="Literal2" runat="server" Text="<%$ Resources: FRV_row1%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_updatePrijmeni" runat="server" 
                            Text='<%# Bind("Prijmeni") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="val_prijmeni" runat="server" 
                            ControlToValidate="txb_updatePrijmeni" Display="None" ErrorMessage="<%$ Resources: VAL6%>"
                            ValidationGroup="valUpdate"></asp:RequiredFieldValidator>
                            <cc1:ValidatorCalloutExtender ID="val_prijmeni_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="val_prijmeni">
                            </cc1:ValidatorCalloutExtender>
                        <asp:RegularExpressionValidator ID="rval_prijmeni" runat="server" 
                            ControlToValidate="txb_updatePrijmeni" Display="None" 
                            ErrorMessage="<%$ Resources: VAL1%>" ValidationExpression="\D{3,}" 
                            ValidationGroup="valUpdate"></asp:RegularExpressionValidator>
                            <cc1:ValidatorCalloutExtender ID="rval_prijmeni_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="rval_prijmeni">
                            </cc1:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; " >
                        <asp:Literal ID="Literal3" runat="server" Text="<%$ Resources: FRV_row2%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_updateJmeno" runat="server" 
                            Text='<%# Bind("Jmeno") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="val_jmeno" runat="server" 
                            ControlToValidate="txb_updateJmeno" Display="None" ErrorMessage="<%$ Resources: VAL6%>" 
                            ValidationGroup="valUpdate"></asp:RequiredFieldValidator>
                            <cc1:ValidatorCalloutExtender ID="val_jmeno_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="val_jmeno">
                            </cc1:ValidatorCalloutExtender>
                        <asp:RegularExpressionValidator ID="rval_jmeno" runat="server" 
                            ControlToValidate="txb_updateJmeno" Display="None" 
                            ErrorMessage="<%$ Resources: VAL1%>" ValidationExpression="\D{3,}" 
                            ValidationGroup="valUpdate"></asp:RegularExpressionValidator>
                            <cc1:ValidatorCalloutExtender ID="rval_jmeno_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="rval_jmeno">
                            </cc1:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; " >
                        <asp:Literal ID="Literal4" runat="server" Text="<%$ Resources: FRV_row3%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_updateMail" runat="server" Text='<%# Bind("Mail") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="val_mail" runat="server" 
                            ControlToValidate="txb_updateMail" Display="None" ErrorMessage="<%$ Resources: VAL6%>" 
                            ValidationGroup="valUpdate"></asp:RequiredFieldValidator>
                            <cc1:ValidatorCalloutExtender ID="val_mail_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="val_mail">
                            </cc1:ValidatorCalloutExtender>
                        <asp:RegularExpressionValidator ID="rval_mail" runat="server" 
                            ControlToValidate="txb_updateMail" Display="None" 
                            ErrorMessage="<%$ Resources: VAL2%>" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                            ValidationGroup="valUpdate"></asp:RegularExpressionValidator>
                            <cc1:ValidatorCalloutExtender ID="rval_mail_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="rval_mail">
                            </cc1:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; " >
                        <asp:Literal ID="Literal5" runat="server" Text="<%$ Resources: FRV_row4%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_updateTelefon" runat="server" 
                            Text='<%# Bind("Telefon") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="val_telefon" runat="server" 
                            ControlToValidate="txb_updateTelefon" Display="None" ErrorMessage="<%$ Resources: VAL6%>"
                            ValidationGroup="valUpdate"></asp:RequiredFieldValidator>
                            <cc1:ValidatorCalloutExtender ID="val_telefon_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="val_telefon">
                            </cc1:ValidatorCalloutExtender>
                    </td>    
                </tr>
                <tr>
                    <td style="text-align: right; " >
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
                
                <tr>
                    <td colspan="2" style="text-align: left; ">
                        <cc1:CollapsiblePanelExtender ID="CollapsiblePanelExtender1" runat="server"
                        TargetControlID="ContentPanel"
                        ExpandControlID="TitlePanel" 
                        CollapseControlID="TitlePanel" 
                        Collapsed="True"
                        TextLabelID="Popis" 
                        ExpandedText='<%$Resources: CollapsiblePanelExtender1.ExpandedText %>' 
                        CollapsedText='<%$Resources: CollapsiblePanelExtender1.CollapsedText %>'
                        ImageControlID="Image1" 
                        ExpandedImage="~/WebImages/collapse.jpg" 
                        CollapsedImage="~/WebImages/expand.jpg"
                        ExpandDirection="Vertical"
                        SuppressPostBack="true">
                        </cc1:CollapsiblePanelExtender>
                        <asp:Panel ID="TitlePanel" runat="server" CssClass="hlavickaCollapse"> 
                        <asp:Image ID="Image1" runat="server" ImageUrl="~/WebImages/expand.jpg" />&nbsp;
                           <asp:Literal ID="Literal6" runat="server" Text="<%$ Resources: FRV_title2%>" /> &nbsp;&nbsp;
                           <asp:Label ID="Popis" runat="server" Text='<%$Resources: Popis.Text %>'></asp:Label>
                        </asp:Panel>
                        <asp:Panel ID="ContentPanel" runat="server" CssClass="collapsePanel">
                        <p style="text-align:justify; margin-top:5px">
                        <asp:Literal ID="Literal7" runat="server" Text="<%$ Resources: CLP_description%>" /></p>
                        <table class="obsah">
                        <tr><td style="text-align: right"><asp:Literal ID="Literal8" runat="server" Text="<%$ Resources: FRV_row5%>" /></td>
                        <td align="center">
                            <asp:TextBox ID="txb_updateFirma" runat="server" Text='<%# Bind("Firma") %>'></asp:TextBox></td>
                        </tr>
                            <tr>
                                <td style="text-align: right">
                                    <asp:Literal ID="Literal9" runat="server" Text="<%$ Resources: FRV_row6%>" /></td>
                                <td align="center">
                                    <asp:TextBox ID="txb_updateICO" runat="server" Text='<%# Bind("IC") %>'></asp:TextBox>
                                </td>
                            </tr>
                            <%If CultureInfo.CurrentCulture.ToString = "cs-CZ" Then%>
                            <tr>
                                <td style="text-align: right">
                                    <asp:Literal ID="Literal10" runat="server" Text="<%$ Resources: FRV_row7%>" /></td>
                                <td align="center">
                                    <asp:TextBox ID="txb_updateDIC" runat="server" Text='<%# Bind("DIC") %>'></asp:TextBox>
                                </td>
                            </tr>
                            <%End If%>
                        </table>
                        </asp:Panel>
                    </td>
                </tr>
                
                <tr>
                    <td style="text-align: right" >
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
                
                <tr>
                    <td colspan="2" align="center" 
                        style="text-align: left; padding-left: 5px;" class="hlavickaListProdukt" 
                        ><asp:Literal ID="Literal11" runat="server" Text="<%$ Resources: FRV_title3%>" /></td>
                </tr>
                <tr>
                    <td style="text-align: right" >
                       <asp:Literal ID="Literal12" runat="server" Text="<%$ Resources: FRV_row8%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_updateMesto" runat="server" Text='<%# Bind("Mesto") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="val_mesto" runat="server" 
                            ControlToValidate="txb_updateMesto" Display="None" ErrorMessage="<%$ Resources: VAL6%>" 
                            ValidationGroup="valUpdate"></asp:RequiredFieldValidator>
                            <cc1:ValidatorCalloutExtender ID="val_mesto_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="val_mesto">
                            </cc1:ValidatorCalloutExtender>
                        <asp:RegularExpressionValidator ID="rval_mesto" runat="server" 
                            ControlToValidate="txb_updateMesto" Display="None" 
                            ErrorMessage="<%$ Resources: VAL3%>" ValidationExpression="\D{2,}\s*\d*" 
                            ValidationGroup="valUpdate"></asp:RegularExpressionValidator>
                            <cc1:ValidatorCalloutExtender ID="rval_mesto_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="rval_mesto">
                            </cc1:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right" >
                        <asp:Literal ID="Literal13" runat="server" Text="<%$ Resources: FRV_row9%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_updateUlice" runat="server" Text='<%# Bind("Ulice") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="val_ulice" runat="server" 
                            ControlToValidate="txb_updateUlice" Display="None" ErrorMessage="<%$ Resources: VAL6%>" 
                            ValidationGroup="valUpdate"></asp:RequiredFieldValidator>
                            <cc1:ValidatorCalloutExtender ID="val_ulice_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="val_ulice">
                            </cc1:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; " >
                        <asp:Literal ID="Literal14" runat="server" Text="<%$ Resources: FRV_row10%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_updatePSC" runat="server" Text='<%# Bind("PSC") %>'></asp:TextBox>
                        <asp:RequiredFieldValidator ID="val_psc" runat="server" 
                            ControlToValidate="txb_updatePSC" Display="None" ErrorMessage="<%$ Resources: VAL6%>" 
                            ValidationGroup="valUpdate"></asp:RequiredFieldValidator>
                            <cc1:ValidatorCalloutExtender ID="val_psc_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="val_psc">
                            </cc1:ValidatorCalloutExtender>
                        
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; ">
                        <asp:Literal ID="Literal23" runat="server" Text="<%$ Resources: FRV_row14%>"></asp:Literal>
                    </td>
                    <td>
                        <asp:DropDownList ID="ddl_updateStat" runat="server" DataSourceID="DS_Staty" 
                            DataTextField="nazev" DataValueField="id_stat" selectedValue='<%# Bind("Staty_ID") %>' 
                            Width="149px">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; " >
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
                <tr>
                    <td align="left" class="hlavickaListProdukt" colspan="2" 
                        style="padding-left: 5px">
                        <asp:Literal ID="Literal15" runat="server" Text="<%$ Resources: FRV_title4%>" /></td>
                </tr>
                <tr>
                    <td style="text-align: right">
                        <asp:Literal ID="Literal118" runat="server" Text="<%$ Resources: FRV_row8%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_updateFMesto" runat="server" Text='<%# Bind("F_mesto") %>'></asp:TextBox>
                        <asp:RegularExpressionValidator ID="rval_Fmesto" runat="server" 
                            ControlToValidate="txb_updateFMesto" Display="None" 
                            ErrorMessage="<%$ Resources: VAL3%>" ValidationExpression="\D{2,}\s*\d*" 
                            ValidationGroup="valUpdate"></asp:RegularExpressionValidator>
                            <cc1:ValidatorCalloutExtender ID="rval_Fmesto_ValidatorCalloutExtender" 
                            runat="server" Enabled="True" TargetControlID="rval_Fmesto">
                            </cc1:ValidatorCalloutExtender>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">
                        <asp:Literal ID="Literal17" runat="server" Text="<%$ Resources: FRV_row9%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_updateFUlice" runat="server" 
                             Text='<%# Bind("F_ulice") %>'></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right">
                        <asp:Literal ID="Literal16" runat="server" Text="<%$ Resources: FRV_row10%>" /></td>
                    <td>
                        <asp:TextBox ID="txb_updateFPSC" runat="server" Text='<%# Bind("F_PSC") %>'></asp:TextBox>
                        
                    </td>
                </tr>
                <tr>
                    <td style="text-align: right; ">
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
                
                <tr>
                    <td align="center" colspan="2" >
                        <asp:Button ID="BTN_updateregistrace" runat="server" CommandName="Update" CssClass="button"
                            Text='<%$Resources: BTN_updateregistrace.Text %>' ValidationGroup="valUpdate" />
                    </td>
                </tr>
            </table>
        </EditItemTemplate>
    </asp:FormView>
</div>
</asp:Content>

