import Foundation

let numColumns = 9
let numRows = 9
let numLevels = 4

class Level {
  private var fruits = Array2D<fruit>(columns: numColumns, rows: numRows)
  private var tiles = Array2D<Tile>(columns: numColumns, rows: numRows)
  private var possibleSwaps: Set<Swap> = []
  private var comboMultiplier = 0
  
  var targetScore = 0
  var maximumMoves = 0
  
  init(filename: String) {
    // 1
    guard let levelData = LevelData.loadFrom(file: filename) else { return }
    // 2
    let tilesArray = levelData.tiles
    // 3
    for (row, rowArray) in tilesArray.enumerated() {
      // 4
      let tileRow = numRows - row - 1
      // 5
      for (column, value) in rowArray.enumerated() {
        if value == 1 {
          tiles[column, tileRow] = Tile()
        }
      }
    }
    
    targetScore = levelData.targetScore
    maximumMoves = levelData.moves
  }
  
  func fruit(atColumn column: Int, row: Int) -> fruit? {
    precondition(column >= 0 && column < numColumns)
    precondition(row >= 0 && row < numRows)
    return fruits[column, row]
  }
  
  func tileAt(column: Int, row: Int) -> Tile? {
    precondition(column >= 0 && column < numColumns)
    precondition(row >= 0 && row < numRows)
    return tiles[column, row]
  }
  
  func shuffle() -> Set<fruit> {
    var set: Set<fruit>
    repeat {
      set = createInitialfruits()
      detectPossibleSwaps()
      print("possible swaps: \(possibleSwaps)")
    } while possibleSwaps.count == 0
    
    return set
  }
  
    private func createInitialfruits() -> Set<Fruit> {
        var set: Set<Fruit> = []
        
        for row in 0..<numRows {
            for column in 0..<numColumns {
                if tiles[column, row] != nil {
                    var fruitType: FruitType
                    repeat {
                        fruitType = FruitType.allCases.randomElement()!
                    } while (column >= 2 &&
                        fruits[column - 1, row]?.fruitType == fruitType &&
                        fruits[column - 2, row]?.fruitType == fruitType)
                        || (row >= 2 &&
                            fruits[column, row - 1]?.fruitType == fruitType &&
                            fruits[column, row - 2]?.fruitType == fruitType)
                    
                    let fruit = Fruit(column: column, row: row, fruitType: fruitType)
                    fruits[column, row] = fruit
                    
                    set.insert(fruit)
                }
            }
        }
        return set
    }

  
  private func hasChain(atColumn column: Int, row: Int) -> Bool {
    let FruitType = fruits[column, row]!.FruitType
    
    // Horizontal chain check
    var horizontalLength = 1
    
    // Left
    var i = column - 1
    while i >= 0 && fruits[i, row]?.FruitType == FruitType {
      i -= 1
      horizontalLength += 1
    }
    
    // Right
    i = column + 1
    while i < numColumns && fruits[i, row]?.FruitType == FruitType {
      i += 1
      horizontalLength += 1
    }
    if horizontalLength >= 3 { return true }
    
    // Vertical chain check
    var verticalLength = 1
    
    // Down
    i = row - 1
    while i >= 0 && fruits[column, i]?.FruitType == FruitType {
      i -= 1
      verticalLength += 1
    }
    
    // Up
    i = row + 1
    while i < numRows && fruits[column, i]?.FruitType == FruitType {
      i += 1
      verticalLength += 1
    }
    return verticalLength >= 3
  }
  
  func detectPossibleSwaps() {
    var set: Set<Swap> = []
    
    for row in 0..<numRows {
      for column in 0..<numColumns {
        if column < numColumns - 1,
          let fruit = fruits[column, row] {
          
          // Have a fruit in this spot? If there is no tile, there is no fruit.
          if let other = fruits[column + 1, row] {
            // Swap them
            fruits[column, row] = other
            fruits[column + 1, row] = fruit
            
            // Is either fruit now part of a chain?
            if hasChain(atColumn: column + 1, row: row) ||
              hasChain(atColumn: column, row: row) {
              set.insert(Swap(fruitA: fruit, fruitB: other))
            }
            
            // Swap them back
            fruits[column, row] = fruit
            fruits[column + 1, row] = other
          }
          
          if row < numRows - 1,
            let other = fruits[column, row + 1] {
            fruits[column, row] = other
            fruits[column, row + 1] = fruit
            
            // Is either fruit now part of a chain?
            if hasChain(atColumn: column, row: row + 1) ||
              hasChain(atColumn: column, row: row) {
              set.insert(Swap(fruitA: fruit, fruitB: other))
            }
            
            // Swap them back
            fruits[column, row] = fruit
            fruits[column, row + 1] = other
          }
        }
        else if column == numColumns - 1, let fruit = fruits[column, row] {
          if row < numRows - 1,
            let other = fruits[column, row + 1] {
            fruits[column, row] = other
            fruits[column, row + 1] = fruit
            
            // Is either fruit now part of a chain?
            if hasChain(atColumn: column, row: row + 1) ||
              hasChain(atColumn: column, row: row) {
              set.insert(Swap(fruitA: fruit, fruitB: other))
            }
            
            // Swap them back
            fruits[column, row] = fruit
            fruits[column, row + 1] = other
          }
        }
      }
    }
    
    possibleSwaps = set
  }
  
