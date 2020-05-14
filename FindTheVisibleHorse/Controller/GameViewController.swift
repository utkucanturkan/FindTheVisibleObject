//
//  ViewController.swift
//  FindTheVisibleHorse
//
//  Created by Utkucan Türkan on 30.03.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {
    
    private struct GameConstraints {
        static fileprivate let defaultSoundRate = Float(1.0)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewGame()
    }

    deinit {
        print("GameViewController Deinitialization")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        overGame(isSuccess: false)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        switch UIDevice.current.orientation {
        case .portrait, .landscapeLeft, .landscapeRight:
            gameView.isRotated = true
        default:
            break
        }
    }
    
    // MARK: variables
    var configuration: GameConfiguration!
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var timerCounter = 0
    
    private var timer = Timer()
    
    private var audioPlayer: AVAudioPlayer!
    
    // MARK: Outlets
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var exitButton: UIImageView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showExitGameAlert(_:)))
            exitButton.isUserInteractionEnabled = true
            exitButton.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var gameView: GameView! {
        didSet {
            let panGesture = UIPanGestureRecognizer(target: gameView, action: #selector(GameView.performPanGesture(_:)))
            panGesture.maximumNumberOfTouches = 1
            panGesture.delegate = self
            gameView.addGestureRecognizer(panGesture)
            let tapGesture = UILongPressGestureRecognizer(target: gameView, action: #selector(GameView.performTapGesture(_:)))
            tapGesture.minimumPressDuration = 0
            tapGesture.delegate = self
            gameView.addGestureRecognizer(tapGesture)
            gameView.gameDelegate = self
        }
    }
    
    // MARK: Timer
    @objc private func updateTimer() {
        timerCounter += 1
        timerLabel?.text = "\(timerCounter)"
    }
    
    private func stopTimer() {
        timer.invalidate()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.updateTimer), userInfo: nil, repeats: true)
    }

    
    // MARK: Alerts
    @objc func showExitGameAlert(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == .ended {
            stopTimer()
            stopSound()
            showAlert(title: "End Game", message: "Do you really want to end the game?", type: "exit")
        }
    }
    
    
    // TODO: encapsulate alert implementation
    
    func showAlert(title: String, message: String, type: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default){ _ in
            if type == "exit" {
                self.navigationController?.popViewController(animated: true)
            } else if type == "newGame" {
                self.startNewGame()
            }
        })
        alert.addAction(UIAlertAction(title: "No", style: .cancel) { _ in
             if type == "newGame" {
                self.navigationController?.popViewController(animated: true)
            } else if type == "exit" {
                self.startTimer()
            }
        })
        self.present(alert, animated: true)
    }
}

extension GameViewController: GameDelegate {
    func playSound(fromPath path: URL, withRate rate: Float = GameConstraints.defaultSoundRate, repeat loop: Bool = false) {
        do {
            if audioPlayer == nil || (audioPlayer.url != nil && audioPlayer.url!.absoluteString != path.absoluteString) {
                audioPlayer = try AVAudioPlayer(contentsOf: path)
            }
            audioPlayer.enableRate = !(rate == GameConstraints.defaultSoundRate)
            audioPlayer.rate = rate
            audioPlayer.numberOfLoops = loop ? -1 : 0
            print("Rate; \(audioPlayer.rate)")
            audioPlayer.play()
        } catch  {
            print("Error; \(error)")
        }
    }
        
    func stopSound() {
        audioPlayer?.stop()
    }
    
    func overGame(isSuccess success: Bool) {
        stopTimer()
        stopSound()
        if success {
            //gameView.config.time = timerCounter
            showAlert(title: "Would you like to play again?", message: "You have found the image in \(timerCounter) seconds...", type: "newGame")
        }
    }
    
    func startNewGame() {
        timerCounter = 0
        gameView.config = configuration
        startTimer()
    }
}

extension GameViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let recognizers = gameView.gestureRecognizers {
            return recognizers.contains(gestureRecognizer) && recognizers.contains(otherGestureRecognizer)
        }
        return false
    }
}
