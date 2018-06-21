/// Copyright (c) 2018 Razeware LLC

import SpriteKit

class HealthBar: SKSpriteNode{
  var hp:Int
  
  convenience init() {
    let color = UIColor.green
    let size = CGRect(origin:CGPoint(x:500.0, y:200.0),size: CGSize(width: 60, height: 8)).size
    self.init(color:color,size:size)
    self.anchorPoint = CGPoint(x:0.0,y:0.5)
  }
  
  override init(texture: SKTexture!, color: UIColor, size: CGSize) {
    self.hp = 100
    super.init(texture: texture, color: color, size: size)
}
  
  func gotHit(_ damage: Int){
    self.hp = self.hp - damage
    if self.hp <= 0{
      //on kill l'unit
    }
    else{
      self.size.width = CGFloat((self.hp * 60) / 100)
    }
  }
  
  required init?(coder aDecoder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }
}
