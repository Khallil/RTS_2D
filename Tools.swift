/// Copyright (c) 2018 Razeware LLC

import Foundation
import SpriteKit

struct PhysicsCategory {
  static let none      : UInt32 = 0
  static let all       : UInt32 = UInt32.max
  static let monster   : UInt32 = 0b1       // 1
  static let projectile: UInt32 = 0b10      // 2
  static let marauder_big: UInt32 = 0b11      // 3
  static let marine_big  : UInt32 = 0b100     // 4
  static let marauder_p       : UInt32 = 0b101     // 5
  static let marine_p       : UInt32 = 0b110     // 6
  static let tri       : UInt32 = 0b111     // 7
  static let cer     : UInt32 = 0b1000     // 8
  static let rec     : UInt32 = 0b1001     // 9
}

extension CGPoint {
  func length() -> CGFloat {
    return sqrt(x*x + y*y)
  }
  func normalized() -> CGPoint {
    return self / length()
  }
}

// Polymorphism for clean operations
#if !(arch(x86_64) || arch(arm64))
func sqrt(a: CGFloat) -> CGFloat {
  return CGFloat(sqrtf(Float(a)))
}
#endif

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
// -------------------

// Init blocks array
func getNewBlocks(_ rows:Int, _ cols:Int)->Array<Block>{
  var blocks:Array<Block> = Array()
  for row in 0...rows-1{
    for col in 0...cols-1{
      let coor=Coor(row: row, col: col)
      let block = Block(coor: coor,position:CGPoint(x:0.0,y:0.0), unit_name: "", isFree: true)
      blocks.append(block)
    }
  }
  return blocks
}

// Look for the closest target
func findTarget(_ my_unit:SKSpriteNode,_ units: Array<SKSpriteNode>)->(SKSpriteNode,CGFloat){
  var min:CGFloat = 100000000.0
  var target = units[0]
  // this function is not called if units.count <= 0 so it's safe
  for unit in units{
    let distance = sqrt( pow((my_unit.position.x - unit.position.x),2) + pow((my_unit.position.y - unit.position.y),2) )
    if distance < min{
      min = distance
      target = unit
    }
  }
  return (target,min)
}

// Return the right unit by comparing the position of units
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


