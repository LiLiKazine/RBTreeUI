//
//  TreeView.swift
//  RBTreeUI
//
//  Created by LiLi Kazine on 2019/3/5.
//  Copyright © 2019 LiLi Kazine. All rights reserved.
//

import UIKit

class TreeView<T: Comparable>: UIView {

    var tree: RBTree<T>
    init(tree: RBTree<T>, frame: CGRect) {
        self.tree = tree
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        Colors.grey.setFill()
        context.fill(rect)
        let queue = tree.printTreeWithColor()
        let height = log2(Double(queue.size+1))
        let sectorHeight = rect.height / CGFloat(height*2-1)
        var lastPoint: CGPoint? = nil
        var level = 0
        while !queue.isEmpty {
            let count = Int(pow(2.0, Double(level)))
            let sectorWidth = rect.width / CGFloat(count)
            let diameter = min(sectorWidth, sectorHeight)

            for i in 0..<count {
                let node = queue.pop()
                var center: CGPoint?
                if i == 0 {
                    if lastPoint == nil {
                        // root
                        center = CGPoint(x: rect.width/2, y: sectorHeight/2)
                        drawCircle(center: center!, radius: diameter/2, val: node?.val, red: node?.red, contex: context)
                        lastPoint = center
                    } else {
                        let offsetY = lastPoint!.y + sectorHeight * 2
                        center = CGPoint(x: rect.width/2 - CGFloat(count)/2*sectorWidth + sectorWidth/2, y: offsetY)
                        drawCircle(center: center!, radius: diameter/2, val: node?.val, red: node?.red, contex: context)
                        lastPoint = center
                    }
                } else {
                    let offsetX = lastPoint!.x + sectorWidth
                    center = CGPoint(x: offsetX, y: lastPoint!.y)
                    drawCircle(center: center!, radius: diameter/2, val: node?.val, red: node?.red, contex: context)
                    lastPoint = center
                }
                if i % 2 == 0 {
                    let pCenter = CGPoint(x: center!.x+diameter/2, y: center!.y-sectorHeight)
                    drawLine(from: center!, to: pCenter, color: Colors.blue, context: context)
                }
            }
            level += 1
        }
    }
    
    func drawLine(from a: CGPoint, to b: CGPoint, color: UIColor, context: CGContext)  {
        context.saveGState()
        let path = UIBezierPath()
        path.move(to: a)
        path.addLine(to: b)
        color.setStroke()
        path.lineWidth = 2
        path.stroke()
    }
    
    func drawCircle<T>(center: CGPoint, radius: CGFloat, val: T?, red: Bool?, contex: CGContext) {
        contex.saveGState()
        let path = UIBezierPath(ovalIn: CGRect(x: center.x-radius, y: center.y-radius, width: radius*2, height: radius*2))
        let color = red == true ? Colors.red : Colors.black
        color.setFill()
        path.fill()
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributes: [NSAttributedString.Key : Any] = [
            .paragraphStyle: paragraph,
            .font: UIFont.systemFont(ofSize: 12.0),
            .foregroundColor: UIColor.white
        ]
        var text = "nil"
        if let val = val {
            text = String(describing: val)
        }
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        attributedString.draw(in: CGRect(x: center.x-radius, y: center.y-radius, width: radius*2, height: radius*2))
        contex.restoreGState()
    }

}
