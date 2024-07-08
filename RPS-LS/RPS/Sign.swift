//Name: ARYAN TUWAR (112137229)
//Date: June 4, 2024


import Foundation

enum Sign {
    case rock
    case paper
    case scissors
    case lizard
    case spock
    // Property to return the emoji for each sign
    var emoji: String {
        switch self {
        case .rock: return "👊"
        case .paper: return "🤚"
        case .scissors: return "✌"
        case .lizard: return "🤏"
        case .spock: return "🖖"
        }
    }
    // Function to determine the game state (win, lose, draw) against an opponent's sign
    func gameState(against opponent: Sign) -> GameState {
        switch (self, opponent) {
        case (.rock, .scissors), (.rock, .lizard), // Rock beats Scissors and Lizard
             (.paper, .rock), (.paper, .spock), // Paper beats Rock and Spock
             (.scissors, .paper), (.scissors, .lizard), // Scissors beats Paper and Lizard
             (.lizard, .spock), (.lizard, .paper), // Lizard beats Spock and Paper
             (.spock, .scissors), (.spock, .rock): // Spock beats Scissors and Rock
            return .win
        case (.scissors, .rock), (.lizard, .rock), // Rock loses to Paper and Spock
             (.rock, .paper), (.spock, .paper), // Paper loses to Scissors and Lizard
             (.paper, .scissors), (.lizard, .scissors), // Scissors loses to Rock and Spock
             (.spock, .lizard), (.paper, .lizard), // Lizard loses to Rock and Scissors
             (.scissors, .spock), (.rock, .spock): // Spock loses to Paper and Lizard
            return .lose
        default:
            return .draw
        }
    }
}

// Function to generate a random sign
func randomSign() -> Sign {
    let sign = Int.random(in: 0...4)
    switch sign {
    case 0: return .rock
    case 1: return .paper
    case 2: return .scissors
    case 3: return .lizard
    default: return .spock
    }
}
