--1List the films where the yr is 1962 [Show id, title]
SELECT id, title
 FROM movie
 WHERE yr=1962;

--2Give year of 'Citizen Kane'.
SELECT yr FROM movie
WHERE title = 'Citizen Kane';

--3List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr FROM movie
WHERE title like '%Star Trek%'
ORDER BY yr;

--4What id number does the actor 'Glenn Close' have?
SELECT id FROM actor
WHERE name = 'Glenn Close';

--5What is the id of the film 'Casablanca'
SELECT id FROM movie
WHERE title = 'Casablanca';

--6.Obtain the cast list for 'Casablanca'.
--what is a cast list?
--The cast list is the names of the actors who were in the movie.
--Use movieid=11768, (or whatever value you got from the previous question)
SELECT actor.name FROM casting JOIN actor ON (casting.actorid = actor.id)
WHERE movieid = 11768

--7Obtain the cast list for the film 'Alien'
SELECT actor.name FROM casting JOIN actor ON(casting.actorid = actor.id)
WHERE movieid = (SELECT id FROM movie WHERE title = 'Alien')

SELECT actor.name FROM actor
JOIN casting ON (actor.id = casting.actorid)
JOIN movie ON (casting.movieid = movie.id AND title = 'Alien');

--8List the films in which 'Harrison Ford' has appeared
SELECT movie.title FROM movie JOIN casting ON (movie.id = casting.movieid)
WHERE casting.actorid = (SELECT id FROM actor WHERE name = 'Harrison Ford')

SELECT movie.title FROM movie
JOIN casting ON (movie.id = casting.movieid)
JOIN actor ON (casting.actorid = actor.id AND actor.name = 'Harrison Ford');

--9List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
SELECT movie.title FROM movie JOIN casting ON (movie.id = casting.movieid)
WHERE casting.actorid = (SELECT id FROM actor WHERE name = 'Harrison Ford')
AND casting.ord != 1

SELECT movie.title FROM movie
JOIN casting ON (movie.id = casting.movieid AND casting.ord != 1)
JOIN actor ON (casting.actorid = actor.id AND actor.name = 'Harrison Ford');


--10.List the films together with the leading star for all 1962 films.
SELECT movie.title, 
(SELECT name FROM actor WHERE id = casting.actorid) AS name
FROM movie 
JOIN casting ON (movie.id = casting.movieid)
WHERE movie.yr = 1962 AND casting.ord = 1 

SELECT title, actor.name FROM movie
JOIN casting ON (movie.id = casting.movieid AND ord = 1)
JOIN actor ON (casting.actorid = actor.id)
WHERE yr = 1962

--11.Busy years for Rock Hudson
SELECT movie.yr, COUNT(movie.title) FROM movie 
    JOIN casting ON movie.id=movieid
    JOIN actor   ON actorid=actor.id
WHERE actor.name='Rock Hudson'
GROUP BY movie.yr
HAVING COUNT(movie.title) > 2

--12List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT movie.title, actor.name FROM movie
JOIN casting ON (casting.movieid = movie.id AND casting.ord = 1)
JOIN actor ON (casting.actorid= actor.id)
WHERE movieid IN (
                    SELECT movieid FROM casting
                    WHERE actorid IN (
                                        SELECT id FROM actor
                                        WHERE name = 'JUlie Andrews'
                                     )

                )

SELECT movie.title, actor.name FROM movie
JOIN casting ON (movie.id = casting.movieid AND casting.ord = 1)
JOIN actor ON (casting.actorid = actor.id)
WHERE movie.id IN 
(SELECT movieid FROM casting JOIN actor ON 
(casting.actorid = actor.id ) 
WHERE actor.name = 'Julie Andrews')

--13Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT actor.name FROM actor
JOIN casting ON(actor.id = casting.actorid AND 
(SELECT COUNT(ord) FROM casting WHERE casting.actorid = actor.id AND casting.ord=1)>=15)
GROUP BY actor.name;

--14List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT movie.title, COUNT(casting.actorid) FROM movie
JOIN casting ON (movie.id = casting.movieid)
WHERE yr = 1978
GROUP BY movie.title
ORDER BY COUNT(casting.actorid) DESC, movie.title;

--15List all the people who have worked with 'Art Garfunkel'.
SELECT actor.name FROM actor
JOIN casting ON (actor.id = casting.actorid)
WHERE casting.movieid IN
(SELECT movieid FROM casting JOIN actor ON (actorid=id AND name='Art Garfunkel')) AND name != 'Art Garfunkel';


