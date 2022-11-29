
--1. Sacar la media de ataque, defensa y hp de todos los pokemon de la familia de Registax (todos empiezan por 'Regi').

select avg(ataque), avg(defensa), avg(hp)
from especie_pokemon e
where lower(e.nombre) like 'regi%';

--2. Sacar los nombres y vida de los pokemon legendarios cuyo ataque sea mayor o igual que el ataque de Pinsir
select e.nombre, e.hp
from especie_pokemon e
where legendario = 1
	and e.ataque >= (select ataque from especie_pokemon where lower(nombre) = 'pinsir');

--3. Sacar el nombre y el ataque del pokemon no legendario que tiene el ataque más alto
select nombre, ataque
from especie_pokemon
where ataque = (select max(ataque) from especie_pokemon where legendario = 0)
	and legendario = 0;
	
--4. Sacar el número de ataques de cada tipo, junto con el nombre del tipo de ataque

select t.nombre, count(*)
from ataque a, tipo t
where (t.id_tipo = a.id_tipo)
group by t.nombre;

select t.nombre, count(*)
from ataque a,
	natural join tipo t
group by t.nombre;

--5. Sacar el nombre y tipo de los pokemon que son uno evolución de otro
select e1.nombre as basico, e2.nombre as evolucion
from especie_pokemon e1, especie_pokemon e2
where (e2.evoluciona_de = e1.id_pokedex);

--6. Sacar el nombre de los pokemon que pueden evolucionar en más de un pokemon
select e.nombre
from especie_pokemon e
where (select count(*) from especie_pokemon where evoluciona_de = e.id_pokedex)>1;

--7. Sacar el nombre, ataque y defensa de todas las evoluciones de eevee, ordenadas por ataque de mayor a menor y después por orden alfabético
select nombre, ataque
from especie_pokemon 
where evoluciona_de = (select id_pokedex from especie_pokemon where lower(nombre) = 'eevee')
order by ataque desc, nombre;

select e2.nombre, e2.ataque
from especie_pokemon e1, especie_pokemon e2
where e1.id_pokedex = e2.evoluciona_de and
	lower(e1.nombre) = 'eevee'
order by ataque desc, nombre;

select e2.nombre, e2.ataque
from especie_pokemon e1
	join especie_pokemon e2
	on (e1.id_pokedex = e2.evoluciona_de)
where lower(e1.nombre) = 'eevee'
order by ataque desc, nombre;

--8. Sacar el nombre de los pokemon que son del mismo tipo que el ataque "contraataque"
-- (con subconsulta, con producto cartesiano y con join)

select e.nombre
from especie_pokemon e
where e.tipo1 = (select id_tipo from ataque where lower(nombre) = 'contraataque') or
	e.tipo2 = (select id_tipo from ataque where lower(nombre) = 'contraataque');

select e.nombre
from especie_pokemon e, ataque a
where (e.tipo1 = a.id_tipo or
	e.tipo2 = a.id_tipo) and
	lower(a.nombre) = 'contraataque';
	
select e.nombre
from especie_pokemon e
	left outer join ataque a
	on (e.tipo1 = a.id_tipo or e.tipo2 = a.id_tipo)
where lower(a.nombre) = 'contraataque';


--9. Sacar el nombre y el nombre del tipo principal de los pokemon de la 3ª generación
-- (con producto cartesiano y con join)

select e.nombre, t.nombre
from especie_pokemon e, tipo t
where 
	e.tipo1 = t.id_tipo
	and e.generacion = 3;

select e.nombre, t.nombre
from especie_pokemon e
	join tipo t
	on e.tipo1 = t.id_tipo
where e.generacion = 3;

--10. Sacar el número de pokemon de tipo fuego
-- (con subconsulta, con producto cartesiano y con join)
select count(*)
from especie_pokemon e
where e.tipo1 = (select id_tipo from tipo where lower(nombre) = 'fuego')
	or e.tipo2 = (select id_tipo from tipo where lower(nombre) = 'fuego');


