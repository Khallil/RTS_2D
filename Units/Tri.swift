/// Copyright (c) 2018 Razeware LLC

import SpriteKit

class Tri: Unit {
  init(){
    super.init(name:"tri",life:100,cost:400)
    
   
  }

  required init?(coder aDecoder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }
}
