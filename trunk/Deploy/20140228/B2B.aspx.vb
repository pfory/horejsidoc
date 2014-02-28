Imports System.IO
Imports Objednavka
Imports System.Globalization

Partial Class Pages_B2B
    Inherits BasePage

    Public prihlasen As New Uzivatel

    Protected Sub Page_LoadComplete(sender As Object, e As EventArgs) Handles Me.LoadComplete
        Dim lokalizace As String = System.Globalization.CultureInfo.CurrentCulture.ToString
        Dim zeme As String = lokalizace.Substring(3)
        Dim VC As Boolean = False

        If Not IsNothing(Session("id_zakaznik")) Then
            prihlasen = CType(Session("id_zakaznik"), Uzivatel)
            If prihlasen.VC Then VC = True
        Else
        End If

        If Not VC Then
            lit_htmlFile.Text = "Pro využívání služby pro výměnu dat musíte být přihlášen jako obchodník. Použijte přihlášení k účtu v pravé části obrazovky."
            Return
        End If

        Dim cesta As String
        cesta = Server.MapPath("../HTML/") + "b2b_" + zeme + ".html"
        Dim reader As StreamReader = File.OpenText(cesta)
        Dim obsah As String = reader.ReadToEnd()

        lit_htmlFile.Text = obsah


    End Sub
End Class
