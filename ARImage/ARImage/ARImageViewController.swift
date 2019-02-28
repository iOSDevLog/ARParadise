//
//  ARImageViewController.swift
//  ARImage
//
//  Created by ios dev on 2019/2/28.
//  Copyright © 2019 iosdevlog. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARImageViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) else { return }

        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1

        // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()

        if anchor is ARImageAnchor {
            let plane = SCNPlane(width: 0.7, height: 0.35)
            let deviceScene = SKScene(fileNamed: "DeviceScene")

            plane.firstMaterial?.diffuse.contents = deviceScene
            plane.firstMaterial?.isDoubleSided = true
            plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)

            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2

            let iPhoneScene = SCNScene(named: "Device.scnassets/iPhoneX.scn")!
            let iPhoneNode = iPhoneScene.rootNode.childNodes.first!
            iPhoneNode.position = SCNVector3(0, 0, 0.15)

            node.addChildNode(planeNode)
            planeNode.addChildNode(iPhoneNode)
        }

        return node
    }
}