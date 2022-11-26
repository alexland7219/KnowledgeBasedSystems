;            (load "./ontologiaKBS.clp")
;            (load "./kbs.clp")

;(defrule imprimir_exercicis
;    (declare (salience 10))
;    ?instancia <- (object (is-a Ejercicio-Fisico))
;    =>
;    (printout t "Exercici " (instance-name ?instancia)
;    " con intensitat " (send ?instancia get-intensitat) crlf)
;)

(deftemplate programa-exercici
  (slot exercici)
  (slot repeticions)
  (slot duracio)
)

(deftemplate programa
  (multislot llista-exercicis)
)

(defrule preguntar
  (declare (salience 20))
  ?x <- (object(is-a Persona))
  =>
  (printout t "" crlf crlf)
  (printout t "Hola! Benvingut al programa d'inclusió a l'esport per les persones grans." crlf)
  (printout t "Primer de tot rebrà algunes preguntes, per tal d'obtenir un programa d'exercicis personalitzat especialment per a vostè." crlf)
  (printout t "Parlem primer una mica de les seves dades generals." crlf crlf)
  
  (printout t "Amb quin gènere es sent més identificat?" crlf)
  (printout t "home" crlf)
  (printout t "dona" crlf)
  (printout t "altres" crlf crlf)
  (printout t ">")
  (bind ?genere (read))
  (send ?x put-genere ?genere)
  (printout t "Perfecte " (send ?x get-genere) ", continuem." crlf crlf)
  
  (printout t "Com es diu vostè? " crlf)
  (printout t ">")
  (bind ?nombre (read))
  (send ?x put-nom ?nombre)
  (printout t "Encantat, " (send ?x get-nom) crlf crlf)

  (printout t "Quina edat té vostè? " crlf)
  (printout t ">")
  (bind ?edat (read))
  (send ?x put-edat ?edat)
  (printout t "Tens " (send ?x get-edat) " anys" crlf crlf)
  (printout t "Quant medeix? (en centímetres) " crlf)
  (printout t ">")
  (bind ?alcada (read))
  (send ?x put-alçada ?alcada)
  (printout t "Medeix " (send ?x get-alçada) " centímetres" crlf crlf crlf)


 (printout t "Parlem ara una mica de l'estil de vida." crlf crlf)

  (printout t "En una escala del 1 (sedentari) al 5 (actiu), on se situaria vostè? " crlf)
  (printout t ">")
  (bind ?graused (read))
  (send ?x put-grau_sedentarisme ?graused)
  (printout t "" crlf crlf)
  
  (printout t "Quin és el seu ritme cardiac? (en repòs) " crlf)
  (printout t ">")
  (bind ?ritme (read))
  (send ?x put-ritme_cardiac_repos ?ritme)
  (printout t (send ?x get-ritme_cardiac_repos) " polsacions per minut." crlf crlf)
  
  (printout t "Per últim, vostè és una persona fumadora?."crlf)
  (printout t "En cas afirmatiu inserti un 1, en cas contrari un 0." crlf)
  (printout t ">")
  (bind ?fuma (read))
  (send ?x put-fumador ?fuma)
  (if (eq ?fuma 1)
  then
  (printout t "Vostè és fumador." crlf crlf)
  else
  (printout t "Vostè és NO fumador." crlf crlf))
  (printout t "Moltes gràcies per la seva atenció."crlf)
  
  (printout t "Pateix vostè d'alguna malaltia cardiovascular (Y/N)? " crlf)
  (bind ?cv (read))
  (if (eq ?cv Y)
  then
    (printout t "Pateix d'hipertensió (Y/N)? " crlf)
    (bind ?ht (read))
    (if (eq ?ht Y) then (assert (pateix [me] [Hipertension])))
    (printout t "Petaix d'ateroesclerosis (Y/N)? " crlf)
    (bind ?ae (read))
    (if (eq ?ae Y) then (assert (pateix [me] [Enfermedad-cardiovascular-ateroesclerotica])))
  )

  ; Següent grup de malalties
)

(defrule dummy
  ?x <- (object(is-a Persona))
  =>
  (printout t "dummy" crlf)
)

(defrule determine_best_exercise
  (declare (salience 10))
  (printout t "HELLO" crlf)
;  ?m <- (object(is-a Malaltia))
  ?m <- (send [me] get-pateix)
  =>  
;  (bind ?pro (assert (programa p)))
  (bind ?pro (assert (programa)))
  (printout t "Es crea el programa " ?pro crlf)
;  (if (pateix [me] ?m)
;    then
    (bind ?x (send ?m get-recomenable_amb))
    (loop-for-count (?i 1 (length$ ?x)) do
      ; Per a cada exercici recomenable per a cada malaltia
      (bind ?var (nth$ ?i ?x))
      (bind ?temp (assert (programa-exercici)))
      (modify ?temp (exercici ?var))
      (printout t "S'afegeix l'exercici " ?var crlf)
    )
;  )
)