select count(*)
from especie_pokemon e, tipo t
where (e.tipo1=t.id_tipo or e.tipo2=t.id_tipo)
	and lower(t.nombre)='fuego';

select count(*)
from especie_pokemon e
	join tipo t
	on (e.tipo1=t.id_tipo or e.tipo2=t.id_tipo)
where lower(t.nombre)='fuego';	


--11. Sacar el nombre y la vida de los pokemon de tipo agua, ordenados por vida de mayor a menor
-- (con subconsulta, con producto cartesiano y con join)

select e.nombre, e.hp
from especie_pokemon e
where e.tipo1 = (select id_tipo from tipo where lower(nombre) = 'agua')
	or e.tipo2 = (select id_tipo from tipo where lower(nombre) = 'agua')
order by e.hp desc;

select e.nombre, e.hp
from especie_pokemon e, tipo t
where 
	(e.tipo1 = t.id_tipo or e.tipo2=t.id_tipo)
	and	lower(t.nombre) = 'agua'
order by e.hp desc;


select e.nombre, e.hp
from especie_pokemon e
	join tipo t
	on (e.tipo1 = t.id_tipo or e.tipo2=t.id_tipo)
where lower(t.nombre) = 'agua' 
order by e.hp desc;


--12. Sacar el pokemon (nombre, ataque) con más ataque de cada generacion

select e.nombre, e.ataque, e.generacion
from especie_pokemon e
where e.ataque = (
	select max(ataque)
	from especie_pokemon
	group by generacion
	having generacion = e.generacion
	);
	
--13. Sacar el nombre y los dos tipos de los pokemon con 150 de velocidad o más
-- (con join)

select e.nombre, t1.nombre, t2.nombre
from especie_pokemon e
	inner join tipo t1
	on e.tipo1 = t1.id_tipo
	left outer join tipo t2
	on e.tipo2 = t2.id_tipo
where e.velocidad>=150;	

--14. Sacar los nombre de todos los pokemon junto con el nombre de su especie pokemon
select p.nombre, e.nombre
from pokemon p, especie_pokemon e
where p.id_pokedex = e.id_pokedex;


--15. Sacar un informe con las distintas especies que hay en la tabla pokemon con el mensaje: "¡Un <especie> salvaje apareció!"

select distinct "¡Un "||e.nombre||" salvaje apareció!"
from especie_pokemon e
where (select count(*) from pokemon where id_pokedex = e.id_pokedex)>0;

select distinct "¡Un "||e.nombre||" salvaje apareció!"
from pokemon p, especie_pokemon e
where p.id_pokedex = e.id_pokedex;

select distinct "¡Un "||e.nombre||" salvaje apareció!"
from pokemon p
	inner join especie_pokemon e
	on p.id_pokedex = e.id_pokedex
;

--16. Sacar los nombres de los pokemon que han evolucionado de otro pokemon
select p.nombre
from pokemon p
where (select evoluciona_de from especie_pokemon where id_pokedex=p.id_pokedex) is not null;

--17. Sacar los nombres de los pokemon que pueden evolucionar
select p.nombre
from pokemon p
where id_pokedex in (select evoluciona_de from especie_pokemon);


--18. Sacar los nombres de todos los pokemon que sean de tipo electrico

select p.nombre
from pokemon p
where (select tipo1 from especie_pokemon where id_pokedex = p.id_pokedex) = (select id_tipo from tipo where lower(nombre) = 'electrico') or
	  (select tipo2 from especie_pokemon where id_pokedex = p.id_pokedex) = (select id_tipo from tipo where lower(nombre) = 'electrico');

select p.nombre
from pokemon p, especie_pokemon e, tipo t
where p.id_pokedex = e.id_pokedex and
	(e.tipo1 = t.id_tipo or e.tipo2=t.id_tipo) and
	lower(t.nombre) = 'electrico';
	
select p.nombre
from pokemon p
	inner join especie_pokemon e
	on p.id_pokedex = e.id_pokedex
	inner join tipo t
	on (e.tipo1 = t.id_tipo or e.tipo2 = t.id_tipo)
