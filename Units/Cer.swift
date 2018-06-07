/// Copyright (c) 2018 Razeware LLC

import SpriteKit

class Cer: Unit {
  init(){
    super.init(name:"cer",life:50,cost:500)
    self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
    self.physicsBody?.isDynamic = false// 2

    self.physicsBody?.categoryBitMask = PhysicsCategory.cer
  }

  required init?(coder aDecoder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }
}
