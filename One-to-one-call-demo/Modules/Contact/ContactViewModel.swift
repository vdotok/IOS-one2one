//  
//  ContactViewModel.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 09/06/2021.
//  Copyright © 2021 VDOTOK. All rights reserved.
//

import Foundation
import iOSSDKStreaming
import UIKit

typealias ContactViewModelOutput = (ContactViewModelImpl.Output) -> Void

protocol ContactViewModelInput {
    func moveToAudio(with users: [User])
    func moveToVideo(with users: [User])
    func moveToIncoming()
    func closeConnection()
}

protocol ContactViewModel: ContactViewModelInput {
    var output: ContactViewModelOutput? { get set}
    var contacts: [User] {get set}
    var searchContacts: [User] {get set}
    var isSearching: Bool {get set}
   
    func viewModelDidLoad()
    func viewModelWillAppear()
    func rowsCount() -> Int
    func viewModelItem(row: Int) -> User
    func filterGroups(with text: String)
}

class ContactViewModelImpl: ContactViewModel, ContactViewModelInput {
    
    var isSearching: Bool = false
    var contacts: [User] = []
    var searchContacts: [User] = []
    var vtokSdk: VTokSDK?
    
    private let router: ContactRouter
    private let allUserStoreAble: AllUserStoreAble = AllUsersService(service: NetworkService())
    var output: ContactViewModelOutput?
    
    init(router: ContactRouter) {
        self.router = router
       
    }
    
    func viewModelDidLoad() {
        getUsers()
        configureVdotTok()
    }
    
    func viewModelWillAppear() {
        
    }

    
    //For all of your viewBindings
    enum Output {
        case reload
        case showProgress
        case hideProgress
        case socketConnected
        case socketDisconnected
        case failure(message: String)
        case alreadyCreated(message : String)
    }
    
    func configureVdotTok() {
        
        guard let user = VDOTOKObject<UserResponse>().getData() else {return}
        let request = RegisterRequest(type: Constants.Request,
                                      requestType: Constants.Register,
                                      referenceID: user.refID!,
                                      authorizationToken: user.authorizationToken!,
                                      requestID: getRequestId(),
                                      projectID: AuthenticationConstants.PROJECTID)
        self.vtokSdk = VTokSDK(url: user.mediaServerMap.completeAddress, registerRequest: request, connectionDelegate: self, peerName: "")
        
    }
    
    func getRequestId() -> String {
        let generatable = IdGenerator()
        guard let response = VDOTOKObject<UserResponse>().getData() else {return ""}
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = Date(timeIntervalSince1970: TimeInterval(myTimeInterval)).stringValue()
        let tenantId = "12345"
        let token = generatable.getUUID(string: time + tenantId + response.refID!)
        return token
        
    }
}

extension ContactViewModelImpl {
    
    func viewModelItem(row: Int) -> User {
        return isSearching ? searchContacts[row] : contacts[row]
    }
    
    func rowsCount() -> Int {
        return isSearching ? searchContacts.count : contacts.count
    }
    
    private func getUsers() {
        let request = AllUserRequest()
        output?(.showProgress)
        allUserStoreAble.fetchUsers(with: request) { [weak self] (result) in
            guard let self = self else {return}
            self.output?(.hideProgress)
            switch result {
            case .success(let response):
                switch  response.status {
                case 503:
                    self.output?(.failure(message: response.message ))
                case 500:
                    self.output?(.failure(message: response.message))
                case 401:
                    self.output?(.failure(message: response.message))
                case 200:
                    self.contacts = response.users
                    self.searchContacts = self.contacts
                    DispatchQueue.main.async {
                        self.output?(.reload)
                    }
                    
                default:
                    break
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func filterGroups(with text: String) {
        self.searchContacts = contacts.filter({$0.fullName.lowercased().prefix(text.count) == text.lowercased()})
        output?(.reload)
    }

}

extension ContactViewModelImpl: SDKConnectionDelegate {
    
    func didGenerate(output: SDKOutPut) {
        switch output {
        case .registered:
            self.output?(.socketConnected)
        case .disconnected(_):
            self.output?(.socketDisconnected)
        case .sessionRequest(let request):
            guard let sdk = vtokSdk else {return}
            let users = contacts.filter({$0.refID == request.to.first})
            router.incomingCall(vtokSdk: sdk, sessionRequest: request, users: users)
        }
    }
    
}

extension ContactViewModelImpl {
    func moveToAudio(with users: [User]) {
        guard let sdk = vtokSdk else {return}
        router.moveToAudio(vtokSdk: sdk, users: users)
    }
    
    func moveToVideo(with users: [User]) {
        guard let sdk = vtokSdk else {return}
        router.moveToVideo(vtokSdk: sdk, users: users)
    }
    
    func moveToIncoming() {
    }
    
    func closeConnection() {
        vtokSdk?.closeConnection()
    }
}

extension ContactViewModelImpl {

}
