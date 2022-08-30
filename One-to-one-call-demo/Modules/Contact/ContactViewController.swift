//  
//  ContactViewController.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 09/06/2021.
//  Copyright © 2021 VDOTOK. All rights reserved.
//

import UIKit
import iOSSDKStreaming

public class ContactViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var addGroup: UIButton!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var connectionStatusView: UIView! {
        didSet {
            connectionStatusView.layer.cornerRadius = connectionStatusView.frame.width/2
        }
    }
    let navigationTitle = UILabel()
    
    var viewModel: ContactViewModel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        bindViewModel()
        viewModel.viewModelDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewModelWillAppear()
    }
    
    
    @IBAction func didTapAddContact(_ sender: UIButton) {
    }
    
    @IBAction func logout() {
        UserDefaults.standard.removeObject(forKey: "UserResponse")
        let viewController = LoginBuilder().build(with: self.navigationController)
        viewController.modalPresentationStyle = .fullScreen
        viewModel.closeConnection()
        self.navigationController?.present(viewController, animated: true, completion: nil)
    }
    
    fileprivate func bindViewModel() {
        
        viewModel.output = { [unowned self] output in
            //handle all your bindings here
            switch output {
            case .showProgress:
                ProgressHud.show(viewController: self)
            case .hideProgress:
                ProgressHud.hide()
            case .failure(message: let message):
                DispatchQueue.main.async {
                    ProgressHud.showError(message: message, viewController: self)
                }
            case .reload:
                tableView.reloadData()
            case .socketConnected:
                connectionStatusView.backgroundColor = .green
            case .socketDisconnected:
                connectionStatusView.backgroundColor = .red
            case .authFailure(let message):
                ProgressHud.shared.alertForPermission(message: message)
            default:
                break
            }
        }
    }
}

extension ContactViewController {
    func configureAppearance() {
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        separatorView.backgroundColor = .appTileGreenColor
        contactLabel.font = UIFont(name: "Manrope-Medium", size: 16)
        contactLabel.textColor = .appDarkColor
        navigationTitle.text = "Contact List"
        navigationTitle.font = UIFont(name: "Manrope-Medium", size: 20)
        navigationTitle.textColor = .appDarkGreenColor
        navigationTitle.sizeToFit()
        let leftItem = UIBarButtonItem(customView: navigationTitle)
        self.navigationItem.leftBarButtonItems = [leftItem]
        registerCell()
        guard let user = VDOTOKObject<UserResponse>().getData() else {return}
        userName.text = user.fullName
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "ContactCell")
    }
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTappedAdd() {
        navigationController?.popViewController(animated: true)
    }
}

extension ContactViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowsCount()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        cell.selectionStyle = .none
        cell.configure(with: viewModel.viewModelItem(row: indexPath.row), delegate: self)
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSection: Int = 0
        if viewModel.searchContacts.count > 0 {
            self.tableView.backgroundView = nil
            numOfSection = 1
        }
        else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
            noDataLabel.text = "No User Found"
            noDataLabel.textColor = .appDarkColor
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = noDataLabel
        }
        
        return numOfSection
    }
}

extension ContactViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else {return}
        viewModel.isSearching = true
        viewModel.filterGroups(with: text)
        print(text)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension ContactViewController: ContactCellProtocol {
    func didTapVideo(user: User) {
        viewModel.makeCall(with: [user], mediaType: .videoCall)
    }
    
    func didTapAudio(user: User) {
        viewModel.makeCall(with: [user], mediaType: .audioCall)
    }

}
