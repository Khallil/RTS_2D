/// Copyright (c) 2018 Razeware LLC

import SpriteKit

class Visu: SKSpriteNode {
  
  var price = SKLabelNode(fontNamed: "Athens Classic")
  
  init(_ image:String) {
    let texture = SKTexture(imageNamed: image)
    price.fontSize = 17
    price.fontColor = SKColor.yellow

    super.init(texture: texture,color: UIColor.clear,size: texture.size())
    print(image)
    if image == "cer"{
      self.name = "visuCer"
      price.text = "500"    }
    if image == "rec"{
      // self.name = visu+name
      // price.text = global_var[self.name]
      self.name = "visuRec"
      price.text = "350"
    }
    self.zPosition = 0.1
    //self.price.zPosition = 0
  }
  
  func addOnScene(_ scene: SKScene){
    if self.name == "visuRec"{
      self.position = CGPoint(x: scene.size.width * 0.17, y: scene.size.height * 0.35)
    }
    else if self.name == "visuCer"{
      self.position = CGPoint(x: scene.size.width * 0.17, y: scene.size.height * 0.65)
    }
    price.position = CGPoint(x: self.position.x+10, y: self.position.y - 30)
    price.zPosition = 0.2
    scene.addChild(self.price)
    scene.addChild(self)
  }
  
  required init?(coder aDecoder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }
}
