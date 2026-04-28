:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_cors)).

% Configuración para permitir peticiones desde cualquier origen (CORS)
% Esto es necesario porque el HTML se abrirá como archivo local (file://)
:- set_setting(http:cors, [*]).

% 1. Arrancar el servidor web
iniciar_servidor :-
    http_server(http_dispatch, [port(8000)]),
    nl,
    write('======================================================='), nl,
    write(' Servidor Prolog API Iniciado con exito.               '), nl,
    write(' Escuchando en el puerto 8000...                       '), nl,
    write('                                                       '), nl,
    write(' Ya puedes abrir el archivo index.html en tu navegador.'), nl,
    write('======================================================='), nl, nl.

% 2. Crear las rutas (endpoints)
% Permitimos POST (para enviar datos) y OPTIONS (requerido por navegadores para CORS)
:- http_handler('/api/diagnosticar', diagnosticar_api, [method(post), method(options)]).

% 3. Manejar peticiones de pre-vuelo (CORS OPTIONS)
diagnosticar_api(Request) :-
    option(method(options), Request), !,
    cors_enable(Request, [methods([get,post,options])]),
    format('~n').

% 4. Manejar la petición principal POST
diagnosticar_api(Request) :-
    cors_enable(Request, [methods([get,post,options])]),
    % Leer el JSON enviado desde JavaScript
    http_read_json_dict(Request, Datos),
    Sintomas = Datos.sintomas, 
    
    limpiar,
    registrar_sintomas(Sintomas),
    
    % Evaluar hipótesis
    ( hipotesis(Trastorno) -> 
        Resultado = Trastorno 
    ; 
        Resultado = 'No concluyente. Por favor, consulta a un especialista.'
    ),
    
    % Responder con JSON
    reply_json(_{diagnostico: Resultado}).

% --- MEMORIA Y REGISTRO ---
:- dynamic si/1.
limpiar :- retractall(si(_)).

registrar_sintomas([]).
registrar_sintomas([S|Resto]) :-
    assert(si(S)),
    registrar_sintomas(Resto).

% --- BASE DE CONOCIMIENTOS (REGLAS SIN PREGUNTAR) ---
% Orden de evaluación
hipotesis('Depresión mayor') :- depresion, !.
hipotesis('Ansiedad generalizada') :- ansiedad, !.
hipotesis('Trastorno de pánico') :- panico, !.
hipotesis('Insomnio') :- insomnio, !.
hipotesis('TOC (Trastorno Obsesivo Compulsivo)') :- toc, !.
hipotesis('Trastorno Bipolar') :- bipolaridad, !.
hipotesis('Estrés postraumático (TEPT)') :- trauma, !.

% Criterios de evaluación basados en los hechos "si/1" recibidos
depresion :-
    si('te sientes triste casi todos los dias'),
    si('has perdido interes en actividades que disfrutabas'),
    si('te sientes sin esperanza').

ansiedad :-
    si('te preocupas demasiado por cosas pequenas'),
    si('sientes nerviosismo constante').

panico :-
    si('has sentido miedo intenso repentino'),
    si('has sentido que no puedes respirar').

insomnio :-
    si('tienes dificultad para dormir'),
    si('te despiertas muchas veces en la noche').

toc :-
    si('tienes pensamientos repetitivos que no controlas'),
    si('repites acciones muchas veces (lavar, revisar, contar)').

bipolaridad :-
    si('has tenido periodos de mucha energia excesiva'),
    si('hablas demasiado rapido en ocasiones'),
    si('luego caes en tristeza profunda').

trauma :-
    si('viviste un evento traumatico'),
    si('tienes recuerdos repetitivos de eso').
