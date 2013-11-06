Imports System.Diagnostics
Imports System.Web.UI.WebControls
Imports Objednavka
Imports KurzCNB
Imports WriteLogFile
Imports System.Data
Imports System.Net.Mail
Imports System.Globalization
Imports AjaxControlToolkit
Imports System.Drawing

Partial Class Pages_Kosik
    Inherits BasePage

    Private _typZakaznika As s_typZakaznika
    Public Property typZakaznika As s_typZakaznika
        Get
            _typZakaznika.ochodnik = False
            _typZakaznika.registrace = False
            _typZakaznika.cizinec = False

            If Not IsNothing(Session("id_zakaznik")) Then
                _typZakaznika.registrace = True
                _typZakaznika.ochodnik = prihlasen.VC
                _typZakaznika.statID = prihlasen.StatID
                _typZakaznika.statName = prihlasen.StatName
            Else
                If FRV_zakaznik.CurrentMode = FormViewMode.ReadOnly Then
                    '_typZakaznika.statID = CType(FRV_zakaznik.FindControl("lbl_stat"), DropDownList).SelectedItem.Value
                    _typZakaznika.statName = CType(FRV_zakaznik.FindControl("lbl_stat"), Label).Text
                Else
                    _typZakaznika.statID = CType(FRV_zakaznik.FindControl("ddl_insertstat"), DropDownList).SelectedItem.Value
                    _typZakaznika.statName = CType(FRV_zakaznik.FindControl("ddl_insertstat"), DropDownList).SelectedItem.Text
                End If
            End If

            If _typZakaznika.statID <> 58 And _typZakaznika.statID <> 199 Then
                _typZakaznika.cizinec = True
            End If

            Return _typZakaznika
        End Get
        Set(ByVal value As s_typZakaznika)
            _typZakaznika = value
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

    Private _bt_Objednat As Button
    Public Property bt_Objednat() As Button
        Get
            Dim bt As Button = CType(FRV_zakaznik.FindControl("BTN_objednatBezReg"), Button)
            Dim bt1 As Button = CType(FRV_zakaznik.FindControl("BTN_objednat"), Button)
            _bt_Objednat = IIf(Not bt Is Nothing, bt, bt1)
            
            Return _bt_Objednat
        End Get
        Set(ByVal value As Button)
            _bt_Objednat = value
        End Set
    End Property

    Public Structure s_typZakaznika
        Dim registrace As Boolean 'registrovan = true
        Dim ochodnik As Boolean   'VC = true
        Dim statID As Integer
        Dim statName As String
        Dim cizinec As Boolean  'True kdyz to neni CZ nebo SK
    End Structure

    Public sumaObj As Single
    Public sumaVc As Single
    Public idZakaznik As Integer
    Public neregUzivatel As String
    Public idObjednavky As Integer
    Public obj As Objednavka = New Objednavka
    Public prihlasen As Uzivatel = New Uzivatel
    Public lang As String
    Public logger As New WriteLogFile

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        lang = CultureInfo.CurrentCulture.ToString

        Dim vybraneZbozi As ArrayList = New ArrayList()

        If Not IsNothing(Session("zvoleneZbozi")) Then
            vybraneZbozi = CType(Session("zvoleneZbozi"), ArrayList)
        End If

        If vybraneZbozi.Count <= 0 Then
            RPT_VybraneZbozi.Visible = False
            RBL_odber.Visible = False
            FRV_zakaznik.Visible = False
            Localize3.Visible = False
            Localize4.Visible = False
            lbl_cenaCelkem.Visible = False
            lbl_stavObjednavky.Text = GetLocalResourceObject("prazdnyKosik").ToString
            lbl_stavObjednavky.Visible = True
            CType(Master.FindControl("lbl_cenaNakupu"), Label).Text = 0
            CType(Master.FindControl("lbl_pocetPolozek"), Label).Text = 0
        End If

        'Kdo je prihlasen
        If IsNothing(Session("id_zakaznik")) Then
            prihlasen.VC = False
        Else
            prihlasen = CType(Session("id_zakaznik"), Uzivatel)
        End If


        If Not IsPostBack Then

            zpusobDoruceni()
            setCenaCelkem()

            'Secteni polozek v kosiku

            obj.zobrazObsahKosiku()

            'If vybraneZbozi.Count > 0 Then
            '    sumaObj = obj.sectiPolozky(vybraneZbozi, CInt(RBL_odber.SelectedValue), prihlasen.VC, lang)
            '    CType(Master.FindControl("lbl_cenaNakupu"), Label).Text = Format(sumaObj, "### ##0,0 Kč") + IIf(typZakaznika.cizinec, "/" + Math.Round(Single.Parse(sumaObj / kurzEUR), 1).ToString("F2") + "€", "")
            '    Session("payment_amt") = sumaObj

            'End If

            RPT_VybraneZbozi.DataSource = vybraneZbozi
            RPT_VybraneZbozi.DataBind()

            DS_Zakaznik.Select(DataSourceSelectArguments.Empty)
        End If

        'Potvrzeni objednavky az po validaci stranky
        If vybraneZbozi.Count = 0 Then bt_Objednat.Visible = False
        Dim confirmText As String = ("javascript:if (Page_ClientValidate()) { return confirm('" & GetLocalResourceObject("CBE_potvrdit").ToString & "'); } return true;")
        If Not bt_Objednat Is Nothing Then bt_Objednat.Attributes.Add("OnClick", confirmText)
    End Sub

    Protected Sub RPT_VybraneZbozi_ItemCommand(ByVal source As Object, ByVal e As System.Web.UI.WebControls.RepeaterCommandEventArgs) Handles RPT_VybraneZbozi.ItemCommand
        Dim zbozi As New ArrayList()
        Dim uprPolozka As String = e.CommandArgument
        Dim ind As Integer = 0
        
        zbozi = CType(Session("zvoleneZbozi"), ArrayList)

        If IsNothing(zbozi) Then Exit Sub

        If e.CommandName = "Odstranit" Then
            For Each polozka As VybraneZbozi In zbozi
                If polozka.objcislo = uprPolozka Then
                    zbozi.Remove(polozka)
                    Exit For
                End If
            Next
            If zbozi.Count = 0 Then
                RPT_VybraneZbozi.Visible = False
                RBL_odber.Visible = False
                FRV_zakaznik.Visible = False
                Localize3.Visible = False
                Localize4.Visible = False
                lbl_cenaCelkem.Visible = False
                lbl_stavObjednavky.Text = GetLocalResourceObject("prazdnyKosik").ToString
                lbl_stavObjednavky.Visible = True
                bt_Objednat.Visible = False
            End If
        End If

        If e.CommandName = "Plus" Then
            For Each polozka As VybraneZbozi In zbozi
                If polozka.objcislo = uprPolozka And polozka.mnozstvi < 999 Then
                    polozka.mnozstvi += polozka.KsInc
                    polozka.soucetMC = (polozka.mnozstvi * polozka.mc) + polozka.PHE * polozka.mnozstvi
                    polozka.soucetMCDPH = polozka.mnozstvi * polozka.mcDPH
                    polozka.soucetMC_EUR = polozka.mnozstvi * polozka.mc_EUR
                    polozka.soucetMCDPH_EUR = polozka.mnozstvi * polozka.mcDPH_EUR
                    polozka.soucetVC = (polozka.mnozstvi * polozka.vc) + polozka.PHE * polozka.mnozstvi
                    polozka.soucetVC_EUR = polozka.mnozstvi * polozka.vc_EUR
                    polozka.soucetVCDPH = polozka.mnozstvi * polozka.vcDPH
                    polozka.soucetVCDPH_EUR = polozka.mnozstvi * polozka.vcDPH_EUR
                    zbozi.Item(ind) = polozka
                    Exit For
                End If
                ind += 1
            Next
        End If

        If e.CommandName = "Minus" Then
            For Each polozka As VybraneZbozi In zbozi
                If polozka.objcislo = uprPolozka And polozka.mnozstvi > 1 Then
                    polozka.mnozstvi -= polozka.KsInc
                    polozka.soucetMC = (polozka.mnozstvi * polozka.mc) + polozka.PHE * polozka.mnozstvi
                    polozka.soucetMCDPH = polozka.mnozstvi * polozka.mcDPH
                    polozka.soucetMC_EUR = polozka.mnozstvi * polozka.mc_EUR
                    polozka.soucetMCDPH_EUR = polozka.mnozstvi * polozka.mcDPH_EUR
                    polozka.soucetVC = (polozka.mnozstvi * polozka.vc) + polozka.PHE * polozka.mnozstvi
                    polozka.soucetVC_EUR = polozka.mnozstvi * polozka.vc_EUR
                    polozka.soucetVCDPH = polozka.mnozstvi * polozka.vcDPH
                    polozka.soucetVCDPH_EUR = polozka.mnozstvi * polozka.vcDPH_EUR
                    zbozi.Item(ind) = polozka
                    Exit For
                End If
                ind += 1
            Next
        End If

        Session("zvoleneZbozi") = zbozi
        
        RPT_VybraneZbozi.DataSource = zbozi
        RPT_VybraneZbozi.DataBind()
        'Secteni polozek kosiku a zobrazeni na masterpage
        obj.zobrazObsahKosiku()
        setCenaCelkem()

    End Sub


    Protected Sub DS_Zakaznik_Inserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles DS_Zakaznik.Inserted
        odeslatObjednavku()
    End Sub

    Protected Sub DS_Zakaznik_Inserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceCommandEventArgs) Handles DS_Zakaznik.Inserting
        'Zaznam neregistrovaneho uzivatele 
        neregUzivatel = e.Command.Parameters("@Prijmeni").Value + Now.ToString
        e.Command.Parameters("@Uzivatel").Value = neregUzivatel
        e.Command.Parameters("@Heslo").Value = neregUzivatel
        e.Command.Parameters("@Staty_ID").Value = CType(FRV_zakaznik.FindControl("ddl_insertstat"), DropDownList).SelectedValue
    End Sub

    Protected Sub DS_Zakaznik_Selecting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceSelectingEventArgs) Handles DS_Zakaznik.Selecting
        If Not IsNothing(Session("id_zakaznik")) Then
            'Registrovany zakaznik
            FRV_zakaznik.DefaultMode = FormViewMode.ReadOnly
            e.Command.Parameters("@ID_zakaznik").Value = CInt(CType(Session("id_zakaznik"), Uzivatel).id)
            e.Command.Parameters("@Uzivatel").Value = ""
        ElseIf Not String.IsNullOrEmpty(neregUzivatel) Then
            'Neregistrovany
            e.Command.Parameters("@ID_zakaznik").Value = 0
            e.Command.Parameters("@Uzivatel").Value = neregUzivatel
        End If
    End Sub


    Private Sub odeslatObjednavku()
        'Odeslani objednavky
        Dim sb As StringBuilder = New StringBuilder
        Dim zbozi As New ArrayList()
        Dim Msg As New MailMessage()
        Dim Senderx As New SmtpClient()
        Dim mailAdr As String = ""
        Dim adresat As MailAddress
        Dim colspan As String
        Dim status As SmtpStatusCode

        lang = CultureInfo.CurrentCulture.ToString

        zbozi = CType(Session("zvoleneZbozi"), ArrayList)
        If IsNothing(zbozi) Then Exit Sub

        'Zaznam do db objednavky.Pokud je neuspesna objednavka tak to ohlasit
        If zaznamObjednavky() Then

            sb.Append(String.Format(GetLocalResourceObject("code_text12").ToString & ":<br /><br />", Format(Now, "dd.MM.yyyy HH:mm")))
            sb.AppendLine()

            'Hlavicka tabulky
            If prihlasen.VC Then
                sb.Append("<table border=1 style='border-collapse: collapse'><tr><td>" & GetLocalResourceObject("RPT_VybraneZbozi_Col1").ToString & "</td><td>" _
                          & GetLocalResourceObject("RPT_VybraneZbozi_Col2").ToString & "</td><td>" _
                          & GetLocalResourceObject("RPT_VybraneZbozi_Col3").ToString & "</td><td>" & GetLocalResourceObject("RPT_VybraneZbozi_Col13").ToString & "</td><td>" _
                          & GetLocalResourceObject("RPT_VybraneZbozi_Col9").ToString & "</td><td>" & GetLocalResourceObject("RPT_VybraneZbozi_Col5").ToString & "</td><td>" _
                          & GetLocalResourceObject("RPT_VybraneZbozi_Col11").ToString & "</td><td>" & GetLocalResourceObject("RPT_VybraneZbozi_Col6").ToString & "</td><td>" & GetLocalResourceObject("RPT_VybraneZbozi_Col7").ToString & "</td></tr>")
            Else
                sb.Append("<table border=1 style='border-collapse: collapse'><tr><td>" & GetLocalResourceObject("RPT_VybraneZbozi_Col1").ToString & "</td><td>" _
                          & GetLocalResourceObject("RPT_VybraneZbozi_Col2").ToString & "</td><td>" _
                          & GetLocalResourceObject("RPT_VybraneZbozi_Col3").ToString & "</td><td>" & GetLocalResourceObject("RPT_VybraneZbozi_Col13").ToString & "</td><td>" _
                          & GetLocalResourceObject("RPT_VybraneZbozi_Col9").ToString & "</td><td>" & GetLocalResourceObject("RPT_VybraneZbozi_Col5").ToString & "</td><td>" _
                          & GetLocalResourceObject("RPT_VybraneZbozi_Col11").ToString & "</td><td>" & GetLocalResourceObject("RPT_VybraneZbozi_Col6").ToString & "</td></tr>")
            End If
            'Data tabulky
            For Each polozka As VybraneZbozi In zbozi
                sb.Append("<tr>")
                If prihlasen.VC Then
                    sb.Append("<td>" + polozka.objcislo + "</td><td>" + IIf(lang = "cs-CZ", polozka.popis, polozka.popisEN) + "</td><td align='center'>" + polozka.mnozstvi.ToString + "</td><td align='right'>" + Format(polozka.vc, "#,0.0 Kč") + IIf(typZakaznika.cizinec, "/" + Format(polozka.vc_EUR, "#,0.00 €"), "") + "</td><td align='right'>" + Format(polozka.PHE * polozka.mnozstvi, "#,0.00 Kč") + IIf(typZakaznika.cizinec, "/" + Format(polozka.PHE_EUR * polozka.mnozstvi, "#,0.00 €"), "") + "</td><td align='right'>" + Format(polozka.soucetVC, "#,0.0 Kč") + IIf(typZakaznika.cizinec, "/" + Format(polozka.soucetVC_EUR, "#,0.00 €"), "") + "</td><td align='right'>" + polozka.dan.ToString + "%" + "</td><td align='right'>" + Format(polozka.soucetVCDPH, "#,0.0 Kč") + IIf(typZakaznika.cizinec, "/" + Format(polozka.soucetVCDPH_EUR, "#,0.00 €"), "") + "</td><td align='right'>" + polozka.marze.ToString + "%" + "</td>")
                Else
                    sb.Append("<td>" + polozka.objcislo + "</td><td>" + IIf(lang = "cs-CZ", polozka.popis, polozka.popisEN) + "</td><td align='center'>" + polozka.mnozstvi.ToString + "</td><td align='right'>" + Format(polozka.mc, "#,0.0 Kč") + IIf(typZakaznika.cizinec, "/" + Format(polozka.mc_EUR, "#,0.00 €"), "") + "</td><td align='right'>" + Format(polozka.PHE * polozka.mnozstvi, "#,0.00 Kč") + IIf(typZakaznika.cizinec, "/" + Format(polozka.PHE_EUR * polozka.mnozstvi, "#,0.00 €"), "") + "</td><td align='right'>" + Format(polozka.soucetMC, "#,0.0 Kč") + IIf(typZakaznika.cizinec, "/" + Format(polozka.soucetMC_EUR, "#,0.00 €"), "") + "</td><td align='right'>" + polozka.dan.ToString + "%" + "</td><td align='right'>" + Format(polozka.soucetMCDPH, "#,0.0 Kč") + IIf(typZakaznika.cizinec, "/" + Format(polozka.soucetMCDPH_EUR, "#,0.00 €"), "") + "</td>")
                End If
                sb.Append("</tr>")
            Next

            sumaObj = obj.sectiPolozky(zbozi, CInt(RBL_odber.SelectedValue), prihlasen.VC, lang)

            CType(Master.FindControl("lbl_cenaNakupu"), Label).Text = Format(obj.sectiPolozky(zbozi, CInt(RBL_odber.SelectedValue), prihlasen.VC, "cs-CZ"), "#,0.0 Kč") + IIf(typZakaznika.cizinec, "/" + Format(obj.sectiPolozky(zbozi, CInt(RBL_odber.SelectedValue), prihlasen.VC, "EUR"), "#,0.0 €"), "")

            'Paticka tabulky

            If prihlasen.VC Then
                colspan = 8

            Else
                colspan = 7
                
            End If
            'Cena celkem bez DPH
            sb.Append("<tr><td colspan='" + colspan + "'  align='right'>" & GetLocalResourceObject("RPT_VybraneZbozi_Col10").ToString & " &nbsp;-&nbsp;</td>" _
                          & "<td align='right'>" + Format(obj.sectiPolozky(zbozi, CInt(RBL_odber.SelectedValue), prihlasen.VC, "cs-CZ", True), "#,0.0 Kč") + IIf(typZakaznika.cizinec, "/" + Format(obj.sectiPolozky(zbozi, CInt(RBL_odber.SelectedValue), prihlasen.VC, "EUR", True), "#,0.00 €"), "") + "</td></tr>")


            'Cena celkem s DPH
            sb.Append("<tr><td colspan='" + colspan + "'  align='right'>" & GetLocalResourceObject("RPT_VybraneZbozi_Col12").ToString & " &nbsp;-&nbsp;</td>" _
                          & "<td align='right'>" + Format(obj.sectiPolozky(zbozi, CInt(RBL_odber.SelectedValue), prihlasen.VC, "cs-CZ"), "#,0.0 Kč") + IIf(typZakaznika.cizinec, "/" + Format(obj.sectiPolozky(zbozi, CInt(RBL_odber.SelectedValue), prihlasen.VC, "EUR"), "#,0.00 €"), "") + "</td></tr>")


            'Postovne a Celkova cena

            If typZakaznika.statName = "Czech Republic" Then
                sb.Append("<tr><td colspan='" + colspan + "'  align='right'>" & GetLocalResourceObject("code_text2").ToString & " &nbsp;-&nbsp;</td><td align='right'>" + Format(postovne, "#,0 Kč") + "</td></tr>")
                sb.Append("<tr><td colspan='" + colspan + "'  align='right'>" & GetLocalResourceObject("RPT_VybraneZbozi_Col4").ToString & " &nbsp;-&nbsp;</td><td align='right' style='background-color:#fdeaa5;'>" + Format(postovne() + sumaObj, "#,0 Kč") + "</td></tr>")
            End If




            sb.Append("</table><br />")

            Dim poznamka As TextBox
            If FRV_zakaznik.CurrentMode = FormViewMode.ReadOnly Then
                poznamka = CType(FRV_zakaznik.FindControl("txb_poznamka"), TextBox)
            Else
                poznamka = CType(FRV_zakaznik.FindControl("txb_insertPoznamka"), TextBox)
            End If
            If Not String.IsNullOrEmpty(Trim(poznamka.Text)) Then
                sb.AppendLine()
                sb.Append("<br /><b>" & GetLocalResourceObject("FRV_title4").ToString & ":</b><br />")
                sb.Append(Trim(poznamka.Text))
                sb.Append("<br />")
                poznamka.Text = ""
            End If

            sb.AppendLine()

            'Zpusob doruceni
            sb.Append("<br /><b>" & GetLocalResourceObject("doruceni").ToString & ":</b><br />")
            'Pokud je to bez postovneho tak nezobrazim cenu dopravy
            If postovne() <> 0 Or typZakaznika.cizinec Then
                sb.Append(RBL_odber.SelectedItem.Text & "<br /> ")
            Else
                sb.Append(Mid(RBL_odber.SelectedItem.Text, 1, InStr(RBL_odber.SelectedItem.Text, "(") - 1) & "<br /> ")
            End If

            sb.AppendLine()

            'Pri prevodu nebo PayPal
            If RBL_odber.SelectedValue = "1" Or RBL_odber.SelectedValue = "2" Or RBL_odber.SelectedValue = "3" Then
                sb.Append(GetLocalResourceObject("code_text13").ToString & "<br />")
            End If


            sumaVc = obj.sectiVC(zbozi)

            If ((sumaObj <= 3000 And Not prihlasen.VC) Or (prihlasen.VC And sumaVc <= 10000)) Then
                If RBL_odber.SelectedValue = "0" Then sb.Append(GetLocalResourceObject("code_text1").ToString & "<br />")
                If RBL_odber.SelectedValue = "0" And typZakaznika.statName = "Slovakia" Then sb.Append(GetLocalResourceObject("code_text15").ToString & "<br />")
            ElseIf typZakaznika.statName = "Czech Republic" Then
                sb.Append(String.Format(GetLocalResourceObject("bezPostovneho").ToString, IIf(prihlasen.VC, "10000", "3000")) & "<br />")
            End If

            If prihlasen.VC Then
                sb.Append("<br /><b>" & GetLocalResourceObject("code_text5").ToString & ":</b><br />")
                sb.Append(String.Format(GetLocalResourceObject("code_text6").ToString & " : {0}<br />", prihlasen.Firma))
            End If


            sb.Append("<br /><b>" & GetLocalResourceObject("FRV_title2").ToString & "</b><br />")

            If FRV_zakaznik.CurrentMode = FormViewMode.ReadOnly Then
                sb.Append(String.Format(GetLocalResourceObject("FRV_row11").ToString & " {0} ", RTrim(CType(FRV_zakaznik.FindControl("txb_FirmaAdresa"), Label).Text))) 'Firma
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row12").ToString & " {0} ", RTrim(CType(FRV_zakaznik.FindControl("txb_ICOAdresa"), Label).Text))) 'ICO
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row13").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_DICAdresa"), Label).Text))) 'DIC
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row1").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_Prijmeni"), Label).Text)))
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row2").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_Jmeno"), Label).Text)))
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row5").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_Ulice"), Label).Text)))
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row6").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_Mesto"), Label).Text)))
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row7").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_PSC"), Label).Text)))
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row8").ToString & " {0}<br />", RTrim(typZakaznika.statName)))
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row4").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_Telefon"), Label).Text)))
                sb.AppendLine()
                sb.Append("<br /><b>" & GetLocalResourceObject("FRV_title3").ToString & "</b><br />")
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row5").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_FUlice"), Label).Text)))
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row6").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_FMesto"), Label).Text)))
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row7").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_FPSC"), Label).Text)))
                If Not String.IsNullOrEmpty(RTrim(CType(FRV_zakaznik.FindControl("txb_FUlice"), Label).Text)) Then
                    sb.AppendLine()
                    sb.Append(String.Format(GetLocalResourceObject("FRV_row8").ToString & " {0}<br />", RTrim(typZakaznika.statName)))
                End If
                sb.AppendLine()
                mailAdr = RTrim(CType(FRV_zakaznik.FindControl("txb_Mail"), Label).Text)
            Else
                sb.Append(String.Format(GetLocalResourceObject("FRV_row11").ToString & " {0} ", RTrim(CType(FRV_zakaznik.FindControl("txb_insert_FirmaAdresa"), TextBox).Text))) 'Firma
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row12").ToString & " {0} ", RTrim(CType(FRV_zakaznik.FindControl("txb_insert_ICOAdresa"), TextBox).Text))) 'ICO
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row13").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_insert_DICAdresa"), TextBox).Text))) 'DIC
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row1").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_insertPrijmeni"), TextBox).Text)))
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row2").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_insertJmeno"), TextBox).Text)))
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row5").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_insertUlice"), TextBox).Text)))
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row6").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_insertMesto"), TextBox).Text)))
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row7").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_insertPSC"), TextBox).Text)))
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row8").ToString & " {0}<br />", RTrim(typZakaznika.statName)))
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row4").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_insertTelefon"), TextBox).Text)))
                sb.AppendLine()
                sb.Append("<br /><b>" & GetLocalResourceObject("FRV_title3").ToString & "</b><br />")
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row5").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_insertFUlice"), TextBox).Text)))
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row6").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_insertFMesto"), TextBox).Text)))
                sb.AppendLine()
                sb.Append(String.Format(GetLocalResourceObject("FRV_row7").ToString & " {0}<br />", RTrim(CType(FRV_zakaznik.FindControl("txb_insertFPSC"), TextBox).Text)))
                If Not String.IsNullOrEmpty(RTrim(CType(FRV_zakaznik.FindControl("txb_insertFUlice"), TextBox).Text)) Then
                    sb.AppendLine()
                    sb.Append(String.Format(GetLocalResourceObject("FRV_row8").ToString & " {0}<br />", RTrim(typZakaznika.statName)))
                End If
                sb.AppendLine()
                mailAdr = RTrim(CType(FRV_zakaznik.FindControl("txb_insertMail"), TextBox).Text)

            End If

            sb.AppendLine()
            sb.Append("<br />" & GetLocalResourceObject("code_text7").ToString)
            'Poslat mail
            Msg.From = New System.Net.Mail.MailAddress("objednavky@horejsi.cz", "e-Obchod Hořejší")
            Msg.Subject = GetLocalResourceObject("code_text8").ToString & idObjednavky.ToString
            Msg.Body = sb.ToString

            'Debug.Print(sb.ToString)

            adresat = New MailAddress(mailAdr)
            Msg.To.Add(adresat)
            Msg.Bcc.Add(New MailAddress("objednavky@horejsi.cz"))
            Msg.IsBodyHtml = True

            Try

                Senderx.Send(Msg)
                lbl_stavObjednavky.Text = GetLocalResourceObject("code_text9").ToString
            Catch ex As SmtpFailedRecipientsException
                For i As Integer = 0 To ex.InnerExceptions.Length - 1
                    status = ex.InnerExceptions(i).StatusCode
                    If status = SmtpStatusCode.MailboxBusy OrElse status = SmtpStatusCode.MailboxUnavailable Then
                        logger.WriteLogFile(Me.GetType.Name, "odeslatObjednavku(" + idObjednavky.ToString + ")", "Je zatizeny server - zkusim za 5s zopakovat")
                        System.Threading.Thread.Sleep(5000)
                        Senderx.Send(Msg)
                    Else
                        logger.WriteLogFile(Me.GetType.Name, "odeslatObjednavku(" + idObjednavky.ToString + ")", "Jina chyba - " + ex.InnerExceptions(i).Message.ToString)
                        lbl_stavObjednavky.Text = GetLocalResourceObject("code_text10").ToString
                        'MsgBox("Failed to deliver message to {0}", MsgBoxStyle.Information, ex.InnerExceptions(i).FailedRecipient)

                    End If
                Next

            Catch ex As SmtpException
                logger.WriteLogFile(Me.GetType.Name, "odeslatObjednavku(" + IIf(String.IsNullOrEmpty(idObjednavky.ToString), "-", idObjednavky.ToString) + ")", "SmtpException - " + ex.InnerException.InnerException.Message.ToString)
                lbl_stavObjednavky.Text = GetLocalResourceObject("code_text10").ToString
                'MsgBox("Failed to deliver message to {0}", MsgBoxStyle.Information, ex.InnerException.InnerException.Message.ToString)
            Finally
                'Po uspesne objednavce,zruseni vybranych produktu
                Session("zvoleneZbozi") = Nothing
                RPT_VybraneZbozi.DataBind()
                RPT_VybraneZbozi.Visible = False
                lbl_stavObjednavky.Visible = True
                CType(Master.FindControl("lbl_cenaNakupu"), Label).Text = 0
                CType(Master.FindControl("lbl_pocetPolozek"), Label).Text = 0
                RPT_VybraneZbozi.Visible = False
                RBL_odber.Visible = False
                FRV_zakaznik.Visible = False
                Localize3.Visible = False
                Localize4.Visible = False
                lbl_cenaCelkem.Visible = False
                lbl_stavObjednavky.Visible = True
            End Try

        Else
            'Nemohl jsem zapsat objednavku do db
            lbl_stavObjednavky.Text = GetLocalResourceObject("code_text11").ToString

        End If


    End Sub

    Private Function postovne() As Integer
        Dim sumaVC As Single = obj.sectiVC(CType(Session("zvoleneZbozi"), ArrayList))
        If (sumaObj <= 3000 And Not prihlasen.VC) Or (prihlasen.VC And sumaVC <= 10000) Then
            postovne = StN(RBL_odber.SelectedItem.Text)
        Else
            postovne = 0
        End If
        Return postovne
    End Function
    Function StN(ByVal SwS As String) As Integer
        'Vytazeni cisla ze stringu
        Dim i As Integer
        StN = 0
        If Len(SwS) Then
            For i = 1 To Len(SwS)
                If Val(Mid$(SwS, i)) <> 0 Then
                    StN = Val(Mid$(SwS, i))
                    Exit For
                End If
            Next
        End If
    End Function


    Private Function zaznamObjednavky() As Boolean
        'Zjisti id zakaznika
        Dim dsZakaznik As DataView = CType(DS_Zakaznik.Select(DataSourceSelectArguments.Empty), DataView)
        Dim dsObjednavka As DataView
        Dim zbozi As New ArrayList()
        Dim mail As Emails = New Emails
        Dim komu As MailAddress = New MailAddress("mr.datel@gmail.com")
        Dim predmet As String = "Nelze uložit objednávku!"
        Dim kurz As Single = kurzEUR


        DS_Objednavka.SelectCommand = "SELECT max(ID_objednavky) as maxID from T_Objednavky"
        dsObjednavka = CType(DS_Objednavka.Select(DataSourceSelectArguments.Empty), DataView)
        idObjednavky = IIf(IsNumeric(dsObjednavka.Table.Rows(0)("maxID")), dsObjednavka.Table.Rows(0)("maxID"), 0) + 1

        Try
            idZakaznik = dsZakaznik.Table.Rows(0)("ID_zakaznik")
        Catch ex As Exception
            Dim chyba As String
            If prihlasen.id = 0 Then
                chyba = String.Format("Nenalezen v db zákazník - {0}!", neregUzivatel)
            Else
                chyba = String.Format("Nenalezeno ID zakaznika - {0}!", prihlasen.id)
            End If
            mail.OdesliMail(komu, predmet, chyba)
            Return False
        End Try


        lang = CultureInfo.CurrentCulture.ToString

        zbozi = CType(Session("zvoleneZbozi"), ArrayList)


        For Each polozka As VybraneZbozi In zbozi
            DS_Objednavka.InsertCommand = String.Format("INSERT INTO T_Objednavky(ID_zakaznik, ID_objcislo, ID_objednavky, Mnozstvi, Datum_objednavky, Doprava, Jazyk, KurzEUR) VALUES ({0}, '{1}', {2}, {3}, convert(smalldatetime,'{4}',104), '{5}','{6}', {7}) ", idZakaznik, polozka.objcislo, idObjednavky, polozka.mnozstvi, Format(Now, "dd.MM.yyyy"), RBL_odber.SelectedValue, lang, Replace(kurz, ",", "."))
            Try
                DS_Objednavka.Insert()
            Catch ex As Exception
                mail.OdesliMail(komu, predmet, String.Format("Nemohu vložit do objednávek tento produkt - {0} !" + vbCrLf + "Výpis chyby : " + ex.Message, polozka.objcislo))
                Return False
            End Try
        Next

        'Zapis poznamky k objednavce 
        Dim textPoznamky As TextBox
        If FRV_zakaznik.CurrentMode = FormViewMode.ReadOnly Then
            textPoznamky = CType(FRV_zakaznik.FindControl("txb_poznamka"), TextBox)
        Else
            textPoznamky = CType(FRV_zakaznik.FindControl("txb_insertPoznamka"), TextBox)
        End If
        'Pokud neni vyplnena poznamka tak nezapisuji do db
        If Not String.IsNullOrEmpty(textPoznamky.Text) Then
            DS_Poznamky.InsertCommand = String.Format("INSERT INTO T_Poznamky (ID_Objednavky, Text) VALUES ({0},'{1}')", idObjednavky, Trim(textPoznamky.Text))
            Try
                DS_Poznamky.Insert()
            Catch ex As Exception
                mail.OdesliMail(komu, predmet, String.Format("Nemohu přidat poznámku({0}) k id_objednavky({1})", idObjednavky, Trim(textPoznamky.Text)))
            End Try
        End If

        'Objednavka a zapsana do db prijata
        Return True

    End Function

    Protected Sub BTN_Objednat_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        odeslatObjednavku()
    End Sub


    Protected Sub RBL_odber_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles RBL_odber.SelectedIndexChanged
        Dim zbozi As New ArrayList()

        zbozi = CType(Session("zvoleneZbozi"), ArrayList)
        setCenaCelkem()
        If IsNothing(zbozi) Then Exit Sub
        'sumaObj = obj.sectiPolozky(zbozi, CInt(RBL_odber.SelectedValue), prihlasen.VC, lang)
        'CType(Master.FindControl("lbl_cenaNakupu"), Label).Text = Format(sumaObj, "### ##0,00")
        'CType(lbl_cenaCelkem, Label).Text = "Cena celkem : " + Format(sumaObj + getCenaDoruceni(), "### ##0,00 Kč")
        RPT_VybraneZbozi.DataSource = zbozi
        RPT_VybraneZbozi.DataBind()
    End Sub

    Private Sub setCenaCelkem()
        'Dim zbozi As New ArrayList()
        'zbozi = CType(Session("zvoleneZbozi"), ArrayList)
        'If IsNothing(zbozi) Then Exit Sub
        'sumaObj = obj.sectiPolozky(zbozi, CInt(RBL_odber.SelectedValue), prihlasen.VC, lang)
        Dim cenaKc As Single = getCenaZboziKc()
        CType(Master.FindControl("lbl_cenaNakupu"), Label).Text = Format(cenaKc, "### ##0")
        Dim cenaPayPal As Single = getCenaPayPal()
        Dim cenaDoruceni As Single = getCenaDoruceni()
        Dim cenaEUR As Single = getCenaZboziEUR()
        CType(lbl_cenaCelkem, Label).Text = "Cena celkem : " + Format(cenaKc + cenaDoruceni + cenaPayPal, "### ##0 Kč")
        If typZakaznika.statName = "Czech Republic" Then
            If cenaPayPal > 0 Then
                CType(lbl_cenaCelkem, Label).Text += " (včetně poplatku PayPal 3% z ceny zboží a dopravy)"
                'GetLocalResourceObject("lbl_cesta_fraze").ToString
            End If
        ElseIf typZakaznika.statName = "Slovakia" Then
            If RBL_odber.SelectedIndex = 0 Then
                CType(lbl_cenaCelkem, Label).Text += " + cena dopravy podle hmotnosti a dobírkové částky min. 280 Kč"
            ElseIf RBL_odber.SelectedIndex = 1 Then
                CType(lbl_cenaCelkem, Label).Text += " + cena dopravy podle hmotnosti min. 220 Kč"
            ElseIf RBL_odber.SelectedIndex = 2 Then
                CType(lbl_cenaCelkem, Label).Text += " + cena dopravy podle hmotnosti + poplatek PayPal 3% z ceny zboží a dopravy min. 230 Kč"
            End If
        Else
            CType(lbl_cenaCelkem, Label).Text += "/" + Format(cenaEUR + cenaDoruceni / kurzEUR + cenaPayPal / kurzEUR, "### ##0.00 €")
            CType(lbl_cenaCelkem, Label).Text += " + cena dopravy podle hmotnosti"
            If RBL_odber.SelectedIndex = 1 Then
                CType(lbl_cenaCelkem, Label).Text += " + poplatek PayPal 3% z ceny zboží a dopravy"
            End If
        End If
    End Sub

    Private Function getCenaZbozi(zeme As String) As Single
        Dim zbozi As New ArrayList()
        zbozi = CType(Session("zvoleneZbozi"), ArrayList)
        If IsNothing(zbozi) Then Return 0
        Return obj.sectiPolozky(zbozi, CInt(RBL_odber.SelectedValue), prihlasen.VC, zeme)
    End Function

    Private Function getCenaZboziKc() As Single
        Return getCenaZbozi("cs-CZ")
    End Function

    Private Function getCenaZboziEUR() As Single
        Return getCenaZbozi("")
    End Function


    Protected Sub ddl_insertstat_DataBound(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddl As DropDownList = CType(sender, DropDownList)

        If CultureInfo.CurrentCulture.ToString = "cs-CZ" And Not IsPostBack Then
            ddl.SelectedValue = 58
        End If

    End Sub

    Public Function getCenaPayPal() As Single
        Dim cena As Single = 0
        Dim isPayPal As Boolean = False

        If typZakaznika.statName = "Czech Republic" Then
            If RBL_odber.SelectedIndex = 2 Then isPayPal = True
        ElseIf typZakaznika.statName = "Slovakia" Then
        Else
        End If
        If isPayPal Then
            cena = (getCenaZboziKc() + getCenaDoruceni()) / 100 * 3
        End If
        Return cena
    End Function

    Public Function getCenaDoruceni() As Single
        If typZakaznika.statName = "Czech Republic" Then
            Dim cenyDoruceniCZDec(,) As Decimal = New Decimal(,) {{130, 100, 100, 0}, {120, 90, 90, 0}}
            Dim cast As Integer = IIf(typZakaznika.ochodnik, 1, 0)
            Return cenyDoruceniCZDec(cast, RBL_odber.SelectedIndex)
        End If
        Return 0
    End Function

    Public Sub zpusobDoruceni()
        'Naplneni zpusobu doruceni podle typu zakaznika
        Dim newItem As ListItem
        Dim zpusobDoruceniCZ(,) As String = New String(,) {{"Dobírka. Zásilka PPL CZ ",
                                                "Převod na účet. Zásilka PPL CZ ",
                                                "PayPal. Zásilka PPL CZ ",
                                                "Hotově. Osobní odběr "}, {"0", "1", "3", "4"}}
        Dim cenyDoruceniCZ(,) As String = New String(,) {{"(130,- Kč)", "(100,- Kč)", "(100,- Kč)", "(0,- Kč)"}, {"(120,- Kč)", "(90,- Kč)", "(90,- Kč)", "(0,- Kč)"}}
        Dim zpusobDoruceniSK(,) As String = New String(,) {{"Dobírka.PPL CZ/DHL Express Slovakia ",
                                                "Převod na EUR účet vedený u ČSOB na Slovensku.PPL CZ/DHL Express Slovakia ",
                                                "PayPal.PPL CZ/DHL Express Slovakia ",
                                                "Hotově. Osobní odběr "}, {"0", "1", "3", "4"}}
        Dim cenyDoruceniSK() As String = New String() {"(od 280,- Kč, podle hmotnosti a dobírkové částky)", "<br>(od 220,- Kč, podle hmotnosti)", "(od 230,- Kč, podle hmotnosti)", "(0,- Kč)"}
        Dim zpusobDoruceniEN(,) As String = New String(,) {{"Bank transfer",
                                                            "PayPal"}, {"1", "3"}}
        Dim zpusob(,) As String = New String(,) {{}, {}}
        Dim cena() As String = New String() {""}
        Dim cast As Integer

        If typZakaznika.statName = "Czech Republic" Then
            zpusob = zpusobDoruceniCZ.Clone()
            cast = IIf(typZakaznika.ochodnik, 1, 0)
            ReDim cena(cenyDoruceniCZ.GetUpperBound(1))
            For ind As Integer = 0 To cenyDoruceniCZ.GetUpperBound(1)
                cena(ind) = cenyDoruceniCZ(cast, ind)
            Next

        ElseIf typZakaznika.statName = "Slovakia" Then
            zpusob = zpusobDoruceniSK.Clone()
            ReDim cena(cenyDoruceniSK.GetUpperBound(0))
            For ind As Integer = 0 To cenyDoruceniSK.GetUpperBound(0)
                cena(ind) = cenyDoruceniSK(ind)
            Next
        Else
            ReDim cena(zpusobDoruceniEN.GetUpperBound(0))
            zpusob = zpusobDoruceniEN.Clone()
        End If


        RBL_odber.Items.Clear()

        For index As Integer = 0 To zpusob.GetUpperBound(1)
            newItem = New ListItem()
            newItem.Text = zpusob(0, index) + cena(index)
            newItem.Value = zpusob(1, index)
            RBL_odber.Items.Add(newItem)
        Next

        RBL_odber.SelectedIndex = 0
    End Sub
    Protected Sub ddl_stat_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        'Dim zeme As DropDownList = sender
        zpusobDoruceni()
    End Sub

    Protected Sub ddl_insertstat_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs)
        'Dim zeme As DropDownList = sender
        zpusobDoruceni()
        setCenaCelkem()
    End Sub
End Class
