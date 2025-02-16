//
//  GKCanvas.swift
//  GridKitUsage
//
//  Created by Devansh Seth on 13/02/25.
//


import Foundation
import UIKit

open class GKCanvas  {
    /// Specifications of the canvas
    public var gkspec: GKSpec {
        didSet {
            if oldValue.cellSize != gkspec.cellSize, self.gklayout != nil {
                self.gkCells.forEach { (indexPath: IndexPath, cell: GKCell) in
                    cell.frame = computeCellFrame(row: cell.row, column: cell.column)
                    cell.initialOrigin = cell.frame.origin
                }
                self.gklayout?.bounds.size = getSize()
            }
            
            if oldValue.cellBorderColor != gkspec.cellBorderColor {
                self.gkCells.forEach { (indexPath: IndexPath, cell: GKCell) in
                    cell.layer.borderColor = gkspec.cellBorderColor?.cgColor
                }
            }
            
            if oldValue.cellColor != gkspec.cellColor {
                self.gkCells.forEach { (indexPath: IndexPath, cell: GKCell) in
                    cell.backgroundColor = gkspec.cellColor
                }
            }
            
            if oldValue.cellBorderWidth != gkspec.cellBorderWidth {
                self.gkCells.forEach { (indexPath: IndexPath, cell: GKCell) in
                    cell.layer.borderWidth = gkspec.cellBorderWidth ?? 0
                }
            }
            
            if oldValue.cellCornerRadius != gkspec.cellCornerRadius {
                self.gkCells.forEach { (indexPath: IndexPath, cell: GKCell) in
                    cell.layer.cornerRadius = gkspec.cellCornerRadius ?? 0
                }
            }
            
            if oldValue.canvasColor != gkspec.canvasColor {
                gklayout?.backgroundColor = gkspec.canvasColor
            }
            
            if oldValue.canvasCornerRadius != gkspec.canvasCornerRadius {
                gklayout?.layer.cornerRadius = gkspec.canvasCornerRadius ?? 0
            }
        }
    }
    
    /// Track all the cells to be displayed on the canvas with their positions
    public private(set) var gkCells: [IndexPath : GKCell] = [:]
    
    /// Superview which display the cells
    public weak var gklayout: UIView?
    
    /// Initializes the Canvas with a given configuration.
    public init(spec: GKSpec) {
        self.gkspec = spec
    }

    
    /// Attaches the layout view after initialization
    public func attachLayoutView(_ view: GKLayoutView) {
        self.gklayout = view
        self.gklayout?.backgroundColor = self.gkspec.canvasColor
        self.gklayout?.layer.cornerRadius = gkspec.canvasCornerRadius ?? 0
        layoutCanvasCells()
    }
    
    /// Returns the size of canvas
    public func getSize() -> CGSize {
        return CGSize(
            width: self.gkspec.canvasWidth,
            height: self.gkspec.canvasHeight
        )
    }
    
    /// Returns the size of single cell
    public func getCellSize() -> CGSize {
        return CGSize(
            width: self.gkspec.cellSize,
            height: self.gkspec.cellSize
        )
    }
    
    /// Returns the cell at given index if exists
    public func getCell(at indexPath: IndexPath?) -> GKCell? {
        guard let indexPath = indexPath else { return nil }
        return gkCells[indexPath]
    }
    
    /// Returns the cell from the canvas at given row and column if exists
    public func getCell(atRow row: Int, column: Int) -> GKCell? {
        return getCell(at: IndexPath(row: row, section: column))
    }
    
    /// Returns the index path of a cell in canvas if exists
    public func getIndexPath(ofCell cell: GKCell) -> IndexPath {
        return IndexPath(row: cell.row, section: cell.column)
    }
    
