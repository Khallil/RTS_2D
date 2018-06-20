/// Copyright (c) 2018 Razeware LLC

import SpriteKit

class Unit: SKSpriteNode{
  // init le spritNode
  let life: Int
  let cost: Int
  var hb: HealthBar
  init(name: String,life: Int, cost:Int){
    let texture = SKTexture(imageNamed: name)
    self.life = life
    self.cost = cost
    self.hb = HealthBar()
    super.init(texture: texture, color: UIColor.clear, size: texture.size())
    self.name = name
  }
  
  required init?(coder aDecoder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }
  
  func placeEnemyUnit(_ blocks:Array<Block>,_ scene:SKScene,_ index:Int,_ grid:Grid,_ units:Array<Unit>)-> (Array<Block>,Array<Unit>){
    var blocks = blocks
    var units = units
    let block = blocks[index]
    
    blocks[index].isFree = false
    blocks[index].unit_name = "tri"
    self.position = grid.gridPosition(row: block.coor.row+1, col: block.coor.col+1)
    self.hb.position = CGPoint(x:self.position.x-30,y:self.position.y-25)
    scene.addChild(self)
    scene.addChild(self.hb)
    units.append(self)
    
    return (blocks,units)
  }
  
  func unitPlacement(_ blocks:Array<Block>,_ player:Player,_ scene:SKScene, _ index:Int, _ grid:Grid,_ name:String, _ units:Array<Unit>)-> (Array<Block>,Array<Unit>){
    var blocks = blocks
    var units = units
    let block = blocks[index]
    var unit:Unit
    //print(block)
    if block.isFree == true && block.unit_name != name{
      if !player.buyUnit(cost: cost){
        print("not enough money !")
      }
      else{
        blocks[index].isFree = false
        blocks[index].unit_name = name
        self.position = grid.gridPosition(row: block.coor.row+1, col: block.coor.col+1)
        self.hb.position = CGPoint(x:self.position.x-30,y:self.position.y-25)
        // adding bar here
        //print(self.position)
        scene.addChild(self)
        scene.addChild(self.hb)
        units.append(self)
      }
    }
    else if block.isFree == false && block.unit_name == name{
        blocks[index].isFree = true
        blocks[index].unit_name = ""
        player.addMoney(self.cost)
        if units.count > 0 {
          unit = getRightUnit(grid.gridPosition(row: block.coor.row+1, col: block.coor.col+1),units)
          unit.hb.removeFromParent()
          unit.removeFromParent()
          units.remove(at:units.index(of:unit)!)
        }
    }
    else{
      print("block is not free block unit_name ==",block.unit_name)
    }
    return (blocks,units)
  }
}
