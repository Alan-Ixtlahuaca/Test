% --- BASE DE HECHOS ---
% Estos son los datos que "llegarían" de la página HTML.
% Por ejemplo, si en el HTML Juan marca que tiene tristeza e insomnio:
padece(juan, tristeza).
padece(juan, insomnio).
padece(ana, nerviosismo).
padece(carlos, miedo).

% Definimos qué síntoma pertenece a qué trastorno (igual que es_sintoma(fiebre, gripa))
es_sintoma(tristeza, depresion).
es_sintoma(perdida_interes, depresion).
es_sintoma(nerviosismo, ansiedad).
es_sintoma(preocupacion, ansiedad).
es_sintoma(miedo, panico).
es_sintoma(insomnio, trastorno_sueno).

% Definimos qué tratamiento alivia qué trastorno (igual que suprime(paracetamol, fiebre))
alivia(terapia_cognitiva, depresion).
alivia(meditacion, ansiedad).
alivia(ejercicios_respiracion, panico).
alivia(melatonina, trastorno_sueno).

% --- REGLAS --- (Misma estructura que usó tu profesor)

% 1. Regla para saber el diagnóstico: Una persona tiene un trastorno si padece un síntoma de ese trastorno
tiene_trastorno(Persona, Trastorno) :- 
    padece(Persona, Sintoma), 
    es_sintoma(Sintoma, Trastorno).

% 2. Regla para saber qué recetar: Debe tomar un tratamiento si tiene un trastorno y ese tratamiento lo alivia
debe_tomar_terapia(Persona, Tratamiento) :- 
    tiene_trastorno(Persona, Trastorno), 
    alivia(Tratamiento, Trastorno).
