select city, len_city
from
(select city, LENGTH(city) as len_city, row_number() over (order by LENGTH(city), city) as rownum1 from station
) where rownum1=1
union 
select city, len_city
from
(select city, LENGTH(city) as len_city, row_number() over (order by LENGTH(city) desc, city) as rownum1 from station
) where rownum1=1;
