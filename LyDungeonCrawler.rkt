;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname LyDungeonCrawler) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Image Stuff;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define scaleS 3)
(define cell-H (* scaleS 16))
(define cell-W (* scaleS 16))
(define matrix-H (* scaleS 16))
(define matrix-W (* scaleS 16))
(define cell (rectangle cell-W cell-H 'outline 'black) )
(define p1 (underlay cell (circle (/ cell-W 2) 'solid 'blue)))
(define e1 (underlay cell (circle (/ cell-W 2) 'solid 'red)))
(define wall (underlay cell (rectangle cell-W cell-H 'solid 'black)))
(define moveHLight (overlay (rectangle cell-W cell-H 'outline 'black) (rectangle cell-W cell-H 'solid 'lightgreen)))
(define atkHLight (overlay (rectangle cell-W cell-H 'outline 'black) (rectangle cell-W cell-H 'solid 'pink)))
(define atkE (underlay atkHLight e1))
(define health (underlay (underlay (rectangle (/ cell-W 3) cell-H 'solid 'red) (rectangle cell-W (/ cell-H 3) 'solid 'red)) cell))
(define ammo (overlay (above (underlay (triangle (/ cell-W 5) 'outline 'black) (triangle (/ cell-W 5) 'solid 'silver))
                             (underlay (rectangle (/ cell-W 5) (* cell-H 0.5) 'outline 'black) (rectangle (/ cell-W 5) (* cell-H 0.5) 'solid 'silver))
                             (rectangle (/ cell-W 2) (/ cell-H 10) 'solid 'brown)
                             (rectangle (/ cell-W 5) (* cell-H 0.2) 'solid 'brown)) cell))
(define movement (underlay (above/align "left" (rectangle (/ cell-W 2) (/ cell-H 10) 'solid 'brown)
                           (above/align "left"
                        (rectangle (/ cell-W 2.8) (/ cell-H 2.5) 'solid 'brown)
                        (rectangle (/ cell-W 1.5) (/ cell-H 3) 'solid 'brown))) cell))
(define healthH (underlay moveHLight health))
(define ammoH (underlay moveHLight ammo))
(define movementH (underlay moveHLight movement))
(define endOutline (rectangle (* cell-W 24) (* cell-H 16) 'outline 'black))
(define (stats hp ap mp c) (underlay/xy (underlay/xy
               (rectangle (* 7 cell-W) (* 16 cell-H) 'outline 'black) 0 0
               (above/align "left"
                      (beside (text " " (* scaleS 24) c) health (text " HP:" (* scaleS 24) c) (text (number->string hp) (* scaleS 24) "olive"))
                      (beside (text " " (* scaleS 24) c) ammo (text " AP:" (* scaleS 24) c) (text (number->string ap) (* scaleS 24) "olive"))
                      (beside (text " " (* scaleS 24) c) movement (text " MP:" (* scaleS 24) c) (text (number->string mp) (* scaleS 24) "olive")))) 0 (* 12 cell-H)
               (above/align "left"                                            
                      (underlay (rectangle (* 7 cell-W) (* 2 cell-H) 'outline 'black) (text "ATTACK" (* scaleS 20) "red"))
                      (underlay (rectangle (* 7 cell-W) (* 2 cell-H) 'outline 'black) (text "END TURN" (* scaleS 20) "red")))))
(define gameOver (underlay endOutline (underlay/xy (underlay/xy
             (rotate 45 (scale 10 (above (triangle (/ cell-W 5) 'solid 'silver)
                             (rectangle (/ cell-W 5) (* cell-H 0.5) 'solid 'silver)
                             (rectangle (/ cell-W 2) (/ cell-H 10) 'solid 'brown)
                             (rectangle (/ cell-W 5) (* cell-H 0.2) 'solid 'brown))))
             15 0
             (rotate -45 (scale 10 (above (triangle (/ cell-W 5) 'solid 'silver)
                             (rectangle (/ cell-W 5) (* cell-H 0.5) 'solid 'silver)
                             (rectangle (/ cell-W 2) (/ cell-H 10) 'solid 'brown)
                             (rectangle (/ cell-W 5) (* cell-H 0.2) 'solid 'brown))))) -80 -5
                      (text "GAME OVER" 50 "red"))))
(define win (underlay endOutline (underlay/xy (underlay/xy
             (rotate 45 (scale 10 (above (triangle (/ cell-W 5) 'solid 'silver)
                             (rectangle (/ cell-W 5) (* cell-H 0.5) 'solid 'silver)
                             (rectangle (/ cell-W 2) (/ cell-H 10) 'solid 'brown)
                             (rectangle (/ cell-W 5) (* cell-H 0.2) 'solid 'brown))))
             100 0
             (rotate -45 (scale 10 (above (triangle (/ cell-W 5) 'solid 'silver)
                             (rectangle (/ cell-W 5) (* cell-H 0.5) 'solid 'silver)
                             (rectangle (/ cell-W 2) (/ cell-H 10) 'solid 'brown)
                             (rectangle (/ cell-W 5) (* cell-H 0.2) 'solid 'brown))))) 60 -5
                      (text "WIN" 50 "blue"))))
