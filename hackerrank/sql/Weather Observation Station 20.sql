select round(LAT_N,4) from station order by lat_n limit 1 offset 249 ;
(or)
select round(LAT_N,4)
from
(
select round(LAT_N,4), row_number() over (order by LAT_N) rownum1 from station
) A
where rownum1 =
(
select case when count(*) %2 = 0 then count(*)/2 else count(*)/2+1 end
from station
)