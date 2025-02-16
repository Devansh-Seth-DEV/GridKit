//
//  GKLayoutView.swift
//  GridKit
//
//  Created by Devansh Seth on 12/02/25.
//

import Foundation
import UIKit

open class GKLayoutView: UIView {
    /// Canvas which manages the cells in the layout
    public var canvas: GKCanvas
    /// Computes the number of rows in the canvas
    public var rows: Int { canvas.gkspec.rows }
    
    /// Computes the number of row in the canvas
    public var columns: Int { canvas.gkspec.columns }

    /// Flag which defines whether canvas size can go out of bounds or not
    private var masksToBounds: Bool
    
    
    // Cell tapping properties
    /// Function to call when a cell gets tapped, `allowPathDrawing` should be set to `false` for its working
    /// Provide cell which gets tapped
    public var didTapCell: ((_ cell: GKCell) -> Void)?

    // Path Drawing Related Properties
    /// Flag which allow canvas to make path between two cells when finger slides from one cell to another, `tapping` on the cell will not work after its activation instead you can update cell properties inside `updateCellOnTrace` or `updateCellOnTraceEnd`
    public var allowPathDrawing: Bool = false {
        didSet {
            resetTracedPath(.init(), with: nil)
        }
    }
    
    /// Stores the width of the line connecting two cells
    public var pathLineWidth: CGFloat = 5
    
    /// Stores the stroke color of the line connecting two cells
    public var pathStrokeColor: UIColor? = .label
    
    /// Track all the lines with the order in which they connect two cells, `allowPathDrawing` should be set to `true` for its working
    public var pathLayers: [CAShapeLayer] = []
    
    /// Track all the cells with the order in which they are connected, `allowPathDrawing` should be set to `true` for its working
    public var tracedCells: [IndexPath] = []
    
    /// Function to call when new cell gets connected, `allowPathDrawing` should be set to `true` for its working
    /// Provides three parameters `cell`, `touch`, `event`
    public var updateCellOnTrace: ((GKCell, Set<UITouch>, UIEvent?) -> Void)?
    
    /// Function to call when event to connect two cells end to update cell properties, `allowPathDrawing` should be set to `true` for its working
    /// Provides three parameters `cell`, `touch`, `event`
    public var updateCellOnTraceEnd: ((GKCell, Set<UITouch>, UIEvent?) -> Void)?
    
    
    
    // Draging and droping cells related properties
    
    /// Flag which allow the cells in the canvas to be dragged in the canvas and dropped onto another cell
    public var allowCellDragNDrop: Bool = false
    
    /// Flag which allow the cells in the canvas to be dropped in empty space
    public var allowDropInEmptySpace: Bool = false
    
    /// Function to call before droping the cell into another cell
    /// Provides two parameters `dragingCell` and `acceptorCell`
    public var onCellDropped: ((GKCell, GKCell) -> Void)?
    
    /// Function to call before detaching the cell from another cell
    /// Provides two parameters `dragingCell` and `acceptorCell`
    public var onCellDetach: ((GKCell, GKCell) -> Void)?
    
    /// Stores origin of cell when it begans to drag
    public var initialDragOrigin: CGPoint = .zero
    
    /// Stores the cell which is currently under draging state
    public var selectedDragCell: GKCell? = nil
    

    public convenience init(spec: GKSpec, in superview: UIView, masksToBounds: Bool = true) {
        self.init(frame: .zero, spec: spec, in: superview, masksToBounds: masksToBounds)
    }

    public init(frame: CGRect, spec: GKSpec, in superview: UIView, masksToBounds: Bool = true) {
        self.masksToBounds = masksToBounds
        self.canvas = GKCanvas(spec: spec)  // Create GK Canvas inside GKLayoutView
        
        super.init(frame: frame)
        self.center = superview.center
        self.translatesAutoresizingMaskIntoConstraints = false
        
        canvas.attachLayoutView(self) // Let Canvas know the GK layout view
        setupTapGesture()
        
        superview.addSubview(self)
        
        resizeCanvas(to: canvas.getSize())
    }
    

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Removes the track of all the lines connecting the cells
    private func resetTracedPath(_ touches: Set<UITouch>, with event: UIEvent?) {
        tracedCells.forEach { indexPath in
            if let cell = canvas.getCell(atRow: indexPath.row, column: indexPath.section) {
                updateCellOnTraceEnd?(cell, touches, event)
            }
        }
        
        pathLayers.forEach { (pathLayer: CAShapeLayer) in
            pathLayer.removeFromSuperlayer()
        }
        
        pathLayers.removeAll()
        tracedCells.removeAll()
    }
    
