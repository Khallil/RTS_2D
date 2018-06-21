/// Copyright (c) 2018 Razeware LLC

import Foundation
import SpriteKit

struct Coor{
  var row:Int
  var col:Int
}

struct Block{
  var coor:Coor
  var position:CGPoint
  var unit_name:String
  var isFree:Bool
}

class Grid:SKSpriteNode {
  var rows:Int!
  var cols:Int!
  var blockSize:CGFloat!
  var x_right:CGFloat
  var x_left: CGFloat
  var y_down:CGFloat
  var y_up:CGFloat
  var dfs_x:CGFloat
  var dfs_y:CGFloat
  var middle_x:CGFloat
  var middle_y:CGFloat
  
  init(blockSize:CGFloat,rows:Int,cols:Int) {
    let texture = Grid.gridTexture(blockSize: blockSize,rows: rows, cols:cols)!
    self.blockSize = blockSize
    self.rows = rows
    self.cols = cols
    self.x_left = 0
    self.x_right = 0
    self.y_up = 0
    self.y_down = 0
    self.dfs_x = 0.0
    self.dfs_y = 0.0
    self.middle_x = 0.0
    self.middle_y = 0.0
    super.init(texture: texture, color:SKColor.clear, size: texture.size())
  }
  
  class func gridTexture(blockSize:CGFloat,rows:Int,cols:Int) -> SKTexture? {
    // Add 1 to the height and width to ensure the borders are within the sprite
    let size = CGSize(width: CGFloat(cols)*blockSize+1.0, height: CGFloat(rows)*blockSize+1.0)
    UIGraphicsBeginImageContext(size)
    
    guard let context = UIGraphicsGetCurrentContext() else {
      return nil
    }
    let bezierPath = UIBezierPath()
    let offset:CGFloat = 0.5
    // Draw vertical lines
    for i in 0...cols {
      let x = CGFloat(i)*blockSize + offset
      bezierPath.move(to: CGPoint(x: x, y: 0))
      bezierPath.addLine(to: CGPoint(x: x, y: size.height))
    }
    // Draw horizontal lines
    for i in 0...rows {
      let y = CGFloat(i)*blockSize + offset
      bezierPath.move(to: CGPoint(x: 0, y: y))
      bezierPath.addLine(to: CGPoint(x: size.width, y: y))
    }
    
    SKColor.white.setStroke()
    bezierPath.lineWidth = 1.0
    bezierPath.stroke()
    context.addPath(bezierPath.cgPath)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return SKTexture(image: image!)
  }
  
  func gridPosition(row:Int, col:Int) -> CGPoint {
    let b_cols = (blockSize * CGFloat(cols)) / 2.0
    let b_rows = (blockSize * CGFloat(rows)) / 2.0
    let x = ((CGFloat(col) * blockSize - b_cols) + middle_x).rounded(.up)
    let y = ((CGFloat(row) * blockSize - b_rows) + (middle_y-30)).rounded(.up)
    return CGPoint(x:x, y:y)
  }
  
  func isTouchInGrid(point:CGPoint)-> Bool{
   if (x_left...x_right ~= point.x) && (y_down...y_up ~= point.y){
        return true
      }
      else{
        return false
      }
    }
  
  func getIndexBlockTouched(_ point:CGPoint,_ blocks:Array<Block>)-> Int{
    // get le tableau
    var i = 0
    let x_touch = point.x - self.dfs_x
    let y_touch = point.y - self.dfs_y
    let col = Int((x_touch / blockSize).rounded(.down) )
    let row = Int((y_touch / blockSize).rounded(.down))
    for block in blocks{
      if block.coor.row == row && block.coor.col == col{
        return i
      }
      i = i + 1
    }
    return -1
  }
  
  func initValues(middle_x:CGFloat,middle_y:CGFloat){
    let nb_rows = CGFloat(6/2)
    self.middle_y = middle_y
    self.middle_x = middle_x
    self.x_left = middle_x - blockSize * nb_rows + 30.0
    self.x_right = middle_x + blockSize * nb_rows + 30.0
    self.y_up = middle_y + (blockSize * nb_rows)
    self.y_down = middle_y - (blockSize * nb_rows)
    self.dfs_x =  (middle_x + 30.0)  - nb_rows * blockSize
    self.dfs_y =  middle_y - (nb_rows * blockSize)
  }
  
  required init?(coder aDecoder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }
}
