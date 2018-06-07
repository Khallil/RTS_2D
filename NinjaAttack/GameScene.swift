/// Copyright (c) 2018 Razeware LLC

import SpriteKit

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let monster   : UInt32 = 0b1       // 1
    static let projectile: UInt32 = 0b10      // 2
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}
#endif

class GameScene: SKScene {
  // 1
    let player = Player()
    let ennemy = SKSpriteNode(imageNamed: "ennemy")
    //var background = SKSpriteNode(imageNamed: "battleground2d")
    var start_button = SKSpriteNode(imageNamed: "start")
    var bar1 = SKSpriteNode(imageNamed: "bar")
    var bar2 = SKSpriteNode(imageNamed: "bar")
    var bar3 = SKSpriteNode(imageNamed: "bar")
    var visuTri = SKSpriteNode(imageNamed: "tri")
    var visuCer = SKSpriteNode(imageNamed: "cer")
    var visuRec = SKSpriteNode(imageNamed: "rec")
    var surface = SKSpriteNode(imageNamed: "square")
    var currentSelected = "none"
    var money = SKLabelNode(fontNamed: "Athens Classic")
    var blocks = getNewBlocks(6, 6)
    var startMode = false
    var enemy_units:Array<SKSpriteNode>=Array()
    var player_units:Array<SKSpriteNode>=Array()
    let grid = Grid(blockSize: 60.0, rows:6, cols:6)

