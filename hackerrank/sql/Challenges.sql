select hacker_id,name,cnt 
from
(
select hacker_id,name,cnt,dense_rank() over (order by cnt desc) rnk
from 
(
select a.hacker_id,name,count(challenge_id) cnt
from 
hackers a join challenges b on a.hacker_id=b.hacker_id
group by a.hacker_id,name
)
)
where rnk=1
or rnk in (
select rnk from 
(
select hacker_id,name,cnt,dense_rank() over (order by cnt desc) rnk
from 
(
select a.hacker_id,name,count(challenge_id) cnt
from 
hackers a join challenges b on a.hacker_id=b.hacker_id
group by a.hacker_id,name
)
) group by rnk having count(*) < 2
)
order by rnk asc,hacker_id asc
;