//  
//  ContactRouter.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 09/06/2021.
//  Copyright © 2021 VDOTOK. All rights reserved.
//

import Foundation
import UIKit
import iOSSDKStreaming

class ContactRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}

extension ContactRouter {

    func moveToAudio(vtokSdk: VTokSDK, users: [User]) {
        let builder = CallingBuilder().build(with: self.navigationController, screenType: .audioView, vtokSdk: vtokSdk, users: users, sessionRequest: nil)
        builder.modalPresentationStyle = .fullScreen
        self.navigationController?.present(builder, animated: true, completion: nil)
    }
    
    func moveToVideo(vtokSdk: VTokSDK, users: [User]) {
        let builder = CallingBuilder().build(with: self.navigationController, screenType: .videoView, vtokSdk: vtokSdk, users: users, sessionRequest: nil)
        builder.modalPresentationStyle = .fullScreen
        self.navigationController?.present(builder, animated: true, completion: nil)
    }
    
    func incomingCall(vtokSdk: VTokSDK, sessionRequest: VTokBaseSession, users: [User]) {
        let builder = CallingBuilder().build(with: self.navigationController, screenType: .incomingCall, vtokSdk: vtokSdk, users: users, sessionRequest: sessionRequest)
        builder.modalPresentationStyle = .fullScreen
        self.navigationController?.present(builder, animated: true, completion: nil)
    }
}