    //Called immediately after a scene is presented by a view.
    override func didMove(to view: SKView) {
        init_scene()
        //screen size =  812 375
        addChild(money)
        addChild(grid)
        addChild(player)
        addChild(ennemy)
        addChild(start_button)
        addChild(bar1)
        addChild(bar2)
        addChild(bar3)
        addChild(visuTri)
        addChild(visuCer)
        addChild(visuRec)
        addChild(surface)
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
        print("touchedNode : ",touchedNode)

        // gere la selection des Units
        if touchedNode.count > 0{
          let sprite = touchedNode[0].name
          if sprite == "start"{
            self.gameStartMode()
          }
          else{
            self.handleUnitSelection(sprite)
          }
        }

        // gere le placement des units sur le grid
        if grid.isTouchInGrid(point: touchLocation){
            let index = grid.getIndexBlockTouched(touchLocation,blocks)
            self.handleUnitOnGrid(index,touchedNode[0])
        }
    }
  
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }

    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
  
  
    // ! trouver un moyen de modifier les array des units ennemy et player
    func handleUnitOnGrid(_ index:Int,_ node: SKNode){
        print("grid is touched !")
        switch self.currentSelected {
        case "visuTri":
            let tri = Tri()
            blocks = tri.unitPlacement(blocks,player,self,node,index,grid,"tri")
        case "visuRec":
            let rec = Rec()
            blocks = rec.unitPlacement(blocks,player,self,node,index,grid,"rec")
        case "visuCer":
            let cer = Cer()
            blocks = cer.unitPlacement(blocks,player,self,node,index,grid,"cer")
            player_units.append(cer)
        default:
            print("no item selected")
        }
        money.text = String(player.getMoney())
    }

    func handleUnitSelection(_ sprite:String?){
        switch sprite {
        case "visuTri":
            // enleve le selected highlight si est deja sur le triangle
            if self.currentSelected==sprite!{
                surface.isHidden=true
                self.currentSelected = "none"
            }
            else{
                surface.position = visuTri.position
                surface.isHidden=false
                self.currentSelected=sprite!
            }
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
  
    func gameStartMode(){
      // si bouton start
      surface.isHidden=true
      self.currentSelected = "none"
      startMode = true
      
      for unit in enemy_units{
        run(SKAction.repeatForever(
          SKAction.sequence([
            // lance addMonster
            SKAction.run({self.addProjectile(unit)}),
            // att 5sec
            SKAction.wait(forDuration: 5.0)
            ])
        ))
      }
      // pour chaque sprite enemy
      // run SequenceForever(addProjectile(spriteEnemy.position))

      // on deselect le currentSelected
      // on fait generer des sprite par le triangle de droite
    }
  
    func addProjectile(_ unit:SKSpriteNode){
      let projectile = SKSpriteNode(imageNamed: "projectile")
      projectile.position = unit.position
      projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
      projectile.physicsBody?.isDynamic = true
      projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
      //projectile.physicsBody?.contactTestBitMask = PhysicsCategory.monster
      //projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
      // pour utiliser un algo ameliorer de detection de collision
      //projectile.physicsBody?.usesPreciseCollisionDetection = true
      addChild(projectile)
    
      let target_unit = findTarget(unit, player_units)
      let direction = target_unit.position
      // 7 - Make it shoot far enough to be guaranteed off screen
      let shootAmount = direction * 1000
    
      // 8 - Add the shoot amount to the current position
      let realDest = shootAmount + projectile.position
    
      // 9 - Create the actions
      let actionMove = SKAction.move(to: realDest, duration: 2.0)
      let actionMoveDone = SKAction.removeFromParent()
      projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
      return
    }
  
    func addMonster() {
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "monster")

        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size) // 1
        // specify that we want the object to move by physics simulation
        monster.physicsBody?.isDynamic = true // 2
        //assign son bitmask = 0b1
        monster.physicsBody?.categoryBitMask = PhysicsCategory.monster
        //assign le bitmask avec lequel il peut avoir une collision = projectile = 0b10
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.projectile
        //choisis si on veut que l'objet soit affecter par la collision
        monster.physicsBody?.collisionBitMask = PhysicsCategory.none // 5
        // Determine where to spawn the monster along the X,Y axis
        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        //monster.position = CGPoint(x: 0 + monster.size.width/2, y: actualY)
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        // Add the monster to the scene
        addChild(monster)

        // Determine randoms speed of the monster
        //let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let actualDuration = 3

        // set un objectif de destination en x et en y
        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width, y: actualY),
                                       duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        monster.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
  
    func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
        print("Hit")
        //projectile.removeFromParent
        monster.removeFromParent()
    }

    func init_scene(){
        grid.position = CGPoint (x:frame.midX+30, y:frame.midY)
        grid.initValues(middle_x:frame.midX,middle_y:frame.midY)
        player.position = CGPoint(x: size.width * 0.05, y: size.height * 0.5)
        start_button.position = CGPoint(x: size.width * 0.07, y: size.height * 0.15)
        start_button.name = "start"
        ennemy.position = CGPoint(x: size.width * 0.92, y: size.height * 0.5)
        bar1.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        bar2.position = CGPoint(x: size.width * 0.24, y: size.height * 0.5)
        bar3.position = CGPoint(x: size.width * 0.84, y: size.height * 0.5)
        //background.position = CGPoint(x: size.width/2, y:size.height/2)
        visuTri.position = CGPoint(x: size.width * 0.17, y: size.height * 0.8)
        visuTri.zPosition = 0.1
        visuCer.position = CGPoint(x: size.width * 0.17, y: size.height * 0.5)
        visuCer.zPosition = 0.1
        visuRec.position = CGPoint(x: size.width * 0.17, y: size.height * 0.2)
        visuRec.zPosition = 0.1
        visuTri.name = "visuTri"
        visuCer.name = "visuCer"
        visuRec.name = "visuRec"
        visuTri.isUserInteractionEnabled = false
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
}

extension GameScene: SKPhysicsContactDelegate {
  // 2 objets physique sont rentrer en collision
  func didBegin(_ contact: SKPhysicsContact) {
    var firstBody: SKPhysicsBody
    var secondBody: SKPhysicsBody
    
    //0b1 monster 0b10 projectile
    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
      firstBody = contact.bodyA
      secondBody = contact.bodyB
    } else {
      firstBody = contact.bodyB
      secondBody = contact.bodyA
    }
    
    // Assigne les bons objets au contact objets pour pouvoir les reutiliser apres
    if ((firstBody.categoryBitMask & PhysicsCategory.monster != 0) &&
      (secondBody.categoryBitMask & PhysicsCategory.projectile != 0)) {
      if let monster = firstBody.node as? SKSpriteNode,
        let projectile = secondBody.node as? SKSpriteNode {
        projectileDidCollideWithMonster(projectile: projectile, monster: monster)
      }
    }
  }
}
