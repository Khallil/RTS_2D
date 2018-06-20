/// Copyright (c) 2018 Razeware LLC

import SpriteKit

class Tri: Unit {
  init(){
    super.init(name:"tri",life:100,cost:400)
    self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
    self.physicsBody?.isDynamic = false// 2
    
    self.physicsBody?.categoryBitMask = PhysicsCategory.tri
   
  }

  required init?(coder aDecoder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }
}
