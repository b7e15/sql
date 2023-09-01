create trigger dbo.TR_Basket_insert_update on dbo.Basket instead of insert as
begin
    /* Calculate whether a discount is needed for ID_SKU and ID_Family pairs */
    with discountable as
        (select
            i.ID_SKU
            ,i.ID_Family
            ,isDiscountable = case
                when count(*) >= 2 then 1
                else 0
                end
        from inserted as i
        group by
            i.ID_SKU
            ,i.ID_Family)

    /* Add records */
    insert into dbo.Basket(ID_SKU, ID_Family, Quantity, Value, PurchaseDate, DiscountValue)
    select
        i.ID_SKU
        ,i.ID_Family
        ,i.Quantity
        ,i.Value
        ,i.PurchaseDate
        ,DiscountValue = case
            when d.isDiscountable = 1 then i.Value * 0.05
            else 0
            end
    from inserted i
    left join discountable as d on d.ID_SKU = i.ID_SKU and d.ID_Family = i.ID_Family    
end