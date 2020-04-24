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
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        gameView.brain = GameBrain()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        switch UIDevice.current.orientation {
        case .portrait, .landscapeLeft, .landscapeRight:
            gameView.isRotated = true
        default:
            break
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        overGame()
    }
    
    
    private var timerCounter = 0
    
    private var timer = Timer()
    
    @IBOutlet weak var timerLabel: UILabel!
    
    private var audioPlayer: AVAudioPlayer!
    
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
    
    @objc func updateTimer() {
        timerCounter += 1
        timerLabel?.text = "\(timerCounter)"
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
    
    func overGame() {
        timer.invalidate()
        gameView.brain.time = timerCounter
        stopSound()
        print("Time; \(gameView.brain.time)")
    }
    
    func startGame() {
        timerCounter = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.updateTimer), userInfo: nil, repeats: true)
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
