Imports Objednavka
Imports PHE
Imports System.Data
Imports System.IO
Imports System.Globalization

Partial Class Pages_ListProdukt
    Inherits BasePage
    Private _kategorie As Integer
    Public Property paramKategorie() As Integer
        Get
            _kategorie = IIf(String.IsNullOrEmpty(Request.QueryString("kategorie")), 0, Request.QueryString("kategorie"))
            If Not IsNumeric(_kategorie) Then _kategorie = 0
            Return _kategorie
        End Get
        Set(ByVal value As Integer)
            _kategorie = value
        End Set
    End Property

    Private _kurzEUR As Single
    Public Property kurzEUR() As Single
        Get
            Dim kurz As New KurzCNB
            _kurzEUR = kurz.nactiUlozenyKurz("EUR")
            If Not IsNumeric(_kurzEUR) Or _kurzEUR = 0 Then _kurzEUR = 1
            Return _kurzEUR
        End Get
        Set(ByVal value As Single)
            _kurzEUR = value
        End Set
    End Property

    Private _subKategorie As Integer
    Public Property paramSubKategorie() As Integer
        Get
            _subKategorie = IIf(String.IsNullOrEmpty(Request.QueryString("subkategorie")), 0, Request.QueryString("subkategorie"))
            If Not IsNumeric(_subKategorie) Then _subKategorie = 0
            Return _subKategorie
        End Get
        Set(ByVal value As Integer)
            _subKategorie = value
        End Set
    End Property

    Private _fraze As String
    Public Property paramFraze() As String
        Get
            _fraze = Request.QueryString("fraze")
            Return _fraze
        End Get
        Set(ByVal value As String)
            _fraze = value
        End Set
    End Property

    Private _akce As Integer
    Public Property paramAkce() As Integer
        Get
            _akce = CInt(Request.QueryString("akce"))
            Return _akce
        End Get
        Set(ByVal value As Integer)
            _akce = value
        End Set
    End Property


  Public obj As Objednavka = New Objednavka
  Public prihlasen As Uzivatel = New Uzivatel
  Public cenaPHE As PHE = New PHE
  Public Layout As Integer = 0


  Private Sub nastavFiltrProduktu()
    If String.IsNullOrEmpty(paramFraze) Then
      If paramAkce = 1 Then
        DS_Produkty.SelectCommand = "SELECT Text_CZ, Text_EN,  MC*((DPH/100.0)+1) AS MCDPH, VC*((DPH/100.0)+1) AS VCDPH, ID_objcislo, Poznamka, Jednotka, Marze, Min_ks, Min_ks_inc, Skladem FROM T_Produkt WHERE lower(rtrim(Poznamka))='akce' AND Zobrazit=1 ORDER BY ind_akce"
      Else
        If (paramSubKategorie <> 0) Then
          DS_Produkty.SelectCommand = String.Format("SELECT Text_CZ, Text_EN, MC*((DPH/100.0)+1) AS MCDPH, VC*((DPH/100.0)+1) AS VCDPH, VC, ID_objcislo, Poznamka, Jednotka, Marze, Min_ks, Min_ks_inc, Skladem, ind FROM T_Produkt WHERE  (Zobrazit=1 AND ID_kategorie = {0} AND ID_subkategorie = {1}) OR (Zobrazit=1 AND ID_kategorie2 = {0} AND ID_subkategorie2 = {1}) ORDER BY ind, ID_objcislo", paramKategorie, paramSubKategorie)
        Else
          DS_Produkty.SelectCommand = String.Format("SELECT Text_CZ, Text_EN,  MC*((DPH/100.0)+1) AS MCDPH, VC*((DPH/100.0)+1) AS VCDPH, VC, ID_objcislo, Poznamka, Jednotka, Marze, Min_ks, Min_ks_inc, Skladem, ind FROM T_Produkt WHERE Zobrazit=1 AND (ID_kategorie = {0}) OR (ID_kategorie2 = {0}) ORDER BY ind, ID_objcislo", paramKategorie)
        End If
      End If
    Else
      Dim lang As String = CultureInfo.CurrentCulture.ToString
      If lang = "cs-CZ" Then
        DS_Produkty.SelectCommand = String.Format("SELECT Text_CZ, Text_EN, MC*((DPH/100.0)+1) AS MCDPH, VC*((DPH/100.0)+1) AS VCDPH, VC, ID_objcislo, Poznamka, Jednotka, Marze, Min_ks, Min_ks_inc, Skladem, ind FROM [T_Produkt] WHERE Zobrazit=1 AND CONTAINS((Detail,ID_objcislo,Jednotka,Poznamka,Text_CZ), '""{0}*""')", paramFraze)
      Else
        DS_Produkty.SelectCommand = String.Format("SELECT Text_CZ, Text_EN, MC*((DPH/100.0)+1) AS MCDPH, VC*((DPH/100.0)+1) AS VCDPH, VC, ID_objcislo, Poznamka, Jednotka, Marze, Min_ks, Min_ks_inc, Skladem, ind FROM [T_Produkt] WHERE Zobrazit=1 AND CONTAINS((Detail_EN,ID_objcislo,Jednotka,Poznamka,Text_EN), '""{0}*""')", paramFraze)
      End If
    End If

    DS_Produkty.DataBind()


  End Sub


  Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
    Dim dv As DataView
    If (Not IsPostBack) Then

      If String.IsNullOrEmpty(paramFraze) Then
        If paramAkce = 1 Then
          LBL_Cesta.Text = GetLocalResourceObject("lbl_cesta_akce").ToString
        Else
          Try
            dv = CType(DS_Kategorie.Select(DataSourceSelectArguments.Empty), DataView)

            LBL_Cesta.Text = IIf(CultureInfo.CurrentCulture.ToString = "cs-CZ", dv.Table.Rows(0)("TEXT_CZ").ToString(), dv.Table.Rows(0)("TEXT_EN").ToString())
            dv = CType(DS_Subkategorie.Select(DataSourceSelectArguments.Empty), DataView)
            If (dv.Count > 0) Then
              LBL_Cesta.Text = LBL_Cesta.Text & " >> " & IIf(CultureInfo.CurrentCulture.ToString = "cs-CZ", dv.Table.Rows(0)("TEXT_CZ").ToString(), dv.Table.Rows(0)("TEXT_EN").ToString())
            End If
          Catch
            LBL_Cesta.Text = "Pozor! Jsou zobrazeny všechny produkty - chybný parametr výběru kategorie."
          End Try

        End If
      Else
        LBL_Cesta.Text = GetLocalResourceObject("lbl_cesta_fraze").ToString & paramFraze
      End If

      Try
      Catch
        'IE vyhazuje nullexception.Ostatni prohlizece ne.
      End Try

    End If
    nastavFiltrProduktu()


    If Not IsNothing(Session("id_zakaznik")) Then
      prihlasen = CType(Session("id_zakaznik"), Uzivatel)
    Else
      prihlasen.VC = False
    End If

  End Sub


  Protected Sub LSV_Produkty_ItemCommand(sender As Object, e As System.Web.UI.WebControls.ListViewCommandEventArgs) Handles LSV_Produkty.ItemCommand
    'If e.CommandName = "Page" Then Exit Sub
    Dim popisLBL As String = CType(e.Item.FindControl("hl_popis"), HyperLink).Text
    Dim objCislo As String = CType(e.Item.FindControl("lbl_objcislo"), Label).Text
    Dim zadaneKusy As TextBox = CType(e.Item.FindControl("TXB_kusu"), TextBox)
    Dim kusu As Integer


    If (String.IsNullOrEmpty(zadaneKusy.Text) Or Not IsNumeric(zadaneKusy.Text)) Then
      kusu = 0
    Else
      kusu = CInt(zadaneKusy.Text)
    End If

    Dim resKusu As Integer = obj.pridejDoKosiku(objCislo, kusu)
    zadaneKusy.Text = resKusu
    'Secteni nakupu v kosiku a zobrazeni na master page
    obj.zobrazObsahKosiku()

  End Sub


  Protected Sub LSV_Produkty_ItemDataBound(sender As Object, e As System.Web.UI.WebControls.ListViewItemEventArgs) Handles LSV_Produkty.ItemDataBound
    Dim hpLink As HyperLink
    Dim hpLinkPopis As HyperLink
    Dim lblObj As Label
    Dim lblDostupnost As Label
    Dim lblPoznamka As Label
    Dim obCis As String
    Dim obCisx As String
    Dim cesta As String = Server.MapPath("../ImagesSmall/")
    Dim soubor As String = ""
    Dim kusuSkladem As Integer
    Dim poznamka As String = ""
    Dim lblMC As Label
    Dim lblVC As Label
    Dim lblCenaCZ As Label
    Dim lblCenaEUR As Label
    Dim dv_produkt As DataView = CType(DS_Produkty.Select(DataSourceSelectArguments.Empty), DataView)
    Dim MC As Integer = CInt(dv_produkt.Table.Rows(e.Item.DataItemIndex).Item("MCDPH"))
    Dim VC As Integer = CInt(dv_produkt.Table.Rows(e.Item.DataItemIndex).Item("VCDPH"))


    If Layout = 1 Then
      hpLink = CType(e.Item.FindControl("hl_Navigace1"), HyperLink)
      hpLinkPopis = CType(e.Item.FindControl("hl_popis1"), HyperLink)
      lblPoznamka = CType(e.Item.FindControl("LBL_poznamka1"), Label)
      lblObj = CType(e.Item.FindControl("lbl_objcislo1"), Label)
      lblDostupnost = CType(e.Item.FindControl("LBL_dostupnost1"), Label)
    Else
      hpLink = CType(e.Item.FindControl("hl_Navigace"), HyperLink)
      hpLinkPopis = CType(e.Item.FindControl("hl_popis"), HyperLink)
      lblPoznamka = CType(e.Item.FindControl("LBL_poznamka"), Label)
      lblObj = CType(e.Item.FindControl("lbl_objcislo"), Label)
      lblDostupnost = CType(e.Item.FindControl("LBL_dostupnost"), Label)
    End If

    obCis = Trim(lblObj.Text)
    soubor = cesta + String.Format("{0}small.jpg", obCis)
    'Kontrola jestli je fotka
    If File.Exists(soubor) = False Then
      If CultureInfo.CurrentCulture.ToString = "cs-CZ" Then
        obCisx = "neni"
      Else
        obCisx = "notimage"
      End If
    Else
      obCisx = obCis
    End If
    hpLink.NavigateUrl = String.Format("DetailProdukt.aspx?objcislo={0}", obCis)
    hpLinkPopis.NavigateUrl = String.Format("DetailProdukt.aspx?objcislo={0}", obCis)
    hpLink.ImageUrl = String.Format("../ImagesSmall/{0}small.jpg", obCisx)
    hpLink.ToolTip = String.Format(GetLocalResourceObject("tlt_obr").ToString, obCis)

    'Pokud je cena 0 tak zobrazit neco jineho
    If True Then
      lblVC = CType(e.Item.FindControl("LBL_VC"), Label)
      lblMC = CType(e.Item.FindControl("LBL_MC"), Label)
      lblCenaCZ = CType(e.Item.FindControl("LBL_CenaCZ"), Label)
      lblCenaEUR = CType(e.Item.FindControl("LBL_CenaEU"), Label)
    Else
      lblVC = CType(e.Item.FindControl("LBL_VC1"), Label)
      lblMC = CType(e.Item.FindControl("LBL_MC1"), Label)
      lblCenaCZ = CType(e.Item.FindControl("LBL_CenaCZ1"), Label)
      lblCenaEUR = CType(e.Item.FindControl("LBL_CenaEU1"), Label)
    End If

    If VC = 0 And MC = 0 Then
      lblVC.Text = GetLocalResourceObject("bezCeny")
      lblMC.Text = GetLocalResourceObject("bezCeny")
      lblCenaCZ.Text = GetLocalResourceObject("bezCeny")
      lblCenaEUR.Text = GetLocalResourceObject("bezCeny")
    End If

    'Zobrazeni dostupnosti
    kusuSkladem = CInt(lblDostupnost.Text)

    poznamka = lblPoznamka.Text
    If String.IsNullOrEmpty(poznamka) Then
      lblPoznamka.Visible = False
    End If

    If paramAkce <> 1 Then
      lblDostupnost.Text = obj.dostupnost(kusuSkladem, poznamka)
      Select Case obj.dostupnost(kusuSkladem, poznamka)
        Case Resources.Dostupnost.sklad
          lblDostupnost.ForeColor = Drawing.Color.Green
        Case Resources.Dostupnost.omez
          lblDostupnost.ForeColor = Drawing.Color.Orange
        Case Resources.Dostupnost.vyprodano
          lblDostupnost.ForeColor = Drawing.Color.Red
      End Select
    Else
      lblDostupnost.Text = String.Format(Resources.Dostupnost.vAkci, kusuSkladem)
    End If

  End Sub

  Protected Sub ddl_pageSize_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles ddl_pageSize.SelectedIndexChanged
    DataPager1.PageSize = CType(sender, DropDownList).SelectedValue
    Session.Item("pageSize") = CType(sender, DropDownList).SelectedValue
    DataPager1.SetPageProperties(0, DataPager1.PageSize, True)
  End Sub

  Protected Sub DataPager1_Init(sender As Object, e As EventArgs) Handles DataPager1.Init
    DataPager1.PageSize = 10
    If IsNumeric(Session("pageSize")) Then
      DataPager1.PageSize = Session("pageSize")
    End If
    ddl_pageSize.SelectedValue = DataPager1.PageSize
  End Sub

  Protected Sub ImageButton1_Click(sender As Object, e As ImageClickEventArgs) Handles ImageButton1.Click
    Layout = 1
    Session.Item("layout") = Layout
    Dim aCookie As New HttpCookie("layout")
    aCookie.Value = Layout
    aCookie.Expires = DateTime.MaxValue 'newer expires
    Response.Cookies.Add(aCookie)
    ImageButton2.ImageUrl = "~/WebImages/list125.png"
    ImageButton1.ImageUrl = "~/WebImages/list225o.png"
    LSV_Produkty.DataBind()
  End Sub

  Protected Sub ImageButton2_Click(sender As Object, e As ImageClickEventArgs) Handles ImageButton2.Click
    Layout = 0
    Session.Item("layout") = Layout
    Dim aCookie As New HttpCookie("layout")
    aCookie.Value = Layout
    aCookie.Expires = DateTime.MaxValue 'newer expires
    Response.Cookies.Add(aCookie)
    ImageButton2.ImageUrl = "~/WebImages/list125o.png"
    ImageButton1.ImageUrl = "~/WebImages/list225.png"
    LSV_Produkty.DataBind()
  End Sub

  Protected Sub LSV_Produkty_Init(sender As Object, e As EventArgs) Handles LSV_Produkty.Init
    'nacteni nastaveni seznamu produktu z cookie
    If Not IsNothing(Session("layout")) Then
      If IsNumeric(Session("layout")) Then
        Layout = Session("layout")
      End If
    Else
      If Not Request.Cookies("layout") Is Nothing Then
        Layout = Request.Cookies("layout").Value
        Session("layout") = Layout
      End If
    End If
    If Layout = 0 Then
      ImageButton2.ImageUrl = "~/WebImages/list125o.png"
      ImageButton1.ImageUrl = "~/WebImages/list225.png"
    Else
      ImageButton2.ImageUrl = "~/WebImages/list125.png"
      ImageButton1.ImageUrl = "~/WebImages/list225o.png"
    End If
  End Sub
End Class
