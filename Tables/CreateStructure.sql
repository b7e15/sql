create table dbo.SKU
(
    ID int identity primary key not null,
    Code as concat('s', ID) unique,
    Name varchar(255)
)

create table dbo.Family
(
    ID int identity primary key not null,
    SurName varchar(255),
    BudgetValue int
)

create table dbo.Basket
(
    ID int identity primary key not null,
    ID_SKU int references dbo.SKU(ID) on delete cascade,
    ID_Family int references dbo.Family(ID) on delete cascade,
    Quantity decimal(18, 2) check (Quantity >= 0),
    Value decimal(18, 2) check (Value >= 0),
    PurchaseDate datetime DEFAULT (getdate()),
    DiscountValue int
)