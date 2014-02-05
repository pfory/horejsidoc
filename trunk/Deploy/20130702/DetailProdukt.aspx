<%@ Page Language="VB" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="false" CodeFile="DetailProdukt.aspx.vb" Inherits="Pages_DetailProdukt" title="Modely Hoøejší" %>

<%@ Import Namespace="System.ComponentModel" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="PHE" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Hlavni" Runat="Server">


	<asp:SqlDataSource ID="DS_Produkt" runat="server" ConnectionString="<%$ ConnectionStrings:DataHorejsi %>"
        SelectCommand="SELECT ltrim(rtrim(ID_objcislo)) as ID_objcislo, Text_CZ, Text_EN, MC*((DPH/100.0)+1) AS MCDPH, VC*((DPH/100.0)+1) AS VCDPH, VC, Marze, Detail, Detail_EN, ID_kategorie, ID_subkategorie, ID_kategorie2, ID_subkategorie2, Jednotka, Min_Ks, Poznamka, Skladem FROM T_Produkt WHERE (ID_objcislo = @ID_objcislo)">
        <SelectParameters>
            <asp:QueryStringParameter Name="ID_objcislo" QueryStringField="objcislo" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    
    <h1><asp:HyperLink ID="HL_Produkt" CssClass="linkZpet"  runat="server" NavigateUrl="" meta:resourcekey="HL_Produkt" Text=""></asp:HyperLink></h1>

   <div class="centr">
   <div class="seznamproduktu2">
    <asp:ListView ID="dls_detailProduktu" runat="server" DataSourceID="DS_Produkt" >
        <ItemTemplate>
            <div class="produktdet">
            <div class="nahled">
            <asp:Panel runat="server" ID="popUp_Image" CssClass="ModalWindow">
                            <div style="text-align:center;background-color: white">
                            <asp:Image ID="Image1" runat="server" ImageUrl='<%# Eval("ID_objcislo", "/Images/{0}.jpg") %>' />
                            <%If CultureInfo.CurrentCulture.ToString = "cs-CZ" Then%>
                            <p style="margin-left:10px"><%# Eval("Text_CZ") %></p>
                            <%Else%>
                            <p style="margin-left:10px"><%# Eval("Text_EN") %></p>
                            <%End If%>
                            <br /></div>
                            <div style="text-align:right;background-color:white">
                            <asp:ImageButton runat="server" ID="btn_close" ImageUrl="/WebImages/closelabel.gif" />
                            <br />
                            </div>
                        </asp:Panel>
                        <asp:HiddenField ID="x" runat="server" />

                        <asp:ModalPopupExtender ID="MPE_ImgDetail" runat="server" 
                            DynamicServicePath="" Enabled="True" TargetControlID="x"  
                            PopupControlID="popUp_Image"
                            BackgroundCssClass="modalBackground"
                            CancelControlID="btn_close">
                        </asp:ModalPopupExtender>
                        
                        <%If CultureInfo.CurrentCulture.ToString = "cs-CZ" Then%>
                        <asp:ImageButton runat="server" ID="img_det" CommandName="imgView" 
                            ImageUrl='<%# Eval("ID_objcislo", "/ImagesMedium/{0}medium.jpg") %>' 
                            onclick="img_det_Click" ToolTip='<%# Eval("Text_CZ") %>' />
                        <%Else%>
                        <asp:ImageButton runat="server" ID="img_detEN" CommandName="imgView"
                            ImageUrl='<%# Eval("ID_objcislo", "/ImagesMedium/{0}medium.jpg") %>' 
                            onclick="img_det_Click" ToolTip='<%# Eval("Text_EN") %>' />
                        <%End If%>
                        <br />
                        <asp:Button runat="server" Text="<%$Resources: detailObr %>" 
                            CommandName="imgView" ID="btn_linkImg" BackColor="White" BorderStyle="None" 
                            Font-Size="X-Small" onclick="btn_linkImg_Click"  />
                            
            </div>
			<div class="produktinfo">
			<div class="nazev">
            <strong><asp:HyperLink ID="hl_popis" runat="server" NavigateUrl="" Text='<%# IIf(CultureInfo.CurrentCulture.ToString = "cs-CZ", DataBinder.Eval(Container.DataItem, "Text_CZ"),  DataBinder.Eval(Container.DataItem, "Text_EN")) %>'></asp:HyperLink></strong>
            <%--<asp:Label ID="LBL_poznamka" runat="server" CssClass="poznamka" Text='<%# Bind("Poznamka")%>'></asp:Label>--%>            
            <asp:Label ID="LBL_poznamka" runat="server" CssClass="poznamka" Text='<%# IIf (DataBinder.Eval(Container.DataItem, "Poznamka")=" ","",DataBinder.Eval(Container.DataItem, "Poznamka"))%>'></asp:Label>
            </div>
      <div class="ceny">
        <div class="leva">
          <%If prihlasen.VC Then%>
          <div class="cenasdph"><asp:Literal ID="Literal5" runat="server" Text="<%$ Resources: lsv_produkt_4%>"></asp:Literal><strong><asp:Label ID="LBL_VC" ToolTip="<%$ Resources: lsv_produkt_3_tip%>" runat="server" Text='<%# Format(DataBinder.Eval(Container.DataItem, "VC")+ cenaPHE.PHEsDPH(DataBinder.Eval(Container.DataItem, "ID_objcislo")),"N0") & iif(CultureInfo.CurrentCulture.ToString = "cs-CZ",",-",".-")%>'></asp:Label></strong><%# IIf(Single.Parse(DataBinder.Eval(Container.DataItem, "VCDPH")) = 0, "", " Kè/" & DataBinder.Eval(Container.DataItem, "Jednotka"))%></div>
          <div class="cenaeuro"><asp:Literal ID="Literal6" runat="server" Text="<%$ Resources: lsv_produkt_3%>"></asp:Literal><asp:Label ID="LBL_MC" ToolTip="<%$ Resources: lsv_produkt_4_tip%>" runat="server" Text='<%# Format(DataBinder.Eval(Container.DataItem, "MCDPH") + cenaPHE.PHEsDPH(DataBinder.Eval(Container.DataItem, "ID_objcislo")),"N0") & iif(CultureInfo.CurrentCulture.ToString = "cs-CZ",",-",".-")%>'></asp:Label><%# IIf(Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH")) = 0, "", " Kè/" & DataBinder.Eval(Container.DataItem, "Jednotka"))%></div>
          <div class="sklad"><asp:Literal ID="Literal7" runat="server" Text="<%$ Resources: lsv_produkt_2%>"></asp:Literal><asp:Label ID="LBL_Marze"  runat="server" Text='<%# Bind("Marze")%>'></asp:Label> % </div>
          <%Else%>
          <div class="cenaeuro"><asp:Literal ID="Literal1" runat="server" Text="<%$ Resources: lsv_produkt_1%>"></asp:Literal><strong><asp:Label ID="LBL_CenaEU" runat="server" Text='<%#Format((Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH")) / kurzEUR) + cenaPHE.PHEsDPH(DataBinder.Eval(Container.DataItem, "ID_objcislo"),"EUR"),"N2") %>'></asp:Label></strong><%# IIf(Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH")) = 0, "", " €/" & DataBinder.Eval(Container.DataItem, "Jednotka"))%></div>
          <div class="cenasdph"><asp:Literal ID="Literal2" runat="server" Text="<%$ Resources: lsv_produkt_1%>"></asp:Literal><strong><asp:Label ID="LBL_CenaCZ" runat="server" Text='<%# Format(Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH"))+ cenaPHE.PHEsDPH(DataBinder.Eval(Container.DataItem, "ID_objcislo")),"N0") & iif(CultureInfo.CurrentCulture.ToString = "cs-CZ",",-",".-")%>'></asp:Label></strong><%# IIf(Single.Parse(DataBinder.Eval(Container.DataItem, "MCDPH")) = 0, "", " Kè/" & DataBinder.Eval(Container.DataItem, "Jednotka"))%></div>
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
      </div>
      </div>
     </div>
      <div style="margin-top:20px">
      <%If CultureInfo.CurrentCulture.ToString = "cs-CZ" Then%>
                        <asp:Label ID="lbl_detail" runat="server" Text='<%# Eval("Detail") %>'></asp:Label>
                    <%Else%>
                        <asp:Label ID="Label3" runat="server" Text='<%# Eval("Detail_EN") %>'></asp:Label>
                    <%End If%> 
      </div>
    
        </ItemTemplate>
    </asp:ListView>
    <center style="margin-top:20px;">
    <table border="0" width="50%" style="text-align:center" >
    <tr>
    <td>
    <%--Odkaz pro kamarada a prepocet na cizi menu--%>
    <a id="anc_mail" runat="server" href="">
        <asp:Localize ID="Localize2" runat="server" Text="<%$Resources: anc_mail %>"></asp:Localize></a>
    </td>
    </tr>
    <tr>
        <td colspan="2" style="text-align:center">
            <br />
            <asp:HyperLink ID="HyperLink2" runat="server" ImageUrl="/WebImages/ZpravodajBanner.png" NavigateUrl="~/Pages/ListZpravodaj.aspx"></asp:HyperLink>
        </td>
    </tr>
    </table></center>
    
    <asp:SqlDataSource ID="DS_SouvProdukt" runat="server" 
        ConnectionString="<%$ ConnectionStrings:DataHorejsi %>" 
        SelectCommand="SELECT Text_CZ, Text_EN, ID_objcislo FROM T_Produkt WHERE (ID_objcislo IN (SELECT ID_SlaveObjCislo FROM T_Vazby WHERE (ID_MasterObjCislo =@ID_objcislo)))">
            <SelectParameters>
                <asp:QueryStringParameter Name="ID_objcislo" QueryStringField="objcislo" />
            </SelectParameters>
        </asp:SqlDataSource>
    <div id="nadpisSouvis" runat="server" class="cestaProdukt">
        <asp:Label ID="Label4" runat="server" Text='<%$Resources: Label4.Text %>'></asp:Label>
    </div>
    <asp:DataList ID="dls_SouvisProdukt" runat="server" DataSourceID="DS_SouvProdukt" RepeatColumns="3"
        RepeatDirection="Horizontal" HorizontalAlign="Center" >
        <ItemTemplate>
            <table class="detailData">
                <tr>
                    <td >
                        <asp:HyperLink ID="HyperLink1" runat="server" ImageUrl='<%# Eval("ID_objcislo", "~/ImagesSmall/{0}small.jpg") %>'
                            NavigateUrl='<%# Eval("ID_objcislo", "~/Pages/DetailProdukt.aspx?objcislo={0}") %>' ToolTip='<%# Eval("ID_objcislo", "Zobraz detail {0}") %>' BorderStyle="Solid" BorderWidth="2px" BorderColor="#3366cc"></asp:HyperLink>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center">
            <%If CultureInfo.CurrentCulture.ToString = "cs-CZ" Then%>
            <asp:Label ID="Label1" runat="server" Text='<%# Eval("Text_CZ") %>'></asp:Label>
            <%Else%>
            <asp:Label ID="Label2" runat="server" Text='<%# Eval("Text_EN") %>'></asp:Label>
            <%End If%>
            </td>
                </tr>
            </table>
        </ItemTemplate>
    </asp:DataList>
</div>
</div>
</asp:Content>

