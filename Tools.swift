/// Copyright (c) 2018 Razeware LLC

import Foundation
import SpriteKit


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

func getNewBlocks(_ rows:Int, _ cols:Int)->Array<Block>{
  var blocks:Array<Block> = Array()
  for row in 0...rows{
    for col in 0...cols{
      let coor=Coor(row: row, col: col)
      let block = Block(coor: coor, unit_name: "", isFree: true)
      blocks.append(block)
    }
  }
  return blocks
}

func findTarget(_ unit:SKSpriteNode,_ player_units: Array<SKSpriteNode>)->SKSpriteNode{
  var min:CGFloat = 1000.0
  var target = player_units[0]
  for player_unit in player_units{
    let distance = sqrt( pow((unit.position.x - player_unit.position.x),2) + pow((unit.position.y - player_unit.position.y),2) )
    if distance < min{
      min = distance
      target = player_unit
    }
  }
  return target
}

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}
