
import SpriteKit


extension GameScene{
  // Animations
  // run EnergyBar animation
  func runEnergyBar(){
    run(SKAction.repeatForever(
      SKAction.sequence([
        SKAction.run({
          if self.startMode == true {
            self.energyBar.upSize()
          }
        }),
        SKAction.wait(forDuration: 0.010)
        ])
    ))
  }

  // run Player Units attack animation
  func initPlayerAction(){
    run(SKAction.repeatForever(
      SKAction.sequence([
        SKAction.run({
          //print("startMode = ",self.startMode)
          if self.startMode == true {
            for unit in self.player_units{
              self.addPlayerProjectile(unit,false)
            }
          }
        }),
        SKAction.wait(forDuration: 1.0)
        ])
    ))
  }

  // run Enemy Units attack animation
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
  // ------------ //
}
