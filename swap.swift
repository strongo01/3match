struct Swap: CustomStringConvertible, Hashable {
  let fruitA: fruit
  let fruitB: fruit
  
  var hashValue: Int {
    return fruitA.hashValue ^ fruitB.hashValue
  }
  
  static func ==(lhs: Swap, rhs: Swap) -> Bool {
    return (lhs.fruitA == rhs.fruitA && lhs.fruitB == rhs.fruitB) ||
      (lhs.fruitB == rhs.fruitA && lhs.fruitA == rhs.fruitB)
  }
  
  init(fruitA: fruit, fruitB: fruit) {
    self.fruitA = fruitA
    self.fruitB = fruitB
  }
  
  var description: String {
    return "swap \(fruitA) with \(fruitB)"
  }
}