where lower(t.nombre) = 'fuego';

--19. Sacar el número de pokemon de cada especie con su número de pokedex

select id_pokedex, count(*) 
from pokemon
group by id_pokedex;
	
--20. Sacar el número de pokemon de cada especie con el nombre de la especie

select e.nombre, count(*)
from pokemon p, especie_pokemon e
where p.id_pokedex = e.id_pokedex
group by e.nombre;

select e.nombre, count(*)
from pokemon p
	inner join especie_pokemon e
	on p.id_pokedex = e.id_pokedex
group by e.nombre;


-- 21. Mostrar todos los pokemon que son de fuego

select ep.nombre
from especie_pokemon ep
join tipo t1
on ep.tipo1 = t1.id_tipo
left join tipo t2
on ep.tipo2 = t2.id_tipo
where lower(t1.nombre) = 'fuego'
	or lower(t2.nombre) = 'fuego';
	
-- 22. Mostrar los nombres de los pokemon que tienen vida entre 25 y 105

select ep.nombre
from especie_pokemon ep
where ep.hp between 25 and 105;


-- 23. Mostrar los nombres de los pokemon que son de la tercera generación

select nombre
from especie_pokemon
where generacion = 3;


-- 24. Mostrar todos los pokemon capturados de la especie Bulbasaur

select p.nombre
from pokemon p
join especie_pokemon ep
on (p.id_pokedex = ep.id_pokedex)
where lower (ep.nombre)='bulbasaur';

-- 25. Mostrar los pokemon que tengan un ataque rápido mayor que 75 y defensa mayor de 182

select nombre 
from especie_pokemon ep
where ataque > 75
	and defensa > 182;
	
-- 26. Mostrar las especies de pokemon (identificador y nombre) que sean legendarios

select id_pokedex, nombre
from especie_pokemon
where legendario = 1;

-- 27. Mostrar las especies de pokemon (identificador y nombre) que sean roca o psíquico

select ep.id_pokedex, ep.nombre
from especie_pokemon ep
join tipo t1
on ep.tipo1 = t1.id_tipo
left join tipo t2
on ep.tipo2 = t2.id_tipo
where lower(t1.nombre) = 'roca'
	or lower(t1.nombre) = 'psiquico'
	or lower(t2.nombre) = 'roca'
	or lower(t2.nombre) = 'psiquico';


-- 28. Mostrar los nombres de los pokemon capturados que sean de tipo planta

select p.nombre
from pokemon p
join especie_pokemon ep
on p.id_pokedex=ep.id_pokedex
join tipo t1
on ep.tipo1 = t1.id_tipo
left join tipo t2
on ep.tipo2 = t2.id_tipo
where lower(t1.nombre) = 'planta'
	or lower(t2.nombre) = 'planta';

-- 29. Mostrar los ataques que contengan la frase 'ta'

select nombre
from ataque
where lower(nombre) like '%ta%';


-- 30. Mostrar los ataques (identificador y nombre) que hagan un daño superior a 53

select id_ataque, nombre
from ataque
where danho > 53;

-- 31. Mostrar las especies de pokemon que aún no han sido capturadas

select ep.nombre
from especie_pokemon ep
where not exists (select null from pokemon where id_pokedex = ep.id_pokedex);


-- 32. Mostrar los ataques que pertenecen a los pokemon de tipo agua

select a1.nombre, a2.nombre
from pokemon p
join ataque a1
on a1.id_ataque = p.ataque_rapido
join ataque a2
on a2.id_ataque = p.ataque_cargado
join especie_pokemon ep
on p.id_pokedex = ep.id_pokedex
join tipo t1
on ep.tipo1 = t1.id_tipo
left join tipo t2
on ep.tipo2 = t2.id_tipo
where lower(t1.nombre) = 'agua'
	or lower(t2.nombre) = 'agua';


-- 33. Mostrar cuántos pokemon de cada especie han sido cazados

