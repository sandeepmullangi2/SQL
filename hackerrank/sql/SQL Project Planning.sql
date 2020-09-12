select min(end_date)-1 as min,max(end_date) as max
from
(
select end_date
,row_number() over (order by end_date) as rn
,end_date-row_number() over (order by end_date) as grp
from
projects
)
group by grp
order by max-min-1 asc, min asc;