    /// Updates the cell position in canvas to new row or colum
    public func updateCellPosition(withIndexPath indexPath: IndexPath, to newIndexPath: IndexPath) {
        if gkCells[indexPath] != nil {
            let removedCell = gkCells.removeValue(forKey: indexPath)
            removedCell!.row = newIndexPath.row
            removedCell!.column = newIndexPath.section
            removedCell!.initialOrigin = computeCellOrigin(row: newIndexPath.row, column: newIndexPath.section)
            removedCell!.tag = (newIndexPath.row * gkspec.columns) + newIndexPath.section
            self.gkCells.updateValue(removedCell!, forKey: newIndexPath)
        }
    }
    
    /// Returns the index of cell at a point if exists
    public func getIndexPath(forCellAt point: CGPoint) -> IndexPath? {
        for (indexPath, cell) in gkCells {
            if cell.frame.contains(point) {
                return indexPath
            }
        }
        return nil
    }
    
    /// Returns cell at a point if exists
    public func getCell(atPoint point: CGPoint) -> GKCell? {
        guard let indexPath = getIndexPath(forCellAt: point) else { return nil }
        return getCell(at: indexPath)
    }
    
    /// Returns all the allocated cells in the canvas
    public func getAllCells() -> [GKCell] {
        return Array(gkCells.values)
    }
    
    /// Returns all the positions of the cell in the canvas
    public func getAllIndexPaths() -> [IndexPath] {
        return Array(gkCells.keys)
    }
    
    /// Add a marker at the corner of a cell in the canvas at given position, marker will be added even if cell not exists
    public func addCornerMarker(
        at indexPath: IndexPath,
        size: CGSize = CGSize(width: 4, height: 4),
        offset: (dx: CGFloat, dy: CGFloat) = (dx: 2, dy: 2),
        cornerRadius: CGFloat = 2,
        backgroundColor: UIColor? = nil,
        borderWidth: CGFloat = 0,
        borderColor: UIColor? = .clear
    ) {
        let backgroundColor: UIColor = backgroundColor ?? .label
        let frame = self.computeCellFrame(row: indexPath.row, column: indexPath.section)
        var cornerPoints: [CGPoint] = [frame.origin]
        
        if indexPath.row == self.gkspec.rows - 1 {
            cornerPoints.append(CGPoint(x: frame.minX, y: frame.maxY)) // Bottom-left
        }
        if indexPath.section == self.gkspec.columns - 1 {
            cornerPoints.append(CGPoint(x: frame.maxX, y: frame.minY))
        }
        if indexPath.row == self.gkspec.rows - 1 && indexPath.section == self.gkspec.columns - 1 {
            cornerPoints.append(CGPoint(x: frame.maxX, y: frame.maxY))
        }
        
        for point in cornerPoints {
            let dot = MarkerView(frame: CGRect(
                x: point.x - offset.dx,
                y: point.y - offset.dy,
                width: size.width,
                height: size.height
            ))
            dot.layer.cornerRadius = cornerRadius
            dot.backgroundColor = backgroundColor
            dot.layer.borderWidth = borderWidth
            dot.layer.borderColor = borderColor?.cgColor
            dot.tag = (indexPath.row * gkspec.columns) + indexPath.section
            
            self.gklayout?.addSubview(dot)
        }
    }
    
    /// Add markers at the corner of the cell in the canvas which satisfy certain condition on row and column, marker will be added even if cell not exists
    public func addCornerMarkers(where condition: ((_ row: Int, _ col: Int) -> Bool)) {
        for row in 0..<gkspec.rows {
            for column in 0..<gkspec.columns {
                if condition(row, column) {
                    addCornerMarker(at: IndexPath(row: row, section: column))
                }
            }
        }
    }
    
    /// Removes a marker from the corner of the cell in the canvas at given position, marker will be added even if cell not exists
    public func removeCornerMarker(from indexPath: IndexPath) {
        for view in self.gklayout!.subviews {
            if view is MarkerView &&
                view.tag == (indexPath.row * gkspec.columns) + indexPath.section {
                view.removeFromSuperview()
            }
        }
    }
    
