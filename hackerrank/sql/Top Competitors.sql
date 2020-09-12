select hacker_id, name
from
(
select a.hacker_id,name,sum(case when c.score=a.score then 1 end) as x
from submissions a join challenges b on a.challenge_id=b.challenge_id
join difficulty c on b.difficulty_level=c.difficulty_level
join hackers d on a.hacker_id=d.hacker_id
group by name,a.hacker_id
)
where x > 1
order by x desc,hacker_id asc;