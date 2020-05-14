//
//  GameView.swift
//  FindTheVisibleHorse
//
//  Created by Utkucan Türkan on 4.04.2020.
//  Copyright © 2020 Utkucan Türkan. All rights reserved.
//

import UIKit

protocol GameDelegate {
    func startNewGame()
    func overGame(isSuccess success: Bool)
    func stopSound()
    func playSound(fromPath path: URL, withRate rate: Float, repeat loop: Bool)
}

class GameView: UIView {
        
    private struct GameConstraints {
        static fileprivate let offset = CGFloat(10)
        static fileprivate let defaultSoundRate = Float(1.0)
        static fileprivate let maxAudioRate: Float = 1.5
        static fileprivate let minAudioRate: Float = 0.5
    }
    
    var config: GameConfiguration! {
        didSet {
            setup()
            setNeedsLayout()
        }
    }
    
    var gameDelegate: GameDelegate!
    
    var time = 0
    
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
           
    private var targetView: UIImageView!
    
    private var isTargetviewFound = false {
        didSet {
            if isTargetviewFound {
                targetView.isHidden = false
                gameDelegate.overGame(isSuccess: true)
                setEnableAllGestureRecognizers(to: false)
                gameDelegate.playSound(fromPath: config.successSoundPath, withRate: GameConstraints.defaultSoundRate, repeat: false)
            }
        }
    }
    
    private func setup() {
        setEnableAllGestureRecognizers(to: true)
        if targetView == nil {
            createTargetView()
        } else {
            targetView.isHidden = true
            targetView.randomCenterPoint(in: self.bounds)
            targetView.image = UIImage(named: config.theme.randomTargetImageName)
        }
    }
    
    private func createTargetView() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: config.targetViewDimensions.0, height: config.targetViewDimensions.1))
        imageView.image = UIImage(named: config.theme.randomTargetImageName)
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        imageView.randomCenterPoint(in: self.bounds)
        targetView = imageView
    }
    
    private func setEnableAllGestureRecognizers(to value: Bool) {
        self.gestureRecognizers?.forEach { $0.isEnabled = value }
    }
    
    @objc func performPanGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            let valueByRecognizer = calculateRateAndDistance(by: recognizer)
            gameDelegate.playSound(fromPath: config.distanceSoundPath, withRate: valueByRecognizer.rate, repeat: true)
        default:
            break
        }
    }
    
    @objc func performTapGesture(_ recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            let valuesByRecognizer = calculateRateAndDistance(by: recognizer)
            if valuesByRecognizer.distances.actual < config.halfOfMinDimension {
                isTargetviewFound = true
            } else {
                gameDelegate.playSound(fromPath: config.distanceSoundPath, withRate: valuesByRecognizer.rate, repeat: true)
            }
        default:
            break
        }
    }
    
    private func calculateRateAndDistance(by recognizer: UIGestureRecognizer) -> (rate: Float, distances: (actual: Double, valid: Double)) {
        let distances = measureDistances(from: recognizer.location(in: self), to: targetView.center)
        let rate = calculateNormalizedAudioRate(by: distances.valid, minimumDistance: config.halfOfMinDimension)
        return (rate, distances)
    }
    
    private func measureDistances(from point: CGPoint, to targetPoint: CGPoint ) -> (actual: Double, valid: Double) {
        let distance = point.euclideanDistance(to: targetPoint)
        let validDistance = distance - config.halfOfMinDimension
        return (distance, validDistance)
    }
    
    private func calculateNormalizedAudioRate(by distance: Double, minimumDistance minDistance: Double) -> Float {
        let hipotenus = Double(round(CGFloat(sqrt(self.bounds.width * self.bounds.width + self.bounds.height * self.bounds.height))))
        let normalization = (distance - minDistance)/(hipotenus - minDistance)
        return GameConstraints.maxAudioRate - ((GameConstraints.maxAudioRate-GameConstraints.minAudioRate)*Float(normalization) + GameConstraints.minAudioRate)
    }
        
    override func draw(_ rect: CGRect) {
        addSubview(targetView)
        self.backgroundColor = UIColor(patternImage: UIImage(named: config.theme.backgroundImageName)!)
        //print("subview; \(self.subviews.count)")
        //print("self.bounds; \(self.bounds)")
        //print("targetView bounds; \(targetView.bounds)")
        //print("targetView frame; \(targetView.frame)")
        //print("Layout Margins; \(targetView.layoutMargins)")
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
