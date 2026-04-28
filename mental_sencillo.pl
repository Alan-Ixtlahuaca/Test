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
