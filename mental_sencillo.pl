:- encoding(utf8).
:- dynamic si/1.
:- dynamic no/1.

% --- BASE DE CONOCIMIENTO: ENFERMEDADES Y SINTOMAS ---
enfermedad(depresion, [tristeza, perdida_interes, sin_esperanza]).
enfermedad(ansiedad, [nerviosismo, preocupacion, tension_muscular]).
enfermedad(panico, [miedo_intenso, falta_respiracion, taquicardia]).
enfermedad(trastorno_sueno, [insomnio, despertar_frecuente, cansancio_diurno]).

% --- REGLAS ---
% Diagnostica un trastorno si un síntoma afirmativo ("si") está en la lista de síntomas de esa enfermedad
tiene_trastorno(Trastorno) :-
    enfermedad(Trastorno, ListaSintomas),
    si(Sintoma),
    member(Sintoma, ListaSintomas).
