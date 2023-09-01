create function dbo.udf_GetSKUPrice (@ID_SKU int)
returns decimal(18, 2)
begin
    declare @result decimal(18, 2)

    select @result = sum(b.Value) / sum(b.Quantity)
    from dbo.Basket as b
    where b.ID_SKU = @ID_SKU

    return @result
end
