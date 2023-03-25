USE sakila;

# 1. List each pair of actors that have worked together.
# With JOIN, in previous lab.
SELECT a1.first_name AS act1_firstname, a1.last_name AS act1_lastname,
       a2.first_name AS act2_firstname, a2.last_name AS act2_lastname
FROM film_actor AS fa1
JOIN film_actor AS fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id 
JOIN actor AS a1 ON fa1.actor_id = a1.actor_id
JOIN actor AS a2 ON fa2.actor_id = a2.actor_id
ORDER BY act1_firstname ASC;

# Without JOIN, with subqueries.
SELECT a1.first_name AS act1_firstname, a1.last_name AS act1_lastname, a2.first_name AS act2_firstname, a2.last_name AS act2_lastname
FROM film_actor AS fa1, film_actor AS fa2, actor AS a1, actor AS a2
WHERE 
	fa1.film_id = fa2.film_id 
	AND fa1.actor_id < fa2.actor_id 
	AND fa1.actor_id = a1.actor_id 
	AND fa2.actor_id = a2.actor_id
ORDER BY 
    act1_lastname ASC;

# 2. For each film, list actor that has acted in more films.
SELECT a.first_name, a.last_name, fa.actor_id, COUNT(*) AS actor_film_count # To see the amount of films each actor has acted in.
FROM film_actor AS fa
JOIN actor AS a ON fa.actor_id = a.actor_id
GROUP BY fa.actor_id
ORDER BY actor_film_count ASC; 

WITH actor_film_counts AS (
  SELECT actor_id, COUNT(*) AS num_films
  FROM film_actor
  GROUP BY actor_id
), 
max_film_count AS (
  SELECT MAX(num_films) AS max_num_films
  FROM actor_film_counts
)
SELECT f.title, a.first_name, a.last_name, afc.num_films
FROM film AS f 
INNER JOIN film_actor AS fa ON f.film_id = fa.film_id 
INNER JOIN actor AS a ON fa.actor_id = a.actor_id 
INNER JOIN actor_film_counts AS afc ON a.actor_id = afc.actor_id 
INNER JOIN (
  SELECT fa.film_id, MAX(afc.num_films) AS max_num_films
  FROM film_actor AS fa 
  INNER JOIN actor_film_counts AS afc ON fa.actor_id = afc.actor_id
  GROUP BY fa.film_id
) AS max_film_counts ON fa.film_id = max_film_counts.film_id AND afc.num_films = max_film_counts.max_num_films
ORDER BY f.title;






