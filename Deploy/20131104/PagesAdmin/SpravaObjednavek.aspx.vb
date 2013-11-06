Imports System.Data
Imports System.Diagnostics
Imports System.Net.Mail
Imports System.Globalization
Imports System.Threading
Imports KurzCNB
Imports PHE
Imports Emails

Partial Class Pages_SpravaObjednavek
    Inherits System.Web.UI.Page

    Public alert As New Alerts
    Public cenaPHE As New PHE

    Public Structure s_typZakaznika
        Dim registrace As Boolean 'registrovan = true
        Dim obchodnik As Boolean   'VC = true
        Dim statID As Integer
        Dim jazyk As String
        Dim cizinec As Boolean  'True kdyz to neni CZ nebo SK
        Dim mail As String
        Dim zpusobDoruceni As Integer
        Dim datumExpedice As String
        Dim idBaliku As String
        Dim kurz As Single
        Dim polozky As DataRowCollection
    End Structure
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
    Private _typZakaznika As s_typZakaznika
    Public Property typZakaznika(ByVal ID_objednavky As Integer) As s_typZakaznika
        Get

            Dim dvVypisObjednavky As DataView
            Dim dsComSel As String = DS_VypisObjednavky.SelectCommand
            DS_VypisObjednavky.SelectCommand = dsComSel + " AND ID_objednavky=" + ID_objednavky.ToString
            dvVypisObjednavky = DS_VypisObjednavky.Select(DataSourceSelectArguments.Empty)
           

            _typZakaznika.obchodnik = CBool(dvVypisObjednavky.Table.Rows(0).Item("Obchodnik"))
            _typZakaznika.registrace = CBool(dvVypisObjednavky.Table.Rows(0).Item("Registrovan"))
            _typZakaznika.statID = dvVypisObjednavky.Table.Rows(0).Item("Staty_ID")
            _typZakaznika.jazyk = dvVypisObjednavky.Table.Rows(0).Item("Jazyk").ToString
            _typZakaznika.mail = Trim(dvVypisObjednavky.Table.Rows(0).Item("Mail").ToString)
            _typZakaznika.zpusobDoruceni = CInt(dvVypisObjednavky.Table.Rows(0).Item("Doprava"))
            _typZakaznika.datumExpedice = dvVypisObjednavky.Table.Rows(0).Item("Datum_expedice")
            _typZakaznika.idBaliku = IIf(IsDBNull(dvVypisObjednavky.Table.Rows(0).Item("ID_baliku")), "", dvVypisObjednavky.Table.Rows(0).Item("ID_baliku"))
            _typZakaznika.kurz = IIf(IsDBNull(dvVypisObjednavky.Table.Rows(0).Item("KurzEUR")), 0, dvVypisObjednavky.Table.Rows(0).Item("KurzEUR"))

            _typZakaznika.cizinec = False

            If _typZakaznika.statID <> 58 And _typZakaznika.statID <> 199 Then
                _typZakaznika.cizinec = True
            End If

            _typZakaznika.polozky = dvVypisObjednavky.Table.Rows

            Return _typZakaznika
        End Get
        Set(ByVal value As s_typZakaznika)
            _typZakaznika = value
        End Set
    End Property

    Protected Sub ddl_pageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddl_pageSize.SelectedIndexChanged
        GV_Objednavky.PageSize = ddl_pageSize.SelectedValue
        FiltrObjednavek()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            txb_datumObjednavky.Text = Format(Now, "dd.MM.yyyy")
            
            FiltrObjednavek()

        End If

    End Sub

    Protected Sub BTN_vyhledej_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BTN_vyhledej.Click
       
        FiltrObjednavek()
        
    End Sub

    Private Sub FiltrObjednavek()
        Dim sb As StringBuilder = New StringBuilder()

        sb.Append(DS_Objednavky.SelectCommand)
        
        If Not String.IsNullOrEmpty(txb_datumObjednavky.Text) And String.IsNullOrEmpty(TXT_objednavka.Text) Then
            If String.IsNullOrEmpty(txb_interval.Text) Then
                sb.Append(" AND T_Objednavky.Datum_objednavky >= CONVERT (smalldatetime,'")
                sb.Append(Trim(txb_datumObjednavky.Text))
                sb.Append(" 00:00:00', 104) AND (T_Objednavky.Datum_objednavky < DATEADD(hour,24,convert(smalldatetime,'")
                sb.Append(Trim(txb_datumObjednavky.Text))
                sb.Append(" 00:00:00', 104)))")
            Else
                sb.Append(" AND T_Objednavky.Datum_objednavky <= convert(smalldatetime,'")
                sb.Append(Trim(txb_datumObjednavky.Text))
                sb.Append(" 00:00:00', 104) AND T_Objednavky.Datum_objednavky >= DATEADD(")
                sb.Append(ddl_rozsah.SelectedValue)
                sb.Append(", ")
                sb.Append((CInt((txb_interval.Text)) * -1))
                sb.Append(", CONVERT (smalldatetime,'")
                sb.Append(Trim(txb_datumObjednavky.Text))
                sb.Append(" 00:00:00', 104))")
            End If
        End If
        If Not String.IsNullOrEmpty(TXB_mailZakaznik.Text) Then
            sb.Append(" AND (T_Zakaznik.Mail = '")
            sb.Append(Trim(TXB_mailZakaznik.Text))
            sb.Append("')")
        End If
        If Not String.IsNullOrEmpty(TXB_cisloBaliku.Text) Then
            sb.Append(" AND (T_Objednavky.ID_baliku='")
            sb.Append(Trim(TXB_cisloBaliku.Text))
            sb.Append("')")
        End If

        If Not String.IsNullOrEmpty(TXT_objednavka.Text) Then
            sb.Append(" AND (T_Objednavky.ID_objednavky='")
            sb.Append(Trim(TXT_objednavka.Text))
            sb.Append("')")
        End If

        If CHB_neodeslane.Checked Then
            sb.Append(" AND (T_Objednavky.Expedovano = 0)")
        End If

        DS_Objednavky.SelectCommand = sb.ToString
        DS_Objednavky.Select(DataSourceSelectArguments.Empty)
        DS_Objednavky.DataBind()
        GV_Objednavky.DataBind()

    End Sub


    Protected Sub GV_Objednavky_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles GV_Objednavky.RowCommand

        FiltrObjednavek()

    End Sub

    Protected Sub DS_Objednavky_Inserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles DS_Objednavky.Inserted
        If e.AffectedRows = 1 Then

        Else
            alert.Show("Pozor, nepovedlo se vložit nový produkt do upravované objednávky.", "Pozor")
        End If
    End Sub

    Protected Sub DS_Objednavky_Inserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceCommandEventArgs) Handles DS_Objednavky.Inserting

        Dim dataObjednavky As DataView = DS_Objednavky.Select(DataSourceSelectArguments.Empty)
        Dim posData As Integer
        Dim idobj As String = CType(GV_DetailObjednavky.FooterRow.FindControl("ddl_newObjCislo"), DropDownList).SelectedValue
        Dim idzakaznik As Integer = 1
        Dim mnozstvi As Integer = CInt(CType(GV_DetailObjednavky.FooterRow.FindControl("txb_newMnozstvi"), TextBox).Text)
        Dim poznamka As String = CType(GV_DetailObjednavky.FooterRow.FindControl("txb_newPoznamka"), TextBox).Text
        Dim idobjednavky As Integer = CInt(GV_Objednavky.SelectedRow.Cells(0).Text)
        Dim datumobjednavky As String
        Dim doprava As Integer

        dataObjednavky.Sort = "ID_objednavky"
        posData = dataObjednavky.Find(idobjednavky)
        idzakaznik = dataObjednavky(posData)("ID_zakaznik")
        datumobjednavky = dataObjednavky(posData)("Datum_objednavky").ToString
        doprava = dataObjednavky(posData)("Doprava").ToString

        e.Command.Parameters("@ID_objCislo").Value = idobj
        e.Command.Parameters("@ID_objednavky").Value = idobjednavky
        e.Command.Parameters("@Mnozstvi").Value = mnozstvi
        e.Command.Parameters("@Storno_poznamka").Value = poznamka
        e.Command.Parameters("@ID_zakaznik").Value = idzakaznik
        e.Command.Parameters("@Datum_objednavky").Value = datumobjednavky
        e.Command.Parameters("@Doprava").Value = doprava
        e.Command.Parameters("@KurzEUR").Value = kurzEUR

    End Sub

    Protected Sub DS_Objednavky_Updated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles DS_Objednavky.Updated
        Dim dvObjed As DataView = CType(DS_Objednavky.Select(DataSourceSelectArguments.Empty), DataView)
        Dim expedovano As Boolean = False
        'Delam jen pri update datum_expedice.ne pri nastaveni expedovano
        If Not IsDBNull(e.Command.Parameters("@ID_objednavky").Value) Then
            For Each dr As DataRow In dvObjed.Table.Rows
                If dr.Item("ID_objednavky") = e.Command.Parameters("@ID_objednavky").Value Then
                    expedovano = CBool(dr.Item("Expedovano"))
                End If
            Next

            If e.AffectedRows <> 0 And Not expedovano Then
                odesliPotvrzeni(e.Command.Parameters("@ID_objednavky").Value)
            End If
        End If
    End Sub

    Private Sub odesliPotvrzeni(ByVal ID_objednavky As Integer)
        Dim soucet As Single
        Dim soucetVCbezDPH As Single
        Dim postovne As Single = 0
        Dim proc9 As Boolean = False
        Dim email As Emails = New Emails
        

        Dim infoObj As New s_typZakaznika
        infoObj = typZakaznika(ID_objednavky)
        Dim cult As CultureInfo = New CultureInfo(infoObj.jazyk)
        Dim kurz As Single

        'Pokud neni u objednavky ulozen kurz vem aktualni
        If infoObj.kurz <> 0 Then
            kurz = infoObj.kurz
        Else
            kurz = kurzEUR
        End If

        If Not String.IsNullOrEmpty(infoObj.datumExpedice) Then
            Dim bodyMail As StringBuilder = New StringBuilder
            bodyMail.Append(HttpContext.GetGlobalResourceObject("MailText", "pozdrav", cult).ToString & "<br/>")
            bodyMail.AppendLine()

            If infoObj.zpusobDoruceni <> 4 Then
                bodyMail.Append(String.Format(HttpContext.GetGlobalResourceObject("MailText", "expedice", cult).ToString & "<br/>", infoObj.datumExpedice, ID_objednavky))
                bodyMail.AppendLine()
                bodyMail.Append(String.Format(HttpContext.GetGlobalResourceObject("MailText", "obsah", cult).ToString & "<br/><br/>"))
            Else
                bodyMail.Append(String.Format(HttpContext.GetGlobalResourceObject("MailText", "kompletace", cult).ToString & "<br/>", infoObj.datumExpedice, ID_objednavky))
                bodyMail.AppendLine()
                bodyMail.Append(HttpContext.GetGlobalResourceObject("MailText", "vyzvednuti", cult).ToString & "<br/><br/>")
            End If
            bodyMail.AppendLine()
            'Hlavicka tabulky
            If infoObj.obchodnik Then
                bodyMail.Append("<table border=1 style='border-collapse: collapse'><tr><td>" & HttpContext.GetGlobalResourceObject("MailText", "table_Col1", cult).ToString & "</td><td>" _
                          & HttpContext.GetGlobalResourceObject("MailText", "table_Col2", cult).ToString & "</td><td>" _
                          & HttpContext.GetGlobalResourceObject("MailText", "table_Col3", cult).ToString & "</td><td>" & HttpContext.GetGlobalResourceObject("MailText", "table_Col4", cult).ToString & "</td><td>" _
                          & HttpContext.GetGlobalResourceObject("MailText", "table_Col5", cult).ToString & "</td><td>" & HttpContext.GetGlobalResourceObject("MailText", "table_Col8", cult).ToString & "</td><td>" _
                          & HttpContext.GetGlobalResourceObject("MailText", "table_Col7", cult).ToString & "</td><td>" & HttpContext.GetGlobalResourceObject("MailText", "table_Col9", cult).ToString & "</td><td>" _
                          & HttpContext.GetGlobalResourceObject("MailText", "table_Col10", cult).ToString & "</td></tr>")
            Else
                bodyMail.Append("<table border=1 style='border-collapse: collapse'><tr><td>" & HttpContext.GetGlobalResourceObject("MailText", "table_Col1", cult).ToString & "</td><td>" _
                         & HttpContext.GetGlobalResourceObject("MailText", "table_Col2", cult).ToString & "</td><td>" _
                         & HttpContext.GetGlobalResourceObject("MailText", "table_Col3", cult).ToString & "</td><td>" & HttpContext.GetGlobalResourceObject("MailText", "table_Col4", cult).ToString & "</td><td>" _
                         & HttpContext.GetGlobalResourceObject("MailText", "table_Col6", cult).ToString & "</td><td>" & HttpContext.GetGlobalResourceObject("MailText", "table_Col9", cult).ToString & "</td><td>" _
                         & HttpContext.GetGlobalResourceObject("MailText", "table_Col10", cult).ToString & "</td></tr>")
            End If

            bodyMail.AppendLine()

            'data tabulky
            Dim PHE711, PHE715 As Boolean
            Dim PHE = 0.0, PHEDPH, PHE_EUR, PHEDPH_EUR, DPH As Single

            For Each dr As DataRow In infoObj.polozky
                PHE711 = CType(dr.Item("PHE711"), Boolean)
                PHE715 = CType(dr.Item("PHE715"), Boolean)
                DPH = 1 + CType(dr.Item("DPH"), Single) / 100.0

                If PHE711 Then
                    PHE = cenaPHE.nactiUlozenyPoplatek("PHE711")

                End If
                If PHE715 Then
                    PHE = cenaPHE.nactiUlozenyPoplatek("PHE715")
                End If
                PHEDPH = PHE * DPH
                PHE_EUR = PHE / kurz
                PHEDPH_EUR = PHE_EUR / kurz

                bodyMail.Append("<tr>")
                bodyMail.Append(String.Format("<td>{0}</td>", dr.Item("ID_objcislo").ToString))
                bodyMail.Append(String.Format("<td>{0}</td>", dr.Item(IIf(infoObj.jazyk = "cs-CZ", "Text_CZ", "Text_EN")).ToString))
                bodyMail.Append(String.Format("<td align=center>{0} {1}</td>", dr.Item("Mnozstvi").ToString, dr.Item("Jednotka").ToString))
                If infoObj.obchodnik Then
                    bodyMail.Append(String.Format("<td align=center>{0} Kč ", Format(dr.Item("VC") + PHE, "#,0.0")) + IIf(infoObj.cizinec, "/" + Single.Parse(dr.Item("VC") + PHE / kurz).ToString("F2") + " € </td>", "</td>"))
                    bodyMail.Append(String.Format("<td align=center>{0} Kč</td>", Format(dr.Item("VCDPH") + PHEDPH, "#,0.0")))
                    bodyMail.Append(String.Format("<td align=center>{0} Kč</td>", IIf(dr.Item("Storno"), "-", Format((dr.Item("VCDPH") + PHEDPH) * dr.Item("Mnozstvi"), "#,0.0"))))
                    bodyMail.Append(String.Format("<td align=center>{0}</td>", dr.Item("Marze").ToString))
                    bodyMail.AppendLine()
                Else
                    bodyMail.Append(String.Format("<td align=center>{0} Kč ", Format(dr.Item("MCDPH") + PHEDPH, "#,0.0")) + IIf(infoObj.cizinec, "/ " + Single.Parse(dr.Item("MCDPH") + PHEDPH / kurz).ToString("F2") + " € </td>", "</td>"))
                    bodyMail.Append(String.Format("<td align=center>{0} Kč ", IIf(dr.Item("Storno"), "-", Format((dr.Item("MCDPH") + PHEDPH) * dr.Item("Mnozstvi"), "#,0.0"))) + IIf(infoObj.cizinec, "/ " + Single.Parse(((dr.Item("MCDPH") + PHEDPH) * dr.Item("Mnozstvi")) / kurz).ToString("F2") + " € </td>", "</td>"))
                    bodyMail.AppendLine()
                End If
                bodyMail.Append(String.Format("<td align=center>{0}</td>", IIf(dr.Item("Storno"), HttpContext.GetGlobalResourceObject("MailText", "ano", cult).ToString, "-")))
                bodyMail.Append(String.Format("<td>{0}</td>", dr.Item("Storno_poznamka").ToString))
                bodyMail.Append("</tr>")
                If Not dr.Item("Storno") Then
                    If infoObj.obchodnik Then
                        soucet += (dr.Item("VCDPH") + PHEDPH) * dr.Item("Mnozstvi")
                        soucetVCbezDPH += (dr.Item("VC") + PHE) * dr.Item("Mnozstvi")
                    Else
                        soucet += (dr.Item("MCDPH") + PHEDPH) * dr.Item("Mnozstvi")
                    End If
                End If
            Next


            bodyMail.Append("</table><br/>")
            bodyMail.AppendLine()

            'Urceni postovneho
            If (soucet <= 3000 And Not infoObj.obchodnik) Or (infoObj.obchodnik And soucetVCbezDPH <= 10000) Then
                If infoObj.zpusobDoruceni = 0 And infoObj.statID = 58 And Not infoObj.obchodnik Then
                    postovne = 130

                ElseIf (infoObj.zpusobDoruceni = 1 Or infoObj.zpusobDoruceni = 3) And infoObj.statID = 58 And Not infoObj.obchodnik Then
                    postovne = 100

                End If

            End If

            'Vypis ceny zbozi,postovneho a celkove ceny 
            If Not infoObj.cizinec And postovne <> 0 Then
                bodyMail.Append(String.Format("<p> Cena objednaného zboží : <b>{0}</b> Kč </p>", Format(soucet, "#,0")))
                bodyMail.Append(String.Format("<p> Cena přepravy : <b>{0}</b> Kč </p>", Format(postovne, "#,0")))
                bodyMail.Append(String.Format("<p> Cena celkem : <span style='background:#fdeaa5'><b>{0}</b> Kč</span> </p>", Format(soucet + postovne, "#,0")))
            ElseIf infoObj.statID = 199 And infoObj.zpusobDoruceni <> 4 Then
                bodyMail.Append(String.Format(HttpContext.GetGlobalResourceObject("MailText", "celkemobj", cult).ToString & "<span style='background:#fdeaa5'> <b>{0}</b> Kč </span><br/>", Format(soucet + postovne, "#,0")))
                bodyMail.Append(String.Format("Zásilka číslo <b>{0}</b> byla odeslána službou GLS. <br/><br/>", Trim(infoObj.idBaliku)))
            Else
                bodyMail.Append(String.Format(HttpContext.GetGlobalResourceObject("MailText", "celkemobj", cult).ToString & "<span style='background:#fdeaa5'> <b>{0}</b> Kč </span>", Format(soucet + postovne, "#,0")) + IIf(infoObj.cizinec, "<span style='background:#fdeaa5'>/ <b>" + Math.Round(Single.Parse((soucet + postovne) / kurz), 1).ToString("F2") + "</b> €</span><br/>", "<br/>"))
                If infoObj.zpusobDoruceni > 0 And infoObj.zpusobDoruceni < 4 And Not infoObj.obchodnik Then bodyMail.Append(HttpContext.GetGlobalResourceObject("MailText", "platba", cult).ToString)
                bodyMail.AppendLine()
            End If

            If infoObj.zpusobDoruceni <= 3 And infoObj.statID = 58 And soucet <> 0.0 Then
                bodyMail.Append("<br/><br/>")
                bodyMail.Append("Na Váš email obdržíte zprávu od společnosti PPL CZ s odkazem na sledování zásilky.")
                'bodyMail.Append(String.Format("Balík č.<b>{0}</b> můžete sledovat na webu České pošty - sledování zásilek <br/><br/>", Trim(infoObj.idBaliku)))
                'bodyMail.Append("Sledování zásilek : <a href='http://www.cpost.cz/cz/nastroje/sledovani-zasilky.php'>Odkaz na sledování zásilek</a> (Zásilka se objeví v evidenci nejdříve dnes večer).")
                bodyMail.AppendLine()
            End If
        


            bodyMail.Append("<br/><br/>" & HttpContext.GetGlobalResourceObject("MailText", "podekovani", cult).ToString)

            Debug.Print(bodyMail.ToString)

            Dim odeslano As Boolean
            odeslano = email.OdesliMail(od:=New MailAddress("objednavky@horejsi.cz", "e-Obchod Hořejší"), komu:=New MailAddress(infoObj.mail), predmet:=HttpContext.GetGlobalResourceObject("MailText", "mailPredmet", cult).ToString, zprava:=bodyMail.ToString, kopie:=New MailAddress("objednavky@horejsi.cz"))

            'nastaveni priznaku expedovani
            If odeslano Then
                Dim dsUpdate As String = String.Format("UPDATE T_Objednavky SET Expedovano = 1 WHERE (ID_objednavky = {0})", ID_objednavky)
                DS_Objednavky.UpdateCommand = dsUpdate
                DS_Objednavky.Update()
            Else
                alert.Show(String.Format("Pozor nepovedlo se odeslat mail potvrzovací mail na adresu {0}", infoObj.mail), "Pozor")
            End If
        End If

    End Sub

    Protected Sub btn_pridat_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        DS_Objednavky.Insert()
        FiltrObjednavek()
        DS_DetailObjednavky.Select(DataSourceSelectArguments.Empty)
        DS_DetailObjednavky.DataBind()
        GV_DetailObjednavky.DataBind()
        updatePanel.Update()
    End Sub

    Protected Sub lnk_zakaznikDetail_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim lnbDetail As LinkButton = CType(sender, LinkButton)
        DS_Zakaznik.SelectParameters("ID_zakaznik").DefaultValue = CInt(lnbDetail.CommandArgument)
        DS_Zakaznik.Select(DataSourceSelectArguments.Empty)
        dtv_Zakaznik.Visible = True
        dtv_Zakaznik.DataBind()
        mdlPopup.Show()
    End Sub

End Class
