class Chain: Hashable, CustomStringConvertible {
  var fruits: [fruit] = []
  var score = 0
  
  enum ChainType: CustomStringConvertible {
    case horizontal
    case vertical
    
    var description: String {
      switch self {
      case .horizontal: return "Horizontal"
      case .vertical: return "Vertical"
      }
    }
  }
  
  var chainType: ChainType
  init(chainType: ChainType) {
    self.chainType = chainType
  }
  
  func add(fruit: fruit) {
    fruits.append(fruit)
  }
  
  func firstfruit() -> fruit {
    return fruits[0]
  }
  
  func lastfruit() -> fruit {
    return fruits[fruits.count - 1]
  }
  
  var length: Int {
    return fruits.count
  }
  
  var description: String {
    return "type:\(chainType) fruits:\(fruits)"
  }
  
  var hashValue: Int {
    return fruits.reduce (0) { $0.hashValue ^ $1.hashValue }
  }
  
  static func ==(lhs: Chain, rhs: Chain) -> Bool {
    return lhs.fruits == rhs.fruits
  }
}
