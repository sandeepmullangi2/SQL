select contest_id,hacker_id,name,ts,tas,tv,tuv
from
(
select a.contest_id,a.hacker_id,a.name,sum(ts) ts,sum(tas) tas,sum(tv) tv,sum(tuv) tuv
from
Contests a join Colleges b on a.contest_id=b.contest_id
join challenges c on b.college_id=c.college_id
left join (select challenge_id,sum(total_views) tv,sum(total_unique_views) tuv from view_stats group by challenge_id) d on c.challenge_id=d.challenge_id
left join (select challenge_id,sum(total_submissions) ts,sum(total_accepted_submissions) tas from submission_stats group by challenge_id) e on c.challenge_id=e.challenge_id
group by a.contest_id,a.hacker_id,a.name
)
where ts > 0 or tas > 0 or tv > 0 or tuv > 0
order by contest_id;