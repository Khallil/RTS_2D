/// Copyright (c) 2018 Razeware LLC

/*

plusieurs type d'units
rec
 life = 200
 cost = 350
 hitpoint = 10
tri
 life = 100
 cost = 400
 hitpoint = 20
cer
 life = 50
 cost = 500
 hitpoint = 40
 */

import SpriteKit

class Unit: SKSpriteNode{
  // init le spritNode
  let life: Int
  let cost: Int
  init(name: String,life: Int, cost:Int){
    let texture = SKTexture(imageNamed: name)
    self.life = life
    self.cost = cost
    super.init(texture: texture, color: UIColor.clear, size: texture.size())
  }
  
  
  required init?(coder aDecoder: NSCoder)
  {
    fatalError("init(coder:) has not been implemented")
  }
  
  // attaquer
  
  // faire autre chose
  
  
}
