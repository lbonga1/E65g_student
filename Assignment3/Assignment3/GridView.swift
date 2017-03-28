//
//  GridView.swift
//  Assignment3
//
//  Created by Lauren Bongartz on 3/26/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {

    @IBInspectable var size: Int = 20 {
        didSet {
            grid = Grid(size, size)
        }
    }
    var grid = Grid(3,3)
    @IBInspectable var livingColor = UIColor.darkGray
    @IBInspectable var emptyColor = UIColor.gray
    @IBInspectable var bornColor = UIColor.black
    @IBInspectable var diedColor = UIColor.lightGray
    @IBInspectable var gridColor = UIColor.black
    @IBInspectable var gridWidth: CGFloat = 1.0
    
    override func draw(_ rect: CGRect) {
        
        let gridSize = CGSize(
            width: rect.size.width / CGFloat(size - 1),
            height: rect.size.height / CGFloat(size - 1)
        )
        let base = rect.origin
        (0 ..< size).forEach { i in
            (0 ..< size).forEach { j in
                let origin = CGPoint(
                    x: base.x + (CGFloat(i) * gridSize.width),
                    y: base.y + (CGFloat(j) * gridSize.height)
                )
                let subRect = CGRect(
                    origin: origin,
                    size: gridSize
                )
                
                drawCircle(row: i, col: j, rect: subRect)
            }
        }
        
        (0..<size).forEach {
        drawLine(start: CGPoint(x: CGFloat($0)/CGFloat(size - 1) * rect.size.width, y: 0.0),
                 end: CGPoint(x: CGFloat($0)/CGFloat(size - 1) * rect.size.width, y: rect.size.height))
        
        drawLine(start: CGPoint(x: 0.0, y: CGFloat($0)/CGFloat(size - 1) * rect.size.height),
                 end: CGPoint(x: rect.size.width, y: CGFloat($0)/CGFloat(size - 1) * rect.size.height))
        
        }
        
    }
    
    func drawLine(start:CGPoint, end:CGPoint) {
        //create the path
        let path = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        path.lineWidth = gridWidth
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        path.move(to: start)
        
        //add a point to the path at the end of the stroke
        path.addLine(to: end)
        
        //draw the stroke
        gridColor.setStroke()
        path.stroke()
    }
    
    func drawCircle(row: Int, col: Int, rect:CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        
        switch grid._cells[row][col].state {
        case .empty:
            emptyColor.setFill()
        case .alive:
            livingColor.setFill()
        case .born:
            bornColor.setFill()
        case .died:
            diedColor.setFill()
        default:
            break
        }
        path.fill()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
        
        grid._cells[(lastTouchedPosition?.row)!][(lastTouchedPosition?.col)!].state = (grid._cells[(lastTouchedPosition?.row)!][(lastTouchedPosition?.col)!].state.toggle(value: (grid._cells[lastTouchedPosition!.row][lastTouchedPosition!.col].state)))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
        
        grid._cells[(lastTouchedPosition?.row)!][(lastTouchedPosition?.col)!].state = (grid._cells[(lastTouchedPosition?.row)!][(lastTouchedPosition?.col)!].state.toggle(value: (grid._cells[lastTouchedPosition!.row][lastTouchedPosition!.col].state)))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
    }
    
    // Updated since class
    typealias Position = (row: Int, col: Int)
    var lastTouchedPosition: Position?
    
    func process(touches: Set<UITouch>) -> Position? {
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        
        setNeedsDisplay()
        return pos
    }
    
    func convert(touch: UITouch) -> Position {
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let row = touchY / gridHeight * CGFloat(size)
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(size)
        let position = (row: Int(row), col: Int(col))
        return position
    }

}
