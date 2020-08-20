/*Gabriel cree en Campanita, el Mago de Oz y Cavenaghi
Juan cree en el Conejo de Pascua
Macarena cree en los Reyes Magos, el Mago Capria y Campanita
Diego no cree en nadie

Conocemos tres tipos de sueño
ser un cantante y vender una cierta cantidad de “discos” (≅ bajadas)
ser un futbolista y jugar en algún equipo
ganar la lotería apostando una serie de números

Queremos reflejar entonces que
Gabriel quiere ganar la lotería apostando al 5 y al 9, y también quiere ser un futbolista de Arsenal
Juan quiere ser un cantante que venda 100.000 “discos”
Macarena no quiere ganar la lotería, sí ser cantante estilo “Eruca Sativa” y vender 10.000 discos
Generar la base de conocimientos inicial
Indicar qué conceptos entraron en juego para cada punto.
Utilizamos el principio de universo cerrado para diego que no cree en nadie, ya que el predicado existe pero al no encontrar a diego dará false
también en macarena que no quiere ganar la loteria
utilizamos functores para modelar los sueños ya que aunque todos son sueños, tienen información distinta y  es una buena forma de tratar a todos los sueños por igual si lo llegasemos a necesitar

*/
creeEn(gabriel, campanita).
creeEn(gabriel, magoDeOz).
creeEn(gabriel, cavenaghi).
creeEn(juan, conejoDePascua).
creeEn(macarena, reyesMagos).
creeEn(macarena, magoCapria).
creeEn(macarena, campanita).

%sueño(Persona, Sueño).
suenio(gabriel, ganarLoteria([5, 9])).
suenio(gabriel, serFutbolista(arsenal)).
suenio(juan, serCantante(100000)). 
suenio(macarena, serCantante(10000)).
%suenio(macarena, serFutbolista(arsenal)). %lo agregamos para probar
%suenio(macarena, ganarLoteria([5, 9])).


/*Queremos saber si una persona es ambiciosa, esto ocurre cuando la suma de dificultades de los 
sueños es mayor a 20. La dificultad de cada sueño se calcula como
6 para ser un cantante que vende más de 500.000 ó 4 en caso contrario
ganar la lotería implica una dificultad de 10 * la cantidad de los números apostados
lograr ser un futbolista tiene una dificultad de 3 en equipo chico o 16 en caso contrario. Arsenal y 
Aldosivi son equipos chicos.
Puede agregar los predicados que sean necesarios. El predicado debe ser inversible para todos sus argumentos. 
*/

personaAmbiciosa(Persona):-
    sumaDificultades(Persona, Suma),
    Suma > 20.

sumaDificultades(Persona, Suma):-
    suenio(Persona, _), % lo agregamos para que fuera inversible para Persona
    findall(Dificultad, dificultadSuenio(Persona, Dificultad), ListaDificultades),
    sum_list(ListaDificultades, Suma).

dificultadSuenio(Persona, Dificultad):-
    suenio(Persona, Suenio),
    dificultadSegunSuenio(Suenio, Dificultad).

dificultadSegunSuenio(serCantante(Discos), 6):-
    between(0, Discos, 500000).
    %Discos > 500000.

dificultadSegunSuenio(serCantante(Discos), 4):-
    between(0, 500000, Discos). % lo hacemos así por la inversibilidad 

%otra opcion Discos =< 500000.
dificultadSegunSuenio(ganarLoteria(NumerosApostados), Dificultad):-
    length(NumerosApostados, CantidadNumeros),
    Dificultad is 10* CantidadNumeros.

/*lograr ser un futbolista tiene una dificultad de 3 en equipo chico o 16 en caso contrario. Arsenal y 
Aldosivi son equipos chicos.*/

dificultadSegunSuenio(serFutbolista(Equipo), 3):-
    equipoChico(Equipo).

dificultadSegunSuenio(serFutbolista(Equipo), 16):-
    not(equipoChico(Equipo)).

equipoChico(arsenal).
equipoChico(aldosivi).

/*Queremos saber si un personaje tiene química con una persona. Esto se da
si la persona cree en el personaje y...
para Campanita, la persona debe tener al menos un sueño de dificultad menor a 5.
para el resto, 
todos los sueños deben ser puros (ser futbolista o cantante de menos de 200.000 discos)
y la persona no debe ser ambiciosa
*/

tieneQuimica(Persona, OtraPersona):-
    creeEn(Persona, OtraPersona),
    cumpleCondicion(Persona, OtraPersona).

cumpleCondicion(Persona, campanita):-
    dificultadSuenio(Persona, Dificultad),
    Dificultad < 5.

cumpleCondicion(Persona, OtraPersona):-
    suenio(Persona, _),
    creeEn(_, OtraPersona), %los agregamos para que pueda ligar valores a Persona y a OtraPersona y ser totalmente inversible
    forall(suenio(Persona, Suenio), esSuenioPuro(Suenio)),
    not(personaAmbiciosa(Persona)),
    OtraPersona \= campanita.

esSuenioPuro(serFutbolista(_)).
esSuenioPuro(serCantante(Discos)):-
    Discos < 200000.

/*Punto 4
Sabemos que
Campanita es amiga de los Reyes Magos y del Conejo de Pascua
el Conejo de Pascua es amigo de Cavenaghi, entre otras amistades

Necesitamos definir si un personaje puede alegrar a una persona, esto ocurre
si una persona tiene algún sueño
el personaje tiene química con la persona y...
el personaje no está enfermo
o algún personaje de backup no está enfermo. Un personaje de backup es un amigo directo o indirecto del 
personaje principal
*/

amigos(campanita, reyesMagos).
amigos(campanita, conejoDePascua).
amigos(conejoDePascua, cavenaghi).

enfermo(campanita).
enfermo(reyesMagos).
enfermo(conejoDePascua).
%Campanita, los Reyes Magos y el Conejo de Pascua están enfermos

/*
conoce(megurineLuka, hatsuneMiku).
conoce(megurineLuka, gumi).
conoce(gumi, seeU).
conoce(seeU, kaito).



conocido(Vocaloid, ConocidoDirecto):- 
    conoce(Vocaloid, ConocidoDirecto).
    
conocido(Vocaloid, ConocidoIndirecto):-
    conoce(Vocaloid, Conocido),
    conocido(Conocido, ConocidoIndirecto).*/

sonAmigos(Personaje, OtraPersona):-
    amigos(Personaje, OtraPersona).
    
sonAmigos(Personaje, AmigoIndirecto):-
    amigos(Personaje, Amigo),
    amigos(Amigo, AmigoIndirecto).

puedeAlegrar(Personaje, OtraPersona):-
    suenio(OtraPersona, _),
    tieneQuimica(OtraPersona, Personaje),
    hayAlgunSano(Personaje).

hayAlgunSano(Personaje):-
    not(enfermo(Personaje)).

hayAlgunSano(Personaje):-
    sonAmigos(Personaje, Amigo),
    not(enfermo(Amigo)).







    



    
    