<%@ Page Language="VB" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="false"
    CodeFile="Kontakt.aspx.vb" Inherits="Pages_Kontakt" Title="Modely Hoøejší" %>

<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Hlavni" runat="Server">
    <h1>
        <asp:Localize ID="Localize1" runat="server" Text='<%$ Resources: Nadpis %>'></asp:Localize>
    </h1>
    <div>
    <table border="0" cellpadding="2" cellspacing="0" width="600">
        <tr>
            <td style="padding-left: 10px; padding-top: 10px;">
                <p>
                    <strong>HOØEJŠÍ MODEL s.r.o.
                        <br />
                    </strong><span>Slovanská 8</span><br />
                    <span>326 00 Plzeò</span><br />
                    IÈO/DIÈ 279 68 049/CZ 279 68 049<br />
                    <br />
                    <asp:Localize ID="Localize2" runat="server" Text='<%$ Resources: ProvozniDoba %>'></asp:Localize>
                    <br />
                    <br />
                    Telefony:</p>
                    <table>
                    <tr>
                    <td>+420 377 429 869</td><td style="padding-left:25px"><asp:Localize ID="Localize3" runat="server" Text='<%$ Resources: Telefon1 %>'></asp:Localize></td>
                    </tr>
                    <tr>
                    <td>+420 377 462 535</td><td style="padding-left:25px"><asp:Localize ID="Localize10" runat="server" Text='<%$ Resources: Telefon2 %>'></asp:Localize></td>
                    </tr>
                    <tr>
                    <td>+420 733 254 229</td><td style="padding-left:25px"><asp:Localize ID="Localize11" runat="server" Text='<%$ Resources: Telefon3 %>'></asp:Localize></td>
                    </tr>
                    </table>
                     
                    <br />
                    <span>
                        <br />
                    </span>E-Mail:<br />
                        <table>
                        <tr>
                        <td><a href="mailto:objednavky@horejsi.cz">objednavky@horejsi.cz</a></td><td style="padding-left:15px"><asp:Localize ID="Localize6" runat="server" Text='<%$ Resources: Mail1Popis %>'></asp:Localize></td>
                        </tr>
                        <tr>
                        <td><a href="mailto:obchod@horejsi.cz">obchod@horejsi.cz</a></td><td style="padding-left:15px"><asp:Localize ID="Localize7" runat="server" Text='<%$ Resources: Mail2Popis %>'></asp:Localize></td>
                        </tr>
                        <tr>
                        <td><a href="mailto:finance@horejsi.cz">finance@horejsi.cz</a></td><td style="padding-left:15px"><asp:Localize ID="Localize8" runat="server" Text='<%$ Resources: Mail3Popis %>'></asp:Localize></td>
                        </tr>
                        <tr>
                        <td><a href="mailto:info@horejsi.cz">info@horejsi.cz</a></td><td style="padding-left:15px"><asp:Localize ID="Localize9" runat="server" Text='<%$ Resources: Mail4Popis %>'></asp:Localize></td>
                        </tr>
                        </table>
                <br />
            </td>
        </tr>
        <tr>
            <td align="center">
                <%--<img border="1" src="../WebImages/firma_small.jpg" alt="Firma" />--%>
            </td>
        </tr>
        <tr>
            <td align="left">
                <br />
                <span style="padding-left: 10px; padding-right: 10px">
                <%--<asp:Localize ID="Localize3" runat="server" Text='<%$ Resources: PopisTrasy %>'></asp:Localize>--%> </span>
                <br />
                <br />
            </td>
        </tr>
        <tr>
            <td style="text-align: center">
                <%--<img border="1" src="../WebImages/mapa_1.jpg" alt="Mapa" />--%>
                <iframe width="502" height="377" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" 
                src="https://maps.google.com/maps?f=q&amp;source=s_q&amp;hl=cs&amp;geocode=&amp;q=Slovansk%C3%A1+8,+Plze%C5%88,+%C4%8Cesk%C3%A1+republika&amp;aq=&amp;sll=49.727808,13.367958&amp;sspn=0.17821,0.308647&amp;t=m&amp;ie=UTF8&amp;hq=&amp;hnear=Slovansk%C3%A1+8,+Plze%C5%88+2-Slovany,+%C4%8Cesk%C3%A1+republika&amp;ll=49.742953,13.386841&amp;spn=0.02091,0.043001&amp;z=14&amp;output=embed"></iframe>
                <br /><small><a href="https://maps.google.com/maps?f=q&amp;source=embed&amp;hl=cs&amp;geocode=&amp;q=Slovansk%C3%A1+8,+Plze%C5%88,+%C4%8Cesk%C3%A1+republika&amp;aq=&amp;sll=49.727808,13.367958&amp;sspn=0.17821,0.308647&amp;t=m&amp;ie=UTF8&amp;hq=&amp;hnear=Slovansk%C3%A1+8,+Plze%C5%88+2-Slovany,+%C4%8Cesk%C3%A1+republika&amp;ll=49.742953,13.386841&amp;spn=0.02091,0.043001&amp;z=14" style="color:#0000FF;text-align:left">Zvìtšit mapu</a></small>
            </td>
        </tr>
        <%--<tr>
            <td style="text-align: center">
                <img border="1" src="../WebImages/mapa_2.jpg" alt="Detail mapa" />
            </td>
        </tr>--%>
        <tr>
            <td>
                <p>
                    <asp:Localize ID="Localize4" runat="server" Text='<%$ Resources: Souradnice %>'></asp:Localize>
                    </p>
                <p>
                    <asp:Localize ID="Localize5" runat="server" Text='<%$ Resources: Zdroje %>'></asp:Localize>
                    
                </p>
            </td>
        </tr>
    </table>
    </div>
</asp:Content>
