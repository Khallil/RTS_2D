/// Copyright (c) 2018 Razeware LLC


import SpriteKit
import Foundation

class Player: SKSpriteNode {
  var life: Int
  var money: Int
  let max_money :Int
  init() {
    let texture = SKTexture(imageNamed: "player")
    self.life = 100
    self.max_money = 3000
    self.money = max_money
    super.init(texture: texture, color: UIColor.clear, size: texture.size())
  }
  
  func buyUnit(cost: Int) -> Bool {
    if self.money < cost{
      return false
    }
    self.money = self.money - cost
    //print(self.money)
    return true
  }
  
  func getMoney() -> Int{
    return self.money
  }
  
  func addMoney(_ money: Int){
    self.money = self.money + money
    if self.money > max_money{
      self.money = max_money
    }
  }
  
  required init?(coder aDecoder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }
}
