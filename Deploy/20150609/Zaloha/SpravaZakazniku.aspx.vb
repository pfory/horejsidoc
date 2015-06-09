Imports System.Globalization
Imports System.Data
Imports System.Diagnostics
Imports System.Net.Mail
Imports Emails

Partial Class Pages_SpravaObjednavek
    Inherits System.Web.UI.Page

    Protected Sub ddl_pageSize_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddl_pageSize.SelectedIndexChanged
        GV_Zakaznici.PageSize = ddl_pageSize.SelectedValue
        FiltrZakazniku()
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then

            FiltrZakazniku()

        End If

    End Sub

    Protected Sub BTN_vyhledej_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BTN_vyhledej.Click

        FiltrZakazniku()

    End Sub

    Private Sub FiltrZakazniku()
        Dim sb As StringBuilder = New StringBuilder()

        sb.Append(DS_Zakaznik.SelectCommand)

        If Not String.IsNullOrEmpty(txb_zakaznik.Text) Then
            sb.Append(" AND (T_Zakaznik.Prijmeni like '%")
            sb.Append(Trim(txb_zakaznik.Text))
            sb.Append("%' OR T_Zakaznik.Jmeno like '%")
            sb.Append(Trim(txb_zakaznik.Text))
            sb.Append("%')")
        Else
            sb.Append(" AND (T_Zakaznik.VC = " & Convert.ToInt32(chb_potvrzeny.Checked) & ")")
            sb.Append(" AND (T_Zakaznik.Obchodnik = " & Convert.ToInt32(chb_zadajici.Checked) & ")")
        End If


        DS_Zakaznik.SelectCommand = sb.ToString
        DS_Zakaznik.Select(DataSourceSelectArguments.Empty)
        DS_Zakaznik.DataBind()
        GV_Zakaznici.DataBind()

    End Sub

    Protected Sub GV_Objednavky_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles GV_Zakaznici.RowCommand

        FiltrZakazniku()

    End Sub

    Protected Sub DS_Zakaznik_Updated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.SqlDataSourceStatusEventArgs) Handles DS_Zakaznik.Updated
        If e.AffectedRows <> 0 Then
            odesliPotvrzeni(e.Command.Parameters("@ID_zakaznik").Value, e.Command.Parameters("@VC").Value)
        End If
    End Sub

    Private Sub odesliPotvrzeni(ByVal ID_zakaznik As Integer, ByVal stav As Boolean)
        Dim email As Emails = New Emails
        Dim od As MailAddress = New MailAddress("obchod@horejsi.cz", "e-Obchod Hořejší")
        Dim zprava As StringBuilder = New StringBuilder
        Dim tmpCommand As String = DS_Zakaznik.SelectCommand
        DS_Zakaznik.SelectCommand = "SELECT DISTINCT ID_zakaznik, RTRIM(Prijmeni) + ' ' + RTRIM(Jmeno) AS Zakaznik, Mail, VC, Obchodnik, Firma, IC, DIC,Uzivatel,Heslo,Jazyk FROM T_Zakaznik WHERE (1 = 1) AND ID_zakaznik=" + CStr(ID_zakaznik)
        Dim dvZakaznik As DataView = CType(DS_Zakaznik.Select(DataSourceSelectArguments.Empty), DataView)
        
        Dim index As Integer = 0

        Dim jazyk As String = dvZakaznik.Table.Rows(index).Item("Jazyk").ToString
        Dim komu As MailAddress = New MailAddress(dvZakaznik.Table.Rows(index).Item("Mail").ToString)
        Dim kontrola As MailAddress = New MailAddress("obchod@horejsi.cz")
        Dim predmet As String
        DS_Zakaznik.SelectCommand = tmpCommand


        If stav Then
            If jazyk = "cs-CZ" Then
                zprava.Append("Dobrý den,<br/>")
                zprava.Append(" byl/a jste zařazen/a do kategorie pro velkoobchodní prodej. Při nákupu z e-obchodu se Vám bude u jednotlivých položek zobrazovat cena zboží bez DPH.")
                zprava.Append("V rekapitulaci cen v košíku se Vám bude zobrazovat také cena s DPH a celková částka.<br/><br/>")

                zprava.Append("Děkujeme za Vaši registraci a těšíme se na spolupráci.")
            Else
                zprava.Append("Good day,<br/>")
                zprava.Append(" Have you appears in the category of wholesale sales. When buying from an e-commerce you will display the individual items of goods price excluding VAT.")
                zprava.Append("In the recapitulation of prices in the shopping cart you will also be displayed with the price and the total amount of VAT.<br/><br/>")

                zprava.Append("Thank you for your registration and we look forward to working together.")
            End If
        Else
            If jazyk = "cs-CZ" Then
                zprava.Append("Dobrý den,<br/>")
                zprava.Append(" oznamujeme Vám, že jste nebyl/a zařazen/a do kategorie pro velkoobchodní prodej.")
                zprava.Append("Zboží z naší nabídky můžete dále objednávat prostřednictvím e-obchodu za doporučené maloobchodní ceny.<br/><br/>")

                zprava.Append("S pozdravem obchodní oddělení Hořejší model s.r.o.")
            Else
                zprava.Append("Good day,<br/>")
                zprava.Append(" announce to you that you were not appears in the category of wholesale sales.")
                zprava.Append("Goods from our menu, you can also order via e-commerce for the suggested retail price.<br/><br/>")

                zprava.Append("Sincerely, Sales Department  Hořejší model s.r.o.")
            End If
        End If

        If jazyk = "cs-CZ" Then
            predmet = "Hořejší model - Správa obchodníků"
        Else
            predmet = "Hořejší model - Managing traders"
        End If

        email.OdesliMail(od, komu, predmet, zprava.ToString, kontrola)
        'Pridani/Odebrani obchodnika v seznamu kontaktu pro obchodni sdeleni 
        zpravodajObchod(komu, stav)
    End Sub

    Private Sub zpravodajObchod(ByVal mail As MailAddress, ByVal stav As Boolean)
        'Pokud je uz mail v kontaktech tak udelam update Obchod
        'Pokud tam jeste neni tak insert
        DS_Kontakty.SelectCommand = String.Format("SELECT MailAdresa FROM T_Kontakty WHERE MailAdresa='{0}'", mail.ToString)
        Dim dvKontakty As DataView = CType(DS_Kontakty.Select(DataSourceSelectArguments.Empty), DataView)

        If stav Then
            If dvKontakty IsNot Nothing Then
                DS_Kontakty.UpdateCommand = String.Format("UPDATE T_Kontakty set Obchodnik=1 WHERE MailAdresa='{0}'", mail.ToString)
                DS_Kontakty.Update()
            Else
                DS_Kontakty.InsertCommand = String.Format("INSERT INTO T_Kontakty (MailAdresa,Aktivni,Tester,DatumRegistrace,Obchodnik) VALUES ('{0}',1,0,convert(datetime,'{1}',104),1) ", mail.ToString, Now())
                DS_Kontakty.Insert()
            End If
        Else
            'Po vyrazeni z Obchodu necham kontakt a jen nastavim Obchod na false
            DS_Kontakty.UpdateCommand = String.Format("UPDATE T_Kontakty set Obchodnik=0 WHERE MailAdresa='{0}'", mail.ToString)
            DS_Kontakty.Update()
        End If
    End Sub

End Class
