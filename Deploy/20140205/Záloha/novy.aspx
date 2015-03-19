  <div class="centr">

    <div class="strankovani">
      <div class="strankovaninapln">
        <div style="float: left">
          <asp:Label ID="lbl_Pocet" runat="server" Text="<%$ Resources:LBL_pocet %>"></asp:Label>


          <asp:DropDownList ID="ddl_pageSize" runat="server" AutoPostBack="True" CssClass="listPocet" Visible="true">
            <asp:ListItem>5</asp:ListItem>
            <%--<asp:ListItem Selected="True">10</asp:ListItem> --%>
            <asp:ListItem>10</asp:ListItem>
            <asp:ListItem>20</asp:ListItem>
            <asp:ListItem>40</asp:ListItem>
            <asp:ListItem>80</asp:ListItem>
            <asp:ListItem>100</asp:ListItem>
          </asp:DropDownList>
        </div>

        <div style="float: right">
          <asp:Label ID="Label1" runat="server" Text="<%$ Resources: LBL_page %>"></asp:Label>
          <asp:DataPager ID="DataPager2" PagedControlID="LSV_Produkty" PageSize="10" runat="server">
            <Fields>
              <asp:NumericPagerField
                PreviousPageText="&lt;"
                NextPageText="&gt;"
                ButtonCount="5"
                NextPreviousButtonCssClass="PrevNext"
                CurrentPageLabelCssClass="activ"
                NumericButtonCssClass="PageNumber" />
            </Fields>
          </asp:DataPager>
        </div>
        <div style="margin-left: 25px; float: left;">
          <asp:ImageButton ID="ImageButton2" runat="server" ImageUrl="~/WebImages/list125.png" ToolTip="<%$ Resources: lsv_layout_1%>" />
          <asp:ImageButton ID="ImageButton1" runat="server" ImageUrl="~/WebImages/list225.png" ToolTip="<%$ Resources: lsv_layout_2%>" />
        </div>
      </div>
    </div>
    <%If Layout = 0 Then%>
    <div class="seznamproduktu1">
      <%Else%>
      <div class="seznamproduktu2">
        <%End If%>
        <asp:ListView ID="LSV_Produkty" runat="server" DataSourceID="DS_Produkty" GroupItemCount="2">
          <LayoutTemplate>
            <table runat="server">
              <tr id="groupPlaceholder" runat="server"></tr>
            </table>
          </LayoutTemplate>
          <GroupTemplate>
            <tr runat="server" id="tableRow">
              <td runat="server" id="itemPlaceholder" />
            </tr>
          </GroupTemplate>
          <ItemTemplate>
            <%If Layout = 0 Then%>
            <div class="produkt1">
              <div class="nahled1">
                <asp:HyperLink ID="hl_Navigace" runat="server" NavigateUrl="" ImageUrl="" ToolTip=""></asp:HyperLink>
              </div>
              <div class="produktinfo1">
                <div class="nazev1">
                  <strong>
                    <asp:HyperLink ID="hl_popis" runat="server" NavigateUrl="" Text='<%# IIf(CultureInfo.CurrentCulture.ToString = "cs-CZ", DataBinder.Eval(Container.DataItem, "Text_CZ"),  DataBinder.Eval(Container.DataItem, "Text_EN")) %>'></asp:HyperLink></strong>
                  <asp:Label ID="LBL_poznamka" runat="server" CssClass="poznamka1" Text='<%# IIf (DataBinder.Eval(Container.DataItem, "Poznamka")=" ","",DataBinder.Eval(Container.DataItem, "Poznamka"))%>'></asp:Label>
                </div>
                <div class="ceny1">
                  <div class="leva1">
                    <%If prihlasen.VC Then%>
                    <div class="cenasdph1">
                      <asp:Literal ID="Literal5" runat="server" Text="<%$ Resources: lsv_produkt_4%>"></asp:Literal><strong><asp:Label ID="LBL_VC" ToolTip="<%$ Resources: lsv_produkt_3_tip%>" runat="server" Text='<%# Format(DataBinder.Eval(Container.DataItem, "VC")+ cenaPHE.PHEsDPH(DataBinder.Eval(Container.DataItem, "ID_objcislo")),"N0") & iif(CultureInfo.CurrentCulture.ToString = "cs-CZ",",-",".-")%>'></asp:Label></strong><%# IIf(Single.Parse(DataBinder.Eval(Container.DataItem, "VCDPH")) = 0, "", " Kè/" & DataBinder.Eval(Container.DataItem, "Jednotka"))%>
                    </div>
                    <div class="cenaeuro1">
                      <asp:Literal ID="Literal6" runat="server" Text="<%$ Resources: lsv_produkt_3%>"></asp:Literal><asp:Label ID="LBL_MC" ToolTip="<%$ Resources: lsv_produkt_4_tip%>" runat="server" Text='<%# Format(DataBinder.Eval(Container.DataItem, "MCDPH") + cenaPHE.PHEsDPH(DataBinder.Eval(Container.DataItem, "ID_objcislo")),"N0") & iif(CultureInfo.CurrentCulture.ToString = "cs-CZ",",-",".-")%>'></asp:Label><%# IIf(Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH")) = 0, "", " Kè/" & DataBinder.Eval(Container.DataItem, "Jednotka"))%>
                    </div>
                    <div class="sklad1">
                      <asp:Literal ID="Literal7" runat="server" Text="<%$ Resources: lsv_produkt_2%>"></asp:Literal><asp:Label ID="LBL_Marze" runat="server" Text='<%# Bind("Marze")%>'></asp:Label>
                      %
                    </div>
                    <%Else%>
                    <div class="cenaeuro1">
                      <asp:Literal ID="Literal1" runat="server" Text="<%$ Resources: lsv_produkt_1%>"></asp:Literal><strong><asp:Label ID="LBL_CenaEU" runat="server" Text='<%#Format((Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH")) / kurzEUR) + cenaPHE.PHEsDPH(DataBinder.Eval(Container.DataItem, "ID_objcislo"),"EUR"),"N2")%>'></asp:Label></strong><%# IIf(Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH")) = 0, "", " €/" & DataBinder.Eval(Container.DataItem, "Jednotka"))%>
                    </div>
                    <div class="cenasdph1">
                      <asp:Literal ID="Literal2" runat="server" Text="<%$ Resources: lsv_produkt_1%>"></asp:Literal><strong><asp:Label ID="LBL_CenaCZ" runat="server" Text='<%# Format(Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH"))+ cenaPHE.PHEsDPH(DataBinder.Eval(Container.DataItem, "ID_objcislo")),"N0") & iif(CultureInfo.CurrentCulture.ToString = "cs-CZ",",-",".-")%>'></asp:Label></strong><%# IIf(Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH")) = 0, "", " Kè/" & DataBinder.Eval(Container.DataItem, "Jednotka"))%>
                    </div>
                    <%End If%>
                    <div class="sklad1">
                      <asp:Literal ID="Literal3" runat="server" Text="<%$ Resources: lsv_produkt_5%>"></asp:Literal><strong><asp:Label ID="LBL_dostupnost" runat="server" Text='<%# Bind("Skladem")%>'></asp:Label></strong>
                    </div>
                  </div>
                  <div class="prava1">
                    <div class="kod1">
                      <asp:Literal ID="Literal4" runat="server" Text="<%$ Resources: lsv_produkt_6%>"></asp:Literal><asp:Label ID="lbl_objcislo" runat="server" Text='<%# Eval("ID_objcislo") %>'></asp:Label>
                    </div>
                    <div>
                      <asp:TextBox ID="TXB_kusu" CssClass="pocet1" runat="server" MaxLength="3" Text='<%# Bind("Min_ks") %>'></asp:TextBox>
                      <asp:Localize ID="LCL_jednotka" runat="server" meta:resourceKey="Localize2" Text='<%# Bind("Jednotka") %>'></asp:Localize>
                      <asp:ImageButton ID="IMB_doKose" runat="server" CommandArgument='<%# Container.DataItemIndex %>'
                        ImageUrl="~/WebImages/kosik.png" CssClass="kosik1" ToolTip="<%$ Resources: Kosik_tooltip %>" EnableViewState="True" />
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <%Else%>
            <td>
              <div class="produkt2">
                <div class="nazev2">
                  <strong>
                    <asp:HyperLink ID="hl_popis1" runat="server" NavigateUrl="" Text='<%# IIf(CultureInfo.CurrentCulture.ToString = "cs-CZ", DataBinder.Eval(Container.DataItem, "Text_CZ"),  DataBinder.Eval(Container.DataItem, "Text_EN")) %>'></asp:HyperLink></strong>
                  <asp:Label ID="LBL_poznamka1" runat="server" CssClass="poznamka2" Text='<%# IIf (DataBinder.Eval(Container.DataItem, "Poznamka")=" ","",DataBinder.Eval(Container.DataItem, "Poznamka"))%>'></asp:Label>
                </div>
                <div class="nahled2">
                  <asp:HyperLink ID="hl_Navigace1" runat="server" NavigateUrl="" ImageUrl="" ToolTip=""></asp:HyperLink>
                </div>
                <div class="produktinfo2">
                  <%If prihlasen.VC Then%>
                  <div class="cenasdph2">
                    <asp:Literal ID="Literal8" runat="server" Text="<%$ Resources: lsv_produkt_4%>"></asp:Literal><strong><asp:Label ID="LBL_VC1" ToolTip="<%$ Resources: lsv_produkt_3_tip%>" runat="server" Text='<%# Format(DataBinder.Eval(Container.DataItem, "VC")+ cenaPHE.PHEsDPH(DataBinder.Eval(Container.DataItem, "ID_objcislo")),"N0") & iif(CultureInfo.CurrentCulture.ToString = "cs-CZ",",-",".-")%>'></asp:Label></strong><%# IIf(Single.Parse(DataBinder.Eval(Container.DataItem, "VCDPH")) = 0, "", " Kè/" & DataBinder.Eval(Container.DataItem, "Jednotka"))%>
                  </div>
                  <div class="cenaeuro2">
                    <asp:Literal ID="Literal9" runat="server" Text="<%$ Resources: lsv_produkt_3%>"></asp:Literal><asp:Label ID="LBL_MC1" ToolTip="<%$ Resources: lsv_produkt_4_tip%>" runat="server" Text='<%# Format(DataBinder.Eval(Container.DataItem, "MCDPH") + cenaPHE.PHEsDPH(DataBinder.Eval(Container.DataItem, "ID_objcislo")),"N0") & iif(CultureInfo.CurrentCulture.ToString = "cs-CZ",",-",".-")%>'></asp:Label><%# IIf(Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH")) = 0, "", " Kè/" & DataBinder.Eval(Container.DataItem, "Jednotka"))%>
                  </div>
                  <div class="sklad2">
                    <asp:Literal ID="Literal10" runat="server" Text="<%$ Resources: lsv_produkt_2%>"></asp:Literal><asp:Label ID="LBL_Marze1" runat="server" Text='<%# Bind("Marze")%>'></asp:Label>
                    %
                  </div>
                  <%Else%>
                  <div class="cenaeuro2">
                    <asp:Literal ID="Literal11" runat="server" Text="<%$ Resources: lsv_produkt_1%>"></asp:Literal><strong><asp:Label ID="LBL_CenaEU1" runat="server" Text='<%#Format((Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH")) / kurzEUR) + cenaPHE.PHEsDPH(DataBinder.Eval(Container.DataItem, "ID_objcislo"),"EUR"),"N2")%>'></asp:Label></strong><%# IIf(Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH")) = 0, "", " €/" & DataBinder.Eval(Container.DataItem, "Jednotka"))%>
                  </div>
                  <div class="cenasdph2">
                    <asp:Literal ID="Literal12" runat="server" Text="<%$ Resources: lsv_produkt_1%>"></asp:Literal><strong><asp:Label ID="LBL_CenaCZ1" runat="server" Text='<%# Format(Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH"))+ cenaPHE.PHEsDPH(DataBinder.Eval(Container.DataItem, "ID_objcislo")),"N0") & iif(CultureInfo.CurrentCulture.ToString = "cs-CZ",",-",".-")%>'></asp:Label></strong><%# IIf(Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH")) = 0, "", " Kè/" & DataBinder.Eval(Container.DataItem, "Jednotka"))%>
                  </div>
                  <%End If%>
                  <div class="sklad2">
                    <asp:Literal ID="Literal13" runat="server" Text="<%$ Resources: lsv_produkt_5%>"></asp:Literal><strong><asp:Label ID="LBL_dostupnost1" runat="server" Text='<%# Bind("Skladem")%>'></asp:Label></strong>
                  </div>
                  <div class="kod2">
                    <asp:Literal ID="Literal14" runat="server" Text="<%$ Resources: lsv_produkt_6%>"></asp:Literal><asp:Label ID="lbl_objcislo1" runat="server" Text='<%# Eval("ID_objcislo") %>'></asp:Label>
                  </div>

                  <asp:TextBox ID="TXB_kusu1" CssClass="pocet2" runat="server" MaxLength="3" Text='<%# Bind("Min_ks") %>'></asp:TextBox>
                  <asp:Localize ID="LCL_jednotka1" runat="server" meta:resourceKey="Localize2" Text='<%# Bind("Jednotka") %>'></asp:Localize>
                  <asp:ImageButton ID="IMB_doKose1" runat="server" CommandArgument='<%# Container.DataItemIndex %>'
                    ImageUrl="~/WebImages/kosik.png" CssClass="kosik2" ToolTip="<%$ Resources: Kosik_tooltip %>" EnableViewState="True" />
                </div>
              </div>
            </td>
            <%End If%>
          </ItemTemplate>
        </asp:ListView>
      </div>
