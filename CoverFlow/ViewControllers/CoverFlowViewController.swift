//
//  ViewController.swift
//  CoverFlow
//
//  Created by Vladimir on 24/10/2020.
//  Copyright © 2020 Embler. All rights reserved.
//

import UIKit

class CoverFlowViewController: UIViewController {
    
    // MARK: - Private properties
    private var leftOutsideLayerFrame = CGRect()
    private var leftLayerFrame = CGRect()
    private var centerLayerFrame = CGRect()
    private var rightLayerFrame = CGRect()
    private var rightOutsideLayerFrame = CGRect()

    private var imagesNames: [String] = []
    private var centerImageID = 0
    private var isOrientationCahnged = false
    
    
    // MARK: - Ovveride Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesNames = ImageManager.shared.getImagesName()
        prepeareCoverLayersSize()
        addingCoversToView(from: imagesNames)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: view)
            if let hitLayer = self.view.layer.hitTest(location) {
                moveCoverFlow(hitLayer)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        if isOrientationCahnged {
            prepeareCoverLayersSize()
            changeCoverLayersSize()
            isOrientationCahnged = false
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        isOrientationCahnged = true
    }
    //MARK: - ID Actions
    
    //MARK: - Private Methods
    private func changeCoverLayersSize() {
        guard let layers = view.layer.sublayers else { return }
        for layer in layers {
            switch layer.name {
            case PositionLayerName.leftOutsideLayer.rawValue:
                layer.frame = leftOutsideLayerFrame
            case PositionLayerName.leftLayer.rawValue:
                layer.frame = leftLayerFrame
            case PositionLayerName.centerLayer.rawValue:
                layer.frame = centerLayerFrame
            case PositionLayerName.rightLayer.rawValue:
                layer.frame = rightLayerFrame
            case PositionLayerName.rightOutsideLayer.rawValue:
                layer.frame = rightOutsideLayerFrame
            default:
                break
            }
        }
    }
    
    private func addingCoversToView(from images: [String]) {
        if images.count == 1 {
            let centerLayer = CALayer()
            centerLayer.frame = centerLayerFrame
            centerLayer.contents = UIImage(named: imagesNames[0])?.cgImage
            centerLayer.name = PositionLayerName.centerLayer.rawValue
            view.layer.addSublayer(centerLayer)
        } else if images.count == 2 {
            centerImageID = 1
            let leftLayer = CALayer()
            leftLayer.frame = leftLayerFrame
            leftLayer.contents = UIImage(named: imagesNames[0])?.cgImage
            leftLayer.name = PositionLayerName.leftLayer.rawValue
            leftLayer.transform = setLeft3DTransfrom()
            view.layer.addSublayer(leftLayer)
            
            let centerLayer = CALayer()
            centerLayer.frame = centerLayerFrame
            centerLayer.contents = UIImage(named: imagesNames[1])?.cgImage
            centerLayer.name = PositionLayerName.centerLayer.rawValue
            view.layer.addSublayer(centerLayer)
        } else if images.count == 3 {
            centerImageID = 1
            
            let leftLayer = CALayer()
            leftLayer.frame = leftLayerFrame
            leftLayer.contents = UIImage(named: imagesNames[0])?.cgImage
            leftLayer.name = PositionLayerName.leftLayer.rawValue
            leftLayer.transform = setLeft3DTransfrom()
            view.layer.addSublayer(leftLayer)
            
            let centerLayer = CALayer()
            centerLayer.frame = centerLayerFrame
            centerLayer.contents = UIImage(named: imagesNames[1])?.cgImage
            centerLayer.name = PositionLayerName.centerLayer.rawValue
            view.layer.addSublayer(centerLayer)
            
            let rightLayer = CALayer()
            rightLayer.frame = rightLayerFrame
            rightLayer.contents = UIImage(named: imagesNames[2])?.cgImage
            rightLayer.name = PositionLayerName.rightLayer.rawValue
            rightLayer.transform = setRight3DTransform()
            view.layer.addSublayer(rightLayer)
        } else if images.count > 3 {
            centerImageID = 1
            
            let leftOutsideLayer = CALayer()
            leftOutsideLayer.frame = leftOutsideLayerFrame
            leftOutsideLayer.name = PositionLayerName.leftOutsideLayer.rawValue
            leftOutsideLayer.transform = setLeft3DTransfrom()
            view.layer.addSublayer(leftOutsideLayer)
            
            let leftLayer = CALayer()
            leftLayer.frame = leftLayerFrame
            leftLayer.contents = UIImage(named: imagesNames[0])?.cgImage
            leftLayer.name = PositionLayerName.leftLayer.rawValue
            leftLayer.transform = setLeft3DTransfrom()
            view.layer.addSublayer(leftLayer)
            
            let centerLayer = CALayer()
            centerLayer.frame = centerLayerFrame
            centerLayer.contents = UIImage(named: imagesNames[1])?.cgImage
            centerLayer.name = PositionLayerName.centerLayer.rawValue
            view.layer.addSublayer(centerLayer)
            
            let rightLayer = CALayer()
            rightLayer.frame = rightLayerFrame
            rightLayer.contents = UIImage(named: imagesNames[2])?.cgImage
            rightLayer.name = PositionLayerName.rightLayer.rawValue
            rightLayer.transform = setRight3DTransform()
            view.layer.addSublayer(rightLayer)
            
            let rightOutsideLayer = CALayer()
            rightOutsideLayer.frame = rightOutsideLayerFrame
            rightOutsideLayer.contents = UIImage(named: imagesNames[3])?.cgImage
            rightOutsideLayer.name = PositionLayerName.rightOutsideLayer.rawValue
            rightOutsideLayer.transform = setRight3DTransform()
            view.layer.addSublayer(rightOutsideLayer)
        }
    }
    
    private func moveCoverFlow(_ hitLayer: CALayer) {
            if hitLayer.contents == nil { return }
            if let name = hitLayer.name {
                if name == PositionLayerName.leftLayer.rawValue {
                    if let sublayers = view.layer.sublayers {
                        centerImageID -= 1
                        for layer in sublayers {
                            if layer.name == PositionLayerName.centerLayer.rawValue {
                                layer.name = PositionLayerName.rightLayer.rawValue
                                performAnimationWithTransactionDuration(0.5) {
                                    layer.transform = setRight3DTransform()
                                    layer.frame = rightLayerFrame
                                }
                                continue
                            }
                            if layer.name == PositionLayerName.rightLayer.rawValue {
                                layer.name = PositionLayerName.rightOutsideLayer.rawValue
                                performAnimationWithTransactionDuration(0.5) {
                                    layer.frame = rightOutsideLayerFrame
                                }
                                continue
                            }
                            if layer.name == PositionLayerName.rightOutsideLayer.rawValue {
                                layer.name = PositionLayerName.leftOutsideLayer.rawValue
                                performWithoutAnimation() {
                                    layer.frame = leftOutsideLayerFrame
                                    layer.transform = setLeft3DTransfrom()
                                }
                                if centerImageID < 2 {
                                    layer.contents = nil
                                } else {
                                    layer.contents = UIImage(named: imagesNames[centerImageID - 2])?.cgImage
                                }
                                continue
                            }
                            if layer.name == PositionLayerName.leftOutsideLayer.rawValue {
                                layer.name = PositionLayerName.leftLayer.rawValue
                                performAnimationWithTransactionDuration(0.5) {
                                    layer.frame = leftLayerFrame
                                }
                                continue
                            }
                        }
                    }
                    hitLayer.name = PositionLayerName.centerLayer.rawValue
                    performAnimationWithTransactionDuration(0.5) {
                        hitLayer.frame = centerLayerFrame
                        hitLayer.transform = delete3Dtransform()
                    }
                    
                }
                if name == PositionLayerName.rightLayer.rawValue {
                    centerImageID += 1
                    //if hitLayer == nil { return }
                    if let sublayers = view.layer.sublayers {
                        for layer in sublayers {
                            if layer.name == PositionLayerName.centerLayer.rawValue {
                                layer.name = PositionLayerName.leftLayer.rawValue
                                performAnimationWithTransactionDuration(0.5) {
                                    layer.frame = leftLayerFrame
                                    layer.transform = setLeft3DTransfrom()
                                }
                                continue
                            }
                            if layer.name == PositionLayerName.leftLayer.rawValue {
                                layer.name = PositionLayerName.leftOutsideLayer.rawValue
                                performAnimationWithTransactionDuration(0.5) {
                                    layer.frame = leftOutsideLayerFrame
                                }
                                continue
                            }
                            if layer.name == PositionLayerName.leftOutsideLayer.rawValue {
                                layer.name = PositionLayerName.rightOutsideLayer.rawValue
                                performWithoutAnimation() {
                                    layer.frame = rightOutsideLayerFrame
                                    layer.transform = setRight3DTransform()
                                }
                                if centerImageID  + 2 >= imagesNames.count {
                                    layer.contents = nil
                                } else {
                                    layer.contents = UIImage(named: imagesNames[centerImageID + 2])?.cgImage
                                }
                                continue
                            }
                            if layer.name == PositionLayerName.rightOutsideLayer.rawValue {
                                layer.name = PositionLayerName.rightLayer.rawValue
                                performAnimationWithTransactionDuration(0.5) {
                                    layer.frame = rightLayerFrame
                                }
                                continue
                            }
                        }
                    }
                    hitLayer.name = PositionLayerName.centerLayer.rawValue
                    performAnimationWithTransactionDuration(0.5) {
                        hitLayer.frame = centerLayerFrame
                        hitLayer.transform = delete3Dtransform()
                    }
                }
            }
    }
    
    private func prepeareCoverLayersSize() {
        
        let coverSideSize: CGFloat = (view.frame.width / 3)
        
        leftOutsideLayerFrame = CGRect(x: -coverSideSize,
                                       y: view.center.y - coverSideSize / 2,
                                       width: coverSideSize,
                                       height: coverSideSize)
        leftLayerFrame = CGRect(x: 0,
                                y: view.center.y - coverSideSize / 2,
                                width: coverSideSize,
                                height: coverSideSize)
        centerLayerFrame = CGRect(x: coverSideSize - coverSideSize / 4,
                                  y: view.center.y - coverSideSize * 1.5 / 2,
                                  width: coverSideSize * 1.5,
                                  height: coverSideSize * 1.5)
        rightLayerFrame = CGRect(x: coverSideSize * 2,
                                 y: view.center.y - coverSideSize / 2,
                                 width: coverSideSize,
                                 height: coverSideSize)
        rightOutsideLayerFrame = CGRect(x: view.frame.width + coverSideSize,
                                        y: view.center.y - coverSideSize / 2,
                                        width:  coverSideSize,
                                        height: coverSideSize)
    }
    
    private func setLeft3DTransfrom() -> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500
        transform = CATransform3DRotate(transform, 45 * CGFloat.pi / 180, 0, 1, 0)
        return transform
    }
    
    private func setRight3DTransform() -> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = -1 / 500
        transform = CATransform3DRotate(transform, -45 * CGFloat.pi / 180, 0, 1, 0)
        return transform
    }
    
    private func delete3Dtransform() -> CATransform3D{
        CATransform3DIdentity
    }
    
    private func performWithoutAnimation(_ actionWithoutAnimation: () -> Void) {
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actionWithoutAnimation()
        CATransaction.commit()
    }
    
    private func performAnimationWithTransactionDuration(_ duration: CFTimeInterval,_ actionWithDuration: () -> Void) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(duration)
        actionWithDuration()
        CATransaction.commit()
    }
    
    private enum PositionLayerName: String {
        case leftOutsideLayer = "LeftOutsideLayer"
        case leftLayer = "LeftLayer"
        case centerLayer = "CenterLayer"
        case rightLayer = "RigthLayer"
        case rightOutsideLayer = "RightOutsidrLayer"
    }
}

