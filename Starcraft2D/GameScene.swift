/// Copyright (c) 2018 Razeware LLC

import SpriteKit

struct PhysicsCategory {
  static let none      : UInt32 = 0
  static let all       : UInt32 = UInt32.max
  static let monster   : UInt32 = 0b1       // 1
  static let projectile: UInt32 = 0b10      // 2
  static let marauder_p: UInt32 = 0b11      // 3
  static let marine_p  : UInt32 = 0b100     // 4
  static let tri       : UInt32 = 0b101     // 5
  static let cer       : UInt32 = 0b110     // 6
  static let rec       : UInt32 = 0b111     // 7
  //static let roach     : UInt32 = 0b1000     // 8
}

/*
static let none      : UInt32 = 0
static let all       : UInt32 = UInt32.max
static let monster   : UInt32 = 0b1       // 1
static let projectile: UInt32 = 0b10      // 2
static let marauder_p       : UInt32 = 0b11      // 3
static let marine_p       : UInt32 = 0b100     // 4
static let tri       : UInt32 = 0b101     // 5
static let cer       : UInt32 = 0b110     // 6
static let rec       : UInt32 = 0b111     // 7
static let roach       : UInt32 = 0b1000     // 8
*/

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif

class GameScene: SKScene {
  // 1
    let player = Player()
    let ennemy = SKSpriteNode(imageNamed: "ennemy")
    var background = SKSpriteNode(imageNamed: "grass_background")
    var start_button = SKSpriteNode(imageNamed: "start")
    var bar1 = SKSpriteNode(imageNamed: "bar")
    var bar2 = SKSpriteNode(imageNamed: "bar")
    var bar3 = SKSpriteNode(imageNamed: "bar")
    //var visuTri = SKSpriteNode(imageNamed: "tri")
    var visuCer = Visu("cer")
    var visuRec = Visu("rec")
    var surface = SKSpriteNode(imageNamed: "square")
    var currentSelected = "none"
    var money = SKLabelNode(fontNamed: "Athens Classic")
    var blocks = getNewBlocks(6, 6)
    var startMode = false
    var enemy_units:Array<Unit>=Array()
    var player_units:Array<Unit>=Array()
    let grid = Grid(blockSize: 60.0, rows:6, cols:6)
  
    //Called immediately after a scene is presented by a view.
    override func didMove(to view: SKView) {
        init_scene()
        //screen size =  812 375
        addChild(background)
        addChild(money)
        visuCer.addOnScene(self)
        visuRec.addOnScene(self)
        addChild(grid)
        addChild(player)
        addChild(ennemy)
        addChild(start_button)
        addChild(bar1)
        addChild(bar2)
        addChild(bar3)

        addChild(surface)
      
        placeEnemyUnit()
        initEnnemyAction()
        initPlayerAction()
        //IphoneX = 2.16
        //Iphone8+ = 1.77
        //Iphone6 = 1.77
        print(size.width/size.height)
    }
  
    // trigerred when the touch (click) happenned Set<UITouch>
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1 - on prends seulement le premier toucher
        guard let touch = touches.first else {
          return
        }
        let touchLocation = touch.location(in: self)
        print("Touch Location : ",touchLocation)
        let touchedNode = self.nodes(at: touchLocation)
        //print("touchedNode : ",touchedNode)

        // gere la selection des Units

        if touchedNode.count > 0{
          let sprite = touchedNode[0].name
          if sprite == "start"{
            self.startButtonAction()
          }
          else{
            if startMode == false{
              self.handleUnitSelection(sprite)
            }
          }
        }

