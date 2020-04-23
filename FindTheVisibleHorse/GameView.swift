//
//  GameView.swift
//  FindTheVisibleHorse
//
//  Created by Utkucan Türkan on 4.04.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit
import AVFoundation

class GameView: UIView {
    
    private struct GameConstraints {
        static fileprivate let offset = CGFloat(10)
        static fileprivate let defaultSoundRate = Float(1.0)
        static fileprivate let maxAudioRate: Float = 1.5
        static fileprivate let minAudioRate: Float = 0.5
    }
    
    var brain = GameBrain() {
        didSet {
            setNeedsLayout()
        }
    }
    
    var isRotated = false {
        didSet {
            switch UIDevice.current.orientation {
            case .portrait:
                print("PORTRAIT")
                print("self.bounds; \(self.bounds)")
                print("targetView bounds; \(targetView.bounds)")
                print("targetView frame; \(targetView.frame)")
                //let newY = self.bounds.maxY - targetView.frame.origin.x - targetView.bounds.height
                break
            case .landscapeLeft:
                break
            case .landscapeRight:
                print("LANDSCAPE")
                print("self.bounds; \(self.bounds)")
                print("targetView bounds; \(targetView.bounds)")
                print("targetView frame; \(targetView.frame)")
                
                //let newX = self.bounds.width - targetView.bounds.height - targetView.frame.origin.y
                //targetView.frame.origin.y = 50
                //targetView.frame.origin.x = 50
                break
            default:
                break
            }
            setNeedsLayout()
        }
    }
        
    private var audioPlayer: AVAudioPlayer!
    
    private lazy var targetView: UILabel = createTargetView()
    
    private var isTargetviewFound = false {
        didSet {
            if isTargetviewFound {
                targetView.isHidden = false
                performSelector(onMainThread: #selector(GameViewController.stopTimer), with: nil, waitUntilDone: false)
                self.gestureRecognizers?.forEach { $0.isEnabled = false }
                playSound(fromPath: brain.successSoundPath)
            }
        }
    }
    
    private func createTargetView() -> UILabel {
        let label = UILabel()
        label.text = brain.emoji
        label.font = UIFont(name: "Helvetica", size: CGFloat(brain.fontSize))
        label.isHidden = true
        label.sizeToFit()
        label.randomCenterPoint(in: self.bounds)
        return label
    }
    
    @objc func performPanGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            let distances = measureDistances(from: recognizer.location(in: self), to: targetView.center)
            let rate = calculateNormalizedAudioRate(by: distances.valid, minimumDistance: brain.halfOfMinDimension)
            playSound(fromPath: brain.distanceSoundPath, withRate: rate, repeat: true)
        default:
            break
        }
    }
    
    @objc func performTapGesture(_ recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            let distances = measureDistances(from: recognizer.location(in: self), to: targetView.center)
            let rate = calculateNormalizedAudioRate(by: distances.valid, minimumDistance: brain.halfOfMinDimension )
            if distances.actual < brain.halfOfMinDimension {
                isTargetviewFound = true
            } else {
                playSound(fromPath: brain.distanceSoundPath, withRate: rate, repeat: true)
            }
        default:
            break
        }
    }
    
    private func measureDistances(from point: CGPoint, to targetPoint: CGPoint ) -> (actual: Double, valid: Double) {
        let distance = point.euclideanDistance(to: targetPoint)
        let validDistance = distance - brain.halfOfMinDimension
        return (distance, validDistance)
    }
    
    private func calculateNormalizedAudioRate(by distance: Double, minimumDistance minDistance: Double) -> Float {
        let hipotenus = Double(round(CGFloat(sqrt(self.bounds.width * self.bounds.width + self.bounds.height * self.bounds.height))))
        let normalization = (distance - minDistance)/(hipotenus - minDistance)
        return GameConstraints.maxAudioRate - ((GameConstraints.maxAudioRate-GameConstraints.minAudioRate)*Float(normalization) + GameConstraints.minAudioRate)
    }
    
    private func playSound(fromPath path: URL, withRate rate: Float = GameConstraints.defaultSoundRate, repeat loop: Bool = false) {
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
    
    override func draw(_ rect: CGRect) {
        addSubview(targetView)
        self.backgroundColor = UIColor(patternImage: UIImage(named: "pattern.png")!)
        print("subview; \(self.subviews.count)")
        print("self.bounds; \(self.bounds)")
        print("targetView bounds; \(targetView.bounds)")
        print("targetView frame; \(targetView.frame)")
    }
}

extension CGPoint {
    func euclideanDistance(to secondPoint: CGPoint) -> Double {
        let xDistance = self.x - secondPoint.x
        let yDistance = self.y - secondPoint.y
        return Double(round(CGFloat(sqrt(xDistance * xDistance + yDistance * yDistance))))
    }
}

extension UIView {
    func randomCenterPoint(in frame: CGRect, offset space: CGFloat = 5) {
        let absoluteSpace = abs(space)
        let randomX = Int.random(in: Int(absoluteSpace)...Int(frame.maxX - self.bounds.midX - absoluteSpace))
        let randomY = Int.random(in: Int(absoluteSpace)...Int(frame.maxY - self.bounds.midY - absoluteSpace))
        self.center = CGPoint(x: randomX, y: randomY)
    }
}
