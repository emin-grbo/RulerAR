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
    element.pointSize = 100
    return SCNGeometry(sources: [source], elements: [element])
  }
  
  //MARK: - Draw the line
  func draw() {
    lineNode = getDrawnLineFrom(from: dotNodes[dotOne].position, to: dotNodes[dotTwo].position)
    sceneView.scene.rootNode.addChildNode(lineNode!)
  }
  
  // MARK: - Showing line in real-time
  func renderer(_ renderer: SCNSceneRenderer,
                updateAtTime time: TimeInterval) {
    
    DispatchQueue.main.async {
      
      if self.dotNodes.isEmpty == false && self.dotNodes.count != 4 {
        guard let currentPosition = self.sceneView.realWorldVector(screenPos: self.sceneView.center),
          let placedNode = self.dotNodes.last?.position else {return}
        
        self.lineNode?.removeFromParentNode()
        
        self.lineNode = self.getDrawnLineFrom(from: placedNode,
                                              to: currentPosition)
        self.sceneView.scene.rootNode.addChildNode(self.lineNode!)
      } else {
        return
      }
    }
  }
  
  
}
