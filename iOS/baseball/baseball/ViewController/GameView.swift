//
//  GameView.swift
//  baseball
//
//  Created by 양준혁 on 2021/05/04.
//

import UIKit
import SnapKit

class GameView: UIView {
    
    private var baseLayer = CAShapeLayer()
    private var baseLineLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpBaseLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpBaseLayer()
    }
    
    func setUpBaseLayer() {
        let path = UIBezierPath()
        let centerX = CGFloat(bounds.size.width/2)
        let centerY = CGFloat(bounds.size.height/2)
        
        //홈베이스
        path.move(to: CGPoint(x: centerX+10, y: centerY+110))
        path.addLine(to: CGPoint(x: centerX+10, y: centerY+100))
        path.addLine(to: CGPoint(x: centerX, y: centerY+90))
        path.addLine(to: CGPoint(x: centerX-10, y: centerY+100))
        path.addLine(to: CGPoint(x: centerX-10, y: centerY+110))
        path.close()
        
        // 1루
        path.move(to: CGPoint(x: centerX+110, y: centerY))
        path.addLine(to: CGPoint(x: centerX+100, y: centerY-10))
        path.addLine(to: CGPoint(x: centerX+90, y: centerY))
        path.addLine(to: CGPoint(x: centerX+100, y: centerY+10))
        path.close()
        
        // 2루
        path.move(to: CGPoint(x: centerX, y: centerY-90))
        path.addLine(to: CGPoint(x: centerX+10, y: centerY-100))
        path.addLine(to: CGPoint(x: centerX, y: centerY-110))
        path.addLine(to: CGPoint(x: centerX-10, y: centerY-100))
        path.close()
        
        // 3루
        path.move(to: CGPoint(x: centerX-110, y: centerY))
        path.addLine(to: CGPoint(x: centerX-100, y: centerY+10))
        path.addLine(to: CGPoint(x: centerX-90, y: centerY))
        path.addLine(to: CGPoint(x: centerX-100, y: centerY-10))
        path.close()
        
        baseLayer.frame = self.bounds
        baseLayer.path = path.cgPath
        baseLayer.fillColor = UIColor.systemBackground.cgColor
        baseLayer.strokeColor = UIColor.gray.cgColor
        baseLayer.lineWidth = 1
        self.layer.addSublayer(baseLayer)
    }
    
    
//    override func draw(_ rect: CGRect) {
//        let path = UIBezierPath()
//        let path2 = UIBezierPath()
//        path.lineWidth = 2
//
//        // 이동경로 그리기
//        path.move(to: CGPoint(x: self.frame.width / 2, y: self.frame.height - 50))
//        path.addLine(to: CGPoint(x: self.frame.width/2 + 115, y: self.frame.height/2 ))
//        path.addLine(to: CGPoint(x: self.frame.width/2, y: 50))
//        path.addLine(to: CGPoint(x: self.frame.width/2 - 115, y: self.frame.height/2))
//        path.close()
//        UIColor.systemGray.set()
//        path.stroke()
//        
//        // 홈베이스 그리기
//        path2.move(to: CGPoint(x: 207, y: 248))
//        path2.addLine(to: CGPoint(x: 196, y: 268))
//        path2.addLine(to: CGPoint(x: 196, y: 286))
//        path2.addLine(to: CGPoint(x: 218, y: 286))
//        path2.addLine(to: CGPoint(x: 218, y: 268))
//        path2.close()
//
//        UIColor.systemBackground.set()
//        path2.fill()
//
//    }
}
