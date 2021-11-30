//  
//  SignUpBuilder.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 08/06/2021.
//  Copyright © 2021 VDOTOK. All rights reserved.
//

import Foundation
import UIKit

class SignUpBuilder {

    func build(with navigationController: UINavigationController?) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "SignUp", bundle: Bundle(for: SignUpBuilder.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        let coordinator = SignUpRouter(navigationController: navigationController)
        let viewModel = SignUpViewModelImpl(router: coordinator)

        viewController.viewModel = viewModel
        
        return viewController
    }
}