(define bg (rectangle (* cell-W matrix-W) (* cell-H matrix-H) 'solid 'darkgray))

;Magic Number Stuff
(define cellEmpty 0)
(define cellWall 1)
(define cellPlyr 2)
(define cellMove 3)
(define cellEnmy 4)
(define cellAtk 5)
(define cellAtkEnmy 6)
(define cellHealth 7)
(define cellAmmo 8)
(define cellMovement 9)
(define cellHealthH 10)
(define cellAmmoH 11)
(define cellMovementH 12)

(define lowerBoard 16)
(define upperBoard 1)
(define leftBoard 1)
(define rightBoard 16)

(define leftStat 16)
(define rightStat 24)

(define upperATKButton 13)
(define lowerATKButton 14)
(define upperEndButton 15)
(define lowerEndButton 16)

(define HighlightOff 0)
(define HighlightOn 1)


;Number -> List of Numbers
;Builds a row that is x-long
(define (row x)
  (cond
    [(= x 0) empty]
    [else (cons cellEmpty (row (- x 1)))]))
(check-expect (row 2) (list 0 0))
 
;Number, Number -> List of Lists
;Builds a matrix that is x-wide and y-tall
(define (build-matrx x y)
  (cond
    [(= y 0) empty]
    [else (cons (row x) (build-matrx x (- y 1)))]))
(check-expect (build-matrx 2 2) (list (list 0 0)
                                      (list 0 0)))

;List -> element
;Returns last element in a list
(define (last-entry l)
  (cond
    [(empty? l) (make-posn (+ (random 16) 1) (+ (random 16) 1))]
    [(= 1 (length l)) (first l)]
    [else (last-entry (rest l))]))
(check-expect (last-entry (list 1 2 3)) 3)

;Number, Number, List -> List
;Changes the x-th element in a list l to the value z
(define (insert x z l)
  (cond
    [(empty? l) empty]
    [(= (length l) x) (cons z (insert x z (reverse (rest (reverse l)))))]
    [else (cons (last-entry l) (insert x z (reverse (rest (reverse l)))))]))
(check-expect (insert 2 3 (list 0 0 0)) (list 0 3 0))

;Number -> Image
;Draws an oject depending on given value
(define (drawCell z)
  (cond
    [(= z cellWall) wall]
    [(= z cellPlyr) p1]
    [(= z cellMove) moveHLight]
    [(= z cellEnmy) e1]
    [(= z cellAtk) atkHLight]
    [(= z cellAtkEnmy) atkE]
    [(= z cellHealth) health]
    [(= z cellAmmo) ammo]
    [(= z cellMovement) movement]
    [(= z cellHealthH) healthH]
    [(= z cellAmmoH) ammoH]
    [(= z cellMovementH) movementH]
    [else cell]))

;List -> Image
;Draws a row of cells for each value in a list l
(define (drawRow l)
  (cond [(empty? l) (empty-scene 0 0)]
        [else (beside (drawCell (first l)) (drawRow (rest l)) )]))
(check-expect (drawRow (list 0 0)) (beside cell cell))

;List of Lists -> Image
;Draws a matrix of cells
(define (drawBoard lol)
  (cond [(empty? lol) (empty-scene 0 0)]
        [else (above  (drawBoard (reverse (rest (reverse lol))))
                      (drawRow (last-entry lol)))]))
