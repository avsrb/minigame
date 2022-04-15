//
//  ViewController.swift
//  Game
//
//  Created by Артём Серебряков on 14.04.22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var gameFieldView: GameFieldView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    private var isGameActive = false
    private var gameTimeLeft:TimeInterval = 0
    private var gameTimer: Timer?
    private var timer: Timer?
    private let displayDuration: TimeInterval = 2
    private var score = 0
    
    @IBAction func Changed(_ sender: UIStepper) {
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.minimumScaleFactor = 0.2
        timeLabel.numberOfLines = 0
        updateUI()
    }
    @IBAction func actionButtonStart(_ sender: UIButton) {
        if isGameActive {
            stopGame()
        } else {
            startGame()
        }
    }
    func objectTapped() {
        guard isGameActive else { return }
        repositionImageWithTimer()
        score += 1
    }
    
//    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var gameFieldView: UIView!
//    @IBOutlet weak var stepper: UIStepper!
//    @IBOutlet weak var buttonStart: UIButton!
//
//    private var isGameActive = false
//    private var gameTimeLeft:TimeInterval = 0
//    private var gameTimer: Timer?
    
    private func startGame() {
        score = 0
        repositionImageWithTimer()
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(gameTimerTick),
            userInfo: nil,
            repeats: true
        )
        gameTimeLeft = stepper.value
        isGameActive = true
        updateUI()
    }
    private func stopGame() {
        isGameActive = false
        updateUI()
        gameTimer?.invalidate()
        timer?.invalidate()
        scoreLabel.text = "Last result: \(score)"
    }
    
    private func repositionImageWithTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: displayDuration,
            target: self,
            selector: #selector(moveImage),
            userInfo: nil,
            repeats: true
        )
        timer?.fire()
    }
    
    private func updateUI() {
        gameFieldView.isShapeHidden = !isGameActive
        stepper.isEnabled = !isGameActive
        if isGameActive {
            timeLabel.text = "\(Int(gameTimeLeft)) sec left "
            buttonStart.setTitle("Stop", for: .normal)
        } else {
            timeLabel.text = "Time: \(Int(stepper.value)) sec"
            buttonStart.setTitle("Start", for: .normal)
        }
    }
    
    @objc private func gameTimerTick() {
        gameTimeLeft -= 1
        if gameTimeLeft <= 0 {
            stopGame()
        } else {
            updateUI()
        }
    }
    
    @objc private func moveImage() {
        gameFieldView.randomizeShapes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        gameFieldView.layer.borderWidth = 1
        gameFieldView.layer.borderColor = UIColor.gray.cgColor
        gameFieldView.layer.cornerRadius = 10
        updateUI()
        gameFieldView.shapeHitHandler = { [weak self] in
            self?.objectTapped()
        }
    
    }


}