  func performSwap(_ swap: Swap) {
    let columnA = swap.fruitA.column
    let rowA = swap.fruitA.row
    let columnB = swap.fruitB.column
    let rowB = swap.fruitB.row
    
    fruits[columnA, rowA] = swap.fruitB
    swap.fruitB.column = columnA
    swap.fruitB.row = rowA
    
    fruits[columnB, rowB] = swap.fruitA
    swap.fruitA.column = columnB
    swap.fruitA.row = rowB
  }
  
  func isPossibleSwap(_ swap: Swap) -> Bool {
    return possibleSwaps.contains(swap)
  }
  
  private func detectHorizontalMatches() -> Set<Chain> {
    // 1
    var set: Set<Chain> = []
    // 2
    for row in 0..<numRows {
      var column = 0
      while column < numColumns-2 {
        // 3
        if let fruit = fruits[column, row] {
          let matchType = fruit.FruitType
          // 4
          if fruits[column + 1, row]?.FruitType == matchType &&
            fruits[column + 2, row]?.FruitType == matchType {
            // 5
            let chain = Chain(chainType: .horizontal)
            repeat {
              chain.add(fruit: fruits[column, row]!)
              column += 1
            } while column < numColumns && fruits[column, row]?.FruitType == matchType
            
            set.insert(chain)
            continue
          }
        }
        // 6
        column += 1
      }
    }
    return set
  }
  
  private func detectVerticalMatches() -> Set<Chain> {
    var set: Set<Chain> = []
    
    for column in 0..<numColumns {
      var row = 0
      while row < numRows-2 {
        if let fruit = fruits[column, row] {
          let matchType = fruit.FruitType
          
          if fruits[column, row + 1]?.FruitType == matchType &&
            fruits[column, row + 2]?.FruitType == matchType {
            let chain = Chain(chainType: .vertical)
            repeat {
              chain.add(fruit: fruits[column, row]!)
              row += 1
            } while row < numRows && fruits[column, row]?.FruitType == matchType
            
            set.insert(chain)
            continue
          }
        }
        row += 1
      }
    }
    return set
  }
  
  func removeMatches() -> Set<Chain> {
    let horizontalChains = detectHorizontalMatches()
    let verticalChains = detectVerticalMatches()
    
    removefruits(in: horizontalChains)
    removefruits(in: verticalChains)
    
    calculateScores(for: horizontalChains)
    calculateScores(for: verticalChains)
    
    return horizontalChains.union(verticalChains)
  }
  
  private func removefruits(in chains: Set<Chain>) {
    for chain in chains {
      for fruit in chain.fruits {
        fruits[fruit.column, fruit.row] = nil
      }
    }
  }
  
  func fillHoles() -> [[fruit]] {
    var columns: [[fruit]] = []
    // 1
    for column in 0..<numColumns {
      var array = [fruit]()
      for row in 0..<numRows {
        // 2
        if tiles[column, row] != nil && fruits[column, row] == nil {
          // 3
          for lookup in (row + 1)..<numRows {
            if let fruit = fruits[column, lookup] {
              // 4
              fruits[column, lookup] = nil
              fruits[column, row] = fruit
              fruit.row = row
              // 5
              array.append(fruit)
              // 6
              break
            }
          }
        }
      }
      // 7
      if !array.isEmpty {
        columns.append(array)
      }
    }
    return columns
  }
  
  func topUpfruits() -> [[fruit]] {
    var columns: [[fruit]] = []
    var FruitType: FruitType = .unknown
    
    for column in 0..<numColumns {
      var array: [fruit] = []
      
      // 1
      var row = numRows - 1
      while row >= 0 && fruits[column, row] == nil {
        // 2
        if tiles[column, row] != nil {
          // 3
          var newFruitType: FruitType
          repeat {
            newFruitType = FruitType.random()
          } while newFruitType == FruitType
          FruitType = newFruitType
          // 4
          let fruit = fruit(column: column, row: row, FruitType: FruitType)
          fruits[column, row] = fruit
          array.append(fruit)
        }
        
        row -= 1
      }
      // 5
      if !array.isEmpty {
        columns.append(array)
      }
    }
    return columns
  }
  
  private func calculateScores(for chains: Set<Chain>) {
    // 3-chain is 60 pts, 4-chain is 120, 5-chain is 180, and so on
    for chain in chains {
      chain.score = 60 * (chain.length - 2)
      comboMultiplier += 1
    }
  }
  
  func resetComboMultiplier() {
    comboMultiplier = 1
  }

}
