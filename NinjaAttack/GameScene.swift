/// Copyright (c) 2018 Razeware LLC


import SpriteKit

struct PhysicsCategory {
  static let none      : UInt32 = 0
  static let all       : UInt32 = UInt32.max
  static let monster   : UInt32 = 0b1       // 1
  static let projectile: UInt32 = 0b10      // 2
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func /(point: CGPoint, scalar: CGFloat) -> CGPoint {
  return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
  return CGFloat(sqrtf(Float(a)))
}
#endif

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}
public var screenWidth: CGFloat {
  return UIScreen.main.bounds.width
}

// Screen height.
public var screenHeight: CGFloat {
  return UIScreen.main.bounds.height
}

class GameScene: SKScene {
  // 1
  let player = Player()
  let ennemy = SKSpriteNode(imageNamed: "ennemy")
  var background = SKSpriteNode(imageNamed: "battleground2d")
  var bar1 = SKSpriteNode(imageNamed: "bar")
  var bar2 = SKSpriteNode(imageNamed: "bar")
  var bar3 = SKSpriteNode(imageNamed: "bar")
  var visuTri = SKSpriteNode(imageNamed: "tri")
  var visuCer = SKSpriteNode(imageNamed: "cer")
  var visuRec = SKSpriteNode(imageNamed: "rec")
  var surface = SKSpriteNode(imageNamed: "square")
  var currentSelected = "none"
  
  let grid = Grid(blockSize: 60.0, rows:6, cols:6)

  //Called immediately after a scene is presented by a view.
  override func didMove(to view: SKView) {
    //screen size =  812 375
   
    grid.position = CGPoint (x:frame.midX+30, y:frame.midY)
    
    player.position = CGPoint(x: size.width * 0.05, y: size.height * 0.5)
    ennemy.position = CGPoint(x: size.width * 0.92, y: size.height * 0.5)
    //backgroundColor = SKColor.white
    bar1.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
    bar2.position = CGPoint(x: size.width * 0.24, y: size.height * 0.5)
    bar3.position = CGPoint(x: size.width * 0.84, y: size.height * 0.5)
    background.position = CGPoint(x: size.width/2, y:size.height/2)
    visuTri.position = CGPoint(x: size.width * 0.17, y: size.height * 0.8)
    visuTri.zPosition = 0.1
    visuCer.position = CGPoint(x: size.width * 0.17, y: size.height * 0.5)
    visuCer.zPosition = 0.1
    visuRec.position = CGPoint(x: size.width * 0.17, y: size.height * 0.2)
    visuRec.zPosition = 0.1
    visuTri.name = "tri"
    visuCer.name = "cer"
    visuRec.name = "rec"
    visuTri.isUserInteractionEnabled = false
    surface.isHidden=true
    
    addChild(grid)
    //addChild(background)
    addChild(player)
    addChild(ennemy)
    addChild(bar1)
    addChild(bar2)
    addChild(bar3)
    addChild(visuTri)
    addChild(visuCer)
    addChild(visuRec)
    addChild(surface)

    physicsWorld.gravity = .zero
    // si 2 objet de la scene rentre en collision on call un type SKPhysicsContactDelegate
    // donc "self" voir extension
    physicsWorld.contactDelegate = self
    
    grid.setXYsquare(middle_x:frame.midX,middle_y:frame.midY)
      //x_ left = (x_size / 2) - sizeblock * ( n_block / 2)
    /*x_left = 218
    x_right = 580
    y_up = 384
    y_down = 26
    */
    
    // gere le pop de monstre a l'infini
    /*run(SKAction.repeatForever(
      SKAction.sequence([
        // lance addMonster
        SKAction.run(addMonster),
        // att 5sec
        SKAction.wait(forDuration: 5.0)
        ])
    ))*/
 
    //let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
    //backgroundMusic.autoplayLooped = true
    //addChild(backgroundMusic)
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
    var block = Block()
    
    if touchedNode.count > 0{
      let sprite = touchedNode[0].name
      switch sprite {
          case "tri":
            print("touched tri")
            if !player.buyUnit(cost: 100){
              print("not enough money !")
            }
            else{
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
              //tri.position = grid.gridPosition(row: 1, col: 0)
              //tri.position.x = frame.midX + tri.position.x
              //tri.position.y = frame.midY + tri.position.y
              //tri.spawn(scene: self, position: tri.position)
            }
        
          // cree l'objet dans le jeu objet tri (voir comment faire cohabiter plusieurs instances)
          case "rec":
            surface.position = visuRec.position
            surface.isHidden=false
            self.currentSelected=sprite!
            //addChild(surface)
            print("touched rec")
          case "cer":
            surface.position = visuCer.position
            surface.isHidden=false
            self.currentSelected=sprite!
            //addChild(surface)
            print("touched cer")
          default:
            print("none sprite selected")
        }
    }
      
    if grid.isTouchInGrid(point: touchLocation){
        
        print("grid is touched !")
        block = grid.getBlockTouched(point:touchLocation)
        let tri = Tri()
        switch self.currentSelected {
            case "tri":
                tri.position = grid.gridPosition(row: block.row+1, col: block.col+1)
                tri.spawn(scene: self, position: tri.position)
            default:
                print("no item selected")
        }
    }
  
    // gere le cas si le touch est derriere le player projectile.p = player.p
    let offset = touchLocation - player.position
    if offset.x < 0 { return }
    
    // run le pew pew son
    //run(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
    // get la position du toucher
    
    // Create Sprite 2 ( Projectile)
    let projectile = SKSpriteNode(imageNamed: "projectile")
    projectile.position = player.position
    projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
    projectile.physicsBody?.isDynamic = true
    projectile.physicsBody?.categoryBitMask = PhysicsCategory.projectile
    projectile.physicsBody?.contactTestBitMask = PhysicsCategory.monster
    projectile.physicsBody?.collisionBitMask = PhysicsCategory.none
    // pour utiliser un algo ameliorer de detection de collision
    projectile.physicsBody?.usesPreciseCollisionDetection = true
    addChild(projectile)
    
    // 6 - Get the direction of where to shoot
    
    let direction = offset.normalized()
    print(direction.x,direction.y)
    // 7 - Make it shoot far enough to be guaranteed off screen
    let shootAmount = direction * 1000
    
    // 8 - Add the shoot amount to the current position
    let realDest = shootAmount + projectile.position
    
    // 9 - Create the actions
    let actionMove = SKAction.move(to: realDest, duration: 2.0)
    let actionMoveDone = SKAction.removeFromParent()
    projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
  }
  
  func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
  }
  
  func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
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
  
  func resetCurrentSelected(){
    
  }
  
  func projectileDidCollideWithMonster(projectile: SKSpriteNode, monster: SKSpriteNode) {
    print("Hit")
    //projectile.removeFromParent
    monster.removeFromParent()
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
  }}
