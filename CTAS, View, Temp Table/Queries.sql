--1. Which movies from each genre are considered the most critically acclaimed based on their ratings?

--VIEW

create view vw_top_rated_movies_by_genre as
with cte as (
    select 
        m.movie_id, 
        m.title, 
        m.genre, 
        r.score,
        rank() over(partition by m.genre order by r.score desc) as ranking
    from movies m 
    inner join reviews r on m.movie_id = r.movie_id
)
select movie_id, title, genre, score 
from cte 
where ranking = 1;

select * from vw_top_rated_movies_by_genre;


--TEMPORARY TABLE
with cte as (
    select 
        m.movie_id, 
        m.title, 
        m.genre, 
        r.score,
        rank() over(partition by m.genre order by r.score desc) as ranking
    from movies m 
    inner join reviews r on m.movie_id = r.movie_id
)
select movie_id, title, genre, score 
into #temp_top_rated_movies_by_genre
from cte 
where ranking = 1;

select * from #temp_top_rated_movies_by_genre;


--CTAS
with cte as (
    select 
        m.movie_id, 
        m.title, 
        m.genre, 
        r.score,
        rank() over(partition by m.genre order by r.score desc) as ranking
    from movies m 
    inner join reviews r on m.movie_id = r.movie_id
)
select movie_id, title, genre, score 
into top_rated_movies_by_genre_ctas
from cte 
where ranking = 1;

select * from top_rated_movies_by_genre_ctas;


--2. Can you find the top 3 movies with the highest audience appreciation, regardless of genre?

--view
create view vw_top_3_movies_by_rating as
select top 3 m.movie_id, m.title, m.rating
from movies m
order by m.rating desc;

select * from vw_top_3_movies_by_rating;


--temp 
select top 3 m.movie_id, m.title, m.rating
into #temp_top_3_movies_by_rating
from movies m
order by m.rating desc;

select * from #temp_top_3_movies_by_rating;


--CTAS
select top 3 m.movie_id, m.title, m.rating
into top_3_movies_by_rating_ctas
from movies m
order by m.rating desc;

select * from top_3_movies_by_rating_ctas;


--3. Within each release year, which movies performed the best in terms of domestic revenue?

--view
create view vw_top_movie_per_year_by_revenue as
with cte as (
    select m.movie_id, m.title, m.release_year, b.domestic_gross,
    rank() over(partition by m.release_year order by b.domestic_gross desc) as ranking
    from movies m 
    inner join boxoffice b on m.movie_id = b.movie_id
)
select movie_id, title, release_year, domestic_gross, ranking 
from cte
where ranking = 1
order by domestic_gross desc;

select * from vw_top_movie_per_year_by_revenue;

--temp table
with cte as (
    select m.movie_id, m.title, m.release_year, b.domestic_gross,
    rank() over(partition by m.release_year order by b.domestic_gross desc) as ranking
    from movies m 
    inner join boxoffice b on m.movie_id = b.movie_id
)
select movie_id, title, release_year, domestic_gross, ranking 
into #temp_top_movie_per_year_by_revenue
from cte
where ranking = 1
order by domestic_gross desc;

select * from #temp_top_movie_per_year_by_revenue;


--ctas
with cte as (
    select m.movie_id, m.title, m.release_year, b.domestic_gross,
    rank() over(partition by m.release_year order by b.domestic_gross desc) as ranking
    from movies m 
    inner join boxoffice b on m.movie_id = b.movie_id
)
select movie_id, title, release_year, domestic_gross, ranking 
into top_movie_per_year_by_revenue_ctas
from cte
where ranking = 1
order by domestic_gross desc;

select * from top_movie_per_year_by_revenue_ctas;


--4. Are there any movies within the same genre that have an equal standing when it comes to international box office collections?

--view
create view vw_equal_international_gross_by_genre as
select 
    m.genre,
    b.international_gross
from movies m
join boxoffice b on m.movie_id = b.movie_id
group by m.genre, b.international_gross
having count(*) > 1;

select * from vw_equal_international_gross_by_genre;


--temp 
select 
    m.genre,
    b.international_gross
