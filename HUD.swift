import SpriteKit

class HUD: SKNode {
    private var movesLabel: SKLabelNode!
    private var goalLabel: SKLabelNode!
    private var movesLeft: Int
    private var goal: Int

    init(moves: Int, goal: Int) {
        self.movesLeft = moves
        self.goal = goal
        super.init()

        setupLabels()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLabels() {
        // Label voor het aantal zetten
        movesLabel = SKLabelNode(fontNamed: "Chalkduster")
        movesLabel.fontSize = 24
        movesLabel.fontColor = .white
        movesLabel.position = CGPoint(x: 0, y: -30) // Verlaag de y-positie
        movesLabel.text = "Moves Left: \(movesLeft)"
        addChild(movesLabel)

        // Label voor het doel
        goalLabel = SKLabelNode(fontNamed: "Chalkduster")
        goalLabel.fontSize = 24
        goalLabel.fontColor = .white
        goalLabel.position = CGPoint(x: 0, y: -50) // Verlaag de y-positie
        goalLabel.text = "Goal: \(goal) red fruits"
        addChild(goalLabel)
    }

    // Functie om aantal zetten te updaten
    func updateMovesLeft(_ moves: Int) {
        movesLeft = moves
        movesLabel.text = "Moves Left: \(movesLeft)"
    }

    // Functie om het doel te updaten
    func updateGoal(_ newGoal: Int) {
        goal = newGoal
        goalLabel.text = "Goal: \(goal) red fruits"
    }
}
