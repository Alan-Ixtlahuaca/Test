% diagnostico_mental.pl
% Para ejecutar el sistema, abre SWI-Prolog y escribe:
% ?- consult('diagnostico_mental.pl').
% ?- diagnostico.

% --- INICIO DEL SISTEMA EXPERTO ---
diagnostico :-
    write('--- Sistema Experto de Diagnostico Mental Simplificado ---'), nl,
    write('Responde a las preguntas con "s." (si) o "n." (no) incluyendo el punto final.'), nl, nl,
    hipotesis(Trastorno),
    write('El diagnostico probable es: '), write(Trastorno), nl,
    limpiar.

diagnostico :-
    write('No tengo suficiente informacion para determinar un diagnostico claro.'), nl,
    limpiar.

% --- HIPOTESIS DE DIAGNOSTICO ---
hipotesis('Depresion mayor') :- depresion, !.
hipotesis('Ansiedad generalizada') :- ansiedad, !.
hipotesis('Trastorno de panico') :- panico, !.
hipotesis('Insomnio') :- insomnio, !.
hipotesis('TOC (Trastorno Obsesivo Compulsivo)') :- toc, !.
hipotesis('Trastorno Bipolar') :- bipolaridad, !.
hipotesis('Estres postraumatico (TEPT)') :- trauma, !.

% --- REGLAS / BASE DE CONOCIMIENTOS ---
% Cada regla hace las preguntas necesarias. Si todas se cumplen (s.), es verdadero.
depresion :-
    pregunta('te sientes triste casi todos los dias'),
    pregunta('has perdido interes en actividades que disfrutabas'),
    pregunta('te sientes sin esperanza').

ansiedad :-
    pregunta('te preocupas demasiado por cosas pequenas'),
    pregunta('sientes nerviosismo constante').

panico :-
    pregunta('has sentido miedo intenso repentino'),
    pregunta('has sentido que no puedes respirar').

insomnio :-
    pregunta('tienes dificultad para dormir'),
    pregunta('te despiertas muchas veces en la noche').

toc :-
    pregunta('tienes pensamientos repetitivos que no controlas'),
    pregunta('repites acciones muchas veces (lavar, revisar, contar)').

bipolaridad :-
    pregunta('has tenido periodos de mucha energia excesiva'),
    pregunta('hablas demasiado rapido en ocasiones'),
    pregunta('luego caes en tristeza profunda').

trauma :-
    pregunta('viviste un evento traumatico'),
    pregunta('tienes recuerdos repetitivos de eso').

% --- MOTOR DE INFERENCIA Y MANEJO DE PREGUNTAS ---
% Declaramos hechos dinamicos para almacenar lo que el usuario responde en memoria
:- dynamic si/1, no/1.

% Verifica si ya preguntamos esto antes, para no repetir
pregunta(S) :-
    ( si(S) -> true ;
      ( no(S) -> fail ;
        preguntar_usuario(S)
      )
    ).

% Hace la pregunta en pantalla y guarda la respuesta
preguntar_usuario(S) :-
    write('¿'), write(S), write('? (s/n): '),
    read(Respuesta),
    ( Respuesta == s -> assert(si(S)) ;
      assert(no(S)), fail
    ).

% Limpiar las respuestas de la memoria al terminar
limpiar :- retractall(si(_)), retractall(no(_)).
