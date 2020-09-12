select 
case when grade >=8 then name else 'NULL' end as name,b.grade,a.marks
from students a left outer join grades b on a.marks between b.min_mark and b.max_mark
order by b.grade desc,name asc;