        // gere le placement des units sur le grid
        if grid.isTouchInGrid(point: touchLocation){
            let index = grid.getIndexBlockTouched(touchLocation,blocks)
            print("Index",index)
            if startMode == false{
              self.handleUnitOnGrid(index)
            }
            else{
              // si on clique sur le maraudeur
              //
            }
        }
    }
  
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
  
  
    // ! trouver un moyen de modifier les array des units ennemy et player
    func handleUnitOnGrid(_ index:Int){
        //print("grid is touched !")
        switch self.currentSelected {
        /*case "visuTri":
            let tri = Tri()
            (blocks,enemy_units) = tri.unitPlacement(blocks,player,self,index,grid,"tri",enemy_units)*/
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

    func handleUnitSelection(_ sprite:String?){
        switch sprite {
        /*case "visuTri":
            // enleve le selected highlight si est deja sur le triangle
            if self.currentSelected==sprite!{
                surface.isHidden=true
                self.currentSelected = "none"
            }
            else{
                surface.position = visuTri.position
                surface.isHidden=false
                self.currentSelected=sprite!
            }*/
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
  
  
    func initPlayerAction(){
      run(SKAction.repeatForever(
        SKAction.sequence([
          SKAction.run({
            //print("startMode = ",self.startMode)
            if self.startMode == true {
              for unit in self.player_units{
                self.addPlayerProjectile(unit)
              }
            }
          }),
          SKAction.wait(forDuration: 1.0)
        ])
      ))
    }
  
    func initEnnemyAction(){
      run(SKAction.repeatForever(
        SKAction.sequence([
          SKAction.run({
            //print("startMode = ",self.startMode)
            if self.startMode == true {
             
              for unit in self.enemy_units{
                self.addEnemyProjectile(unit)
              }
            }
          }),
          SKAction.wait(forDuration: 1.0)
          ])
      ))
    }
  
    func startButtonAction(){
      // si bouton start
      // enleve le highlight
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
      // pour chaque sprite enemy
      // run SequenceForever(addEnemyProjectile(spriteEnemy.position))

      // on deselect le currentSelected
      // on fait generer des sprite par le triangle de droite
    }
  
    func gameOver(){
      startMode = false
      self.start_button.texture = SKTexture(imageNamed:"start")
      print("GAMEOVER ")
      player.money = 2000
      money.text = String(player.getMoney())
      placeEnemyUnit()
    }
  
    func addPlayerProjectile(_ unit:SKSpriteNode){
      if enemy_units.count <= 0{
        gameOver()
        return
      }
      else{
        let projectile = SKSpriteNode(imageNamed: "maraudeur-projectile")
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        if unit.name == "rec"{
          projectile.physicsBody?.categoryBitMask = PhysicsCategory.marauder_p
        }
        else if unit.name == "cer"{
          projectile.texture = SKTexture(imageNamed:"marine-projectile")
          projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
          projectile.physicsBody?.categoryBitMask = PhysicsCategory.marine_p
        }
        let target_unit = findTarget(unit, enemy_units)
        projectile.position = unit.position
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.tri
        projectile.physicsBody?.usesPreciseCollisionDetection = true

        let offset = target_unit.0.position - unit.position
        if offset.x < 0 { return }
        addChild(projectile)
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let real_dest = shootAmount + unit.position
        let distance = target_unit.1
        //calculate your new duration based on the distance
        let moveDuration = Double(0.01*distance)
        let actionMove = SKAction.move(to: real_dest, duration: moveDuration)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
      }
      return
    }
  
    func addEnemyProjectile(_ unit:SKSpriteNode){
      //print(player_units)
      if player_units.count <= 0{
        gameOver()
        return
      }
      else{
        let target_unit = findTarget(unit, player_units)
        let projectile = SKSpriteNode(imageNamed: "projectile")
        projectile.position = unit.position
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.cer
        //projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
        // pour utiliser un algo ameliore de detection de collision
        projectile.physicsBody?.usesPreciseCollisionDetection = true
      
        let offset = unit.position - target_unit.0.position
        // 4 - Bail out if you are shooting down or backwards
        if offset.x < 0 { return }
        addChild(projectile)
        let direction = offset.normalized()
        let real_dest = -(direction * 1000 - target_unit.0.position)
        let distance = target_unit.1
        //calculate your new duration based on the distance
        //let moveDuration = Double(0.01*distance)
        let moveDuration = Double(0.01*distance)


        //move the node
        let actionMove = SKAction.move(to: real_dest, duration: moveDuration)
        let actionMoveDone = SKAction.removeFromParent()
        
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
      }
      return
    }
  
    func init_scene(){
        background.position = CGPoint(x: size.width/2, y:size.height/2)
        background.size.width = size.width
        background.size.height = size.height
        background.zPosition = -0.5
        grid.position = CGPoint (x:frame.midX+30, y:frame.midY)
        grid.initValues(middle_x:frame.midX,middle_y:frame.midY)
        grid.zPosition = -0.1
        player.position = CGPoint(x: size.width * 0.05, y: size.height * 0.5)
        start_button.position = CGPoint(x: size.width * 0.07, y: size.height * 0.15)
        start_button.name = "start"
        ennemy.position = CGPoint(x: size.width * 0.92, y: size.height * 0.5)
        bar1.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        bar2.position = CGPoint(x: size.width * 0.24, y: size.height * 0.5)
        bar3.position = CGPoint(x: size.width * 0.84, y: size.height * 0.5)
      
        //visuTri.isUserInteractionEnabled = false
        surface.isHidden=true
        money.text = String(player.money)
        money.fontSize = 20
        money.fontColor = SKColor.yellow
        money.position = CGPoint(x: player.position.x+10, y: player.position.y + 50)
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        // si 2 objet de la scene rentre en collision on call un type SKPhysicsContactDelegate
        // et donc "self" voir extension
    }
  
    func placeEnemyUnit(){
        let enemy_map = [33]
        //let enemy_map = [33,26,19,12]
        for index in enemy_map{
            let tri = Tri()
            (blocks,enemy_units) = tri.placeEnemyUnit(blocks,self,index,grid,enemy_units)
        }
      }
  
  func projectileDidCollide(_ projectile: SKSpriteNode, _ unit: Unit,_ side: String) {
      //print("Hit")
    
      projectile.removeFromParent()
      unit.hb.gotHit(10)
      if unit.hb.hp <= 0{
        let index = grid.getIndexBlockTouched(unit.position,blocks)
        blocks[index].isFree = true
        blocks[index].unit_name = ""
        if side == "player"{
          player_units.remove(at:player_units.index(of:unit)!)
        }
        else if side == "enemy"{
          enemy_units.remove(at:enemy_units.index(of:unit)!)
        }
        unit.hb.removeFromParent()
        unit.removeFromParent()
        
        if player_units.count <= 0{
          gameOver()
          return
        }
      }
      //monster.removeFromParent()
    }
}

extension GameScene: SKPhysicsContactDelegate {
  // 2 objets physique sont rentrer en collision
  func didBegin(_ contact: SKPhysicsContact) {
    var _projectile: SKPhysicsBody
    var _unit: SKPhysicsBody
    
    if startMode == true{
      //projectile < cer
      if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
        _projectile = contact.bodyA
        _unit = contact.bodyB
      } else {
        _projectile = contact.bodyB
        _unit = contact.bodyA
      }
      // 2 - 5 = contact entre e_projectile et ennemy_unit
      // 2 - 7 = maraudeur touche par projectile
      // 5 -4... = enemy_unit contact avec le maraudeur_p
      // 7 -4... = m_unit contact avec le maraudeur_p
      
      if let projectile = _projectile.node as? SKSpriteNode, let node = _unit.node as? SKSpriteNode {
        if _projectile.categoryBitMask > 2{
          
          if _unit.categoryBitMask == PhysicsCategory.tri{
            if self.enemy_units.count > 0{
              let unit = getRightUnit(node.position, self.enemy_units)
              projectileDidCollide(projectile, unit,"enemy")
            }
          }
        }
        else if _projectile.categoryBitMask == PhysicsCategory.projectile{
          if _unit.categoryBitMask > 5 {
            
            if self.player_units.count > 0{
              let unit = getRightUnit(node.position, self.player_units)
              projectileDidCollide(projectile, unit,"player")
            }
            // defoncer le player
          }
        }
      }
    }
    // Assigne les bons objets au contact objets pour pouvoir les reutiliser apres
    //print("truc chelou",firstBody.categoryBitMask & PhysicsCategory.projectile)
    
    // Cas ou Projectile touche Player_unit seulement
    // if ((_projectile.categoryBitMask & PhysicsCategory.projectile != 0) &&
    //   (_unit.categoryBitMask & PhysicsCategory.cer != 0 || _unit.categoryBitMask & PhysicsCategory.rec != 0  )) {

    //}
  }
}
