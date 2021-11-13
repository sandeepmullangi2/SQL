--This is a data set We need to only keep one occurrence of a b So if table has a b and also b a the only one row should be deleted
with `tab` as 
(
    select 'A' as col1, 'B' as col2
    union all 
    select 'B' as col1, 'A' as col2
    union all 
    select 'C' as col1, 'D' as col2
    union all 
    select 'B' as col1, 'C' as col2
    union all 
    select 'C' as col1, 'E' as col2

)
select a.col1,a.col2 from tab a left join tab b 
on a.col1=b.col2 and a.col2=b.col1
where a.col1<a.col2



--Find matches won
with `tab` as 
(
    select 'CSK' as team1, 'DD' as team2, 1 as won
    union all 
    select 'KKR' as team1, 'DD' as team2, 2 as won
    union all 
    select 'CSK' as team1, 'KKR' as team2, 0 as won
)
select team1 as team, count(1) as matches_played, 
sum(case when won=team1 then 1 else 0 end) as matches_won,
sum(case when won!=team1 and won!='draw' then 1 else 0 end) as matches_lost,
sum(case when won='draw' then 1 else 0 end)  as matches_drawn from 
(
select team1, case when won=1 then team1 when won=2 then team2 else 'draw' end as won from tab
union all 
select team2, case when won=1 then team1 when won=2 then team2 else 'draw' end as won from tab
)
group by team1


--Create table of fixtures from below table of countries
--Country
--Ind
--Aus
--SA

with `tab` as 
(
    select 'Ind' as country
    union all 
    select 'Aus' as country
    union all 
    select 'SA' as country
)
select a.country,b.country as another_country from tab a cross join tab b
where a.country!=b.country and a.country>b.country


--There is a list of countries say IND, PAK, CHN, AFG, SRI, BNG. Create a combination of countries with the help of this list using one query How about IND-PAK & PAK-IND duplicate, this is where people get stuck? Could not arrive at the solution or approach
with `tab` as 
(
    select 'IND' as country
    union all 
    select 'PAK' as country
    union all 
    select 'CHN' as country
    union all 
     select 'AFG' as country
    union all 
    select 'SRI' as country
    union all 
    select 'BNG' as country
)
select * from tab a cross join tab b 
where a.country!=b.country and a.country>b.country
