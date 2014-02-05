Imports System.Data
Imports System.Net.Mail
Imports System.Diagnostics
Imports CuteEditor
Imports Alerts


Partial Class Administrator_Clanky
    Inherits System.Web.UI.Page

    Private _odesilanyZpravodaj As DataView
    Public Property odesilanyZpravodaj() As DataView
        Get
            DS_OdesilanyZpravodaj.SelectCommand = String.Format("SELECT ID_zpravodaj, Datum_vlozeni, Popis, Text_CZ, Odeslan, Nazev, Vystavit, Obchod FROM T_Zpravodaj WHERE ID_zpravodaj = {0}", FV_Zpravodaj.SelectedValue)
            Dim zpravodajTable As DataView = CType(DS_OdesilanyZpravodaj.Select(DataSourceSelectArguments.Empty), DataView)
            _odesilanyZpravodaj = zpravodajTable
            Return _odesilanyZpravodaj
        End Get
        Set(ByVal value As DataView)
            _odesilanyZpravodaj = value
        End Set
    End Property


    Public Structure listAdres
        Public j As Integer
        Public i As Integer
        Public adresa As String
    End Structure

    Public Alert As New Alerts

    Private Sub odeslatMaily(ByVal jeTest As Boolean)
        Dim Msg As New MailMessage()
        Dim adresat As MailAddress
        Dim kontaktTable As DataView = CType(DS_Kontakty.Select(DataSourceSelectArguments.Empty), DataView)
        Dim maxAdres As Integer = kontaktTable.Table.Rows.Count
        Dim pocetMax As Integer
        Dim velikostDavky As Integer = 49
        Dim odeslan As Boolean = CType(odesilanyZpravodaj.Table.Rows(0).Item("Odeslan"), Boolean)
        Dim retval As Integer = 6
        Dim Senderx As New SmtpClient()
        Dim lsAdr() As listAdres = {}
        Dim citac As Integer = 0
        Dim regEx As New System.Text.RegularExpressions.Regex("\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*")


        ReDim lsAdr(maxAdres - 1)

        Msg.From = New System.Net.Mail.MailAddress("zpravodaj@horejsi.cz", "Zpravodaj")
        Msg.Subject = "Zpravodaj - " & odesilanyZpravodaj.Table.Rows(0).Item("Popis").ToString

        Msg.Body = odesilanyZpravodaj.Table.Rows(0).Item("Text_CZ").ToString

        If (maxAdres Mod velikostDavky) = 0 Then
            pocetMax = Int(maxAdres / velikostDavky)
        Else
            pocetMax = Int(maxAdres / velikostDavky) + 1
        End If

        ' Udelat kontrolu jestli byl dany zpravodaj uz poslany a kdy
        If odeslan Then
            'retval = alertX()
            'retval = MsgBox("Tento zpravodaj byl již odeslán. Chcete ho poslat znovu?", MsgBoxStyle.YesNo, "Zpravodaj")
        End If


        If retval = 6 Then

            For j As Integer = 0 To pocetMax
                For i As Integer = 0 To velikostDavky
                    If citac < maxAdres Then
                        If regEx.IsMatch(kontaktTable.Table.Rows(citac).Item("MailAdresa").ToString) = True Then
                            adresat = New MailAddress(kontaktTable.Table.Rows(citac).Item("MailAdresa").ToString)
                            Msg.Bcc.Add(adresat)
                            If citac <= UBound(lsAdr) Then
                                lsAdr(citac).j = j
                                lsAdr(citac).i = i
                                lsAdr(citac).adresa = adresat.Address
                            End If
                            citac += 1
                        Else
                            Debug.Print(kontaktTable.Table.Rows(citac).Item("MailAdresa").ToString)
                            citac += 1
                        End If
                    Else : Exit For
                    End If

                Next i

                Msg.IsBodyHtml = True
                'Msg.BodyEncoding = System.Text.Encoding.UTF8


                Try
                    Senderx.Send(Msg)
                Catch ex As SmtpFailedRecipientsException
                    For i As Integer = 0 To ex.InnerExceptions.Length - 1
                        Dim status As SmtpStatusCode = ex.InnerExceptions(i).StatusCode
                        If status = SmtpStatusCode.MailboxBusy OrElse status = SmtpStatusCode.MailboxUnavailable Then
                            lbl_Vypis.Text = "Je zatizeny server"
                            'MsgBox("Delivery failed - retrying in 5 seconds.")
                            System.Threading.Thread.Sleep(20000)
                            Senderx.Send(Msg)
                        Else
                            lbl_Vypis.Text = ex.InnerExceptions(i).FailedRecipient
                            'MsgBox("Failed to deliver message to {0}", MsgBoxStyle.Information, ex.InnerExceptions(i).FailedRecipient)
                        End If
                    Next
                Catch ex As Exception
                    'lbl_Vypis.Text = lbl_Vypis.Text & "Pocet bcc: " & Msg.Bcc.Count.ToString & " s chybou - " & ex.ToString
                    'MsgBox("Exception caught in RetryIfBusy(): {0}", MsgBoxStyle.Information, ex.ToString())
                End Try
                Msg.Bcc.Clear()
            Next j

            'Log do mailu - kontrola
            Msg.Bcc.Clear()
            Msg.From = New System.Net.Mail.MailAddress("zpravodaj@horejsi.cz", "LogMail")
            Msg.To.Add(New System.Net.Mail.MailAddress("mr.datel@gmail.com"))
            Msg.Subject = "Seznam odeslanych adres"
            Msg.IsBodyHtml = False
            Dim vysl As String = ""
            For ind As Integer = 0 To UBound(lsAdr)
                vysl = vysl + lsAdr(ind).j.ToString + "," + lsAdr(ind).i.ToString + "," + lsAdr(ind).adresa + Chr(10)
            Next
            Msg.Body = vysl
            Senderx.Send(Msg)

            Dim textAlert As String
            textAlert = String.Format("Zpravodaj byl úspìšnì odeslán {0} odbìratelùm.", IIf(jeTest, "testovacím", "všem"))
        
            Alert.Show(textAlert, "Zpravodaj")

        'Nastaveni ze zpravodaj byl odeslan
        If Not jeTest Then
            Dim tmpDS As SqlDataSource = New SqlDataSource
            Dim tmpCom As String
            Dim updCom As String = String.Format("UPDATE T_Zpravodaj SET Odeslan = 1 WHERE ID_zpravodaj={0}", odesilanyZpravodaj.Table.Rows(0).Item("ID_zpravodaj").ToString)
            tmpDS = DS_Zpravodaj
            tmpCom = tmpDS.UpdateCommand
            tmpDS.UpdateCommand = updCom
            tmpDS.Update()
            tmpDS.UpdateCommand = tmpCom
        End If
        Else : Exit Sub
        End If
    End Sub

    Protected Sub BTN_VsemOdesli_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BTN_VsemOdesli.Click
        DS_Kontakty.SelectCommand = "SELECT ID_kontakt, MailAdresa, Aktivni, Tester, DatumRegistrace, Obchodnik FROM T_Kontakty WHERE Aktivni=1"
        DS_Kontakty.DataBind()
        Dim obchod As Boolean = CType(odesilanyZpravodaj.Table.Rows(0).Item("Obchod"), Boolean)
        If Not obchod Then
            odeslatMaily(False)
        Else
            Alert.Show("Zpravodaj, který jsi vybral má nastaven pøíznak obchodního sdìlení!", "Zpravodaj")
        End If
       
    End Sub
    

    Protected Sub BTN_hledej_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BTN_hledej.Click
        If Not String.IsNullOrEmpty(TXB_filtrKontakt.Text) Then
            DS_Kontakty.SelectCommand = String.Format("SELECT ID_kontakt, MailAdresa, Aktivni, Tester, DatumRegistrace, Obchodnik FROM T_Kontakty WHERE (MailAdresa like '%{0}%')", Trim(TXB_filtrKontakt.Text))
            DS_Kontakty.DataBind()
            'GV_Kontakty.DataBind()
        End If
    End Sub

    Protected Sub BTN_testOdeslani_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BTN_testOdeslani.Click
        DS_Kontakty.SelectCommand = "SELECT ID_kontakt, MailAdresa, Aktivni, Tester, DatumRegistrace, Obchodnik FROM T_Kontakty WHERE Tester=1"
        DS_Kontakty.DataBind()

        odeslatMaily(True)
       
    End Sub

    Protected Sub Button3_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button3.Click
        FV_Zpravodaj.ChangeMode(FormViewMode.Insert)
    End Sub

    Protected Sub FV_Zpravodaj_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles FV_Zpravodaj.ItemInserted
        DS_Zpravodaj.DataBind()
        GV_Zravodaj.DataBind()
    End Sub

    Protected Sub FV_Zpravodaj_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles FV_Zpravodaj.ItemUpdated
        DS_Zpravodaj.DataBind()
        GV_Zravodaj.DataBind()
    End Sub

    Protected Sub ddl_pageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddl_pageSize.SelectedIndexChanged
        GV_Zravodaj.PageSize = ddl_pageSize.SelectedValue
        GV_Zravodaj.DataBind()
    End Sub

    Protected Sub FV_Zpravodaj_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles FV_Zpravodaj.PreRender

        'Pokud mam vybrany zpravodaj tak povolim tlacitka k odeslani
        If FV_Zpravodaj.SelectedValue <> 0 Then
            BTN_ObchodOdesli.Enabled = True
            BTN_VsemOdesli.Enabled = True
            BTN_testOdeslani.Enabled = True
        Else
            BTN_ObchodOdesli.Enabled = False
            BTN_VsemOdesli.Enabled = False
            BTN_testOdeslani.Enabled = False
        End If

        If FV_Zpravodaj.CurrentMode = FormViewMode.Insert Then
            Dim obsah As CuteEditor.Editor = CType(FV_Zpravodaj.FindControl("CE_InsertText"), CuteEditor.Editor)
            Dim sablonyTable As DataView = CType(DS_Sablony.Select(DataSourceSelectArguments.Empty), DataView)
            Dim nazevZpr As TextBox = CType(FV_Zpravodaj.FindControl("Txb_Nazev"), TextBox)

            'U noveho zpravodaje vlazim sablonu
            If String.IsNullOrEmpty(obsah.Text) Then
                obsah.Text = sablonyTable.Table.Rows(0).Item("Obsah").ToString
            End If
            'Predvyplnim nazev zpravodaje
            If String.IsNullOrEmpty(nazevZpr.Text) Then
                nazevZpr.Text = "Hoøejší model INFO " + Format(Now, "yyMMdd")
            End If
        End If
    End Sub

    Protected Sub BTN_ObchodOdesli_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BTN_ObchodOdesli.Click
        DS_Kontakty.SelectCommand = "SELECT ID_kontakt, MailAdresa, Aktivni, Tester, DatumRegistrace,Obchodnik FROM T_Kontakty WHERE Aktivni=1 And Obchodnik=1"
        DS_Kontakty.DataBind()
        Dim obchod As Boolean = CType(odesilanyZpravodaj.Table.Rows(0).Item("Obchod"), Boolean)
        If obchod Then
            odeslatMaily(False)
        Else
            Alert.Show("Zpravodaj, který jsi vybral nemá nastaven pøíznak obchodního sdìlení!", "Zpravodaj")
        End If
    End Sub

End Class
