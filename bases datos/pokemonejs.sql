
--6. Sacar el nombre de los pokemon que pueden evolucionar en más de un pokemon.
SELECT e.nombre
FROM especie_pokemon e
WHERE (SELECT COUNT(*) 
					FROM especie_pokemon
					WHERE evoluciona_de= e.id_pokedex)>1;


--7. Sacar el nombre, ataque y defensa de todas las evoluciones de eevee, ordenadas por ataque
--de mayor a menor y después por orden alfabético.
SELECT nombre, ataque, defensa
FROM especie_pokemon
WHERE evoluciona_de=(SELECT id_pokedex
		FROM especie_pokemon
		WHERE LOWER(nombre)='eevee')
ORDER BY ataque DESC, nombre;

--9. Sacar el nombre y el nombre del tipo principal de los pokemon de la 3ª generación (con
--producto cartesiano y con join).

SELECT e.nombre, t.nombre
FROM especie_pokemon e
JOIN tipo t
	ON e.tipo1 = t.id_tipo
WHERE e.generacion=3;

-----------------

SELECT e.nombre, t.nombre
FROM especie_pokemon e
WHERE e.tipo1 = t.id_tipo
AND e.generacion=3;

--10. Sacar el número de pokemon de tipo fuego (con subconsulta, con producto cartesiano y con
--join).


SELECT COUNT(*)
FROM especie_pokemon
WHERE tipo1 = (SELECT id_tipo
			   FROM tipo
			   WHERE LOWER(nombre)= 'fuego')
   OR tipo2 = (SELECT id_tipo
			   FROM tipo
			   WHERE LOWER(nombre)= 'fuego');

SELECT COUNT(*)
FROM especie_pokemon e, tipo t
WHERE (e.tipo1 = t.id_tipo
	OR e.tipo2 = t.id_tipo)
AND LOWER(t.nombre) = 'fuego';


SELECT COUNT(*)
FROM especie_pokemon e
JOIN tipo t
	ON (e.tipo1= t.id_tipo
	OR e.tipo2 = t.id_tipo)
WHERE LOWER(t.nombre) = 'fuego';



--11. Sacar el nombre y la vida de los pokemon de tipo agua, ordenados por vida de mayor a
--menor (con subconsulta, con producto cartesiano y con join).

SELECT nombre, hp
FROM especie_pokemon
WHERE tipo1 = (SELECT id_tipo
				FROM tipo
				WHERE LOWER(nombre) = 'agua')
   OR tipo2 = (SELECT id_tipo
				FROM tipo
				WHERE LOWER(nombre) = 'agua')
ORDER BY hp DESC;

SELECT e.nombre, e.hp
FROM especie_pokemon e, tipo t
WHERE (e. tipo1 = t.id_tipo 
	  OR e. tipo2 = t.id_tipo)
AND LOWER(t.nombre)= 'agua'
ORDER BY hp;

SELECT e.nombre, e.hp
JOIN tipo t
ON(e.tipo1= t.id_tipo
	OR tipo2 =t-id_tipo)
AND LOWER(t.nombre)= 'agua'
ORDER BY e.hp DESC;

--12. Sacar el pokemon (nombre, ataque) con más ataque de cada generacion.

SELECT e.nombre, e.ataque, e.generacion
FROM especie_pokemon e
WHERE ataque = (SELECT MAX(ataque)
				FROM especie_pokemon
				WHERE generacion = e.generacion);
				
SELECT generacion, MAX(ataque)
FROM especie_pokemon
GROUP BY generacion;				


SELECT e.nombre, e.ataque, e.generacion
FROM especie_pokemon e,
	(SELECT generacion, MAX(ataque) as ataque
	FROM especie_pokemon
	GROUP BY generacion) maximos
WHERE e.generacion = maximos.generacion
AND e.ataque = maximos.ataque;
				
--13. Sacar el nombre y los dos tipos de los pokemon con 150 de velocidad o más.

SELECT e.nombre, t1.nombre, t2.nombre
INNER JOIN tipo t1
	ON(e.tipo1 = t1.id_tipo)
LEFT OUTER JOIN  tipo t2
	ON (e.tipo2 = t2.id_tipo)
AND e.velocidad >=150;


--14. Sacar los nombre de todos los pokemon junto con el nombre de su especie pokemon.

