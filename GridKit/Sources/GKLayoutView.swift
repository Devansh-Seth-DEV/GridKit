//
//  GridView.swift
//  GridKit
//
//  Created by Devansh Seth on 12/02/25.
//

import Foundation
import UIKit

open class GKLayoutView: UIView {
    public private(set) var canvas: GKCanvas
    public var didTapCell: ((_ cell: GKCell) -> Void)?
    
    public var rows: Int { canvas.gkspec.rows }
    public var columns: Int { canvas.gkspec.columns }
    
    public convenience init(spec: GKSpec, in superview: UIView) {
        self.init(frame: .zero, spec: spec, in: superview)
    }

    public init(frame: CGRect, spec: GKSpec, in superview: UIView) {
        self.canvas = GKCanvas(spec: spec)  // Create GK Canvas inside GKLayoutView
        
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        

        var canvasSize: CGSize = canvas.getSize()
        if (superview.bounds.width < canvasSize.width) ||
            (superview.bounds.height < canvasSize.height)
        {
            canvasSize = superview.bounds.size
            let cellWidth = canvasSize.width / CGFloat(canvas.gkspec.columns)
            let cellHeight = canvasSize.height / CGFloat(canvas.gkspec.rows)
            let cellSize = (cellWidth + cellHeight)/2
            
            canvas.gkspec.cellSize = cellSize
            canvasSize = canvas.getSize()
        }
        self.frame = CGRect(
            origin: .zero,
            size: canvasSize
        )
        self.center = CGPoint(x: superview.bounds.midX, y: superview.bounds.midY)

        canvas.attachLayoutView(self) // Let Canvas know the GK layout view
        setupTapGesture()
        
        superview.addSubview(self)
    }
    

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupTapGesture() {
        // Add tap gesture recognizer to detect taps on grid blocks
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc internal func handleCellTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: self)
        if let cell: GKCell = canvas.getCell(atPoint: tapLocation) {
            didTapCell?(cell)
        }
    }
    
    /// Resizes the canvas size to new size
    public func resizeCanvas(to size: CGSize) {
        let cellWidth = size.width / CGFloat(canvas.gkspec.columns)
        let cellHeight = size.height / CGFloat(canvas.gkspec.rows)
        let cellSize = (cellWidth + cellHeight)/2
        canvas.gkspec.cellSize = cellSize
        self.frame = CGRect(
            origin: .zero,
            size: canvas.getSize()
        )
        self.center = CGPoint(x: self.superview!.bounds.midX, y: self.superview!.bounds.midY)
    }
    
    public func populate() { canvas.populate() }
    public func eraseCanvas() { canvas.erase() }
}
