//  
//  QRScannerViewController.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 20/09/2022.
//  Copyright © 2022 VDOTOK. All rights reserved.
//

import UIKit
import AVFoundation

public class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    var viewModel: QRScannerViewModel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        bindViewModel()
        viewModel.viewModelDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewModelWillAppear()
        if (captureSession?.isRunning == false) {
                  captureSession.startRunning()
              }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
                   captureSession.stopRunning()
               }
    }
    
    fileprivate func bindViewModel() {

        viewModel.output = { [unowned self] output in
            //handle all your bindings here
            switch output {
            default:
                break
            }
        }
    }
}

extension QRScannerViewController {
    func configureAppearance() {
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)
        DispatchQueue.global().async {
            self.captureSession.startRunning()
        }
        
        
    }
    
    func failed() {
         let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
         ac.addAction(UIAlertAction(title: "OK", style: .default))
         present(ac, animated: true)
         captureSession = nil
     }
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
          captureSession.stopRunning()

          if let metadataObject = metadataObjects.first {
              guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
              guard let stringValue = readableObject.stringValue else { return }
              AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
              found(code: stringValue)
          }

          dismiss(animated: true)
        
      }

    func found(code: String) {
        let data = code.data(using: .utf8)!
        do {
            let model  = try JSONDecoder().decode(AuthenticationModel.self, from: data)
            UserDefaults.baseUrl = model.tenantApiUrl
            UserDefaults.projectId = model.projectId
            AuthenticationConstants.TENANTSERVER = model.tenantApiUrl
            AuthenticationConstants.PROJECTID = model.projectId
        } catch (let error) {
            print(error)
        }
        
        print(code)
    }

    public override var prefersStatusBarHidden: Bool {
          return true
      }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
          return .portrait
      }
}