select ep.nombre, count(*)
from pokemon p
join especie_pokemon ep
on ep.id_pokedex = p.id_pokedex
group by ep.nombre;


-- 34. Mostrar cuántos pokemon por generación existen

select generacion, count(*)
from especie_pokemon
group by generacion
order by generacion asc;


-- 35. Mostrar el primer y últimpo pokemon que han sido capturados

select nombre, to_char(fecha_captura, 'DD/MM/YYYY') as fecha_captura
from pokemon
where fecha_captura = (select min(fecha_captura)
						from pokemon)
	  or fecha_captura = (select max(fecha_captura)
						from pokemon);

-- 36. Mostrar aquellos pokemon que no tienen tipo 2.

select p.nombre
from pokemon p
join especie_pokemon ep
on p.id_pokedex=ep.id_pokedex
where ep.tipo2 is null;

-- 37. Contar las especies pokemon cuyo nombre comienza por 'Ni'

select count(*)
from especie_pokemon
where lower(nombre) like 'ni%';


-- 38. Mostrar la vida de los pokemon cazados

select p.nombre, ep.hp
from pokemon p
join especie_pokemon ep
on p.id_pokedex=ep.id_pokedex;


--39. Obtener el nombre de tipo de pokémon que sea el tipo principal de más especies.

select t.nombre, count(*)
from tipo t ,especie_pokemon e
where t.id_tipo = e.tipo1
group by t.nombre
having count(*) = (select max(count(*))
					from tipo t ,especie_pokemon e
					where t.id_tipo = e.tipo1
					group by t.nombre)
;

--40. Obtener el número de especies pokémon de cada combinación de tipo (es decir, el número de pokemon normal y siniestro, lucha y eléctrico, etc), incluyendo los que solamente tienen tipo principal, ordenado alfabéticamente por el primer tipo y después por el segundo

select t1.nombre, t2.nombre, count(*)
from especie_pokemon e
join tipo t1
on (t1.id_tipo = e.tipo1)
left join tipo t2
on (t2.id_tipo = e.tipo2)
group by t1.nombre,t2.nombre
order by t1.nombre, t2.nombre;


-- 41. Obtener una lista de todas las especies pokémon que evolucionan de otro, de la siguiente forma:
--			flareon evoluciona de eevee
--			mr. mime evoluciona de mime jr.
--			snorlax evoluciona de munchlax
--			etc.


select e2.nombre||' evoluciona de '||e1.nombre
from especie_pokemon e1
join especie_pokemon e2
on (e2.evoluciona_de = e1.id_pokedex);



-- 42. Mostrar todos los pokemon de la tabla pokemon que, siendo no legendarios, pertenecen a una especie que no evoluciona de ninguna otra.

select p.nombre, e.nombre
from pokemon p
join especie_pokemon e
on (p.id_pokedex = e.id_pokedex)
where e.evoluciona_de is null
	and e.legendario = 0;


-- 43. Mostrar todos los pokemon de la tabla pokemon que pertenecen a una especie que no evoluciona a ninguna otra.

select p.nombre, e.nombre
from pokemon p
join especie_pokemon e
on (p.id_pokedex = e.id_pokedex)
where (select count(*)
		from especie_pokemon e2
		where e2.evoluciona_de = e.id_pokedex)=0;


-- 44. Mostrar los nombres y los nombres de los ataques rápidos de todos los pokemon de la tabla pokemon que tienen un ataque rápido de tipo normal

select p.nombre, a.nombre
from pokemon p
join especie_pokemon e
on (p.id_pokedex = e.id_pokedex)
join ataque a
on (a.id_ataque = p.ataque_rapido)
join tipo t
on (a.id_tipo = t.id_tipo)
where lower(t.nombre) = 'normal';


--45. Mostrar los nombres e ids de las especies pokemon representadas en los datos de la tabla pokemon, ordenadas por id de la pokedex.

select distinct p.id_pokedex, e.nombre
from especie_pokemon e
join pokemon p
on (p.id_pokedex = e.id_pokedex)
order by p.id_pokedex;


