//
//  Line.swift
//  RulerAR
//
//  Created by Emin Roblack on 8/27/18.
//  Copyright © 2018 emiN Roblack. All rights reserved.
//

import Foundation
import ARKit

extension ViewController {
  
  //MARK: - Draw the line
  // draw line-node between two vectors
  func getDrawnLineFrom(from: SCNVector3,
                        to: SCNVector3) -> SCNNode {
    
    let line = lineFrom(vector: from, toVector: to)
    let lineInBetween = SCNNode(geometry: line)
    
    return lineInBetween
  }
  
  // get line geometry between two vectors
  func lineFrom(vector vector1: SCNVector3,
                toVector vector2: SCNVector3) -> SCNGeometry {
    
    let indices: [Int32] = [0, 1]
    let source = SCNGeometrySource(vertices: [vector1, vector2])
    let element = SCNGeometryElement(indices: indices,
                                     primitiveType: .line)
    return SCNGeometry(sources: [source], elements: [element])
  }
  
}
