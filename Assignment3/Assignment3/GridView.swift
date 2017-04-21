//
//  GridView.swift
//  Assignment3
//
//  Created by Lauren Bongartz on 3/26/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {

    @IBInspectable var livingColor = UIColor.darkGray
    @IBInspectable var emptyColor = UIColor.clear
    @IBInspectable var bornColor = UIColor.black
    @IBInspectable var diedColor = UIColor.lightGray
    @IBInspectable var gridColor = UIColor.black
    @IBInspectable var gridWidth: CGFloat = 1.0
    // Updated since class
    let gridSize = StandardEngine.engine.grid.size
    
    override func draw(_ rect: CGRect) {
        drawOvals(rect)
        drawLines(rect)
    }
    
    func drawOvals(_ rect: CGRect) {
        
        let size = CGSize(
            width: rect.size.width / CGFloat(gridSize.rows),
            height: rect.size.height / CGFloat(gridSize.cols)
        )
        let base = rect.origin
        (0 ..< gridSize.rows).forEach { i in
            (0 ..< gridSize.cols).forEach { j in
                // Inset the oval 2 points from the left and top edges
                let ovalOrigin = CGPoint(
                    x: base.x + (CGFloat(j) * size.width) + 2.0,
                    y: base.y + (CGFloat(i) * size.height + 2.0)
                )
                // Make the oval draw 2 points short of the right and bottom edges
                let ovalSize = CGSize(
                    width: size.width - 4.0,
                    height: size.height - 4.0
                )
                let ovalRect = CGRect( origin: ovalOrigin, size: ovalSize )
                drawOval(ovalRect, row: i, col: j)
            }
        }
    }
    
    func drawOval(_ ovalRect: CGRect, row:Int, col:Int) {
        let path = UIBezierPath(ovalIn: ovalRect)
      
        var fillColor: UIColor
        switch StandardEngine.engine.grid[(row, col)] {
        case .empty: fillColor = self.emptyColor
        case .alive: fillColor = self.livingColor
        case .born: fillColor = self.bornColor
        case .died: fillColor = self.diedColor
        }
        
        fillColor.setFill()
        path.fill()
    }
    
    func drawLines(_ rect: CGRect) {
        //create the path
        (0 ..< (gridSize.rows) + 1).forEach {
            drawLine(
                start: CGPoint(x: CGFloat($0)/CGFloat(gridSize.rows) * rect.size.width, y: 0.0),
                end:   CGPoint(x: CGFloat($0)/CGFloat(gridSize.rows) * rect.size.width, y: rect.size.height)
            )
            
            drawLine(
                start: CGPoint(x: 0.0, y: CGFloat($0)/CGFloat(gridSize.cols) * rect.size.height ),
                end: CGPoint(x: rect.size.width, y: CGFloat($0)/CGFloat(gridSize.cols) * rect.size.height)
            )
        }
    }
    
    func drawLine(start:CGPoint, end: CGPoint) {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)

        StandardEngine.engine.grid[(lastTouchedPosition?.row)!,(lastTouchedPosition?.col)!] = (StandardEngine.engine.grid[(lastTouchedPosition?.row)!,(lastTouchedPosition?.col)!].toggle(value: (StandardEngine.engine.grid[lastTouchedPosition!.row,lastTouchedPosition!.col])))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
        
       StandardEngine.engine.grid[(lastTouchedPosition?.row)!,(lastTouchedPosition?.col)!] = (StandardEngine.engine.grid[(lastTouchedPosition?.row)!,(lastTouchedPosition?.col)!].toggle(value: (StandardEngine.engine.grid[lastTouchedPosition!.row,lastTouchedPosition!.col])))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
    }
    
    var lastTouchedPosition: GridPosition?
    
    func process(touches: Set<UITouch>) -> GridPosition? {
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        
        setNeedsDisplay()
        return pos
    }
    
    func convert(touch: UITouch) -> GridPosition {
        let touchY = touch.location(in: self).y
        let gridHeight = frame.size.height
        let row = touchY / gridHeight * CGFloat(gridSize.rows)
        let touchX = touch.location(in: self).x
        let gridWidth = frame.size.width
        let col = touchX / gridWidth * CGFloat(gridSize.cols)
        let position = (row: Int(row), col: Int(col))
        return position
    }

    
//    // Updated since class
//    var lastTouchedPosition: GridPosition?
//    
//    func process(touches: Set<UITouch>) -> GridPosition? {
//        guard touches.count == 1 else { return nil }
//        let pos = convert(touch: touches.first!)
//        
//        //************* IMPORTANT ****************
//        guard lastTouchedPosition?.row != pos.row
//            || lastTouchedPosition?.col != pos.col
//            else { return pos }
//        //****************************************
//        
//        if grid != nil {
//            grid![pos.row, pos.col] = grid![pos.row, pos.col].toggle(value: grid![pos.row, pos.col])
//            setNeedsDisplay()
//        }
//        self.setNeedsDisplay()
//        
//        return pos
//    }
//    
//    func convert(touch: UITouch) -> GridPosition {
//        let touchY = touch.location(in: self).y
//        let gridHeight = frame.size.height
//        let row = touchY / gridHeight * CGFloat(gridSize.rows)
//        
//        let touchX = touch.location(in: self).x
//        let gridWidth = frame.size.width
//        let col = touchX / gridWidth * CGFloat(gridSize.cols)
//        
//        return GridPosition(row: Int(row), col: Int(col))
//    }

}