    /// Removes markers from the corner of the cells in the canvas which satisfy certain conditions on row and column, marker will be added even if cell not exists
    public func removeCornerMarker(where condition: ((_ row: Int, _ col: Int) -> Bool)) {
        for row in 0..<gkspec.rows {
            for column in 0..<gkspec.columns {
                if condition(row, column) {
                    removeCornerMarker(from: IndexPath(row: row, section: column))
                }
            }
        }
    }
    
    /// Fill the canvas with markers
    public func displayMarkers() {
        for row in 0..<gkspec.rows {
            for column in 0..<gkspec.columns {
                addCornerMarker(at: IndexPath(row: row, section: column))
            }
        }
    }
    
    
    /// Removes all the markers from the canvas
    public func removeMarkers() {
        for row in 0..<gkspec.rows {
            for column in 0..<gkspec.columns {
                removeCornerMarker(from: IndexPath(row: row, section: column))
            }
        }
    }
    
    /// Computes the cell origin based on its position in the canvas
    public func computeCellOrigin(row: Int, column: Int) -> CGPoint {
        let cellSize = gkspec.cellSize
        let interCellInsets = gkspec.interCellInsets
        let startX = (gklayout?.bounds.origin.x ?? 0)
        let startY = (gklayout?.bounds.origin.y ?? 0)
        
        let cellX = startX + (CGFloat(column) * (cellSize + interCellInsets))
        let cellY = startY + (CGFloat(row) * (cellSize + interCellInsets))
        return CGPoint(x: cellX, y: cellY)
    }
    
    /// Calculates the frame of a cell based on its position in the canvas
    public func computeCellFrame(row: Int, column: Int) -> CGRect {
        let cellSize = gkspec.cellSize
        let cellOrigin = computeCellOrigin(row: row, column: column)
        
        return CGRect(x: cellOrigin.x, y: cellOrigin.y, width: cellSize, height: cellSize)
    }

    /// Refreshes the canvas layout
    public func layoutCanvasCells() {
        gkCells.forEach { (indexPath: IndexPath, cell: GKCell) in
            cell.frame = computeCellFrame(row: cell.row, column: cell.column)
            cell.initialOrigin = cell.frame.origin
            cell.backgroundColor = gkspec.cellColor
            cell.layer.borderColor = gkspec.cellBorderColor?.cgColor
            cell.layer.borderWidth = gkspec.cellBorderWidth ?? 0
            cell.layer.cornerRadius = gkspec.cellCornerRadius ?? 0
            self.gklayout?.setNeedsLayout()
            self.gklayout?.layoutIfNeeded()
        }
    }
    
    /// Fill the canvas with cells
    public func populate() {
        for row in 0..<gkspec.rows {
            for column in 0..<gkspec.columns {
                insertCell(atRow: row, column: column)
            }
        }
    }
    
    /// Fill the canvas with cells at given positions
    public func populateCells(at indexes: [(row: Int, col: Int)]) {
        for pair in indexes {
            insertCell(atRow: pair.row, column: pair.col)
        }
    }
    
    /// Fill the canvas with cells which satisfy certain conditions on row and column
    public func populateCells(where condition: ((Int, Int) -> Bool)) {
        for row in 0..<gkspec.rows {
            for column in 0..<gkspec.columns {
                if condition(row, column) == true {
                    insertCell(atRow: row, column: column)
                }
            }
        }
    }
    
