/// Copyright (c) 2018 Razeware LLC

import Foundation
import SpriteKit


func +(left: CGPoint, right: CGPoint) -> CGPoint {
  return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

prefix func -(point: CGPoint) -> CGPoint {
  return CGPoint(x:-point.x,y:-point.y)
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

func findTarget(_ my_unit:SKSpriteNode,_ units: Array<SKSpriteNode>)->(SKSpriteNode,CGFloat){
  var min:CGFloat = 1000.0
  var target = units[0]
  
  for unit in units{
    let distance = sqrt( pow((my_unit.position.x - unit.position.x),2) + pow((my_unit.position.y - unit.position.y),2) )
    if distance < min{
      min = distance
      target = unit
    }
  }
  return (target,min)
}

func getRightUnit(_ position:CGPoint,_ units: Array<Unit>)-> Unit{
  var units = units
  let _unit = units[0]
  for unit in units{
    let unit_position:CGPoint = CGPoint.init(x:unit.position.x.rounded(.up),y:unit.position.y.rounded(.up))
    let node_position:CGPoint = CGPoint.init(x:position.x.rounded(.up),y:position.y.rounded(.up))
    if unit_position == node_position{
      return unit
    }
  }
  return _unit
}

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  
  func normalized() -> CGPoint {
    return self / length()
  }
}
