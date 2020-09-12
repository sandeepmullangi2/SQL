select id,age,coins_needed,power
from
(
select id,age,coins_needed,power,rank() over (partition by age,power order by coins_needed asc)rnk
from
wands a join wands_property b on a.code=b.code
where is_evil=0
) a
where rnk=1
ORDER BY power DESC, age DESC;