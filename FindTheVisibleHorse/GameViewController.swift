//
//  ViewController.swift
//  FindTheVisibleHorse
//
//  Created by Utkucan Türkan on 30.03.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UIGestureRecognizerDelegate
{
    override func viewDidLoad() {
        super.viewDidLoad()
        gameView.brain = GameBrain()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    private var timerCounter = 0
    private var timer = Timer()
    
    @objc func updateTimer() {
        timerCounter += 1
        timerLabel?.text = "\(timerCounter)"
    }
    
    @objc func stopTimer() {
        timer.invalidate()
        gameView.brain.time = timerCounter
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
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let recognizers = gameView.gestureRecognizers {
            return recognizers.contains(gestureRecognizer) && recognizers.contains(otherGestureRecognizer)
        }
        return false
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        switch UIDevice.current.orientation {
        case .portrait, .landscapeLeft, .landscapeRight:
            gameView.isRotated = true
        default:
            break
        }
    }
    
}

