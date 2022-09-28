//  
//  QRScannerBuilder.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 20/09/2022.
//  Copyright © 2022 VDOTOK. All rights reserved.
//

import Foundation
import UIKit

class QRScannerBuilder {

    func build(with navigationController: UINavigationController?) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "QRScanner", bundle: Bundle(for: QRScannerBuilder.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "QRScannerViewController") as! QRScannerViewController
        let coordinator = QRScannerRouter(navigationController: navigationController)
        let viewModel = QRScannerViewModelImpl(router: coordinator)

        viewController.viewModel = viewModel
        
        return viewController
    }
}


