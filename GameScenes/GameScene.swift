
import SpriteKit

class GameScene: SKScene {
    let player = Player()
    let ennemy = SKSpriteNode(imageNamed: "ennemy")
    var background = SKSpriteNode(imageNamed: "grass_background")
    var start_button = SKSpriteNode(imageNamed: "start")
    var bar1 = SKSpriteNode(imageNamed: "bar")
    var bar2 = SKSpriteNode(imageNamed: "bar")
    var bar3 = SKSpriteNode(imageNamed: "bar")
    var energyBar = EnergyBar()
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
        addChild(background)
        addChild(money)
        energyBar.addOnScene(self)
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
        runEnergyBar()
    }
  
    // trigerred when the touch (click) happenned Set<UITouch>
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
          return
        }
        let touchLocation = touch.location(in: self)
        //print("Touch Location : ",touchLocation)
        let touchedNode = self.nodes(at: touchLocation)
      
        // If touch is on grid
        if grid.isTouchInGrid(point: touchLocation){
          let index = grid.getIndexBlockTouched(touchLocation,blocks)
          if startMode == false{
            self.handleUnitOnGrid(index)
          }
          else{
            bulletPowerOn(index)
          }
        }
        else{
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
        }
    }
  
    func gameOver(_ win:Bool){
      startMode = false
      self.start_button.texture = SKTexture(imageNamed:"start")
    
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, won: win)
        view?.presentScene(gameOverScene, transition: reveal)
        enemy_units.removeAll()
        player.money = player.max_money
        money.text = String(player.getMoney())
        placeEnemyUnit()
        energyBar.reset()
    }
  
    // Init EnemyUnits on the map
    func placeEnemyUnit(){
      let enemy_map = [34,29,22,16,11,4]
      for index in enemy_map{
        let tri = Tri()
        (blocks,enemy_units) = tri.placeEnemyUnit(blocks,self,index,grid,enemy_units)
      }
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
      
        surface.isHidden=true
        money.text = String(player.money)
        money.fontSize = 20
        money.fontColor = SKColor.yellow
        money.position = CGPoint(x: player.position.x+10, y: player.position.y + 50)
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
}


