//
//  GKCanvas 2.swift
//  GridKitUsage
//
//  Created by Devansh Seth on 13/02/25.
//


import Foundation
import UIKit

public class GKCanvas {
    public var gkspec: GKSpec {
        didSet {
            if oldValue.cellSize != gkspec.cellSize, self.gklayout != nil {
                self.gkCells.forEach { (indexPath: IndexPath, cell: GKCell) in
                    cell.view.frame = computeCellFrame(row: cell.row, column: cell.column)
                }
                self.gklayout?.bounds.size = getSize()
            }
            
            if oldValue.cellBorderColor != gkspec.cellBorderColor {
                self.gkCells.forEach { (indexPath: IndexPath, cell: GKCell) in
                    cell.view.layer.borderColor = gkspec.cellBorderColor?.cgColor
                }
            }
            
            if oldValue.cellColor != gkspec.cellColor {
                self.gkCells.forEach { (indexPath: IndexPath, cell: GKCell) in
                    cell.view.backgroundColor = gkspec.cellColor
                }
            }
            
            if oldValue.cellBorderWidth != gkspec.cellBorderWidth {
                self.gkCells.forEach { (indexPath: IndexPath, cell: GKCell) in
                    cell.view.layer.borderWidth = gkspec.cellBorderWidth ?? 0
                }
            }
            
            if oldValue.cellCornerRadius != gkspec.cellCornerRadius {
                self.gkCells.forEach { (indexPath: IndexPath, cell: GKCell) in
                    cell.view.layer.cornerRadius = gkspec.cellCornerRadius ?? 0
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
    
    /// Stores all the visible cells
    public private(set) var gkCells: [IndexPath : GKCell] = [:]
    
    /// Layout view / Parent view which constains the cells stack
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
    
    /// Returns the cell at given index if exists
    public func getCell(at indexPath: IndexPath) -> GKCell? {
        return gkCells[indexPath]
    }
    
    public func getCell(atRow row: Int, column: Int) -> GKCell? {
        return getCell(at: IndexPath(row: row, section: column))
    }
    
    /// Returns the index of cell at a point if exists
    public func getIndexPath(forCellAt point: CGPoint) -> IndexPath? {
        for (indexPath, cell) in gkCells {
            if cell.view.frame.contains(point) {
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
    
    /// Calculates the position of a cell
    public func computeCellFrame(row: Int, column: Int) -> CGRect {
        let cellSize = gkspec.cellSize
        let interCellInsets = gkspec.interCellInsets
        let startX = (gklayout?.bounds.origin.x ?? 0)
        let startY = (gklayout?.bounds.origin.y ?? 0)
        
        let cellX = startX + (CGFloat(column) * (cellSize + interCellInsets))
        let cellY = startY + (CGFloat(row) * (cellSize + interCellInsets))
        
        return CGRect(x: cellX, y: cellY, width: cellSize, height: cellSize)
    }

    /// Refreshes the canvas layout
    public func layoutCanvasCells() {
        gkCells.forEach { (indexPath: IndexPath, cell: GKCell) in
            cell.view.frame = computeCellFrame(row: cell.row, column: cell.column)
            cell.view.backgroundColor = gkspec.cellColor
            cell.view.layer.borderColor = gkspec.cellBorderColor?.cgColor
            cell.view.layer.borderWidth = gkspec.cellBorderWidth ?? 0
            cell.view.layer.cornerRadius = gkspec.cellCornerRadius ?? 0
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
    
    /// Inserts a cell at a specific row and column.
    public func insertCell(atRow row: Int, column: Int, file: StaticString = #file, line: UInt = #line) {
        guard row>=0, column>=0, row < gkspec.rows, column < gkspec.columns else {
            let warningText = "Rows or columns out of bounds! (maxRows: \(gkspec.rows), maxColumns: \(gkspec.columns))"
            let errorOccurFromPathText = "Error occurred in file: \(file), line: \(line)"
            
            preconditionFailure("\(warningText)\n\(errorOccurFromPathText)")
        }
        
        let indexPath = IndexPath(row: row, section: column)
        if gkCells[indexPath] != nil { return }
        
        let cell = GKCell(
            row: row,
            column: column,
            frame: computeCellFrame(row: row, column: column),
            cellColor: gkspec.cellColor,
            borderWidth: gkspec.cellBorderWidth,
            borderColor: gkspec.cellBorderColor,
            cornerRadius: gkspec.cellCornerRadius
        )
        
        gkCells[indexPath] = cell
        gklayout?.addSubview(cell.view)
    }
    
    /// Removes a cell from a specific row and column.
    public func removeCell(atRow row: Int, column: Int) {
        guard row>=0, column>=0, row < gkspec.rows, column < gkspec.columns else { return }
        
        let indexPath = IndexPath(row: row, section: column)
        guard let cell = gkCells[indexPath] else { return }
        
        cell.view.removeFromSuperview()
        gkCells.removeValue(forKey: indexPath)
    }
    
    /// Erase all cells from the canvas.
    public func erase() {
        gkCells.forEach { (_, cell) in
            cell.view.removeFromSuperview()
        }
        gkCells.removeAll()
    }
    
    /// Checks if a cell exists at a given position.
    public func hasCell(atRow row: Int, column: Int) -> Bool {
        let indexPath = IndexPath(row: row, section: column)
        return gkCells[indexPath] != nil
    }
    
    /// Updates cell properties at a given position
    public func updateCell(atRow row: Int, column: Int, update: (inout GKCell) -> Void) {
        let indexPath = IndexPath(row: row, section: column)
        guard var cell = gkCells[indexPath] else {
            print("Warning: Attempted to update block at (\(row), \(column)), but it's out of bounds! Valid range: 0-\(gkspec.rows-1), 0-\(gkspec.columns-1)")
            return
        }
        update(&cell)
        gkCells[indexPath] = cell
    }
}
