//
//  View.swift
//  CryptoViperApp
//
//  Created by Furkan Cingöz on 12.11.2023.
//

import Foundation
import UIKit

//MARK: TO DO LIST
//Talks to -> Presenter
//Class, protocol
//Viewcontroler


protocol AnyView {
  var presenter : AnyPresenter? {get set}
  func update(wtih cryptos:[Crypto])
  func update(with error: String)
}


class CryptoViewController : UIViewController, AnyView, UITableViewDelegate, UITableViewDataSource{
  var presenter: AnyPresenter?
  var cryptos : [Crypto] = []
  private let tableView : UITableView = {
    let table = UITableView()
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    table.isHidden = true
    return table
  }()

  private let messageLabel : UILabel = {
    let label = UILabel()
    label.isHidden = false
    label.text = "Downloading..."
    label.font = UIFont.systemFont(ofSize: 25)
    label.textColor = .white
    label.textAlignment = .center
    return label
  }()


  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(tableView)
    view.addSubview(messageLabel)
    tableView.delegate = self
    tableView.dataSource = self
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = view.bounds
    messageLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 25, width: 200, height: 50)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cryptos.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    var content = cell.defaultContentConfiguration()
    content.text = cryptos[indexPath.row].currency
    content.secondaryText = cryptos[indexPath.row].price
    cell.contentConfiguration = content
    cell.backgroundColor = .white

    return cell
  }

  func update(wtih cryptos: [Crypto]) {
    DispatchQueue.main.async {
      self.cryptos = cryptos
      self.messageLabel.isHidden = true
      self.tableView.reloadData()
      self.tableView.isHidden = false
    }
  }

  func update(with error: String) {
    DispatchQueue.main.async {
      self.cryptos = []
      self.tableView.isHidden = true
      self.messageLabel.text = "Error"
      self.messageLabel.isHidden = false
    }
  }



}