into #temp_equal_international_gross_by_genre
from movies m
join boxoffice b on m.movie_id = b.movie_id
group by m.genre, b.international_gross
having count(*) > 1;

select * from #temp_equal_international_gross_by_genre;


--ctas
select 
    m.genre,
    b.international_gross
into equal_international_gross_by_genre_ctas
from movies m
join boxoffice b on m.movie_id = b.movie_id
group by m.genre, b.international_gross
having count(*) > 1;

select * from equal_international_gross_by_genre_ctas;


--5. What are the best-rated movies in each genre according to critics?

--view
create view vw_best_rated_movies_by_genre as
with cte as (
    select m.movie_id, m.title, m.genre, r.score,
    rank() over(partition by m.genre order by r.score) as ranked
    from movies m  
    inner join reviews r on m.movie_id = r.movie_id
)
select movie_id, title, genre, score, ranked 
from cte
where ranked = 1;

select * from vw_best_rated_movies_by_genre;


--temp 
with cte as (
    select m.movie_id, m.title, m.genre, r.score,
    rank() over(partition by m.genre order by r.score) as ranked
    from movies m  
    inner join reviews r on m.movie_id = r.movie_id
)
select movie_id, title, genre, score, ranked 
into #temp_best_rated_movies_by_genre
from cte
where ranked = 1;

select * from #temp_best_rated_movies_by_genre;

--ctas 
with cte as (
    select m.movie_id, m.title, m.genre, r.score,
    rank() over(partition by m.genre order by r.score) as ranked
    from movies m  
    inner join reviews r on m.movie_id = r.movie_id
)
select movie_id, title, genre, score, ranked 
into best_rated_movies_by_genre_ctas
from cte
where ranked = 1;

select * from best_rated_movies_by_genre_ctas;

--6. How can we divide the movies into four equal groups based on their domestic earnings?

--view
create view vw_movies_grouped_by_domestic_gross as
select m.movie_id, m.title, b.domestic_gross,
case 
    when b.domestic_gross <= 190000000 then 'group a'
    when b.domestic_gross > 190000000 and b.domestic_gross <= 380000000 then 'group b'
    when b.domestic_gross > 380000000 and b.domestic_gross <= 570000000 then 'group c'
    when b.domestic_gross > 570000000 and b.domestic_gross <= 760000000 then 'group d'
end as groups
from movies m 
inner join boxoffice b on m.movie_id = b.movie_id;

select * from vw_movies_grouped_by_domestic_gross;

--temp 

select m.movie_id, m.title, b.domestic_gross,
case 
    when b.domestic_gross <= 190000000 then 'group a'
    when b.domestic_gross > 190000000 and b.domestic_gross <= 380000000 then 'group b'
    when b.domestic_gross > 380000000 and b.domestic_gross <= 570000000 then 'group c'
    when b.domestic_gross > 570000000 and b.domestic_gross <= 760000000 then 'group d'
end as groups
into #temp_movies_grouped_by_domestic_gross
from movies m 
inner join boxoffice b on m.movie_id = b.movie_id;

select * from #temp_movies_grouped_by_domestic_gross;


--ctas

select m.movie_id, m.title, b.domestic_gross,
case 
    when b.domestic_gross <= 190000000 then 'group a'
    when b.domestic_gross > 190000000 and b.domestic_gross <= 380000000 then 'group b'
    when b.domestic_gross > 380000000 and b.domestic_gross <= 570000000 then 'group c'
    when b.domestic_gross > 570000000 and b.domestic_gross <= 760000000 then 'group d'
end as groups
into movies_grouped_by_domestic_gross_ctas
from movies m 
inner join boxoffice b on m.movie_id = b.movie_id;

select * from movies_grouped_by_domestic_gross_ctas;


--7. Can we group movies into three distinct categories according to their international revenue?

--view
create view vw_movies_grouped_by_international_gross as
select m.movie_id, m.title, b.international_gross,
ntile(3) over(order by b.international_gross desc) as category
from movies m
inner join boxoffice b on m.movie_id = b.movie_id;

select * from vw_movies_grouped_by_international_gross;


