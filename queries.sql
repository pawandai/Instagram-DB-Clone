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

-- What day of the week do most users register on?
select
    count(*) as total,
    dayname(createdAt) as day
from
    users
group by
    day
order by
    total desc
limit
    1;

-- Find the users who have never posted a photo and send them email to post some photos
select
    username
from
    users
    left join photos on users.id = photos.userId
where
    photos.id is null;

-- Pick a most liked photo and send the user who posted that photo a reward.
select
    username,
    photos.id,
    photos.imageUrl,
    count(*) as total
from
    photos
    inner join likes on likes.photoId = photos.id
    inner join users on photos.userId = users.id
group by
    photos.id
order by
    total desc
limit
    1;

-- How many times does an average user posts?
select
    ceil(
        (
            select
                count(*)
            from
                photos
        ) / (
            select
                count(*)
            from
                users
        )
    ) as average;

-- What are the top 5 most commonly userd hashtags?
select
    count(*) as total,
    tags.tagName
from
    photo_tags
    join tags on photo_tags.tagId = tags.id
group by
    tags.id
order by
    total desc
limit
    5;

-- Find users who have likes every single photo on the app (detect bots)
select
    username,
    likes.userId,
    count(*) as totalLikes
from
    users
    inner join likes on users.id = likes.userId
group by
    likes.userId
having
    totalLikes = (
        select
            count(*)
        from
            photos
    );

-- Show all the users that have liked a specific photo with id = 1
SELECT
    user.username
FROM
    likes
    JOIN users ON likes.userId = users.id
WHERE
    likes.photoId = 1;

-- Retrieve all followers of a specific user with id = 1
SELECT
    u.username
FROM
    follows f
    JOIN users u ON f.followerId = u.id
WHERE
    f.followeeId = 1;

-- Find users who have never uploaded a photo.
SELECT
    username
FROM
    users
WHERE
    id NOT IN (
        SELECT
            userId
        FROM
            photos
    );

-- Get a list of users who follow a specific user and have commented on one of their photos.
SELECT
    DISTINCT u.username
FROM
    follows f
    JOIN users u ON f.followerId = u.id
    JOIN comments c ON c.userId = u.id
WHERE
    f.followeeId = 1
    AND c.photoId IN (
        SELECT
            id
        FROM
            photos
        WHERE
            userId = 1
    );

-- Find the average number of comments per photo.
SELECT
    AVG(comment_count)
FROM
    (
        SELECT
            photoId,
            COUNT(*) AS comment_count
        FROM
            comments
        GROUP BY
            photoId
    ) AS comment_counts;

-- Find top 3 most liked photos with the total number of comments on each photo.
SELECT
    p.id,
    COUNT(l.userId) AS like_count,
    COUNT(c.id) AS comment_count
FROM
    photos p
    LEFT JOIN likes l ON p.id = l.photoId
    LEFT JOIN comments c ON p.id = c.photoId
GROUP BY
    p.id
ORDER BY
    like_count DESC
LIMIT
    3;

-- Get the number of mutual followers between two users (userA and userB).
SELECT
    COUNT(*)
FROM
    follows f1
    JOIN follows f2 ON f1.followerId = f2.followerId
WHERE
    f1.followeeId = userA
    AND f2.followeeId = userB;