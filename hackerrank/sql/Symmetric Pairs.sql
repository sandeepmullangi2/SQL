select a.x, a.y from (
    -- tuples with not equals that follow the rule
    select f1.x, f1.y 
    from functions f1 join functions f2 
    on (f1.x = f2.y and f2.x = f1.y)
    and f1.x < f1.y
    union
    -- tuples with the equals that follow the rule
    select f1.x, f1.y 
    from functions f1 join functions f2 
    on (f1.x = f2.y and f2.x = f1.y)
    group by f1.x,f1.y
    having count(1) > 1
) a
order by a.x asc;