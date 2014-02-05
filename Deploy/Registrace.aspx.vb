Imports System.Globalization
Imports System.Net.Mail
Imports System.Data
Imports Objednavka
Imports Alerts


Partial Class Pages_Registrace
    Inherits BasePage
    Public alert As Alerts = New Alerts
    Dim returnPage As String = ""

    Protected Sub FRV_zakaznik_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FRV_zakaznik.ItemInserted
        Dim Msg As New MailMessage()
        Dim Senderx As New SmtpClient()
        Dim sb As StringBuilder = New StringBuilder
        Dim itemArray(e.Values.Count - 1) As DictionaryEntry
        Dim polozka As DictionaryEntry
        Dim uzivatel As String = ""
        Dim heslo As String = ""
        Dim prijmeni As String = ""
        Dim jmeno As String = ""
        Dim telefon As String = ""
        Dim mesto As String = ""
        Dim psc As String = ""
        Dim ulice As String = ""
        Dim firma As String = ""
        Dim ico As String = ""
        Dim dic As String = ""
        Dim mailAdr As String = ""
        Dim stat As String = ""
        Dim adresat As MailAddress

        e.Values.CopyTo(itemArray, 0)

        If e.Exception Is Nothing Then

            If e.AffectedRows = 1 Then

                alert.Show(GetLocalResourceObject("cod_20").ToString, GetLocalResourceObject("popisBlok").ToString)
                'Poslu mail
                Msg.From = New System.Net.Mail.MailAddress("obchod@horejsi.cz", "e-Obchod Hořejší")
                Msg.Subject = GetLocalResourceObject("cod_21").ToString
                'Zadany informace
                For Each polozka In itemArray
                    Select Case polozka.Key
                        Case "Mail"
                            mailAdr = polozka.Value
                        Case "Uzivatel"
                            uzivatel = polozka.Value
                        Case "Heslo"
                            heslo = polozka.Value
                        Case "Prijmeni"
                            prijmeni = polozka.Value
                        Case "Jmeno"
                            jmeno = polozka.Value
                        Case "Telefon"
                            telefon = polozka.Value
                        Case "Mesto"
                            mesto = polozka.Value
                        Case "Ulice"
                            ulice = polozka.Value
                        Case "PSC"
                            psc = polozka.Value
                        Case "Firma"
                            firma = polozka.Value
                        Case "IC"
                            ico = polozka.Value
                        Case "DIC"
                            dic = polozka.Value
                        
                    End Select
                Next

                stat = CType(FRV_zakaznik.FindControl("ddl_insertstat"), DropDownList).SelectedItem.Text

                'Text mailu
                sb.Append("<p>" + GetLocalResourceObject("cod_1").ToString + "</p>")
                sb.AppendLine()
                sb.Append("<p>" + GetLocalResourceObject("cod_2").ToString + "<p>")
                sb.AppendLine()
                sb.Append(String.Format("<table border=0px><tr><td>" + GetLocalResourceObject("cod_3").ToString + "</td><td style=""padding-left: 10px"">{0}</td></tr>", uzivatel))
                sb.Append(String.Format("<tr><td>" + GetLocalResourceObject("cod_4").ToString + "</td><td style=""padding-left: 10px"">{0}</td></tr>", heslo))
                sb.Append(String.Format("<tr><td>" + GetLocalResourceObject("cod_5").ToString + "</td style=""padding-left: 10px;""><td style=""padding-left: 10px"">{0}</td></tr>", prijmeni))
                sb.Append(String.Format("<tr><td>" + GetLocalResourceObject("cod_6").ToString + "</td><td style=""padding-left: 10px"">{0}</td></tr>", jmeno))
                sb.Append(String.Format("<tr><td>" + GetLocalResourceObject("cod_7").ToString + "</td><td style=""padding-left: 10px"">{0}</td></tr>", telefon))
                sb.Append(String.Format("<tr><td>" + GetLocalResourceObject("cod_8").ToString + "</td><td style=""padding-left: 10px"">{0}</td></tr>", mailAdr))
                sb.Append(String.Format("<tr><td>" + GetLocalResourceObject("cod_9").ToString + "</td><td style=""padding-left: 10px"">{0}</td></tr>", mesto))
                sb.Append(String.Format("<tr><td>" + GetLocalResourceObject("cod_10").ToString + "</td><td style=""padding-left: 10px"">{0}</td></tr>", ulice))
                sb.Append(String.Format("<tr><td>" + GetLocalResourceObject("cod_11").ToString + "</td><td style=""padding-left: 10px"">{0}</td></tr>", psc))
                sb.Append(String.Format("<tr><td>" + GetLocalResourceObject("cod_22").ToString + "</td><td style=""padding-left: 10px"">{0}</td></tr>", stat))
                If Not String.IsNullOrEmpty(firma) Then
                    sb.Append(String.Format("<tr><td>" + GetLocalResourceObject("cod_12").ToString + "</td><td style=""padding-left: 10px"">{0}</td></tr>", firma))
                    sb.Append(String.Format("<tr><td>" + GetLocalResourceObject("cod_13").ToString + "</td><td style=""padding-left: 10px"">{0}</td></tr>", ico))
                    If CultureInfo.CurrentCulture.ToString = "cs-CZ" Then
                        sb.Append(String.Format("<tr><td>" + GetLocalResourceObject("cod_14").ToString + "</td><td style=""padding-left: 10px"">{0}</td></tr></table>", dic))
                    End If
                    sb.AppendLine()
                    sb.Append("<p>" + GetLocalResourceObject("cod_15").ToString + "</p>")
                    'Kopie pokud zada o VC
                    Msg.Bcc.Add(New MailAddress("obchod@horejsi.cz"))
                Else
                    sb.Append("</table>")
                End If
                sb.Append("<p>" + GetLocalResourceObject("cod_16").ToString + "<a href=""mailto:info@horejsi.cz""> info@horejsi.cz</a></p>")

                Msg.Body = sb.ToString

                adresat = New MailAddress(mailAdr)
                Msg.To.Add(adresat)
                Msg.IsBodyHtml = True
                Try
                    Senderx.Send(Msg)
                Catch ex As Exception
                    alert.Show(GetLocalResourceObject("cod_17").ToString, GetLocalResourceObject("popisBlok").ToString)
                End Try
            Else
                alert.Show(GetLocalResourceObject("cod_18").ToString, GetLocalResourceObject("popisBlok").ToString)

            End If

        Else

            If e.Exception.Message.Contains("duplicate key") Then
                alert.Show(GetLocalResourceObject("cod_19").ToString, GetLocalResourceObject("popisBlok").ToString)
            End If
            e.ExceptionHandled = True
            e.KeepInInsertMode = True
        End If

    End Sub

    Protected Sub FRV_zakaznik_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles FRV_zakaznik.ItemInserting
        Dim jazyk As String = CultureInfo.CurrentCulture.ToString
        Dim stat As Integer = CInt(CType(FRV_zakaznik.FindControl("ddl_insertstat"), DropDownList).SelectedValue)

        For Each param As DictionaryEntry In e.Values
            If param.Key = "Firma" And Not String.IsNullOrEmpty(param.Value.ToString) Then
                DS_Zakaznik.InsertParameters("Obchodnik").DefaultValue = True
            End If
        Next

        If jazyk = "cs-CZ" And stat <> 58 Then
            jazyk = "en-US"
        End If

        DS_Zakaznik.InsertParameters("Jazyk").DefaultValue = jazyk
        DS_Zakaznik.InsertParameters("Staty_ID").DefaultValue = stat

    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim prihlasen As Uzivatel = New Uzivatel

        If Not IsNothing(Session("id_zakaznik")) Then
            prihlasen = CType(Session("id_zakaznik"), Uzivatel)
            FRV_zakaznik.DefaultMode = FormViewMode.Edit
            DS_Zakaznik.SelectParameters("ID_zakaznik").DefaultValue = prihlasen.id
            DS_Zakaznik.UpdateParameters("ID_zakaznik").DefaultValue = prihlasen.id
        End If

        If (Request.QueryString("ret") <> Nothing) Then
            returnPage = Request.QueryString("ret")
            Dim tlacitko As Button = FRV_zakaznik.FindControl("BTN_updateregistrace")
            If (Not tlacitko Is Nothing) Then
                tlacitko.Text = GetLocalResourceObject("BTN_updateregistraceNavratKosik.Text").ToString()
            End If
        Else
            returnPage = ""
        End If
    End Sub

    Protected Sub ddl_insertstat_DataBound(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ddl As DropDownList = CType(sender, DropDownList)

        If CultureInfo.CurrentCulture.ToString = "cs-CZ" Then
            ddl.SelectedValue = 58
        End If

    End Sub


  Protected Sub FRV_zakaznik_ItemUpdated(sender As Object, e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles FRV_zakaznik.ItemUpdated
    Dim prihlasen As Uzivatel = New Uzivatel

    prihlasen = Session("id_zakaznik")
    prihlasen.StatName = CType(FRV_zakaznik.FindControl("ddl_UpdateStat"), DropDownList).SelectedItem.ToString()
    prihlasen.StatID = CType(FRV_zakaznik.FindControl("ddl_UpdateStat"), DropDownList).SelectedValue.ToString()

    Session("id_zakaznik") = prihlasen
    If (Not returnPage = "") Then
      Response.Redirect(returnPage)
    End If
  End Sub
End Class
