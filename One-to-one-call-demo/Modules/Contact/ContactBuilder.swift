//  
//  ContactBuilder.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 09/06/2021.
//  Copyright © 2021 VDOTOK. All rights reserved.
//

import Foundation
import UIKit

class ContactBuilder {

    func build(with navigationController: UINavigationController?) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Contact", bundle: Bundle(for: ContactBuilder.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "ContactViewController") as! ContactViewController
        let coordinator = ContactRouter(navigationController: navigationController)
        let viewModel = ContactViewModelImpl(router: coordinator)

        viewController.viewModel = viewModel
        
        return viewController
    }
}


