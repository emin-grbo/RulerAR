//
//  Rendering.swift
//  RulerAR
//
//  Created by Emin Roblack on 9/3/18.
//  Copyright © 2018 emiN Roblack. All rights reserved.
//

import ARKit

extension ViewController {


//MARK: - Adding a dot
func addDot(at centreVector: SCNVector3) {
  
  let dot = SCNSphere(radius: 0.005)
  let dotMaterial = SCNMaterial()
  dotMaterial.diffuse.contents = UIColor.white
  dot.materials = [dotMaterial]
  
  let dotNode = SCNNode(geometry: dot)
  dotNode.position = centreVector
  
  sceneView.scene.rootNode.addChildNode(dotNode)
  dotNodes.append(dotNode)
  
  if dotNodes.count >= 2 {
    calculate()
    draw()
  }
}
  
  
  //MARK: - Adding a label
  func addLabel(_ distance: String) {
    
    let node1 = dotNodes[dotOne].position
    let node2 = dotNodes[dotTwo].position
    
    let labelPosition = SCNVector3((node2.x + node1.x)/2.0,
                                   (node2.y + node1.y)/2.0,
                                   (node2.z + node1.z)/2.0)
    
    let ssLabelPosition = SSLabelNode()
    ssLabelPosition.worldPosition = labelPosition
    self.sceneView.scene.rootNode.addChildNode(ssLabelPosition)
    
    let ssLabelPlacedView = SSLabelView(labelNode: ssLabelPosition)
    self.view.addSubview(ssLabelPlacedView)
    self.ssViews.append(ssLabelPlacedView)
    ssViews.last?.label.text = String(distance)
  }
  
}
