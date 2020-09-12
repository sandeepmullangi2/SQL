select hacker_id,name,sum(score) score from 
(
select a.hacker_id,name,score,row_number() over (partition by a.hacker_id,challenge_id order by score desc)rnk
from 
hackers a join submissions b on a.hacker_id=b.hacker_id
)
where rnk=1 
group by hacker_id,name
having sum(score) > 0
order by score desc, hacker_id asc
;