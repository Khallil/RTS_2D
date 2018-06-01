/// Copyright (c) 2018 Razeware LLC

import Foundation
import SpriteKit

class Tri: Unit {
  init(){
    super.init(name:"tri",life:100,cost:400)
  }
  
  func spawn(scene: SKScene, position: CGPoint){
      self.position = position
      print("tri added at position : ",self.position)
      scene.addChild(self)
  }
  
  required init?(coder aDecoder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }
}

