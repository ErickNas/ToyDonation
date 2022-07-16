//
//  ToysTableViewController.swift
//  ToyDonation
//
//  Created by Erick on 16/07/22.
//

import UIKit
import FirebaseFirestore

class ToysTableViewController: UITableViewController {
    let collection = "toyDonation"
    var toyList: [ToyItem] = []
    lazy var firestore: Firestore = {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        let firestore = Firestore.firestore()
        firestore.settings = settings
        return firestore
    }()
    
    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadToyList()
    }

    // MARK: - Table view data source
    func loadToyList(){
        listener = firestore.collection(collection).order(by: "toyName", descending: false).addSnapshotListener(includeMetadataChanges: true, listener: { snapshot, error in
            if let error = error { print(error) } else {
                guard let snapshot = snapshot else { return }
                print("Total de documentos alterados: \(snapshot.documentChanges.count)")
                if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                    self.showItemsFrom(snapshot)
                }
            }
        })
    }
    
    func showItemsFrom(_ snapshot: QuerySnapshot){
        toyList.removeAll()
        for document in snapshot.documents {
            let data = document.data()
            if let toyName = data["toyName"] as? String,
               let donatorName = data["donatorName"] as? String,
               let address = data["address"] as? String,
               let phoneNumber = data["phoneNumber"] as? String,
               let toyState = data["toyState"] as? Int {
                let toyItem = ToyItem(id: document.documentID, toyName: toyName, donatorName: donatorName, address: address, phoneNumber: phoneNumber, toyState: toyState)
                toyList.append(toyItem)
            }
        }
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toyList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let toyItem = toyList[indexPath.row]
        cell.textLabel?.text = toyItem.toyName
        cell.detailTextLabel?.text = toyItem.condition

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let toyFormViewController = segue.destination as? ToyFormViewController {
            toyFormViewController.firestore = firestore
            if let row = tableView.indexPathForSelectedRow?.row {
                toyFormViewController.toy = toyList[row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toy = toyList[indexPath.row]
            firestore.collection(collection).document(toy.id).delete()
        }
    }

}
