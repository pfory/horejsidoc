<div class="centr">

        <div class="strankovani">
        <div class="strankovaninapln">
        <div style="float:left">
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

            <div style="float:right">
        <asp:Label ID="Label1" runat="server" Text="<%$ Resources: LBL_page %>"></asp:Label>
        <asp:DataPager ID="DataPager2" PagedControlID="LSV_Produkty" PageSize="10" runat="server" >
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
        </div>
        </div>
    <div class="seznamproduktu2">
        <asp:ListView ID="LSV_Produkty" runat="server" DataSourceID="DS_Produkty">
        <ItemTemplate>
        <div class="produkt2">
            <div class="nahled"><asp:HyperLink ID="hl_Navigace" runat="server" NavigateUrl="" ImageUrl="" ToolTip="" ></asp:HyperLink></div>
			<div class="produktinfo">
			<div class="nazev">
            <strong><asp:HyperLink ID="hl_popis" runat="server" NavigateUrl="" Text='<%# IIf(CultureInfo.CurrentCulture.ToString = "cs-CZ", DataBinder.Eval(Container.DataItem, "Text_CZ"),  DataBinder.Eval(Container.DataItem, "Text_EN")) %>'></asp:HyperLink></strong>
            <%--<asp:Label ID="LBL_poznamka" runat="server" CssClass="poznamka" Text='<%# Bind("Poznamka")%>'></asp:Label>--%>
  <asp:Label ID="LBL_poznamka" runat="server" CssClass="poznamka" Text='<%# IIf (DataBinder.Eval(Container.DataItem, "Poznamka")=" ","",DataBinder.Eval(Container.DataItem, "Poznamka"))%>'></asp:Label>
            </div>
      <div class="ceny">
        <div class="leva">
          <%If prihlasen.VC Then%>
          <div class="cenasdph"><asp:Literal ID="Literal5" runat="server" Text="<%$ Resources: lsv_produkt_4%>"></asp:Literal><strong><asp:Label ID="LBL_VC" ToolTip="<%$ Resources: lsv_produkt_3_tip%>" runat="server" Text='<%# Format(DataBinder.Eval(Container.DataItem, "VC")+ cenaPHE.PHEsDPH(DataBinder.Eval(Container.DataItem, "ID_objcislo")),"N0") & iif(CultureInfo.CurrentCulture.ToString = "cs-CZ",",-",".-")%>'></asp:Label></strong><%# IIf(Single.Parse(DataBinder.Eval(Container.DataItem, "VCDPH")) = 0, "", " Kč/" & DataBinder.Eval(Container.DataItem, "Jednotka"))%></div>
          <div class="cenaeuro"><asp:Literal ID="Literal6" runat="server" Text="<%$ Resources: lsv_produkt_3%>"></asp:Literal><asp:Label ID="LBL_MC" ToolTip="<%$ Resources: lsv_produkt_4_tip%>" runat="server" Text='<%# Format(DataBinder.Eval(Container.DataItem, "MCDPH") + cenaPHE.PHEsDPH(DataBinder.Eval(Container.DataItem, "ID_objcislo")),"N0") & iif(CultureInfo.CurrentCulture.ToString = "cs-CZ",",-",".-")%>'></asp:Label><%# IIf(Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH")) = 0, "", " Kč/" & DataBinder.Eval(Container.DataItem, "Jednotka"))%></div>
          <div class="sklad"><asp:Literal ID="Literal7" runat="server" Text="<%$ Resources: lsv_produkt_2%>"></asp:Literal><asp:Label ID="LBL_Marze"  runat="server" Text='<%# Bind("Marze")%>'></asp:Label> % </div>
          <%Else%>
          <div class="cenaeuro"><asp:Literal ID="Literal1" runat="server" Text="<%$ Resources: lsv_produkt_1%>"></asp:Literal><strong><asp:Label ID="LBL_CenaEU" runat="server" Text='<%#Format((Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH")) / kurzEUR) + cenaPHE.PHEsDPH(DataBinder.Eval(Container.DataItem, "ID_objcislo"),"EUR"),"N2")%>'></asp:Label></strong><%# IIf(Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH")) = 0, "", " €/" & DataBinder.Eval(Container.DataItem, "Jednotka"))%></div>
          <div class="cenasdph"><asp:Literal ID="Literal2" runat="server" Text="<%$ Resources: lsv_produkt_1%>"></asp:Literal><strong><asp:Label ID="LBL_CenaCZ" runat="server" Text='<%# Format(Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH"))+ cenaPHE.PHEsDPH(DataBinder.Eval(Container.DataItem, "ID_objcislo")),"N0") & iif(CultureInfo.CurrentCulture.ToString = "cs-CZ",",-",".-")%>'></asp:Label></strong><%# IIf(Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH")) = 0, "", " Kč/" & DataBinder.Eval(Container.DataItem, "Jednotka"))%></div>
          <%End If%>
		  <div class="sklad"><asp:Literal ID="Literal3" runat="server" Text="<%$ Resources: lsv_produkt_5%>"></asp:Literal><strong><asp:Label ID="LBL_dostupnost" runat="server" Text='<%# Bind("Skladem")%>'></asp:Label></strong></div>
          </div>
        <div class="prava">
        <div class="kod"><asp:Literal ID="Literal4" runat="server" Text="<%$ Resources: lsv_produkt_6%>"></asp:Literal><asp:Label ID="lbl_objcislo" runat="server" Text='<%# Eval("ID_objcislo") %>'></asp:Label></div>
        <div>
        <asp:TextBox  ID="TXB_kusu" CssClass="pocet" runat="server" MaxLength="3" Text='<%# Bind("Min_ks") %>'></asp:TextBox>
        <asp:Localize ID="LCL_jednotka" runat="server" meta:resourceKey="Localize2" Text='<%# Bind("Jednotka") %>'></asp:Localize> 
        <asp:ImageButton ID="IMB_doKose"  runat="server" CommandArgument='<%# Container.DataItemIndex %>'
                    ImageUrl="~/WebImages/kosik.png" CssClass="kosik" ToolTip="<%$ Resources: Kosik_tooltip %>" EnableViewState="True"  />
     	</div> 
        </div>
      </div></div>
    </div>
        </ItemTemplate>
        </asp:ListView>
        </div>