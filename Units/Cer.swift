/// Copyright (c) 2018 Razeware LLC

import Foundation

class Cer: Unit {
  init(){
    super.init(name:"cer",life:50,cost:500)
  }
  
  required init?(coder aDecoder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }
}
