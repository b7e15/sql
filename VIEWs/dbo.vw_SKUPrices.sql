create view dbo.vw_SKUPrices as
select
    s.ID
    ,s.Code
    ,s.Name
    ,dbo.udf_GetSKUPrice(s.ID) as Price
from dbo.SKU as s