create procedure dbo.udf_MakeFamilyPurchase (@FamilySurName varchar(255)) as
begin
    update dbo.Family
    set BudgetValue =
        (select isnull(sum(b.Value), 0)
        from dbo.Basket as b
        inner join dbo.Family as f on f.ID = b.ID_Family
        where f.SurName = @FamilySurName)
    where SurName = @FamilySurName

    if @@ROWCOUNT <= 0
        throw 50001, '@FamilySurName does not exist', 1
end
