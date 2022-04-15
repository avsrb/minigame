//
//  gameFieldView.swift
//  Game
//
//  Created by Артём Серебряков on 15.04.22.
//

import UIKit

@IBDesignable
class GameFieldView: UIView {
    @IBInspectable var shapeColor: UIColor = .red {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var sharePosition: CGPoint = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var shareSize: CGSize = CGSize(width: 40, height: 40) {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var isShapeHidden: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var shapeHitHandler: (() -> Void)?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard !isShapeHidden else {
            curPath = nil
            return
        }
        shapeColor.setFill()
        let path = getTrainglePath(in: CGRect(origin: sharePosition, size: shareSize))
        path.fill()
        curPath = path
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let curRath = curPath else { return }
        let hit = touches.contains(where: { touch -> Bool in
            let touchPoint = touch.location(in: self)
            return curRath.contains(touchPoint)
        })
        if hit {
            shapeHitHandler?()
        }
    }
    
    func randomizeShapes() {
        let maxX = bounds.maxX - shareSize.width
        let maxY = bounds.maxY - shareSize.height
        let x = CGFloat(arc4random_uniform(UInt32(maxX)))
        let y = CGFloat(arc4random_uniform(UInt32(maxY)))
        sharePosition = CGPoint(x: x, y: y)
    }
    
    private var curPath: UIBezierPath?
    private func getTrainglePath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 0
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.close()
        path.stroke()
        path.fill()
        
        return path
    }
}
