-- searched for 'P' in pizza_name table
select CHARINDEX('p', pizza_name) as search from pizza_names

-- multiple characters
select CHARINDEX('e', pizza_name) as search from pizza_names
-- returns first occuring char position and indexing starts from 1

-- using 3rd input 
select CHARINDEX('e', pizza_name, 4) as search from pizza_names

----------------------------------------------------------------------------------

/*Parameter		Description
%pattern%		Required. The pattern to find. It MUST be surrounded by %. Other wildcards can be used in pattern, such as:
%		-		Match any string of any length (including 0 length)
_ 		-		Match one single character
[] 		-		Match any characters in the brackets, e.g. [xyz]
[^] 	-		Match any character not in the brackets, e.g. [^xyz]
*/

-- patindex  pattern matching
select PATINDEX('%o%ions%', topping_name) as char_index from pizza_toppings

--  character matching 
select PATINDEX('%[or]%', topping_name) as char_index from pizza_toppings
select * from pizza_toppings;

-- excluding matching
select PATINDEX('%[^c]%', topping_name) as char_index from pizza_toppings

-----------------------------------------------------------------------------------

--try_cast() if conversion possible then OK otherwise returns null
select TRY_CAST(customer_id as float) from customer_orders  --int to float

--datetime to date
select TRY_CAST(order_time as date) from customer_orders  

--string to int
select TRY_CAST(topping_name as int) from pizza_toppings;  

----------------------------------------------------------------------------------

-- cross apply()
select distance, km
from rider_orders
cross apply (select left(distance, 1) as km) as splitted_km;

--string_split()
with cte as (
select pizza_id, value as toppings 
from pizza_recipes cross apply string_split(toppings, ',') as splitted
)

select pizza_id, trim(toppings) from cte 


--string split on the basis of spaces
select * from string_split ('BMW is a German Car Maker', ' ') as splitted

----string split on the basis of special characters
select * from string_split ('BMW $ is $ a $ German $ Car $ Maker', '$') as splitted



select trim(pizza_id), trim(toppings)
from pizza_recipes
cross apply string_split(trim(toppings), ',') as splitted_items