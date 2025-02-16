//
//  GKCell.swift
//  GridKit
//
//  Created by Devansh Seth on 12/02/25.
//

import Foundation
import UIKit

open class MarkerView: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class GKCell: UIView {
    /// Row at which cell  is present in canvas
    public var row: Int
    /// Column at which cell is present in canvas
    public var column: Int
    /// Initial origin of cell in the canvas, updated as cell's position changes
    public var initialOrigin: CGPoint
    
    /// Flag which allow a cell to be able to be dragged in canvas, by default set to `false`
    public var dragable: Bool  = false
    /// Flag which allow a cell to take another cell onto it or in other words to allow another cell to be droped into it, by default set to `false`
    public var dropable: Bool  = false
    /// Stores the maximum capacity to accepts the drops on this view, default is `1`
    public var maxDropCapacity: Int = 1
    /// Stores the maxmium number of cells currently droped on it
    public var dropStorageCount: Int = 0
    
    /// Check whether this cell can accept more drops or not
    public var canAcceptDrop: Bool {
        return dropable && dropStorageCount < maxDropCapacity
    }
    
    /// Checks whether this cell can accepts more detaches of cell or not
    public var canAcceptDetach: Bool {
        return dropable && dropStorageCount > 0
    }
    
    public convenience init(
        row: Int,
        column: Int,
        frame: CGRect,
        cellColor: UIColor? = UIColor.tertiarySystemGroupedBackground,
        borderWidth: CGFloat? = nil,
        borderColor: UIColor? = UIColor.black,
        cornerRadius: CGFloat? = nil
    ) {
        self.init(frame: frame, row: row, column: column)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = cellColor
        self.layer.borderWidth = borderWidth ?? 0
        self.layer.borderColor = borderColor?.cgColor
        self.layer.cornerRadius = cornerRadius ?? 0
    }
    
    public init(frame: CGRect, row: Int, column: Int) {
        self.row = row
        self.column = column
        self.initialOrigin = frame.origin
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
