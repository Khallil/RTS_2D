import SpriteKit

extension GameScene: SKPhysicsContactDelegate {
  
  func projectileDidCollide(_ projectile: SKSpriteNode, _ unit: Unit,_ side: String,_ hitPoint: Int) {
    projectile.removeFromParent()
    unit.hb.gotHit(hitPoint)
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
      
    }
  }
  
  // 2 objets physique sont rentrer en collision
  func didBegin(_ contact: SKPhysicsContact) {
    var _projectile: SKPhysicsBody
    var _unit: SKPhysicsBody
    
    if startMode == true{
      if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
        _projectile = contact.bodyA
        _unit = contact.bodyB
      } else {
        _projectile = contact.bodyB
        _unit = contact.bodyA
      }
      
      if let projectile = _projectile.node as? SKSpriteNode, let node = _unit.node as? SKSpriteNode {
        // cas Big Bullet contre Enemy
        if _projectile.categoryBitMask == 3 || _projectile.categoryBitMask == 4{
          if _unit.categoryBitMask == PhysicsCategory.tri{
            if self.enemy_units.count > 0{
              let unit = getRightUnit(node.position, self.enemy_units)
              projectileDidCollide(projectile, unit,"enemy",10)
            }
          }
        }  // cas Bullet contre Enemy
        else if _projectile.categoryBitMask == 5 || _projectile.categoryBitMask == 6{
          if _unit.categoryBitMask == PhysicsCategory.tri{
            if self.enemy_units.count > 0{
              let unit = getRightUnit(node.position, self.enemy_units)
              projectileDidCollide(projectile, unit,"enemy",3)
            }
          }
        } // cas Projectile contre Player
        else if _projectile.categoryBitMask == 2{
          if _unit.categoryBitMask > 7 {
            if self.player_units.count > 0{
              let unit = getRightUnit(node.position, self.player_units)
              projectileDidCollide(projectile, unit,"player",5)
            }
          }
        }
      }
    }
  }
  

}
