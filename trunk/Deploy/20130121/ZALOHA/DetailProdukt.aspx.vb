Imports System.Data
Imports System.IO
Imports Objednavka
Imports System.Globalization

Partial Class Pages_DetailProdukt
    Inherits BasePage

    Public prihlasen As New Uzivatel
    Public obj As Objednavka = New Objednavka
    Public cenaPHE As PHE = New PHE

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

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If (Not IsPostBack) Then

            Try
                HL_Produkt.NavigateUrl = Request.UrlReferrer.ToString
                anc_mail.HRef = String.Format("mailto:?subject={0}&body=" + GetLocalResourceObject("mailKamarad").ToString + " - {1}", "Odkaz", Request.Url.AbsoluteUri)
            Catch ex As Exception
                HL_Produkt.Text = ""
            End Try

        End If
        If Not IsNothing(Session("id_zakaznik")) Then
            prihlasen = CType(Session("id_zakaznik"), Uzivatel)
        Else
            prihlasen.VC = False
        End If

    End Sub

    Protected Sub dls_detailProduktu_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.ListViewCommandEventArgs) Handles dls_detailProduktu.ItemCommand
        If Not e.CommandName = "imgView" Then
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
        End If

    End Sub

    Protected Sub dls_detailProduktu_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles dls_detailProduktu.PreRender
        Dim objCis As String = Request.QueryString("objcislo")

        If Not dls_detailProduktu.Items.Count = 0 Then

            Dim detailObr As ImageButton
            Dim detailTextObr As Button
            Dim cesta As String = Server.MapPath("../ImagesMedium/")
            Dim soubor As String = cesta + String.Format("{0}medium.jpg", objCis)
            Dim lblMC As Label
            Dim lblVC As Label
            Dim lblCenaCZ As Label
            Dim lblCenaEUR As Label
            Dim lblDostupnost As Label = CType(dls_detailProduktu.Items(0).FindControl("LBL_dostupnost"), Label)
            Dim lblPoznamka As Label = CType(dls_detailProduktu.Items(0).FindControl("LBL_poznamka"), Label)
            Dim paramAkce As String = Trim(lblPoznamka.Text)
            Dim dv_produkt As DataView = CType(DS_Produkt.Select(DataSourceSelectArguments.Empty), DataView)
            Dim kusuSkladem As Integer = CInt(dv_produkt.Table.Rows(0).Item("Skladem"))
            Dim MC As Integer = CInt(dv_produkt.Table.Rows(0).Item("MCDPH"))
            Dim VC As Integer = CInt(dv_produkt.Table.Rows(0).Item("VCDPH"))

            If Not IsNothing(Session("id_zakaznik")) Then
                prihlasen = CType(Session("id_zakaznik"), Uzivatel)
            Else
                prihlasen.VC = False
            End If

            'Pokud neni vyplnena poznamka tak ji nezobrazim
            If String.IsNullOrEmpty(lblPoznamka.Text) Then
                lblPoznamka.Visible = False
            End If

            'Kontrola jestli je k dispozici foto produktu
            Try
                Dim notimage As String
                If CultureInfo.CurrentCulture.ToString = "cs-CZ" Then
                    detailObr = dls_detailProduktu.Items(0).FindControl("img_det")
                    notimage = "nenimedium.jpg"
                Else
                    detailObr = dls_detailProduktu.Items(0).FindControl("img_detEN")
                    notimage = "notimagemedium.jpg"
                End If

                detailTextObr = dls_detailProduktu.Items(0).FindControl("btn_linkImg")

                If File.Exists(soubor) = False Then
                    detailObr.ImageUrl = String.Format("../ImagesMedium/{0}", notimage)
                    detailObr.ToolTip = GetLocalResourceObject("Image_tooltip")
                    detailTextObr.Text = ""

                Else
                    detailObr.ImageUrl = String.Format("../ImagesMedium/{0}medium.jpg", objCis)
                End If

                'Pokud je cena 0 tak zobrazit neco jineho
                lblVC = CType(dls_detailProduktu.Items(0).FindControl("LBL_VC"), Label)

                lblMC = CType(dls_detailProduktu.Items(0).FindControl("LBL_MC"), Label)

                lblCenaCZ = CType(dls_detailProduktu.Items(0).FindControl("LBL_CenaCZ"), Label)

                lblCenaEUR = CType(dls_detailProduktu.Items(0).FindControl("LBL_CenaEU"), Label)

                If VC = 0 And MC = 0 Then
                    lblVC.Text = GetLocalResourceObject("bezCeny")
                    lblMC.Text = GetLocalResourceObject("bezCeny")
                    lblCenaCZ.Text = GetLocalResourceObject("bezCeny")
                    lblCenaEUR.Text = GetLocalResourceObject("bezCeny")
                End If


            Catch
                HL_Produkt.Text = "Nebyl správnì zadán produkt pro zobrazení detailu!"
            End Try

            'Zobrazeni dostupnosti


            If LCase(paramAkce) <> "akce" Then
                lblDostupnost.Text = obj.dostupnost(kusuSkladem, paramAkce)
                Select Case obj.dostupnost(kusuSkladem, paramAkce)
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
        Else
            Localize2.Visible = False
            HyperLink2.Visible = False
        End If
    End Sub

    Protected Sub Page_LoadComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.LoadComplete
        Dim tableSouvis As DataView = CType(DS_SouvProdukt.Select(DataSourceSelectArguments.Empty), DataView)

        Try
            If tableSouvis.Table.Rows.Count = 0 Then
                nadpisSouvis.Visible = False
            End If
        Catch
            nadpisSouvis.Visible = False
        End Try

    End Sub

    Protected Sub img_det_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs)
        Dim lnq As AjaxControlToolkit.ModalPopupExtender = CType(dls_detailProduktu.Items(0).FindControl("MPE_ImgDetail"), AjaxControlToolkit.ModalPopupExtender)
        lnq.Show()
    End Sub


    Protected Sub btn_linkImg_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim lnq As AjaxControlToolkit.ModalPopupExtender = CType(dls_detailProduktu.Items(0).FindControl("MPE_ImgDetail"), AjaxControlToolkit.ModalPopupExtender)
        lnq.Show()
    End Sub
End Class
