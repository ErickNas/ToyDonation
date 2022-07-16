//
//  ToyFormViewController.swift
//  ToyDonation
//
//  Created by Erick on 16/07/22.
//

import UIKit
import FirebaseFirestore

class ToyFormViewController: UIViewController {
    @IBOutlet weak var textFieldToyName: UITextField!
    @IBOutlet weak var textFieldDonatorName: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var segmentedControlToyState: UISegmentedControl!
    @IBOutlet weak var buttonAddEdit: UIButton!
    
    var toy: ToyItem?
    let collection = "toyDonation"
    var firestore: Firestore?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let toy = toy {
            title = "Detalhes/Edição"
            textFieldToyName.text = toy.toyName
            textFieldDonatorName.text = toy.donatorName
            textFieldAddress.text = toy.address
            textFieldPhoneNumber.text = toy.phoneNumber
            segmentedControlToyState.selectedSegmentIndex = toy.toyState
            buttonAddEdit.setTitle("Alterar", for: .normal)
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        guard let toyName = textFieldToyName.text else { return }
        guard let donatorName = textFieldDonatorName.text else { return }
        guard let address = textFieldAddress.text else { return }
        guard let phoneNumber = textFieldPhoneNumber.text else { return }
        let toyState = segmentedControlToyState.selectedSegmentIndex
        
        let data: [String: Any] = [
            "toyName": toyName,
            "donatorName": donatorName,
            "address": address,
            "phoneNumber": phoneNumber,
            "toyState": toyState
        ]
        
        if let toy = toy {
            firestore?.collection(self.collection).document(toy.id).updateData(data)
        } else {
            firestore?.collection(self.collection).addDocument(data: data)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
