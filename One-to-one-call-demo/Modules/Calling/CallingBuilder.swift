//  
//  CallingBuilder.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 09/06/2021.
//

import Foundation
import UIKit
import iOSSDKStreaming

enum ScreenType {
    case videoView
    case audioView
    case incomingCall
}

class CallingBuilder {

    func build(with navigationController: UINavigationController?, screenType: ScreenType, vtokSdk: VTokSDK, users: [User]?, sessionRequest: VTokBaseSession?) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Calling", bundle: Bundle(for: CallingBuilder.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "CallingViewController") as! CallingViewController
        let coordinator = CallingRouter(navigationController: navigationController)
        let viewModel = CallingViewModelImpl(router: coordinator, screenType: screenType, vtokSdk: vtokSdk, users: users, session: sessionRequest)

        viewController.viewModel = viewModel
        
        return viewController
    }
}


