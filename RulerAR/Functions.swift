//
//  Distance.swift
//  RulerAR
//
//  Created by Emin Roblack on 9/3/18.
//  Copyright © 2018 emiN Roblack. All rights reserved.
//

import ARKit

extension ViewController {

//MARK: - Calculate distance
func  calculate() {
  updateDots()
  let start = dotNodes[dotOne]
  let end = dotNodes[dotTwo]
  
  let distance = start.position.distance(from: end.position)
  updateDistance(text: distance)
}

//MARK: - Adding a text overlay
func updateDistance(text: Float) {
  
  var distanceCM: String {
    if self.unitSwitch.isOn == true {
    return String(format: "%.1fcm", (text * 100))
    } else {
      return String(format: "%.1f''", (text * 39.3700787402))
    }
    
  }

  addLabel(distanceCM)
  
}
  
  //MARK: determine if closing dot
  func updateDots() {
    if dotNodes.count == 4 {
      distanceFinal()
      dotOne = 3
      dotTwo = 0
    } else {
      dotOne = dotNodes.endIndex - 2
      dotTwo = dotNodes.endIndex - 1
    }
  }
  
  //MARK final distance
  func distanceFinal() {
    let start = dotNodes[2]
    let end = dotNodes[3]
    dotOne = 3
    dotTwo = 2
    let distance = start.position.distance(from: end.position)
    updateDistance(text: distance)
  }
  
  //MARK remove everything
  func purge() {
    // removing all nodes
    sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
      node.removeFromParentNode() }
    dotNodes = []

    // removing all label views that are PLACED in the view
    for view in ssViews {
      view.removeFromSuperview()
    }
    
    // clearing the array, since it has items but are not placed in the view
    ssViews.removeAll()
    
  }
  
}