    /// Draw the lines between two cells
    private func drawLine(from start: CGPoint, to end: CGPoint) {
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)

        let lineLayer = CAShapeLayer()
        lineLayer.path = path.cgPath
        
        if pathLayers.isEmpty  {
            lineLayer.strokeColor = self.pathStrokeColor?.cgColor
            lineLayer.lineWidth = self.pathLineWidth
            lineLayer.fillColor = nil
            lineLayer.lineCap = .round
        } else {
            lineLayer.strokeColor = pathLayers.last!.strokeColor
            lineLayer.lineWidth = pathLayers.last!.lineWidth
            lineLayer.fillColor = pathLayers.last!.fillColor
            lineLayer.lineCap = pathLayers.last!.lineCap
        }
        
        layer.addSublayer(lineLayer)
        pathLayers.append(lineLayer)
    }
    
    /// Update the newly tracked cell properties at given position
    public func updateTracedCell(atIndexPath indexPath: IndexPath, update: ((GKCell) -> Void)?) {
        if !allowPathDrawing || !tracedCells.contains(indexPath) { return }
        canvas.updateCell(
            atRow: indexPath.row,
            column: indexPath.section
        ) { cell in
            update?(cell)
        }
    }
    
    /// Update the next tracked cell properties at given position
    private func updateNewTracedCell(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !allowPathDrawing || tracedCells.isEmpty { return }
        let lastIndexPath = tracedCells.last!
        updateTracedCell(atIndexPath: lastIndexPath) { cell in
            self.updateCellOnTrace?(cell, touches, event)
        }
    }
    
    /// Checks whether the subview goes out of canvas frame or not
    func isSubviewOutOfBounds(_ subview: UIView) -> Bool {
        guard let superview = subview.superview else { return false }
        
        let subviewFrame = subview.frame
        let superviewBounds = superview.bounds
        
        let isOutX = subviewFrame.minX < superviewBounds.minX || subviewFrame.maxX > superviewBounds.maxX
        let isOutY = subviewFrame.minY < superviewBounds.minY || subviewFrame.maxY > superviewBounds.maxY
        
        return (isOutX || isOutY)
    }
    
    /// Moves the current dragging cell to its initial position from where it starts dragging
    private func moveSelectedDragCellToInitial() {
        guard let selectedDragCell = selectedDragCell else { return }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            selectedDragCell.frame.origin = selectedDragCell.initialOrigin
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if allowPathDrawing {
            resetTracedPath(touches, with: event)
            
            if let indexPath = canvas.getIndexPath(forCellAt: location) {
                tracedCells.append(indexPath)
                updateNewTracedCell(touches, with: event)
            }
        } else if allowCellDragNDrop {
            if let cell = hitTest(location, with: event) as? GKCell {
                if cell.dragable == true {
                    if let intersetCell = self.canvas.getIntersectCell(with: cell),
                       intersetCell.dropable {
                        if intersetCell.canAcceptDetach {
                            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                                self.onCellDetach?(cell, intersetCell)
                            }
                            intersetCell.dropStorageCount -= 1
                        }
                    }
                    initialDragOrigin = location
                    self.bringSubviewToFront(cell)
                    selectedDragCell = cell
                }
            }
        }
    }
    
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        UIView.performWithoutAnimation {
            self.layer.removeAllAnimations()
        }
        
        if allowPathDrawing {
            if let nextCell = hitTest(location, with: event) as? GKCell,
               !tracedCells.contains(canvas.getIndexPath(ofCell: nextCell)) {
                if let lastCell = canvas.getCell(at: tracedCells.last) {
                    drawLine(from: lastCell.center, to: nextCell.center)
                }
                tracedCells.append(canvas.getIndexPath(ofCell: nextCell))
                updateNewTracedCell(touches, with: event)
            }
        } else if allowCellDragNDrop && selectedDragCell != nil{
            let deltaX = location.x - initialDragOrigin.x
            let deltaY = location.y - initialDragOrigin.y
            
            selectedDragCell!.center = CGPoint(x: initialDragOrigin.x + deltaX, y: initialDragOrigin.y + deltaY)
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if allowPathDrawing {
            resetTracedPath(touches, with: event)
        } else if allowCellDragNDrop && selectedDragCell != nil {
            
            if let intersetCell = self.canvas.getIntersectCell(with: selectedDragCell) {
                if intersetCell.canAcceptDrop {
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                        self.selectedDragCell!.frame.origin = intersetCell.frame.origin
                        self.selectedDragCell!.center = intersetCell.center
                    }
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                        self.onCellDropped?(self.selectedDragCell!, intersetCell)
                    }
                    intersetCell.dropStorageCount += 1
                } else { moveSelectedDragCellToInitial() }
            } else if self.allowDropInEmptySpace {
                UIView.animate(withDuration: 0.3) {
                    var cellDropped: Bool = false
                    
                    for row in 0..<self.canvas.gkspec.rows {
                        for col in 0..<self.canvas.gkspec.columns {
                            let frame = self.canvas.computeCellFrame(row: row, column: col)
                            let intersetCell = self.canvas.getCell(atRow: row, column: col)
                            let isEmptySpace = !self.canvas.hasCell(atRow: row, column: col) || (self.selectedDragCell!.row == row && self.selectedDragCell!.column == col)
                            
                            if !frame.intersects(self.selectedDragCell!.frame) { continue }
                            
                            if let intersetCell = intersetCell, intersetCell.dragable
                            {
                                self.selectedDragCell!.frame.origin = self.selectedDragCell!.initialOrigin
                            } else if isEmptySpace {
                                self.selectedDragCell!.frame.origin = frame.origin
                                self.canvas.updateCellPosition(
                                    withIndexPath: self.canvas
                                        .getIndexPath(ofCell: self.selectedDragCell!),
                                    to: IndexPath(row: row, section: col)
                                )
                                
                            }
                            cellDropped = true
                            break
                        }
                        if cellDropped { break }
                    }
                }
            } else {
                moveSelectedDragCellToInitial()
            }
            
            if isSubviewOutOfBounds(selectedDragCell!) { moveSelectedDragCellToInitial(); return }

            initialDragOrigin = .zero
            selectedDragCell = nil
        }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        if allowPathDrawing {
            resetTracedPath(touches, with: event)
        } else if allowCellDragNDrop && selectedDragCell != nil {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.selectedDragCell!.frame.origin = self.selectedDragCell!.initialOrigin
            }
            
            initialDragOrigin = .zero
            self.selectedDragCell = nil
        }
    }
    
    private func setupTapGesture() {
        // Add tap gesture recognizer to detect taps on grid blocks
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCellTap(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc internal func handleCellTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self)
        if let cell: GKCell = canvas.getCell(atPoint: tapLocation) {
            if !allowPathDrawing {
                didTapCell?(cell)
            }
        }
    }
    
    /// Resizes the canvas size to new size
    public func resizeCanvas(to size: CGSize) {
        var canvasSize: CGSize = size
        if self.masksToBounds &&
            ((superview!.bounds.width < canvasSize.width) ||
             (superview!.bounds.height < canvasSize.height)
            ) {
            canvasSize = superview!.bounds.size
            canvasSize.width -= canvas.gkspec.interCellInsets * CGFloat(canvas.gkspec.columns-1)
            canvasSize.height -= canvas.gkspec.interCellInsets * CGFloat(canvas.gkspec.rows-1)
        }
        
        let cellWidth = canvasSize.width / CGFloat(canvas.gkspec.columns)
        let cellHeight = canvasSize.height / CGFloat(canvas.gkspec.rows)
        let cellSize = (cellWidth + cellHeight)/2
        canvas.gkspec.cellSize = cellSize
        
        self.frame = CGRect(
            origin: .zero,
            size: canvas.getSize()
        )
        self.center = CGPoint(x: self.superview!.bounds.midX, y: self.superview!.bounds.midY)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    /// Calls GKCanvas `populate` method
    public func populate() {
        canvas.populate()
    }
    
    /// Calls GKCanvas `populateCells(at:)` method
    public func populteCells(at indexes: [(row: Int, col: Int)]) {
        canvas.populateCells(at: indexes)
    }
    
    /// Calls GKCanvas `populateCells(where:)` method
    public func populateCells(where condition: ((Int, Int) -> Bool)) {
        canvas.populateCells(where: condition)
    }
    
    /// Calls GKCanvas `removeCell(atRow:column)` method
    public func removeCell(atRow row: Int, column: Int) {
        canvas.removeCell(atRow: row, column: column)
    }
    
    /// Calls GKCanvas `removeCells(at:)` method
    public func removeCells(at indexes: [(row: Int, col: Int)]) {
        canvas.removeCells(at: indexes)
    }
    
    /// Calls GKCanvas `removeCells(where:)` method
    public func removeCells(where condition: ((Int, Int) -> Bool)) {
        canvas.removeCells(where: condition)
    }
    
    /// Calls GKCanvs `erase()` method
    public func eraseCanvas() { canvas.erase() }
    
    /// Calls GKCanvas `updateCells(at:update:)` method
    public func updateCells(at indexes: (Int, Int), update: ((inout GKCell) -> Void)?) {
        self.canvas.updateCell(atRow: indexes.0, column: indexes.1, update: update)
    }
    
    /// Calls GKCanvas `updateCells(with:update)` method
    public func updateCells(with indexPaths: [IndexPath], update: ((inout GKCell) -> Void)?) {
        self.canvas.updateCells(with: indexPaths, update: update)
    }
    
    /// Calls GKCanvas `updateCells(where:update)` method
    public func updateCells(where condition: ((Int, Int) -> Bool), update: ((inout GKCell) -> Void)?) {
        self.canvas.updateCells(where: condition, update: update)
    }
    
    /// Returns the height of canvas from starting row till ending row, if ending is not know use negative indexes to get last indexes
    public func getHeight(fromRow startRow: Int, to endRow: Int) -> CGFloat {
        var endRow = endRow
        if endRow < 0 { endRow = self.canvas.gkspec.rows + endRow }
        let startFrame = canvas.computeCellFrame(row: startRow, column: 0)
        let endFrame = canvas.computeCellFrame(row: endRow, column: 0)
        let height = (endFrame.maxY - startFrame.minY)
        return (height > 0) ? height : -height
    }
    
    /// Returns the width of canvas from starting column till ending column, if ending is not know use negative indexes to get last indexes
    public func getWidth(fromColumn startColumn: Int, to endColumn: Int) -> CGFloat {
        var endColumn = endColumn
        if endColumn < 0 { endColumn = self.canvas.gkspec.columns + endColumn }
        let startFrame = canvas.computeCellFrame(row: 0, column: startColumn)
        let endFrame = canvas.computeCellFrame(row: 0, column: endColumn)
        let width = (endFrame.maxX - startFrame.minX)
        return (width > 0) ? width : -width
    }
    
    /// Returns the size of canvas from starting (row, col) till ending (row, col), if ending is not know use negative indexes to get last indexes
    public func getSize(fromGridAt startCell: (row: Int, col: Int), to endCell: (row: Int, col: Int)) -> CGSize {
        let size = CGSize(
            width: getWidth(fromColumn: startCell.col, to: endCell.col),
            height: getHeight(fromRow: startCell.row, to: endCell.row)
        )
        return size
    }
    
    /// Sets the size of subview with the size of canvas from starting (row, col) till ending (row, col), if ending is not know use negative indexes to get last indexes
    public func setSubviewSize(_ view: UIView, fromGridAt startCell: (row: Int, col: Int), to endCell: (row: Int, col: Int)) {
        view.frame.size = getSize(fromGridAt: startCell, to: endCell)
    }
    
    /// Adds the subview in canvas at specific position and also add `tag` to them to identify them uniquely
    public func addSubview(atRow row: Int, column: Int, view: UIView) {
        let frame = canvas.computeCellFrame(row: row, column: column)
        view.tag = (row * canvas.gkspec.columns) + column
        view.frame.origin = frame.origin
        self.addSubview(view)
    }
}
