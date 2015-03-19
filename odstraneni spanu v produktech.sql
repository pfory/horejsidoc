begin tran
update T_Produkt 
set detail=replace(detail,'<span style="font-weight: normal; font-size: x-small; color: #000000; line-height: normal; font-style: normal; font-family: Verdana, Arial, Helvetica, sans-serif">','') 
from t_produkt where detail like '%<span style="font-weight: normal; font-size: x-small; color: #000000; line-height: normal; font-style: normal; font-family: Verdana, Arial, Helvetica, sans-serif">%'
commit

begin tran
update T_Produkt 
set detail=replace(detail,'<span style="line-height: normal; font-style: normal; font-family: Verdana, Arial, Helvetica, sans-serif; color: #000000; font-size: x-small; font-weight: normal">','') 
from t_produkt where detail like '%<span style="line-height: normal; font-style: normal; font-family: Verdana, Arial, Helvetica, sans-serif; color: #000000; font-size: x-small; font-weight: normal">%'

begin tran
update T_Produkt 
set detail=replace(detail,'<span style="line-height: normal; font-style: normal; font-family: Verdana,Arial,Helvetica,sans-serif; color: #000000; font-size: x-small; font-weight: normal">','') 
from t_produkt where detail like '%<span style="line-height: normal; font-style: normal; font-family: Verdana,Arial,Helvetica,sans-serif; color: #000000; font-size: x-small; font-weight: normal">%'

begin tran
update T_Produkt 
set detail=replace(detail,'<span style="line-height: normal; font-style: normal; font-family: Verdana, Arial, Helvetica, sans-serif; color: #000099; font-size: x-small; font-weight: bold">','') 
from t_produkt where detail like '%<span style="line-height: normal; font-style: normal; font-family: Verdana, Arial, Helvetica, sans-serif; color: #000099; font-size: x-small; font-weight: bold">%'

begin tran
update T_Produkt 
set detail=replace(detail,'<span style="font-weight: bold; font-size: x-small; color: #000099; line-height: normal; font-style: normal; font-family: Verdana, Arial, Helvetica, sans-serif">','') 
from t_produkt where detail like '%<span style="font-weight: bold; font-size: x-small; color: #000099; line-height: normal; font-style: normal; font-family: Verdana, Arial, Helvetica, sans-serif">%'


begin tran
update T_Produkt 
set detail=replace(detail,'<span style="display: none" id="1231091578548S">&nbsp;</span>','') 
from t_produkt where detail like '%<span style="display: none" id="1231091578548S">&nbsp;</span>%'


begin tran
update T_Produkt 
set detail=replace(detail,'<span id="1231091578548S" style="display: none">&nbsp;</span>','') 
from t_produkt where detail like '%<span id="1231091578548S" style="display: none">&nbsp;</span>%'

<span style="line-height: normal; font-style: normal; font-family: Verdana, Arial, Helvetica, sans-serif; color: #000000; font-size: x-small">
<span style="color: #000080;">
<span style="">

begin tran
update T_Produkt 
set detail=replace(detail,'<span style="font-size: xx-small">','') 
from t_produkt where detail like '%<span style="font-size: xx-small">%'

begin tran
update T_Produkt 
set detail=replace(detail,'<span style="font-weight: normal; color: #000000; line-height: normal; font-style: normal; font-family: Verdana, Arial, Helvetica, sans-serif">','') 
from t_produkt where detail like '%<span style="font-weight: normal; color: #000000; line-height: normal; font-style: normal; font-family: Verdana, Arial, Helvetica, sans-serif">%'

begin tran
update T_Produkt 
set detail=replace(detail,'<span style="line-height: normal; font-style: normal; font-family: Verdana, Arial, Helvetica, sans-serif; color: #000000; font-size: x-small">','') 
from t_produkt where detail like '%<span style="line-height: normal; font-style: normal; font-family: Verdana, Arial, Helvetica, sans-serif; color: #000000; font-size: x-small">%'

begin tran
update T_Produkt 
set detail=replace(detail,'<span style="color: #000080;">','') 
from t_produkt where detail like '%<span style="color: #000080;">%'


begin tran
update T_Produkt 
set detail=replace(detail,'<span style="">','') 
from t_produkt where detail like '%<span style="">%'


begin tran
update T_Produkt 
set detail=replace(detail,'<span id="1230990915616S" style="display: none">','') 
from t_produkt where detail like '%<span id="1230990915616S" style="display: none">%'

begin tran
update T_Produkt 
set detail=replace(detail,'<span style="font-weight: normal; font-size: x-small; color: #000000; line-height: normal; font-style: normal; font-family: Verdana,Arial,Helvetica,sans-serif;">','') 
from t_produkt where detail like '%<span style="font-weight: normal; font-size: x-small; color: #000000; line-height: normal; font-style: normal; font-family: Verdana,Arial,Helvetica,sans-serif;">%'

begin tran
update T_Produkt 
set detail=replace(detail,'<span style="line-height: normal; font-style: normal; font-family: Verdana,Arial,Helvetica,sans-serif; color: #000000; font-size: x-small; font-weight: normal;">','') 
from t_produkt where detail like '%<span style="line-height: normal; font-style: normal; font-family: Verdana,Arial,Helvetica,sans-serif; color: #000000; font-size: x-small; font-weight: normal;">%'

begin tran
update T_Produkt 
set detail=replace(detail,'','') 
from t_produkt where detail like '%%'