    /// Inserts a cell at a specific position
    public func insertCell(atRow row: Int, column: Int, file: StaticString = #file, line: UInt = #line) {
        guard row>=0, column>=0, row < gkspec.rows, column < gkspec.columns else {
            let warningText = "Rows or columns out of bounds! (maxRows: \(gkspec.rows), maxColumns: \(gkspec.columns))"
            let errorOccurFromPathText = "Error occurred in file: \(file), line: \(line)"
            
            preconditionFailure("\(warningText)\n\(errorOccurFromPathText)")
        }
        
        let indexPath = IndexPath(row: row, section: column)
        if self.gkCells[indexPath] != nil { return }
        
        let cell = GKCell(
            row: row,
            column: column,
            frame: computeCellFrame(row: row, column: column),
            cellColor: gkspec.cellColor,
            borderWidth: gkspec.cellBorderWidth,
            borderColor: gkspec.cellBorderColor,
            cornerRadius: gkspec.cellCornerRadius
        )
        cell.tag = (row * gkspec.columns) + column
        self.gkCells.updateValue(cell, forKey: indexPath)
        self.gklayout?.addSubview(cell)
    }
    
    /// Removes a cell from a specific position
    public func removeCell(atRow row: Int, column: Int) {
        guard row>=0, column>=0, row < gkspec.rows, column < gkspec.columns else { return }
        
        let indexPath = IndexPath(row: row, section: column)
        guard let cell = gkCells[indexPath] else { return }
        
        cell.removeFromSuperview()
        gkCells.removeValue(forKey: indexPath)
    }
    
    /// Remove cells from given position
    public func removeCells(at indexes: [(row: Int, col: Int)]) {
        for pair in indexes {
            removeCell(atRow: pair.row, column: pair.col)
        }
    }
    
    /// Remove cells which satisfy certain condition on row and column
    public func removeCells(where condition: ((Int, Int) -> Bool)) {
        for row in 0..<gkspec.rows {
            for col in 0..<gkspec.columns {
                if condition(row, col) == true {
                    removeCell(atRow: row, column: col)
                }
            }
        }
    }
    
    /// Erase all cells from the canvas.
    public func erase() {
        gkCells.forEach { (_, cell) in
            cell.removeFromSuperview()
        }
        gkCells.removeAll()
    }
    
    /// Checks if a cell exists at a given position.
    public func hasCell(atRow row: Int, column: Int) -> Bool {
        let indexPath = IndexPath(row: row, section: column)
        return gkCells[indexPath] != nil
    }
    
    /// Updates cell properties at a given position
    public func updateCell(atRow row: Int, column: Int, update: ((inout GKCell) -> Void)?) {
        let indexPath = IndexPath(row: row, section: column)
        guard var cell = gkCells[indexPath] else {
            print("Warning: Attempted to update block at (\(row), \(column)), but it's out of bounds! Valid range: 0-\(gkspec.rows-1), 0-\(gkspec.columns-1)")
            return
        }
        update?(&cell)
        gkCells[indexPath] = cell
    }
    
    /// Update cells properties at given pair of positions (row, col)
    public func updateCells(at indexes: [(row: Int, col: Int)], update: ((inout GKCell) -> Void)?) {
        for pair in indexes {
            updateCell(atRow: pair.row, column: pair.col, update: update)
        }
    }
    
    /// Update cells properties at given positions
    public func updateCells(with indexPaths: [IndexPath], update: ((inout GKCell) -> Void)?) {
        for indexPath in indexPaths {
            updateCell(atRow: indexPath.row, column: indexPath.section, update: update)
        }
    }
    
    /// Update cells properties which satisfy certain condition on row and column
    public func updateCells(where condition: ((Int, Int) -> Bool), update: ((inout GKCell) -> Void)?) {
        for row in 0..<gkspec.rows {
            for col in 0..<gkspec.columns {
                if condition(row, col) == true {
                    updateCell(atRow: row, column: col, update: update)
                }
            }
        }
    }
    
    /// Returns the cell from the canvas which gets intersected with the provided cell
    func getIntersectCell(with cell: GKCell?) -> GKCell? {
        guard let cell = cell else { return nil } 
        let cellFrame = cell.frame

        for (_, otherCell) in self.gkCells {
            if otherCell == cell { continue }

            if cellFrame.intersects(otherCell.frame) {
                return otherCell
            }
        }
        return nil
    }
}