SELECT p.nombre, e.nombre
FROM pokemon p, especie_pokemon e
where p.id_pokedex= e.id_pokedex;



--15. Sacar un informe con las distintas especies que hay en la tabla pokemon con el mensaje:
--"¡Un <especie> salvaje apareció!".

SELECT 'Un ' ||e.nombre|| ' salvaje apareció'
FROM pokemon p, especie_pokemon e
WHERE p-id_pokedex= e.id_pokedex;






--16. Sacar los nombres de los pokemon que han evolucionado de otro pokemon.
--17. Sacar los nombres de los pokemon que pueden evolucionar.
--18. Sacar los nombres de todos los pokemon que sean de tipo electrico.
--19. Sacar el número de pokemon de cada especie con su número de pokedex.
--20. Sacar el número de pokemon de cada especie con el nombre de la especie.
--21. Mostrar todos los pokemon que son de fuego.
--22. Mostrar los nombres de los pokemon que tienen vida entre 25 y 105.
--23. Mostrar los nombres de los pokemon que son de la tercera generación.
--24. Mostrar todos los pokemon capturados de la especie Bulbasaur.
--25. Mostrar los pokemon que tengan un ataque rápido mayor que 75 y defensa mayor de 182.
--26. Mostrar las especies de pokemon (identificador y nombre) que sean legendarios.
--27. Mostrar las especies de pokemon (identificador y nombre) que sean roca o psíquico.
--28. Mostrar los nombres de los pokemon capturados que sean de tipo planta.
--29. Mostrar los ataques que contengan la frase ‘ta’.
--30. Mostrar los ataques (identificador y nombre) que hagan un daño superior a 53.
--31. Mostrar las especies de pokemon que aún no han sido capturadas.
--32. Mostrar los ataques que pertenecen a los pokemon de tipo agua.
--33. Mostrar cuantos pokemon de cada especie han sido cazados.
--34. Mostrar cuantos pokemon por generación existen.
--35. Mostrar el primer y último pokemon que han sido capturados.
--36. Mostrar aquellos pokemon capturados que no tienen tipo2.
--37. Contar las especies pokemon cuyo nombre comienza por ‘Ni’.
--38. Mostrar la vida de los pokemon cazados.
--39. Obtener el nombre de tipo de pokemon que sea el tipo1 más frecuente.
--40. Obtener el número de especies pokémon de cada combinación de tipo (es decir, el número
--de pokemon normal y siniestro, lucha y eléctrico, etc), incluyendo los que solamente tienen
--tipo principal, ordenado alfabéticamente por el primer tipo y después por el segundo.
--41. Obtener una lista de todas las especies pokémon que evolucionan de otro, de la siguiente
--forma:
--flareon evoluciona de eevee
--mr. mime evoluciona de mime jr.
--snorlax evoluciona de munchlax
--etc.
--42. Mostrar todos los pokemon capturados que, siendo no legendarios, pertenecen a una especie
--que no evoluciona de ninguna otra.
--43. Mostrar todos los pokemon capturados que pertenecen a una especie que no evoluciona a
--ninguna otra.
--44. Mostrar los nombres de especie y los nombres de los ataques rápidos de todos los pokemon
--capturados que tienen un ataque rápido de tipo normal.
--45. Mostrar los distintos nombres e ids de las especies pokemon capturadas, ordenadas por id de
--la pokedex.
--46. Mostrar la media de ataque, defensa y hp (hit points) cada tipo de pokemon, indicando el
--nombre de sus tipos, y ordenado por la media de ataque, de mayor a menor.
--47. Mostrar el nombre, el nombre de la especie y el valor de hp (hit points) de los pokemon
--capturados con el mayor valor de hp.
--48. Mostrar los nombres y los nombres de los ataques de los pikachus capturados.
--49. Mostrar el nombre y el nombre de la especie de los pokemon capturados que tienen un
--ataque cargado que en realidad está catalogado como ataque rápido.
--50. Para todas las combinaciones de tipos de los que solamente hay una especie de pokemon,
--obtener su nombre y los nombres de sus tipos.
--51. Si el pokémon Revenant ataca a Loki con su ataque cargado, ¿cuál es el multiplicador de su
--ataque? (podemos asumir que conocemos que tanto Revenant como Loki son pokemon que
--no tienen tipo secundario).
--52. Obtener las especies de pokémon más vulnerables contra el ataque "Puya Nociva"