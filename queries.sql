-- select the top 5 users that have been loyal for more than eight years and maybe reward them
select
    *
from
    users
where
    datediff(now(), createdAt) / 356 > 8
order by
    createdAt desc
limit
    5;