/// Copyright (c) 2018 Razeware LLC

import SpriteKit

class Rec: Unit {
  init(){
    super.init(name:"rec",life:200,cost:400)
    self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
    self.physicsBody?.isDynamic = false// 2
    
    self.physicsBody?.categoryBitMask = PhysicsCategory.rec
  }
  
  required init?(coder aDecoder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }
}



