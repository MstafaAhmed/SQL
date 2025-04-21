CREATE DATABASE movie;


CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title varchar(50),
    release_year INTEGER,
    genre varchar(50)
);

CREATE TABLE actors (
    id INTEGER PRIMARY KEY,
    name varchar(50),
    birth_year INTEGER
);

CREATE TABLE movie_actors (
    movie_id INTEGER,
    actor_id INTEGER,
    FOREIGN KEY (movie_id) REFERENCES movies(id),
    FOREIGN KEY (actor_id) REFERENCES actors(id)
);

CREATE TABLE ratings (
    movie_id INTEGER,
    user_id INTEGER,
    rating INTEGER,
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);
-- Movies
INSERT INTO movies VALUES
(1, 'Inception', 2010, 'Sci-Fi'),
(2, 'The Dark Knight', 2008, 'Action'),
(3, 'Interstellar', 2014, 'Sci-Fi'),
(4, 'The Prestige', 2006, 'Drama'),
(5, 'Dunkirk', 2017, 'War');

-- Actors
INSERT INTO actors VALUES
(1, 'Leonardo DiCaprio', 1974),
(2, 'Christian Bale', 1974),
(3, 'Joseph Gordon-Levitt', 1981),
(4, 'Matthew McConaughey', 1969),
(5, 'Michael Caine', 1933);

-- Movie Actors
INSERT INTO movie_actors VALUES
(1, 1), (1, 3), (1, 5),
(2, 2), (2, 5),
(3, 4), (3, 5),
(4, 2), (4, 5),
(5, 5);

-- Ratings
INSERT INTO ratings VALUES
(1, 1, 9), (1, 2, 10), (1, 3, 8),
(2, 1, 10), (2, 2, 9), (2, 4, 9),
(3, 3, 9), (3, 4, 10),
(4, 2, 7)


-- viewing
SELECT * FROM movies
SELECT * FROM actors
SELECT * FROM movie_actors
SELECT * FROM ratings
--Add a New Movie
INSERT INTO movies (id, title, release_year, genre)
VALUES (6, 'Tenet', 2020, 'Sci-Fi');

--Update a Movie Title
UPDATE movies
SET title = 'The Dark Knight Rises'
WHERE id = 2;

-- Movies Without Any Ratings
SELECT m.title
FROM movies m
LEFT JOIN ratings r ON m.id = r.movie_id
WHERE r.movie_id IS NULL

-- Find All Movies Featuring a Specific Actor (e.g., Michael Caine)
SELECT m.title
FROM movies m
JOIN movie_actors ma ON m.id = ma.movie_id
JOIN actors a ON ma.actor_id = a.id
WHERE a.name  = 'Michael Caine';


--Count Total Movies Per Genre
SELECT genre, COUNT(*) AS total_movies
FROM movies
GROUP BY genre

--List All Actors in a Specific Movie (e.g., Inception)
SELECT a.name
FROM actors a
JOIN movie_actors ma ON a.id = ma.actor_id
JOIN movies m ON ma.movie_id = m.id
WHERE m.title = 'Inception';

--Find Movies with an Average Rating  9
SELECT m.title, AVG(r.rating) AS avg_rating
FROM movies m
JOIN ratings r ON m.id = r.movie_id
GROUP BY m.id, m.title
HAVING AVG(r.rating) = 9;

--List All Actor Pairs Who Have Acted Together

SELECT DISTINCT a1.name AS actor_1, a2.name AS actor_2, m.title
FROM movie_actors ma1
JOIN movie_actors ma2 ON ma1.movie_id = ma2.movie_id AND ma1.actor_id < ma2.actor_id
JOIN actors a1 ON ma1.actor_id = a1.id
JOIN actors a2 ON ma2.actor_id = a2.id
JOIN movies m ON ma1.movie_id = m.id
ORDER BY actor_1, actor_2;

-- Window Function: Rank Movies by Average Rating

SELECT 
    m.title,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    RANK() OVER (ORDER BY AVG(r.rating) DESC) AS rank
FROM movies m
JOIN ratings r ON m.id = r.movie_id
GROUP BY m.id, m.title;

-- Find All Movies Released After 2010

SELECT * 
FROM movies
WHERE release_year > 2010;

-- Delete Ratings for a Specific Movie (e.g., 'Dunkirk')

DELETE FROM ratings
WHERE movie_id = 
(SELECT id FROM movies WHERE title = 'Dunkirk')

--Update an Actor’s Birth Year

UPDATE actors
SET birth_year = 1975
WHERE name  = 'Christian Bale';

-- Find the Actor Who Appeared in the Most Movies

SELECT a.name, COUNT(ma.movie_id) AS movie_count
FROM actors a
JOIN movie_actors ma ON a.id = ma.actor_id
GROUP BY a.id, a.name
ORDER BY movie_count DESC
