/// Copyright (c) 2018 Razeware LLC


import Foundation
import SpriteKit

class Grid:SKSpriteNode {
  var rows:Int!
  var cols:Int!
  var blockSize:CGFloat!
  
  init(blockSize:CGFloat,rows:Int,cols:Int) {
    let texture = Grid.gridTexture(blockSize: blockSize,rows: rows, cols:cols)!
    self.blockSize = blockSize
    self.rows = rows
    self.cols = cols
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
    //bezierPath.lineWidth = 1.0
    bezierPath.stroke()
    context.addPath(bezierPath.cgPath)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return SKTexture(image: image!)
  }
                  //row: 1, col: 0
  func gridPosition(row:Int, col:Int) -> CGPoint {
    let offset = blockSize / 2.0
    let x = CGFloat(col) * blockSize - (blockSize * CGFloat(cols)) / 2.0 + offset
    print("x ",x)
    let y = CGFloat(rows - row - 1) * blockSize - (blockSize * CGFloat(rows)) / 2.0 + offset
    print("y ",y)
    return CGPoint(x:x, y:y)
  }
  
  required init?(coder aDecoder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }
}