--46. Mostrar la media de ataque, defensa y hit points cada tipo de pokemon, indicando el nombre de sus tipos, y ordenado por la media de ataque, de mayor a menor.

select t1.nombre, t2.nombre, avg(e.ataque), avg(e.defensa), avg(e.hp)
from especie_pokemon e
join tipo t1
on (e.tipo1=t1.id_tipo)
left join tipo t2
on (e.tipo2=t2.id_tipo)
group by t1.nombre, t2.nombre
order by avg(e.ataque) desc;



--47. Mostrar el nombre, el nombre de la especie y el valor de hp (hit points) de los pokémon de la tabla pokemon con el mayor valor de hp
select p.nombre, e.hp, e.nombre
from pokemon p
join especie_pokemon e
on (e.id_pokedex = p.id_pokedex)
where e.hp = (select max(hp) 
				from especie_pokemon
				where (id_pokedex in (select id_pokedex 
									  from pokemon)));


--48. Mostrar los nombres y los nombres de los ataques de los pokemon de la tabla pokemon que son pikachus.

select p.nombre, a1.nombre, a2.nombre
from pokemon p
join especie_pokemon e
on (e.id_pokedex = p.id_pokedex)
join ataque a1
on (a1.id_ataque = p.ataque_rapido)
join ataque a2
on (a2.id_ataque = p.ataque_cargado)
where lower(e.nombre)='pikachu';


--49. Mostrar el nombre y el nombre de la especie de los pokemon que tienen un ataque cargado que en realidad está catalogado como ataque rápido

select p.nombre, e.nombre
from pokemon p
join especie_pokemon e
on (p.id_pokedex=e.id_pokedex)
join ataque a
on (p.ataque_cargado = a.id_ataque)
where a.rapido = 1;


--50. Para todas las combinaciones de tipos de los que solamente hay una especie de pokémon, obtener su nombre y los nombres de sus tipos


select e.nombre, t1.nombre, t2.nombre
from especie_pokemon e
join tipo t1
on (t1.id_tipo = e.tipo1)
left join tipo t2
on (t2.id_tipo = e.tipo2)
where (tipo1, tipo2) in (select e2.tipo1,e2.tipo2
							from especie_pokemon e2
							group by e2.tipo1, e2.tipo2
							having count(*)=1)
order by tipo1,tipo2;


	
						

--51. Si el pokémon Revenant ataca a Loki con su ataque cargado, ¿cuál es el multiplicador de su ataque? (podemos asumir que conocemos que tanto Revenant como Loki son pokemon que no tienen tipo secundario)

select m1.valor
from pokemon p1
join pokemon p2
on (lower(p2.nombre) = 'loki')
join especie_pokemon e
on (e.id_pokedex = p2.id_pokedex)
join ataque a
on (a.id_ataque=p1.ataque_cargado)
join multiplicador m1
on (m1.id_tipo_ataque = a.id_tipo 
	and m1.id_tipo_defensa = e.tipo1)
where lower(p1.nombre) = 'revenant';


--52. Obtener las especies de pokémon más vulnerables contra el ataque "Puya Nociva"

select e.nombre
from especie_pokemon e
join ataque a
on (lower(a.nombre)='puya nociva')
join multiplicador m1
on (e.tipo1 = m1.id_tipo_defensa
	and m1.id_tipo_ataque = a.id_tipo)
left join multiplicador m2
on (e.tipo2 = m2.id_tipo_defensa
    and m2.id_tipo_ataque = a.id_tipo)
where m1.valor*nvl(m2.valor,1) = (
	select max(m12.valor*nvl(m22.valor,1))
	from especie_pokemon e2
	join ataque a2
	on (lower(a2.nombre)='puya nociva')
	join multiplicador m12
	on (e2.tipo1 = m12.id_tipo_defensa
		and m12.id_tipo_ataque = a2.id_tipo)
	left join multiplicador m22
	on (e2.tipo2 = m22.id_tipo_defensa
		and m22.id_tipo_ataque = a2.id_tipo));




























