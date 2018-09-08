//
//  ARVCSessionDelegate.swift
//  RulerAR
//
//  Created by Emin Roblack on 9/3/18.
//  Copyright © 2018 emiN Roblack. All rights reserved.
//

import ARKit

extension ViewController: ARSessionDelegate {
  
  func session(_ session: ARSession, didUpdate frame: ARFrame) {
    
    //MARK: Placing views on the screen
    for view in ssViews {
      let projectedPosition = self.sceneView.projectPoint(view.labelNode.worldPosition)
      onlyShowViewsInFront(projectedPosition: projectedPosition, view: view)
      let size = view.frame.size
      let x = CGFloat(projectedPosition.x) - size.width/2
      let y = CGFloat(projectedPosition.y) - size.height/2
      
      view.frame.origin = CGPoint(x: x, y: y)
    }

  }
  
  
  //MARK: Handling an error where view appears behind the user, as Z axis is not taken into account during placement
  fileprivate func onlyShowViewsInFront(projectedPosition: SCNVector3, view: UIView) {
    if projectedPosition.z > 1 {
      view.isHidden = true
    } else {
      view.isHidden = false
    }
  }
  
}
