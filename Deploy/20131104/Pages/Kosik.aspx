<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="false"
    CodeFile="Kosik.aspx.vb" Inherits="Pages_Kosik" %>

<%@ Import Namespace="Objednavka" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Hlavni" runat="Server">
    <h1>
        <asp:Localize ID="Localize1" runat="server" Text='<%$ Resources: popisBlok %>'></asp:Localize></h1>
    <div class="centr nazev">
        <asp:Localize ID="Localize2" runat="server" Text='<% $ Resources: obsahKosiku%>'></asp:Localize>
    </div>

            <asp:Label ID="lbl_stavObjednavky" runat="server" CssClass="prihlasen" Text="" Visible="false"></asp:Label>
            <asp:Repeater ID="RPT_VybraneZbozi" runat="server">
                <HeaderTemplate>
                    <table border="1px" width=600px style="border-collapse: collapse; margin-right: auto; margin-left: auto">
                        <tr style="font-family: Arial, Helvetica, sans-serif; font-size: x-small; font-style: italic;
                            color: #0066FF; font-weight: bold; background-color: #C1FDF7;" align="center">
                            <td>
                                <asp:Literal ID="Literal1" runat="server" Text="<%$ Resources: RPT_VybraneZbozi_Col1%>" />
                            </td>
                            <td>
                                <asp:Literal ID="Literal2" runat="server" Text="<%$ Resources: RPT_VybraneZbozi_Col2%>" />
                            </td>
                            <td>
                                <asp:Literal ID="Literal3" runat="server" Text="<%$ Resources: RPT_VybraneZbozi_Col3%>" />
                            </td>
                            <td>
                                <asp:Literal ID="Literal4" runat="server" Text="<%$ Resources: RPT_VybraneZbozi_Col13%>" />
                            </td>
                            <td style="width: 15%">
                                <asp:Literal ID="Literal5" runat="server" Text="<%$ Resources: RPT_VybraneZbozi_Col5%>" />
                            </td>
                            
                            <td style="width: 17%">
                                <asp:Literal ID="Literal6" runat="server" Text="<%$ Resources: RPT_VybraneZbozi_Col6%>" />
                            </td>
                            <td>
                            </td>
                        </tr>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td>
                            <%#CType(Container.DataItem, VybraneZbozi).objcislo%>
                        </td>
                        <%If CultureInfo.CurrentCulture.ToString = "cs-CZ" Then%>
                        <td>
                            <%#CType(Container.DataItem, VybraneZbozi).popis%>
                        </td>
                        <%Else%>
                        <td>
                            <%# CType(Container.DataItem, VybraneZbozi).popisEN%>
                        </td>
                        <%End If%>
                        <td>
                            <table width="100%">
                                <tr>
                                    <td rowspan="2">
                                        <%#CType(Container.DataItem, VybraneZbozi).mnozstvi.ToString + " " + CType(Container.DataItem, VybraneZbozi).jednotka%>
                                    </td>
                                    <td valign="bottom">
                                        <asp:ImageButton ID="IMB_plus" runat="server" ImageUrl="/WebImages/plus.png" CommandName="Plus"
                                            CommandArgument='<%#ctype(Container.DataItem,VybraneZbozi).objcislo %>' />
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">
                                        <asp:ImageButton ID="IMB_minus" runat="server" ImageUrl="/WebImages/minus.png" CommandName="Minus"
                                            CommandArgument='<%#ctype(Container.DataItem,VybraneZbozi).objcislo %>' />
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <%If prihlasen.VC Then%>
                        <td>
                            <%#Format(CType(Container.DataItem, VybraneZbozi).vc, "#,0.0 Kè")%>
                            <%If typZakaznika.cizinec Then%>
                            <br/>/<%#Format(CType(Container.DataItem, VybraneZbozi).vc_EUR, "#,0.00 €")%><%End If%></td>
                        <td>
                            <%#Format(CType(Container.DataItem, VybraneZbozi).soucetVC, "#,0.0 Kè")%>
                            <%If typZakaznika.cizinec Then%>
                            <br/>/<%#Format(CType(Container.DataItem, VybraneZbozi).soucetVC_EUR, "#,0.00 €")%><%End If%></td>
                        <td>
                            <%#Format(CType(Container.DataItem, VybraneZbozi).soucetVCDPH, "#,0.0 Kè")%>
                            <%If typZakaznika.cizinec Then%>
                            <br/>/<%#Format(CType(Container.DataItem, VybraneZbozi).soucetVCDPH_EUR, "#,0.00 €")%><%End If%></td>
                        <%Else%>
                        <td>
                            <%#Format(CType(Container.DataItem, VybraneZbozi).mc, "#,0.0 Kè")%>
                            <%If typZakaznika.cizinec Then%>
                            <br/>/<%#Format(CType(Container.DataItem, VybraneZbozi).mc_EUR, "#,0.00 €")%><%End If%></td>
                        <td>
                            <%#Format(CType(Container.DataItem, VybraneZbozi).soucetMC, "#,0.0 Kè")%>
                            <%If typZakaznika.cizinec Then%>
                            <br/>/<%#Format(CType(Container.DataItem, VybraneZbozi).soucetMC_EUR, "#,0.00 €")%><%End If%></td>
                        <td>
                            <%#Format(CType(Container.DataItem, VybraneZbozi).soucetMCDPH, "#,0.0 Kè")%>
                            <%If typZakaznika.cizinec Then%>
                            <br/>/<%#Format(CType(Container.DataItem, VybraneZbozi).soucetMCDPH_EUR, "#,0.00 €")%><%End If%></td>
                        <%End If%>
                        <td align="center">
                            <%--<asp:ImageButton ID="IMB_odstr" ImageUrl="~/WebImages/smaz.png" runat="server"  CommandName="Odstranit" CommandArgument='<%#ctype(Container.DataItem,VybraneZbozi).objcislo %>' ToolTip="Odeber z košíku" />--%>
                            <asp:Button ID="BTN_odstr" CssClass="button" runat="server" Text='<%$ Resources: BTN_odstr %>'
                                CommandName="Odstranit" CommandArgument='<%#ctype(Container.DataItem,VybraneZbozi).objcislo %>' />
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                    <tr>
                        <td colspan="5" align="right">
                            <asp:Literal ID="Literal6" runat="server" Text="<%$ Resources: RPT_footer%>" />
                            &nbsp;-&nbsp;
                        </td>
                        <td>
                            <%# Format(obj.sectiPolozky(CType(Session("zvoleneZbozi"), ArrayList), CInt(RBL_odber.SelectedValue), prihlasen.VC, "cs-CZ"), "#,0 Kè")%>
                            <%If typZakaznika.cizinec Then%>
                                <br />/<%# Format(obj.sectiPolozky(CType(Session("zvoleneZbozi"), ArrayList), CInt(RBL_odber.SelectedValue), prihlasen.VC, "EUR"), "#,0.00 €")%><%End If%></td>
                    </tr>
                    </table>
                </FooterTemplate>
            </asp:Repeater>

    
    <br />
    <asp:SqlDataSource ID="DS_Zakaznik" runat="server" ConnectionString="<%$ ConnectionStrings:DataHorejsi %>"
        InsertCommand="INSERT INTO T_Zakaznik(Prijmeni, Jmeno, Mail, Telefon, Mesto, Ulice, PSC, Uzivatel, Heslo, Staty_ID, FirmaAdresa, ICOAdresa, DICAdresa) VALUES (@Prijmeni, @Jmeno, @Mail, @Telefon, @Mesto, @Ulice, @PSC, @Uzivatel, @Heslo, @Staty_ID, @FirmaAdresa, @ICOAdresa, @DICAdresa)"
        SelectCommand="SELECT ID_zakaznik, Prijmeni, Jmeno, Mail, Telefon, Mesto, Ulice, IC, Firma, VC, PSC, DIC, F_mesto, F_ulice, F_PSC, Heslo, Uzivatel, Staty_ID, T_Staty.nazev as Stat_Nazev, FirmaAdresa, ICOAdresa, DICAdresa FROM T_Zakaznik join T_Staty on T_Zakaznik.Staty_ID = T_Staty.id_stat WHERE (ID_zakaznik = @ID_zakaznik) OR (Uzivatel = @Uzivatel)"
        UpdateCommand="UPDATE [T_Zakaznik] SET [Prijmeni] = @Prijmeni, [Jmeno] = @Jmeno, [Mail] = @Mail, [Telefon] = @Telefon, [Mesto] = @Mesto, [Ulice] = @Ulice, [IC] = @IC, [Firma] = @Firma, [VC] = @VC, [PSC] = @PSC, [DIC] = @DIC, [F_mesto] = @F_mesto, [F_ulice] = @F_ulice, [F_PSC] = @F_PSC, [Heslo] = @Heslo, [Uzivatel] = @Uzivatel, [FirmaAdresa] = @FirmaAdresa, [ICOAdresa] = @ICOAdresa, [DICAdresa] = @DICAdresa WHERE [ID_zakaznik] = @ID_zakaznik"
        >
        <SelectParameters>
            <asp:Parameter Name="ID_zakaznik" />
            <asp:Parameter Name="Uzivatel" />
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
            <asp:Parameter Name="IC" Type="Int32" />
            <asp:Parameter Name="Firma" Type="String" />
            <asp:Parameter Name="VC" Type="Boolean" />
            <asp:Parameter Name="PSC" Type="String" />
            <asp:Parameter Name="DIC" Type="String" />
            <asp:Parameter Name="F_mesto" Type="String" />
            <asp:Parameter Name="F_ulice" Type="String" />
            <asp:Parameter Name="F_PSC" Type="String" />
            <asp:Parameter Name="Heslo" Type="String" />
            <asp:Parameter Name="Uzivatel" Type="String" />
            <asp:Parameter Name="ID_zakaznik" Type="Int32" />
            <asp:Parameter Name="FirmaAdresa" Type="String" />
            <asp:Parameter Name="ICOAdresa" Type="String" />
            <asp:Parameter Name="DICAdresa" Type="String" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="FirmaAdresa" Type="String" />
            <asp:Parameter Name="ICOAdresa" Type="String" />
            <asp:Parameter Name="DICAdresa" Type="String" />
            <asp:Parameter Name="Prijmeni" Type="String" />
            <asp:Parameter Name="Jmeno" Type="String" />
            <asp:Parameter Name="Mail" Type="String" />
            <asp:Parameter Name="Telefon" Type="String" />
            <asp:Parameter Name="Mesto" Type="String" />
            <asp:Parameter Name="Ulice" Type="String" />
            <asp:Parameter Name="PSC" Type="String" />
            <asp:Parameter Name="Uzivatel" Type="String" />
            <asp:Parameter Name="Heslo" />
            <asp:Parameter Name="Staty_ID" Type="Int32" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DS_Objednavka" runat="server" ConnectionString="<%$ ConnectionStrings:DataHorejsi %>"
        InsertCommand="INSERT INTO T_Objednavky(ID_zakaznik, ID_objcislo, ID_objednavky, Mnozstvi, Datum_objednavky, Doprava, Datum_expedice) VALUES (@ID_zakaznik, @ID_objcislo, @ID_objednavky, @Mnozstvi, @Datum_objednavky, @Doprava, @Datum_expedice)"
        SelectCommand="SELECT [ID_zakaznik], [ID_objcislo], [ID_objednavky], [Mnozstvi], [Datum_objednavky], [Datum_expedice], [Doprava] FROM [T_Objednavky]">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DS_Staty" runat="server" ConnectionString="<%$ ConnectionStrings:DataHorejsi %>"
        ProviderName="<%$ ConnectionStrings:DataHorejsi.ProviderName %>" SelectCommand="SELECT id_stat, nazev, kod FROM T_Staty">
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="DS_Poznamky" runat="server" ConnectionString="<%$ ConnectionStrings:DataHorejsi %>"
        SelectCommand="SELECT [ID_Objednavky], [Text] FROM [T_Poznamky]">
     </asp:SqlDataSource>
    


    <div class="centr nazev">
        <asp:Localize ID="Localize3" runat="server" Text='<% $ Resources: doruceni%>'></asp:Localize>
    </div>
    
    <asp:RadioButtonList ID="RBL_odber" runat="server" 
        style="margin-right: auto; margin-left: auto" AutoPostBack="True" >
    </asp:RadioButtonList>
    
    <br />       
    <br />
    <div class="centr nazev">
        <asp:Label style="color:green" ID="lbl_cenaCelkem" runat="server" Text='<% $ Resources: totalPrice%>'></asp:Label>
    </div>
    <br />
    <br />

    <div class="centr nazev">
        <asp:Localize ID="Localize4" runat="server" Text='<% $ Resources: kontakt%>'></asp:Localize>
    </div>
    <br />
    
            <asp:FormView ID="FRV_zakaznik" runat="server" DataSourceID="DS_Zakaznik" Width="100%"
                DefaultMode="Insert">
                <InsertItemTemplate>
                    <table style="margin-right: auto; margin-left: auto">
                        <tr>
                            <td style="padding-left: 5px;" colspan="2">
                                <b>
                                    <asp:Literal ID="Literal6" runat="server" Text="<%$ Resources: FRV_title1%>" /></b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal36" runat="server" Text="<%$ Resources:FRV_row11 %>" />
                            </td>
                            <td>
                                <asp:TextBox ID="txb_insert_FirmaAdresa" runat="server" 
                                    Text='<%# Bind("FirmaAdresa") %>' MaxLength="100" Width="250px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                        <td  style="text-align: right">
                            <asp:Literal ID="Literal37" runat="server" Text="<%$ Resources:FRV_row12 %>" />
                            </td>
                        <td>
                            <asp:TextBox ID="txb_insert_ICOAdresa" runat="server" 
                                Text='<%# Bind("ICOAdresa") %>' MaxLength="10"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                        <td  style="text-align: right">
                            <asp:Literal ID="Literal38" runat="server" Text="<%$ Resources:FRV_row13 %>" />
                            </td>
                        <td>
                            <asp:TextBox ID="txb_insert_DICAdresa" runat="server" 
                                Text='<%# Bind("DICAdresa") %>' MaxLength="12"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal8" runat="server" Text="<%$ Resources: FRV_row1%>" />
                            </td>
                            <td>
                                <asp:TextBox ID="txb_insertPrijmeni" runat="server" 
                                    Text='<%# Bind("Prijmeni") %>' MaxLength="200" Width="250px"></asp:TextBox>
                                <asp:Label ID="Label2" runat="server" ForeColor="Red" Text="*"></asp:Label>
                                <asp:RequiredFieldValidator ID="val_prijmeni" runat="server" 
                                    ControlToValidate="txb_insertPrijmeni" Display="none" 
                                    ErrorMessage="<%$ Resources: VAL5 %>" ValidationGroup="valInsert"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender1" runat="server" 
                                    TargetControlID="val_prijmeni">
                                </cc1:ValidatorCalloutExtender>
                                <asp:RegularExpressionValidator ID="rval_prijmeni" runat="server" 
                                    ControlToValidate="txb_insertPrijmeni" Display="none" 
                                    ErrorMessage="<%$ Resources: VAL41%>" ValidationExpression="\D{2,}" 
                                    ValidationGroup="valInsert"></asp:RegularExpressionValidator>
                                <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender2" runat="server" 
                                    TargetControlID="rval_prijmeni">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal9" runat="server" Text="<%$ Resources: FRV_row2%>" />
                            </td>
                            <td>
                                <asp:TextBox ID="txb_insertJmeno" runat="server" Text='<%# Bind("Jmeno") %>' 
                                    MaxLength="50" Width="250px"></asp:TextBox>
                                <asp:Label ID="Label3" runat="server" ForeColor="Red" Text="*"></asp:Label>
                                <asp:RequiredFieldValidator ID="val_jmeno" runat="server" 
                                    ControlToValidate="txb_insertJmeno" Display="none" 
                                    ErrorMessage="<%$ Resources: VAL6 %>" ValidationGroup="valInsert"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender3" runat="server" 
                                    TargetControlID="val_jmeno">
                                </cc1:ValidatorCalloutExtender>
                                <asp:RegularExpressionValidator ID="rval_jmeno" runat="server" 
                                    ControlToValidate="txb_insertJmeno" Display="none" 
                                    ErrorMessage="<%$ Resources: VAL42%>" ValidationExpression="\D{2,}" 
                                    ValidationGroup="valInsert"></asp:RegularExpressionValidator>
                                <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender4" runat="server" 
                                    TargetControlID="rval_jmeno">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal10" runat="server" Text="<%$ Resources: FRV_row3%>" />
                            </td>
                            <td>
                                <asp:TextBox ID="txb_insertMail" runat="server" Text='<%# Bind("Mail") %>' 
                                    MaxLength="300" Width="200px"></asp:TextBox>
                                <asp:Label ID="Label4" runat="server" ForeColor="Red" Text="*"></asp:Label>
                                <asp:RequiredFieldValidator ID="val_mail" runat="server" 
                                    ControlToValidate="txb_insertMail" Display="none" 
                                    ErrorMessage="<%$ Resources: VAL7 %>" ValidationGroup="valInsert"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender5" runat="server" 
                                    TargetControlID="val_mail">
                                </cc1:ValidatorCalloutExtender>
                                <asp:RegularExpressionValidator ID="rval_mail" runat="server" 
                                    ControlToValidate="txb_insertMail" Display="none" 
                                    ErrorMessage="<%$ Resources: VAL3%>" 
                                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                                    ValidationGroup="valInsert"></asp:RegularExpressionValidator>
                                <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender6" runat="server" 
                                    TargetControlID="rval_mail">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal11" runat="server" Text="<%$ Resources: FRV_row4%>" />
                            </td>
                            <td>
                                <asp:TextBox ID="txb_insertTelefon" runat="server" 
                                    Text='<%# Bind("Telefon") %>' MaxLength="20"></asp:TextBox>
                                <asp:Label ID="Label5" runat="server" ForeColor="Red" Text="*"></asp:Label>
                                <asp:RequiredFieldValidator ID="val_telefon" runat="server" 
                                    ControlToValidate="txb_insertTelefon" Display="none" 
                                    ErrorMessage="<%$ Resources: VAL8 %>" ValidationGroup="valInsert"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender7" runat="server" 
                                    TargetControlID="val_telefon">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td align="left" class="hlavickaListProdukt" colspan="2" 
                                style="padding-left: 5px; ">
                                <b>
                                <asp:Literal ID="Literal12" runat="server" Text="<%$ Resources: FRV_title2%>" />
                                </b>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal33" runat="server" Text="<%$ Resources: FRV_row5%>" />
                            </td>
                            <td>
                                <asp:TextBox ID="txb_insertUlice" runat="server" Text='<%# Bind("Ulice") %>' 
                                    MaxLength="200" Width="250px"></asp:TextBox>
                                <asp:Label ID="Label6" runat="server" ForeColor="Red" Text="*"></asp:Label>
                                <asp:RequiredFieldValidator ID="val_ulice" runat="server" 
                                    ControlToValidate="txb_insertUlice" Display="none" 
                                    ErrorMessage="<%$ Resources: VAL9 %>" ValidationGroup="valInsert"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender8" runat="server" 
                                    TargetControlID="val_ulice">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal13" runat="server" Text="<%$ Resources: FRV_row6%>" />
                            </td>
                            <td>
                                <asp:TextBox ID="txb_insertMesto" runat="server" Text='<%# Bind("Mesto") %>' 
                                    MaxLength="200" Width="200px"></asp:TextBox>
                                <asp:Label ID="Label7" runat="server" ForeColor="Red" Text="*"></asp:Label>
                                <asp:RequiredFieldValidator ID="val_mesto" runat="server" 
                                    ControlToValidate="txb_insertMesto" Display="none" 
                                    ErrorMessage="<%$ Resources: VAL10 %>" ValidationGroup="valInsert"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender9" runat="server" 
                                    TargetControlID="val_mesto">
                                </cc1:ValidatorCalloutExtender>
                                <asp:RegularExpressionValidator ID="rval_mesto" runat="server" 
                                    ControlToValidate="txb_insertMesto" Display="none" 
                                    ErrorMessage="<%$ Resources: VAL21%>" ValidationExpression="\D{2,}\s*\W*\w*" 
                                    ValidationGroup="valInsert"></asp:RegularExpressionValidator>
                                <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender10" runat="server" 
                                    TargetControlID="rval_mesto">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal14" runat="server" Text="<%$ Resources: FRV_row7%>" />
                            </td>
                            <td>
                                <asp:TextBox ID="txb_insertPSC" runat="server" Text='<%# Bind("PSC") %>' 
                                    MaxLength="50" Width="70px"></asp:TextBox>
                                <asp:Label ID="Label8" runat="server" ForeColor="Red" Text="*"></asp:Label>
                                <asp:RequiredFieldValidator ID="val_psc" runat="server" 
                                    ControlToValidate="txb_insertPSC" Display="none" 
                                    ErrorMessage="<%$ Resources: VAL11 %>" ValidationGroup="valInsert"></asp:RequiredFieldValidator>
                                <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender11" runat="server" 
                                    TargetControlID="val_psc">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal34" runat="server" Text="<%$ Resources: FRV_row8%>" />
                            </td>
                            <td>
                                <asp:DropDownList ID="ddl_insertstat" runat="server" AutoPostBack="true" 
                                    DataSourceID="DS_Staty" DataTextField="nazev" DataValueField="id_stat" 
                                    OnDataBound="ddl_insertstat_DataBound" 
                                    OnSelectedIndexChanged="ddl_insertstat_SelectedIndexChanged" Width="155px">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td align="left" colspan="2" nowrap="nowrap" style="padding-left: 5px">
                                <asp:Literal ID="Literal15" runat="server" Text="<%$ Resources: FRV_title3%>" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal16" runat="server" Text="<%$ Resources: FRV_row5%>" />
                            </td>
                            <td>
                                <asp:TextBox ID="txb_insertFUlice" runat="server" Text='<%# Bind("F_ulice") %>' 
                                    MaxLength="200" Width="250px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal17" runat="server" Text="<%$ Resources: FRV_row6%>" />
                            </td>
                            <td>
                                <asp:TextBox ID="txb_insertFMesto" runat="server" Text='<%# Bind("F_Mesto") %>' 
                                    MaxLength="200" Width="200px"></asp:TextBox>
                                <asp:RegularExpressionValidator ID="rval_Fmesto" runat="server" 
                                    ControlToValidate="txb_insertFMesto" Display="none" 
                                    ErrorMessage="<%$ Resources:VAL21 %>" ValidationExpression="\D{2,}\s*\W*\w*" 
                                    ValidationGroup="valInsertB"></asp:RegularExpressionValidator>
                                <cc1:ValidatorCalloutExtender ID="ValidatorCalloutExtender12" runat="server" 
                                    TargetControlID="rval_Fmesto">
                                </cc1:ValidatorCalloutExtender>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal18" runat="server" Text="<%$ Resources: FRV_row7%>" />
                            </td>
                            <td>
                                <asp:TextBox ID="txb_insertFPSC" runat="server" Text='<%# Bind("F_PSC") %>' 
                                    MaxLength="50" Width="70px"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" nowrap="nowrap" style="padding-left: 5px">
                                <b>
                                <asp:Literal ID="Literal19" runat="server" Text="<%$ Resources: FRV_title4%>" />
                                </b>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height="80px" valign="top">
                                <asp:TextBox ID="txb_insertPoznamka" runat="server" EnableViewState="False" 
                                    Height="100%" TextMode="MultiLine" Width="100%"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: right">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                                <asp:Label ID="Label13" runat="server" ForeColor="Red" 
                                    Text="<%$ Resources: PovinnePole%>"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align: left">
                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
                                    HeaderText="<%$ Resources: HeaderErrorText%>" ShowMessageBox="True" 
                                    ValidationGroup="valInsert" />
                            </td>
                        </tr>
                        <tr>
                            <td align="center" colspan="2">
                                <asp:Button ID="BTN_objednatBezReg" runat="server" CommandName="Insert" 
                                    CssClass="button" Text="<%$ Resources: BTN_potvrdit %>" 
                                    ValidationGroup="valInsert" />
                            </td>
                        </tr>
                    </table>
                </InsertItemTemplate>
                <ItemTemplate>
                    <table >
                        <tr>
                            <td  colspan="2" style="padding-left: 5px; font-weight: 700;">
                                <asp:Literal ID="Literal81" runat="server" Text="<%$ Resources: FRV_title1%>" />
                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Pages/Registrace.aspx?ret=Kosik.aspx&update=1"
                                    Text="<%$ Resources: linkChangeRegistration%>"></asp:HyperLink>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal37" runat="server" Text="<%$ Resources: FRV_row11%>" />
                            </td>
                            <td >
                                <asp:Label ID="txb_FirmaAdresa" runat="server" Text='<%# Bind("FirmaAdresa") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal82" runat="server" Text="<%$ Resources: FRV_row12%>" />
                            </td>
                            <td>
                                <asp:Label ID="txb_ICOAdresa" runat="server" Text='<%# Bind("ICOAdresa") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal83" runat="server" Text="<%$ Resources: FRV_row13%>" />
                            </td>
                            <td>
                                <asp:Label ID="txb_DICAdresa" runat="server" Text='<%# Bind("DICAdresa") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal20" runat="server" Text="<%$ Resources: FRV_row1%>" />
                            </td>
                            <td >
                                <asp:Label ID="txb_Prijmeni" runat="server" Text='<%# Bind("Prijmeni") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal21" runat="server" Text="<%$ Resources: FRV_row2%>" />
                            </td>
                            <td>
                                <asp:Label ID="txb_Jmeno" runat="server" Text='<%# Bind("Jmeno") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal22" runat="server" Text="<%$ Resources: FRV_row3%>" />
                            </td>
                            <td>
                                <asp:Label ID="txb_Mail" runat="server" Text='<%# Bind("Mail") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal23" runat="server" Text="<%$ Resources: FRV_row4%>" />
                            </td>
                            <td>
                                <asp:Label ID="txb_Telefon" runat="server" Text='<%# Bind("Telefon") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="padding-left: 5px; font-weight: 700;">
                                <asp:Literal ID="Literal24" runat="server" Text="<%$ Resources: FRV_title2%>" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal25" runat="server" Text="<%$ Resources: FRV_row5%>" />
                            </td>
                            <td>
                                <asp:Label ID="txb_Ulice" runat="server" Text='<%# Bind("Ulice") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal26" runat="server" Text="<%$ Resources: FRV_row6%>" />
                            </td>
                            <td >
                                <asp:Label ID="txb_Mesto" runat="server" Text='<%# Bind("Mesto") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal27" runat="server" Text="<%$ Resources: FRV_row7%>" />
                            </td>
                            <td>
                                <asp:Label ID="txb_PSC" runat="server" Text='<%# Bind("PSC") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal35" runat="server" Text="<%$ Resources: FRV_row8%>" />
                            </td>
                            <td>
                                <asp:Label ID="lbl_Stat" runat="server" Text='<%# Bind("Stat_Nazev") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="padding-left: 5px" nowrap="nowrap" width="30%">
                                <asp:Literal ID="Literal28" runat="server" Text="<%$ Resources: FRV_title3%>" />
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal29" runat="server" Text="<%$ Resources: FRV_row5%>" />
                            </td>
                            <td>
                                <asp:Label ID="txb_FUlice" runat="server" Text='<%# Bind("F_ulice") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal30" runat="server" Text="<%$ Resources: FRV_row6%>" />
                            </td>
                            <td>
                                <asp:Label ID="txb_FMesto" runat="server" Text='<%# Bind("F_mesto") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: right">
                                <asp:Literal ID="Literal31" runat="server" Text="<%$ Resources: FRV_row7%>" />
                            </td>
                            <td>
                                <asp:Label ID="txb_FPSC" runat="server" Text='<%# Bind("F_PSC") %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td class="hlavickaListProdukt" colspan="2" nowrap="nowrap" style="padding-left: 5px">
                                <asp:Literal ID="Literal32" runat="server" Text="<%$ Resources: FRV_title4%>" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" height="80px" valign="top">
                                <asp:TextBox ID="txb_poznamka" runat="server" EnableViewState="False" Height="100%"
                                    TextMode="MultiLine" Width="100%"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                &nbsp;
                            </td>
                        </tr>
                        
                        <tr>
                            <td colspan="2" align="center">
                                <asp:Button ID="BTN_Objednat" runat="server" CssClass="button" OnClick="BTN_Objednat_Click"
                                    Text="<%$ Resources: BTN_potvrdit%>" ValidationGroup="valInsert" />
                                <br />
                                <cc1:ConfirmButtonExtender ID="ConfirmButtonExtender1" runat="server" ConfirmText="<%$ Resources: CBE_potvrdit%>"
                                    TargetControlID="BTN_Objednat" ConfirmOnFormSubmit="True">
                                </cc1:ConfirmButtonExtender>
                            </td>
                        </tr>
                    </table>
                </ItemTemplate>
            </asp:FormView>


</asp:Content>
