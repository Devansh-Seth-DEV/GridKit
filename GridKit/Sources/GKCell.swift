//
//  GKCell.swift
//  GridKit
//
//  Created by Devansh Seth on 12/02/25.
//

import Foundation
import UIKit

open class GKCell {
    public let row: Int         // Row at which cell is present
    public let column: Int      // Column at which cell is present
    public let view: UIView    // Independent cell view

    public init(
        row: Int,
        column: Int,
        frame: CGRect,
        cellColor: UIColor? = UIColor.tertiarySystemGroupedBackground,
        borderWidth: CGFloat? = nil,
        borderColor: UIColor? = UIColor.black,
        cornerRadius: CGFloat? = nil
    ) {
        self.row = row
        self.column = column
        
        self.view = UIView(frame: frame)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.backgroundColor = cellColor
        self.view.layer.borderWidth = borderWidth ?? 0
        self.view.layer.borderColor = borderColor?.cgColor
        self.view.layer.cornerRadius = cornerRadius ?? 0
    }
}
