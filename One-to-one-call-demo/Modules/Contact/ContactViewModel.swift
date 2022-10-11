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
    func makeCall(with users:[User], mediaType: SessionMediaType)
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
    private let localPort = 14135
    lazy var client: StunClient = {
        
        let resultsCallback: (NatTypeResult) -> () = { [weak self] (result) in
            guard let self = self else {return}
            print("NatType Results: \n\(result)")
            let publicAddress1 = result.aaAddressMapping.ipAddress + ":" + "\(result.aaAddressMapping.port)"
            let publicAddress2 = result.mappedIPAndPort.ipAddress + ":" + "\(result.aaAddressMapping.port)"
            let publicAddress3 = result.apAddressMapping.ipAddress + ":" + "\(result.apAddressMapping.port)"
            let publicAddresses = publicAddress1 + "," + publicAddress2 + "," + publicAddress3
            let publicAddress:[String: String] = ["publicIP": publicAddresses]
            let natFiltering = result.natFilteringType
            let natBehaviorType = result.natBehaviorType
            guard let user = VDOTOKObject<UserResponse>().getData(), let url = user.mediaServerMap?.completeAddress else {return}
            let request = RegisterRequest(type: Constants.Request,
                                          requestType: Constants.Register,
                                          referenceID: user.refID!,
                                          authorizationToken: user.authorizationToken!,
                                          requestID: self.getRequestId(),
                                          projectID: UserDefaults.projectId, natFiltering: natFiltering.rawValue,
                                          natBehavior: natBehaviorType.rawValue,
                                        publicIP: publicAddress)
            
            self.configureVdotTok(request: request)
        }
        
        let successCallback: (String, Int) -> () = { [weak self] (myAddress: String, myPort: Int) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                print("ABC" + "\n\n" + "COMPLETED, my address: " + myAddress + " my port: " + String(myPort))
            }
        }
            let errorCallback: (StunError) -> () = { [weak self] error in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        print("ERROR: " + error.errorDescription)
                    }
                }
            let verboseCallback: (String) -> () = { [weak self] logText in
                    DispatchQueue.main.async {
                        guard let self = self else { return }
                        print(logText)
                    }
                }
            //18.219.110.18
            //stun.stunprotocol.org
            return StunClient(stunIpAddress: "18.219.110.18", stunPort: 3478 , localPort: UInt16(localPort), timeoutInMilliseconds: 500)
                .discoverNatType()
                .ifNatTypeDetectingSuccessful(resultsCallback)
                .ifWhoAmISuccessful(successCallback)
                .ifError(errorCallback)
                .verbose(verboseCallback)
            //discoverNatType()

        }()
    
    init(router: ContactRouter) {
        self.router = router
       
    }
    
    func viewModelDidLoad() {
        getUsers()
        AVCaptureDevice.requestAccess(for: .video) { _ in}
        AVCaptureDevice.requestAccess(for: .audio) { _ in}
        checkAppState()
        client.start()
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
        case authFailure(message: String)
    }
    
    func configureVdotTok(request: RegisterRequest) {
        
        guard let user = VDOTOKObject<UserResponse>().getData(), let url = user.mediaServerMap?.completeAddress else {return}
        self.vtokSdk = VTokSDK(url: url, registerRequest: request, connectionDelegate: self)
        
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
    
    func checkAppState() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    @objc func appDidBecomeActive() {
        guard let sdk = vtokSdk else {return}
        sdk.reRegisterSocket()
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

    func makeCall(with users: [User], mediaType: SessionMediaType) {
        Common.isAuthorized { status in
            if status {
                guard let sdk = vtokSdk else {return}
                switch mediaType {
                case .audioCall:
                    router.moveToAudio(vtokSdk: sdk, users: users)
                case .videoCall:
                    router.moveToVideo(vtokSdk: sdk, users: users)
                }
                return
            }
            let message = "To place calls, VDOTOK needs access to your iPhone's microphone and camara. Tap Settings and turn on microphone and camera."
            output?(.authFailure(message: message))
        }
    
    }
    
    func closeConnection() {
        vtokSdk?.closeConnection()
    }
}