--temp 
select m.movie_id, m.title, b.international_gross,
ntile(3) over(order by b.international_gross desc) as category
into #temp_movies_grouped_by_international_gross
from movies m
inner join boxoffice b on m.movie_id = b.movie_id;

select * from #temp_movies_grouped_by_international_gross;


--ctas
select m.movie_id, m.title, b.international_gross,
ntile(3) over(order by b.international_gross desc) as category
into movies_grouped_by_international_gross_ctas
from movies m
inner join boxoffice b on m.movie_id = b.movie_id;

select * from movies_grouped_by_international_gross_ctas;


--8. How would you determine the relative position of each movie based on its critic score?

--view
create view vw_movie_critic_percent_rank as
select m.movie_id, m.title, r.score,
percent_rank() over(order by r.score desc) as percent_rank
from movies m
inner join reviews r on m.movie_id = r.movie_id;

select * from vw_movie_critic_percent_rank;


--temp
select m.movie_id, m.title, r.score,
percent_rank() over(order by r.score desc) as percent_rank
into #temp_movie_critic_percent_rank
from movies m
inner join reviews r on m.movie_id = r.movie_id;

select * from #temp_movie_critic_percent_rank;


--ctas
select m.movie_id, m.title, r.score,
percent_rank() over(order by r.score desc) as percent_rank
into movie_critic_percent_rank_ctas
from movies m
inner join reviews r on m.movie_id = r.movie_id;

select * from movie_critic_percent_rank_ctas;


--9. If we look at the movies within a specific genre, how would you find their relative success in terms of domestic box office collection?

--view
create view vw_sci_fi_movies_ranked_by_domestic_gross as
select m.movie_id, m.title, b.domestic_gross,
percent_rank() over(order by b.domestic_gross desc) as ranking
from movies m
inner join boxoffice b on m.movie_id = b.movie_id
where m.genre = 'sci-fi';

select * from vw_sci_fi_movies_ranked_by_domestic_gross;


--temp 
select m.movie_id, m.title, b.domestic_gross,
percent_rank() over(order by b.domestic_gross desc) as ranking
into #temp_sci_fi_movies_ranked_by_domestic_gross
from movies m
inner join boxoffice b on m.movie_id = b.movie_id
where m.genre = 'sci-fi';

select * from #temp_sci_fi_movies_ranked_by_domestic_gross;


--ctas
select m.movie_id, m.title, b.domestic_gross,
percent_rank() over(order by b.domestic_gross desc) as ranking
into sci_fi_movies_ranked_by_domestic_gross_ctas
from movies m
inner join boxoffice b on m.movie_id = b.movie_id
where m.genre = 'sci-fi';

select * from sci_fi_movies_ranked_by_domestic_gross_ctas;


--10. How does each movie fare when comparing their total box office income to others?

--view
create view vw_movie_total_box_office_rank as
select m.movie_id, m.title, 
       sum(b.domestic_gross + b.international_gross) as total_box_office,
       percent_rank() over(order by sum(b.domestic_gross + b.international_gross) desc) as ranking
from reviews r 
inner join movies m on m.movie_id = r.movie_id
inner join boxoffice b on m.movie_id = b.movie_id
group by m.movie_id, m.title;

select * from vw_movie_total_box_office_rank;


--temp 
select m.movie_id, m.title, 
       sum(b.domestic_gross + b.international_gross) as total_box_office,
       percent_rank() over(order by sum(b.domestic_gross + b.international_gross) desc) as ranking
into #temp_movie_total_box_office_rank
from reviews r 
inner join movies m on m.movie_id = r.movie_id
inner join boxoffice b on m.movie_id = b.movie_id
group by m.movie_id, m.title;

select * from #temp_movie_total_box_office_rank;


--ctas
select m.movie_id, m.title, 
       sum(b.domestic_gross + b.international_gross) as total_box_office,
       percent_rank() over(order by sum(b.domestic_gross + b.international_gross) desc) as ranking
into movie_total_box_office_rank_ctas
from reviews r 
inner join movies m on m.movie_id = r.movie_id
inner join boxoffice b on m.movie_id = b.movie_id
group by m.movie_id, m.title;

select * from movie_total_box_office_rank_ctas;
