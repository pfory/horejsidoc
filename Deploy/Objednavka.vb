Imports Microsoft.VisualBasic
Imports System.Globalization
Imports System.Data
Imports System.Data.SqlClient
Imports System.Web.HttpContext
Imports Alerts
Imports KurzCNB
Imports PHE

Public Class Objednavka

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



    Public Structure VybraneZbozi
        Dim popis As String
        Dim popisEN As String
        Dim objcislo As String
        Dim mnozstvi As Integer
        Dim DPH As Single
        Dim mc As Single
        Dim vc As Single
        Dim mc_EUR As Single
        Dim mcDPH_EUR As Single
        Dim mcDPH As Single
        Dim vc_EUR As Single
        Dim vcDPH As Single
        Dim vcDPH_EUR As Single
        Dim soucetMC As Single
        Dim soucetMCDPH As Single
        Dim soucetDPHmc As Single
        Dim soucetDPHmc_EUR As Single
        Dim soucetVC As Single
        Dim soucetVCDPH As Single
        Dim soucetMC_EUR As Single
        Dim soucetMCDPH_EUR As Single
        Dim soucetVC_EUR As Single
        Dim soucetVCDPH_EUR As Single
        Dim jednotka As String
        Dim marze As Integer
        Dim minKs As Integer
        Dim KsInc As Integer
        Dim dan As String
        Dim PHE As Single
        Dim PHEDPH As Single
        Dim PHE_EUR As Single
        Dim PHEDPH_EUR As Single

    End Structure

    Public Structure Uzivatel
        Dim id As Integer
        Dim Jmeno As String
        Dim VC As Boolean
        Dim Firma As String
        Dim StatID As Integer
        Dim StatName As String
    End Structure


    Public Function sectiPolozky(ByVal xzbozi As ArrayList, ByVal zpusob As Integer, ByVal mc_vc As Boolean, Optional ByVal cizina As String = "cs-CZ", Optional ByVal notDPH As Boolean = False) As Single
        Dim sumaMcDPH As Single
        Dim sumaMc As Single
        Dim sumaVcDPH As Single
        Dim sumaVc As Single
        Dim sumaMcDPH_EUR As Single
        Dim sumaVcDPH_EUR As Single
        Dim sumaMc_EUR As Single
        Dim sumaVc_EUR As Single


        'If cizina <> "cs-CZ" Then postovne = 0

        If Not IsNothing(xzbozi) Then

            For Each polozka As VybraneZbozi In xzbozi
                sumaMcDPH += polozka.soucetMCDPH
                sumaMc += polozka.soucetMC
                sumaVcDPH += polozka.soucetVCDPH
                sumaVc += polozka.soucetVC
                sumaMcDPH_EUR += polozka.soucetMCDPH_EUR
                sumaVcDPH_EUR += polozka.soucetVCDPH_EUR
                sumaMc_EUR += polozka.soucetMC_EUR
                sumaVc_EUR += polozka.soucetVC_EUR
            Next

            If mc_vc Then
                If cizina = "cs-CZ" Then
                    If Not notDPH Then
                        Return sumaVcDPH
                    Else
                        Return sumaVc
                    End If
                Else
                    If Not notDPH Then
                        Return sumaVcDPH_EUR
                    Else
                        Return sumaVc_EUR
                    End If

                End If
            Else
                If cizina = "cs-CZ" Then
                    If Not notDPH Then
                        Return sumaMcDPH
                    Else
                        Return sumaMc
                    End If
                Else
                    If Not notDPH Then
                        Return sumaMcDPH_EUR
                    Else
                        Return sumaMc_EUR
                    End If
                End If
            End If
        End If
        Return 0
    End Function

    Public Function sectiVC(ByVal xzbozi As ArrayList) As Single
        Dim sumaVc As Single
        If Not IsNothing(xzbozi) Then

            For Each polozka As VybraneZbozi In xzbozi
                sumaVc += polozka.soucetVC
            Next

            Return sumaVc
        End If
        Return 0
    End Function

    Public Function sectiPHE(ByVal xzbozi As ArrayList, Optional ByVal cizina As String = "cs-CZ") As Single
        Dim PHE As Single
        Dim PHE_EUR As Single
        If Not IsNothing(xzbozi) Then

            For Each polozka As VybraneZbozi In xzbozi
                PHE += polozka.PHEDPH * polozka.mnozstvi
                PHE_EUR += polozka.PHEDPH_EUR * polozka.mnozstvi
            Next
            If cizina = "cs-CZ" Then
                Return PHE
            Else
                Return PHE_EUR
            End If
        End If
        Return 0
    End Function

    Public Function dostupnost(ByVal pocetKusu As Integer, ByVal poznamka As String) As String
        poznamka = LCase(poznamka)

        Select Case pocetKusu
            Case Is >= 3
                dostupnost = GetGlobalResourceObject("Dostupnost", "sklad").ToString
            Case 1 To 2
                dostupnost = GetGlobalResourceObject("Dostupnost", "omez").ToString
            Case Is = 0
                If poznamka = "novinka" Then
                    dostupnost = GetGlobalResourceObject("Dostupnost", "novinka").ToString
                Else
                    dostupnost = GetGlobalResourceObject("Dostupnost", "vyprodano").ToString
                End If

            Case Else
                dostupnost = GetGlobalResourceObject("Dostupnost", "neudan").ToString
        End Select

        Return dostupnost

    End Function

    Public Function pridejDoKosiku(ByVal id_objcislo As String, ByVal kusu As Integer) As Integer
        Dim alert As New Alerts
        Dim tab As New DataTable
        Dim readerZ As SqlDataReader
        Dim con As New SqlConnection(ConfigurationManager.ConnectionStrings("DataHorejsi").ConnectionString)
        Dim cmd As New SqlCommand(String.Format("SELECT Text_CZ, Text_EN, MC, VC, DPH, ID_objcislo, Poznamka, Jednotka, Marze, Min_ks, Min_ks_inc, Skladem, ind, PHE711, PHE715 FROM T_Produkt WHERE ID_objcislo='{0}'", id_objcislo), con)

        Dim session As HttpSessionState = HttpContext.Current.Session
        Dim jizVybrane As ArrayList = CType(session("zvoleneZbozi"), ArrayList)
        Dim zboziDoKose As New VybraneZbozi
        Dim dost As String
        Dim minKusu, incKusu As Integer
        Dim PHE As New PHE
        Dim PHE711 As Boolean
        Dim PHE715 As Boolean
        Dim poplatek As Single

        con.Open()
        readerZ = cmd.ExecuteReader()

        While readerZ.Read()


            'Pokud je zbozi nedostupne,nebo neni cena tak na to upozorni a nedej do kose
            dost = dostupnost(readerZ("Skladem"), readerZ("Poznamka"))
            If (dost <> GetGlobalResourceObject("Dostupnost", "sklad").ToString And dost <> GetGlobalResourceObject("Dostupnost", "omez").ToString And InStr(dost, Left(GetGlobalResourceObject("Dostupnost", "vAkci").ToString, 10)) = 0) _
                Or readerZ("VC") = 0 Or readerZ("MC") = 0 Then
                alert.Show(GetGlobalResourceObject("Dostupnost", "alertNelze").ToString, GetGlobalResourceObject("Dostupnost", "popUp_title2").ToString)
                Return kusu
                Exit While
            End If
            PHE711 = CType(readerZ("PHE711"), Boolean)
            PHE715 = CType(readerZ("PHE715"), Boolean)

            If PHE711 Then
                poplatek = PHE.nactiUlozenyPoplatek("PHE711")
            End If

            If PHE715 Then
                poplatek = PHE.nactiUlozenyPoplatek("PHE715")
            End If

            'Kontrola zadanych kusu
            minKusu = readerZ("Min_ks")
            incKusu = readerZ("Min_ks_inc")
            If kusu = 0 Then
                kusu = minKusu
                alert.Show(GetGlobalResourceObject("Dostupnost", "minMnoz").ToString, GetGlobalResourceObject("Dostupnost", "popUp_title2").ToString)
            ElseIf (kusu - minKusu) Mod incKusu <> 0 Then
                'Neni to spravny nasobek,dopocitam na nejblissi vyssi
                kusu = (incKusu - (kusu Mod incKusu)) + kusu
                alert.Show(GetGlobalResourceObject("Dostupnost", "nasobek").ToString, GetGlobalResourceObject("Dostupnost", "popUp_title2").ToString)
            End If

            With zboziDoKose
                .popis = readerZ("Text_CZ")
                .popisEN = readerZ("Text_EN")
                .objcislo = readerZ("ID_objcislo")
                .DPH = (readerZ("DPH") / 100) + 1
                .dan = readerZ("DPH")
                .PHE = poplatek
                .PHE_EUR = poplatek / kurzEUR
                .PHEDPH = IIf(poplatek <> 0, poplatek * .DPH, 0)
                .PHEDPH_EUR = .PHEDPH / kurzEUR
                .mnozstvi = kusu
                .mc = readerZ("MC")
                .mc_EUR = .mc / kurzEUR
                .mcDPH = (.mc * .DPH) + .PHEDPH
                .mcDPH_EUR = (.mcDPH / kurzEUR) + .PHEDPH_EUR
                .soucetMC = (.mc * kusu) + .PHE * kusu
                .soucetMCDPH = .soucetMC * .DPH
                .soucetDPHmc = .soucetMCDPH - .soucetMC
                .soucetMCDPH_EUR = .soucetMCDPH / kurzEUR
                .soucetMC_EUR = (.mc_EUR * kusu) + .PHE_EUR * kusu
                .soucetDPHmc_EUR = .soucetMCDPH_EUR - .soucetMC_EUR
                .vc = readerZ("VC")
                .vc_EUR = (.vc / kurzEUR)
                .vcDPH = (.vc * .DPH) + .PHEDPH
                .vcDPH_EUR = (.vcDPH / kurzEUR) + .PHEDPH_EUR
                .soucetVC = (.vc * kusu) + .PHE * kusu
                .soucetVC_EUR = (.vc_EUR * kusu) + .PHE_EUR * kusu
                .soucetVCDPH = .soucetVC * .DPH
                .soucetVCDPH_EUR = .soucetVCDPH / kurzEUR
                .jednotka = readerZ("Jednotka")
                .marze = readerZ("Marze")
                .minKs = minKusu
                .KsInc = incKusu

            End With
        End While
        readerZ.Close()
        con.Close()

        If IsNothing(jizVybrane) Then jizVybrane = New ArrayList
        If Not jizVybrane.Contains(zboziDoKose) Then
            jizVybrane.Add(zboziDoKose)
            session("zvoleneZbozi") = jizVybrane
        Else
            alert.Show(GetGlobalResourceObject("Dostupnost", "uzVkosi").ToString, GetGlobalResourceObject("Dostupnost", "popUp_title2").ToString)
        End If

        Return kusu
    End Function

    Public Sub zobrazObsahKosiku()
        'Secteni nakupu v kosiku a zobrazeni na master page
        Dim session As HttpSessionState = HttpContext.Current.Session
        Dim jizVybrane As ArrayList = CType(session("zvoleneZbozi"), ArrayList)
        Dim page As System.Web.UI.Page = TryCast(System.Web.HttpContext.Current.Handler, System.Web.UI.Page)
        Dim cenaNakupu As Label = CType(page.Master.FindControl("lbl_cenaNakupu"), Label)
        Dim pocetPolozek As Label = CType(page.Master.FindControl("lbl_pocetPolozek"), Label)
        Dim sumaObj As Single
        Dim prihlasen As Uzivatel = New Uzivatel

        prihlasen = CType(session("id_zakaznik"), Uzivatel)
        sumaObj = sectiPolozky(jizVybrane, 0, prihlasen.VC)
        cenaNakupu.Text = Format(sumaObj, "N0")
        Try
            pocetPolozek.Text = jizVybrane.Count
        Catch
            pocetPolozek.Text = 0
        End Try

    End Sub
End Class
