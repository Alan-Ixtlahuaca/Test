:- encoding(utf8).
:- dynamic si/1.
:- dynamic no/1.

% --- BASE DE CONOCIMIENTO: ENFERMEDADES Y SINTOMAS ---
enfermedad(depresion, [tristeza, perdida_interes, sin_esperanza]).
enfermedad(ansiedad, [nerviosismo, preocupacion, tension_muscular]).
enfermedad(panico, [miedo_intenso, falta_respiracion, taquicardia]).
enfermedad(trastorno_sueno, [insomnio, despertar_frecuente, cansancio_diurno]).
enfermedad(esquizofrenia, [alucinaciones, delirios, pensamiento_desorganizado]).
enfermedad(trastorno_bipolar, [cambios_humor_extremos, mania_euforia, impulsividad]).
enfermedad(trastorno_obsesivo_compulsivo, [pensamientos_intrusivos, compulsiones_repetitivas, necesidad_orden]).
enfermedad(estres_postraumatico, [flashbacks, pesadillas, hipervigilancia]).
enfermedad(trastorno_alimentacion, [distorsion_imagen_corporal, restriccion_alimentaria, atracones]).

% --- REGLAS ---
% Diagnostica un trastorno si un síntoma afirmativo ("si") está en la lista de síntomas de esa enfermedad
tiene_trastorno(Trastorno) :-
    enfermedad(Trastorno, ListaSintomas),
    si(Sintoma),
    member(Sintoma, ListaSintomas).





:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_cors)).

:- set_setting(http:cors, [*]).

server(Port) :-
    http_server(http_dispatch, [port(Port)]),
    format('Servidor activo en puerto ~w~n', [Port]).

% SOLO UNA VEZ
:- http_handler('/diagnostico', diagnostico_handler, [methods([post, options])]).

diagnostico_handler(Request) :-
    option(method(options), Request), !,
    cors_enable(Request, [methods([post])]),
    format('Content-type: text/plain~n~n').

diagnostico_handler(Request) :-
    cors_enable(Request, [methods([post]), origin('*')]),

    catch(
        ( http_read_json_dict(Request, Data),
          Sintomas = Data.sintomas,

          retractall(si(_)),
          cargar_sintomas(Sintomas),

          ( mejor_diagnostico(Resultado)
          -> true
          ;  Resultado = 'Sin diagnóstico disponible'
          ),

          reply_json_dict(_{diagnostico: Resultado})
        ),
        Error,
        reply_json_dict(_{error: Error})
    ).

cargar_sintomas([]).
cargar_sintomas([H|T]) :-
    atom_string(AtomH, H),
    assertz(si(AtomH)),
    cargar_sintomas(T).

tiene(S) :- si(S).

score(E, Score) :-
    enfermedad(E, Lista),
    findall(S, (member(S, Lista), tiene(S)), Coinc),
    length(Coinc, Score).

mejor_diagnostico(Mejor) :-
    findall(S-E, score(E, S), Lista),
    Lista \= [],
    sort(0, @>=, Lista, [MaxScore-Mejor|_]),
    MaxScore > 0.