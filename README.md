
  
  Unit herite du type SKSpriteNode
  composant :
    un type (soldier,tank,heal)
    un cout
    une image
    des characteristiques
    une physique, etc
  methodes :
    invoquer_objet()
    remove_item()


Mettre en place des vecteurs de placement
    0    a  w * 0.105
de [x   a x1] = placement icone joueur
   w * 0.105 * w * 0.24
de [x1 a x2] = placement de la board
   w * 0.24 a w * 0.84
de [x2 a x3] = placement du battleground
   w * 0.84 a max_weigth
de [x3 a x4] = placement du joueur IA en face

TODO :
  set les bar
