-- 1a. Display the first and last names of all actors from the table actor.
select first_name,last_name from actor;

/*1b. Display the first and last name of each actor in a single column in upper case -- letters. Name the column Actor Name.*/

select upper(concat(first_name,' ', last_name)) as ACTOR_NAME from actor;
OR
SELECT IF(ISNULL(first_name), last_name, CONCAT(first_name, ' ', last_name)) AS ACTOR_NAME FROM actor;

/* 2a. You need to find the ID number, first name, and last name of an actor, of whom -- you know only the first name, "Joe." What is one query would you use to obtain this information?*/

select ACTOR_ID,first_name,last_name from actor where first_name = 'JOE';

-- 2b. Find all actors whose last name contain the letters GEN:

select ACTOR_ID,first_name,last_name from actor where last_name like  '%GEN%';

/* 2c. Find all actors whose last names contain the letters LI. This time, order the -- --rows by last name and first name, in that order:*/

select ACTOR_ID,first_name,last_name from actor where last_name like  '%LI%' order by 2,3;

/*2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:*/

select country,country_id from country where country in('Afghanistan','Bangladesh','China');

/*3a. You want to keep a description of each actor. You don't think you will be performing queries on a description,
    so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB,
    as the difference between it and VARCHAR are significant).*/

alter table  actor add column description BLOB;

/*--3b. Very quickly you realize that entering descriptions for each actor is too much --  --effort. Delete the description column.*/

alter table actor drop description;

/*-- 4a. List the last names of actors, as well as how many actors have that last name.*/

select first_name, last_name,count(*) from actor group by 2;

/*4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors*/
SELECT CONCAT(a.first_name,' ',a.last_name) AS fullName
FROM actor a
WHERE CONCAT(a.first_name,' ',a.last_name) IN (
SELECT CONCAT(a.first_name,' ',a.last_name) AS fullNm
FROM actor a
GROUP BY a.last_name
HAVING COUNT(*) = 2  
);

/* 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.*/


SELECT REPLACE('GROUCHO', 'GROUCH', 'HARP');

/*4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)/*

SELECT REPLACE('HARPO', 'HARP', 'MUCHO GROUCH');
  UPDATE 
	actor
SET
	first_name = 'GROUCHO'
 WHERE
	actor_id = 78 ;
    

/*5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html/*

mysql> SHOW CREATE TABLE address;

/*6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address*/

select first_name,last_name,a.address from staff s, address a where a.address_id = s.address_id;
OR
select first_name,last_name,a.address from staff s JOIN address a where a.address_id = s.address_id;

/*6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.*/


select s.first_name, s.last_name,s.email, sum(amount) TOTAL_AMOUNT, p.payment_date from staff s,payment p where s.staff_id=p.staff_id and p.payment_date like '%2005-08-%'  group by 2;

/* 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.*/

select DISTINCT title,count(b.actor_id) AS NUMBER_OF_ACTORS from film a inner join film_actor b where a.film_id=b.film_id group by 1;

/** 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?*/

select a.title,count(b.film_id)  from film a, inventory b where b.film_id=439 and a.title ='HUNCHBACK IMPOSSIBLE';

/* 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:*/

select c.first_name,c.last_name, sum(amount) from customer c join payment p where c.customer_id=p.customer_id group by 2;

/*7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.*/

select f.title,f.language_id from film f where f.title  like 'K%' or f.title like 'Q%' and f.language_id in(select l.language_id from language l where f.language_id=l.language_id and l.name='English');

 /* 7b. Use subqueries to display all actors who appear in the film Alone Trip.*/
select DISTINCT concat(first_name,' ', last_name), f.title from actor a, film_actor fa, film f where f.title = (select f.title from film f where title='Alone Trip');

/*7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.*/


 
/*7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.*/

select title,rating AS FAMILY_FILMS from film where rating ='PG';

/*7e. Display the most frequently rented movies in descending order.*/
SELECT       title, rental_duration,
             COUNT(rental_duration) AS frequently_rented
    FROM     film
    GROUP BY rental_duration
    ORDER BY value_occurrence DESC;
    LIMIT    1;
    
  /*7f. Write a query to display how much business, in dollars, each store brought in.*/
  
  select c.store_id AS STORE_NUMBER,sum(p.amount) as TOTAL_REVENUE from customer c, payment p where c.customer_id=p.customer_id group by 1;
+--------------+--------------+
| STORE_NUMBER | TOTAL_PROFIT |
+--------------+--------------+
|            1 |     37001.52 |
|            2 |     30414.99 |
+--------------+--------------+
2 rows in set (0.03 sec)

/*7g. Write a query to display for each store its store ID, city, and country.*/

select a.store_id,c.city,b.country from customer a,city c,country b where c.country_id=b.country_id group by b.country order by a.store_id;


/*7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)*/

SELECT
	cat.name,
    sum(p.amount) AS 'Gross Revenue'
    
FROM
	 payment p 
	INNER JOIN rental r
    ON p.rental_id = r.rental_id
	
	INNER JOIN  inventory i
    ON r.inventory_id = i.inventory_id

	INNER JOIN film_category fc
    ON fc.film_id = i.film_id

	INNER JOIN category cat
    ON cat.category_id = fc.category_id
 GROUP BY cat.name   
ORDER BY 2 DESC;
    
8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW Top_Five_genres  AS SELECT
	cat.name,
    sum(p.amount) AS 'Gross Revenue'  
FROM
	 payment p 
	INNER JOIN rental r
    ON p.rental_id = r.rental_id
	
	INNER JOIN  inventory i
    ON r.inventory_id = i.inventory_id

	INNER JOIN film_category fc
    ON fc.film_id = i.film_id

	INNER JOIN category cat
    ON cat.category_id = fc.category_id
 GROUP BY cat.name   
ORDER BY 2 DESC;

8b. How would you display the view that you created in 8a?

select * from Top_Five_genres;

8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

drop view Top_Five_genres;







