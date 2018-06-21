/// Copyright (c) 2018 Razeware LLC

import SpriteKit

class EnergyBar: SKSpriteNode {
  
  var behind_bar = SKSpriteNode(imageNamed: "empty_bar")
  var max_width:CGFloat
  
  init() {
    let texture = SKTexture(imageNamed: "yellow_bar")
    max_width = 0.0
    super.init(texture: texture, color: UIColor.clear, size: texture.size())
    max_width = self.size.width
    self.anchorPoint=CGPoint(x:0.0,y:0.5)
    behind_bar.anchorPoint=CGPoint(x:0.0,y:0.5)

  }

  func addOnScene(_ scene: SKScene){
    self.position = CGPoint(x: scene.size.width * 0.07, y: scene.size.height * 0.85)
    behind_bar.position = self.position
    behind_bar.position.x = behind_bar.position.x - 3.0
    scene.addChild(self)
    scene.addChild(behind_bar)
  }
  
  func reset(){
    self.size.width = max_width
  }
  
  func upSize(){
    //print("max_width",max_width)
    let upped_bar = self.size.width + (max_width * 0.0025)
    // on up de 10% la barre
    if self.size.width < max_width{
      if upped_bar > max_width{
        self.size.width = max_width
      }
      else{
        self.size.width = upped_bar
      }
    }
  }
  
  func cutSize(_ value: CGFloat)->Bool{
    let cut_part = value * max_width
    if cut_part <= self.size.width {
      self.size.width = self.size.width - cut_part
      return true
    }
    else{
      return false
    }
  }
  
  required init?(coder aDecoder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }
}
