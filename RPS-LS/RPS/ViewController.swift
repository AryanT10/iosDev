//Name: ARYAN TUWAR (112137229)
//Date: June 4, 2024


import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var rockButton: UIButton!
    @IBOutlet weak var paperButton: UIButton!
    @IBOutlet weak var scissorsButton: UIButton!
    // Added lizardButton and spockButton (UIButton!)
    @IBOutlet weak var lizardButton: UIButton!
    @IBOutlet weak var spockButton: UIButton!
    // Added winLabel,drawLabel and lossLabel (UILabel!)
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var drawLabel: UILabel!
    @IBOutlet weak var lossLabel: UILabel!
    
    
    @IBOutlet weak var playAgainButton: UIButton!
    
    // Added count system for win, draw or loss. Variables to keep track of scores
    var winCount = 0
    var drawCount = 0
    var lossCount = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize UI to start state
        updateUI(forState: .start)
    }
    // Actions for each gesture button
    @IBAction func rockChosen(_ sender: Any) {
        play(userSign: .rock)
    }
    
    @IBAction func paperChosen(_ sender: Any) {
        play(userSign: .paper)
    }
    
    @IBAction func scissorsChosen(_ sender: Any) {
        play(userSign: .scissors)
    }
    
    // Added lizardCHosen function and spockChosen
    @IBAction func lizardChosen(_ sender: Any) {
        play(userSign: .lizard)
    }
    
    @IBAction func spockChosen(_ sender: Any) {
        play(userSign: .spock)
    }
    
    // Action for Play Again button
    @IBAction func playAgain(_ sender: Any) {
        updateUI(forState: .start)
    }
    // Function to update the UI based on the game state
    func updateUI(forState state: GameState) {
        statusLabel.text = state.status

        switch state {
        case .start:
            // Reset UI to start state
            view.backgroundColor = .gray
            
            signLabel.text = "👽"
            playAgainButton.isHidden = true
            
            // Ensure all gesture buttons are visible and enabled
            rockButton.isHidden = false
            paperButton.isHidden = false
            scissorsButton.isHidden = false
            // Added lizardButton state and spockButton state
            lizardButton.isHidden = false
            spockButton.isHidden = false

            
            rockButton.isEnabled = true
            paperButton.isEnabled = true
            scissorsButton.isEnabled = true
            lizardButton.isEnabled = true
            spockButton.isEnabled = true
            
        // Update UI for win state
        case .win:
            view.backgroundColor = UIColor(red: 0.651, green: 0.792, blue: 0.651, alpha: 1)
            winCount += 1
            winLabel.text = "\(winCount)"
            
        // Update UI for loss state
        case .lose:
            view.backgroundColor = UIColor(red: 0.851, green: 0.424, blue: 0.412, alpha: 1)
            lossCount += 1
            lossLabel.text = "\(lossCount)"
            
        // Update UI for draw state
        case .draw:
            view.backgroundColor = UIColor(red: 0.663, green: 0.663, blue: 0.663, alpha: 1)
            drawCount += 1
            drawLabel.text = "\(drawCount)"
        }
    }

    // Function to handle the game logic
    func play(userSign: Sign) {
        let computerSign = randomSign()
        
        let gameState = userSign.gameState(against: computerSign)
        updateUI(forState: gameState)
        
        signLabel.text = computerSign.emoji
        
        // Hide and disable all gesture buttons initially
        rockButton.isHidden = true
        paperButton.isHidden = true
        scissorsButton.isHidden = true
        lizardButton.isHidden = true
        spockButton.isHidden = true

        rockButton.isEnabled = false
        paperButton.isEnabled = false
        scissorsButton.isEnabled = false
        lizardButton.isEnabled = false
        spockButton.isEnabled = false
        
        switch userSign {
        case .rock:
            rockButton.isHidden = false
        case .paper:
            paperButton.isHidden = false
        case .scissors:
            scissorsButton.isHidden = false
        case .lizard:
            lizardButton.isHidden = false
        case .spock:
            spockButton.isHidden = false
        }
        
        playAgainButton.isHidden = false
    }
}

