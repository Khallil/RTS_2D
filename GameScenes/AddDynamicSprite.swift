import SpriteKit

extension GameScene{
  func addPlayerProjectile(_ unit:SKSpriteNode,_ special_shoot: Bool){
    if enemy_units.count <= 0{
      gameOver(true)
      return
    }
    else{
      let projectile = SKSpriteNode(imageNamed: "maraudeur-projectile")
      projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/3)
      if unit.name == "rec"{
        if special_shoot == true{
          projectile.texture = SKTexture(imageNamed:"marau_big_bullet")
          projectile.size = projectile.texture!.size()
          //projectile.texture = SKTexture(imageNamed:"marau_big_bullet")

          projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/3)
          projectile.physicsBody?.categoryBitMask = PhysicsCategory.marauder_big
        }
        else{
          projectile.physicsBody?.categoryBitMask = PhysicsCategory.marauder_p
        }
      }
      else if unit.name == "cer"{
        if special_shoot == true{
          projectile.texture = SKTexture(imageNamed:"marine_big_bullet")
          projectile.size = projectile.texture!.size()
          projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/3)
          projectile.physicsBody?.categoryBitMask = PhysicsCategory.marine_big
        }
        else{
          projectile.texture = SKTexture(imageNamed:"marine-projectile")
          projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/3)
          projectile.physicsBody?.categoryBitMask = PhysicsCategory.marine_p
        }
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
      //calculate new duration based on the distance
      let moveDuration = Double(0.01*distance)
      let actionMove = SKAction.move(to: real_dest, duration: moveDuration)
      let actionMoveDone = SKAction.removeFromParent()
      projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    return
  }
  
  func addEnemyProjectile(_ unit:SKSpriteNode){
    if player_units.count <= 0{
      gameOver(false)
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
      
      // pour utiliser un algo amelior(e) de detection de collision
      projectile.physicsBody?.usesPreciseCollisionDetection = true
      
      let offset = unit.position - target_unit.0.position
      if offset.x < 0 { return }
      
      addChild(projectile)
      let direction = offset.normalized()
      let real_dest = -(direction * 1000 - target_unit.0.position)
      let distance = target_unit.1
      
      //calculate your new duration based on the distance
      let moveDuration = Double(0.01*distance)
      let actionMove = SKAction.move(to: real_dest, duration: moveDuration)
      let actionMoveDone = SKAction.removeFromParent()
      
      projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    return
  }
  

}