(check-expect (drawBoard (list (list 0 0)
                               (list 0 0))) (above (beside cell cell)
                                                   (beside cell cell)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Matrix Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;Helper Function
(define (in-matrx x y z lol)
  (cond
    [(empty? lol) empty]
    [(= (length lol) y) (cons (reverse (insert x z (last-entry lol))) (in-matrx x y z (reverse (rest (reverse lol)))))]
    [else (cons (last-entry lol) (in-matrx x y z (reverse (rest (reverse lol)))))]))

;Number, Number, Number, List of List -> List of Lists
;Changes the element at x,y in the matrix lol to z
(define (mod-matrx x y z lol)
  (reverse (in-matrx x y z lol)))
(check-expect (mod-matrx 2 2 5 (list (list 0 0)
                                     (list 0 0))) (list (list 0 0)
                                                        (list 0 5)))

;List of Posn, Number, List of List -> List of Lists
;For each posn in a given list, changes the value of the position in a matrix to z
(define (multi-mod lop z lol)
 (cond
   [(= (length lop) 1) (mod-matrx (posn-x (last-entry lop)) (posn-y (last-entry lop)) z lol)]
   [else (mod-matrx (posn-x (last-entry lop)) (posn-y (last-entry lop)) z
                    (multi-mod (reverse (rest (reverse lop))) z lol))]))
(check-expect (multi-mod (list (make-posn 1 1) (make-posn 2 2)) 5
                         (list (list 0 0)
                               (list 0 0))) (list (list 5 0)
                                                  (list 0 5)))

;List of Lists -> List of Lists
;De-Highlights all "highlighted cells" in matrix 
(define (clearMove lol)
  (map (lambda (t)
         (map
          (lambda (x)
            (cond
              [(= x cellAtkEnmy) cellEnmy]
              [(= x cellHealthH) cellHealth]
              [(= x cellAmmoH) cellAmmo]
              [(= x cellMovementH) cellMovement]
              [else (if (or (= x cellMove) (= x cellAtk)) cellEmpty x)])) t))
       lol))
(check-expect (clearMove (list (list 5 5)
                               (list 5 5)))
                         (list (list 0 0)
                               (list 0 0)))

;Helper Function
(define (return x l)
  (cond
    [(= (length l) x) (last-entry l)]
    [else (return x (reverse (rest (reverse l))))]))
(check-expect (return 3 (list 0 0 5 6)) 5)

;Number, Number, List of Lists -> Element
;Returns the value at x,y in a matrix
(define (returnCell x y lol)
  (cond 
    [(= (length lol) y) (return x (last-entry lol)) ]
    [else (returnCell x y  (reverse (rest (reverse lol))))]))
(check-expect (returnCell 1 2 (list (list 2 3)
                                    (list 4 5))) 4)

;Helper
;Returns #t if the cell above x,y is empty
;Returns #f if not
(define (upEmpty? x y lol)
  (if (or (= (returnCell x (- y 1) lol) cellEmpty)
          (= (returnCell x (- y 1) lol) cellMove)
          (= (returnCell x (- y 1) lol) cellAtkEnmy)
          (= (returnCell x (- y 1) lol) cellHealth)
          (= (returnCell x (- y 1) lol) cellAmmo)
          (= (returnCell x (- y 1) lol) cellMovement)) #t #f))
(check-expect (upEmpty? 2 2 (list (list 0 0)
                                  (list 0 2))) #t)

;Helper
;Returns #t if the cell below x,y is empty
;Returns #f if not
(define (downEmpty? x y lol)
  (if (or (= (returnCell x (+ y 1) lol) cellEmpty)
          (= (returnCell x (+ y 1) lol) cellMove)
          (= (returnCell x (+ y 1) lol) cellAtkEnmy)
          (= (returnCell x (+ y 1) lol) cellHealth)
          (= (returnCell x (+ y 1) lol) cellAmmo)
          (= (returnCell x (+ y 1) lol) cellMovement)) #t #f))
(check-expect (downEmpty? 2 1 (list (list 0 0)
                                  (list 0 2))) #f)

;Helper
;Returns #t if the cell to the left of x,y is empty
;Returns #f if not
(define (leftEmpty? x y lol)
  (if (or (= (returnCell (- x 1) y lol) cellEmpty)
          (= (returnCell (- x 1) y lol) cellMove)
          (= (returnCell (- x 1) y lol) cellAtkEnmy)
          (= (returnCell (- x 1) y lol) cellHealth)
          (= (returnCell (- x 1) y lol) cellAmmo)
          (= (returnCell (- x 1) y lol) cellMovement)) #t #f))
(check-expect (leftEmpty? 2 2 (list (list 0 0)
                                    (list 0 2))) #t)

;Helper
;Returns #t if the cell to the right of x,y is empty
;Returns #f if not
(define (rightEmpty? x y lol)
  (if (or (= (returnCell (+ x 1) y lol) cellEmpty)
          (= (returnCell (+ x 1) y lol) cellMove)
          (= (returnCell (+ x 1) y lol) cellAtkEnmy)
          (= (returnCell (+ x 1) y lol) cellHealth)
          (= (returnCell (+ x 1) y lol) cellAmmo)
          (= (returnCell (+ x 1) y lol) cellMovement)) #t #f))
(check-expect (rightEmpty? 1 2 (list (list 0 0)
                                     (list 0 2))) #f)

;Number, Number, List of Lists -> List of Lists
;Sets the value in matrix at x,y to 0
(define (setEmptyE x y lol)
(mod-matrx x y cellEmpty lol))
(check-expect (setEmptyE 2 2 (list (list 0 0)
                                   (list 0 1)))
              (list (list 0 0)
                    (list 0 0)))
                                         

;Helper
(define (left? pos lol)
(if (> (posn-x pos) leftBoard)
       (if (leftEmpty? (posn-x pos) (posn-y pos) lol)
           (cons (make-posn (- (posn-x pos) 1) (posn-y pos)) (list pos))
           (list pos))
       (list pos)))

;Helper
(define (up? pos lol)
(if (> (posn-y pos) upperBoard)
       (if (upEmpty? (posn-x pos) (posn-y pos) lol)
           (cons (make-posn (posn-x pos) (- (posn-y pos) 1)) (left? pos lol))
           (left? pos lol))
       (left? pos lol)))

;Helper
(define (right? pos lol)
(if (< (posn-x pos) rightBoard)
       (if (rightEmpty? (posn-x pos) (posn-y pos) lol)
           (cons (make-posn (+ (posn-x pos) 1) (posn-y pos)) (up? pos lol))
           (up? pos lol))
       (up? pos lol)))

;Helper
(define (down? pos lol)
(if (< (posn-y pos) lowerBoard)
       (if (downEmpty? (posn-x pos) (posn-y pos) lol)
           (cons (make-posn (posn-x pos) (+ (posn-y pos) 1)) (right? pos lol))
           (right? pos lol))
       (right? pos lol)))

;Posn, List of Lists -> List of Posn
;List of all empty cells next to the cell at pos
(define (check4 pos lol)
  (down? pos lol))
(check-expect (check4 (make-posn 2 2) (list (list 0 0 0)
                                            (list 0 2 1)
                                            (list 0 1 0)))
              (list (make-posn 2 1)(make-posn 1 2)(make-posn 2 2)))

;Helper
(define (multiCheck lop pos lol)
  (cond
    [(= (length lop) 1) (check4 (last-entry lop) lol)]
    [else (append (check4 (last-entry lop) lol) (multiCheck (reverse(rest(reverse lop))) pos lol))]))

;Number, List of Posn, Posn, List of Lists -> List of Posn
;Returns a list of pos that a character can move to
(define (findRange mp lop pos lol)
  (cond
    [(= 0 mp) (list pos)]
    [(= 1 mp) (multiCheck lop pos lol)]
    [else (multiCheck (findRange (- mp 1) lop pos lol) pos lol)]))
(check-expect (findRange 2 (list (make-posn 2 2)) (make-posn 2 2) (list (list 0 1 0)
                                                                        (list 0 2 1)
                                                                        (list 0 1 0)))
(list
 (make-posn 1 2)
 (make-posn 2 2)
 (make-posn 1 3)
 (make-posn 1 1)
 (make-posn 1 2))) 

;Helper
(define (upAtk? x y lol)
  (if (or (= (returnCell x (- y 1) lol) cellEmpty)
          (= (returnCell x (- y 1) lol) cellEnmy)) #t #f))

;Helper
(define (downAtk? x y lol)
  (if (or (= (returnCell x (+ y 1) lol) cellEmpty)
          (= (returnCell x (+ y 1) lol) cellEnmy)) #t #f))

;Helper
(define (leftAtk? x y lol)
  (if (or (= (returnCell (- x 1) y lol) cellEmpty)
          (= (returnCell (- x 1) y lol) cellEnmy)) #t #f))

;Helper
(define (rightAtk? x y lol)
  (if (or (= (returnCell (+ x 1) y lol) cellEmpty)
          (= (returnCell (+ x 1) y lol) cellEnmy)) #t #f))

;Helper
(define (leftAtk pos lol)
(if (> (posn-x pos) leftBoard)
       (if (leftAtk? (posn-x pos) (posn-y pos) lol)
           (cons (make-posn (- (posn-x pos) 1) (posn-y pos)) (list pos))
           (list pos))
       (list pos)))
;Helper
(define (upAtk pos lol)
(if (> (posn-y pos) upperBoard)
       (if (upAtk? (posn-x pos) (posn-y pos) lol)
           (cons (make-posn (posn-x pos) (- (posn-y pos) 1)) (leftAtk pos lol))
           (leftAtk pos lol))
       (leftAtk pos lol)))
;Helper
(define (rightAtk pos lol)
(if (< (posn-x pos) rightBoard)
       (if (rightAtk? (posn-x pos) (posn-y pos) lol)
           (cons (make-posn (+ (posn-x pos) 1) (posn-y pos)) (upAtk pos lol))
           (upAtk pos lol))
       (upAtk pos lol)))
;Helper
(define (downAtk pos lol)
(if (< (posn-y pos) lowerBoard)
       (if (downAtk? (posn-x pos) (posn-y pos) lol)
           (cons (make-posn (posn-x pos) (+ (posn-y pos) 1)) (rightAtk pos lol))
           (rightAtk pos lol))
       (rightAtk pos lol)))

;Helper
(define (check4Atk pos lol)
  (downAtk pos lol))

;Helper
(define (multiCheckAtk lop pos lol)
  (cond
    [(= (length lop) 1) (check4Atk (last-entry lop) lol)]
    [else (append (check4Atk (last-entry lop) lol) (multiCheckAtk (reverse(rest(reverse lop))) pos lol))]))

;Number, List of Posn, Posn, List of Lists -> List of Posn
;Returns a list of possible cells you can attack
(define (findATKRange rng lop pos lol)
  (cond
    [(= 0 rng) empty]
    [(= 1 rng) (multiCheckAtk lop pos lol)]
    [else (multiCheckAtk (findRange (- rng 1) lop pos lol) pos lol)]))
(check-expect (findATKRange 2 (list (make-posn 2 2)) (make-posn 2 2) (list (list 0 1 0)
                                                                        (list 0 2 1)
                                                                        (list 0 1 0)))
(list
 (make-posn 1 2)
 (make-posn 2 2)
 (make-posn 1 3)
 (make-posn 1 1)
 (make-posn 1 2)))



;;;;;;;;;;;;;;;;;;;;;
;;;;World State;;;;;;
;;;;;;;;;;;;;;;;;;;;;

;Initial matrix options
(define matrx (list
  (list 2 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0)
  (list 0 1 0 0 0 0 0 0 0 7 0 0 0 0 7 0)
  (list 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0)
  (list 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0)
  (list 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0)
  (list 0 1 0 1 0 1 0 0 0 0 0 0 7 0 0 0)
  (list 0 1 0 1 0 1 0 0 0 0 0 0 0 0 0 0)
  (list 0 1 0 1 0 1 1 0 0 0 0 0 0 0 0 0)
  (list 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1)
  (list 1 0 1 0 1 0 1 0 0 0 0 0 1 0 0 0)
  (list 0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 0)
  (list 0 1 0 0 1 0 1 0 1 0 1 0 0 0 0 0)
  (list 0 0 0 0 1 0 1 1 1 1 1 1 0 1 0 0)
  (list 0 1 0 0 1 0 0 0 1 0 0 0 1 0 0 0)
  (list 0 0 0 0 1 0 1 0 1 0 0 0 0 0 0 0)
  (list 8 7 0 0 1 9 1 0 0 0 0 0 0 0 0 4)))

;WS: a = matrix, p = player, e = enemy, h = Highlighted Switch, stat = Stats, mPos = mouse position
(define-struct Board (a p e h stat mPos))
(define-struct plyr (hp mp ap pos mList base))
(define-struct enmy (hp mp ap pos mList base))
(define-struct baseStat (mp ap))
(define-struct stat (HP AP MP c))

;Initial Player and Enemy Stats
(define P-HP 2)
(define P-MP 3)
(define P-AP 1)
(define E-HP 5)
(define E-MP 4)
(define E-AP 1)
(define AttackRange 3)
(define startPlyrPos (make-posn 1 1))
(define startEnmyPos (make-posn 16 16))
(define initMouse (make-posn 1 1))
(define initStat (make-stat 0 0 0 "olive"))

;Initial Player and Enemy
(define genPlyr (make-plyr P-HP P-MP P-AP startPlyrPos (list startPlyrPos) (make-baseStat P-MP P-AP) ))
(define genEnmy (make-enmy E-HP E-MP E-AP startEnmyPos (list startEnmyPos) (make-baseStat E-MP E-AP)))

(define initBoard (make-Board matrx
                      genPlyr
                      genEnmy
                      HighlightOff                   
                      initStat
                      initMouse))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;WS Functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;WorldState -> Image
;Draws the game
(define (render ws) (beside/align "top" (drawBoard (Board-a ws)) (stats (stat-HP (Board-stat ws))
                                                            (stat-AP (Board-stat ws))
                                                            (stat-MP (Board-stat ws))
                                                            (stat-c (Board-stat ws)))))

;WorldState, Number, Number -> WorldState
;Updates the position of the mouse
(define (mouseCell ws x y)
  (make-Board (Board-a ws) (Board-p ws) (Board-e ws) (Board-h ws) (Board-stat ws) (make-posn (+ (floor (/ x cell-W)) 1) (+ (floor (/ y cell-H)) 1))))
               

;WorldState, Number, Number -> Number
;Returns the distance between the plyr and another coordinate
(define (dist ws x y)
  (+ (abs (- x (posn-x (plyr-pos (Board-p ws)))))
     (abs (- y (posn-y (plyr-pos (Board-p ws)))))))
(check-expect (dist initBoard 2 2) 2)

;WorldState, Number, Number -> WorldState
;Moves the plyr to the position of the mouse
(define (mouseMove ws x y)
(make-Board (mod-matrx x y cellPlyr
            (clearMove (setEmpty ws)))
            (make-plyr
             (plyr-hp (Board-p ws))
             (- (plyr-mp (Board-p ws)) (dist ws x y))
             (plyr-ap (Board-p ws))
             (make-posn x y)
             (list (make-posn x y))
             (plyr-base (Board-p ws)))
            (Board-e ws)
            HighlightOff
            (make-stat (stat-HP (Board-stat ws))
             (stat-AP (Board-stat ws))
             (- (plyr-mp (Board-p ws)) (dist ws x y))
             "blue")(Board-mPos ws)))

;Helper
(define (itemInRng? ws lpos x)
  (cond
    [(empty? lpos) #f]
    [else (if (= (returnCell (posn-x (first lpos)) (posn-y (first lpos)) (Board-a ws)) x) #t (itemInRng? ws (rest lpos) x))]))
(check-expect (itemInRng? initBoard (list (make-posn 1 1)) 2) #t)

;WorldState -> List of Lists
;"Highlights" all of the cells that a plyr can move to
(define (showMoves ws)
  (local
    [(define movRange (findRange (plyr-mp (Board-p ws)) (plyr-mList (Board-p ws)) (plyr-pos (Board-p ws)) (Board-a ws)))
     (define healthL (filter (lambda (x) (if (= (returnCell (posn-x x) (posn-y x) (Board-a ws)) cellHealth) #t #f)) movRange))
     (define ammoL (filter (lambda (x) (if (= (returnCell (posn-x x) (posn-y x) (Board-a ws)) cellAmmo) #t #f)) movRange))
     (define movementL (filter (lambda (x) (if (= (returnCell (posn-x x) (posn-y x) (Board-a ws)) cellMovement) #t #f)) movRange))
     (define emptyCell (filter (lambda (x) (if (= (returnCell (posn-x x) (posn-y x) (Board-a ws)) cellEmpty) #t #f)) movRange))
     (define showHealth (if (itemInRng? ws healthL cellHealth) (multi-mod healthL cellHealthH (clearMove (Board-a ws))) (clearMove (Board-a ws))))
     (define showAmmo (if (itemInRng?  ws ammoL cellAmmo) (multi-mod ammoL cellAmmoH showHealth) showHealth))
     (define showMovement (if (itemInRng? ws movementL cellMovement) (multi-mod movementL cellMovementH showAmmo) showAmmo))
     (define showEmpty (if (itemInRng? ws emptyCell cellEmpty) (multi-mod emptyCell cellMove showMovement) showMovement))]
showEmpty))

;WorldState -> List of Lists
;"Highlights" the cells a plyr can attack
(define (showATK ws)
  (local
    [(define atkR (findATKRange AttackRange (plyr-mList (Board-p ws)) (plyr-pos (Board-p ws)) (Board-a ws))) 
    (define emptAtk (filter (lambda (x) (if (= (returnCell (posn-x x) (posn-y x) (Board-a ws)) cellEmpty) #t #f)) atkR))
    (define enmyAtk (filter (lambda (x) (if (= (returnCell (posn-x x) (posn-y x) (Board-a ws)) cellEnmy) #t #f)) atkR))
    (define showEnmy (if (itemInRng? ws enmyAtk cellEnmy) (multi-mod enmyAtk cellAtkEnmy (clearMove (Board-a ws))) (clearMove (Board-a ws))))
    (define showAtk (if (itemInRng? ws emptAtk cellEmpty) (multi-mod emptAtk cellAtk showEnmy) showEnmy))]
    showAtk))

;WorldState -> List of Lists
;After a player moves, changes his last position to an empty cell
(define (setEmpty ws)
(mod-matrx
 (posn-x (plyr-pos (Board-p ws)))
 (posn-y (plyr-pos (Board-p ws)))
 HighlightOff
 (Board-a ws)))

;Helper
(define (updEnm1 ws)
  (local
    [(define movRange (findRange (enmy-mp (Board-e ws)) (list (first (enmy-mList (Board-e ws)))) (enmy-pos (Board-e ws)) (Board-a ws)))
    (define randomPos (return (random (length  movRange)) movRange))
    (define enmy (make-enmy (enmy-hp (Board-e ws)) (enmy-mp (Board-e ws)) (enmy-ap (Board-e ws)) randomPos (list randomPos) (enmy-base (Board-e ws))))]
    (make-Board (mod-matrx (posn-x randomPos) (posn-y randomPos) cellEnmy (setEmptyE (posn-x (enmy-pos (Board-e ws))) (posn-y (enmy-pos (Board-e ws))) (clearMove (Board-a ws))))
                (make-plyr
                 (- (plyr-hp (Board-p ws)) 1)
                 (baseStat-mp (plyr-base (Board-p ws)))
                 (baseStat-ap (plyr-base (Board-p ws)))
                 (plyr-pos (Board-p ws))
                 (plyr-mList (Board-p ws))
                 (plyr-base (Board-p ws)))
                enmy
                HighlightOff
                (make-stat
                   (- (plyr-hp (Board-p ws)) 1)
                   (baseStat-ap (plyr-base (Board-p ws)))
                   (baseStat-mp (plyr-base (Board-p ws)))
                   "blue")
                (Board-mPos ws)))) 

;Helper
(define (updEnm2 ws)
  (local
    [(define movRange (findRange (enmy-mp (Board-e ws)) (list (first (enmy-mList (Board-e ws)))) (enmy-pos (Board-e ws)) (Board-a ws)))
    (define randomPos (return (random (length  movRange)) movRange))
    (define enmy (make-enmy (enmy-hp (Board-e ws)) (enmy-mp (Board-e ws)) (enmy-ap (Board-e ws)) randomPos (list randomPos) (enmy-base (Board-e ws))))]
    (make-Board (mod-matrx (posn-x randomPos) (posn-y randomPos) 4 (setEmptyE (posn-x (enmy-pos (Board-e ws))) (posn-y (enmy-pos (Board-e ws))) (clearMove (Board-a ws))))
                (make-plyr
                 (plyr-hp (Board-p ws))
                 (baseStat-mp (plyr-base (Board-p ws)))
                 (baseStat-ap (plyr-base (Board-p ws)))
                 (plyr-pos (Board-p ws))
                 (plyr-mList (Board-p ws))
                 (plyr-base (Board-p ws)))
                enmy
                HighlightOff
                (make-stat
                   (enmy-hp (Board-e ws))
                   (enmy-ap (Board-e ws))
                   (enmy-mp (Board-e ws))
                   "red")
                (Board-mPos ws))))

;WorldState -> WorldState
; Updates enemy:
; If the plyr is close enought to attack at the start of its turn, it attacks the playre then moves
; Else, it will just move.
(define (enmAtk ws)
  (if (<= (dist ws (posn-x (enmy-pos (Board-e ws))) (posn-y (enmy-pos (Board-e ws)))) AttackRange) (updEnm1 ws) (updEnm2 ws)))


;WorldState, Number, Number, MouseEvent -> WorldState
;MouseEventStuff
(define (mouseActions ws x y m-event)
  (local
    [(define mousePos (Board-mPos ws))]
    
  (cond
    [(mouse=? m-event "button-down") (mouseCell ws x y)]
    [(mouse=? m-event "button-up") (cond
                                     [(and (<= (posn-x mousePos) rightBoard) (<= (posn-y mousePos) lowerBoard))
                                      (cond [ (= (returnCell (posn-x mousePos) (posn-y mousePos) (Board-a ws)) cellPlyr)
                                              (if (and (= (Board-h ws) HighlightOff) (> (plyr-mp (Board-p ws)) 0))
                               (make-Board
                                (showMoves ws)
                                (Board-p ws)
                                (Board-e ws)
                                HighlightOn
                                (make-stat (plyr-hp (Board-p ws))
                                 (plyr-ap (Board-p ws))
                                 (plyr-mp (Board-p ws))
                                 "blue")
                                (Board-mPos ws))
                               (make-Board
                                (clearMove (Board-a ws))
                                (Board-p ws)
                                (Board-e ws)
                                HighlightOff
                                (make-stat (plyr-hp (Board-p ws))
                                 (plyr-ap (Board-p ws))
                                 (plyr-mp (Board-p ws))
                                 "blue")
                                (Board-mPos ws)))]
                                            [(= (returnCell (posn-x mousePos) (posn-y mousePos) (Board-a ws)) cellMove)
                                             (mouseMove ws (posn-x mousePos) (posn-y mousePos))]
                                            [(= (returnCell (posn-x mousePos) (posn-y mousePos) (Board-a ws)) cellEnmy)
                                             (make-Board
                                              (clearMove (Board-a ws))
                                              (Board-p ws)
                                              (Board-e ws)
                                              HighlightOff
                                              (make-stat
                                               (enmy-hp (Board-e ws))
                                               (enmy-ap (Board-e ws))
                                               (enmy-mp (Board-e ws))
                                               "red")
                                              (Board-mPos ws))]
                                            [(= (returnCell (posn-x mousePos) (posn-y mousePos) (Board-a ws)) cellAtkEnmy)
                                             (make-Board
                                              (clearMove (Board-a ws))
                                              (make-plyr
                                               (plyr-hp (Board-p ws))
                                               (plyr-mp (Board-p ws))
                                               (- (plyr-ap (Board-p ws)) 1)
                                               (plyr-pos (Board-p ws))
                                               (plyr-mList (Board-p ws))
                                               (plyr-base (Board-p ws)))
                                              (make-enmy
                                               (- (enmy-hp (Board-e ws)) 1)
                                               (enmy-mp (Board-e ws))
                                               (enmy-ap (Board-e ws))
                                               (enmy-pos (Board-e ws))
                                               (enmy-mList (Board-e ws))
                                               (enmy-base (Board-e ws)))
                                              HighlightOff
                                              (make-stat
                                               (- (enmy-hp (Board-e ws)) 1)
                                               (enmy-ap (Board-e ws))
                                               (enmy-mp (Board-e ws))
                                               "red")
                                              (Board-mPos ws))]
                                            [(= (returnCell (posn-x mousePos) (posn-y mousePos) (Board-a ws)) cellHealthH)
                                             (make-Board
                                              (mod-matrx (posn-x mousePos)(posn-y mousePos) cellPlyr (clearMove (setEmptyE (posn-x (plyr-pos (Board-p ws))) (posn-y (plyr-pos (Board-p ws))) (Board-a ws))))
                                              (make-plyr
                                               (+ (plyr-hp (Board-p ws)) 1)
                                               (- (plyr-mp (Board-p ws)) (dist ws (posn-x mousePos) (posn-y mousePos)))
                                               (plyr-ap (Board-p ws))
                                               mousePos
                                               (list mousePos)
                                               (plyr-base (Board-p ws)) )
                                              (Board-e ws)
                                              HighlightOff
                                              (make-stat
                                               (+ (plyr-hp (Board-p ws)) 1)
                                               (plyr-ap (Board-p ws))
                                               (- (plyr-mp (Board-p ws)) (dist ws (posn-x mousePos) (posn-y mousePos)))
                                               "blue")
                                              (Board-mPos ws))]
                                            [(= (returnCell (posn-x mousePos) (posn-y mousePos) (Board-a ws)) cellAmmoH)
                                             (make-Board
                                              (mod-matrx (posn-x mousePos)(posn-y mousePos) cellPlyr (clearMove (setEmptyE (posn-x (plyr-pos (Board-p ws))) (posn-y (plyr-pos (Board-p ws))) (Board-a ws))))
                                              (make-plyr
                                               (plyr-hp (Board-p ws))
                                               (- (plyr-mp (Board-p ws)) (dist ws (posn-x mousePos) (posn-y mousePos)))
                                               (+ (plyr-ap (Board-p ws)) 1)
                                               mousePos
                                               (list mousePos)
                                               (make-baseStat (baseStat-mp (plyr-base (Board-p ws))) (+ (baseStat-ap (plyr-base (Board-p ws))) 1) ) )
                                              (Board-e ws)
                                              HighlightOff
                                              (make-stat
                                               (plyr-hp (Board-p ws))
                                               (+ (plyr-ap (Board-p ws)) 1)
                                               (- (plyr-mp (Board-p ws)) (dist ws (posn-x mousePos) (posn-y mousePos)))
                                               "blue")(Board-mPos ws))]
                                            [(= (returnCell (posn-x mousePos) (posn-y mousePos) (Board-a ws)) cellMovementH)
                                             (make-Board
                                              (mod-matrx (posn-x mousePos)(posn-y mousePos) cellPlyr (clearMove (setEmptyE (posn-x (plyr-pos (Board-p ws))) (posn-y (plyr-pos (Board-p ws))) (Board-a ws))))
                                              (make-plyr
                                               (plyr-hp (Board-p ws))
                                               (+ (- (plyr-mp (Board-p ws)) (dist ws (posn-x mousePos) (posn-y mousePos))) 1)
                                               (plyr-ap (Board-p ws))
                                               mousePos
                                               (list mousePos)
                                               (make-baseStat (+ (baseStat-mp (plyr-base (Board-p ws))) 1) (baseStat-ap (plyr-base (Board-p ws))) ))
                                              (Board-e ws)
                                              HighlightOff
                                              (make-stat
                                               (plyr-hp (Board-p ws))
                                               (plyr-ap (Board-p ws))
                                               (+ (- (plyr-mp (Board-p ws)) (dist ws (posn-x mousePos) (posn-y mousePos))) 1)
                                               "blue")
                                              (Board-mPos ws))]
                                            [else ws])]
                                     [(and (>= (posn-x mousePos) leftStat) (<= (posn-x mousePos) rightStat) (<= (posn-y mousePos) lowerEndButton) (>= (posn-y mousePos) upperEndButton))
                                      (enmAtk ws)]
                                     [(and (>= (posn-x mousePos) leftStat) (<= (posn-x mousePos) rightStat) (<= (posn-y mousePos) lowerATKButton) (>= (posn-y mousePos) upperATKButton))
                                      (if (and (= (Board-h ws) HighlightOff) (> (plyr-ap (Board-p ws)) 0))
                                            (make-Board (showATK ws) (Board-p ws) (Board-e ws) HighlightOn
                                                        (make-stat (plyr-hp (Board-p ws))
                                                         (plyr-ap (Board-p ws))
                                                         (plyr-mp (Board-p ws))
                                                         "blue")(Board-mPos ws))
                                            (make-Board (clearMove (Board-a ws)) (Board-p ws) (Board-e ws) HighlightOff
                                                        (make-stat (plyr-hp (Board-p ws))
                                                         (plyr-ap (Board-p ws))
                                                         (plyr-mp (Board-p ws))
                                                         "blue")(Board-mPos ws)))]
                                        
                                     [else ws])]
    [else ws])))
 
;WorldState -> WorldState
;Checks whether or not the game is over
(define (endGame ws)
  (cond
    [(= 0 (enmy-hp (Board-e ws))) #t]
    [(= 0 (plyr-hp (Board-p ws))) #t]
    [else #f]))

;WorldState -> Image
;Checks if the plyr won or lost
(define (endPic ws)
  (if (= 0 (enmy-hp (Board-e ws))) win gameOver))

;Initial World State
(big-bang initBoard
          (on-draw render)
          (on-mouse mouseActions)
          (stop-when endGame endPic))
