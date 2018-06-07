/// Copyright (c) 2018 Razeware LLC

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
    self.name = name
  }
  
  required init?(coder aDecoder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }
  
  func unitPlacement(_ blocks:Array<Block>,_ player:Player,_ scene:SKScene,_ node:SKNode, _ index:Int, _ grid:Grid,_ name:String, _ units:Array<SKSpriteNode>)-> (Array<Block>,Array<SKSpriteNode>){
    var blocks = blocks
    var units = units
    let block = blocks[index]
    if block.isFree == true && block.unit_name != name{
      if !player.buyUnit(cost: cost){
        print("not enough money !")
      }
      else{
        blocks[index].isFree = false
        blocks[index].unit_name = name
        self.position = grid.gridPosition(row: block.coor.row+1, col: block.coor.col+1)
        scene.addChild(self)
        units.append(self)
      }
    }
    else if block.unit_name == name{
      // fonctionne pas, parce que faut recupere la bonne SpriteNode
      if node.name == name{
        node.removeFromParent()
        blocks[index].isFree = true
        blocks[index].unit_name = ""
        player.addMoney(self.cost)
        units = removeNodeFromArray(self.position,units)
      }
      else{
        print("ca fait un son erreur")
      }
    }
    else{
      print("ca fait un son erreur")
    }
    return (blocks,units)
  }
  
  // attaquer
  
  // faire autre chose
  
  
}
