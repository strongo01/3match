import SpriteKit

// MARK: - FruitType
enum FruitType: Int {
  
  case unknown = 0, croissant, cupcake, danish, donut, macaroon, sugarfruit
  
  var spriteName: String {
    let spriteNames = [
      "Croissant",
      "Cupcake",
      "Danish",
      "Donut",
      "Macaroon",
      "Sugarfruit"]
    
    return spriteNames[rawValue - 1]
  }
  
  var highlightedSpriteName: String {
    return spriteName + "-Highlighted"
  }
  
  static func random() -> FruitType {
    return FruitType(rawValue: Int(arc4random_uniform(6)) + 1)!
  }
}

// MARK: - fruit
class fruit: CustomStringConvertible, Hashable {
  
  var hashValue: Int {
    return row * 10 + column
  }
  
  static func ==(lhs: fruit, rhs: fruit) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
    
  }
  
  var description: String {
    return "type:\(FruitType) square:(\(column),\(row))"
  }
  
  var column: Int
  var row: Int
  let FruitType: FruitType
  var sprite: SKSpriteNode?
  
  init(column: Int, row: Int, FruitType: FruitType) {
    self.column = column
    self.row = row
    self.FruitType = FruitType
  }
}
