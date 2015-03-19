Imports System.Data.SqlClient
Imports System.Globalization
Imports System.Data
Imports System.Diagnostics
Imports System.Xml
Imports System.IO
Imports Objednavka
Imports Alerts

Partial Class MasterPage_MasterPage
    Inherits System.Web.UI.MasterPage
    Public obj As Objednavka = New Objednavka
    Public alert As Alerts = New Alerts
    Dim prihlasen As Uzivatel = New Uzivatel
    Dim imgUrlString As String
    Dim alternateTextString As String
    Dim navigateURLString As String

    Private Sub naplnMenu()

        Dim tab As New DataTable
        Dim ds As New DataSet
        Dim con As New SqlConnection(ConfigurationManager.ConnectionStrings("DataHorejsi").ConnectionString)
        Dim cmd As New SqlCommand("SELECT Kategorie, KategorieEN FROM V_MenuProduktu GROUP BY Kategorie, KategorieEN ORDER BY MIN(indK)", con)
        Dim cmdS As New SqlCommand("SELECT Kategorie,Subkategorie,KategorieEN,SubkategorieEN,replace(WebURL,'~/Pages','../Pages') as WebURL,indK,indS FROM dbo.V_MenuProduktu WHERE Subkategorie IS NOT NULL ORDER BY indS", con)
        Dim dat1 As New SqlDataAdapter
        Dim ofsetfields As String = ""

        If CultureInfo.CurrentCulture.ToString = "en-US" Then ofsetfields = "EN"

        dat1.SelectCommand = cmd
        dat1.Fill(ds, "Kategorie")

        dat1.SelectCommand = cmdS
        dat1.Fill(ds, "Subkategorie")

        ds.Relations.Add("myrelation", ds.Tables("Kategorie").Columns(String.Format("Kategorie{0}", ofsetfields)), ds.Tables("Subkategorie").Columns(String.Format("Kategorie{0}", ofsetfields)))


        RPT_Kategorie.DataSource = ds.Tables("Kategorie")
        RPT_Kategorie.DataBind()
    End Sub

    Private Sub ukazPrihlaseni(ByVal zobrazit As Boolean)


        txb_uzivatel.Visible = zobrazit
        txb_heslo.Visible = zobrazit
        lnb_zapomenuteHeslo.Visible = zobrazit
        lnb_registrace.Visible = zobrazit
        lbl_statusPrihlaseni.Visible = Not zobrazit
        lnb_zmena.Visible = Not zobrazit
        btn_prihlasit.Visible = zobrazit
        btn_odhlasit.Visible = Not zobrazit

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'SetNextImage()

        If Not IsPostBack Then
            naplnMenu()


            If Not IsNothing(Session("id_zakaznik")) Then
                prihlasen = CType(Session("id_zakaznik"), Uzivatel)
                lbl_statusPrihlaseni.Text = String.Format(GetLocalResourceObject("loginStatus").ToString, prihlasen.Jmeno)
                ukazPrihlaseni(False)
            Else
                prihlasen.VC = False
                ukazPrihlaseni(True)
            End If

            obj.zobrazObsahKosiku()
        End If
    End Sub

    Protected Sub imb_cz_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imb_cz.Click
        If Not Session("MyCulture") = "cs-CZ" Then
            Session("MyCulture") = "cs-CZ"
            Dim aCookie As New HttpCookie("otmData")
            aCookie.Values("languagePref") = Session("MyCulture")
            aCookie.Expires = System.DateTime.Now.AddDays(21)
            Response.Cookies.Add(aCookie)
        End If

        'Reload the page
        Response.Redirect(Request.Url.ToString)
    End Sub

    Protected Sub imb_en_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imb_en.Click
        If Not Session("MyCulture") = "en-US" Then
            Session("MyCulture") = "en-US"
            Dim aCookie As New HttpCookie("otmData")
            aCookie.Values("languagePref") = Session("MyCulture")
            aCookie.Expires = System.DateTime.Now.AddDays(21)
            Response.Cookies.Add(aCookie)
        End If

        'Reload the page
        Response.Redirect(Request.Url.ToString)
    End Sub

    Protected Sub txb_ZadejFull_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txb_ZadejFull.TextChanged
        Response.Redirect(String.Format("~/Pages/ListProdukt.aspx?kategorie=0&subkategorie=0&fraze={0}", txb_ZadejFull.Text))
    End Sub

    Protected Sub btn_HledejFull_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btn_HledejFull.Click
        Response.Redirect(String.Format("~/Pages/ListProdukt.aspx?kategorie=0&subkategorie=0&fraze={0}", txb_ZadejFull.Text))
    End Sub

    Protected Sub btn_prihlasit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btn_prihlasit.Click
        'Overeni uzivatele
        Dim uzivatel As String = Trim(txb_uzivatel.Text)
        Dim heslo As String = Trim(txb_heslo.Text)
        Dim sqlCmd As String = String.Format("SELECT T_Zakaznik.Uzivatel, T_Zakaznik.ID_zakaznik, T_Zakaznik.VC, ISNULL(T_Zakaznik.Firma, ' ') AS Firma, T_Zakaznik.Staty_ID, T_Staty.nazev AS Stat" _
                                           & " FROM T_Zakaznik INNER JOIN T_Staty ON T_Zakaznik.Staty_ID = T_Staty.id_stat WHERE T_Zakaznik.Uzivatel = '{0}' AND T_Zakaznik.Heslo = '{1}'", uzivatel, heslo)
        Dim con As New SqlConnection(ConfigurationManager.ConnectionStrings("DataHorejsi").ConnectionString)
        Dim cmdUzivatel As New SqlCommand(sqlCmd, con)
        Dim uzv As New Uzivatel

        con.Open()
        Dim readerU As SqlDataReader = cmdUzivatel.ExecuteReader()
        Session("id_zakaznik") = Nothing


        While readerU.Read()
            If Trim(readerU("Uzivatel")) = uzivatel Then
                With uzv
                    .id = readerU("ID_zakaznik")
                    .Jmeno = readerU("Uzivatel")
                    .VC = readerU("VC")
                    .Firma = readerU("Firma")
                    .StatID = readerU("Staty_ID")
                    .StatName = readerU("Stat")
                End With
                Session("id_zakaznik") = uzv
                lbl_statusPrihlaseni.Text = String.Format(GetLocalResourceObject("loginStatus").ToString, uzivatel)
                ukazPrihlaseni(False)


                'Pokud je zobrazen kosik je treba po prihlaseni znovu nacist data zakaznika
                If InStr(LCase(Hlavni.Page.AppRelativeVirtualPath), "kosik.aspx") Or InStr(LCase(Hlavni.Page.AppRelativeVirtualPath), "produkt.aspx") Then
                    Response.Redirect(Request.Url.ToString)
                End If
            End If
        End While

        readerU.Close()
        con.Close()

        If IsNothing(Session("id_zakaznik")) Then
            alert.Show(GetLocalResourceObject("errorLogin"), GetGlobalResourceObject("Dostupnost", "popUp_title1"))
        End If
    End Sub

    Protected Sub btn_odhlasit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btn_odhlasit.Click
        Session("id_zakaznik") = Nothing
        lbl_statusPrihlaseni.Text = ""
        ukazPrihlaseni(True)
        txb_uzivatel.Text = GetLocalResourceObject("user")
        'Po odhlaseni znovu nacist praznou stranku
        If InStr(LCase(Hlavni.Page.AppRelativeVirtualPath), "kosik.aspx") Or InStr(LCase(Hlavni.Page.AppRelativeVirtualPath), "produkt.aspx") Or InStr(LCase(Hlavni.Page.AppRelativeVirtualPath), "registrace.aspx") Then
            Response.Redirect(Request.Url.ToString)
        End If
    End Sub




End Class

