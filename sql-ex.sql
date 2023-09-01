/* N 6 (2) */
/* Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость. */

select distinct
    p.maker
    ,l.speed
from Laptop as l
inner join Product as p on p.model = l.model
where l.hd >= 10




/* N 7 (2) */
/* Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква). */

select
    l.model,
    l.price
from Laptop as l
inner join Product as p on p.model = l.model
where p.maker = 'B'

union

select
    pc.model,
    pc.price
from PC as pc
inner join Product as p on p.model = pc.model
where p.maker = 'B'

union

select
    pr.model,
    pr.price
from Printer as pr
inner join Product as p on p.model = pr.model
where p.maker = 'B'




/* N 8 (2) */
/* Найдите производителя, выпускающего ПК, но не ПК-блокноты. */

select distinct p.maker
from Product as p
where p.type = 'PC'
    and p.maker not in
        (select p.maker
        from Product as p
        where p.type = 'Laptop')




/* N 14 (2) */
/* Найдите класс, имя и страну для кораблей из таблицы Ships, имеющих не менее 10 орудий. */

select
    c.class,
    s.name,
    c.country
from Ships as s
inner join Classes as c on c.class = s.class
where c.numGuns >= 10




/* N 15 (2) */
/* Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD */

select pc.hd
from PC as pc
group by pc.hd
having count(*) >= 2




/* N 16 (2) */
/* Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i), Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM. */

select distinct
    pc1.model
    ,pc2.model
    ,pc1.speed
    ,pc1.ram
from PC as pc1
inner join PC as pc2 on pc1.speed = pc2.speed
    and pc1.ram = pc2.ram
where pc1.model > pc2.model



/* N 17 (2) */
/* Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК.
Вывести: type, model, speed */

select distinct
    p.type
    ,la.model
    ,la.speed
from Laptop as la
inner join Product as p on p.model = la.model
where la.speed <
    (select min(pc.speed)
    from PC as pc)




/* N 18 (2) */
/* Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price */

select distinct
    p.maker
    ,pr.price
from Printer as pr
inner join Product as p on p.model = pr.model
where pr.color = 'y'
    and pr.price =
        (select min(pr.price)
        from Printer as pr
        where pr.color = 'y')




/* N 20 (2) */
/* Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК. */

select
    p.maker
    ,count(*) as count
from Product as p
group by
    p.maker
    ,p.type
having p.type = 'PC'
    and count(*) >= 3




/* N 23 (2) */
/* Найдите производителей, которые производили бы как ПК
со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
Вывести: Maker */

with
    pc_makers as
        (select distinct p.maker
        from PC as pc
        inner join Product as p on p.model = pc.model
        where pc.speed >= 750)

    ,laptop_makers as
        (select distinct p.maker
        from Laptop as la
        inner join Product as p on p.model = la.model
        where la.speed >= 750)

select pc_makers.maker
from pc_makers
inner join laptop_makers on laptop_makers.maker = pc_makers.maker




/* N 24 (2) */
/* Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции. */

with products as
    (select
        pc.model
        ,pc.price
    from PC as pc

    union

    select
        la.model
        ,la.price
    from Laptop as la

    union

    select
        pr.model
        ,pr.price
    from Printer as pr)

select products.model
from products
where products.price =
    (select max(products.price)
    from products)




/* N 25 (2) */
/* Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker */

with
    pc_with_min_ram as
        (select distinct
            p.maker
            ,pc.speed
        from PC as pc
        inner join Product as p on p.model = pc.model
        where pc.ram =
            (select min(pc.ram)
            from PC pc))
    ,pc_with_min_ram_and_max_speed as
        (select distinct pc_with_min_ram.maker
        from pc_with_min_ram
        where pc_with_min_ram.speed =
            (select max(pc_with_min_ram.speed)
            from pc_with_min_ram))

select distinct p.maker
from Product as p
inner join pc_with_min_ram_and_max_speed on pc_with_min_ram_and_max_speed.maker = p.maker
where p.type = 'Printer'




/* N 26 (2) */
/* Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква). Вывести: одна общая средняя цена. */

with prices as
    (select pc.price
    from PC as pc
    inner join Product as p on p.model = pc.model
    where p.maker = 'A'

    union all

    select la.price
    from Laptop as la
    inner join Product as p on p.model = la.model
    where p.maker = 'A')

select avg(price)
from prices




/* N 27 (2) */
/* Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD. */

with printer_makers as
    (select p.maker
    from Product as p
    where p.type = 'Printer')

select
    p.maker
    ,avg(pc.hd)
from PC as pc
inner join Product as p on p.model = pc.model
inner join printer_makers on printer_makers.maker = p.maker
group by p.maker




/* N 28 (2) */
/* Используя таблицу Product, определить количество производителей, выпускающих по одной модели. */

select count(*)
from
    (select p.maker
    from Product as p
    group by p.maker
    having count(*) = 1) as makers




/* N 34 (2) */
/* По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли водоизмещением более 35 тыс.тонн. Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом спуска на воду). Вывести названия кораблей. */

select sh.name
from Ships as sh
inner join Classes as c on c.class = sh.class
where c.type = 'bb'
    and c.displacement > 35000
    and sh.launched >= 1922




/* N 36 (2) */
/* Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes). */

select sh.name
from Ships as sh
where sh.name = sh.class

union

select o.ship as name
from Outcomes as o
inner join Classes c on c.class = o.ship




/* N 37 (2) */
/* Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes). */

with all_ships as
    (select
        sh.class
        ,sh.name
    from Ships as sh

    union

    select
        c.class
        ,o.ship as name
    from Outcomes as o
    inner join Classes c on c.class = o.ship)

select sh.class
from all_ships sh
group by sh.class
having count(*) = 1




/* N 39 (2) */
/* Найдите корабли, `сохранившиеся для будущих сражений`; т.е. выведенные из строя в одной битве (damaged), они участвовали в другой, произошедшей позже. */

select distinct o.ship
from Outcomes as o
inner join Battles as b1 on b1.name = o.battle
where o.result = 'damaged'
    and o.ship in
        (select o.ship
        from Outcomes as o
        inner join Battles as b2 on b2.name = o.battle
        where b1.date < b2.date)




/* N 40 (2) */
/* Найти производителей, которые выпускают более одной модели, при этом все выпускаемые производителем модели являются продуктами одного типа.
Вывести: maker, type */

with one_type_makers as
    (select p.maker
    from
        (select distinct p.maker, p.type
        from Product as p) as p
    group by p.maker
    having count(*) = 1)

select
    p.maker
    ,p.type
from Product as p
inner join one_type_makers on one_type_makers.maker = p.maker
group by
    p.maker
    ,p.type
having count(*) > 1
