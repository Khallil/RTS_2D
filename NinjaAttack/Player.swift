/// Copyright (c) 2018 Razeware LLC


import SpriteKit
import Foundation

class Player: SKSpriteNode {
  var life: Int
  var money: Int
  
  init() {
    let texture = SKTexture(imageNamed: "player")
    self.life = 100
    self.money = 2000
    super.init(texture: texture, color: UIColor.clear, size: texture.size())
  }
  
  func buyUnit(cost: Int) -> Bool {
    if self.money < cost{
      return false
    }
    self.money = self.money - cost
    return true
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
}