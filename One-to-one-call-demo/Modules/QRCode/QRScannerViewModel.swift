//  
//  QRScannerViewModel.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 20/09/2022.
//  Copyright © 2022 VDOTOK. All rights reserved.
//

import Foundation

typealias QRScannerViewModelOutput = (QRScannerViewModelImpl.Output) -> Void

protocol QRScannerViewModelInput {
    
}

protocol QRScannerViewModel: QRScannerViewModelInput {
    var output: QRScannerViewModelOutput? { get set}
    
    func viewModelDidLoad()
    func viewModelWillAppear()
}

class QRScannerViewModelImpl: QRScannerViewModel, QRScannerViewModelInput {

    private let router: QRScannerRouter
    var output: QRScannerViewModelOutput?
    
    init(router: QRScannerRouter) {
        self.router = router
    }
    
    func viewModelDidLoad() {
        
    }
    
    func viewModelWillAppear() {
        
    }
    
    //For all of your viewBindings
    enum Output {
        
    }
}

extension QRScannerViewModelImpl {

}
