
import SpriteKit


extension GameScene{
  // Actions after user interaction
  
  // when player try to add unit on the grid
  func handleUnitOnGrid(_ index:Int){
    switch self.currentSelected {
    case "visuRec":
      let rec = Rec()
      (blocks,player_units) = rec.unitPlacement(blocks,player,self,index,grid,"rec",player_units)
    case "visuCer":
      let cer = Cer()
      (blocks,player_units) = cer.unitPlacement(blocks,player,self,index,grid,"cer",player_units)
    //print("len player_units : ",player_units.count)
    default:
      print("no item selected")
    }
    money.text = String(player.getMoney())
  }
  
  // when player select a type of unit
  func handleUnitSelection(_ sprite:String?){
    switch sprite {
    case "visuRec":
      // enleve le selected highlight si est deja sur le triangle
      if self.currentSelected==sprite!{
        surface.isHidden=true
        self.currentSelected = "none"
      }
      else{
        surface.position = visuRec.position
        surface.isHidden=false
        self.currentSelected=sprite!
      }
    case "visuCer":
      // enleve le selected highlight si est deja sur le triangle
      if self.currentSelected==sprite!{
        surface.isHidden=true
        self.currentSelected = "none"
      }
      else{
        surface.position = visuCer.position
        surface.isHidden=false
        self.currentSelected=sprite!
      }
    default:
      print("none sprite selected")
    }
  }
  
  // when player select unit to shoot the Big Shoot
  func bulletPowerOn(_ index:Int){
    let block = blocks[index]
    if block.unit_name == "rec" || block.unit_name == "cer"{
      if energyBar.cutSize(0.4){
        let unit = getRightUnit(block.position, player_units)
        addPlayerProjectile(unit, true)
      }
    }
  }
  
  func startButtonAction(){
    if startMode == true{
      startMode = false
      self.start_button.texture = SKTexture(imageNamed:"start")
    }
    else{
      startMode = true
      surface.isHidden=true
      self.currentSelected = "none"
      self.start_button.texture = SKTexture(imageNamed:"startoff")
    }
  }
  // --------------- //
  
}
