--tento skript zrusi text novinka v poli poznamka krome nejnovejsich 200 karet, berou se jen karty s ciselnym kodem

begin tran
update dbo.T_Produkt set Poznamka='' where ID_objcislo in (
select id_objcislo from dbo.T_Produkt where ID_objcislo not in (
select top 200 id_objcislo from dbo.t_produkt where isnumeric(SUBSTRING(id_objcislo,1,1))=1  order by id_objcislo desc
)
and Poznamka='novinka'
and isnumeric(SUBSTRING(id_objcislo,1,1))=1
)

--a take zrusi text u karet s neciselnym jkodem ktere se dnes uz nepouzivaji, staci asi pustit jen jednou
--update dbo.T_Produkt set poznamka='' where isnumeric(SUBSTRING(id_objcislo,1,1))=0 and poznamka='novinka'

--commit
