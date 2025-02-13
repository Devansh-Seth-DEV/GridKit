//
//  GKLayoutView.swift
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
    private var masksToBounds: Bool

    // Path Drawing Related Properties
    public var pathLineWidth: CGFloat = 5
    public var pathStrokeColor: UIColor? = .systemTeal
    public var pathLayers: [CAShapeLayer] = []
    public var tracedCells: [IndexPath] = []
    public var updateCellOnTrace: ((GKCell) -> Void)?
    public var updateCellOnTraceEnd: ((GKCell) -> Void)?
    public var allowPathDrawing: Bool = false {
        didSet {
            resetTracedPath()
        }
    }
    
    public convenience init(spec: GKSpec, in superview: UIView, masksToBounds: Bool = true) {
        self.init(frame: .zero, spec: spec, in: superview, masksToBounds: masksToBounds)
    }

    public init(frame: CGRect, spec: GKSpec, in superview: UIView, masksToBounds: Bool = true) {
        self.masksToBounds = masksToBounds
        self.canvas = GKCanvas(spec: spec)  // Create GK Canvas inside GKLayoutView
        
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        canvas.attachLayoutView(self) // Let Canvas know the GK layout view
        setupTapGesture()
        
        superview.addSubview(self)
        
        resizeCanvas(to: canvas.getSize())
    }
    

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func resetTracedPath() {
        tracedCells.forEach { indexPath in
            if let cell = canvas.getCell(atRow: indexPath.row, column: indexPath.section) {
                updateCellOnTraceEnd?(cell)
            }
        }
        
        pathLayers.forEach { (pathLayer: CAShapeLayer) in
            pathLayer.removeFromSuperlayer()
        }
        
        pathLayers.removeAll()
        tracedCells.removeAll()
    }
    
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
    
    public func updateTracedCell(atIndexPath indexPath: IndexPath, update: ((GKCell) -> Void)?) {
        if !allowPathDrawing || !tracedCells.contains(indexPath) { return }
        canvas.updateCell(
            atRow: indexPath.row,
            column: indexPath.section
        ) { cell in
            update?(cell)
        }
    }
    
    private func updateNewTracedCell() {
        if !allowPathDrawing || tracedCells.isEmpty { return }
        let lastIndexPath = tracedCells.last!
        updateTracedCell(atIndexPath: lastIndexPath) { cell in
            self.updateCellOnTrace?(cell)
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard allowPathDrawing, let touch = touches.first else { return }

        // Reset path and selected cells
        resetTracedPath()
        
        let location = touch.location(in: self)
        if let indexPath = canvas.getIndexPath(forCellAt: location) {
            tracedCells.append(indexPath)
            updateNewTracedCell()
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard allowPathDrawing, let touch = touches.first else { return }

        let location = touch.location(in: self)
        if let nextCell = canvas.getCell(atPoint: location),
           !tracedCells.contains(canvas.getIndexPath(ofCell: nextCell)) {
            if let lastCell = canvas.getCell(at: tracedCells.last) {
                drawLine(from: lastCell.view.center, to: nextCell.view.center)
            }
            tracedCells.append(canvas.getIndexPath(ofCell: nextCell))
            updateNewTracedCell()
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard allowPathDrawing else { return }
        resetTracedPath()
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
    
    public func populate() { canvas.populate() }
    
    public func populteCells(at indexes: [(row: Int, col: Int)]) {
        canvas.populateCells(at: indexes)
    }
    
    public func populateCells(if condition: ((Int, Int) -> Bool)) {
        canvas.populateCells(if: condition)
    }
    
    public func removeCell(atRow row: Int, column: Int) {
        canvas.removeCell(atRow: row, column: column)
    }
    
    public func removeCells(at indexes: [(row: Int, col: Int)]) {
        canvas.removeCells(at: indexes)
    }
    
    public func removeCells(if condition: ((Int, Int) -> Bool)) {
        canvas.removeCells(if: condition)
    }
    
    public func eraseCanvas() { canvas.erase() }
}
